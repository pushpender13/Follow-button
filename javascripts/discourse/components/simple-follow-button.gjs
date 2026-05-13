import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import { NotificationLevels } from "discourse/lib/notification-levels";

export default class SimpleFollowButton extends Component {
  @service currentUser;

  get isFollowing() {
    const level = this.args.category?.get("notification_level");
    return level && level > NotificationLevels.NORMAL;
  }

  @action
  toggleFollow() {
    if (this.isFollowing) {
      this.args.category?.setNotification(NotificationLevels.REGULAR);
    } else {
      this.args.category?.setNotification(NotificationLevels.WATCHING);
    }
  }

  <template>
    {{#if @category}}
      <DButton
        @action={{this.toggleFollow}}
        @icon="bell"
        @translatedLabel={{if this.isFollowing "Following" "Follow"}}
        class={{if this.isFollowing "btn-primary follow-btn following" "btn-default follow-btn"}}
      />
    {{/if}}
  </template>
}
