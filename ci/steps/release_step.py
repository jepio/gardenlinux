import glci.model
import release

parsable_to_int = str


def release_step(
    giturl: str,
    committish: str,
    gardenlinux_epoch: parsable_to_int,
    publishing_actions: str,
):
    publishing_actions = [
        glci.model.PublishingAction(action.strip()) for action in publishing_actions.split(',')
    ]

    if not glci.model.PublishingAction.RELEASE in publishing_actions:
      print(f'{publishing_actions=} - will not perform release')
      return

    release.ensure_target_branch_exists(
        release_branch=release.release_branch_name(gardenlinux_epoch=gardenlinux_epoch),
        release_committish=committish,
        release_version=glci.model.next_release_version_from_workingtree(),
        git_helper=release._git_helper(giturl=giturl),
        giturl=giturl,
    )

if __name__ == '__main__':
    release_step(
        committish='229156b3c433a19d6e91cd6911d0f3b0b7fafc48',
        gardenlinux_epoch='576',
        giturl='ssh://git@github.com/gardenlinux/gardenlinux',
        publishing_actions='component_descriptor,images,manifests,release,release_candidate'
    )