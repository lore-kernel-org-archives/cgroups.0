From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
Date: Thu, 8 Sep 2022 10:48:03 +0800
Message-ID: <CALOAHbAwvPFp6F8BXjzTeNnL7rT+LfA6_yoCY5sLO9VVkjXONA@mail.gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com> <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <YxkVq4S1Eoa4edjZ@P9FQF9L96D.corp.robot.car> <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
 <CAADnVQJHtY0m5TnFxnn8w3xBUfAGNzbf1HmS3ChqcLJadEYJFg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=S007uhudJiEUSw5VwxgkV7xB4iqXJLx8bGrjx4fe7Ec=;
        b=Wynxkd/Lh2b+ogTbqK96/Gt6zE8OZeDngoOQzpEIsMlpgLwgwooTbQV5YtjXg+k+43
         UspSoj/yZnUA2/GoXB9T2DiNXkYLbKF4nXr6Ui8BwkpzIXGa9GwJq+SrJNBX7i2yXbdg
         BfpSllT6UIpzwxu9DLlXK9/1LAXbzA0p4z7ahPmrQIzQB2ovJI9+TvXYJE2+FKSvAGjQ
         3GXNk8TxFQMKZ3d93OIEUlyB05I+Uvqq/2ynKBJCQWJkYwwRYWpoewHgCVzlHSaru083
         ACQrWwhViZfE479uxHlF7W8EID7aiLjo/amxw7glHDaVnxPhJivreP+95GHsAcfCSsJW
         Y3hg==
In-Reply-To: <CAADnVQJHtY0m5TnFxnn8w3xBUfAGNzbf1HmS3ChqcLJadEYJFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, john fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 8, 2022 at 10:43 AM Alexei Starovoitov
<alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Wed, Sep 7, 2022 at 7:37 PM Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
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
> >
> > [1] https://www.kernel.org/doc/Documentation/cgroup-v2.txt
> >
> > > Beatiful? Not. Neither is the proposed solution.
> > >
> >
> > Is it really hard to admit a fault?
>
> Yafang,
>
> This attitude won't get you anywhere.
>

Thanks for pointing it out. It is my fault.

> Selecting memcg by fd is no go.
> You need to work with the community to figure out a solution
> acceptable to maintainers of relevant subsystems.

Yes, I'm trying.

-- 
Regards
Yafang
