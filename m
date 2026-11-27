Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795744950;
	b=KdBF4oBDJPrqqCWwEHNppLwcTF+iAO1rnbhfyQ/R3uGL0x84G6tn/ZzaE3UCs/U/1Q1N
	 5IJYTNX+qYomtze7/Kdy9bXk9vt8nWRr8r5fHLaWe5hJnr4pRioyYNovdvfH0IbGLv3Eh
	 mJighkq1Dcz9Wwxud58+w77zbeMkC0E5dmTbiiiKgTGCPmX8Zi7S/9qmKScmKtm/4Pycx
	 gAqyCgTjyc8x8tDEQjsYzutkA7TUX3CqOgCRjAF2vx1vfCN95wxKB+2rHCVOZAT2RMBrZ
	 nm5aTlKPEjxhPdUOiOJGk9Z9P9ZtJFGwIO087S5KlNqBdxqg2URgRRQgwTOq1XsMCOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795744950;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=4HqrvdCaoRLWQfr32Eh+EaYearFMhIXj3DWUunR1Bq4=;
	b=Zq9glLADhccVq6T9sEs88f/hR6jf+qJMbcwU3rQrSSuimEwSrxX7noCYHG3jAf0pqHLy
	 SPHtMhWFDsPk8kByHQIbrIvY5G6c59OVxXmYZ3325WLI+Hkt5l+LeC+jsJB09yO9mLDSb
	 /EqS+i06AT/ol0TaVclJzkpm0kbCZVVF3rk9CzUgF0psU1GMF3Y1G5fCrZbFGiYMfocTD
	 XqnoqKdXfpOSPAKxR4QbJB7N5pPus2/aOaTp08Qnm0Lr4aCD5wcmPLCEfMO1EAw7s5Luy
	 9s5cCk7BXiN91q91MfFNPbdoAe1kynXU5Mq6CNNIuG/MR8a0wBUyXJeL+b9EHnaFoig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DwP8tvtq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5854E606A31C;
	Fri, 27 Nov 2026 02:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DwP8tvtq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281741F00899;
	Fri, 27 Nov 2026 02:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795744949;
	bh=4HqrvdCaoRLWQfr32Eh+EaYearFMhIXj3DWUunR1Bq4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DwP8tvtqN9/NfnynhYi9TNTQ7JpsRb3uLgBeM7RjC9RvUdUGjAwVqZxiZzAovza84
	 PfmJlad3Eu1JV4b7jDvr2yUDFCoYWsuZ014SJvZHMmryyh8rgBlQe0nMgj0+mJX3C5
	 /4ZhtPZULIphwef5B+qmUtWgogyOIGuGFhv34/JQ=
Date: Thu, 26 Nov 2026 18:02:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>, Greg KH
 <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
 against filesystem freeze
Message-Id: <20261126180228.9b672a945d480e3d3f301985@linux-foundation.org>
In-Reply-To: <f188775aea9580f9ab2b477788503434@kernel.org>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
	<f188775aea9580f9ab2b477788503434@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 26 Nov 2026 02:17:38 -1000 Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> Your follow-up, "mm/vmscan: scope freeze writeback skip to the reclaim
> target", applies on top of this patch and tests fine here.

Cool, thanks.  I'd forgotten about that ;) It was a hastily slop-coded
"maybe you'd like to include something like this in your patch" thing.

Can people please take a look and suggest whether it should be a
standalone patch, or just fold it into this patch, "mm/vmscan: Fix
legacy memcg reclaim deadlock against filesystem freeze"?


(That's mem_cgroup's fifth bool - maybe scrunch them all into an
atomic_t and do atomic bitops on it?)

(I am told that moving wb_wait_skip to just after oom_group would avoid
increasing sizeof(mem_cgroup), but that puts wb_wait_skip into the
read-mostly section. wdyt?) 


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmscan: scope freeze writeback skip to the reclaim target
Date: Tue, 17 Nov 2026 14:04:43 -0800

The freeze workaround sets memcg_wb_wait_skip globally when a memcg's
writeback wait times out.  While any superblock freeze is pending, this
makes reclaimers in unrelated memcgs bypass their writeback waits and can
drive an otherwise recoverable cgroup to OOM.

Store the flag in the reclaim target memcg instead.  Use
sc->target_mem_cgroup, not the folio's memcg: reclaim against a parent
limit scans descendants.  This also keeps the skip across successive
try_to_free_mem_cgroup_pages() calls in try_charge_memcg(), each of which
creates a new scan_control.  Reclaim against a different target must first
time out on its own writeback.

Reclaimers sharing the target can still OOM early during a freeze.

Reclaimers of the same target can run concurrently, without a lock
protecting this flag.  Keep READ_ONCE() and WRITE_ONCE() for its lockless
loads and stores.  The flag does not publish any other data.  As with the
global flag, a clear racing with a new timeout may cost another 15-second
wait; the timeout path can set the flag again.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>

 include/linux/memcontrol.h |    2 +
 mm/vmscan.c                |   52 ++++++++++++++++++++---------------
 2 files changed, 33 insertions(+), 21 deletions(-)

--- a/include/linux/memcontrol.h~mm-vmscan-scope-freeze-writeback-skip-to-the-reclaim-target
+++ a/include/linux/memcontrol.h
@@ -248,6 +248,8 @@ struct mem_cgroup {
 	struct list_head memory_peaks;
 	struct list_head swap_peaks;
 	spinlock_t	 peaks_lock;
+	/* Legacy writeback wait timed out during a filesystem freeze. */
+	bool wb_wait_skip;
 
 	/* memory.events and memory.events.local */
 	struct cgroup_file events_file;
--- a/mm/vmscan.c~mm-vmscan-scope-freeze-writeback-skip-to-the-reclaim-target
+++ a/mm/vmscan.c
@@ -1171,39 +1171,49 @@ static bool may_enter_fs(struct folio *f
  *
  * Reclaim can't tell which filesystem a writeback depends on. As a crude
  * workaround, memcg_wait_writeback() times out and, if any filesystem is being
- * frozen at that point, sets memcg_wb_wait_skip. While it is set, legacy memcg
- * reclaim neither waits for nor throttles on writeback, so that the task a
- * freeze may be waiting for isn't held up in reclaim and can drop its freeze
- * protection. This can cause premature memcg OOM kills.
+ * frozen at that point, sets a skip flag on the reclaim target memcg. While
+ * it is set, reclaim against that target neither waits for nor throttles on
+ * writeback, so that the task a freeze may be waiting for isn't held up in
+ * reclaim and can drop its freeze protection. This can cause premature memcg
+ * OOM kills in that reclaim target.
  */
-static bool memcg_wb_wait_skip;
-
-/*
- * Test memcg_wb_wait_skip. It takes effect only while a filesystem is being
- * frozen and is cleared here once none is. A freeze that starts before it is
- * cleared inherits the skip.
- */
-static bool memcg_skip_wb_wait(void)
+#ifdef CONFIG_MEMCG
+/* Retain the skip across separate reclaim attempts against the same limit. */
+static bool memcg_skip_wb_wait(struct scan_control *sc)
 {
-	if (!READ_ONCE(memcg_wb_wait_skip))
+	struct mem_cgroup *memcg = sc->target_mem_cgroup;
+
+	if (!memcg || !READ_ONCE(memcg->wb_wait_skip))
 		return false;
 	if (atomic_read(&sb_nr_freezing))
 		return true;
-	WRITE_ONCE(memcg_wb_wait_skip, false);
+	WRITE_ONCE(memcg->wb_wait_skip, false);
 	return false;
 }
 
-/* wait for writeback of @folio, see memcg_wb_wait_skip for the timeout */
-static void memcg_wait_writeback(struct folio *folio)
+/* Wait for writeback, unless a freeze stalls this reclaim target. */
+static void memcg_wait_writeback(struct folio *folio, struct scan_control *sc)
 {
 	while (!folio_wait_bit_timeout(folio, PG_writeback, 15 * HZ)) {
 		if (atomic_read(&sb_nr_freezing)) {
-			WRITE_ONCE(memcg_wb_wait_skip, true);
-			pr_warn("memcg1 writeback wait timed out during fs freeze, skipping waits, may OOM early\n");
+			WRITE_ONCE(sc->target_mem_cgroup->wb_wait_skip, true);
+			pr_warn("memcg writeback wait timed out during fs freeze; "
+				"skipping waits for reclaim target, may OOM early\n");
 			return;
 		}
 	}
 }
+#else
+static bool memcg_skip_wb_wait(struct scan_control *sc)
+{
+	return false;
+}
+
+static void memcg_wait_writeback(struct folio *folio, struct scan_control *sc)
+{
+	folio_wait_writeback(folio);
+}
+#endif
 
 /*
  * shrink_folio_list() returns the number of reclaimed pages
@@ -1351,7 +1361,7 @@ retry:
 
 			/* Case 2 above */
 			} else if (writeback_throttling_sane(sc) ||
-			    memcg_skip_wb_wait() ||
+			    memcg_skip_wb_wait(sc) ||
 			    !folio_test_reclaim(folio) ||
 			    !may_enter_fs(folio, sc->gfp_mask) ||
 			    (mapping &&
@@ -1377,7 +1387,7 @@ retry:
 			/* Case 3 above */
 			} else {
 				folio_unlock(folio);
-				memcg_wait_writeback(folio);
+				memcg_wait_writeback(folio, sc);
 				/* then go back and try same folio again */
 				list_add_tail(&folio->lru, folio_list);
 				continue;
@@ -2138,7 +2148,7 @@ static void handle_reclaim_writeback(uns
 		 * enough for cgroupv1 writeback throttling to work
 		 * on a large system.
 		 */
-		if (!writeback_throttling_sane(sc) && !memcg_skip_wb_wait())
+		if (!writeback_throttling_sane(sc) && !memcg_skip_wb_wait(sc))
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
_

