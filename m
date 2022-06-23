From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: vmpressure: don't count userspace-induced reclaim as
 memory pressure
Date: Thu, 23 Jun 2022 10:05:56 +0200
Message-ID: <YrQe5A+FXnbgOR1f@dhcp22.suse.cz>
References: <20220623000530.1194226-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655971557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y9JvyrtgVzfCy9ltHeRGduIrfv2kgcjya7gqZ8Tg/Eg=;
        b=NyVtGuJt8cxNsPfYFDoV+sIvK1KTL8xU6r6mwnAYB2JKqguCEJ9f/3TqAsImvAR01eR767
        q/fw2eL8mU8xVld1PKOtc+bBWtYdBf2xpd/9Pmk20D0RpEweflTKcZjNKqraXVi4sWplQi
        PO+js2nqOqm2w+GNEKhlXlL7F+vzvlQ=
Content-Disposition: inline
In-Reply-To: <20220623000530.1194226-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu 23-06-22 00:05:30, Yosry Ahmed wrote:
> Commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
> as memory pressure") made sure that memory reclaim that is induced by
> userspace (limit-setting, proactive reclaim, ..) is not counted as
> memory pressure for the purposes of psi.
> 
> Instead of counting psi inside try_to_free_mem_cgroup_pages(), callers
> from try_charge() and reclaim_high() wrap the call to
> try_to_free_mem_cgroup_pages() with psi handlers.
> 
> However, vmpressure is still counted in these cases where reclaim is
> directly induced by userspace. This patch makes sure vmpressure is not
> counted in those operations, in the same way as psi. Since vmpressure
> calls need to happen deeper within the reclaim path, the same approach
> could not be followed. Hence, a new "controlled" flag is added to struct
> scan_control to flag a reclaim operation that is controlled by
> userspace. This flag is set by limit-setting and proactive reclaim
> operations, and is used to count vmpressure correctly.
> 
> To prevent future divergence of psi and vmpressure, commit e22c6ed90aa9
> ("mm: memcontrol: don't count limit-setting reclaim as memory pressure")
> is effectively reverted and the same flag is used to control psi as
> well.

Why do we need to add this is a legacy interface now? Are there any
pre-existing users who realized this is bugging them? Please be more
specific about the usecase.

-- 
Michal Hocko
SUSE Labs
