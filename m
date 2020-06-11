From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 19/19] mm: memcontrol: update page->mem_cgroup stability
 rules
Date: Thu, 11 Jun 2020 11:40:33 +0200
Message-ID: <20200611094033.GC20450@dhcp22.suse.cz>
References: <20200508183105.225460-1-hannes@cmpxchg.org>
 <20200508183105.225460-20-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200508183105.225460-20-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri 08-05-20 14:31:06, Johannes Weiner wrote:
> The previous patches have simplified the access rules around
> page->mem_cgroup somewhat:
> 
> 1. We never change page->mem_cgroup while the page is isolated by
>    somebody else. This was by far the biggest exception to our rules
>    and it didn't stop at lock_page() or lock_page_memcg().
> 
> 2. We charge pages before they get put into page tables now, so the
>    somewhat fishy rule about "can be in page table as long as it's
>    still locked" is now gone and boiled down to having an exclusive
>    reference to the page.
> 
> Document the new rules. Any of the following will stabilize the
> page->mem_cgroup association:
> 
> - the page lock
> - LRU isolation
> - lock_page_memcg()
> - exclusive access to the page
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Reviewed-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

Thanks a lot this is a big improvement and simplification.

I have gone through the whole series finally. I have followed up where
necessary but overall this is really nice!

Sorry I couldn't jump in to review in time.
-- 
Michal Hocko
SUSE Labs
