From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] numa: introduce per-cgroup numa balancing locality,
 statistic
Date: Thu, 11 Jul 2019 15:47:54 +0200
Message-ID: <20190711134754.GD3402@hirez.programming.kicks-ass.net>
References: <209d247e-c1b2-3235-2722-dd7c1f896483@linux.alibaba.com>
 <60b59306-5e36-e587-9145-e90657daec41@linux.alibaba.com>
 <3ac9b43a-cc80-01be-0079-df008a71ce4b@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=B8VPRtxAaRavzdJXhPNGPP7MJxy27D2BMEVGhwTkA7Q=; b=c8TzrwqUlt9qDq7vFPYtRVBn3H
        DJX6fm8LSxp8r//78fWYTug6IOIH6geBZYWoJ4TYpizO7Auf6N1pg/+wvb4w6DAM26YzLByT0MSgp
        evUPeJbSWAr5lJfEkWgcdX5J6Bhvf07xqbmj4/m9aTNZPLqXkp1S/1U+lAW3vBOvW0lDdC0zCdz/v
        Lye8AT85BM2UXm31VdG3JBET4bqv6lc4kHnFgc3kqhq/OYyHtZiHN8dYc9gaJEqZToVuPqSSgsdnT
        o6zqNnzdwABf4sX+eyYJckTDkvRP0lDq06+zAaJg0KxKy/92maynHWSddc2vAVyq71sQHEn1aeW9y
Content-Disposition: inline
In-Reply-To: <3ac9b43a-cc80-01be-0079-df008a71ce4b@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org, keescook@chromium.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, riel@surriel.com

On Wed, Jul 03, 2019 at 11:28:10AM +0800, 王贇 wrote:

> @@ -3562,10 +3563,53 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
>  		seq_putc(m, '\n');
>  	}
> 
> +#ifdef CONFIG_NUMA_BALANCING
> +	seq_puts(m, "locality");
> +	for (nr = 0; nr < NR_NL_INTERVAL; nr++) {
> +		int cpu;
> +		u64 sum = 0;
> +
> +		for_each_possible_cpu(cpu)
> +			sum += per_cpu(memcg->stat_numa->locality[nr], cpu);
> +
> +		seq_printf(m, " %u", jiffies_to_msecs(sum));
> +	}
> +	seq_putc(m, '\n');
> +#endif
> +
>  	return 0;
>  }
>  #endif /* CONFIG_NUMA */
> 
> +#ifdef CONFIG_NUMA_BALANCING
> +
> +void memcg_stat_numa_update(struct task_struct *p)
> +{
> +	struct mem_cgroup *memcg;
> +	unsigned long remote = p->numa_faults_locality[3];
> +	unsigned long local = p->numa_faults_locality[4];
> +	unsigned long idx = -1;
> +
> +	if (mem_cgroup_disabled())
> +		return;
> +
> +	if (remote || local) {
> +		idx = ((local * 10) / (remote + local)) - 2;
> +		/* 0~29% in one slot for cache align */
> +		if (idx < PERCENT_0_29)
> +			idx = PERCENT_0_29;
> +		else if (idx >= NR_NL_INTERVAL)
> +			idx = NR_NL_INTERVAL - 1;
> +	}
> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_task(p);
> +	if (idx != -1)
> +		this_cpu_inc(memcg->stat_numa->locality[idx]);

I thought cgroups were supposed to be hierarchical. That is, if we have:

          R
	 / \
	 A
	/\
	  B
	  \
	   t1

Then our task t1 should be accounted to B (as you do), but also to A and
R.

> +	rcu_read_unlock();
> +}
> +#endif
