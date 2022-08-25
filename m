From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v9 1/5] bpf: Introduce cgroup iter
Date: Thu, 25 Aug 2022 10:58:26 -0700
Message-ID: <CA+khW7hKk8yMvsQCQjnEoR3=G9=77F2TgAEDa+uSVedoOE=NsA@mail.gmail.com>
References: <20220824030031.1013441-1-haoluo@google.com> <20220824030031.1013441-2-haoluo@google.com>
 <20220825152455.GA29058@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=/GYRroV0j1HQtttqGy5ikwY0tvszI/gqxle1gBMtBi8=;
        b=ck2vOHHo88Dym2Eg5dmOrOFWsd+DiRYzQswvx+qDw/AaR6oiFaBJuXUDozxFm5NdeY
         RyIHT6ucnHWVYW6HD8rQ+SaVdPk0knVAyhXIGj5w8crdLz6PBdvQtFIIaAYJdupUr7Jf
         m1xm1ISYsse8LApnX9JzNrTmopx1LnHBt+ZKHiKPVL0+L8GUr6VeP3JxqlvNj8ckaxzE
         V4nu1m+hX8cIclMyiKgMwCNn4rkZdPf3FccCw+8fdv7PtEeMjXwsvWy9eT3Gia6EroBO
         DE334U1ACpqjXh+T9+MFSK12LcnccR145icds02vQe0SfVkKnQiwa6FtY2yGHSVjM2t+
         KwEA==
In-Reply-To: <20220825152455.GA29058-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Aug 25, 2022 at 8:24 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> Hello.
>
> On Tue, Aug 23, 2022 at 08:00:27PM -0700, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wro=
te:
> > +static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
> > +                               union bpf_iter_link_info *linfo,
> > +                               struct bpf_iter_aux_info *aux)
> > +{
> > +     int fd =3D linfo->cgroup.cgroup_fd;
> > +     u64 id =3D linfo->cgroup.cgroup_id;
> > +     int order =3D linfo->cgroup.order;
> > +     struct cgroup *cgrp;
> > +
> > +     if (order !=3D BPF_ITER_DESCENDANTS_PRE &&
> > +         order !=3D BPF_ITER_DESCENDANTS_POST &&
> > +         order !=3D BPF_ITER_ANCESTORS_UP &&
> > +         order !=3D BPF_ITER_SELF_ONLY)
> > +             return -EINVAL;
> > +
> > +     if (fd && id)
> > +             return -EINVAL;
> > +
> > +     if (fd)
> > +             cgrp =3D cgroup_get_from_fd(fd);
> > +     else if (id)
> > +             cgrp =3D cgroup_get_from_id(id);
> > +     else /* walk the entire hierarchy by default. */
> > +             cgrp =3D cgroup_get_from_path("/");
> > +
> > +     if (IS_ERR(cgrp))
> > +             return PTR_ERR(cgrp);
>
> This section caught my eye.
>
> Perhaps the simpler way for the default hierachy fallback would be
>
>                 cgrp =3D &cgrp_dfl_root.cgrp;
>                 cgroup_get(cgroup)
>
> But maybe it's not what is the intention if cgroup NS should be taken
> into account and cgroup_get_from_path() is buggy in this regard.
>
> Would it make sense to prepend the patch below to your series?

Yep. Being able to take cgroup NS into account is my intention here.
Right now, I imagine the control plane who uses this default option is
the system daemon which lives in the init cgroup ns. They could always
specify a particular cgroup using ID or FD. Printing the whole
hierarchy is something a system daemon would do. Anyhow, can I add the
appended patch if there is going to be a v10 of this patch series? If
v9 is ok to merge, I can send the appended patch separately. Does that
sound good? The appended patch looks good to me, thanks!

>
> Also, that makes me think about iter initialization with ID. In contrast
> with FD passing (that's subject to some permissions and NS checks), the
> retrieval via ID is not equipped with that, ids are not unguessable and
> I'd consider cgroup IDs an implementation detail.
>
> So, is the ID initialization that much useful? (I have no idea about
> permissions model of BPF here, so it might be just fine but still it'd
> be good to take cgroup NS into account. Likely for BPF_ITER_ANCESTORS_UP
> too.)
>

Permission is a valid point about FD. There was discussion in an
earlier version of this patch series [0]. The good thing about ID is
that it can be passed across processes and it's meaningful to appear
in logs. It's more user-friendly. So we decided to support both.

[0] https://lore.kernel.org/netdev/YuK+eg3lgwJ2CJnJ-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/

> HTH,
> Michal
>
> ----8<----
> From 1098e60e89d4d901b7eef04e531f2c889309a91b Mon Sep 17 00:00:00 2001
> From: =3D?UTF-8?q?Michal=3D20Koutn=3DC3=3DBD?=3D <mkoutny-IBi9RG/b67k@public.gmane.org>
> Date: Thu, 25 Aug 2022 15:19:04 +0200
> Subject: [PATCH] cgroup: Honor caller's cgroup NS when resolving path
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> cgroup_get_from_path() is not widely used function. Its callers presume
> the path is resolved under cgroup namespace. (There is one caller
> currently and resolving in init NS won't make harm (netfilter). However,
> future users may be subject to different effects when resolving
> globally.)
> Since, there's currently no use for the global resolution, modify the
> existing function to take cgroup NS into account.
>
> Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
> Signed-off-by: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>
> ---
>  kernel/cgroup/cgroup.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index ffaccd6373f1..9280f4b41d8b 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6603,8 +6603,12 @@ struct cgroup *cgroup_get_from_path(const char *pa=
th)
>  {
>         struct kernfs_node *kn;
>         struct cgroup *cgrp =3D ERR_PTR(-ENOENT);
> +       struct cgroup *root_cgrp;
>
> -       kn =3D kernfs_walk_and_get(cgrp_dfl_root.cgrp.kn, path);
> +       spin_lock_irq(&css_set_lock);
> +       root_cgrp =3D current_cgns_cgroup_from_root(&cgrp_dfl_root);
> +       kn =3D kernfs_walk_and_get(root_cgrp->kn, path);
> +       spin_unlock_irq(&css_set_lock);
>         if (!kn)
>                 goto out;
>
>
> base-commit: 3cc40a443a04d52b0c95255dce264068b01e9bfe
> --
> 2.37.0
>
