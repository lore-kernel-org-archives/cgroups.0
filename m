From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
Date: Wed, 3 Aug 2022 13:29:51 -0700
Message-ID: <CA+khW7jDD9p80xnZj0Z3m5oFHjb2u___NAiJkbyRgD5FKopGhg@mail.gmail.com>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com> <CAEf4BzbD38XFVxMy5crO-=+Xg7U3Vc_fB4Ntug4BEbmdLpvuDQ@mail.gmail.com>
 <CA+khW7jftQikVsc8moM6rNRqBerUHDM6WRDjb33exdbogDc7aQ@mail.gmail.com> <CAEf4BzYDqaTQr-S8TuLkysQ+FhT+6qMS0z=Sp_7+-wk84_4h6Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dsz8IHMohhYZ2cZL5pWvVqmp+AxFsLxkDLJLSy2o2N4=;
        b=qhvgEU9aNbRaLz1LZz5Di83doxE96N37k+dzlmaEWg5j2FL+um8PmgRkdOPCt9li8w
         d6I9EofHmCIIm5a5qQKRxvYyHNjc/oSKXVrzBEYTWXJxPsC9SdRj1z3GYLR95V0+NkFw
         lgyrS8WvaiBPjACPGlGDABCkAa+ybGB/6Uv/er7mt+cMRI1NTghVCOUPKzd2udTCZ6Kc
         +Ti6RiS7W6hdxcjcgYGDJ/Ujgc9ms5B7xl43PRhb/E298i9nxm26sTuM2DhKkPlQ9DEg
         Q2NcVHoYtWH31WyzoWtwIiBrvvxg4ctBJQuILoR82lLcUyoK2mZZvbPldxUKnIwE1sE7
         EVeg==
In-Reply-To: <CAEf4BzYDqaTQr-S8TuLkysQ+FhT+6qMS0z=Sp_7+-wk84_4h6Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrii Nakryiko <andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel

On Tue, Aug 2, 2022 at 3:50 PM Andrii Nakryiko
<andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Tue, Aug 2, 2022 at 3:27 PM Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Hi Andrii,
> >
> > On Mon, Aug 1, 2022 at 8:43 PM Andrii Nakryiko
> > <andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > On Fri, Jul 22, 2022 at 10:48 AM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
[...]
> > > >
> > > > +enum bpf_iter_cgroup_traversal_order {
> > > > +       BPF_ITER_CGROUP_PRE = 0,        /* pre-order traversal */
> > > > +       BPF_ITER_CGROUP_POST,           /* post-order traversal */
> > > > +       BPF_ITER_CGROUP_PARENT_UP,      /* traversal of ancestors up to the root */
> > >
> > > I've just put up my arguments why it's a good idea to also support a
> > > "trivial" mode of only traversing specified cgroup and no descendants
> > > or parents. Please see [0].
> >
> > cc Kui-Feng in this thread.
> >
> > Yeah, I think it's a good idea. It's useful when we only want to show
> > a single object, which can be common. Going further, I think we may
> > want to restructure bpf_iter to optimize for this case.
> >
> > > I think the same applies here, especially
> > > considering that it seems like a good idea to support
> > > task/task_vma/task_files iteration within a cgroup.
> >
> > I have reservations on these use cases. I don't see immediate use of
> > iterating vma or files within a cgroup. Tasks within a cgroup? Maybe.
> > :)
> >
>
> iter/task was what I had in mind in the first place. But I can also
> imagine tools utilizing iter/task_files for each process within a
> cgroup, so given iter/{task, task_file, task_vma} share the same UAPI
> and internals, I don't see why we'd restrict this to only iter/task.

No problem. I was hoping we don't over-design the interface. IMHO keep
it simple stupid. :)

>
[...]
> >
> > [1] https://lwn.net/Articles/902405/
> >
> > >
> > > Some more naming nits. I find BPF_ITER_CGROUP_PRE and
> > > BPF_ITER_CGROUP_POST a bit confusing. Even internally in kernel we
> > > have css_next_descendant_pre/css_next_descendant_post, so why not
> > > reflect the fact that we are going to iterate descendants:
> > > BPF_ITER_CGROUP_DESCENDANTS_{PRE,POST}. And now that we use
> > > "descendants" terminology, PARENT_UP should be ANCESTORS. ANCESTORS_UP
> > > probably is fine, but seems a bit redundant (unless we consider a
> > > somewhat weird ANCESTORS_DOWN, where we find the furthest parent and
> > > then descend through preceding parents until we reach specified
> > > cgroup; seems a bit exotic).
> > >
> >
> > BPF_ITER_CGROUP_DESCENDANTS_PRE is too verbose. If there is a
> > possibility of merging rbtree and supporting walk order of rbtree
> > iter, maybe the name here could be general, like
> > BPF_ITER_DESCENDANTS_PRE, which seems better.
>
> it's not like you'll be typing this hundreds of type, so verboseness
> doesn't seem to be too problematic, but sure, BPF_ITER_DESCENDANTS_PRE
> is fine with me
>
> >
> > >   [0] https://lore.kernel.org/bpf/f92e20e9961963e20766e290ee6668edd4bacf06.camel-b10kYP2dOMg@public.gmane.org/T/#m5ce50632aa550dd87a99241efb168cbcde1ee98f
> > >
> > > > +};
> > > > +
> > > >  union bpf_iter_link_info {
> > > >         struct {
> > > >                 __u32   map_fd;
> > > >         } map;
> > > > +
> > > > +       /* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> > > > +        * ancestors of a given cgroup.
> > > > +        */
> > > > +       struct {
> > > > +               /* Cgroup file descriptor. This is root of the subtree if walking
> > > > +                * descendants; it's the starting cgroup if walking the ancestors.
> > > > +                * If it is left 0, the traversal starts from the default cgroup v2
> > > > +                * root. For walking v1 hierarchy, one should always explicitly
> > > > +                * specify the cgroup_fd.
> > > > +                */
> > > > +               __u32   cgroup_fd;
> > >
> > > Now, similar to what I argued in regard of pidfd vs pid, I think the
> > > same applied to cgroup_fd vs cgroup_id. Why can't we support both?
> > > cgroup_fd has some benefits, but cgroup_id is nice due to simplicity
> > > and not having to open/close/keep extra FDs (which can add up if we
> > > want to periodically query something about a large set of cgroups).
> > > Please see my arguments from [0] above.
> > >
> > > Thoughts?
> > >
> >
> > We can support both, it's a good idea IMO. But what exactly is the
> > interface going to look like? Can you be more specific about that?
> > Below is something I tried based on your description.
> >
> > @@ -91,6 +91,18 @@ union bpf_iter_link_info {
> >         struct {
> >                 __u32   map_fd;
> >         } map;
> > +       struct {
> > +               /* PRE/POST/UP/SELF */
> > +               __u32 order;
> > +               struct {
> > +                       __u32 cgroup_fd;
> > +                       __u64 cgroup_id;
> > +               } cgroup;
> > +               struct {
> > +                       __u32 pid_fd;
> > +                       __u64 pid;
> > +               } task;
> > +       };
> >  };
> >
>
> So I wouldn't combine task and cgroup definition together, let's keep
> them independent.
>
> then for cgroup we can do something like:
>
> struct {
>     __u32 order;
>     __u32 cgroup_fd; /* cgroup_fd ^ cgroup_id, exactly one can be non-zero */
>     __u32 cgroup_id;
> } cgroup
>
> Similar idea with task, but it's a bit more complicated because there
> we have target that can be pid, pidfd, or cgroup (cgroup_fd and
> cgroup_id). I haven't put much thought into the best representation,
> though.
>

The cgroup part sounds good to me. For the full picture, how about
this? I'm just trying  a prototype, hoping that it can help people to
get a clear picture.

union bpf_iter_link_info {
          struct {
                  __u32   map_fd;
          } map;
          struct {
                  __u32   order; /* PRE/POST/UP/SELF */
                  __u32   cgroup_fd;
                  __u64   cgroup_id;
          } cgroup;
          struct {
                  __u32   pid;
                  __u32   pid_fd;
                  __u64   cgroup_id;
                  __u32   cgroup_fd;
                  __u32   mode; /* SELF or others */
          } task;
};

> > > > +               __u32   traversal_order;
> > > > +       } cgroup;
> > > >  };
> > > >
> > > >  /* BPF syscall commands, see bpf(2) man-page for more details. */
> > >
> > > [...]
