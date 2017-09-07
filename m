From: Prateek Sood <prsood@codeaurora.org>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Thu, 7 Sep 2017 14:35:06 +0530
Message-ID: <48cd3692-59fa-4e80-6aa5-25293f0fe113@codeaurora.org>
References: <1504764252-29091-1-git-send-email-prsood@codeaurora.org>
 <20170907072848.2sjjddwincaeplju@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504775120;
        bh=6Ba81eAyPpK1GgTA1Zq/m3+EdeW/yLYc6XH3AN4Gn5Y=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=Uc96osgdTORJnBradO3E0VqIgW3hBtGkswhAQDPCO211z+K4irdvwxK+FoQmXxUcu
         1HxV/jqeLSFM2derzbtXkg0T586XKvXNB262bsQrFXlHoTgjsdOCLf0kXbb4lhamnM
         v82D+lfuhQMhrf9r9yALeUciIAzZf07aXYG9pVMw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504775119;
        bh=6Ba81eAyPpK1GgTA1Zq/m3+EdeW/yLYc6XH3AN4Gn5Y=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=iVy7fNAMZKH/EELVLFHcQFOTn3FQdr0UU5tRS0xSuUSDwSQtN7Fu2Wczxuawl/JoT
         O5qW8cVwbYRZtzEDp9MpTNsH9668utpOVhGNoXOTqKNT9B1MBdXV5tuU5D0FzJM6oz
         MJgVDuHN5Ge/YEFAT7nak1EO4x7ku+jWV5o2ugjs=
In-Reply-To: <20170907072848.2sjjddwincaeplju@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, mingo@kernel.org, longman@redhat.com, linux-kernel@vger.kernel.org, sramana@codeaurora.org, Thomas Gleixner <tglx@linutronix.de>

On 09/07/2017 12:58 PM, Peter Zijlstra wrote:
> On Thu, Sep 07, 2017 at 11:34:12AM +0530, Prateek Sood wrote:
>> Remove circular dependency deadlock in a scenario where hotplug of CPU is
>> being done while there is updation in cgroup and cpuset triggered from
>> userspace.
>>
>> Example scenario:
>> kworker/0:0 => kthreadd => init:729 => init:1 => kworker/0:0
>>
>> kworker/0:0 - percpu_down_write(&cpu_hotplug_lock)  [held]
>>               flush(work)   [no high prio workqueue available on CPU]
>>               wait_for_completion()
>>
>> kthreadd    - percpu_down_read(cgroup_threadgroup_rwsem)  [waiting]
>>
>> init:729    - percpu_down_write(cgroup_threadgroup_rwsem)   [held]
>>               lock(cpuset_mutex)   [waiting]
>>
>> init:1      - lock(cpuset_mutex)   [held]
>>               percpu_down_read(&cpu_hotplug_lock)   [waiting]
> 
> That's both unreadable and useless :/ You want to tell what code paths
> that were, not which random tasks happened to run them.
> 
> 
> 
>> Eliminate this dependecy by reordering locking of cpuset_mutex
>> and cpu_hotplug_lock in following order
>> 1. Acquire cpu_hotplug_lock (read)
>> 2. Acquire cpuset_mutex
>>
>> Signed-off-by: Prateek Sood <prsood@codeaurora.org>
>> ---
>>  kernel/cgroup/cpuset.c | 70 +++++++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 61 insertions(+), 9 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 2f4039b..687be57 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -843,10 +843,41 @@ static void rebuild_sched_domains_locked(void)
>>  out:
>>  	put_online_cpus();
>>  }
>> +
>> +/*
>> + * Rebuild scheduler domains.
>> + * Call with following lock held in the order
>> + * 1. cpu_hotplug_lock (read)
>> + * 2. cpuset_mutex
> 
> Do not put that in comments, nobody ever reads comments.
> 
>> + */
>> +static void rebuild_sched_domains_unlocked(void)
> 
> The common postfix for a function called with the cpuhotplug lock held
> is: _cpuslocked()
> 
>> +{
>> +        struct sched_domain_attr *attr;
>> +        cpumask_var_t *doms;
>> +        int ndoms;
> 
> 	lockdep_assert_cpus_held();
> 	lockdep_assert_held(&cpuset_mutex);
> 
>> +
>> +        /*
>> +         * We have raced with CPU hotplug. Don't do anything to avoid
>> +         * passing doms with offlined cpu to partition_sched_domains().
>> +         * Anyways, hotplug work item will rebuild sched domains.
>> +         */
>> +        if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
>> +                return;
>> +
>> +        /* Generate domain masks and attrs */
>> +        ndoms = generate_sched_domains(&doms, &attr);
>> +
>> +        /* Have scheduler rebuild the domains */
>> +        partition_sched_domains(ndoms, doms, attr);
>> +}
> 
> And you couldn't come up with a way to share _anything_ with the
> existing rebuild_sched_domains_locked() function?
> 
> *sigh*.. please try again.
> 

Thanks for the suggestion Peter, I will resend the patch

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
