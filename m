From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] memcg: fix stale mem_cgroup_force_empty() comment
Date: Tue, 10 May 2016 09:28:37 +0200
Message-ID: <20160510072837.GC23576@dhcp22.suse.cz>
References: <1462569810-54496-1-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462569810-54496-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri 06-05-16 14:23:30, Greg Thelen wrote:
> commit f61c42a7d911 ("memcg: remove tasks/children test from
> mem_cgroup_force_empty()") removed memory reparenting from the function.
> 
> Fix the function's comment.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/memcontrol.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fe787f5c41bd..19fd76168a05 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2636,8 +2636,7 @@ static inline bool memcg_has_children(struct mem_cgroup *memcg)
>  }
>  
>  /*
> - * Reclaims as many pages from the given memcg as possible and moves
> - * the rest to the parent.
> + * Reclaims as many pages from the given memcg as possible.
>   *
>   * Caller is responsible for holding css reference for memcg.
>   */
> -- 
> 2.8.0.rc3.226.g39d4020

-- 
Michal Hocko
SUSE Labs
