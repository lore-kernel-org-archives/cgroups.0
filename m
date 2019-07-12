From: =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: Re: [PATCH 4/4] numa: introduce numa cling feature
Date: Fri, 12 Jul 2019 11:10:08 +0800
Message-ID: <82f42063-ce51-dd34-ba95-5b32ee733de7@linux.alibaba.com>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
 <9a440936-1e5d-d3bb-c795-ef6f9839a021@linux.alibaba.com>
 <20190711142728.GF3402@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190711142728.GF3402@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Peter Zijlstra <peterz@infradead.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org, keescook@chromium.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, riel@surriel.com



On 2019/7/11 下午10:27, Peter Zijlstra wrote:
[snip]
>> Thus we introduce the numa cling, which try to prevent tasks leaving
>> the preferred node on wakeup fast path.
> 
> 
>> @@ -6195,6 +6447,13 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
>>  	if ((unsigned)i < nr_cpumask_bits)
>>  		return i;
>>
>> +	/*
>> +	 * Failed to find an idle cpu, wake affine may want to pull but
>> +	 * try stay on prev-cpu when the task cling to it.
>> +	 */
>> +	if (task_numa_cling(p, cpu_to_node(prev), cpu_to_node(target)))
>> +		return prev;
>> +
>>  	return target;
>>  }
> 
> Select idle sibling should never cross node boundaries and is thus the
> entirely wrong place to fix anything.

Hmm.. in our early testing the printk show both select_task_rq_fair() and
task_numa_find_cpu() will call select_idle_sibling with prev and target on
different node, thus we pick this point to save few lines.

But if the semantics of select_idle_sibling() is to return cpu on the same
node of target, what about move the logical after select_idle_sibling() for
the two callers?

Regards,
Michael Wang

> 
