From: Hao Luo <haoluo@google.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 12:42:54 -0700
Message-ID: <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org> <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0lG+wkpvvM5BrA6qMbE7wBMotbPnzZWg8Zgz+BedKu0=;
        b=MxqMb1bfrueYp5btVTDjnT2tZ4EudnH7IxjI0/g/SP5vEIe/U2NL9ob1BaPa8WrAAR
         gHX32C1grdPWfQAeZ3t3XutIipxcrCttxt0pbHMynNAuNxoaHJpIUkpJOWdoL+jti5/w
         j2Sz1Ry4bwwp1I09ZXwTrH30sJNUvlsXzNlOJJSHSXHiJ+4F5FE6Bz19mWJUzsgA0AzW
         wag0FmlobomPxKN5cV2/IVZDBNTgvni6AX5t0CfhwObdRYjhIsOOQj+NeZy9qA8qqayf
         jVACJxUx6T2C5Dy7ncHo4iQwQCSGKzdywRmM2t8gw67xFH5l+VlMZ0sqGJELpxpWIyd5
         +t5w==
In-Reply-To: <YofFli6UCX4J5YnU@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Yonghong Song <yhs@fb.com>, Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@v>

Hi Tejun and Yonghong,

On Fri, May 20, 2022 at 9:45 AM Tejun Heo <tj@kernel.org> wrote:
> On Fri, May 20, 2022 at 09:29:43AM -0700, Yonghong Song wrote:
> > Maybe you can have a bpf program signature like below:
> >
> > int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup *cgrp,
> > struct cgroup *parent_cgrp)
> >
> > parent_cgrp is NULL when cgrp is the root cgroup.
> >
> > I would like the bpf program should send the following information to
> > user space:
> >    <parent cgroup dir name> <current cgroup dir name>
>
> I don't think parent cgroup dir name would be sufficient to reconstruct the
> path given that multiple cgroups in different subtrees can have the same
> name. For live cgroups, userspace can find the path from id (or ino) without
> traversing anything by constructing the fhandle, open it open_by_handle_at()
> and then reading /proc/self/fd/$FD symlink -
> https://lkml.org/lkml/2020/12/2/1126. This isn't available for dead cgroups
> but I'm not sure how much that'd matter given that they aren't visible from
> userspace anyway.
>

Sending cgroup id is better than cgroup dir name, also because IIUC
the path obtained from cgroup id depends on the namespace of the
userspace process. So if the dump file may be potentially read by
processes within a container, it's better to have the output
namespaced IMO.

> >    <various stats interested by the user>
> >
> > This way, user space can easily construct the cgroup hierarchy stat like
> >                            cpu   mem   cpu pressure   mem pressure ...
> >    cgroup1                 ...
> >       child1               ...
> >         grandchild1        ...
> >       child2               ...
> >    cgroup 2                ...
> >       child 3              ...
> >         ...                ...
> >
> > the bpf iterator can have additional parameter like
> > cgroup_id = ... to only call bpf program once with that
> > cgroup_id if specified.

Yep, this should work. We just need to make the cgroup_id parameter
optional. If it is specified when creating bpf_iter_link, we print for
that cgroup only. If it is not specified, we iterate over all cgroups.
If I understand correctly, sounds doable.

> > The kernel part of cgroup_iter can call cgroup_rstat_flush()
> > before calling cgroup_iter bpf program.

Sounds good to me as well. But my knowledge on rstat_flush is limited.
Yosry can give this a try.

>
> Would it work to just pass in @cgrp and provide a group of helpers so that
> the program can do whatever it wanna do including looking up the full path
> and passing that to userspace?
>

My understanding is, yes, doable. If we need the full path information
of a cgroup, helpers or kfuncs are needed.

The userspace needs to specify the identity of the cgroup, when
creating bpf_iter. This identity could be cgroup id or fd. This
identity needs to be converted to cgroup object somewhere before
passing into bpf program to use.
