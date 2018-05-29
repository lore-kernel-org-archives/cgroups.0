From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v8 4/6] cpuset: Make generate_sched_domains() recognize
 isolated_cpus
Date: Tue, 29 May 2018 08:27:03 +0200
Message-ID: <20180529062703.GA8985@localhost.localdomain>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-5-git-send-email-longman@redhat.com>
 <20180524102837.GA3948@localhost.localdomain>
 <45d70c88-e9f5-716a-ee9a-33dc111159cc@redhat.com>
 <8e610b98-970c-a309-5821-fc8e6aca892f@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8e610b98-970c-a309-5821-fc8e6aca892f@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 28/05/18 21:24, Waiman Long wrote:
> On 05/28/2018 09:12 PM, Waiman Long wrote:
> > On 05/24/2018 06:28 AM, Juri Lelli wrote:
> >> On 17/05/18 16:55, Waiman Long wrote:
> >>
> >> [...]
> >>
> >>> @@ -849,7 +860,12 @@ static void rebuild_sched_domains_locked(void)
> >>>  	 * passing doms with offlined cpu to partition_sched_domains().
> >>>  	 * Anyways, hotplug work item will rebuild sched domains.
> >>>  	 */
> >>> -	if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
> >>> +	if (!top_cpuset.isolation_count &&
> >>> +	    !cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
> >>> +		goto out;
> >>> +
> >>> +	if (top_cpuset.isolation_count &&
> >>> +	   !cpumask_subset(top_cpuset.effective_cpus, cpu_active_mask))
> >>>  		goto out;
> >> Do we cover the case in which hotplug removed one of the isolated cpus
> >> from cpu_active_mask?
> > Yes, you are right. That is the remnant of my original patch that allows
> > only one isolated_cpus at root. Thanks for spotting that.
> 
> I am sorry. I would like to take it back my previous comment. The code
> above looks for inconsistency in the state of the effective_cpus mask to
> find out if it is racing with a hotplug event. If it is, we can skip the
> domain generation as the hotplug event will do that too. The checks are
> still valid with the current patchset. So I don't think we need to make
> any change here.

Yes, these checks are valid, but don't we also need to check for hotplug
races w.r.t. isolated CPUs (of some other sub domain)?
