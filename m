From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v8 4/6] cpuset: Make generate_sched_domains() recognize
 isolated_cpus
Date: Thu, 24 May 2018 12:28:37 +0200
Message-ID: <20180524102837.GA3948@localhost.localdomain>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-5-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526590545-3350-5-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 17/05/18 16:55, Waiman Long wrote:

[...]

> @@ -849,7 +860,12 @@ static void rebuild_sched_domains_locked(void)
>  	 * passing doms with offlined cpu to partition_sched_domains().
>  	 * Anyways, hotplug work item will rebuild sched domains.
>  	 */
> -	if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
> +	if (!top_cpuset.isolation_count &&
> +	    !cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
> +		goto out;
> +
> +	if (top_cpuset.isolation_count &&
> +	   !cpumask_subset(top_cpuset.effective_cpus, cpu_active_mask))
>  		goto out;

Do we cover the case in which hotplug removed one of the isolated cpus
from cpu_active_mask?
