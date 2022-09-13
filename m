From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
Date: Tue, 13 Sep 2022 14:15:20 +0800
Message-ID: <CALOAHbAzi0s3N_5BOkLsnGfwWCDpUksvvhPejjj5jo4G2v3mGg@mail.gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com> <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <YxkVq4S1Eoa4edjZ@P9FQF9L96D.corp.robot.car> <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
 <YxoUkz05yA0ccGWe@P9FQF9L96D.corp.robot.car>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=iL+PSuTvBsgGgVuYBzw23P7DA3wgNTk8Y2M7Kc+r7u8=;
        b=UXg7Y3VmdYKh0yVQeWq3KV0amIKGmR9oIbm2MDgvqcrlBMbu3Gz0DwJ2d7oTuamu/6
         MNqFRm+GD3j1yKbm3LDTkdJ4gee9fnjmeQVk7onS2afn0pU1gUPmFp0Ort3ThmUpqA0P
         BCRjT363Klq15cX5XXoZwn7aC1EW4FZso6vCdIvC6WRpB6PZNTsmNFVUdoVwmhGOrCoN
         Fd5buTIBvFqWtyxkxWCx+SQ9CXELd4rl/uPSaEFApnVvkLyVB3sAcMwPC0sOajU+oldm
         D3lKi3nkb3r+0KVHyovGr1Q1S7rQkiFWuDJHhpqPSVfxddUM2JVIAt+djtL61R2yldi+
         ypcQ==
In-Reply-To: <YxoUkz05yA0ccGWe-+xijCwNIfdoLQcUKs7qKB+WAnPUfkyWGUBSOeVevoDU@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, john fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, Sep 9, 2022 at 12:13 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
>
> On Thu, Sep 08, 2022 at 10:37:02AM +0800, Yafang Shao wrote:
> > On Thu, Sep 8, 2022 at 6:29 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> > >
> > > On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> > > > Hello,
> > > >
> > > > On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> > > > ...
> > > > > This patchset tries to resolve the above two issues by introducing a
> > > > > selectable memcg to limit the bpf memory. Currently we only allow to
> > > > > select its ancestor to avoid breaking the memcg hierarchy further.
> > > > > Possible use cases of the selectable memcg as follows,
> > > >
> > > > As discussed in the following thread, there are clear downsides to an
> > > > interface which requires the users to specify the cgroups directly.
> > > >
> > > >  https://lkml.kernel.org/r/YwNold0GMOappUxc-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org
> > > >
> > > > So, I don't really think this is an interface we wanna go for. I was hoping
> > > > to hear more from memcg folks in the above thread. Maybe ping them in that
> > > > thread and continue there?
> > >
> >
> > Hi Roman,
> >
> > > As I said previously, I don't like it, because it's an attempt to solve a non
> > > bpf-specific problem in a bpf-specific way.
> > >
> >
> > Why do you still insist that bpf_map->memcg is not a bpf-specific
> > issue after so many discussions?
> > Do you charge the bpf-map's memory the same way as you charge the page
> > caches or slabs ?
> > No, you don't. You charge it in a bpf-specific way.
>

Hi Roman,

Sorry for the late response.
I've been on vacation in the past few days.

> The only difference is that we charge the cgroup of the processes who
> created a map, not a process who is doing a specific allocation.

This means the bpf-map can be indepent of process, IOW, the memcg of
bpf-map can be indepent of the memcg of the processes.
This is the fundamental difference between bpf-map and page caches, then...

> Your patchset doesn't change this.

We can make this behavior reasonable by introducing an independent
memcg, as what I did in the previous version.

> There are pros and cons with this approach, we've discussed it back
> to the times when bpf memcg accounting was developed. If you want
> to revisit this, it's maybe possible (given there is a really strong and likely
> new motivation appears), but I haven't seen any complaints yet except from you.
>

memcg-base bpf accounting is a new feature, which may not be used widely.

> >
> > > Yes, memory cgroups are not great for accounting of shared resources, it's well
> > > known. This patchset looks like an attempt to "fix" it specifically for bpf maps
> > > in a particular cgroup setup. Honestly, I don't think it's worth the added
> > > complexity. Especially because a similar behaviour can be achieved simple
> > > by placing the task which creates the map into the desired cgroup.
> >
> > Are you serious ?
> > Have you ever read the cgroup doc? Which clearly describe the "No
> > Internal Process Constraint".[1]
> > Obviously you can't place the task in the desired cgroup, i.e. the parent memcg.
>
> But you can place it into another leaf cgroup. You can delete this leaf cgroup
> and your memcg will get reparented. You can attach this process and create
> a bpf map to the parent cgroup before it gets child cgroups.

If the process doesn't exit after it created bpf-map, we have to
migrate it around memcgs....
The complexity in deployment can introduce unexpected issues easily.

> You can revisit the idea of shared bpf maps and outlive specific cgroups.
> Lof of options.
>
> >
> > [1] https://www.kernel.org/doc/Documentation/cgroup-v2.txt
> >
> > > Beatiful? Not. Neither is the proposed solution.
> > >
> >
> > Is it really hard to admit a fault?
>
> Yafang, you posted several versions and so far I haven't seen much of support
> or excitement from anyone (please, fix me if I'm wrong). It's not like I'm
> nacking a patchset with many acks, reviews and supporters.
>
> Still think you're solving an important problem in a reasonable way?
> It seems like not many are convinced yet. I'd recommend to focus on this instead
> of blaming me.
>

The best way so far is to introduce specific memcg for specific resources.
Because not only the process owns its memcg, but also specific
resources own their memcgs, for example bpf-map, or socket.

struct bpf_map {                                 <<<< memcg owner
    struct memcg_cgroup *memcg;
};

struct sock {                                       <<<< memcg owner
    struct mem_cgroup *sk_memcg;
};

These resources already have their own memcgs, so we should make this
behavior formal.

The selectable memcg is just a variant of 'echo ${proc} > cgroup.procs'.

-- 
Regards
Yafang
