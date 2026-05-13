import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import { NotificationLevels } from "discourse/lib/notification-levels";
import { i18n } from "discourse-i18n";

export default class FollowTagButton extends Component {
  @service currentUser;
  @service store;
  @tracked tagNotification = null;
  @tracked isLoading = false;

  constructor(owner, args) {
    super(owner, args);
    this.#loadTagNotification();
  }

  get tag() {
    return this.args.tag;
  }

  get isFollowing() {
    return (
      this.tagNotification?.notification_level === NotificationLevels.WATCHING
    );
  }

  async #loadTagNotification() {
    if (!this.tag?.name || !this.currentUser) {
      return;
    }
    try {
      this.tagNotification = await this.store.find(
        "tagNotification",
        this.tag.name
      );
    } catch {
      // non-critical
    }
  }

  @action
  async toggleFollow() {
    if (!this.tag?.name || !this.tagNotification || this.isLoading) {
      return;
    }

    this.isLoading = true;
    try {
      const targetLevel = this.isFollowing
        ? NotificationLevels.REGULAR
        : NotificationLevels.WATCHING;

      const response = await this.tagNotification.update({
        notification_level: targetLevel,
      });

      this.tagNotification.set("notification_level", targetLevel);

      const payload = response.responseJson;
      if (payload) {
        this.currentUser.setProperties({
          watched_tags: payload.watched_tags,
          watching_first_post_tags: payload.watching_first_post_tags,
          tracked_tags: payload.tracked_tags,
          muted_tags: payload.muted_tags,
          regular_tags: payload.regular_tags,
        });
      }
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
