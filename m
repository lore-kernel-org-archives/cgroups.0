Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D24446855;
	Fri, 16 Oct 2026 08:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792140195; cv=none; b=Egq1tFujplLpga5cF1w3cSY+VQi5aAWF/dQ1B8ghzpIGs3gr2Zd7YprL3G0CszSn1952IlsLVeKa7Pmb/356M+BEvjl2GEwink4pUAeCx4aTeyQpicAAYgotT9mtOblIswA+mtCzXo8xbKi37/gBE8jb1RMtIMKU0jKakviMXR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792140195; c=relaxed/simple;
	bh=JPSACOaMlTfpve9+sZEgKufMkhYE6UnAah6afFDSS3M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c3TEdNDuPyuC/qaOk8P/v9j69RE4QUaKveGwg3bLjD+xRcVTGJp+5Gfee+XjM0OErlhihjvTvJIzUQG2yS6Dgp3Mk0uZ/kl8swz1HYsSbCfXMEQjob/VOsQkzF3MRo5xhumWD4KausIOKzbkx0KS9Pd0c77W9zJMbb/diODGJiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mK5F7RTu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mK5F7RTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31DE1F000C4;
	Fri, 16 Oct 2026 08:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792140188;
	bh=uuyYLjc88NlqPqUJ8TG17oI3ayh7MbBbcx6eKptcvgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mK5F7RTuDashr/9tLlHIbBsWn89AqnBSS/stQsnZFK0udCKKJwwx0mXZQaQ6y0/mL
	 v7mGlbkHWvwzlsaxzGgTYFMZenluZzn+ThpKvxfT1FQwf36UkwlkhVENj2wBZxT6cs
	 Oa73yOwEZyWaWTtUMKIkWXdzfEtYmHJhKqUn83wmEv5Y9Nr09h6UQgTdLpZXLBsi7T
	 BcJoBYPrSNER1hYyvdrJ3OG1NANEuudau4hCEy8QMvdL5eSFm1HA0gqGHf6uV6haqE
	 H7kcsX+z4rgxil/LicfKzRXo4ZkbGiIH/R/Cu4kTDkLTAUpEZrSf+0BJA/cTdijfKW
	 IT70BEsYqnSLA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: devnull+kasong.tencent.com@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	cgroups@vger.kernel.org,
	chenridong@xiaomi.com,
	chrisl@kernel.org,
	damon@lists.linux.dev,
	david@kernel.org,
	dev.jain@arm.com,
	ehab.ababneh@intel.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	ljs@kernel.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	nico.pache@linux.dev,
	nphamcs@gmail.com,
	qi.zheng@linux.dev,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	ryan.roberts@arm.com,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	sj@kernel.org,
	surenb@google.com,
	tz2294@columbia.edu,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	vernon2gm@gmail.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	willy@infradead.org,
	ying.huang@linux.alibaba.com,
	youngjun.park@lge.com,
	yuanchu@google.com,
	yuzhao@google.com,
	zhaozhengzhuo@uniontech.com,
	ziy@nvidia.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 00/17] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
Date: Fri, 16 Oct 2026 16:42:56 +0800
Message-Id: <20261016084256.12955-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, Oct 16, 2026 at 2:15 AM Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:
[...]
>
> LevelDB Scan/Get
> ================
> I also retested the LevelDB benchmark from the cache_ext paper [5].
> Interestingly, mainline MGLRU already beats CLRU on this one after a
> recent change in lru_gen_folio_seq that bumps new folios with refs == 1
> to the second-oldest generation as discussed. That change accidentally
> gave random reads a higher hotness level while making sequential reads
> much colder as described before [14]. However it's unreliable and
> incorrect because it depends on LRU drain timing, and hurts some workloads
> as reported, or where the sequential part is actually hotter (any workload
> involving hotter large file and many small cold files will be affected)
> which is reproduced below.
>
> This series improves it while covering ordinary workloads too and should
> fix regressions:
>
> LevelDB Scan / Get, Throughput Total:
> CLRU:         4708.3 ops/s
> MGLRU:        5026.9 ops/s (faster than CLRU, but hurts other workloads)
> MGLRU After:  5179.2 ops/s (even better in all cases, and no regression)
>
> The hot-sequential and cold-random workload can be easily reproduced with
> SQLite and grep. SQLite continuously scans and looks up a small hot
> portion of a DB file, while grep iterates over a set of small files much
> larger than RAM [6]:
>
>          SQLite scan & lookup time:       Grep iterate time:
> CLRU:                       14.51ms               13281.37ms
> MGLRU mainline:            567.05ms               13694.47ms
> MGLRU After this series:    10.58ms               12930.43ms
>

Thanks, Kairui. I'll do a thorough review of the whole patchset over
the next two weeks.

BTW, do you think we need a quick fix patch like the one below
for the above problem before this patchset, so that it can be
backported to stable? I assume your patchset is too large to
backport?

From f9683205d2ab6e3b185022d7d5af3496dfe5f35f Mon Sep 17 00:00:00 2001
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Date: Fri, 16 Oct 2026 11:48:06 +0800
Subject: [PATCH] mm/mglru: fix using folio_mark_accessed to replace
 folio_set_active

Commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
replace folio_set_active") tried to avoid over-protecting
fault-around read-ahead file folios by placing them in the
second-oldest generation instead of the youngest generations.

However, it abuses `PG_referenced` on read-ahead file folios
for this purpose, potentially coupling their handling with
normal syscall-based file accesses that also use
`PG_referenced`.

This could regress some workloads, as reported by Kairui Song[1]
and Ehab Ababneh[2]. Many thanks to both for reporting these
issues!

The long-term fix is Kairui's MGLRU-FG, but in the meantime,
we also need a quick fix that can be backported to stable.

This patch reverts all of the original commit's behavior that
abuses `PG_referenced`, while preserving the semantics of
avoiding over-protection of fault-around read-ahead file
folios by adjusting only `lru_gen_folio_seq()`.
Specifically, fault-around read-ahead file folios with
`PG_active` set but `PG_workingset` clear are placed in the
second-oldest generation.
Activated file folios and refaulted workingset file folios
are still placed in the youngest generations.

Build kernel cases in a memcg shows it not only perserve
the benefit of original patch, but also even improve
performance further.

w/o fix:

real    1m49.094s
user    25m31.484s
sys     3m40.959s
pswpin: 662112
pswpout: 2504415
pgpgin: 4424336
pgpgout: 10355273
refault_file: 359626
refault_anon: 670724

w/ fix:

real	1m48.913s
user	25m31.639s
sys	3m30.875s
pswpin: 689815
pswpout: 2689894
pgpgin: 4422659
pgpgout: 11043464
refault_file: 326566
refault_anon: 697138

Revert original patch:

real	1m50.044s
user	25m37.137s
sys	4m4.493s
pswpin: 1349087
pswpout: 4317933
pgpgin: 7083597
pgpgout: 17602735
refault_file: 337676
refault_anon: 1368542

[1] https://lore.kernel.org/linux-mm/20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com/
[2] https://lore.kernel.org/linux-mm/20260901180704.168106-1-ehab.ababneh@intel.com/
Fixes: 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to replace folio_set_active")
Cc: <stable@vger.kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 include/linux/mm_inline.h |  8 +++++---
 mm/folio.c                | 16 +++-------------
 mm/vmscan.c               |  9 ++-------
 mm/workingset.c           | 10 ++++------
 4 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..7aaff4e06e80 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -311,7 +311,8 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	 * | Accessed through page tables and  | Accessed through file descriptors |
 	 * | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
 	 * +-----------------------------------+-----------------------------------+
-	 * | PG_active (set while isolated)    |                                   |
+	 * | PG_active (set while isolated)    | PG_active (files|                 |
+	 * |                                   | fault-readahead)|                 |
 	 * +-----------------+-----------------+-----------------+-----------------+
 	 * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU_REFS_FLAGS |
 	 * +-----------------------------------+-----------------------------------+
@@ -319,7 +320,8 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	 * |<---------------------------- MAX_NR_GENS ---------------------------->|
 	 */
 	if (folio_test_active(folio))
-		gen = MIN_NR_GENS - folio_test_workingset(folio);
+		gen = MIN_NR_GENS - folio_test_workingset(folio) +
+		      (type ? !folio_test_workingset(folio) : 0);
 	else if (reclaiming)
 		gen = MAX_NR_GENS;
 	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
@@ -327,7 +329,7 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
 		gen = MIN_NR_GENS;
 	else
-		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
+		gen = MAX_NR_GENS - folio_test_workingset(folio);

 	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
 }
diff --git a/mm/folio.c b/mm/folio.c
index 35e242b48870..2af724cecb31 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -474,20 +474,10 @@ void folio_add_lru(struct folio *folio)
 			folio_test_unevictable(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);

-	/*
-	 * For refaulted workingset folios, set PG_active so they
-	 * can be added to active generations.
-	 * For prefaulted file folios, folio_mark_accessed() sets
-	 * PG_referenced so lru_gen_folio_seq() places them into
-	 * the second oldest generation.
-	 */
+	/* see the comment in lru_gen_folio_seq() */
 	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
-	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
-		if (folio_test_workingset(folio))
-			folio_set_active(folio);
-		else if (!folio_test_referenced(folio))
-			folio_mark_accessed(folio);
-	}
+	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
+		folio_set_active(folio);

 	folio_batch_add_and_move(folio, lru_add);
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index daa7e37c2236..e82ba737c028 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -952,13 +952,8 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 		return false;
 	}

-	/* Promote on second access */
-	if (folio_lru_refs(folio) > 1) {
-		folio_set_workingset(folio);
-		folio_set_lru_refs(folio, 0);
-	} else {
-		folio_mark_accessed(folio);
-	}
+	folio_set_workingset(folio);
+	folio_set_lru_refs(folio, 0);
 	return true;
 }
 #else
diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..10d4ce202cca 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -319,13 +319,11 @@ static void lru_gen_refault(struct folio *folio, void *shadow)

 	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);

+	/* see folio_add_lru() where folio_set_active() will be called */
+	if (lru_gen_in_fault())
+		mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
+
 	if (workingset) {
-		/*
-		 * see folio_add_lru(), where folio_set_active() is
-		 * called for workingset folios
-		 */
-		if (lru_gen_in_fault())
-			mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
 		folio_set_workingset(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
 	} else
--
2.34.1

