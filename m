From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: workqueue usage in vmpressure
Date: Thu, 11 Jul 2013 16:43:08 +0800
Message-ID: <51DE701C.6010800@huawei.com>
References: <20130710184254.GA16979@mtj.dyndns.org> <20130711083110.GC21667@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130711083110.GC21667-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> @@ -178,7 +179,7 @@ static void vmpressure_work_fn(struct work_struct *work)
>  	 * vmpr->reclaimed is in sync.
>  	 */
>  	if (!vmpr->scanned)
> -		return;
> +		goto out;
>  
>  	mutex_lock(&vmpr->sr_lock);
>  	scanned = vmpr->scanned;
> @@ -195,6 +196,13 @@ static void vmpressure_work_fn(struct work_struct *work)
>  		 * hierarchy.
>  		 */
>  	} while ((vmpr = vmpressure_parent(vmpr)));
> +out:
> +	/*
> +	 * Reference has been taken in vmpressure.
> +	 * memcg which embeds this vmpr might go away after this call so
> +	 * no further manipulation with vmprs or work item is safe
> +	 */
> +	vmpressure_unpin_memcg(vmpr);
>  }
>  
>  /**
> @@ -248,6 +256,9 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
>  
>  	if (scanned < vmpressure_win || work_pending(&vmpr->work))
>  		return;
> +
> +	/* Reference will be released in vmpressure_work_fn */
> +	vmpressure_pin_memcg(vmpr);
>  	schedule_work(&vmpr->work);

Looks like a work can be queued right after the above work_pending()
returns 0, then we should do this:

    if (schedule_work(&vmpr->work))
	vmpressure_pin_memcg(vmpr);

>  }
>  
