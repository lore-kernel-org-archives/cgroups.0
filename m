From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/11] memcg: Reclaim when more than one page needed.
Date: Wed, 27 Jun 2012 12:48:41 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206271246380.22162@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-3-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252106430.26640@chino.kir.corp.google.com> <4FEADA55.4060409@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=lBemeYq6NH3OsMePqas9zAa6pdBiuhmpgdAVajHQHSM=;
        b=gdciyxc/k963n5TssKHf1l0msVAd4f/YiCCA9fd3kGFJD1jmQ/Eu8xpnt1ofS//p0i
         +ydnL/A4JYs7rM4cBZkgaca9JKKQeC6jrFdSE5s9m4oZIvVV4tum4lHYUZvUamWSDBG/
         aybaWlkZoWQMNyp9Ognl9N7E04qjf1CKP6+8MywlujkIUM8NDVDcWmJF5PrIYQEVsnlf
         27U8IRChy+zxkLlOecDMf1wWProxHTizccfkgKrKzv3QXVftmew6ehj6Dr7TrfYYTPXo
         AI8SGzKV5A05QNZkLxOf/xTyzMgmIwJTTyeqJLg6JEumDN8IYQnuWYXyWViCESfS8WkM
         YqCg==
In-Reply-To: <4FEADA55.4060409-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, 27 Jun 2012, Glauber Costa wrote:

> > @@ -2206,7 +2214,7 @@ static int mem_cgroup_do_charge(struct mem_cgroup
> > *memcg, gfp_t gfp_mask,
> > >  	 * unlikely to succeed so close to the limit, and we fall back
> > >  	 * to regular pages anyway in case of failure.
> > >  	 */
> > > -	if (nr_pages == 1 && ret)
> > > +	if (nr_pages <= NR_PAGES_TO_RETRY && ret)
> > >  		return CHARGE_RETRY;
> 
> Changed to costly order.
> 

1 << PAGE_ALLOC_COSTLY_ORDER was the suggestion.

> One more thing. The original version of this patch included
> a cond_resched() here, that was also removed. From my re-reading
> of the code in page_alloc.c and vmscan.c now, I tend to think
> this is indeed not needed, since any cond_resched()s that might
> be needed to ensure the safety of the code will be properly
> inserted by the reclaim code itself, so there is no need for us
> to include any when we signal that a retry is needed.
> 

For __GFP_WAIT, that sounds like a safe guarantee.
