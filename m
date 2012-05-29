From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 12/28] slab: pass memcg parameter to
 kmem_cache_create
Date: Tue, 29 May 2012 11:52:55 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205291149280.8406@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-13-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290922340.4666@router.home> <4FC4F04F.1070401@parallels.com> <alpine.DEB.2.00.1205291131590.6723@router.home>
 <4FC4FAF6.8060900@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1338310379; bh=29rG073WZg2ZYvi2VEUvjpUbOjJIVwQFrcPoqPeOOh8=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=KbtMrpV8zbR3Tx5mu/e1sTU/GQ+4+jT6MqNwkoTiPp+1iAi7eo5Q+q0H/1w4eOu6MPqpO3fHvqMmg97/nyOiwknXzNmu9KVQyeiC6KIAxL16E5UqbvaSjhVQA0UkRRING1k2EwwCKLqOQNkhPovEa00g/NPjbPH5yoAJJ1xChSQ=
In-Reply-To: <4FC4FAF6.8060900-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Tue, 29 May 2012, Glauber Costa wrote:

> > How do you detect that someone is touching it?
>
> kmem_alloc_cache will create mem_cgroup_get_kmem_cache.
> (protected by static_branches, so won't happen if you don't have at least
> non-root memcg using it)
>
> * Then it detects which memcg the calling process belongs to,
> * if it is the root memcg, go back to the allocation as quickly as we
>   can
> * otherwise, in the creation process, you will notice that each cache
>   has an index. memcg will store pointers to the copies and find them by
>   the index.
>
> From this point on, all the code of the caches is reused (except for
> accounting the page)

Well kmem_cache_alloc cache is the performance critical hotpath.

If you are already there and doing all of that then would it not be better
to simply count the objects allocated and freed per cgroup? Directly
increment and decrement counters in a cgroup? You do not really need to
duplicate the kmem_cache structure and do not need to modify allocators if
you are willing to take that kind of a performance hit. Put a wrapper
around kmem_cache_alloc/free and count things.



