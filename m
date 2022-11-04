From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v9 3/3] blk-cgroup: Flush stats at blkgs destruction path
Date: Fri, 4 Nov 2022 16:12:05 -0400
Message-ID: <84fd6656-d133-b9df-c39e-fbb3a1f4a873@redhat.com>
References: <20221104182050.342908-1-longman@redhat.com>
 <20221104182050.342908-4-longman@redhat.com>
 <Y2VvboMSxgF0pYpX@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667592728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mVw++WwNRhJv9XuMMPj7SE5JUR1Vsk4jmONPY9jqoLM=;
        b=OmzSpm4lAVyhtDUBwbxA194BFPpi5XPzujj6IxUDPKTycsN8stCZYEZu1ICTErl6Bb3fcN
        7iyJwo5NxzaeSj6tqze4t5F/x7AOKN74V0OTtLREK8CTvH8TVH88B/3hhZLUILzIDbgb4J
        M/+MR08cK+zxJH4/xV8EHlqjBa0OjXo=
Content-Language: en-US
In-Reply-To: <Y2VvboMSxgF0pYpX@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>

On 11/4/22 16:00, Tejun Heo wrote:
> On Fri, Nov 04, 2022 at 02:20:50PM -0400, Waiman Long wrote:
>> +/**
>> + * cgroup_rstat_css_flush - flush stats for the given css and cpu
>> + * @css: target css to be flush
>> + * @cpu: the cpu that holds the stats to be flush
>> + *
>> + * A lightweight rstat flush operation for a given css and cpu.
>> + * Only the cpu_lock is being held for mutual exclusion, the cgroup_rstat_lock
>> + * isn't used.
>> + */
>> +void cgroup_rstat_css_flush(struct cgroup_subsys_state *css, int cpu)
>> +{
>> +	raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
>> +
>> +	raw_spin_lock_irq(cpu_lock);
>> +	rcu_read_lock();
>> +	css->ss->css_rstat_flush(css, cpu);
>> +	rcu_read_unlock();
>> +	raw_spin_unlock_irq(cpu_lock);
>> +}
> Would it make sense to itereate CPUs within the helper rather than asking
> the caller to do it? Also, in terms of patch sequencing, this introduces a
> bug and then fixes it. Prolly better to not introduce the bug in the first
> place.
>
> Thanks.

I should have named the function cgroup_rstat_css_cpu_flush() to 
indicate that the cpu is a needed parameter. We can have a 
cgroup_rstat_css_flush() in the future if the need arises.

It is an optimization to call this function only if the corresponding 
cpu has a pending lockless list. I could do cpu iteration here and call 
the flushing function for all the CPUs. It is less optimized this way. 
Since it is a slow path, I guess performance is not that critical. So I 
can go either way. Please let me know your preference.

Thanks,
Longman

