From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: page_alloc: skip bulk allocator for __GFP_ACCOUNT
Date: Thu, 14 Oct 2021 09:18:07 +0200
Message-ID: <YWfZr+lL2lrBhSc/@dhcp22.suse.cz>
References: <20211013194338.1804247-1-shakeelb@google.com>
 <4c92e227-2abc-c3cb-93eb-f5c45bef7fc6@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634195887; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ItroEyfCjdn2jjHo+KgVNqOCeGtBLeeRzaYF2ey/Y8Q=;
        b=VfMKwkcQxdhoIzXhSYvkSm5ku7ugoTIPQVOo+JxVkpz/QxhwL/Po2BnNIQE8tm4as/wMbN
        S5oH/v78OyHEvUfHBoe4nVgfGedVIE5BtuoePId8+oLCWf/4EVJCEXyDsURoyy63WUne46
        6hmbURCIwobyelAtwxmnd6qGC94sRWw=
Content-Disposition: inline
In-Reply-To: <4c92e227-2abc-c3cb-93eb-f5c45bef7fc6-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 14-10-21 10:05:21, Vasily Averin wrote:
[...]
> > +	/* Bulk allocator does not support memcg accounting. */
> > +	if (unlikely(gfp & __GFP_ACCOUNT))
> > +		goto out;
> > +
> 
> May be (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT)) check is better here?

Yes please

-- 
Michal Hocko
SUSE Labs
