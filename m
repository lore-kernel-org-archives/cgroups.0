From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 3/3] mm/memcg: Unify swap and memsw page counters
Date: Mon, 14 Sep 2020 13:54:16 +0200
Message-ID: <20200914115416.GN16999@dhcp22.suse.cz>
References: <20200914024452.19167-1-longman@redhat.com>
 <20200914024452.19167-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200914024452.19167-4-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Roman Gushchin <guro@fb.com>, Yafang Shao <laoar.shao@gmail.com>

On Sun 13-09-20 22:44:52, Waiman Long wrote:
> The swap page counter is v2 only while memsw is v1 only. As v1 and v2
> controllers cannot be active at the same time, there is no point to keep
> both swap and memsw page counters in mem_cgroup. The previous patch has
> made sure that memsw page counter is updated and accessed only when in
> v1 code paths. So it is now safe to alias the v1 memsw page counter to v2
> swap page counter. This saves 14 long's in the size of mem_cgroup. This
> is a saving of 112 bytes for 64-bit archs.

I didn't realize that page_counter is so large.

> While at it, also document which page counters are used in v1 and/or v2.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  include/linux/memcontrol.h | 13 ++++++++-----
>  mm/memcontrol.c            |  3 ---
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index d0b036123c6a..6ef4a552e09d 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -215,13 +215,16 @@ struct mem_cgroup {
>  	struct mem_cgroup_id id;
>  
>  	/* Accounted resources */
> -	struct page_counter memory;
> -	struct page_counter swap;
> +	struct page_counter memory;		/* Both v1 & v2 */
> +
> +	union {
> +		struct page_counter swap;	/* v2 only */
> +		struct page_counter memsw;	/* v1 only */
> +	};
>  
>  	/* Legacy consumer-oriented counters */
> -	struct page_counter memsw;
> -	struct page_counter kmem;
> -	struct page_counter tcpmem;
> +	struct page_counter kmem;		/* v1 only */
> +	struct page_counter tcpmem;		/* v1 only */
>  
>  	/* Range enforcement for interrupt charges */
>  	struct work_struct high_work;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ca36bed588d1..188901f3a3db 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5281,13 +5281,11 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  		memcg->use_hierarchy = true;
>  		page_counter_init(&memcg->memory, &parent->memory);
>  		page_counter_init(&memcg->swap, &parent->swap);
> -		page_counter_init(&memcg->memsw, &parent->memsw);
>  		page_counter_init(&memcg->kmem, &parent->kmem);
>  		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
>  	} else {
>  		page_counter_init(&memcg->memory, NULL);
>  		page_counter_init(&memcg->swap, NULL);
> -		page_counter_init(&memcg->memsw, NULL);
>  		page_counter_init(&memcg->kmem, NULL);
>  		page_counter_init(&memcg->tcpmem, NULL);
>  		/*
> @@ -5416,7 +5414,6 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
>  
>  	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
>  	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
> -	page_counter_set_max(&memcg->memsw, PAGE_COUNTER_MAX);
>  	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
>  	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
>  	page_counter_set_min(&memcg->memory, 0);
> -- 
> 2.18.1

-- 
Michal Hocko
SUSE Labs
