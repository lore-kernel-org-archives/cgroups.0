From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 14:18:42 -0700
Message-ID: <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org> <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org> <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fjiL3NxvzYrXKj45aHBa+PDLeI3SrPcf1o9kYao+3oU=;
        b=f1SZJ5wLl9KsySVn8cTyhGlWJMoGbRfZWdXIbT19HvldLNIfxvW+e8t2QACM0vOjjl
         TTkCnR8Uv4N+prXqmTruAvJV4jPFv1yFQG5Mcwc/JNk/2wd7QMX3xCRWlmOHUKqiOa8m
         7rN49OeStoRttGDgdidlQT1/mlxLY42xKmmDXWeXODcWslDYXMO/z0UyC6ANAVntoFnN
         dNYejFKQpABvj/LLi6y+ekG47MHIQYksaSFuqWQxHCnopiPAMI0U+V5dHZGF9MC72GLu
         k9uItHw/yoSOK+kR4G3a/Qmt5aepyIBViRMr2gyaWIABqizZ0tr7XgaAqAuOnTlWVB55
         E0tQ==
In-Reply-To: <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TZUIDd8j+nm9g@public.gmane.org>

On Fri, May 20, 2022 at 12:43 PM Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Hi Tejun and Yonghong,
>
> On Fri, May 20, 2022 at 9:45 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Fri, May 20, 2022 at 09:29:43AM -0700, Yonghong Song wrote:
> > > Maybe you can have a bpf program signature like below:
> > >
> > > int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup *cgrp,
> > > struct cgroup *parent_cgrp)
> > >
> > > parent_cgrp is NULL when cgrp is the root cgroup.
> > >
> > > I would like the bpf program should send the following information to
> > > user space:
> > >    <parent cgroup dir name> <current cgroup dir name>
> >
> > I don't think parent cgroup dir name would be sufficient to reconstruct the
> > path given that multiple cgroups in different subtrees can have the same
> > name. For live cgroups, userspace can find the path from id (or ino) without
> > traversing anything by constructing the fhandle, open it open_by_handle_at()
> > and then reading /proc/self/fd/$FD symlink -
> > https://lkml.org/lkml/2020/12/2/1126. This isn't available for dead cgroups
> > but I'm not sure how much that'd matter given that they aren't visible from
> > userspace anyway.
> >
>
> Sending cgroup id is better than cgroup dir name, also because IIUC
> the path obtained from cgroup id depends on the namespace of the
> userspace process. So if the dump file may be potentially read by
> processes within a container, it's better to have the output
> namespaced IMO.
>
> > >    <various stats interested by the user>
> > >
> > > This way, user space can easily construct the cgroup hierarchy stat like
> > >                            cpu   mem   cpu pressure   mem pressure ...
> > >    cgroup1                 ...
> > >       child1               ...
> > >         grandchild1        ...
> > >       child2               ...
> > >    cgroup 2                ...
> > >       child 3              ...
> > >         ...                ...
> > >
> > > the bpf iterator can have additional parameter like
> > > cgroup_id = ... to only call bpf program once with that
> > > cgroup_id if specified.
>
> Yep, this should work. We just need to make the cgroup_id parameter
> optional. If it is specified when creating bpf_iter_link, we print for
> that cgroup only. If it is not specified, we iterate over all cgroups.
> If I understand correctly, sounds doable.
>
> > > The kernel part of cgroup_iter can call cgroup_rstat_flush()
> > > before calling cgroup_iter bpf program.
>
> Sounds good to me as well. But my knowledge on rstat_flush is limited.
> Yosry can give this a try.
>
> >
> > Would it work to just pass in @cgrp and provide a group of helpers so that
> > the program can do whatever it wanna do including looking up the full path
> > and passing that to userspace?
> >
>
> My understanding is, yes, doable. If we need the full path information
> of a cgroup, helpers or kfuncs are needed.
>
> The userspace needs to specify the identity of the cgroup, when
> creating bpf_iter. This identity could be cgroup id or fd. This
> identity needs to be converted to cgroup object somewhere before
> passing into bpf program to use.


Let's sum up the discussion here, I feel like we are losing track of
the main problem. IIUC the main concern is that cgroup_iter is not
effectively an iterator, it rather dumps information for one cgroup. I
like the suggestion to make it iterate cgroups by default, and an
optional cgroup_id parameter to make it only "iterate" this one
cgroup. IIUC, this cgroup_id parameter would be a link parameter,
similar to the current approach. Basically, we extend the current
patch so that if cgroup_id is not specified the iterator gets called
for all cgroups instead of one. This fixes the problem for our use
case and also keeps cgroup_iter generic enough. Is my understanding
correct? If yes, I don't see a need to flush rstat in the kernel on
behalf of cgroup_iter progs.
