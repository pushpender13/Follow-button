import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import { NotificationLevels } from "discourse/lib/notification-levels";
import { i18n } from "discourse-i18n";

export default class FollowCategoryButton extends Component {
  @service currentUser;
  @tracked isLoading = false;

  get isFollowing() {
    return (
      this.args.model?.get("notification_level") === NotificationLevels.WATCHING
    );
  }

  @action
  async toggleFollow() {
    if (!this.args.model || this.isLoading) {
      return;
    }

    this.isLoading = true;
    try {
      const targetLevel = this.isFollowing
        ? NotificationLevels.REGULAR
        : NotificationLevels.WATCHING;

      await this.args.model.setNotification(targetLevel);
    } finally {
      this.isLoading = false;
    }
  }

  <template>
    {{#if @model}}
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
          "follow-category-button btn-primary following"
          "follow-category-button btn-default"
        }}
      />
    {{/if}}
  </template>
}
