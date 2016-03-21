From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/5] mm: memcontrol: Remove redundant hot plug notifier
 test.
Date: Mon, 21 Mar 2016 09:17:17 +0100
Message-ID: <20160321081717.GA21248@dhcp22.suse.cz>
References: <1458336371-17748-1-git-send-email-rcochran@linutronix.de>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1458336371-17748-1-git-send-email-rcochran@linutronix.de>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Cochran <rcochran@linutronix.de>
Cc: linux-kernel@vger.kernel.org, rt@linutronix.de, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, cgroups@vger.kernel.org, linux-mm@kvack.org

On Fri 18-03-16 22:26:07, Richard Cochran wrote:
> The test for ONLINE is redundant because the following test for !DEAD
> already includes the online case.  This patch removes the superfluous
> code.

The code used to do something specific to CPU_ONLINE in the past but now
it really seems to be pointless and maybe even confusing. All we really
care here is when the cpu goes down and we need to drain per-cpu cached
charges.

> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Signed-off-by: Richard Cochran <rcochran@linutronix.de>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks

> ---
>  mm/memcontrol.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d06cae2..993a261 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1916,9 +1916,6 @@ static int memcg_cpu_hotplug_callback(struct notifier_block *nb,
>  	int cpu = (unsigned long)hcpu;
>  	struct memcg_stock_pcp *stock;
>  
> -	if (action == CPU_ONLINE)
> -		return NOTIFY_OK;
> -
>  	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
>  		return NOTIFY_OK;
>  
> -- 
> 2.1.4

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
