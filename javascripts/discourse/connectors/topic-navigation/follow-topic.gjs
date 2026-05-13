import Component from "@glimmer/component";
import FollowTopicButton from "../../components/follow-topic-button";

export default class FollowTopic extends Component {
  <template>
    <FollowTopicButton @topic={{@outletArgs.topic}} />
  </template>
}
