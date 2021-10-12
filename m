From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH mm v3] memcg: enable memory accounting in
 __alloc_pages_bulk
Date: Tue, 12 Oct 2021 21:45:38 +0300
Message-ID: <3467508f-0f0f-fc28-c973-ad9f0eeb9818@virtuozzo.com>
References: <0baa2b26-a41b-acab-b75d-72ec241f5151@virtuozzo.com>
 <60df0efd-f458-a13c-7c89-749bdab21d1d@virtuozzo.com>
 <YWWrai/ChIgycgCo@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=64IcsFb8bBS4pFgFI9KVjfapZy7rEeNKQF8dCkvviYY=; b=pcmeKt+OWhafIWGl+
        Rsq0UqWHt6l2z4rGEpWKXORZXiSDMKTtmftnTOedW5rwjcVI2qepA2vleNRBTivfqynFbNdjJVz9i
        rxsu0SoUkl2/uSmisuOWf21E9oDhshP6OrjfrNC1n8SV04Qxku1PBM1OKoscx4JNdBmVKnrZn6siY
        =;
In-Reply-To: <YWWrai/ChIgycgCo-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 12.10.2021 18:36, Michal Hocko wrote:
> On Tue 12-10-21 17:58:21, Vasily Averin wrote:
>> Enable memory accounting for bulk page allocator.
> 
> ENOCHANGELOG
>  
> And I have to say I am not very happy about the solution. It adds a very
> tricky code where it splits different charging steps apart.
> 
> Would it be just too inefficient to charge page-by-page once all pages
> are already taken away from the pcp lists? This bulk should be small so
> this shouldn't really cause massive problems. I mean something like
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b37435c274cf..8bcd69195ef5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5308,6 +5308,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  
>  	local_unlock_irqrestore(&pagesets.lock, flags);
>  
> +	if (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT)) {
> +		/* charge pages here */
> +	}
> +
>  	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
>  	zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
> 

In general it looks like we can do it.

We can traverse via filled page_array or page_list.
For page_array we need to check is the page already accounted 
(incoming array can contain some pages already, both in the beginning and in middle)
For each taken page we can try to charge it.
If it was charges successfully -- we will process next page in list/array.
When charge fails we need to remove rest of pages from list/array and somehow release them. 
At present I do not understand how to do it correctly -- perhaps just call free_page() ?
Finally, we'll need to adjust nr_account and nr_populated properly.

I'll try to implement this tomorrow.

Thank you,
	Vasily Averin
