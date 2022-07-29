From: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-5.20] cgroup: Replace cgroup->ancestor_ids[]
 with ->ancestors[]
Date: Fri, 29 Jul 2022 13:30:29 -0700
Message-ID: <CAM9d7cgrpORPW_jYAa-Xopw3+im1SPiR3O0omh-v0Odd7YGxGA@mail.gmail.com>
References: <YuQvcCrcgNWbtndU@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YuQvcCrcgNWbtndU-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>

Hi Tejun,

On Fri, Jul 29, 2022 at 12:06 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Every cgroup knows all its ancestors through its ->ancestor_ids[]. While all
> the existing users only need the IDs, there's no advantage to remembering
> the IDs instead of the pointers directly. Let's replace
> cgroup->ancestor_ids[] with ->ancestors[] so that it's easy to access non-ID
> ancestor fields.
>
> This patch shouldn't cause any behavior differences.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> Namhyung, I think the change in bperf_cgroup is correct but couldn't figure
> out how to test it (normal perf build wouldn't compile it). Can you please
> see whether it's correct?

Looks ok to me.  For the perf part,

Acked-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Note that you need to pass BUILD_BPF_SKEL=1 when you build perf
to enable BPF stuff.  IIRC Arnaldo will make it default at some point.

Thanks,
Namhyung

>
> Thanks.
>
>  include/linux/cgroup-defs.h                 |   10 +++++-----
>  include/linux/cgroup.h                      |    2 +-
>  kernel/cgroup/cgroup.c                      |    7 +++----
>  net/netfilter/nft_socket.c                  |    5 +++--
>  tools/perf/util/bpf_skel/bperf_cgroup.bpf.c |    2 +-
>  5 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> index 63bf43c7ca3b..51fa744c2e9d 100644
> --- a/include/linux/cgroup-defs.h
> +++ b/include/linux/cgroup-defs.h
> @@ -379,7 +379,7 @@ struct cgroup {
>         /*
>          * The depth this cgroup is at.  The root is at depth zero and each
>          * step down the hierarchy increments the level.  This along with
> -        * ancestor_ids[] can determine whether a given cgroup is a
> +        * ancestors[] can determine whether a given cgroup is a
>          * descendant of another without traversing the hierarchy.
>          */
>         int level;
> @@ -499,8 +499,8 @@ struct cgroup {
>         /* Used to store internal freezer state */
>         struct cgroup_freezer_state freezer;
>
> -       /* ids of the ancestors at each level including self */
> -       u64 ancestor_ids[];
> +       /* All ancestors including self */
> +       struct cgroup *ancestors[];
>  };
>
>  /*
> @@ -520,8 +520,8 @@ struct cgroup_root {
>         /* The root cgroup.  Root is destroyed on its release. */
>         struct cgroup cgrp;
>
> -       /* for cgrp->ancestor_ids[0] */
> -       u64 cgrp_ancestor_id_storage;
> +       /* for cgrp->ancestors[0] */
> +       u64 cgrp_ancestor_storage;
>
>         /* Number of cgroups in the hierarchy, used only for /proc/cgroups */
>         atomic_t nr_cgrps;
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index ed53bfe7c46c..5334b6134399 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -574,7 +574,7 @@ static inline bool cgroup_is_descendant(struct cgroup *cgrp,
>  {
>         if (cgrp->root != ancestor->root || cgrp->level < ancestor->level)
>                 return false;
> -       return cgrp->ancestor_ids[ancestor->level] == cgroup_id(ancestor);
> +       return cgrp->ancestors[ancestor->level] == ancestor;
>  }
>
>  /**
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 85fa4c8587a8..ce587fe43dab 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -2047,7 +2047,7 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
>         }
>         root_cgrp->kn = kernfs_root_to_node(root->kf_root);
>         WARN_ON_ONCE(cgroup_ino(root_cgrp) != 1);
> -       root_cgrp->ancestor_ids[0] = cgroup_id(root_cgrp);
> +       root_cgrp->ancestors[0] = root_cgrp;
>
>         ret = css_populate_dir(&root_cgrp->self);
>         if (ret)
> @@ -5391,8 +5391,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
>         int ret;
>
>         /* allocate the cgroup and its ID, 0 is reserved for the root */
> -       cgrp = kzalloc(struct_size(cgrp, ancestor_ids, (level + 1)),
> -                      GFP_KERNEL);
> +       cgrp = kzalloc(struct_size(cgrp, ancestors, (level + 1)), GFP_KERNEL);
>         if (!cgrp)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -5444,7 +5443,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
>
>         spin_lock_irq(&css_set_lock);
>         for (tcgrp = cgrp; tcgrp; tcgrp = cgroup_parent(tcgrp)) {
> -               cgrp->ancestor_ids[tcgrp->level] = cgroup_id(tcgrp);
> +               cgrp->ancestors[tcgrp->level] = tcgrp;
>
>                 if (tcgrp != cgrp) {
>                         tcgrp->nr_descendants++;
> diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
> index 05ae5a338b6f..d64784d4bd02 100644
> --- a/net/netfilter/nft_socket.c
> +++ b/net/netfilter/nft_socket.c
> @@ -40,6 +40,7 @@ static noinline bool
>  nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo *pkt, u32 level)
>  {
>         struct cgroup *cgrp;
> +       u64 cgid;
>
>         if (!sk_fullsock(sk))
>                 return false;
> @@ -48,8 +49,8 @@ nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo
>         if (level > cgrp->level)
>                 return false;
>
> -       memcpy(dest, &cgrp->ancestor_ids[level], sizeof(u64));
> -
> +       cgid = cgroup_id(cgrp->ancestors[level]);
> +       memcpy(dest, &cgid, sizeof(u64));
>         return true;
>  }
>  #endif
> diff --git a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
> index 292c430768b5..bd6a420acc8f 100644
> --- a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
> +++ b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
> @@ -68,7 +68,7 @@ static inline int get_cgroup_v1_idx(__u32 *cgrps, int size)
>                         break;
>
>                 // convert cgroup-id to a map index
> -               cgrp_id = BPF_CORE_READ(cgrp, ancestor_ids[i]);
> +               cgrp_id = BPF_CORE_READ(cgrp, ancestors[i], kn, id);
>                 elem = bpf_map_lookup_elem(&cgrp_idx, &cgrp_id);
>                 if (!elem)
>                         continue;
