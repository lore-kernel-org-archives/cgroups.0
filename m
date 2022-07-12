From: Hao Luo <haoluo@google.com>
Subject: Re: [PATCH bpf-next v3 4/8] bpf: Introduce cgroup iter
Date: Mon, 11 Jul 2022 17:42:14 -0700
Message-ID: <CA+khW7gmVmXMg4YP4fxTtgqNyAr4mQqnXbP=z0nUeQ8=hfGC3g@mail.gmail.com>
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-5-yosryahmed@google.com> <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
 <a6d048b8-d017-ea7e-36f0-1c4f88fc4399@fb.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=68mkDNBCkeJpX+q116C9yWsW5XjBLSxGi+xt71TSQ28=;
        b=pXcUEGlIhOHDWFHvDN9rRDLyJeDZML22bbC8eiEGLCy/l4q3ub47IwesxJKljkqfb8
         nHo/r/cp9kyG8mZVZTNOAx4hzS3GaEjcvicCDoe02fE9FolqPAKFuY8Yz4hOx4lEEI+B
         vs5VuZWfB+WFXaL8jLSq4cjzTVtlNJI1bco7XI+5d7o+6Nrc35e3zlx/La0iy33o4aQB
         s4CD0WymQMmITSwJOIiWAIaFjB08hdaj5K8yBVWYxR1oYSeGBMLeY66fr2CPeR5SUtQz
         FqjKBS1ff2f/3D3pFF/1j0RLdvML2qQgm8bFuhL1eit5NdIkvBO5vNiChDWEJL0ialM5
         ooNA==
In-Reply-To: <a6d048b8-d017-ea7e-36f0-1c4f88fc4399@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs@fb.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>

On Mon, Jul 11, 2022 at 4:20 PM Yonghong Song <yhs@fb.com> wrote:
>
> On 7/10/22 5:19 PM, Yonghong Song wrote:
> >
> >
[...]
> >> +
> >>   union bpf_iter_link_info {
> >>       struct {
> >>           __u32    map_fd;
> >>       } map;
> >> +
> >> +    /* cgroup_iter walks either the live descendants of a cgroup
> >> subtree, or the ancestors
> >> +     * of a given cgroup.
> >> +     */
> >> +    struct {
> >> +        /* Cgroup file descriptor. This is root of the subtree if for
> >> walking the
> >> +         * descendants; this is the starting cgroup if for walking
> >> the ancestors.
> >
> > Adding comment that cgroup_fd 0 means starting from root cgroup?

Sure.

> > Also, if I understand correctly, cgroup v1 is also supported here,
> > right? If this is the case, for cgroup v1 which root cgroup will be
> > used for cgroup_fd? It would be good to clarify here too.
> >

IMO, the case of cgroup_fd = 0 combined with cgroup v1 should return
errors. It's an invalid case. If anyone wants to use cgroup_iter on
cgroup v1 hierarchy, they could explicitly open the subsystems' root
directory and pass the fd. With that said, Yosry and I will test and
confirm the behavior in this situation and clarify in the comment.
Thanks for pointing this out.

> >> +         */
> >> +        __u32    cgroup_fd;
> >> +        __u32    traversal_order;
> >> +    } cgroup;
> >>   };
> >>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> >> @@ -6134,6 +6151,10 @@ struct bpf_link_info {
> >>                   struct {
> >>                       __u32 map_id;
> >>                   } map;
> >> +                struct {
> >> +                    __u32 traversal_order;
> >> +                    __aligned_u64 cgroup_id;
> >> +                } cgroup;
> >
> > We actually has a problem here although I don't have a solution yet.
> >
[...]
> >
> > There is a 4 byte hole after member 'target_name_len'. So map_id will
> > have a offset 16 from the start of structure 'iter'.
> >
> >
> > This will break uapi. We probably won't be able to change the existing
> > uapi with adding a ':32' after member 'target_name_len'. I don't have
> > a good solution yet, but any suggestion is welcome.
> >
> > Also, for '__aligned_u64 cgroup_id', '__u64 cgroup_id' is enough.
> > '__aligned_u64' mostly used for pointers.
>
> Briefly discussed with Alexei, the following structure iter definition
> should work. Later on, if we need to addition fields for other iter's,
> for a single __u32, the field can be added to either the first or the
> second union. If fields are more than __u32, they can be placed
> in the second union.
>
>                  struct {
>                          __aligned_u64 target_name; /* in/out:
> target_name buffer ptr */
>                          __u32 target_name_len;     /* in/out:
> target_name buffer len */
>                          union {
>                                  struct {
>                                          __u32 map_id;
>                                  } map;
>                          };
>                          union {
>                                  struct {
>                                          __u64 cgroup_id;
>                                          __u32 traversal_order;
>                                  } cgroup;
>                          };
>                  } iter;
>

Thanks Yonghong for seeking the solution here. The solution looks
good. I'm going to put your heads-up as comments there. One thing I'd
like to confirm, when we query bpf_link_info for cgroup iter, do we
also need to zero those fields for map_elem?

>
> >
> >
> >>               };
> >>           } iter;
> >>           struct  {
[...]
> >> +
> >> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> >> +{
> >> +    struct cgroup_iter_priv *p = seq->private;
> >> +
> >> +    mutex_lock(&cgroup_mutex);
> >> +
> >> +    /* support only one session */
> >> +    if (*pos > 0)
> >> +        return NULL;
> >
> > This might be okay. But want to check what is
> > the practical upper limit for cgroups in a system
> > and whether we may miss some cgroups. If this
> > happens, it will be a surprise to the user.
> >

Ok. What's the max number of items supported in a single session?

> >> +
> >> +    ++*pos;
> >> +    p->terminate = false;
> >> +    if (p->order == BPF_ITER_CGROUP_PRE)
> >> +        return css_next_descendant_pre(NULL, p->start_css);
> >> +    else if (p->order == BPF_ITER_CGROUP_POST)
> >> +        return css_next_descendant_post(NULL, p->start_css);
> >> +    else /* BPF_ITER_CGROUP_PARENT_UP */
> >> +        return p->start_css;
> >> +}
> >> +
> >> +static int __cgroup_iter_seq_show(struct seq_file *seq,
> >> +                  struct cgroup_subsys_state *css, int in_stop);
> >> +
> >> +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
> >> +{
> >> +    /* pass NULL to the prog for post-processing */
> >> +    if (!v)
> >> +        __cgroup_iter_seq_show(seq, NULL, true);
> >> +    mutex_unlock(&cgroup_mutex);
> >> +}
> >> +
> > [...]
