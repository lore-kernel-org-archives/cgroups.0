From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH 4/4] cgroup/bpf: Honor cgroup NS in cgroup_iter for ancestors
Date: Fri, 26 Aug 2022 10:41:37 -0700
Message-ID: <CAJD7tkZZ6j6mPfwwFDy_ModYux5447HFP=oPwa6MFA_NYAZ9-g@mail.gmail.com>
References: <20220826165238.30915-1-mkoutny@suse.com> <20220826165238.30915-5-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=he/bfvf1mDfynCT5CMERAlIneGT6+vfp7BBeASbZgO4=;
        b=KxEI28tPSvUdNvAkCqxed+rLWbEo5ARCEAFxCt3dpg9zrIvuE3hyl80F3lBx6u6qJ8
         R3H2BDEl5L7K+oGIDQ+GjK3+LxQch4naSX+wXjC37jJ8uPcV/nR7R/TpQnB1BwSld3zJ
         8A9o6uWd5OHoG6EhSrquWNsRUo+btk7LVQYEwB9wWyLHaMoMxohYIhDMTLJWnQc1wOIu
         5oAFiC+QxDuY95fL6yWs6rGPB3zd9X2TzZJMsdYhExNwR4VFmsnTXyA0+3vf81dhV4nc
         e6Yo3jfLObOFrEj8pqSkT2fdafWMy12nNaRl2jJm6z+Rm+/zknxKzE0IeiFATBFDDZX2
         lMxA==
In-Reply-To: <20220826165238.30915-5-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Aditya Kali <adityakali@google.com>, Serge Hallyn <serge.hallyn@canonical.com>, Roman Gushchin <roman.gushchin@linux.dev>, Yonghong Song <yhs@fb.com>, Muneendra Kumar <muneendra.kumar@broadcom.com>, Hao Luo <haoluo@google.com>

Hi there!

Thanks for following up with this series!

On Fri, Aug 26, 2022 at 9:53 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote=
:
>
> The iterator with BPF_CGROUP_ITER_ANCESTORS_UP can traverse up across a
> cgroup namespace level, which may be surprising within a non-init cgroup
> namespace.
>
> Introduce and use a new cgroup_parent_ns() helper that stops according
> to cgroup namespace boundary. With BPF_CGROUP_ITER_ANCESTORS_UP. We use
> the cgroup namespace of the iterator caller, not that one of the creator
> (might be different, the former is relevant).
>
> Fixes: d4ccaf58a847 ("bpf: Introduce cgroup iter")
> Signed-off-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> ---
>  include/linux/cgroup.h   |  3 +++
>  kernel/bpf/cgroup_iter.c |  9 ++++++---
>  kernel/cgroup/cgroup.c   | 32 +++++++++++++++++++++++---------
>  3 files changed, 32 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index b6a9528374a8..b63a80e03fae 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -858,6 +858,9 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long=
 flags,
>  int cgroup_path_ns(struct cgroup *cgrp, char *buf, size_t buflen,
>                    struct cgroup_namespace *ns);
>
> +struct cgroup *cgroup_parent_ns(struct cgroup *cgrp,
> +                               struct cgroup_namespace *ns);
> +
>  #else /* !CONFIG_CGROUPS */
>
>  static inline void free_cgroup_ns(struct cgroup_namespace *ns) { }
> diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
> index c69bce2f4403..06ee4a0c5870 100644
> --- a/kernel/bpf/cgroup_iter.c
> +++ b/kernel/bpf/cgroup_iter.c
> @@ -104,6 +104,7 @@ static void *cgroup_iter_seq_next(struct seq_file *se=
q, void *v, loff_t *pos)
>  {
>         struct cgroup_subsys_state *curr =3D (struct cgroup_subsys_state =
*)v;
>         struct cgroup_iter_priv *p =3D seq->private;
> +       struct cgroup *parent;
>
>         ++*pos;
>         if (p->terminate)
> @@ -113,9 +114,11 @@ static void *cgroup_iter_seq_next(struct seq_file *s=
eq, void *v, loff_t *pos)
>                 return css_next_descendant_pre(curr, p->start_css);
>         else if (p->order =3D=3D BPF_CGROUP_ITER_DESCENDANTS_POST)
>                 return css_next_descendant_post(curr, p->start_css);
> -       else if (p->order =3D=3D BPF_CGROUP_ITER_ANCESTORS_UP)
> -               return curr->parent;
> -       else  /* BPF_CGROUP_ITER_SELF_ONLY */
> +       else if (p->order =3D=3D BPF_CGROUP_ITER_ANCESTORS_UP) {
> +               parent =3D cgroup_parent_ns(curr->cgroup,
> +                                         current->nsproxy->cgroup_ns);
> +               return parent ? &parent->self : NULL;
> +       } else  /* BPF_CGROUP_ITER_SELF_ONLY */
>                 return NULL;
>  }
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index c0377726031f..d60b5dfbbbc9 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -1417,11 +1417,11 @@ static inline struct cgroup *__cset_cgroup_from_r=
oot(struct css_set *cset,
>  }
>
>  /*
> - * look up cgroup associated with current task's cgroup namespace on the
> + * look up cgroup associated with given cgroup namespace on the
>   * specified hierarchy
>   */
> -static struct cgroup *
> -current_cgns_cgroup_from_root(struct cgroup_root *root)
> +static struct cgroup *cgns_cgroup_from_root(struct cgroup_root *root,
> +                                           struct cgroup_namespace *ns)
>  {
>         struct cgroup *res =3D NULL;
>         struct css_set *cset;
> @@ -1430,7 +1430,7 @@ current_cgns_cgroup_from_root(struct cgroup_root *r=
oot)
>
>         rcu_read_lock();
>
> -       cset =3D current->nsproxy->cgroup_ns->root_cset;
> +       cset =3D ns->root_cset;
>         res =3D __cset_cgroup_from_root(cset, root);
>
>         rcu_read_unlock();
> @@ -1852,15 +1852,15 @@ int cgroup_show_path(struct seq_file *sf, struct =
kernfs_node *kf_node,
>         int len =3D 0;
>         char *buf =3D NULL;
>         struct cgroup_root *kf_cgroot =3D cgroup_root_from_kf(kf_root);
> -       struct cgroup *ns_cgroup;
> +       struct cgroup *root_cgroup;
>
>         buf =3D kmalloc(PATH_MAX, GFP_KERNEL);
>         if (!buf)
>                 return -ENOMEM;
>
>         spin_lock_irq(&css_set_lock);
> -       ns_cgroup =3D current_cgns_cgroup_from_root(kf_cgroot);
> -       len =3D kernfs_path_from_node(kf_node, ns_cgroup->kn, buf, PATH_M=
AX);
> +       root_cgroup =3D cgns_cgroup_from_root(kf_cgroot, current->nsproxy=
->cgroup_ns);
> +       len =3D kernfs_path_from_node(kf_node, root_cgroup->kn, buf, PATH=
_MAX);
>         spin_unlock_irq(&css_set_lock);
>
>         if (len >=3D PATH_MAX)
> @@ -2330,6 +2330,18 @@ int cgroup_path_ns(struct cgroup *cgrp, char *buf,=
 size_t buflen,
>  }
>  EXPORT_SYMBOL_GPL(cgroup_path_ns);
>
> +struct cgroup *cgroup_parent_ns(struct cgroup *cgrp,
> +                                  struct cgroup_namespace *ns)
> +{
> +       struct cgroup *root_cgrp;
> +
> +       spin_lock_irq(&css_set_lock);
> +       root_cgrp =3D cgns_cgroup_from_root(cgrp->root, ns);
> +       spin_unlock_irq(&css_set_lock);
> +
> +       return cgrp =3D=3D root_cgrp ? NULL : cgroup_parent(cgrp);

I understand that currently cgroup_iter is the only user of this, but
for future use cases, is it safe to assume that cgrp will always be
inside ns? Would it be safer to do something like:

struct cgroup *parent =3D cgroup_parent(cgrp);

if (!parent)
    return NULL;

return cgroup_is_descendant(parent, root_cgrp) ? parent : NULL;


> +}
> +
>  /**
>   * task_cgroup_path - cgroup path of a task in the first cgroup hierarch=
y
>   * @task: target task
> @@ -6031,7 +6043,8 @@ struct cgroup *cgroup_get_from_id(u64 id)
>                 goto out;
>
>         spin_lock_irq(&css_set_lock);
> -       root_cgrp =3D current_cgns_cgroup_from_root(&cgrp_dfl_root);
> +       root_cgrp =3D cgns_cgroup_from_root(&cgrp_dfl_root,
> +                                         current->nsproxy->cgroup_ns);
>         spin_unlock_irq(&css_set_lock);
>         if (!cgroup_is_descendant(cgrp, root_cgrp)) {
>                 cgroup_put(cgrp);
> @@ -6612,7 +6625,8 @@ struct cgroup *cgroup_get_from_path(const char *pat=
h)
>         struct cgroup *root_cgrp;
>
>         spin_lock_irq(&css_set_lock);
> -       root_cgrp =3D current_cgns_cgroup_from_root(&cgrp_dfl_root);
> +       root_cgrp =3D cgns_cgroup_from_root(&cgrp_dfl_root,
> +                                         current->nsproxy->cgroup_ns);
>         kn =3D kernfs_walk_and_get(root_cgrp->kn, path);
>         spin_unlock_irq(&css_set_lock);
>         if (!kn)
> --
> 2.37.0
>
