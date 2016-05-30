From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm/memcontrol.c: add memory allocation result check
Date: Mon, 30 May 2016 10:53:11 +0200
Message-ID: <20160530085311.GM22928@dhcp22.suse.cz>
References: <1464597951-2976-1-git-send-email-wwtao0320@163.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1464597951-2976-1-git-send-email-wwtao0320@163.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wenwei Tao <wwtao0320@163.com>
Cc: hannes@cmpxchg.org, vdavydov@virtuozzo.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, ww.tao0320@gmail.com

On Mon 30-05-16 16:45:51, Wenwei Tao wrote:
> From: Wenwei Tao <ww.tao0320@gmail.com>
> 
> The mem_cgroup_tree_per_node allocation might fail,
> check that before continue the memcg init. Since it
> is in the init phase, trigger the panic if that failure
> happens.

We would blow up in the very same function so what is the point of the
explicit BUG_ON?

> Signed-off-by: Wenwei Tao <ww.tao0320@gmail.com>
> ---
>  mm/memcontrol.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 925b431..6385c62 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5712,6 +5712,7 @@ static int __init mem_cgroup_init(void)
>  
>  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
>  				    node_online(node) ? node : NUMA_NO_NODE);
> +		BUG_ON(!rtpn);
>  
>  		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>  			struct mem_cgroup_tree_per_zone *rtpz;
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
