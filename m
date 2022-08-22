From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFD RESEND] cgroup: Persistent memory usage tracking
Date: Mon, 22 Aug 2022 17:19:50 -0400
Message-ID: <YwPy9hervVxfuuYE@cmpxchg.org>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
 <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org>
 <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
 <Yv/DK+AGlMeBGkF1@slm.duckdns.org>
 <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>
 <YwNold0GMOappUxc@slm.duckdns.org>
 <CAHS8izNvEpX3Lv7eFn-vu=4ZT96Djk2dU-VU+zOueZaZZbnWNw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=FxIK9S2wTvBehSQmWm4iua73649GO/cf0KFcF96zw1A=;
        b=WnSB6qB0/v5bDg0UBCH8XvyxgD+Go42M4ZW04QIoDlf1WY4R6dUzsRq/FJxljUgvzR
         P8qFnCxXLOwjhK7ac/biGzbje7m4mVABX+7q40/X8QQmMMdbA6H5JXrBHCxVySNiyAPs
         r0/0smN1EzbeaFhpHFykf4O6d1mRCTGlBWWv2uELOaSU/MgujmUXcl5XklPFCiFSh1Pt
         ALTePm2DGoPtixANbDQWxpnEW/X1Jjl9+nVLJQBMSTG0rKcXD4R7LsUwqlw/cXODDTXk
         CfNRxjJ+zttWupmRR1E9wx5X+sZwOtAvDfXvbyKPLJVhlUkJz74jPbl8/iGSz4N4tBc0
         3zPA==
Content-Disposition: inline
In-Reply-To: <CAHS8izNvEpX3Lv7eFn-vu=4ZT96Djk2dU-VU+zOueZaZZbnWNw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: Tejun Heo <tj@kernel.org>, Yafang Shao <laoar.shao@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, john fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, jolsa@kernel.org, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Zefan Li <lizefan.x@bytedance.com>, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Linux

On Mon, Aug 22, 2022 at 12:02:48PM -0700, Mina Almasry wrote:
> On Mon, Aug 22, 2022 at 4:29 AM Tejun Heo <tj@kernel.org> wrote:
> > b. Let userspace specify which cgroup to charge for some of constructs like
> >    tmpfs and bpf maps. The key problems with this approach are
> >
> >    1. How to grant/deny what can be charged where. We must ensure that a
> >       descendant can't move charges up or across the tree without the
> >       ancestors allowing it.
> >
> >    2. How to specify the cgroup to charge. While specifying the target
> >       cgroup directly might seem like an obvious solution, it has a couple
> >       rather serious problems. First, if the descendant is inside a cgroup
> >       namespace, it might be able to see the target cgroup at all. Second,
> >       it's an interface which is likely to cause misunderstandings on how it
> >       can be used. It's too broad an interface.
> >
> 
> This is pretty much the solution I sent out for review about a year
> ago and yes, it suffers from the issues you've brought up:
> https://lore.kernel.org/linux-mm/20211120045011.3074840-1-almasrymina@google.com/
> 
> 
> >    One solution that I can think of is leveraging the resource domain
> >    concept which is currently only used for threaded cgroups. All memory
> >    usages of threaded cgroups are charged to their resource domain cgroup
> >    which hosts the processes for those threads. The persistent usages have a
> >    similar pattern, so maybe the service level cgroup can declare that it's
> >    the encompassing resource domain and the instance cgroup can say whether
> >    it's gonna charge e.g. the tmpfs instance to its own or the encompassing
> >    resource domain.
> >
> 
> I think this sounds excellent and addresses our use cases. Basically
> the tmpfs/bpf memory would get charged to the encompassing resource
> domain cgroup rather than the instance cgroup, making the memory usage
> of the first and second+ instances consistent and predictable.
> 
> Would love to hear from other memcg folks what they would think of
> such an approach. I would also love to hear what kind of interface you
> have in mind. Perhaps a cgroup tunable that says whether it's going to
> charge the tmpfs/bpf instance to itself or to the encompassing
> resource domain?

I like this too. It makes shared charging predictable, with a coherent
resource hierarchy (congruent OOM, CPU, IO domains), and without the
need for cgroup paths in tmpfs mounts or similar.

As far as who is declaring what goes, though: if the instance groups
can declare arbitrary files/objects persistent or shared, they'd be
able to abuse this and sneak private memory past local limits and
burden the wider persistent/shared domain with it.

I'm thinking it might make more sense for the service level to declare
which objects are persistent and shared across instances.

If that's the case, we may not need a two-component interface. Just
the ability for an intermediate cgroup to say: "This object's future
memory is to be charged to me, not the instantiating cgroup."

Can we require a process in the intermediate cgroup to set up the file
or object, and use madvise/fadvise to say "charge me", before any
instances are launched?
