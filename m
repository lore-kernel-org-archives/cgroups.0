From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm/memcontrol: fix a -Wunused-function warning
Date: Tue, 17 Sep 2019 09:40:03 +0200
Message-ID: <20190917074003.GA17727@dhcp22.suse.cz>
References: <1568648453-5482-1-git-send-email-cai@lca.pw>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1568648453-5482-1-git-send-email-cai@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Mon 16-09-19 11:40:53, Qian Cai wrote:
> mem_cgroup_id_get() was introduced in the commit 73f576c04b94
> ("mm:memcontrol: fix cgroup creation failure after many small jobs").
> 
> Later, it no longer has any user since the commits,
> 
> 1f47b61fb407 ("mm: memcontrol: fix swap counter leak on swapout from offline cgroup")
> 58fa2a5512d9 ("mm: memcontrol: add sanity checks for memcg->id.ref on get/put")
> 
> so safe to remove it.
> 
> Signed-off-by: Qian Cai <cai@lca.pw>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/memcontrol.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 9ec5e12486a7..9a375b376157 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4675,11 +4675,6 @@ static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
>  	}
>  }
>  
> -static inline void mem_cgroup_id_get(struct mem_cgroup *memcg)
> -{
> -	mem_cgroup_id_get_many(memcg, 1);
> -}
> -
>  static inline void mem_cgroup_id_put(struct mem_cgroup *memcg)
>  {
>  	mem_cgroup_id_put_many(memcg, 1);
> -- 
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs
