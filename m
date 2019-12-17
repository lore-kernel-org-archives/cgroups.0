From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under
 CONFIG_MMU
Date: Tue, 17 Dec 2019 10:53:29 +0100
Message-ID: <20191217095329.GD31063@dhcp22.suse.cz>
References: <87fthjh2ib.wl-kuninori.morimoto.gx@renesas.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87fthjh2ib.wl-kuninori.morimoto.gx@renesas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue 17-12-19 15:47:40, Kuninori Morimoto wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> mem_cgroup_id_get_many() is used under CONFIG_MMU.

Not really. It is used when SWAP is enabled currently. But it is not
really bound to the swap functionality by any means. It just happens
that we do not have other users currently. We might put it under
CONFIG_SWAP but I do not really think it is a big improvement.

> This patch moves it to under CONFIG_MMU.
> We will get below warning without this patch
> if .config doesn't have CONFIG_MMU.
> 
> 	LINUX/mm/memcontrol.c:4814:13: warning: 'mem_cgroup_id_get_many'\
> 		defined but not used [-Wunused-function]
> 	static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
> 	^~~~~~~~~~~~~~~~~~~~~~

Is this warning really a big deal? The function is not used, alright,
and the compiler will likely just drop it.

> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> ---
>  mm/memcontrol.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c5b5f74..8a157ef 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4811,11 +4811,6 @@ static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
>  	}
>  }
>  
> -static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
> -{
> -	refcount_add(n, &memcg->id.ref);
> -}
> -
>  static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
>  {
>  	if (refcount_sub_and_test(n, &memcg->id.ref)) {
> @@ -5153,6 +5148,11 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
>  }
>  
>  #ifdef CONFIG_MMU
> +static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
> +{
> +	refcount_add(n, &memcg->id.ref);
> +}
> +
>  /* Handlers for move charge at task migration. */
>  static int mem_cgroup_do_precharge(unsigned long count)
>  {
> -- 
> 2.7.4

-- 
Michal Hocko
SUSE Labs
