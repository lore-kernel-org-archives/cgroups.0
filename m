From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v8 3/6] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Thu, 24 May 2018 17:16:56 +0200
Message-ID: <20180524151656.GD3948@localhost.localdomain>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-4-git-send-email-longman@redhat.com>
 <20180524143614.GC3948@localhost.localdomain>
 <4bd31510-4f73-e263-8dc1-5edb0fe63b59@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4bd31510-4f73-e263-8dc1-5edb0fe63b59@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 24/05/18 11:09, Waiman Long wrote:
> On 05/24/2018 10:36 AM, Juri Lelli wrote:
> > On 17/05/18 16:55, Waiman Long wrote:
> >
> > [...]
> >
> >> +	A parent cgroup cannot distribute all its CPUs to child
> >> +	scheduling domain cgroups unless its load balancing flag is
> >> +	turned off.
> >> +
> >> +  cpuset.sched.load_balance
> >> +	A read-write single value file which exists on non-root
> >> +	cpuset-enabled cgroups.  It is a binary value flag that accepts
> >> +	either "0" (off) or a non-zero value (on).  This flag is set
> >> +	by the parent and is not delegatable.
> >> +
> >> +	When it is on, tasks within this cpuset will be load-balanced
> >> +	by the kernel scheduler.  Tasks will be moved from CPUs with
> >> +	high load to other CPUs within the same cpuset with less load
> >> +	periodically.
> >> +
> >> +	When it is off, there will be no load balancing among CPUs on
> >> +	this cgroup.  Tasks will stay in the CPUs they are running on
> >> +	and will not be moved to other CPUs.
> >> +
> >> +	The initial value of this flag is "1".	This flag is then
> >> +	inherited by child cgroups with cpuset enabled.  Its state
> >> +	can only be changed on a scheduling domain cgroup with no
> >> +	cpuset-enabled children.
> > [...]
> >
> >> +	/*
> >> +	 * On default hierachy, a load balance flag change is only allowed
> >> +	 * in a scheduling domain with no child cpuset.
> >> +	 */
> >> +	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) && balance_flag_changed &&
> >> +	   (!is_sched_domain(cs) || css_has_online_children(&cs->css))) {
> >> +		err = -EINVAL;
> >> +		goto out;
> >> +	}
> > The rule is actually
> >
> >  - no child cpuset
> >  - and it must be a scheduling domain
> >
> > Right?
> 
> Yes, because it doesn't make sense to have a cpu in one cpuset that has
> loading balance off while, at the same time, in another cpuset with load
> balancing turned on. This restriction is there to make sure that the
> above condition will not happen. I may be wrong if there is a realistic
> use case where the above condition is desired.

Yep, makes sense to me.

Maybe add the second condition to the comment and documentation.
