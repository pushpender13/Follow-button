import FollowCategoryButton from "../../components/follow-category-button";
import FollowTagButton from "../../components/follow-tag-button";

<template>
  {{#if @outletArgs.category}}
    <FollowCategoryButton @model={{@outletArgs.category}} />
  {{else if @outletArgs.tag}}
    <FollowTagButton @tag={{@outletArgs.tag}} />
  {{/if}}
</template>
