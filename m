From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 6/6] mm, memcg: Prevent mem_cgroup_protected store tearing
Date: Mon, 16 Mar 2020 15:59:23 +0100
Message-ID: <20200316145923.GR11482@dhcp22.suse.cz>
References: <cover.1584034301.git.chris@chrisdown.name>
 <d1e9fbc0379fe8db475d82c8b6fbe048876e12ae.1584034301.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d1e9fbc0379fe8db475d82c8b6fbe048876e12ae.1584034301.git.chris@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu 12-03-20 17:33:16, Chris Down wrote:
> The read side of this is all protected, but we can still tear if
> multiple iterations of mem_cgroup_protected are going at the same time.
> 
> There's some intentional racing in mem_cgroup_protected which is ok, but
> load/store tearing should be avoided.
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kernel-team@fb.com

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 57048a38c75d..e9af606238ab 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6301,8 +6301,8 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>  	}
>  
>  exit:
> -	memcg->memory.emin = emin;
> -	memcg->memory.elow = elow;
> +	WRITE_ONCE(memcg->memory.emin, emin);
> +	WRITE_ONCE(memcg->memory.elow, elow);
>  
>  	if (usage <= emin)
>  		return MEMCG_PROT_MIN;
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs
