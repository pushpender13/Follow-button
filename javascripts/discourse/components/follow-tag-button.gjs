import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import { ajax } from "discourse/lib/ajax";
import { NotificationLevels } from "discourse/lib/notification-levels";
import { i18n } from "discourse-i18n";

export default class FollowTagButton extends Component {
  @service currentUser;
  @tracked notificationLevel = null;
  @tracked isLoading = false;

  constructor(owner, args) {
    super(owner, args);
    this.#loadNotificationLevel();
  }

  get tag() {
    return this.args.tag;
  }

  get isFollowing() {
    return this.notificationLevel === NotificationLevels.WATCHING;
  }

  async #loadNotificationLevel() {
    if (!this.tag?.name) {
      return;
    }
    try {
      const data = await ajax(`/tags/${this.tag.name}/notifications.json`);
      this.notificationLevel = data.tag_notification?.notification_level;
    } catch {
      // non-critical, leave null
    }
  }

  @action
  async toggleFollow() {
    if (!this.tag?.name || this.isLoading) {
      return;
    }

    this.isLoading = true;
    try {
      const targetLevel = this.isFollowing
        ? NotificationLevels.REGULAR
        : NotificationLevels.WATCHING;

      await ajax(`/tags/${this.tag.name}/notifications.json`, {
        type: "PUT",
        data: { tag_notification: { notification_level: targetLevel } },
      });

      this.notificationLevel = targetLevel;
    } finally {
      this.isLoading = false;
    }
  }

  <template>
    {{#if this.tag.name}}
      <DButton
        @action={{this.toggleFollow}}
        @icon={{if this.isFollowing "bell-slash" "bell"}}
        @translatedLabel={{if
          this.isFollowing
          (i18n (themePrefix "unfollow_category_button_title"))
          (i18n (themePrefix "follow_category_button_title"))
        }}
        @disabled={{this.isLoading}}
        class={{if
          this.isFollowing
          "follow-tag-button btn-primary following"
          "follow-tag-button btn-default"
        }}
      />
    {{/if}}
  </template>
}
