From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH memcg] mm/page_alloc.c: avoid statistic update with 0
Date: Fri, 8 Oct 2021 13:47:00 +0200
Message-ID: <29155011-f884-b0e5-218e-911039568acb@suse.cz>
References: <b2371951-bb8a-e62e-8d33-10830bbf6275@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1633693621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YoxW4EUonCWf2lBt5f9S3iKvB1ejzJVPxoUC2rO4AkI=;
        b=1ZcyaUI9xL0W6i8yX8fh3JwbqEunlXFB9R5Hp4A3vr8ms486M4COzbyQRsWP+KlLwyB6dh
        dGaXSFSFDN4d5nEVPhN+r4zSGmKnNwJv+aM9LS/ZyZArn593oBkmU1FM8LbR8KuVBUobD1
        yNeUmEVBsrzS2avT2ueUr8fTq1gAZDE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1633693621;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YoxW4EUonCWf2lBt5f9S3iKvB1ejzJVPxoUC2rO4AkI=;
        b=97hilA7zf9D+z7paBomgPpHZSwUGYILNLuMasBPsLrjC2yAu9fTQr3pifWwzZtN5UvLFl5
        +se0dSDU+VEB5VBA==
Content-Language: en-US
In-Reply-To: <b2371951-bb8a-e62e-8d33-10830bbf6275-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 10/8/21 11:24, Vasily Averin wrote:
> __alloc_pages_bulk can call __count_zid_vm_events and zone_statistics
> with nr_account = 0.

But that's not a bug, right? Just an effective no-op that's not commonly
happening, so is it worth the check?

> Fixes: 3e23060b2d0b ("mm/page_alloc: batch the accounting updates in the bulk allocator")
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  mm/page_alloc.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 602819a232e5..e67113452ee8 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5364,9 +5364,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>  	}
>  
>  	local_unlock_irqrestore(&pagesets.lock, flags);
> -
> -	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
> -	zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
> +	if (nr_account) {
> +		__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
> +		zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
> +	}
>  	if (objcg)
>  		memcg_bulk_post_charge_hook(objcg, nr_pre_charge - nr_account);
>  
> 

