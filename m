From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH mm v3] memcg: enable memory accounting in
 __alloc_pages_bulk
Date: Tue, 12 Oct 2021 17:36:10 +0200
Message-ID: <YWWrai/ChIgycgCo@dhcp22.suse.cz>
References: <0baa2b26-a41b-acab-b75d-72ec241f5151@virtuozzo.com>
 <60df0efd-f458-a13c-7c89-749bdab21d1d@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634052973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z4t443UJiJ2rcoEB8L8cMpLE3EGEoriZGHhNtpCV59o=;
        b=LCAWful78QuPBIVafj5uLFJo72ALVVdM8BR8Gp5+khkEphWBJoq8TBmZSTM0EVae88QNRP
        As50/6u8kW+DCDHqOrREg4u2ReEWtBd2xfSfWu8Qfx6P9Df+h+++WUYuIDlZWa3YSQSWP3
        uhiTrgTiXOhkCCm/pagqt/x87mWJrik=
Content-Disposition: inline
In-Reply-To: <60df0efd-f458-a13c-7c89-749bdab21d1d-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue 12-10-21 17:58:21, Vasily Averin wrote:
> Enable memory accounting for bulk page allocator.

ENOCHANGELOG
 
And I have to say I am not very happy about the solution. It adds a very
tricky code where it splits different charging steps apart.

Would it be just too inefficient to charge page-by-page once all pages
are already taken away from the pcp lists? This bulk should be small so
this shouldn't really cause massive problems. I mean something like

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b37435c274cf..8bcd69195ef5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5308,6 +5308,10 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 
 	local_unlock_irqrestore(&pagesets.lock, flags);
 
+	if (memcg_kmem_enabled() && (gfp & __GFP_ACCOUNT)) {
+		/* charge pages here */
+	}
+
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
 	zone_statistics(ac.preferred_zoneref->zone, zone, nr_account);
-- 
Michal Hocko
SUSE Labs
