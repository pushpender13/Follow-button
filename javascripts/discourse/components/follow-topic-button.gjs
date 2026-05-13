import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import { NotificationLevels } from "discourse/lib/notification-levels";
import Composer from "discourse/models/composer";

export default class FollowTopicButton extends Component {
  @service currentUser;
  @service composer;
  @tracked isLoading = false;

  get topic() {
    return this.args.topic ?? this.args.outletArgs?.topic;
  }

  get isFollowing() {
    return this.topic?.details?.notification_level === NotificationLevels.WATCHING;
  }

  @action
  async toggleFollow() {
    if (!this.topic || this.isLoading) {
      return;
    }

    this.isLoading = true;
    try {
      const targetLevel = this.isFollowing
        ? NotificationLevels.REGULAR
        : NotificationLevels.WATCHING;

      await this.topic.details.updateNotificationLevel(targetLevel);
    } finally {
      this.isLoading = false;
    }
  }

  @action
  reply() {
    if (!this.topic) {
      return;
    }

    this.composer.open({
      action: Composer.REPLY,
      topic: this.topic,
      draftKey: this.topic.draft_key,
    });
  }

  <template>
    {{#if this.topic}}
      <div class="follow-topic-actions">
        <DButton
          @action={{this.toggleFollow}}
          @icon={{if this.isFollowing "bell-slash" "bell"}}
          @translatedLabel={{if this.isFollowing "Unfollow" "Follow"}}
          @disabled={{this.isLoading}}
          class={{if
            this.isFollowing
            "follow-topic-btn btn-primary following"
            "follow-topic-btn btn-default"
          }}
        />
        <DButton
          @action={{this.reply}}
          @icon="reply"
          @translatedLabel="Reply"
          class="reply-topic-btn btn-default"
        />
      </div>
    {{/if}}
  </template>
}
