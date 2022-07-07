From: Hao Luo <haoluo@google.com>
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Introduce cgroup iter
Date: Thu, 7 Jul 2022 16:33:23 -0700
Message-ID: <CA+khW7h05O1zg90tkK_7G9u0dhi8jN8WFZ_V_58obSLR4n1iBQ@mail.gmail.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-5-yosryahmed@google.com> <f6c0274d-73c4-e05b-6405-4062230c4a14@fb.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C3mGVzkNGFQOGZ/y27ZbQkMVyVRvFTFo9AVDkxPU3Qs=;
        b=jI3G3nw3SkAqpzPaUgQF22T9Ic6RqP7p4lMxcErcOD7LNwKHd9PhRD3jRjB5LpdRas
         Y5NSMurtCWidZFToFy1cwL/XBxIfNw8pRD1q5Tkl+DjQU82h4wug5DMjjkpFX5N/DorO
         SwsedXFgGBd+s1tGJbH90/3YrEFEevIGRkGo0KerFHlOynd+zFhmCXD6wOxegx+qKcI7
         whx6NUJOU7zlSU/AwEkpEWHVAccpRcvhOXltX62YPY1hchP+LZnGgdRpe/U837IrWH3D
         dz5dOl6K+w5srsimqMB2BRtRhqEml7mfZ8+BDapksn3GwHM8o2gHQoLWP2Z3Uu5lfvw3
         v75A==
In-Reply-To: <f6c0274d-73c4-e05b-6405-4062230c4a14@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs@fb.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Jun 27, 2022 at 9:09 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> > From: Hao Luo <haoluo@google.com>
> >
> > Cgroup_iter is a type of bpf_iter. It walks over cgroups in two modes:
> >
> >   - walking a cgroup's descendants.
> >   - walking a cgroup's ancestors.
>
> The implementation has another choice, BPF_ITER_CGROUP_PARENT_UP.
> We should add it here as well.
>

Sorry about the late reply. I meant to write two modes: walking up and
walking down. And two sub-modes when walking down: pre-order and
post-order.

But it seems this is confusing. I'm going to use three modes in the
next version: UP, PRE and POST.

Besides, since this patch modifies the bpf_iter_link_info, and that
breaks the btf_dump selftest, I need to include the fix of the
selftest in this patch.

> >
> > When attaching cgroup_iter, one can set a cgroup to the iter_link
> > created from attaching. This cgroup is passed as a file descriptor and
> > serves as the starting point of the walk. If no cgroup is specified,
> > the starting point will be the root cgroup.
> >
> > For walking descendants, one can specify the order: either pre-order or
> > post-order. For walking ancestors, the walk starts at the specified
> > cgroup and ends at the root.
> >
> > One can also terminate the walk early by returning 1 from the iter
> > program.
> >
> > Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> > program is called with cgroup_mutex held.
>
> Overall looks good to me with a few nits below.
>
> Acked-by: Yonghong Song <yhs@fb.com>
>
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
[...]
> > +
> > +/* cgroup_iter provides two modes of traversal to the cgroup hierarchy.
> > + *
> > + *  1. Walk the descendants of a cgroup.
> > + *  2. Walk the ancestors of a cgroup.
>
> three modes here?
>

Same here. Will use 'three modes' in the next version.

> > + *
[...]
> > +
> > +static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
> > +                               union bpf_iter_link_info *linfo,
> > +                               struct bpf_iter_aux_info *aux)
> > +{
> > +     int fd = linfo->cgroup.cgroup_fd;
> > +     struct cgroup *cgrp;
> > +
> > +     if (fd)
> > +             cgrp = cgroup_get_from_fd(fd);
> > +     else /* walk the entire hierarchy by default. */
> > +             cgrp = cgroup_get_from_path("/");
> > +
> > +     if (IS_ERR(cgrp))
> > +             return PTR_ERR(cgrp);
> > +
> > +     aux->cgroup.start = cgrp;
> > +     aux->cgroup.order = linfo->cgroup.traversal_order;
>
> The legality of traversal_order should be checked.
>

Sounds good. Will do.

> > +     return 0;
> > +}
> > +
[...]
> > +static void bpf_iter_cgroup_show_fdinfo(const struct bpf_iter_aux_info *aux,
> > +                                     struct seq_file *seq)
> > +{
> > +     char *buf;
> > +
> > +     buf = kzalloc(PATH_MAX, GFP_KERNEL);
> > +     if (!buf) {
> > +             seq_puts(seq, "cgroup_path:\n");
>
> This is a really unlikely case. maybe "cgroup_path:<unknown>"?
>

Sure, no problem. This is a path that is unlikely to hit.

> > +             goto show_order;
[...]
