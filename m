From: Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC][PATCH 3/3] replace mem_cgroup_disabled
Date: Wed, 23 Nov 2011 08:43:15 -0200
Message-ID: <4ECCCE43.9090904@parallels.com>
References: <20111123172840.acd53c41.kamezawa.hiroyu@jp.fujitsu.com> <20111123173421.39c99643.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111123173421.39c99643.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: cgroups@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, "bsingharora@gmail.com" <bsingharora@gmail.com>

On 11/23/2011 06:34 AM, KAMEZAWA Hiroyuki wrote:
> I'll rebase this onto mmotm this is based on mainline git tree.
> ==
>  From 2da35fd8eab3a8c2ca80d7aa5dfd4276a23ebf57 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Date: Wed, 23 Nov 2011 16:42:59 +0900
> Subject: [PATCH 3/3] replace mem_cgroup_disabled().
>
> cgroup provires cgroup_xxxx_disabled() functions for checking
> subsys is diabled by boot option or not. Make use of it instead
> of using private function.
>
> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> ---
>   include/linux/memcontrol.h |   12 ------------
>   kernel/cgroup.c            |    4 ++--
>   mm/memcontrol.c            |   32 ++++++++++++++++----------------
>   mm/page_cgroup.c           |    4 ++--
>   4 files changed, 20 insertions(+), 32 deletions(-)
>

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 28d4430..e5c33f5 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4778,7 +4778,7 @@ static void cgroup_release_agent(struct work_struct *work)
>   }
>   #ifdef CONFIG_JUMP_LABEL
>   #define SUBSYS(_x)\
> -	struct jump_label_key cgroup_ ## _x ## _disable_key;
> +	struct jump_label_key cgroup_ ## _x ## _disabled_key;
>   #include<linux/cgroup_subsys.h>
>   #undef SUBSYS

I have the impression this is just churn. Can you call it disabled_key
from the beginning ?

> @@ -4786,7 +4786,7 @@ static void cgroup_subsys_disable(void)
>   {
>   #define SUBSYS(_x)\
>   	if ( _x ## _subsys.disabled)\
> -		jump_label_inc(&cgroup_ ## _x ## _disable_key);
> +		jump_label_inc(&cgroup_ ## _x ## _disabled_key);
>   #include<linux/cgroup_subsys.h>
>   #undef SUBSYS
>   }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6aff93c..594af98 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -916,7 +916,7 @@ void mem_cgroup_del_lru_list(struct page *page, enum lru_list lru)
>   	struct page_cgroup *pc;
>   	struct mem_cgroup_per_zone *mz;
>
> -	if (mem_cgroup_disabled())
> +	if (cgroup_mem_cgroup_disabled())
>   		return;
>   	pc = lookup_page_cgroup(page);
>   	/* can happen while we handle swapcache. */
> @@ -952,7 +952,7 @@ void mem_cgroup_rotate_reclaimable_page(struct page *page)
>   	struct page_cgroup *pc;
>   	enum lru_list lru = page_lru(page);
>
> -	if (mem_cgroup_disabled())
> +	if (cgroup_mem_cgroup_disabled())
>   		return;
>
>   	pc = lookup_page_cgroup(page);

In many cases, this will be just a useless function call. Wouldn't it be 
better if in the disabled case we would not even call those functions? 
It may help some fast paths.

We could define inline versions in memcontrol.h in place of the function 
signatures themselves, and have those to test for the static branch.

Maybe a macro can be used to make it less laborious?
