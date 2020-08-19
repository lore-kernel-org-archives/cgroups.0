From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 3/5] mm: Add explicit page decrement in exception
 path for isolate_lru_pages
Date: Tue, 18 Aug 2020 21:27:22 -0700
Message-ID: <20200819042722.23414.2654.stgit@localhost.localdomain>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=T7hUYa5UogPv6sBfCV0FhXNPQBfOPqefw0rv85aPgto=;
        b=Eoxng6/BeOd5C+j6fxh7qVKG8VAHJChogDv9BN+ih1vUiDUYa428vI1Qr+RZbHjb+F
         z3PDkhrTAEWMFXQqqS47dXG8H6GuVtMQfIdV1JByxC7hytaIGD/THiPJiKiGDitv9Mu4
         SF3IEcMaQ/mNQsTxJY6Sja8V162q2FroarImRxmS5HP5urBApgHmPQxX4t9Ai+lsXxSG
         OYKZmN1fuUCZoYCc/WUjYKRxEgh+BdWg8jQZdErGjvVfvxnfHHrBPVrpqC0lZKb0eTR+
         n58O8F+j9uYedxQzKWsfe2axi/nAxCbseEV93iRLNiPzCtPxbpaHLF8Aslyd2pM2RZa+
         82Mw==
In-Reply-To: <20200819041852.23414.95939.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Cc: yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org

From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

In isolate_lru_pages we have an exception path where if we call
get_page_unless_zero and that succeeds, but TestClearPageLRU fails we call
put_page. Normally this would be problematic but due to the way that the
calls are ordered and the fact that we are holding the LRU lock we know
that the caller must be holding another reference for the page. Since we
can assume that we can replace the put_page with a call to
put_page_testzero contained within a WARN_ON. By doing this we should see
if we ever leak a page as a result of the reference count somehow hitting
zero when it shouldn't, and can avoid the overhead and confusion of using
the full put_page call.

Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 mm/vmscan.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5bc0c2322043..3ebe3f9b653b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1688,10 +1688,13 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 
 			if (!TestClearPageLRU(page)) {
 				/*
-				 * This page may in other isolation path,
-				 * but we still hold lru_lock.
+				 * This page is being isolated in another
+				 * thread, but we still hold lru_lock. The
+				 * other thread must be holding a reference
+				 * to the page so this should never hit a
+				 * reference count of 0.
 				 */
-				put_page(page);
+				WARN_ON(put_page_testzero(page));
 				goto busy;
 			}
 

