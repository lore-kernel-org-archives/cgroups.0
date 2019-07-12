From: =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: Re: [PATCH 1/4] numa: introduce per-cgroup numa balancing locality,
 statistic
Date: Fri, 12 Jul 2019 11:15:41 +0800
Message-ID: <f8766405-70f3-71b0-60de-03425350189d@linux.alibaba.com>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
 <3ac9b43a-cc80-01be-0079-df008a71ce4b@linux.alibaba.com>
 <20190711134353.GB3402@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190711134353.GB3402@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Peter Zijlstra <peterz@infradead.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org, keescook@chromium.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, riel@surriel.com



On 2019/7/11 下午9:43, Peter Zijlstra wrote:
> On Wed, Jul 03, 2019 at 11:28:10AM +0800, 王贇 wrote:
>> +#ifdef CONFIG_NUMA_BALANCING
>> +
>> +enum memcg_numa_locality_interval {
>> +	PERCENT_0_29,
>> +	PERCENT_30_39,
>> +	PERCENT_40_49,
>> +	PERCENT_50_59,
>> +	PERCENT_60_69,
>> +	PERCENT_70_79,
>> +	PERCENT_80_89,
>> +	PERCENT_90_100,
>> +	NR_NL_INTERVAL,
>> +};
> 
> That's just daft; why not make 8 equal sized buckets.
> 
>> +struct memcg_stat_numa {
>> +	u64 locality[NR_NL_INTERVAL];
>> +};
> 
>> +	if (remote || local) {
>> +		idx = ((local * 10) / (remote + local)) - 2;
> 
> 		idx = (NR_NL_INTERVAL * local) / (remote + local);

Make sense, we actually want to observe the situation rather than
the ratio itself, will be in next version.

Regards,
Michael Wang

> 
>> +	}
>> +
>> +	rcu_read_lock();
>> +	memcg = mem_cgroup_from_task(p);
>> +	if (idx != -1)
>> +		this_cpu_inc(memcg->stat_numa->locality[idx]);
>> +	rcu_read_unlock();
>> +}
>> +#endif
