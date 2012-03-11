From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 04/13] memcg: Make it possible to use the stock for
 more than one page.
Date: Sun, 11 Mar 2012 14:49:52 +0400
Message-ID: <4F5C8350.9080102@parallels.com>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org> <1331325556-16447-5-git-send-email-ssouhlal@FreeBSD.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331325556-16447-5-git-send-email-ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dan.magenheimer-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 03/10/2012 12:39 AM, Suleiman Souhlal wrote:
> Signed-off-by: Suleiman Souhlal<suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>   mm/memcontrol.c |   18 +++++++++---------
>   1 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6fbb438..f605100 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1965,19 +1965,19 @@ static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
>   static DEFINE_MUTEX(percpu_charge_mutex);
>
>   /*
> - * Try to consume stocked charge on this cpu. If success, one page is consumed
> - * from local stock and true is returned. If the stock is 0 or charges from a
> - * cgroup which is not current target, returns false. This stock will be
> - * refilled.
> + * Try to consume stocked charge on this cpu. If success, nr_pages pages are
> + * consumed from local stock and true is returned. If the stock is 0 or
> + * charges from a cgroup which is not current target, returns false.
> + * This stock will be refilled.
>    */
> -static bool consume_stock(struct mem_cgroup *memcg)
> +static bool consume_stock(struct mem_cgroup *memcg, int nr_pages)
>   {
>   	struct memcg_stock_pcp *stock;
>   	bool ret = true;
>
>   	stock =&get_cpu_var(memcg_stock);
> -	if (memcg == stock->cached&&  stock->nr_pages)
> -		stock->nr_pages--;
> +	if (memcg == stock->cached&&  stock->nr_pages>= nr_pages)
> +		stock->nr_pages -= nr_pages;
>   	else /* need to call res_counter_charge */
>   		ret = false;
>   	put_cpu_var(memcg_stock);
> @@ -2290,7 +2290,7 @@ again:
>   		VM_BUG_ON(css_is_removed(&memcg->css));
>   		if (mem_cgroup_is_root(memcg))
>   			goto done;
> -		if (nr_pages == 1&&  consume_stock(memcg))
> +		if (consume_stock(memcg, nr_pages))
>   			goto done;
>   		css_get(&memcg->css);
>   	} else {
> @@ -2315,7 +2315,7 @@ again:
>   			rcu_read_unlock();
>   			goto done;
>   		}
> -		if (nr_pages == 1&&  consume_stock(memcg)) {
> +		if (consume_stock(memcg, nr_pages)) {
>   			/*
>   			 * It seems dagerous to access memcg without css_get().
>   			 * But considering how consume_stok works, it's not

This patch itself is fine in what it wants to achieve.
But it made me think:

We'll jump into the stock code which makes user allocation faster.
but we're not getting the benefit of it when we're accounting kmem.
since we're allocating to both res_counters, we're actually defeating it 
altogether, since we now have to go to the global poll *everytime* (for 
memcg->kmem).

It would make a whole lot more sense to have the stock code moved to the
res_counter. We're now starting to have more users of that anyway, so
a common implementation makes sense.
