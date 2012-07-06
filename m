From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 24/25] memcg/slub: shrink dead caches
Date: Fri, 6 Jul 2012 10:16:36 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1207061015030.28648@router.home>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-25-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1341587800; bh=fKQZ8Mkbv2U0HNaUfxy0miAcvy1IRNzj9X5/uwP2/rM=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=EdEQgP52rkQf0DLoa1IrMPmuQjDpTxI9vqpGNdZ2RJcm7bHSuOKQ642ZQth2Szlre9FCc98eoREWJ87SswBJe3odh0SD2qaM+C1wBwgjBIC99wfJZDht8kZ3V5vylnC8SMviYBcaZsQtzuWkQlUgP+1WqzVIbIBu3H8GFzIcfGo=
In-Reply-To: <1340015298-14133-25-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon, 18 Jun 2012, Glauber Costa wrote:

> In the slub allocator, when the last object of a page goes away, we
> don't necessarily free it - there is not necessarily a test for empty
> page in any slab_free path.

This is the same btw in SLAB which keeps objects in per cpu caches and
keeps empty slab pages on special queues.

> This patch marks all memcg caches as dead. kmem_cache_shrink is called
> for the ones who are not yet dead - this will force internal cache
> reorganization, and then all references to empty pages will be removed.

You need to call this also for slab to drain the caches and free the pages
on the empty list.
