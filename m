From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm, memcg: Handle cgroup_disable=memory when getting
 memcg protection
Date: Fri, 1 Feb 2019 08:12:03 +0100
Message-ID: <20190201071203.GD11599@dhcp22.suse.cz>
References: <20190201045711.GA18302@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190201045711.GA18302@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu 31-01-19 23:57:11, Chris Down wrote:
> memcg is NULL if we have CONFIG_MEMCG set, but cgroup_disable=memory on
> the kernel command line.
> 
> Fixes: 8a907cdf0177ab40 ("mm, memcg: proportional memory.{low,min} reclaim")

JFYI this is not a valid sha1. It is from linux next and it will change
with the next linux-next release.

Btw. I still didn't get to look at your patch and I am unlikely to do so
today. I will be offline next week but I will try to get to it after I
get back.

> Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  include/linux/memcontrol.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 290cfbfd60cd..49742489aa56 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -335,6 +335,9 @@ static inline bool mem_cgroup_disabled(void)
>  
>  static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg)
>  {
> +	if (mem_cgroup_disabled())
> +		return 0;
> +
>  	return max(READ_ONCE(memcg->memory.emin), READ_ONCE(memcg->memory.elow));
>  }
>  
> -- 
> 2.20.1

-- 
Michal Hocko
SUSE Labs
