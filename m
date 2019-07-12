From: =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Subject: Re: [PATCH 1/4] numa: introduce per-cgroup numa balancing locality,
 statistic
Date: Fri, 12 Jul 2019 11:43:17 +0800
Message-ID: <b027f9cc-edd2-840c-3829-176a1e298446@linux.alibaba.com>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
 <3ac9b43a-cc80-01be-0079-df008a71ce4b@linux.alibaba.com>
 <20190711134754.GD3402@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190711134754.GD3402@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Peter Zijlstra <peterz@infradead.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org, keescook@chromium.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, riel@surriel.com



On 2019/7/11 下午9:47, Peter Zijlstra wrote:
[snip]
>> +	rcu_read_lock();
>> +	memcg = mem_cgroup_from_task(p);
>> +	if (idx != -1)
>> +		this_cpu_inc(memcg->stat_numa->locality[idx]);
> 
> I thought cgroups were supposed to be hierarchical. That is, if we have:
> 
>           R
> 	 / \
> 	 A
> 	/\
> 	  B
> 	  \
> 	   t1
> 
> Then our task t1 should be accounted to B (as you do), but also to A and
> R.

I get the point but not quite sure about this...

Not like pages there are no hierarchical limitation on locality, also tasks
running in a particular group have no influence to others, not to mention the
extra overhead, does it really meaningful to account the stuff hierarchically?

Regards,
Michael Wang

> 
>> +	rcu_read_unlock();
>> +}
>> +#endif
