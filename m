From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
Date: Wed, 7 Sep 2022 19:43:33 -0700
Message-ID: <CAADnVQJHtY0m5TnFxnn8w3xBUfAGNzbf1HmS3ChqcLJadEYJFg@mail.gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com> <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <YxkVq4S1Eoa4edjZ@P9FQF9L96D.corp.robot.car> <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=1Kp8lVSbVqh0xdCaSGzBnGS0KimrRJEGXexqvO+A61k=;
        b=VU3x/RATySGCqkn35FuoVNPIlVepIfpPqgHywrVV6qyGcNNaafm8aZ8BLY70OtBm8O
         7B2qayTgwJ3sgII+LEWkS6NTw3tVAR1E6MLM0fQeIcQhqPItOa+d/+7V+dCP/Mdq8RgN
         02dVJ/2tCG0NmAFC75e/nIAYNd+tVV8TAOTDpnLEmsm8EVE8OQebqMYLwlUBhIyix0vj
         awJTD1sijvEhwy/eBYewmdFWk4Rhlo/e0CMllu3BEgKQFjY/A6XNhpG6SyJmXW9tgMt7
         GXQZAQdAwX/2KlD+gHx4uBCwhxHE0Zp1cW4rE+kqQkCLH54uuYRLqZbMrlkVhwbnKKPF
         AINg==
In-Reply-To: <CALOAHbAp=g20rL0taUpQmTwymanArhO-u69Xw42s5ap39Esn=A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Tejun Heo <tj@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, john fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Zefan Li <lizefan.x@bytedance.com>, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Wed, Sep 7, 2022 at 7:37 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On Thu, Sep 8, 2022 at 6:29 AM Roman Gushchin <roman.gushchin@linux.dev> wrote:
> >
> > On Wed, Sep 07, 2022 at 05:43:31AM -1000, Tejun Heo wrote:
> > > Hello,
> > >
> > > On Fri, Sep 02, 2022 at 02:29:50AM +0000, Yafang Shao wrote:
> > > ...
> > > > This patchset tries to resolve the above two issues by introducing a
> > > > selectable memcg to limit the bpf memory. Currently we only allow to
> > > > select its ancestor to avoid breaking the memcg hierarchy further.
> > > > Possible use cases of the selectable memcg as follows,
> > >
> > > As discussed in the following thread, there are clear downsides to an
> > > interface which requires the users to specify the cgroups directly.
> > >
> > >  https://lkml.kernel.org/r/YwNold0GMOappUxc@slm.duckdns.org
> > >
> > > So, I don't really think this is an interface we wanna go for. I was hoping
> > > to hear more from memcg folks in the above thread. Maybe ping them in that
> > > thread and continue there?
> >
>
> Hi Roman,
>
> > As I said previously, I don't like it, because it's an attempt to solve a non
> > bpf-specific problem in a bpf-specific way.
> >
>
> Why do you still insist that bpf_map->memcg is not a bpf-specific
> issue after so many discussions?
> Do you charge the bpf-map's memory the same way as you charge the page
> caches or slabs ?
> No, you don't. You charge it in a bpf-specific way.
>
> > Yes, memory cgroups are not great for accounting of shared resources, it's well
> > known. This patchset looks like an attempt to "fix" it specifically for bpf maps
> > in a particular cgroup setup. Honestly, I don't think it's worth the added
> > complexity. Especially because a similar behaviour can be achieved simple
> > by placing the task which creates the map into the desired cgroup.
>
> Are you serious ?
> Have you ever read the cgroup doc? Which clearly describe the "No
> Internal Process Constraint".[1]
> Obviously you can't place the task in the desired cgroup, i.e. the parent memcg.
>
> [1] https://www.kernel.org/doc/Documentation/cgroup-v2.txt
>
> > Beatiful? Not. Neither is the proposed solution.
> >
>
> Is it really hard to admit a fault?

Yafang,

This attitude won't get you anywhere.

Selecting memcg by fd is no go.
You need to work with the community to figure out a solution
acceptable to maintainers of relevant subsystems.
