From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH bpf-next v1 0/5] bpf: rstat: cgroup hierarchical stats
Date: Fri, 3 Jun 2022 18:22:48 +0200
Message-ID: <20220603162247.GC16134@blackbody.suse.cz>
References: <20220520012133.1217211-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654273369; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t/+AtZ+IDbMv3UT/dcTShtZtPHWiyNk8125DJlO9QaU=;
        b=gMXET3lNPzF+uYOE4KQQ13gAYVSdhjnCHMidX2X6ERv+OQELUk+fiFAs5NMDvVYkmPyj+G
        bDHyo+CLTowgn6Y4QEEVUTMkaSWcM3hnO7cLlI5AclJClQaxevRMRsRNoei+DxSv/BqJEO
        7nQl4ugDZ6y4D/4PlNbi6+FM2AHu8LQ=
Content-Disposition: inline
In-Reply-To: <20220520012133.1217211-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel

Hello Yosry et al.

This is an interesting piece of work, I'll add some questions and
comments.

On Fri, May 20, 2022 at 01:21:28AM +0000, Yosry Ahmed <yosryahmed@google.com> wrote:
> This patch series allows for using bpf to collect hierarchical cgroup
> stats efficiently by integrating with the rstat framework. The rstat
> framework provides an efficient way to collect cgroup stats and
> propagate them through the cgroup hierarchy.

About the efficiency. Do you have any numbers or examples?
IIUC the idea is to utilize the cgroup's rstat subgraph of full tree
when flushing.
I was looking at your selftest example and the measuring hooks call
cgroup_rstat_updated() and they also allocate an entry bpf_map[cg_id].
The flush callback then looks up the cg_id for cgroups in the rstat
subgraph.
(I'm not familiar with bpf_map implementation or performance but I
imagine, you're potentially one step away from erasing bpf_map[cg_id] in
the flush callback.)
It seems to me that you're building a parallel structure (inside
bpf_map(s)) with similar purpose to the rstat subgraph.

So I wonder whether there remains any benefit of coupling this with
rstat?


Also, I'd expect the custom-processed data are useful in the
structured form (within bpf_maps) but then there's the cgroup iter thing
that takes available data and "flattens" them into text files.
I see this was discussed in subthreads already so it's not necessary to
return to it. IIUC you somehow intend to provide the custom info via the
text files. If that's true, I'd include that in the next cover message
(the purpose of the iterator).


> * The second patch adds cgroup_rstat_updated() and cgorup_rstat_flush()
> kfuncs, to allow bpf stat collectors and readers to communicate with rstat.

kfunc means that it can be just called from any BPF program?
(I'm thinking of an unprivileged user who issues cgroup_rstat_updated()
deep down in the hierarchy repeatedly just to "spam" the rstat subgraph
(which slows down flushers above). Arguably, this can be done already
e.g. by causing certain MM events, so I'd like to just clarify if this
can be a new source of such arbitrary updates.)

> * The third patch is actually v2 of a previously submitted patch [1]
> by Hao Luo. We agreed that it fits better as a part of this series. It
> introduces cgroup_iter programs that can dump stats for cgroups to
> userspace.
> v1 - > v2:
> - Getting the cgroup's reference at the time at attaching, instead of
>   at the time when iterating. (Yonghong) (context [1])

I noticed you take the reference to cgroup, that's fine.
But the demo program also accesses via RCU pointers
(memory_subsys_enabled():cgroup->subsys).
Again, my BPF ignorance here, does the iterator framework somehow take
care of RCU locks?


Thanks,
Michal
