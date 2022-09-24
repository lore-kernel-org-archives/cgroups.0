From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [RFC PATCH bpf-next 10/10] bpf, memcg: Add new item bpf into memory.stat
Date: Sat, 24 Sep 2022 22:24:52 +0800
Message-ID: <CALOAHbBHXALOZaqxJfpmE8KFsuwBuZ3BVpQhrtUZ=m7FFpWkVA@mail.gmail.com>
References: <20220921170002.29557-1-laoar.shao@gmail.com> <20220921170002.29557-11-laoar.shao@gmail.com>
 <Yy53cgcwx+hTll4R@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=jRKeU7D5aZgqxcjhpKNi6s8l4B1Pu/W+vLp64/SXJ2k=;
        b=UpNAHeRltGJnNUYU6IN+U1QlRe0AbcVc4toc+QBqstl7xLFBtoVNVlln1qx7x6FHxq
         rzY/D8LfF8p4hcesvrFXHhGlDSwavN4UvN0Wf7LEkbN6RSQ4f3v1Spc+hnP3SMOd28s3
         lnPp5Fie6yB/oSzot5F4zNN7C871LEqZ5grBwldPWgx3HhBMNzb+f6edYQXL1ri9oZ0S
         Go4e9VTTw0+XaHP7aG0MvZJjlbheySZtr3aSZogGWCrLGK0YX5Eeil5Dasn8Sf6dIobv
         FKQG9KNOV2QdrzCjAv9xJCHfHZdSwEXrmDHKT2LfmqnahX+L+U2ulngUzqfy0WZSoING
         bk+w==
In-Reply-To: <Yy53cgcwx+hTll4R@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, john fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Zefan Li <lizefan.x@bytedance.com>, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Linux MM <linux-mm@kva>

On Sat, Sep 24, 2022 at 11:20 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Wed, Sep 21, 2022 at 05:00:02PM +0000, Yafang Shao wrote:
> > A new item 'bpf' is introduced into memory.stat, then we can get the memory
> > consumed by bpf. Currently only the memory of bpf-map is accounted.
> > The accouting of this new item is implemented with scope-based accouting,
> > which is similar to set_active_memcg(). In this scope, the memory allocated
> > will be accounted or unaccounted to a specific item, which is specified by
> > set_active_memcg_item().
>
> Imma let memcg folks comment on the implementation. Hmm... I wonder how this
> would tie in with the BPF memory allocator Alexei is working on.
>

BPF memory allocator is already in bpf-next [1].
It uses the same way to charge bpf memory into memcg, see also
get_memcg() in the BPF memory allocator, so it has been supported in
this patchset.

[1]. https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=274052a2b0ab9f380ce22b19ff80a99b99ecb198

> > The result in cgroup v1 as follows,
> >       $ cat /sys/fs/cgroup/memory/foo/memory.stat | grep bpf
> >       bpf 109056000
> >       total_bpf 109056000
> > After the map is removed, the counter will become zero again.
> >         $ cat /sys/fs/cgroup/memory/foo/memory.stat | grep bpf
> >         bpf 0
> >         total_bpf 0
> >
> > The 'bpf' may not be 0 after the bpf-map is destroyed, because there may be
> > cached objects.
>
> What's the difference between bpf and total_bpf? Where's total_bpf
> implemented?

Ah, the total_* items are cgroup1-specific items. They also include
the descendants' memory.
This patchset supports both cgroup1 and cgroup2.

> It doesn't seem to be anywhere. Please also update
> Documentation/admin-guide/cgroup-v2.rst.
>

Sure, I will update the Document.

> > Note that there's no kmemcg in root memory cgroup, so the item 'bpf' will
> > be always 0 in root memory cgroup. If a bpf-map is charged into root memcg
> > directly, its memory size will not be accounted, so the 'total_bpf' can't
> > be used to monitor system-wide bpf memory consumption yet.
>
> So, system-level accounting is usually handled separately as it's most
> likely that we'd want the same stat at the system level even when cgroup is
> not implemented. Here, too, it'd make sense to first implement system level
> bpf memory usage accounting, expose that through /proc/meminfo and then use
> the same source for root level cgroup stat.
>

Sure, I will do it first. Thanks for your suggestion.

-- 
Regards
Yafang
