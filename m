From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: cleanup some useless code
Date: Tue, 10 Dec 2019 15:07:58 +0100
Message-ID: <20191210140758.GK10404@dhcp22.suse.cz>
References: <20191210134911.2570-1-pilgrimtao@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191210134911.2570-1-pilgrimtao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chengkaitao <pilgrimtao@gmail.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, smuchun@gmail.com

On Tue 10-12-19 05:49:10, chengkaitao wrote:
> From: Kaitao Cheng <pilgrimtao@gmail.com>
> 
> There is a duplicate PageTransHuge, because hpage_nr_pages have
> the same one.

I am not a great fan of changes like these - a minor code churn without
a clear benefit - but in this particular case I do agree that there is
an improvement because we have two states to represent the same thing.
I have hard time believing this makes a more optimal code as
PageTransHuge is a trivial check so it doesn't make much sense to
replicate the state locally.

That being said the changelog could be improved a bit. What about
something like the following?
"
Compound pages handling in mem_cgroup_migrate is more convoluted than
necessary. The state is duplicated in compound variable and the same
could be achieved by PageTransHuge check which is trivial and
hpage_nr_pages is already PageTransHuge aware.

It is much simpler to just use hpage_nr_pages for nr_pages and replace
the local variable by PageTransHuge check directly
"

> Signed-off-by: Kaitao Cheng <pilgrimtao@gmail.com>

To the change
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
> ---
>  mm/memcontrol.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bc01423277c5..870284d3ee9d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6678,7 +6678,6 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
>  {
>  	struct mem_cgroup *memcg;
>  	unsigned int nr_pages;
> -	bool compound;
>  	unsigned long flags;
>  
>  	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
> @@ -6700,8 +6699,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
>  		return;
>  
>  	/* Force-charge the new page. The old one will be freed soon */
> -	compound = PageTransHuge(newpage);
> -	nr_pages = compound ? hpage_nr_pages(newpage) : 1;
> +	nr_pages = hpage_nr_pages(newpage);
>  
>  	page_counter_charge(&memcg->memory, nr_pages);
>  	if (do_memsw_account())
> @@ -6711,7 +6709,8 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
>  	commit_charge(newpage, memcg, false);
>  
>  	local_irq_save(flags);
> -	mem_cgroup_charge_statistics(memcg, newpage, compound, nr_pages);
> +	mem_cgroup_charge_statistics(memcg, newpage, PageTransHuge(newpage),
> +			nr_pages);
>  	memcg_check_events(memcg, newpage);
>  	local_irq_restore(flags);
>  }
> -- 
> 2.20.1

-- 
Michal Hocko
SUSE Labs
