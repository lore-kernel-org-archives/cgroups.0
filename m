From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm, memcg: fix mem_cgroup_swapout() for THPs
Date: Tue, 28 Nov 2017 21:00:05 +0100
Message-ID: <20171128200005.67grhk2arm2ivgug@dhcp22.suse.cz>
References: <20171128161941.20931-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171128161941.20931-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Huang Ying <ying.huang@intel.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org

On Tue 28-11-17 08:19:41, Shakeel Butt wrote:
> The commit d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout()
> support THP") changed mem_cgroup_swapout() to support transparent huge
> page (THP). However the patch missed one location which should be
> changed for correctly handling THPs. The resulting bug will cause the
> memory cgroups whose THPs were swapped out to become zombies on
> deletion.

Very well spotted! Have you seen this triggering or you found it by the
code inspection?

> Fixes: d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout() support THP")

To be honest I am not really happy how the whole THP swapout thing has
been rushed in without a proper review. I am partly guildy for not find
time for the proper review but this is not something that really had to
be merged without a single ack or reviewed-by.

> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: stable@vger.kernel.org

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 50e6906314f8..ac2ffd5e02b9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6044,7 +6044,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
>  	memcg_check_events(memcg, page);
>  
>  	if (!mem_cgroup_is_root(memcg))
> -		css_put(&memcg->css);
> +		css_put_many(&memcg->css, nr_entries);
>  }
>  
>  /**
> -- 
> 2.15.0.417.g466bffb3ac-goog

-- 
Michal Hocko
SUSE Labs
