From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RESEND PATCH v2 09/12] mm: memcontrol: convert vmstat slab
 counters to bytes
Date: Mon, 7 Dec 2020 11:46:22 -0800
Message-ID: <20201207194622.GA2238414@carbon.dhcp.thefacebook.com>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
 <20201206101451.14706-10-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=EoIPii2JPcSda4CrSMHg5vdPlmf3UYzHcRGdqcTmxOM=;
 b=C+9P/aFHxG0QhbPY4mn9GiEFRYI5bR8ZWnxvYmVngxkZrG6tk/f1umOdjNQjd4YrSkf1
 YIREXoRmwu96WGuJjy0MqxqcpdVatayXSTv56RDNtZ+Kk9ZiX9UzIZuYjb6I7nQn3WqP
 xzygF4rUlA6bjz0e9hbMzx7xsGWz3dpW6Eo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EoIPii2JPcSda4CrSMHg5vdPlmf3UYzHcRGdqcTmxOM=;
 b=ZNtjfBhHrp4vT0ra0eICIq7gGT6Z0NKTlELRxBkMNhOiwaV99PXTKp1+UGPzVDrxZ26El6WT4PGKg7/j+mnQDDWpzUyLPVataPhbVB8VHYWoxQfjsUH3gCwOnNnx0/VxZ1N5v2PnjaLxNAouy4y62Q04Ti5iIgw3Y3CiVk6+bjo=
Content-Disposition: inline
In-Reply-To: <20201206101451.14706-10-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Dec 06, 2020 at 06:14:48PM +0800, Muchun Song wrote:
> the global and per-node counters are stored in pages, however memcg
> and lruvec counters are stored in bytes. This scheme looks weird.
> So convert all vmstat slab counters to bytes.

There is a reason for this weird scheme:
percpu caches (see struct per_cpu_nodestat) are s8, so counting in bytes
will lead to overfills. Switching to s32 can lead to an increase in
the cache thrashing, especially on small machines.

> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  include/linux/vmstat.h | 17 ++++++++++-------
>  mm/vmstat.c            | 21 ++++++++++-----------
>  2 files changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 322dcbfcc933..fd1a3d5d4926 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -197,18 +197,26 @@ static inline
>  unsigned long global_node_page_state_pages(enum node_stat_item item)
>  {
>  	long x = atomic_long_read(&vm_node_stat[item]);
> +
>  #ifdef CONFIG_SMP
>  	if (x < 0)
>  		x = 0;
>  #endif
> +	if (vmstat_item_in_bytes(item))
> +		x >>= PAGE_SHIFT;
>  	return x;
>  }
>  
>  static inline unsigned long global_node_page_state(enum node_stat_item item)
>  {
> -	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
> +	long x = atomic_long_read(&vm_node_stat[item]);
>  
> -	return global_node_page_state_pages(item);
> +	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
> +#ifdef CONFIG_SMP
> +	if (x < 0)
> +		x = 0;
> +#endif
> +	return x;
>  }
>  
>  static inline unsigned long zone_page_state(struct zone *zone,
> @@ -312,11 +320,6 @@ static inline void __mod_zone_page_state(struct zone *zone,
>  static inline void __mod_node_page_state(struct pglist_data *pgdat,
>  			enum node_stat_item item, int delta)
>  {
> -	if (vmstat_item_in_bytes(item)) {
> -		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
> -		delta >>= PAGE_SHIFT;
> -	}
> -
>  	node_page_state_add(delta, pgdat, item);
>  }
>  
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 8d77ee426e22..7fb0c7cb9516 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -345,11 +345,6 @@ void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
>  	long x;
>  	long t;
>  
> -	if (vmstat_item_in_bytes(item)) {
> -		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
> -		delta >>= PAGE_SHIFT;
> -	}
> -
>  	x = delta + __this_cpu_read(*p);
>  
>  	t = __this_cpu_read(pcp->stat_threshold);
> @@ -554,11 +549,6 @@ static inline void mod_node_state(struct pglist_data *pgdat,
>  	s8 __percpu *p = pcp->vm_node_stat_diff + item;
>  	long o, n, t, z;
>  
> -	if (vmstat_item_in_bytes(item)) {
> -		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
> -		delta >>= PAGE_SHIFT;
> -	}
> -
>  	do {
>  		z = 0;  /* overflow to node counters */
>  
> @@ -1012,19 +1002,28 @@ unsigned long node_page_state_pages(struct pglist_data *pgdat,
>  				    enum node_stat_item item)
>  {
>  	long x = atomic_long_read(&pgdat->vm_stat[item]);
> +
>  #ifdef CONFIG_SMP
>  	if (x < 0)
>  		x = 0;
>  #endif
> +	if (vmstat_item_in_bytes(item))
> +		x >>= PAGE_SHIFT;
>  	return x;
>  }
>  
>  unsigned long node_page_state(struct pglist_data *pgdat,
>  			      enum node_stat_item item)
>  {
> +	long x = atomic_long_read(&pgdat->vm_stat[item]);
> +
>  	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
>  
> -	return node_page_state_pages(pgdat, item);
> +#ifdef CONFIG_SMP
> +	if (x < 0)
> +		x = 0;
> +#endif
> +	return x;
>  }
>  #endif
>  
> -- 
> 2.11.0
> 
