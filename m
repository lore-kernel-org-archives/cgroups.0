From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Thu, 13 Feb 2020 16:47:31 +0100
Message-ID: <20200213154731.GE31689@dhcp22.suse.cz>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-4-hannes@cmpxchg.org>
 <20200130170020.GZ24244@dhcp22.suse.cz>
 <20200203215201.GD6380@cmpxchg.org>
 <20200211164753.GQ10636@dhcp22.suse.cz>
 <20200212170826.GC180867@cmpxchg.org>
 <20200213074049.GA31689@dhcp22.suse.cz>
 <20200213135348.GF88887@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200213135348.GF88887@mtj.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu 13-02-20 08:53:48, Tejun Heo wrote:
> Hello, Michal.
> 
> On Thu, Feb 13, 2020 at 08:40:49AM +0100, Michal Hocko wrote:
> > So how are we going to deal with hierarchies where the actual workload
> > of interest is a leaf deeper in the hierarchy and the upper levels of
> > the hierarchy are shared between unrelated workloads?  Look at how
> > systemd organizes system into cgroups for example (slices vs. scopes)
> > and say you want to add a protection to a single user or a service.
> 
> The above scenario where descendants of a cgroup behave unrelated to
> each other sound plausible in theory but doesn't really work in
> practice because memory management is closely tied with IO and all IO
> control mechanisms are strictly hierarchical and arbitrate
> level-by-level.
>
> A workload's memory footprint can't be protected without protecting
> its IOs and a descendant cgroup's IOs can't be protected without
> protecting its ancestors, so implementing that in memory controller in
> isolation, while doable, won't serve many practical purposes. It just
> ends up creating cgroups which are punished on memory while greedly
> burning up IOs.
> 
> The same pattern for CPU control, so for any practical configuration,
> the hierarchy layout has to follow the resource distribution hierarchy
> of the system - it's what the whole thing is for after all. The
> existing memory.min/low semantics is mostly from failing to recognize
> them being closely intertwined with IO and resembling weight based
> control mechanisms, and rather blindly copying memory.high/max
> behaviors, for which, btw, individual configurations may make sense.

Well, I would tend to agree but I can see an existing cgroup hierarchy
imposed by systemd and that is more about "logical" organization of
processes based on their purpose than anything resembling resources.
So what can we do about that to make it all work?
-- 
Michal Hocko
SUSE Labs
