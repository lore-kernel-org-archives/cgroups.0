From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 28 May 2020 11:02:35 -0700
Message-ID: <CALvZod7rSeAKXKq_V0SggZWn4aL8pYWJiej4NdRd8MmuwUzPEw@mail.gmail.com>
References: <20200520143712.GA749486@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9OK1+n6SxXEn9JNGRXaWGo1/ty0IYnCL8Tld6OXFjk4=;
        b=n/yOBUUwD4nsHeaM98tpLc9F//6e2SajGthCpSwy3M6a6PPkyZ8E6vqKqhIEtrzFFo
         fN7seVJumIO0Wnvkd+a7+pe9CN30AfHFwnb4pKQyHHxxvYxYF2C5HAl5Xn4FoT4J5Vyk
         VMLsCsYE8efR1rx5M4AzX0hSzGPAFxkGZNr8ZqeKYTn8zZgF4nvsz2xgOJBOGK6nv6+o
         seMMCkXpCofcZmPESV1JiXAMz16W3qld6J2+2VvqTKFKIVJR1qrWmrOVfesJEzRbR++N
         IFBVokf/Sf+oiQwOerg0N/uYZu8ryIZMvjzvrESVST/H719wbQsK1ZHayVmxpokXctjN
         pPGw==
In-Reply-To: <20200520143712.GA749486@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

I haven't gone through the whole email-chain, so, I might be asking
some repetitive questions. I will go through the email-chain later.

On Wed, May 20, 2020 at 7:37 AM Chris Down <chris@chrisdown.name> wrote:
>
> In Facebook production, we've seen cases where cgroups have been put
> into allocator throttling even when they appear to have a lot of slack
> file caches which should be trivially reclaimable.
>
> Looking more closely, the problem is that we only try a single cgroup
> reclaim walk for each return to usermode before calculating whether or
> not we should throttle. This single attempt doesn't produce enough
> pressure to shrink for cgroups with a rapidly growing amount of file
> caches prior to entering allocator throttling.

In my experience it is usually shrink_slab which requires hammering
multiple times to actually reclaim memory.

>
> As an example, we see that threads in an affected cgroup are stuck in
> allocator throttling:
>
>     # for i in $(cat cgroup.threads); do
>     >     grep over_high "/proc/$i/stack"
>     > done
>     [<0>] mem_cgroup_handle_over_high+0x10b/0x150
>     [<0>] mem_cgroup_handle_over_high+0x10b/0x150
>     [<0>] mem_cgroup_handle_over_high+0x10b/0x150
>
> ...however, there is no I/O pressure reported by PSI, despite a lot of
> slack file pages:
>
>     # cat memory.pressure
>     some avg10=78.50 avg60=84.99 avg300=84.53 total=5702440903
>     full avg10=78.50 avg60=84.99 avg300=84.53 total=5702116959
>     # cat io.pressure
>     some avg10=0.00 avg60=0.00 avg300=0.00 total=78051391
>     full avg10=0.00 avg60=0.00 avg300=0.00 total=78049640
>     # grep _file memory.stat
>     inactive_file 1370939392
>     active_file 661635072
>
> This patch changes the behaviour to retry reclaim either until the
> current task goes below the 10ms grace period, or we are making no
> reclaim progress at all. In the latter case, we enter reclaim throttling
> as before.
>
> To a user, there's no intuitive reason for the reclaim behaviour to
> differ from hitting memory.high as part of a new allocation, as opposed
> to hitting memory.high because someone lowered its value. As such this
> also brings an added benefit: it unifies the reclaim behaviour between
> the two.

What was the initial reason to have different behavior in the first place?

>
> There's precedent for this behaviour: we already do reclaim retries when
> writing to memory.{high,max}, in max reclaim, and in the page allocator
> itself.
>
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> ---
>  mm/memcontrol.c | 28 +++++++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 5 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2df9510b7d64..b040951ccd6b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -73,6 +73,7 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
>
>  struct mem_cgroup *root_mem_cgroup __read_mostly;
>
> +/* The number of times we should retry reclaim failures before giving up. */
>  #define MEM_CGROUP_RECLAIM_RETRIES     5
>
>  /* Socket memory accounting disabled? */
> @@ -2228,17 +2229,22 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
>         return 0;
>  }
>
> -static void reclaim_high(struct mem_cgroup *memcg,
> -                        unsigned int nr_pages,
> -                        gfp_t gfp_mask)
> +static unsigned long reclaim_high(struct mem_cgroup *memcg,
> +                                 unsigned int nr_pages,
> +                                 gfp_t gfp_mask)
>  {
> +       unsigned long nr_reclaimed = 0;
> +
>         do {
>                 if (page_counter_read(&memcg->memory) <= READ_ONCE(memcg->high))
>                         continue;
>                 memcg_memory_event(memcg, MEMCG_HIGH);
> -               try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
> +               nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
> +                                                            gfp_mask, true);
>         } while ((memcg = parent_mem_cgroup(memcg)) &&
>                  !mem_cgroup_is_root(memcg));
> +
> +       return nr_reclaimed;
>  }
>
>  static void high_work_func(struct work_struct *work)
> @@ -2378,16 +2384,20 @@ void mem_cgroup_handle_over_high(void)
>  {
>         unsigned long penalty_jiffies;
>         unsigned long pflags;
> +       unsigned long nr_reclaimed;
>         unsigned int nr_pages = current->memcg_nr_pages_over_high;

Is there any benefit to keep current->memcg_nr_pages_over_high after
this change? Why not just use SWAP_CLUSTER_MAX?

> +       int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
>         struct mem_cgroup *memcg;
>
>         if (likely(!nr_pages))
>                 return;
>
>         memcg = get_mem_cgroup_from_mm(current->mm);
> -       reclaim_high(memcg, nr_pages, GFP_KERNEL);
>         current->memcg_nr_pages_over_high = 0;
>
> +retry_reclaim:
> +       nr_reclaimed = reclaim_high(memcg, nr_pages, GFP_KERNEL);
> +
>         /*
>          * memory.high is breached and reclaim is unable to keep up. Throttle
>          * allocators proactively to slow down excessive growth.
> @@ -2403,6 +2413,14 @@ void mem_cgroup_handle_over_high(void)
>         if (penalty_jiffies <= HZ / 100)
>                 goto out;
>
> +       /*
> +        * If reclaim is making forward progress but we're still over
> +        * memory.high, we want to encourage that rather than doing allocator
> +        * throttling.
> +        */
> +       if (nr_reclaimed || nr_retries--)
> +               goto retry_reclaim;
> +
>         /*
>          * If we exit early, we're guaranteed to die (since
>          * schedule_timeout_killable sets TASK_KILLABLE). This means we don't
> --
> 2.26.2
>
