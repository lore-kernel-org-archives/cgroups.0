From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] memcg: Set memory min, low, high values along with max
Date: Fri, 31 Mar 2023 10:40:39 +0200
Message-ID: <ZCach73AHtwcdbbq@dhcp22.suse.cz>
References: <20230330202232.355471-1-shaun.tancheff@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680252040; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=foIa7jbtP7Rg9nUkM8izU/GS17m8DG7SvLf2kEzCXj4=;
        b=Ofh1tn/+4BxdgIFwxB+zPWOZ1FDU2BYSj6+gQsUMQtDMZRfXKJmcZzd1vUQKh9wFhQi62I
        ihIfOQR90PRlYQM+h2JI9jtMu3KzF5yKXe3VJgsEmoy/XJykJlD/8dQQOO5fQFT7ggJ9cf
        ngQPw1yQGuTFD3kCdBfMpNwRjIzIIvM=
Content-Disposition: inline
In-Reply-To: <20230330202232.355471-1-shaun.tancheff@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shaun Tancheff <shaun.tancheff@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Shaun Tancheff <shaun@tancheff.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "stable @ vger . kernel . org . Shaun Tancheff" <shaun.tancheff@hpe.com>

On Fri 31-03-23 03:22:32, Shaun Tancheff wrote:
> From: Shaun Tancheff <shaun@tancheff.com>
> 
> memcg-v1 does not expose memory min, low, and high.
> 
> These values should to be set to reasonable non-zero values
> when max is set.
> 
> This patch sets them to 10%, 20% and 80% respective to max.
> 
> This fixes an issue with memory pressure with file systems
> do an unbounded high rate of I/O hitting oom.

Cgroup v1 has some inherent issues with the dirty data throttling and
that is a well known problem. Especially when those FS allocations are
GFP_NOFS where we cannot throttle direct in the memory reclaim path (see
shrink_folio_list). There are some hacks^Wworkarounds to help out, e.g.
81a70c21d917 ("mm/cgroup/reclaim: fix dirty pages throttling on cgroup
v1") but the issue is inherent to how v1 operates so nothing will work
100%. A more appropriate way forward is to use v2 instead.

But maybe you are hitting a different problem so please tell us more.

> Signed-off-by: Shaun Tancheff <shaun.tancheff@hpe.com>

min, low and high are v2 concepts and v1 cannot/won't really use them.
Besides that hard coded policies do not belong to the kernel. So no to
this patch. We definitely want to hear more about the underlying problem
and see what we can do about that.

Nacked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/memcontrol.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2eee092f8f11..0f5918d9dd2a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3491,6 +3491,15 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
>  		if (max > counter->max)
>  			enlarge = true;
>  		ret = page_counter_set_max(counter, max);
> +		if (!ret && !memsw) {
> +			unsigned long min = (max / 10) + 1;
> +			unsigned long low = min * 2;
> +			unsigned long high = max - low;
> +
> +			page_counter_set_min(counter, min);
> +			page_counter_set_low(counter, low);
> +			page_counter_set_high(counter, high);
> +		}
>  		mutex_unlock(&memcg_max_mutex);
>  
>  		if (!ret)
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs
