From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH] cpuset: Enforce that a child's cpus must be a subset of
 the parent
Date: Wed, 30 May 2018 16:00:21 +0200
Message-ID: <20180530140021.GF3320@localhost.localdomain>
References: <1527687991-1431-1-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1527687991-1431-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hi,

On 30/05/18 09:46, Waiman Long wrote:
> It was found that the cpuset.cpus could contain CPUs that are not listed
> in their parent's cpu list as shown by the command sequence below:
> 
>   # echo "+cpuset" >cgroup.subtree_control
>   # mkdir g1
>   # echo 0-5 >g1/cpuset.cpus
>   # mkdir g1/g11
>   # echo "+cpuset" > g1/cgroup.subtree_control
>   # echo 6-11 >g1/g11/cpuset.cpus
>   # grep -R . g1 | grep "\.cpus"
>   g1/cpuset.cpus:0-5
>   g1/cpuset.cpus.effective:0-5
>   g1/g11/cpuset.cpus:6-11
>   g1/g11/cpuset.cpus.effective:0-5
> 
> As the intersection of g11's cpus and that of g1 is empty, the effective
> cpus of g11 is just that of g1. The check in update_cpumask() is now
> corrected to make sure that cpus in a child cpus must be a subset of
> its parent's cpus. The error "write error: Invalid argument" will now
> be reported in the above case.
> 
> Reported-by: Juri Lelli <juri.lelli@redhat.com>
> Signed-off-by: Waiman Long <longman@redhat.com>

Looks like it fixes the bug.

Reviewed-and-Tested-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,

- Juri
