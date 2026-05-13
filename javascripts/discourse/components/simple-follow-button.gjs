import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import { NotificationLevels } from "discourse/lib/notification-levels";

export default class SimpleFollowButton extends Component {
  @service currentUser;
  @tracked isLoading = false;

  get notificationLevel() {
    return this.args.category?.notification_level ??
      this.args.category?.get?.("notification_level");
  }

  get isFollowing() {
    return this.notificationLevel === NotificationLevels.WATCHING;
  }

  @action
  async toggleFollow() {
    if (!this.args.category || this.isLoading) {
      return;
    }

    this.isLoading = true;
    try {
      const targetLevel = this.isFollowing
        ? NotificationLevels.REGULAR
        : NotificationLevels.WATCHING;

      await this.args.category.setNotification(targetLevel);
    } finally {
      this.isLoading = false;
    }
  }

  <template>
    {{#if @category}}
      <DButton
        @action={{this.toggleFollow}}
        @icon={{if this.isFollowing "bell-slash" "bell"}}
        @translatedLabel={{if this.isFollowing "Unfollow" "Follow"}}
        @disabled={{this.isLoading}}
        class={{if this.isFollowing "btn-primary follow-btn following" "btn-default follow-btn"}}
      />
    {{/if}}
  </template>
}
