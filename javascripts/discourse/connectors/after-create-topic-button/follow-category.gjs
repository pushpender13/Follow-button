/* eslint-disable ember/no-classic-components */
import Component from "@ember/component";
import { tagName } from "@ember-decorators/component";
import SimpleFollowButton from "../../components/simple-follow-button";

@tagName("")
export default class FollowCategory extends Component {
  <template><SimpleFollowButton @category={{this.category}} /></template>
}
