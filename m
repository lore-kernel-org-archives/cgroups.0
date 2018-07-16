From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: avoid bothering interrupted task when charge memcg
 in softirq
Date: Mon, 16 Jul 2018 09:58:36 +0200
Message-ID: <20180716075836.GC17280@dhcp22.suse.cz>
References: <1531557122-12540-1-git-send-email-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1531557122-12540-1-git-send-email-laoar.shao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Sat 14-07-18 16:32:02, Yafang Shao wrote:
> try_charge maybe executed in packet receive path, which is in interrupt
> context.
> In this situation, the 'current' is the interrupted task, which may has
> no relation to the rx softirq, So it is nonsense to use 'current'.
> 
> Avoid bothering the interrupted if page_counter_try_charge failes.

I agree with Shakeel that this changelog asks for more information about
"why it matters". Small inconsistencies should be tolerable because the
state we rely on is so rarely set that it shouldn't make a visible
difference in practice.

> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  mm/memcontrol.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 68ef266..13f95db 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2123,6 +2123,9 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto retry;
>  	}
>  
> +	if (in_softirq())
> +		goto nomem;
> +

If anything would it make more sense to use in_interrupt() to be more
bullet proof for future?

>  	/*
>  	 * Unlike in global OOM situations, memcg is not in a physical
>  	 * memory shortage.  Allow dying and OOM-killed tasks to
> -- 
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs
