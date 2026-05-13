import Component from "@glimmer/component";
import SimpleFollowButton from "../../components/simple-follow-button";

export default class FollowCategory extends Component {
  <template>
    <SimpleFollowButton @category={{@outletArgs.category}} />
  </template>
}
