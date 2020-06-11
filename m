From: Hugh Dickins <hughd@google.com>
Subject: [PATCH alexv12 2/2] mm/compaction: fix call to
 __isolate_lru_page_prepare()
Date: Thu, 11 Jun 2020 15:30:45 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2006111529010.10801@eggly.anvils>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=+EahI0YlQUT1/wBvgRJFQZcHP3obsCOagtKe7ySyhrM=;
        b=W26cncJyLH/i2zSIOMrO837pRs3uf2BxQU7IzrLdCgttozbazIeNDlQgCyQFiYpUyY
         Ms4olROFTxfvmQAdemlh52vDy0Ftr89GQMQrDXOir38oNwY8+8gPiDMnQChh/qPvfhj1
         iUsIdILczYmCpO1xqBDBaFflxA4qJYGotgpCt1+gBdruUxe14ckzTnM3+9z+NR3Qkckp
         8bXFzj6IhT3p8E6ZtAmnlH8HwiB/X34paleeTrwi7sO8xUPY1QHO1EqXGNShfQxJUmTK
         oNomeUpR4hUAyI5seihocIFNBhP5T0Ojn22FOBFdo6AgdYqo+CShth6zOvtf4oEc8vZn
         S8fw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com

isolate_migratepages_block() is calling __isolate_lru_page_prepare()
at a point when it has not yet acquired a reference to the page, and
may not yet hold the right lruvec lock: it has no hold on the page.

trylock_page() is not safe to use at this time: its setting PG_locked
can race with the page being freed or allocated ("Bad page"), and can
also erase flags being set by one of those "sole owners" of a freshly
allocated page who use non-atomic __SetPageFlag().

Though I have tried rcu_read_lock() instead of trylock_page() there
(like in page_evictable()), 054f1d1faaed ("mm/swap_state.c: simplify
total_swapcache_pages() with get_swap_device()") stopped the freeing of
swapper_spaces by RCU; and races against setting PageSwapCache, and the
dereference of mapping->a_ops, and the lack of any page reference: all
make that a more dubious approach.

Just move the call to __isolate_lru_page_prepare() after the call to
get_page_unless_zero(), when using trylock_page() has become safe
(safe given __isolate's  check for PageLRU - unsafe without that).

Signed-off-by: Hugh Dickins <hughd@google.com>
---
I had envisaged this as a separate patch; but once it came down
to just moving the call inside isolate_migratepages_block(), it's
probably best folded into 10/16 or 12/16 (needs isolate_fail_put).

I shall probably want to come along later, to clean up or eliminate
__isolate_lru_page_prepare(): which I found before to have almost
nothing in common between its use by isolate_migratepages_block()
and its use by isolate_lru_pages(). We can then do its safer checks
before the get_page_unless_zero(). But trying that cleanup right
now would just get in the way of this series.

 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- alexv12/mm/compaction.c	2020-06-11 13:48:10.437046025 -0700
+++ hughd/mm/compaction.c	2020-06-11 13:49:05.570579095 -0700
@@ -960,9 +960,6 @@ isolate_migratepages_block(struct compac
 		if (!(cc->gfp_mask & __GFP_FS) && page_mapping(page))
 			goto isolate_fail;
 
-		if (__isolate_lru_page_prepare(page, isolate_mode) != 0)
-			goto isolate_fail;
-
 		/*
 		 * Be careful not to clear PageLRU until after we're
 		 * sure the page is not being freed elsewhere -- the
@@ -971,6 +968,9 @@ isolate_migratepages_block(struct compac
 		if (unlikely(!get_page_unless_zero(page)))
 			goto isolate_fail;
 
+		if (__isolate_lru_page_prepare(page, isolate_mode) != 0)
+			goto isolate_fail_put;
+
 		/* Try isolate the page */
 		if (!TestClearPageLRU(page))
 			goto isolate_fail_put;
