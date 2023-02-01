From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 2/2] cpuset: Call set_cpus_allowed_ptr() with appropriate
 mask for task
Date: Wed, 1 Feb 2023 10:03:27 -0500
Message-ID: <2d450978-5d7d-9a21-adf9-2fdb2bb512a5@redhat.com>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-3-will@kernel.org>
 <66cdf2e8-f1aa-5dfe-cd2e-0e37dc0ae799@redhat.com>
 <Y9otsg1ihF3LH2vG@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675263815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSFGQnJKj8/Bp7/utfIPR5eu4HZIdNy/TbWIaePtzGs=;
        b=Ig4bJrGmIRHb7ZgcaPBaK2dRc552ahDMY6SUM0W8gR6GzoL2PwhKzn/NeicyrD1mp0PzZ/
        DhHS9UZCsZOWy7oP7yqjLQkqHGjoeOZ1d1/ub7NB9i12yM6Pw8tYvSIw181R5g4BcWp2FZ
        DQgfOsuFHwPf5+/1jrcMN1OKhhe4gXY=
Content-Language: en-US
In-Reply-To: <Y9otsg1ihF3LH2vG@hirez.programming.kicks-ass.net>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, kernel-team@android.com, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

On 2/1/23 04:15, Peter Zijlstra wrote:
> On Tue, Jan 31, 2023 at 09:22:44PM -0500, Waiman Long wrote:
>> On 1/31/23 17:17, Will Deacon wrote:
>>> set_cpus_allowed_ptr() will fail with -EINVAL if the requested
>>> affinity mask is not a subset of the task_cpu_possible_mask() for the
>>> task being updated. Consequently, on a heterogeneous system with cpusets
>>> spanning the different CPU types, updates to the cgroup hierarchy can
>>> silently fail to update task affinities when the effective affinity
>>> mask for the cpuset is expanded.
>>>
>>> For example, consider an arm64 system with 4 CPUs, where CPUs 2-3 are
>>> the only cores capable of executing 32-bit tasks. Attaching a 32-bit
>>> task to a cpuset containing CPUs 0-2 will correctly affine the task to
>>> CPU 2. Extending the cpuset to CPUs 0-3, however, will fail to extend
>>> the affinity mask of the 32-bit task because update_tasks_cpumask() will
>>> pass the full 0-3 mask to set_cpus_allowed_ptr().
>>>
>>> Extend update_tasks_cpumask() to take a temporary 'cpumask' paramater
>>> and use it to mask the 'effective_cpus' mask with the possible mask for
>>> each task being updated.
>>>
>>> Fixes: 431c69fac05b ("cpuset: Honour task_cpu_possible_mask() in guarantee_online_cpus()")
>>> Signed-off-by: Will Deacon <will@kernel.org>
>>> ---
>>>
>>> Note: We wondered whether it was worth calling guarantee_online_cpus()
>>> if the cpumask_and() returns 0 in update_tasks_cpumask(), but given that
>>> this path is only called when the effective mask changes, it didn't
>>> seem appropriate. Ultimately, if you have 32-bit tasks attached to a
>>> cpuset containing only 64-bit cpus, then the affinity is going to be
>>> forced.
>> Now I see how the sched_setaffinity() change is impacting arm64. Instead of
>> putting in the bandage in cpuset. I would suggest doing another cpu masking
>> in __set_cpus_allowed_ptr() similar to what is now done for user_cpus_ptr.
> NO! cpuset is *BROKEN* it has been for a while, it needs to get fixed.
>
> Masking the offline CPUs is *WRONG*.
>
This patch is not related to offline cpus at all. It is all about the 
32-bit misfit cpus in some arm64 system.

Cheers,
Longman

