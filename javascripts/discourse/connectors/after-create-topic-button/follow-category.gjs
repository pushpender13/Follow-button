/* eslint-disable ember/no-classic-components */
import Component from "@ember/component";
import { tagName } from "@ember-decorators/component";
import FollowCategoryButton from "../../components/follow-category-button";
import FollowTagButton from "../../components/follow-tag-button";

@tagName("")
export default class FollowCategory extends Component {
  <template>
    {{#if this.category}}
      <FollowCategoryButton @model={{this.category}} />
    {{else if this.tag}}
      <FollowTagButton @tag={{this.tag}} />
    {{/if}}
  </template>
}
