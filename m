From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
Date: Wed, 3 Aug 2022 13:39:57 -0700
Message-ID: <CAEf4BzZhy49KLe5VG4aXZtWBExADskgA__MzhC+6k3DVgU5o5w@mail.gmail.com>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com> <CAEf4BzbD38XFVxMy5crO-=+Xg7U3Vc_fB4Ntug4BEbmdLpvuDQ@mail.gmail.com>
 <CA+khW7jftQikVsc8moM6rNRqBerUHDM6WRDjb33exdbogDc7aQ@mail.gmail.com>
 <CAEf4BzYDqaTQr-S8TuLkysQ+FhT+6qMS0z=Sp_7+-wk84_4h6Q@mail.gmail.com> <CA+khW7jDD9p80xnZj0Z3m5oFHjb2u___NAiJkbyRgD5FKopGhg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=oTShiEMH5RY05sBENmlaVH8MISobFaNytMdpGKM2vSw=;
        b=FjF1KOeYq38Pcb3ngMcfM2yVepWlFrI452L2vdlfv82H/rMHawFN+TeLV82AiPqpmF
         i3+M+41m/q8UWxvj+Dgmi2KsInvlosC6gW6mWOypwb6KS0SP6yeocY7q94D58TudvyX8
         VjO/oG0+PEGuAgaabM6WBEXd5TQaq0umtmCG8Y1e6eHG0fw3Xv0P6renLP3R3wheqvN9
         UMFwBml9r/0ILe/m22Y90oq8idkSNL8+pl6zIcG436NQYPyHW9H9qh8nOe1bWmWr7n93
         LeO4WA/Liz+hgcFQhevLveG5m2UDiSGVCk08ItVP2fU0AvF/0thBj1DmdGEA8gMUthIb
         PncQ==
In-Reply-To: <CA+khW7jDD9p80xnZj0Z3m5oFHjb2u___NAiJkbyRgD5FKopGhg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Luo <haoluo@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel

On Wed, Aug 3, 2022 at 1:30 PM Hao Luo <haoluo@google.com> wrote:
>
> On Tue, Aug 2, 2022 at 3:50 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Aug 2, 2022 at 3:27 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > Hi Andrii,
> > >
> > > On Mon, Aug 1, 2022 at 8:43 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Fri, Jul 22, 2022 at 10:48 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> [...]
> > > > >
> > > > > +enum bpf_iter_cgroup_traversal_order {
> > > > > +       BPF_ITER_CGROUP_PRE = 0,        /* pre-order traversal */
> > > > > +       BPF_ITER_CGROUP_POST,           /* post-order traversal */
> > > > > +       BPF_ITER_CGROUP_PARENT_UP,      /* traversal of ancestors up to the root */
> > > >
> > > > I've just put up my arguments why it's a good idea to also support a
> > > > "trivial" mode of only traversing specified cgroup and no descendants
> > > > or parents. Please see [0].
> > >
> > > cc Kui-Feng in this thread.
> > >
> > > Yeah, I think it's a good idea. It's useful when we only want to show
> > > a single object, which can be common. Going further, I think we may
> > > want to restructure bpf_iter to optimize for this case.
> > >
> > > > I think the same applies here, especially
> > > > considering that it seems like a good idea to support
> > > > task/task_vma/task_files iteration within a cgroup.
> > >
> > > I have reservations on these use cases. I don't see immediate use of
> > > iterating vma or files within a cgroup. Tasks within a cgroup? Maybe.
> > > :)
> > >
> >
> > iter/task was what I had in mind in the first place. But I can also
> > imagine tools utilizing iter/task_files for each process within a
> > cgroup, so given iter/{task, task_file, task_vma} share the same UAPI
> > and internals, I don't see why we'd restrict this to only iter/task.
>
> No problem. I was hoping we don't over-design the interface. IMHO keep
> it simple stupid. :)
>
> >
> [...]
> > >
> > > [1] https://lwn.net/Articles/902405/
> > >
> > > >
> > > > Some more naming nits. I find BPF_ITER_CGROUP_PRE and
> > > > BPF_ITER_CGROUP_POST a bit confusing. Even internally in kernel we
> > > > have css_next_descendant_pre/css_next_descendant_post, so why not
> > > > reflect the fact that we are going to iterate descendants:
> > > > BPF_ITER_CGROUP_DESCENDANTS_{PRE,POST}. And now that we use
> > > > "descendants" terminology, PARENT_UP should be ANCESTORS. ANCESTORS_UP
> > > > probably is fine, but seems a bit redundant (unless we consider a
> > > > somewhat weird ANCESTORS_DOWN, where we find the furthest parent and
> > > > then descend through preceding parents until we reach specified
> > > > cgroup; seems a bit exotic).
> > > >
> > >
> > > BPF_ITER_CGROUP_DESCENDANTS_PRE is too verbose. If there is a
> > > possibility of merging rbtree and supporting walk order of rbtree
> > > iter, maybe the name here could be general, like
> > > BPF_ITER_DESCENDANTS_PRE, which seems better.
> >
> > it's not like you'll be typing this hundreds of type, so verboseness
> > doesn't seem to be too problematic, but sure, BPF_ITER_DESCENDANTS_PRE
> > is fine with me
> >
> > >
> > > >   [0] https://lore.kernel.org/bpf/f92e20e9961963e20766e290ee6668edd4bacf06.camel@fb.com/T/#m5ce50632aa550dd87a99241efb168cbcde1ee98f
> > > >
> > > > > +};
> > > > > +
> > > > >  union bpf_iter_link_info {
> > > > >         struct {
> > > > >                 __u32   map_fd;
> > > > >         } map;
> > > > > +
> > > > > +       /* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> > > > > +        * ancestors of a given cgroup.
> > > > > +        */
> > > > > +       struct {
> > > > > +               /* Cgroup file descriptor. This is root of the subtree if walking
> > > > > +                * descendants; it's the starting cgroup if walking the ancestors.
> > > > > +                * If it is left 0, the traversal starts from the default cgroup v2
> > > > > +                * root. For walking v1 hierarchy, one should always explicitly
> > > > > +                * specify the cgroup_fd.
> > > > > +                */
> > > > > +               __u32   cgroup_fd;
> > > >
> > > > Now, similar to what I argued in regard of pidfd vs pid, I think the
> > > > same applied to cgroup_fd vs cgroup_id. Why can't we support both?
> > > > cgroup_fd has some benefits, but cgroup_id is nice due to simplicity
> > > > and not having to open/close/keep extra FDs (which can add up if we
> > > > want to periodically query something about a large set of cgroups).
> > > > Please see my arguments from [0] above.
> > > >
> > > > Thoughts?
> > > >
> > >
> > > We can support both, it's a good idea IMO. But what exactly is the
> > > interface going to look like? Can you be more specific about that?
> > > Below is something I tried based on your description.
> > >
> > > @@ -91,6 +91,18 @@ union bpf_iter_link_info {
> > >         struct {
> > >                 __u32   map_fd;
> > >         } map;
> > > +       struct {
> > > +               /* PRE/POST/UP/SELF */
> > > +               __u32 order;
> > > +               struct {
> > > +                       __u32 cgroup_fd;
> > > +                       __u64 cgroup_id;
> > > +               } cgroup;
> > > +               struct {
> > > +                       __u32 pid_fd;
> > > +                       __u64 pid;
> > > +               } task;
> > > +       };
> > >  };
> > >
> >
> > So I wouldn't combine task and cgroup definition together, let's keep
> > them independent.
> >
> > then for cgroup we can do something like:
> >
> > struct {
> >     __u32 order;
> >     __u32 cgroup_fd; /* cgroup_fd ^ cgroup_id, exactly one can be non-zero */
> >     __u32 cgroup_id;
> > } cgroup
> >
> > Similar idea with task, but it's a bit more complicated because there
> > we have target that can be pid, pidfd, or cgroup (cgroup_fd and
> > cgroup_id). I haven't put much thought into the best representation,
> > though.
> >
>
> The cgroup part sounds good to me. For the full picture, how about
> this? I'm just trying  a prototype, hoping that it can help people to
> get a clear picture.
>
> union bpf_iter_link_info {
>           struct {
>                   __u32   map_fd;
>           } map;
>           struct {
>                   __u32   order; /* PRE/POST/UP/SELF */
>                   __u32   cgroup_fd;
>                   __u64   cgroup_id;
>           } cgroup;

lgtm

>           struct {
>                   __u32   pid;
>                   __u32   pid_fd;
>                   __u64   cgroup_id;
>                   __u32   cgroup_fd;
>                   __u32   mode; /* SELF or others */

I'd move mode to be first. I'm undecided on using 4 separate fields
for pid/pid_fd/cgroup_{id,fd} vs a single union (or just generic "u64
target"  and then mode can define how we should treat target --
whether it's pid, pid_fd, cgroup ID or FD. I'm fine either way, I
think. But for cgroup case not having to duplicate PRE/POST/UP/SELF
for cgroup id and then for cgroup fd seems like a win. So separate
fields might be better. It's also pretty extendable. And I'm
personally not worried about using few more bytes in bpf_attr for
disjoin fields like this.

>           } task;
> };
>
> > > > > +               __u32   traversal_order;
> > > > > +       } cgroup;
> > > > >  };
> > > > >
> > > > >  /* BPF syscall commands, see bpf(2) man-page for more details. */
> > > >
> > > > [...]
