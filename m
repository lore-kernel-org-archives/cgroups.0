From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/11] Manage the top tier memory in a tiered memory
Date: Mon, 12 Apr 2021 12:20:22 -0700
Message-ID: <CALvZod4zXB6-3Mshu_TnTsQaDErfYkPTw9REYNRptSvPSRmKVA@mail.gmail.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
 <YGwlGrHtDJPQF7UG@dhcp22.suse.cz> <c615a610-eb4b-7e1e-16d1-4bc12938b08a@linux.intel.com>
 <YG7ugXZZ9BcXyGGk@dhcp22.suse.cz> <58e5dcc9-c134-78de-6965-7980f8596b57@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=njLi9+INls9UJu6xo/OSSkdSSq3w2QSnMYDEcop1v+w=;
        b=E6Csoera0jTVwBjqvhuypbBsJEYw/+XzR+REf5XoXOCW9nP2fSC/MJcGVjsDnKa90T
         bk1YHPdwhSkhmjMzdnOnZOJWy/R8XS/WHmV61w9P+OwAyU46e7LrRdhPgfrb+v1IMfRU
         f2nUnjawlUJ+FaLhWS9x3b4/VZbxb7T/ou4E/fqqZqi/7C4RaudewxQdsCBggHQUvsnE
         yKaZNFtbZtIKwo9Gi03kxEFbuSaK+cfntXwPznqzcJz1p6Mir6oOeWJ2RFqqINVWeJ9D
         gqA+lMxXvj9aQFgW5DjHDQQexEHddJrpScogfSMuuD83sWwwzty18aqMU61BOw130fsI
         nzpg==
In-Reply-To: <58e5dcc9-c134-78de-6965-7980f8596b57-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Apr 9, 2021 at 4:26 PM Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>
>
> On 4/8/21 4:52 AM, Michal Hocko wrote:
>
> >> The top tier memory used is reported in
> >>
> >> memory.toptier_usage_in_bytes
> >>
> >> The amount of top tier memory usable by each cgroup without
> >> triggering page reclaim is controlled by the
> >>
> >> memory.toptier_soft_limit_in_bytes
> >
>
> Michal,
>
> Thanks for your comments.  I will like to take a step back and
> look at the eventual goal we envision: a mechanism to partition the
> tiered memory between the cgroups.
>
> A typical use case may be a system with two set of tasks.
> One set of task is very latency sensitive and we desire instantaneous
> response from them. Another set of tasks will be running batch jobs
> were latency and performance is not critical.   In this case,
> we want to carve out enough top tier memory such that the working set
> of the latency sensitive tasks can fit entirely in the top tier memory.
> The rest of the top tier memory can be assigned to the background tasks.
>
> To achieve such cgroup based tiered memory management, we probably want
> something like the following.
>
> For generalization let's say that there are N tiers of memory t_0, t_1 ... t_N-1,
> where tier t_0 sits at the top and demotes to the lower tier.
> We envision for this top tier memory t0 the following knobs and counters
> in the cgroup memory controller
>
> memory_t0.current       Current usage of tier 0 memory by the cgroup.
>
> memory_t0.min           If tier 0 memory used by the cgroup falls below this low
>                         boundary, the memory will not be subjected to demotion
>                         to lower tiers to free up memory at tier 0.
>
> memory_t0.low           Above this boundary, the tier 0 memory will be subjected
>                         to demotion.  The demotion pressure will be proportional
>                         to the overage.
>
> memory_t0.high          If tier 0 memory used by the cgroup exceeds this high
>                         boundary, allocation of tier 0 memory by the cgroup will
>                         be throttled. The tier 0 memory used by this cgroup
>                         will also be subjected to heavy demotion.
>
> memory_t0.max           This will be a hard usage limit of tier 0 memory on the cgroup.
>
> If needed, memory_t[12...].current/min/low/high for additional tiers can be added.
> This follows closely with the design of the general memory controller interface.
>
> Will such an interface looks sane and acceptable with everyone?
>

I have a couple of questions. Let's suppose we have a two socket
system. Node 0 (DRAM+CPUs), Node 1 (DRAM+CPUs), Node 2 (PMEM on socket
0 along with Node 0) and Node 3 (PMEM on socket 1 along with Node 1).
Based on the tier definition of this patch series, tier_0: {node_0,
node_1} and tier_1: {node_2, node_3}.

My questions are:

1) Can we assume that the cost of access within a tier will always be
less than the cost of access from the tier? (node_0 <-> node_1 vs
node_0 <-> node_2)
2) If yes to (1), is that assumption future proof? Will the future
systems with DRAM over CXL support have the same characteristics?
3) Will the cost of access from tier_0 to tier_1 be uniform? (node_0
<-> node_2 vs node_0 <-> node_3). For jobs running on node_0, node_3
might be third tier and similarly for jobs running on node_1, node_2
might be third tier.

The reason I am asking these questions is that the statically
partitioning memory nodes into tiers will inherently add platform
specific assumptions in the user API.

Assumptions like:
1) Access within tier is always cheaper than across tier.
2) Access from tier_i to tier_i+1 has uniform cost.

The reason I am more inclined towards having numa centric control is
that we don't have to make these assumptions. Though the usability
will be more difficult. Greg (CCed) has some ideas on making it better
and we will share our proposal after polishing it a bit more.
