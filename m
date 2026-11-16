Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827057;
	b=QsQ2b7jGpdpWVvQthgnX4rxyo41fnkm+9MezeOx/iN5rtBUTMqHaaQGhs4sK5Ji3wNZ2
	 4YppyGTW2jhn9BpPO36Cn3i+TIkzqqhkiYM8xsxj+jPt43pTkQOWqfGdGOZofGOSzJDZE
	 hVQD5G5wefn7LJmWuO61iNe2YLGsKKh/PHAbyO6OVVGXDBSf9hJc15hySxB5ikcagx+yH
	 AmgzDauw1aeikb/ZmcMr0fR5ee6oPpeAczzdiKNP7RyeabjPsnEj3XiYCSf/jIe2zXh8p
	 WjkDVHews03LWl0j0wvlely/yJW4h8xQV/bctVolBVdGuMU1dhESxQB+6F8gM1WyA/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827057;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6xmqR4g0XK6wj9RV+4lISfl7GT2LUw1NTchSXv7pL54=;
	b=EG5aGNRFMxKe6kq7oxZsBaxE1bKr30MSY4w+CLmPckN3qOEURwnc7hEUt5h2VsUntbeo
	 MlFjicIzrfkZfz1/vMSqkquJeV2dOyjEJFVYZIIAPElLWC5OzH2ME+0fwaWq0RQBfA0+5
	 LcKXTDm9gWPCeMNSxMKCr41hfZ/yqc5WLKhCXezfw8AL+TXP4SuGqHzeV2VqtBuhlf/ZP
	 R5ifn/5OYcrs1LztJP/55JBJ5IAFZrmr+T6tjsUh4ol2sN4F9uz/r58Ui+0TLVkQRyrL7
	 CxgWo74sN9gRbJRHNMsAv85rl7kzISQQn9IHE5WpUqytqRnP4jUWBLmSgRk3NB5zDgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VPCW8c1V;
	arc=none smtp.remote-ip=74.125.82.45
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBFF606A31C
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EBFF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VPCW8c1V
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1b3b4bcbfc9so3658613c88.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827055; x=1795431855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6xmqR4g0XK6wj9RV+4lISfl7GT2LUw1NTchSXv7pL54=;
        b=VPCW8c1VEvRlRsnz3iQukzAHhUWA4Z3HwEwQVrkOBsIC3pYtB7E5Fscf1C0h7ytjel
         63oMoFq7c7QhAf68lf6JeLVdKXzH7yRmPKB+4fXViFYvFgP9xqsWUuQpNL5rjInraNX3
         YoZiDJbAtbZ6B24TTKw2NDXFYITxVlz69t7eD63I3PVdKJbDrDNB1o3pOPqmNYWnd3ZV
         q+YL+0ypKACwgH8+73ZV4cVyYHQuxb+0ses31i41ZlFakS23xXmgCNUtYKegk2gZuR4s
         woBJTFTtErko1fUjp3odysRvCVJHYfe/Uf6wb1esJQz31r+2gCjhIT96vFwc9xVF9kR7
         MSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827055; x=1795431855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6xmqR4g0XK6wj9RV+4lISfl7GT2LUw1NTchSXv7pL54=;
        b=ltnakG+rYW/gpDdSM0xjnPdJaiTONK/KRaYN69+im5TCG54qOkrgP+T0+RaBjW665v
         l+bmXD1UyZ2eBWGQuppOWoBb6kbxi3iSHv5Dlj/QvMr4S9s+/E7p11uocYBtg1OLG9Or
         WMTrTqMfETcFEzW40m/mtpsoz+eO5kMAgX1TpzEVBTKN/Ol5dIUQtvfVV66etSS7YfDF
         kCy1PxTUPf2fsaxf2+0q+wIbzxAbj3R5hibiV06G6HjLwqmT1OsmNdaBTlkBt81m8L+I
         50KjovagLgrXnk/gRXO3u066x36nIHQRwCsQti3nfCNQMR/D9YutQadOK5pK1ArhzSdB
         80JQ==
X-Forwarded-Encrypted: i=1; AL+hErEToycN+3w5f0bZC2rLAGOZEmdgPEbVjtfPGOUZG3N7ZRJq19PHunuhd2TWYQS5zVKw8UW+ROdz@vger.kernel.org
X-Gm-Message-State: APuU4Z/dwxzmR/m/iT8JeCDMkV1xZIO0dqh0KZ0FDiq+Jal71BTzDJBx
	xQO3rP2agBsVWuZznfQaS9xehGHbT0IMxG0rKCO1AnnJ/tojEvFZIMO0
X-Gm-Gg: AYBFou2ByaqsZ/413ubKCukoJX1S5RRemJi5C1AYwULH3dlgBqZHlfd4pXX7D+9Hast
	9VlSqO0bojQ1QT0yd4CX4/fCwy+RDBqGH+m/wpWYh2s7uD7t861oGclTqHd4mwNBn7LcBPrnu0M
	lLWZQQ5UlY2mgzMmGjZuS6Mh0M6mzscJ53u0nSgpBaKkILE7JmsCSYuBDVLa0/5kqYpXuvSZNUL
	5wfyQKYrG7zA1quO4UfwQUClObEVZuuZP+q2mfp72i1pz8OHpsNK8IvwTnF3HRcMwsTw8lF1J3q
	tO2wGd+6mLu1vxuIEjetbhpXX2EsApZEQ98/r0K7cZP74AZnkgWSG8uix43cNRF1gN+VW8pF9L4
	piW5VGzUQKt65ogS0q4oWr4LbQmHpCeASuEYX5yIi/8kuKHlWCVU1cg+iBm5O0D8iZGKD3/YrU6
	V+nvNsHvFZEQNOgVwpfBN4/Rb4E64P5bDzBqKudVl5pk13Kld9dIs/CxPZ45R0thtEA0CrroJkz
	U1bTCAmcL4e3QjP3Hg2vlNl86VneF1/0tzEVrCMHwwOF+QXGEDL5n60olag/IGQBpJhaPnGAHld
	tJ0bF1A5qNZt+7cIviTaCo1HNGYMaMnqYmSiILYXc+Wb9b0=
X-Received: by 2002:a05:7023:d08:b0:1b0:4272:4282 with SMTP id a92af1059eb24-1b50312eb7amr12487254c88.17.1794827054221;
        Mon, 16 Nov 2026 03:04:14 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:12 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 07/16] mm: memcomp: write cold pages back to swap
Date: Mon, 16 Nov 2026 19:01:13 +0800
Message-ID: <20261116110122.309748-8-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Compressed storage can consume its RAM budget even when real swap is
available. Give cold allocated payloads a disk-backed state so reclaim
can release their zsmalloc pages while preserving the memcomp tokens.

Select candidates through per-key cluster FIFO queues and enter
writeback through reclaim scopes. Derive the logical-admission watermark
from total RAM and use a 15 percent physical-pool setpoint for feedback.
Bound each pass, including visits to zero-reference entries, so stale
candidates cannot consume an unbounded reclaim scan. The zero domain has
no allocated payload and does not enter these queues.

Pack compressed payloads into shared swap slots and retain raw slots
when sharing is not suitable. Use sibling read caching, slot prefetch
and conservative sole-survivor defragmentation without changing the swap
allocator. Preserve the token's lookup and backing ownership through I/O
and revalidate its state before publishing the result.

Keep state transitions under token locking while allocation and I/O run
outside non-reclaimable locks. Restore the in-memory state when
writeback cannot complete, and release backing only after the last owner
leaves. Refund source-object-cgroup payload charges when backing leaves
RAM.

Drain the affected swap type before the ordinary swapoff scan. Walk
cluster and slot storage with bounded progress, restore the payload
charge before converting backing to RAM, and refund losing races.
Preserve nofs allocation and the reference lifetime across waits, so
swapoff does not reclaim recursively while holding a token lock.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 include/linux/memcomp.h      |   23 +
 mm/Kconfig                   |    8 +-
 mm/memcomp.c                 | 1742 +++++++++++++++++++++++++++++++++-
 mm/memcomp/defrag.h          |  163 ++++
 mm/memcomp/drain.h           |   83 ++
 mm/memcomp/load.h            |   29 +
 mm/memcomp/swapoff.h         |  186 ++++
 mm/memcomp/swapoff_walk.h    |  122 +++
 mm/memcomp/writeback.h       |  132 +++
 mm/memcomp/writeback_batch.h |  386 ++++++++
 mm/swapfile.c                |    4 +
 mm/vmscan.c                  |   84 ++
 12 files changed, 2942 insertions(+), 20 deletions(-)
 create mode 100644 mm/memcomp/defrag.h
 create mode 100644 mm/memcomp/drain.h
 create mode 100644 mm/memcomp/swapoff.h
 create mode 100644 mm/memcomp/swapoff_walk.h
 create mode 100644 mm/memcomp/writeback.h
 create mode 100644 mm/memcomp/writeback_batch.h

diff --git a/include/linux/memcomp.h b/include/linux/memcomp.h
index 20e81dee9062b97274910a1ed3451dd0089ce235..cebad54a3844996c72cd3e413a7d6c7e05df953d 100644
--- a/include/linux/memcomp.h
+++ b/include/linux/memcomp.h
@@ -52,6 +52,8 @@ static inline void memcomp_count_normal_swap_fallback(void)
 {
 }
 #endif
+void memcomp_reclaim_writeback_begin(int nid, int reclaim_idx);
+void memcomp_reclaim_writeback_end(int nid);
 #ifdef CONFIG_MEMCOMP_DEBUG_STATS
 void memcomp_count_anon_fail(enum memcomp_anon_fail_event event,
 			     unsigned int nr_pages);
@@ -127,6 +129,14 @@ bool memcomp_entry_set_refresh_pending(unsigned long token);
 void memcomp_entry_clear_refresh_pending(unsigned long token);
 bool memcomp_entry_get(unsigned long token);
 bool memcomp_entry_present(unsigned long token);
+#ifdef CONFIG_SWAP
+int memcomp_swapoff(unsigned int type);
+#else
+static inline int memcomp_swapoff(unsigned int type)
+{
+	return 0;
+}
+#endif
 
 /*
  * Page-cache variants for shmem/tmpfs pages. A zero store result prepares
@@ -167,6 +177,14 @@ static inline void memcomp_count_normal_swap_fallback(void)
 {
 }
 
+static inline void memcomp_reclaim_writeback_begin(int nid, int reclaim_idx)
+{
+}
+
+static inline void memcomp_reclaim_writeback_end(int nid)
+{
+}
+
 static inline void
 memcomp_count_anon_fail(enum memcomp_anon_fail_event event,
 			unsigned int nr_pages)
@@ -336,6 +354,11 @@ static inline bool memcomp_entry_present(unsigned long token)
 	return false;
 }
 
+static inline int memcomp_swapoff(unsigned int type)
+{
+	return 0;
+}
+
 static inline bool memcomp_store_cache(struct folio *folio,
 				       unsigned long *token)
 {
diff --git a/mm/Kconfig b/mm/Kconfig
index 61356d7e375b4ce4bcf93b5d37108deb8dd655bd..08d366b1593e048f09bb3bc1239add175394f842 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -173,8 +173,9 @@ config ZSWAP_ZPOOL_DEFAULT
 config MEMCOMP
 	bool "Compress reclaimed pages in memory (memcomp)"
 	#
-	# SWAP: memcomp installs swap PTEs of its own type and uses the
-	# generic swap-entry encoding and page-table helpers.
+	# SWAP: memcomp installs swap PTEs of its own type, hooks swapoff,
+	# and writes cold payloads back through real swap.  Without it the
+	# file does not even compile.
 	#
 	# ZRAM=n: !ZRAM also permits ZRAM=m for this bool, so require it off.
 	#
@@ -200,7 +201,8 @@ config MEMCOMP
 
 	  Pages are compressed into RAM and mapped through a special
 	  non-swap PTE entry type. This does not require swap block I/O as
-	  the first storage layer.
+	  the first storage layer. When real swap is enabled, memcomp
+	  may lazily write cold compressed entries back under memory pressure.
 
 	  If unsure, say N.
 
diff --git a/mm/memcomp.c b/mm/memcomp.c
index 07242de736f6771d4a6d74a6182b2cad4c9d150d..465eb11b4ecf4e95967ea416e8141560f6a4bae4 100644
--- a/mm/memcomp.c
+++ b/mm/memcomp.c
@@ -76,6 +76,116 @@
 #define MEMCOMP_MAX_COMPRESSED_SIZE (2 * PAGE_SIZE)
 #define MEMCOMP_MAX_COMPRESS_PAGES 16
 #define MEMCOMP_COMPRESSOR_NAME_LEN 32
+#define MEMCOMP_WRITEBACK_BATCH	SWAP_CLUSTER_MAX
+#define MEMCOMP_WRITEBACK_FEEDBACK_MIN_BYTES \
+	(MEMCOMP_WRITEBACK_BATCH * PAGE_SIZE)
+/*
+ * A severe scope may migrate a bounded share of the node's in-pool cold
+ * payloads, freeing about the same share of the zsmalloc pool footprint.
+ * Draining a share of what remains is self-limiting: the pool can never
+ * be emptied by writeback alone.
+ *
+ * The share is not a threshold but the state of a negative feedback loop,
+ * closed through the zsmalloc pool footprint - the one quantity writing a payload
+ * back actually reduces.  Its error signal is the kernel's own: a scope
+ * only opens when the node is below its low watermark, and the loop asks
+ * whether the pool shrank while the previous share was in force.  Nothing
+ * here names a pool size, a device size or a byte threshold; the share is
+ * whatever sustained pressure has driven it to, and it decays back to
+ * nothing once the pool is holding.
+ *
+ * Only the two gains are constants: how fast an unhelped scope raises the
+ * share, and the ceiling of half the cold payloads that it cannot pass.
+ */
+#define MEMCOMP_WRITEBACK_FRAC_SHIFT	10
+#define MEMCOMP_WRITEBACK_FRAC_ONE \
+	((unsigned int)BIT(MEMCOMP_WRITEBACK_FRAC_SHIFT))
+#define MEMCOMP_WRITEBACK_DRAIN_STEP	(MEMCOMP_WRITEBACK_FRAC_ONE / 64)
+/*
+ * Evidence the loop must accumulate before it grants anything.  A boot or a
+ * short allocation burst opens a scope or two and then the node recovers;
+ * that is not the pool outgrowing its welcome, and draining for it writes
+ * back pages the pool was holding perfectly well.  The share has to clear
+ * the deadband first, which takes a few scopes of unrelieved pressure.
+ *
+ * Set against how long a recovered node keeps: together they decide when a
+ * growing pool starts being drained.  Too much of either and a workload has
+ * to build gigabytes before anything moves, because the intermittent
+ * recoveries of the ramp keep knocking the share back down.
+ */
+#define MEMCOMP_WRITEBACK_DRAIN_DEADBAND	MEMCOMP_WRITEBACK_DRAIN_STEP
+/* Ceiling sits a deadband above half, so the top of the ramp still grants half. */
+#define MEMCOMP_WRITEBACK_DRAIN_MAX		(MEMCOMP_WRITEBACK_FRAC_ONE / 2 + \
+						 MEMCOMP_WRITEBACK_DRAIN_DEADBAND)
+/*
+ * What a recovered node keeps, so transient pressure cannot accumulate into
+ * writeback while still letting the ramp of a real workload build.
+ */
+#define MEMCOMP_WRITEBACK_DRAIN_RECOVER_SHIFT	1
+/*
+ * How much physical memory the compressed pool may occupy, in permille of
+ * total RAM, before any of it is written out.  Below this the pool keeps
+ * everything and compression carries the load on its own; above it the excess
+ * is what the level asks to drain.  This is the setpoint of the level term
+ * rather than a pool or device size - see memcomp_writeback_level_floor().
+ *
+ * At 15% of RAM the pool still holds the larger part of what it compressed
+ * while a workload that fills it moves roughly half the payload out.  The
+ * loop settles within a few percent of this, so it is the number that decides
+ * the split, and it is the only one to change if the pool should keep more or
+ * less.
+ */
+#define MEMCOMP_WRITEBACK_LEVEL_PERMILLE		150
+/*
+ * The gate in front of all of that: how much uncompressed memory the pool
+ * holds, in permille of total RAM, before writeback runs at all.
+ *
+ * The loop and the level floor decide how fast to drain once draining is
+ * wanted; neither decides whether it is.  The loop steps up on any scope
+ * whose pool did not shrink, and between the back-to-back shrink_node()
+ * calls of one kswapd wakeup the pool always grows, because reclaim is
+ * what fills it.  So every wakeup of a few calls raises the share, and a
+ * device that goes through a few such wakeups an hour, with a pool that
+ * never gets near the level, writes back a slice of it each time.  Over a
+ * day that swaps out most of what the pool holds.  The level floor cannot
+ * stop that either: it is max()ed into the share, so it can raise the
+ * share but never lower it.
+ *
+ * So the gate asks the question separately, on the one number the user
+ * sees as "how much is compressed": the entries in the pool.  Writeback
+ * moves those one for one, unlike the stored total, so the gate sees its
+ * own effect.  It opens at two thirds of RAM and closes at three fifths,
+ * and while closed nothing is granted, nothing is carried over, and
+ * the loop is reset so that the next opening starts from reset state.
+ * While open, every grant, quota and writeback worker pass is
+ * capped at the entries above the close point, so writeback can never
+ * take the pool below it however long the loop has been winding up.
+ *
+ * The footprint term is a backstop for incompressible data: at worse than
+ * about 2.7:1 the pool's footprint reaches a quarter of RAM before the
+ * entries reach two thirds, and the gate opens on that instead.
+ */
+#define MEMCOMP_WRITEBACK_GATE_START_PERMILLE	667
+#define MEMCOMP_WRITEBACK_GATE_STOP_PERMILLE	600
+#define MEMCOMP_WRITEBACK_GATE_FP_START_PERMILLE	250
+#define MEMCOMP_WRITEBACK_GATE_FP_STOP_PERMILLE	200
+/*
+ * Pace the off-reclaim drain so it interleaves with whatever the device is
+ * doing instead of monopolising the storage right after a workload exits.
+ */
+#define MEMCOMP_WRITEBACK_DRAIN_DELAY	msecs_to_jiffies(200)
+/* Slices the off-reclaim drain spends its quota in, to bound one pass. */
+#define MEMCOMP_WRITEBACK_DRAIN_SLICES	16UL
+/*
+ * And an absolute bound on one pass, whatever the quota.  Each entry is one
+ * page-sized swap write; a pass submits them in MEMCOMP_WRITEBACK_BATCH
+ * asynchronous groups and waits once per group, so it costs about
+ * limit/MEMCOMP_WRITEBACK_BATCH blocking waits with the device kept at
+ * batch depth in between.  At this cap that is a handful of waits - a few
+ * milliseconds against the delay between passes, leaving most of the device
+ * for whoever is using it.
+ */
+#define MEMCOMP_WRITEBACK_DRAIN_SLICE_MAX	512UL
 #define MEMCOMP_CTX_TIMING_SAMPLE_SHIFT 8
 #define MEMCOMP_CTX_TIMING_SAMPLE_INTERVAL \
 	(1U << MEMCOMP_CTX_TIMING_SAMPLE_SHIFT)
@@ -239,8 +349,30 @@ struct memcomp_lru {
 
 static struct memcomp_lru memcomp_lrus[MAX_NUMNODES];
 
+static struct shrinker *memcomp_shrinker;
 static struct shrinker *memcomp_meta_shrinker;
 
+#ifdef CONFIG_SWAP
+static struct delayed_work memcomp_writeback_drain_work;
+
+/*
+ * The writepage plug handed to __swap_writepage().  On a swapfile
+ * (SWP_FS_OPS) it coalesces the batch's writes into direct-I/O chains
+ * instead of submitting one kiocb per page; on a block device the writes
+ * are already separate bios and the plug is unused.  It lives as long as
+ * the batch does and is unplugged by the flush - or by swapoff, which
+ * takes the same lock - before any of the folios are waited on.
+ */
+static struct swap_iocb *memcomp_writeback_plugged;
+
+static void memcomp_writeback_drain_schedule(int nid);
+static void memcomp_writeback_drain_worker(struct work_struct *work);
+static bool memcomp_writeback_defrag_due(void);
+static bool memcomp_writeback_defrag_pass(void);
+/* Set by a gate-closed period end with swap short; see the defrag below. */
+static bool memcomp_writeback_defrag_armed;
+#endif
+
 static struct zs_pool *memcomp_pools[MEMCOMP_NR_POOLS];
 static int memcomp_nr_pools;
 
@@ -385,6 +517,21 @@ __setup("memcomp.compressor=", memcomp_compressor_setup);
 static atomic64_t memcomp_stored_bytes = ATOMIC64_INIT(0);
 /* Compressed bytes represented by live memcomp entries. */
 static atomic64_t memcomp_compressed_bytes = ATOMIC64_INIT(0);
+static atomic_t memcomp_writeback_scopes[MAX_NUMNODES];
+static atomic_t memcomp_writeback_stopped[MAX_NUMNODES];
+static spinlock_t memcomp_writeback_scope_locks[MAX_NUMNODES];
+static int memcomp_writeback_reclaim_idx[MAX_NUMNODES];
+static u64 memcomp_writeback_stored_bytes[MAX_NUMNODES];
+static u64 memcomp_writeback_pool_bytes[MAX_NUMNODES];
+static bool memcomp_writeback_feedback_valid[MAX_NUMNODES];
+/* Loop state: share of cold payloads a scope may drain, in 1/1024ths. */
+static unsigned int memcomp_writeback_drain[MAX_NUMNODES];
+/* Entries the off-reclaim drain still owes, settled once per period end. */
+static unsigned long memcomp_writeback_carry[MAX_NUMNODES];
+static unsigned long memcomp_writeback_budget[MAX_NUMNODES];
+/* Level gate latch, see MEMCOMP_WRITEBACK_GATE_START_PERMILLE. */
+static atomic_t memcomp_writeback_gate_open = ATOMIC_INIT(0);
+
 #ifdef CONFIG_MEMCOMP_DEBUG_STATS
 /* Keep debug-only selection diagnostics off a globally contended cacheline. */
 enum memcomp_placement_stat {
@@ -399,6 +546,18 @@ struct memcomp_placement_stats {
 
 static DEFINE_PER_CPU(struct memcomp_placement_stats,
 			      memcomp_placement_stats);
+static atomic64_t memcomp_writeback_pressure_events = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_pressure_scans = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_payloads = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_zs_reclaimed = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_zs_no_progress = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_compression_throttled = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_limited_batches = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_budget_granted = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_gate_opens = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_packed_slots = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_packed_payloads = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_defrag_moved = ATOMIC64_INIT(0);
 
 /* Cumulative hot-path events used to diagnose reclaim capacity. */
 static atomic64_t memcomp_ctx_busy = ATOMIC64_INIT(0);
@@ -477,6 +636,8 @@ static atomic64_t memcomp_pageout_store_fail = ATOMIC64_INIT(0);
 static atomic64_t memcomp_swapped_read_io = ATOMIC64_INIT(0);
 static atomic64_t memcomp_swapped_read_error = ATOMIC64_INIT(0);
 static atomic64_t memcomp_swapped_read_cached = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_decompress_error = ATOMIC64_INIT(0);
+static atomic64_t memcomp_writeback_write_error = ATOMIC64_INIT(0);
 static atomic_long_t memcomp_swapped_entries = ATOMIC_LONG_INIT(0);
 static atomic64_t memcomp_swapoff_entries = ATOMIC64_INIT(0);
 static atomic64_t memcomp_swapoff_read_io = ATOMIC64_INIT(0);
@@ -720,6 +881,11 @@ static void memcomp_objcg_uncharge(struct obj_cgroup *objcg, size_t size)
  * build keeps the direct calls.
  */
 
+static int memcomp_slot_dup(swp_entry_t swap)
+{
+	return swap_duplicate(swap);
+}
+
 static void memcomp_slot_put(swp_entry_t swap)
 {
 	swap_free(swap);
@@ -738,6 +904,10 @@ static void memcomp_slot_put_packed(swp_entry_t swap)
 }
 
 /* References on the slot, of entries and in-flight faults; racy by nature. */
+static int memcomp_slot_count(swp_entry_t swap)
+{
+	return __swap_count(swap);
+}
 
 /*
  * Detach a swap-backed entry from its slot.  Caller holds the token lock
@@ -759,6 +929,14 @@ static void memcomp_slot_put_packed(swp_entry_t swap)
 #include "memcomp/query.h"
 #include "memcomp/scan.h"
 #include "memcomp/payload.h"
+#include "memcomp/writeback.h"
+
+static struct memcomp_lru *memcomp_lru_nid(int nid)
+{
+	if (nid < 0 || nid >= MAX_NUMNODES)
+		return NULL;
+	return &memcomp_lrus[nid];
+}
 
 /* Caller holds the token lock. */
 
@@ -835,6 +1013,20 @@ static unsigned int memcomp_pool_huge_class_size(void)
 
 #endif
 
+static unsigned long memcomp_pool_compact(void)
+{
+	unsigned long freed = 0;
+	int i;
+
+	if (!memcomp_is_enabled())
+		return 0;
+
+	for (i = 0; i < memcomp_nr_pools; i++)
+		freed += zs_compact(memcomp_pools[i]);
+
+	return freed;
+}
+
 static u8 memcomp_select_pool_idx(void)
 {
 	return raw_smp_processor_id() % memcomp_nr_pools;
@@ -881,6 +1073,602 @@ void memcomp_count_normal_swap_fallback(void)
 }
 #endif
 
+enum memcomp_writeback_feedback {
+	MEMCOMP_WRITEBACK_PENDING,
+	MEMCOMP_WRITEBACK_EFFECTIVE,
+	MEMCOMP_WRITEBACK_INEFFICIENT,
+};
+
+/*
+ * Compare new logical payload against the real zsmalloc pool footprint accumulated
+ * since this pressure scope began.  This turns current compression efficacy
+ * into the feedback signal: zsmalloc pool that is not growing, or grows by at most
+ * half of the reclaimed source bytes, gets another compression-first pass.
+ */
+static enum memcomp_writeback_feedback
+memcomp_writeback_feedback_values(u64 stored_start, u64 pool_start,
+				  u64 stored_bytes, u64 pool_bytes)
+{
+	u64 stored_growth;
+	u64 pool_growth;
+
+	if (stored_bytes <= stored_start)
+		return MEMCOMP_WRITEBACK_PENDING;
+
+	stored_growth = stored_bytes - stored_start;
+	/* Do not mistake one zsmalloc page allocation for poor compression. */
+	if (stored_growth < MEMCOMP_WRITEBACK_FEEDBACK_MIN_BYTES)
+		return MEMCOMP_WRITEBACK_PENDING;
+	if (pool_bytes <= pool_start)
+		return MEMCOMP_WRITEBACK_EFFECTIVE;
+	pool_growth = pool_bytes - pool_start;
+	if (pool_growth <= stored_growth / 2)
+		return MEMCOMP_WRITEBACK_EFFECTIVE;
+
+	return MEMCOMP_WRITEBACK_INEFFICIENT;
+}
+
+/*
+ * Next drain share for a node, in 1/1024ths of its cold payloads.
+ *
+ * This is the loop's integrator, and the loop closes through the zsmalloc pool
+ * footprint: draining moves payloads out of the pool, the pool shrinks,
+ * and the next severe scope backs off.  @pool_shrank is that measurement,
+ * taken across the interval the previous share was in force, so it already
+ * nets writeback against whatever new compression arrived meanwhile.
+ *
+ * Additive increase, multiplicative decrease.  A scope whose predecessor
+ * failed to shrink the pool - too small a share to matter, or compression
+ * outrunning writeback - raises the share by one step.
+ *
+ * The pool yielding is the only thing that lowers the share, and it gives
+ * back a quarter: overshooting here costs a few extra swap writes rather
+ * than anything structural, and handing back half the ramp after a single
+ * good scope leaves the loop hovering at twice the step, too low to drain
+ * a pool that keeps refilling.
+ *
+ * The compression sample only slows the rise.  It reports net-positive
+ * whenever the pool grows by at most half of what was stored, i.e. at any
+ * ratio better than 2:1 - which is the normal case for a compressed pool,
+ * not an exceptional one.  Letting it force a decay pinned the share at
+ * zero for exactly the workloads that grow the pool: every scope of a
+ * healthy 2.5:1 workload halved a share that had never been allowed to
+ * rise.  A pool earning its keep is a reason to lean on it a little
+ * longer, not evidence that its footprint is harmless.
+ *
+ * Note a pool that merely holds steady raises the share rather than
+ * lowering it: the node is below its watermark and the pool is not
+ * yielding, which is what the share exists to correct.  One scope of
+ * draining is enough to shrink it and start the decay.
+ *
+ * Rising by a step and falling by a fraction settles near the smallest
+ * share that holds the pool rather than overshooting past it, and cannot
+ * latch at zero: while pressure persists and the pool is not yielding,
+ * every scope raises the share again.
+ */
+static unsigned int
+memcomp_writeback_drain_next(unsigned int drain,
+			     enum memcomp_writeback_feedback feedback,
+				 bool pool_shrank)
+{
+	unsigned int step = MEMCOMP_WRITEBACK_DRAIN_STEP;
+
+	if (pool_shrank) {
+		/* Always give something back, so the decay reaches zero. */
+		unsigned int give_back = max(drain / 4, 1U);
+
+		return drain > give_back ? drain - give_back : 0;
+	}
+
+	if (feedback == MEMCOMP_WRITEBACK_EFFECTIVE)
+		step /= 2;
+
+	return min(drain + step, (unsigned int)MEMCOMP_WRITEBACK_DRAIN_MAX);
+}
+
+/*
+ * Payload-entry budget for one severe scope: the part of @drain above the
+ * deadband, applied to the node's in-pool cold payloads.  Once past the
+ * deadband a node still holding a whole batch of them keeps a budget of at
+ * least one entry, so a small share cannot round down to no writeback at
+ * all while the loop is asking for some.
+ */
+static unsigned long
+memcomp_writeback_budget_values(unsigned long cold_entries,
+				unsigned int drain)
+{
+	unsigned long budget;
+
+	if (drain <= MEMCOMP_WRITEBACK_DRAIN_DEADBAND)
+		return 0;
+	drain -= MEMCOMP_WRITEBACK_DRAIN_DEADBAND;
+
+	budget = (unsigned long)(((u64)cold_entries * drain) >>
+				 MEMCOMP_WRITEBACK_FRAC_SHIFT);
+	if (!budget && cold_entries >= MEMCOMP_WRITEBACK_BATCH)
+		budget = 1;
+
+	return budget;
+}
+
+/*
+ * How many entries one pass of the off-reclaim drain may move, given the
+ * quota it still owes.
+ *
+ * The quota is spent in slices so a pass is bounded and the device stays
+ * responsive while it drains.  The absolute cap is the load-bearing part: a
+ * slice that is only a fraction of the quota scales with it, and the quota is
+ * at its largest exactly when a memory-hungry workload has just exited - the
+ * moment someone picks the device up.  Left uncapped the first pass is tens of
+ * thousands of entries, which is seconds of back-to-back synchronous writes
+ * with the batch lock held, repeated every period until the quota runs out.
+ *
+ * Never more than the cap, never more than is owed, and never zero while
+ * anything is owed - a slice that rounded down to nothing would stall the
+ * quota rather than spend it.
+ */
+static unsigned long memcomp_writeback_drain_slice(unsigned long quota)
+{
+	unsigned long limit;
+
+	limit = max(quota / MEMCOMP_WRITEBACK_DRAIN_SLICES,
+		    (unsigned long)MEMCOMP_WRITEBACK_BATCH);
+
+	return min3(limit, quota,
+		    (unsigned long)MEMCOMP_WRITEBACK_DRAIN_SLICE_MAX);
+}
+
+/*
+ * What a node's drain share decays to when the node climbs back on its own.
+ *
+ * The pressure that raised the share is gone, so it should not be kept in
+ * full - but a node that recovers is not the same as one that never needed
+ * the share, so it is not dropped either.  Keeping half means a boot or a
+ * short allocation burst, which opens a handful of scopes and then recovers,
+ * settles at a bounded multiple of the burst length instead of accumulating
+ * across a long uptime until an idle device starts writing back.  Real
+ * pressure never reaches here and keeps everything it earned.
+ */
+static unsigned int memcomp_writeback_drain_recover(unsigned int drain)
+{
+	return drain >> MEMCOMP_WRITEBACK_DRAIN_RECOVER_SHIFT;
+}
+
+/*
+ * Floor on the share, in 1/1024ths, from how far the pool's physical
+ * footprint sits above the level it is allowed to occupy.
+ *
+ * The loop above is a rate controller: its only inputs are the sign of the
+ * footprint's change and the compression ratio, and neither is a function of
+ * how large the pool actually is.  Its equilibrium is therefore "writeback
+ * removes as fast as compression adds", reached at whatever size the pool
+ * happened to have when the rates met - a pool twice as large settles at the
+ * same share as a pool half the size, because both have stopped growing.
+ * That is the right shape for trimming and no shape at all for deciding how
+ * much of a large pool belongs in swap.
+ *
+ * So state the level separately, as the share of the pool that is over the
+ * line: below the target nothing is asked for, and above it the excess
+ * fraction is, capped so no single scope drains more than half.  Draining
+ * that share removes about that fraction of the footprint, which is why the
+ * error closes - the next scope measures a smaller pool and asks for less,
+ * until the pool is at the target and the level asks for nothing at all.
+ *
+ * The variable has to be the footprint and nothing else.  Writeback moves a
+ * payload from zsmalloc pool to swap; it does not change the stored total, which only
+ * entry release moves.  A level built on stored bytes therefore never sees
+ * its own effect: it stays pinned at the cap and every scope asks for half of
+ * what is left, which drains the pool to nothing.  The target is a fraction
+ * of total RAM, so the policy still names no device or pool size.
+ */
+static unsigned int memcomp_writeback_level_floor_values(u64 pool_bytes,
+							 u64 total_bytes)
+{
+	u64 target;
+	u64 excess;
+	u64 frac;
+
+	if (!total_bytes || !pool_bytes)
+		return 0;
+
+	target = div64_u64(total_bytes * MEMCOMP_WRITEBACK_LEVEL_PERMILLE,
+			   1000);
+	if (pool_bytes <= target)
+		return 0;
+
+	/* Share of the footprint that is above the line. */
+	excess = pool_bytes - target;
+	frac = div64_u64(excess * MEMCOMP_WRITEBACK_FRAC_ONE, pool_bytes);
+	frac = min_t(u64, frac, MEMCOMP_WRITEBACK_FRAC_ONE / 2);
+
+	/* Stated as a share, so the deadband subtraction gives it back. */
+	return (unsigned int)frac + MEMCOMP_WRITEBACK_DRAIN_DEADBAND;
+}
+
+static unsigned int memcomp_writeback_level_floor(u64 pool_bytes)
+{
+	return memcomp_writeback_level_floor_values(pool_bytes,
+			(u64)totalram_pages() << PAGE_SHIFT);
+}
+
+/*
+ * Advance the level gate's latch and return how many entries writeback may
+ * still move, i.e. how far the pool sits above the close point.  Zero means
+ * the gate is closed.  @in_pool is the number of entries in the pool,
+ * @pool_bytes its footprint, @total_pages the RAM both are measured against.
+ * Pure, so the suite can drive it with any numbers.
+ *
+ * Both terms state the excess in entries.  The footprint term converts its
+ * byte excess at the pool's average entry size, so draining that many entries
+ * removes about that many bytes; the larger of the two is what must go.
+ */
+static unsigned long
+memcomp_writeback_gate_values(bool *open, unsigned long in_pool,
+			      u64 pool_bytes, unsigned long total_pages)
+{
+	u64 total_bytes = (u64)total_pages << PAGE_SHIFT;
+	unsigned long start, stop;
+	u64 fp_start, fp_stop;
+	unsigned long excess = 0;
+
+	start = (unsigned long)div64_u64((u64)total_pages *
+			MEMCOMP_WRITEBACK_GATE_START_PERMILLE, 1000);
+	stop = (unsigned long)div64_u64((u64)total_pages *
+			MEMCOMP_WRITEBACK_GATE_STOP_PERMILLE, 1000);
+	fp_start = div64_u64(total_bytes *
+			MEMCOMP_WRITEBACK_GATE_FP_START_PERMILLE, 1000);
+	fp_stop = div64_u64(total_bytes *
+			MEMCOMP_WRITEBACK_GATE_FP_STOP_PERMILLE, 1000);
+
+	if (!*open && total_pages && in_pool &&
+	    (in_pool >= start || pool_bytes >= fp_start))
+		*open = true;
+	if (!*open)
+		return 0;
+
+	if (in_pool > stop)
+		excess = in_pool - stop;
+	if (pool_bytes > fp_stop) {
+		u64 fp_excess = div64_u64((u64)in_pool * (pool_bytes - fp_stop),
+					  pool_bytes);
+
+		excess = max_t(unsigned long, excess, (unsigned long)fp_excess);
+	}
+	if (!excess)
+		*open = false;
+
+	return excess;
+}
+
+static unsigned long memcomp_writeback_in_pool(void)
+{
+	unsigned long in_pool = 0;
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY) {
+		struct memcomp_lru *lru = memcomp_lru_nid(nid);
+
+		if (lru)
+			in_pool += atomic_long_read(&lru->nr_entries);
+	}
+
+	return in_pool;
+}
+
+/*
+ * Re-read the level and advance the gate.  Returns @nid's part of the
+ * excess - its share of the pool's entries, so that the nodes together can
+ * never move more than the excess - or zero when the gate is closed.
+ *
+ * Only the caller that sees the gate open or close accounts for it, and the
+ * per-node loop state is reset by each node itself: a grant or quota on a
+ * closed gate clears its own node, and the worker clears every carry.  That
+ * keeps this free of the per-node scope locks, which grants already hold.
+ */
+static unsigned long memcomp_writeback_gate_excess(int nid, u64 pool_bytes)
+{
+	struct memcomp_lru *lru = memcomp_lru_nid(nid);
+	unsigned long in_pool = memcomp_writeback_in_pool();
+	unsigned long node, excess;
+	int was = atomic_read(&memcomp_writeback_gate_open);
+	bool open = was;
+
+	excess = memcomp_writeback_gate_values(&open, in_pool, pool_bytes,
+					       totalram_pages());
+	if (open != was &&
+	    atomic_cmpxchg(&memcomp_writeback_gate_open, was, open) == was &&
+	    open)
+		memcomp_debug_inc(&memcomp_writeback_gate_opens);
+	if (!excess || !lru)
+		return 0;
+
+	node = atomic_long_read(&lru->nr_entries);
+	if (node >= in_pool)
+		return excess;
+
+	return (unsigned long)div64_u64((u64)excess * node, in_pool);
+}
+
+static bool memcomp_writeback_node_below_low(int nid, int reclaim_idx);
+
+/* Caller holds the per-node scope lock. */
+static void
+memcomp_writeback_feedback_start_locked(int nid, u64 stored_bytes,
+					u64 pool_bytes)
+{
+	WRITE_ONCE(memcomp_writeback_stored_bytes[nid], stored_bytes);
+	WRITE_ONCE(memcomp_writeback_pool_bytes[nid], pool_bytes);
+	WRITE_ONCE(memcomp_writeback_feedback_valid[nid], true);
+}
+
+/*
+ * Advance the loop and grant this severe scope's payload-entry budget.
+ * The measurement that closes the loop is whether the zsmalloc pool footprint
+ * shrank while the previous share was in force; the compression sample
+ * decides whether the pool growing was worth it.  Caller holds the
+ * per-node scope lock.
+ */
+static void
+memcomp_writeback_budget_grant_locked(int nid, u64 stored_bytes,
+				      u64 pool_bytes, unsigned long excess)
+{
+	enum memcomp_writeback_feedback feedback =
+		MEMCOMP_WRITEBACK_PENDING;
+	struct memcomp_lru *lru = memcomp_lru_nid(nid);
+	unsigned long cold = lru ? atomic_long_read(&lru->nr_entries) : 0;
+	bool pool_shrank = false;
+	unsigned long budget;
+	unsigned int drain;
+
+	/*
+	 * A closed gate grants nothing and does not let the loop move: a
+	 * pool below the gate is not a pool the loop has anything to say
+	 * about, however the last few scopes went.  Whatever share an
+	 * earlier opening earned goes with it, so the next opening starts
+	 * from zero.  The sample is still taken, so that opening has one.
+	 */
+	if (!excess) {
+		WRITE_ONCE(memcomp_writeback_drain[nid], 0);
+		WRITE_ONCE(memcomp_writeback_budget[nid], 0);
+		memcomp_writeback_feedback_start_locked(nid, stored_bytes,
+							pool_bytes);
+		return;
+	}
+
+	drain = READ_ONCE(memcomp_writeback_drain[nid]);
+	if (READ_ONCE(memcomp_writeback_feedback_valid[nid])) {
+		u64 stored_start;
+		u64 pool_start;
+
+		stored_start = READ_ONCE(memcomp_writeback_stored_bytes[nid]);
+		pool_start = READ_ONCE(memcomp_writeback_pool_bytes[nid]);
+		feedback = memcomp_writeback_feedback_values(stored_start,
+							     pool_start,
+								 stored_bytes,
+								 pool_bytes);
+		pool_shrank = pool_bytes < pool_start;
+		drain = memcomp_writeback_drain_next(drain, feedback,
+						     pool_shrank);
+	}
+	/*
+	 * With no sample there is nothing to judge the last share by: the
+	 * node climbed back above its low watermark since the previous scope,
+	 * which discarded the sample.  Carry the loop's share over; the level
+	 * below is re-derived from the stored memory as it stands, so a share
+	 * left over from a workload that has since exited cannot outlive what
+	 * that workload was holding.
+	 */
+	/*
+	 * The level says how much of this pool belongs in swap; the loop only
+	 * trims above it.  Below the start point the floor is zero and the
+	 * share is exactly what the loop asked for, so boot and short spikes
+	 * behave as before.
+	 */
+	drain = max(drain, memcomp_writeback_level_floor(pool_bytes));
+	drain = min_t(unsigned int, drain, MEMCOMP_WRITEBACK_DRAIN_MAX);
+	WRITE_ONCE(memcomp_writeback_drain[nid], drain);
+	/*
+	 * Above the gate's band the cap does not bind and the loop runs as
+	 * it always has; near the close point it stops the scope there.
+	 */
+	budget = min(memcomp_writeback_budget_values(cold, drain), excess);
+	WRITE_ONCE(memcomp_writeback_budget[nid], budget);
+	memcomp_debug_add(budget, &memcomp_writeback_budget_granted);
+	if (feedback == MEMCOMP_WRITEBACK_EFFECTIVE)
+		memcomp_debug_inc(&memcomp_writeback_compression_throttled);
+	memcomp_writeback_feedback_start_locked(nid, stored_bytes,
+						pool_bytes);
+}
+
+void memcomp_reclaim_writeback_begin(int nid, int reclaim_idx)
+{
+	unsigned long flags;
+	unsigned long excess;
+	u64 stored_bytes;
+	u64 pool_bytes;
+	bool first;
+
+	if (!memcomp_is_enabled() || nid < 0 || nid >= MAX_NUMNODES)
+		return;
+
+	reclaim_idx = clamp(reclaim_idx, 0, MAX_NR_ZONES - 1);
+	stored_bytes = atomic64_read(&memcomp_stored_bytes);
+	pool_bytes = memcomp_pool_total_size();
+	excess = memcomp_writeback_gate_excess(nid, pool_bytes);
+	spin_lock_irqsave(&memcomp_writeback_scope_locks[nid], flags);
+	first = !atomic_read(&memcomp_writeback_scopes[nid]);
+	if (first) {
+		WRITE_ONCE(memcomp_writeback_reclaim_idx[nid], reclaim_idx);
+		memcomp_writeback_budget_grant_locked(nid, stored_bytes,
+						      pool_bytes, excess);
+		atomic_set(&memcomp_writeback_stopped[nid], 0);
+	}
+	atomic_inc(&memcomp_writeback_scopes[nid]);
+	spin_unlock_irqrestore(&memcomp_writeback_scope_locks[nid], flags);
+
+	if (first)
+		memcomp_debug_inc(&memcomp_writeback_pressure_events);
+}
+
+void memcomp_reclaim_writeback_end(int nid)
+{
+	unsigned long flags;
+	int reclaim_idx = 0;
+	int scopes;
+	bool last = false;
+
+	if (!memcomp_is_enabled() || nid < 0 || nid >= MAX_NUMNODES)
+		return;
+
+	spin_lock_irqsave(&memcomp_writeback_scope_locks[nid], flags);
+	scopes = atomic_read(&memcomp_writeback_scopes[nid]);
+	if (WARN_ON_ONCE(scopes <= 0)) {
+		atomic_set(&memcomp_writeback_scopes[nid], 0);
+	} else {
+		last = scopes == 1;
+		reclaim_idx = READ_ONCE(memcomp_writeback_reclaim_idx[nid]);
+		atomic_dec(&memcomp_writeback_scopes[nid]);
+	}
+	spin_unlock_irqrestore(&memcomp_writeback_scope_locks[nid], flags);
+
+	/*
+	 * Settle the off-reclaim drain's quota at every period end, not only
+	 * at one that saw the node recover.  A workload exiting frees its
+	 * memory directly, so the watermarks are satisfied without reclaim
+	 * running again: kswapd's last scope closed while the node was still
+	 * below low, and then kswapd simply slept.  Waiting for a scope to
+	 * end on a recovered node would miss exactly that case - the one
+	 * where the pool is left at its largest and entirely cold.
+	 *
+	 * This is idempotent, and a pass that finds a scope open leaves that
+	 * node to the reclaim path.
+	 */
+	if (last)
+		memcomp_writeback_drain_schedule(nid);
+
+	if (last && !memcomp_writeback_node_below_low(nid, reclaim_idx)) {
+		spin_lock_irqsave(&memcomp_writeback_scope_locks[nid], flags);
+		if (!atomic_read(&memcomp_writeback_scopes[nid])) {
+			unsigned int drain;
+
+			WRITE_ONCE(memcomp_writeback_feedback_valid[nid], false);
+			/*
+			 * The node climbed back on its own, so decay the share
+			 * the pressure earned - see
+			 * memcomp_writeback_drain_recover().  The level
+			 * floor is unaffected either way: it is re-derived
+			 * from stored memory.
+			 */
+			drain = READ_ONCE(memcomp_writeback_drain[nid]);
+			WRITE_ONCE(memcomp_writeback_drain[nid],
+				   memcomp_writeback_drain_recover(drain));
+		}
+		spin_unlock_irqrestore(&memcomp_writeback_scope_locks[nid], flags);
+	}
+}
+
+static bool memcomp_writeback_node_below_low(int nid, int reclaim_idx)
+{
+	struct pglist_data *pgdat;
+	struct zone *zone;
+	bool found = false;
+	int z;
+
+	if (nid < 0 || nid >= MAX_NUMNODES || reclaim_idx < 0 ||
+	    !node_state(nid, N_MEMORY))
+		return false;
+
+	pgdat = NODE_DATA(nid);
+	if (!pgdat)
+		return false;
+
+	reclaim_idx = min_t(int, reclaim_idx, MAX_NR_ZONES - 1);
+	for (z = 0; z <= reclaim_idx; z++) {
+		zone = pgdat->node_zones + z;
+		if (!managed_zone(zone))
+			continue;
+		found = true;
+		if (zone_watermark_ok_safe(zone, 0, low_wmark_pages(zone),
+					   reclaim_idx))
+			return false;
+	}
+
+	return found;
+}
+
+static bool memcomp_writeback_scope_active(int nid)
+{
+	return nid >= 0 && nid < MAX_NUMNODES &&
+		atomic_read(&memcomp_writeback_scopes[nid]) > 0;
+}
+
+static void memcomp_reclaim_writeback_stop(int nid)
+{
+	if (nid >= 0 && nid < MAX_NUMNODES)
+		atomic_set(&memcomp_writeback_stopped[nid], 1);
+}
+
+static bool memcomp_writeback_pressure_active(int nid)
+{
+	/* A scope lives for one shrink_node call; budget bounds its I/O. */
+	return memcomp_writeback_scope_active(nid) &&
+		!atomic_read(&memcomp_writeback_stopped[nid]) &&
+		READ_ONCE(memcomp_writeback_budget[nid]) > 0;
+}
+
+/*
+ * How much of a node's writeback budget one pass may spend.
+ *
+ * Both writeback paths take this from the same place.  Every entry a pass
+ * moves can flush a batch, and a flush is a __swap_writepage() immediately
+ * waited on, so a pass length is a count of blocking device round trips taken
+ * with the global writeback mutex held.  Slicing costs nothing: consume below
+ * subtracts only what was scanned, so the remainder stays in the budget and
+ * memcomp_writeback_pressure_active() keeps reporting pressure until it is
+ * spent.
+ */
+static unsigned long memcomp_writeback_pass_limit(int nid)
+{
+	if (nid < 0 || nid >= MAX_NUMNODES)
+		return 0;
+
+	return memcomp_writeback_drain_slice(READ_ONCE(memcomp_writeback_budget[nid]));
+}
+
+/*
+ * Consume payload-entry budget for the active scope.  Returns the remaining
+ * budget; reaching zero stops new writeback until the next severe scope.
+ */
+static unsigned long memcomp_writeback_budget_consume(int nid,
+						      unsigned long entries)
+{
+	unsigned long budget;
+
+	if (nid < 0 || nid >= MAX_NUMNODES)
+		return 0;
+	budget = READ_ONCE(memcomp_writeback_budget[nid]);
+	if (entries < budget)
+		budget -= entries;
+	else
+		budget = 0;
+	WRITE_ONCE(memcomp_writeback_budget[nid], budget);
+	return budget;
+}
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static unsigned long memcomp_writeback_pressure_scope_count(void)
+{
+	unsigned long active = 0;
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY)
+		active += atomic_read(&memcomp_writeback_scopes[nid]);
+
+	return active;
+}
+
+#endif
+
 static bool memcomp_can_retry_alloc(void)
 {
 	/* PF_MEMALLOC prevents recursive reclaim and permits net progress. */
@@ -2294,31 +3082,867 @@ memcomp_arch_prepare_to_swap(struct folio *folio)
  * on each, NULL to have them looked up here.
  */
 
+#ifdef CONFIG_SWAP
 /*
- * Core load - decompress one page from @entry into @dst.  Sleeps on the
- * token lock and possibly swap IO; never called under the PTE lock.
+ * Writeback: cold payloads leave the pool for real swap slots, and each
+ * slot is written in whichever form costs the device less.
+ *
+ * Consecutive cold payloads are gathered into one open page.  When the
+ * next one does not fit, the page is closed: if it gathered two or more,
+ * their compressed bytes go out back to back in one slot; if it gathered
+ * only one, that one is decompressed and written as its original page,
+ * exactly as a raw writeback would.  So a slot is only ever packed when
+ * packing saves a whole slot, and a packed slot is never worse than the
+ * raw pages it replaces: the write is the same one page, and a fault on
+ * it is the same one-page read plus a decompression.
+ *
+ * The slot's swap count is its reference count - each entry living in it
+ * owns one - so nothing describes a packed slot beyond the entries
+ * themselves.  The last entry to go frees it; there is no descriptor, no
+ * read/modify/write of a live slot and no separate lifetime to manage.
+ * A slot whose other payloads have all gone keeps its one survivor where
+ * it is; the device holds a little dead space rather than paying to move
+ * it.
+ *
+ * Writes are submitted asynchronously and waited on once per batch of
+ * MEMCOMP_WRITEBACK_BATCH slots, so the device sees batch-deep I/O
+ * instead of a submit-and-wait cycle per page under the global lock.
+ * memcomp_writeback_lock serializes passes, which is what lets the
+ * staging batch live here rather than on kswapd's stack.
  */
-#include "memcomp/load.h"
-#include "memcomp/consumers.h"
+/* Payloads per packed slot; far below the swap count's continuation. */
+#define MEMCOMP_WRITEBACK_PACK_MAX	16
 
+/* One payload on its way to the device. */
+
+/* Attempt identity exists even for a denied or unaccounted reservation. */
+
+/* One slot's write: @nr members from @first, packed or one raw page. */
+
+static DEFINE_MUTEX(memcomp_writeback_lock);
 /*
- * Claim a reclaimable entry for writeback.
+ * Members of the written slots, in slot order, followed by those of the
+ * page still open - the ones from memcomp_writeback_open_first on,
+ * with memcomp_writeback_open_bytes of payload between them.
  */
-
-#ifdef CONFIG_SWAP
 /*
- * Migrate up to @limit of @nid's coldest payloads out to swap as original
- * pages.  Returns the number of entries scanned.  Caller holds
- * memcomp_writeback_lock with memalloc_noreclaim_save() in force.
- *
- * Writes are asynchronous; the batch is waited on once per
- * MEMCOMP_WRITEBACK_BATCH stagings and once at the end, so a pass
- * costs about limit/batch blocking waits rather than one per page, with
- * the device kept at batch depth in between.
+ * Swap slots prefetched a batch at a time.  get_swap_pages() takes a device
+ *-wide lock and scans the free-space bitmap per call, and scan_swap_map_slots()
+ * hands out consecutive slots out of one cluster when asked for several at
+ * once, so one call per staging both pays the lock 32 times where once would
+ * do and scatters the writes this batch is about to submit together across
+ * the device.  The pool holds slots taken but not yet attached to a folio;
+ * a flush returns whatever a pass did not use, and swapoff drains it whole.
  */
+static swp_entry_t
+	memcomp_writeback_slot_pool[MEMCOMP_WRITEBACK_BATCH];
+static unsigned int memcomp_writeback_slots_free;
+
+static void memcomp_drop_swapcache_folio(struct folio *folio, bool dirty)
+{
+	if (dirty)
+		folio_mark_dirty(folio);
+	if (folio_test_swapcache(folio)) {
+		folio_wait_writeback(folio);
+		delete_from_swap_cache(folio);
+	}
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
+static void memcomp_writeback_slots_release(swp_entry_t *slots,
+					    unsigned int n)
+{
+	swapcache_free_entries(slots, n);
+}
+
+/* Return every prefetched slot this pass did not spend. */
+static void memcomp_writeback_slots_return(void)
+{
+	if (!memcomp_writeback_slots_free)
+		return;
+
+	/*
+	 * Prefetched slots were never installed into the swap cache, so
+	 * they are plain uncommitted reservations: hand them back to the
+	 * device's free list as a batch through the same entry point that
+	 * releases unused allocations.
+	 */
+	memcomp_writeback_slots_release(memcomp_writeback_slot_pool,
+					memcomp_writeback_slots_free);
+	memcomp_writeback_slots_free = 0;
+}
+
+/*
+ * Take one prefetched slot, refilling the pool a full batch at a time when
+ * it runs dry.  Returns 0 with an uncommitted reservation in *@swapp, or
+ * -ENOSPC/-ENOMEM when no slots or no device remain.
+ */
+static int memcomp_writeback_slot_take(swp_entry_t *swapp)
+{
+	unsigned int want;
+
+	if (!memcomp_writeback_slots_free) {
+		want = min_t(unsigned int, MEMCOMP_WRITEBACK_BATCH,
+			     SWAP_BATCH);
+
+		if (get_nr_swap_pages() <= 0)
+			return -ENOSPC;
+		memcomp_writeback_slots_free =
+			get_swap_pages(want, memcomp_writeback_slot_pool, 0);
+		if (!memcomp_writeback_slots_free)
+			return get_nr_swap_pages() <= 0 ? -ENOSPC : -ENOMEM;
+	}
+
+	*swapp = memcomp_writeback_slot_pool[--memcomp_writeback_slots_free];
+	return 0;
+}
+
+/*
+ * One swap slot and a swapcache folio to carry it to the device.  On
+ * success the folio is locked and in the cache, and the slot holds one
+ * extra reference - the one the converted entry will own.
+ */
+static int memcomp_swap_folio_alloc(struct folio **foliop,
+				    swp_entry_t *swapp)
+{
+	struct folio *folio;
+	swp_entry_t swap;
+	int ret;
+
+	ret = memcomp_writeback_slot_take(&swap);
+	if (ret)
+		return ret;
+
+	folio = folio_alloc(GFP_HIGHUSER_MOVABLE | __GFP_NOWARN |
+			    __GFP_NOMEMALLOC, 0);
+	if (!folio) {
+		swapcache_free_entries(&swap, 1);
+		return -ENOMEM;
+	}
+	__folio_set_locked(folio);
+	__folio_set_swapbacked(folio);
+
+	ret = add_to_swap_cache(folio, swap,
+				__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN, NULL);
+	if (ret) {
+		folio_unlock(folio);
+		folio_put(folio);
+		swapcache_free_entries(&swap, 1);
+		return ret;
+	}
+
+	ret = memcomp_slot_dup(swap);
+	if (ret) {
+		delete_from_swap_cache(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+		return ret;
+	}
+
+	*foliop = folio;
+	*swapp = swap;
+	return 0;
+}
+
+/*
+ * Convert a staged entry now that its slot is on the device: the zsmalloc
+ * copy is freed and @swap - with one slot reference the caller hands over -
+ * becomes the payload, at @m->offset when the slot is packed.
+ * @entry->length is left alone: it is the compressed length, which is also
+ * what a packed slot holds, and the stored and compressed byte gauges track
+ * live entries wherever the payload lives.  When this returns false the
+ * caller keeps the reference.
+ */
+
+/* Put a claimed entry back where the claim found it. */
+
+/*
+ * Resolve one written slot's members.  Each member converted takes one of
+ * the slot's references: the first the one staging took, every other one
+ * a duplicate taken here - while the swap cache still holds the slot, so a
+ * duplicate can never find it freed.  A member that raced - refreshed,
+ * freed or claimed back - keeps its pool copy and gives its reference back.
+ */
+
+/*
+ * Write one slot: members @first..@first + @nr - 1, their compressed bytes
+ * back to back when there are several, or the lone one decompressed into
+ * the original page.  The write is submitted, not waited on.
+ */
+
+/*
+ * Write the open page out.  On failure every payload it gathered goes back
+ * to the pool, and the batch's reference on each is dropped.
+ */
+
+/*
+ * Wait for everything the batch submitted and resolve each slot.  Returns
+ * the first device error; every staged entry ends converted or reverted
+ * either way, including those of the page still open, which is written
+ * first so that no entry stays claimed across the lock.
+ *
+ * The waits run as one sweep ahead of the resolution sweep: by the time the
+ * first folio's writeback clears, the rest of the batch's IO has usually
+ * landed with it, and the second sweep then takes each folio lock without
+ * sleeping instead of waking and re-sleeping between resolutions.
+ */
+
+/*
+ * Whether a payload of @length joins the open page, which holds @nr
+ * payloads and @bytes of them.  A page-sized payload never does: it is a
+ * page the compressor could not shrink, and shares its slot with nothing.
+ */
+static bool memcomp_writeback_pack_fits(unsigned int nr,
+					unsigned int bytes,
+					    unsigned int length)
+{
+	return length < PAGE_SIZE && nr < MEMCOMP_WRITEBACK_PACK_MAX &&
+	       bytes + length <= PAGE_SIZE;
+}
+
+/*
+ * Whether the batch must be flushed before the next staging: that one may
+ * close the open page and write itself as well, so it needs two slots.
+ */
+
+/*
+ * Stage one claimed entry into the open page, writing that page first if
+ * the payload does not fit in it.  The batch flush waits and converts.
+ */
+
+/*
+ * Recover an entry's page from the slot image @slot: the whole of it for a
+ * raw slot, or @length compressed bytes at @off decompressed for a packed
+ * one.  A packed payload that does not lie inside the slot is corrupt
+ * state, never a short read.
+ */
+#include "memcomp/writeback_batch.h"
+#include "memcomp/drain.h"
+
+static int memcomp_decode_slot(const void *slot, bool packed,
+			       unsigned int off, unsigned int length,
+				   void *dst)
+{
+	if (!packed) {
+		memcpy(dst, slot, PAGE_SIZE);
+		return 0;
+	}
+	if (!length || length >= PAGE_SIZE || off > PAGE_SIZE - length)
+		return -EIO;
+	return memcomp_decompress_payload(slot + off, length, dst);
+}
+
+/*
+ * Whether a fault should leave a packed slot's page in the swap cache.
+ * @count is the slot's reference count as the fault sees it, which includes
+ * this entry's and the fault's own; anything beyond those two is another
+ * entry still living in the slot, or another fault on its way to it.  A raw
+ * slot has no one else to keep it for.
+ */
+static bool memcomp_slot_keep_cached(bool packed, int count)
+{
+	return packed && count > 2;
+}
+
+/*
+ * Read the slot backing @swap and recover this entry's page from it into
+ * @dst - see memcomp_decode_slot() for @packed, @off and @length.  @gfp
+ * is for the swap cache page, if the slot is not already cached.
+ */
+static int memcomp_read_swapped_page(swp_entry_t swap, bool packed,
+				     unsigned int off, unsigned int length,
+				     void *dst, gfp_t gfp)
+{
+	struct folio *folio;
+	bool allocated;
+	void *src;
+	int ret;
+
+	if (!swap.val || !dst)
+		return -EIO;
+
+	/*
+	 * Through the swap cache, so concurrent faults on the same slot
+	 * share one device read instead of each issuing their own.  There
+	 * is no vma here - the fault path and swapoff both only have the
+	 * swap entry - so the folio follows the task's policy, as zswap's
+	 * writeback does; read_swap_cache_async() would hand a NULL vma to
+	 * get_vma_policy(), which dereferences it on NUMA.
+	 */
+	folio = __read_swap_cache_async(swap, gfp, get_task_policy(current),
+					NO_INTERLEAVE_INDEX, &allocated, false);
+	if (!folio)
+		return -ENOMEM;
+	if (allocated)
+		swap_read_folio(folio, NULL);
+
+	folio_lock(folio);
+	if (!folio_test_uptodate(folio)) {
+		memcomp_drop_swapcache_folio(folio, false);
+		memcomp_debug_inc(&memcomp_swapped_read_error);
+		return -EIO;
+	}
+
+	if (!allocated)
+		memcomp_debug_inc(&memcomp_swapped_read_cached);
+
+	src = kmap_local_folio(folio, 0);
+	ret = memcomp_decode_slot(src, packed, off, length, dst);
+	kunmap_local(src);
+	if (ret)
+		memcomp_debug_inc(&memcomp_swapped_read_error);
+
+	/*
+	 * A packed slot's neighbours were written together because they went
+	 * cold together, and they tend to come back together.  While any of
+	 * them still lives in the slot, leave its page in the swap cache: the
+	 * next of them to fault finds it there and decompresses its payload
+	 * with no device read at all.  Nothing else is kept - the page is
+	 * clean, unmapped and on the LRU, so reclaim drops it like any
+	 * readahead page, and the last entry to leave the slot takes it with
+	 * it (memcomp_slot_put_packed()).
+	 */
+	if (!ret && memcomp_slot_keep_cached(packed,
+					     memcomp_slot_count(swap))) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return 0;
+	}
+	memcomp_drop_swapcache_folio(folio, false);
+	return ret;
+}
+
+/*
+ * Continue draining after a pressure period ends.
+ *
+ * Writeback otherwise only runs inside a severe scope, and a severe scope
+ * only exists while kswapd is looking at a node below its low watermark.
+ * The moment a memory-hungry workload exits, the watermarks are satisfied,
+ * kswapd stops, and every scope closes - leaving a pool that is now
+ * entirely cold, at its largest, and draining nothing until the next
+ * workload pushes the node back down.  That is both the worst time to
+ * still be holding it and the cheapest time to write it out, with the CPU
+ * and the storage otherwise idle.
+ *
+ * So a period that ends with the loop still asking for a share hands that
+ * share to this worker rather than dropping it.  The loop is unchanged -
+ * each pass drains its share, measures the pool, and decays - so the
+ * worker simply runs the same controller off the reclaim path until the
+ * share reaches zero and the pool is holding on its own.
+ */
+static void memcomp_writeback_drain_schedule(int nid)
+{
+	struct memcomp_lru *lru;
+	unsigned long excess;
+	unsigned long quota;
+	u64 pool_bytes;
+
+	if (!memcomp_is_enabled() || !total_swap_pages)
+		return;
+	if (nid < 0 || nid >= MAX_NUMNODES)
+		return;
+
+	lru = memcomp_lru_nid(nid);
+	if (!lru)
+		return;
+
+	/*
+	 * Settle the quota once, here, from the share the period earned and
+	 * the payloads that were cold when it ended.  The worker then spends
+	 * it and stops.  Recomputing a share every pass would instead take
+	 * that fraction of whatever remains, over and over: half of the pool,
+	 * then half of the rest, which drains almost all of it rather than
+	 * the half the loop actually asked for.  Past this much the pool has
+	 * given up what it should and the rest is compression's job again.
+	 */
+	quota = memcomp_writeback_budget_values(atomic_long_read(&lru->nr_entries),
+						READ_ONCE(memcomp_writeback_drain[nid]));
+	/*
+	 * And never more than the pool holds above the gate's close point.
+	 * A closed gate owes nothing, including what an earlier period left.
+	 */
+	pool_bytes = memcomp_pool_total_size();
+	excess = memcomp_writeback_gate_excess(nid, pool_bytes);
+	if (!excess) {
+		WRITE_ONCE(memcomp_writeback_carry[nid], 0);
+		/*
+		 * Nothing to drain, which is the one time the device may be
+		 * tidied - if swap is running short.
+		 */
+		if (!READ_ONCE(memcomp_writeback_defrag_armed) &&
+		    memcomp_writeback_defrag_due()) {
+			WRITE_ONCE(memcomp_writeback_defrag_armed, true);
+			queue_delayed_work(system_power_efficient_wq,
+					   &memcomp_writeback_drain_work,
+					   MEMCOMP_WRITEBACK_DRAIN_DELAY);
+		}
+		return;
+	}
+	quota = min(quota, excess);
+	if (!quota)
+		return;
+
+	if (quota > READ_ONCE(memcomp_writeback_carry[nid]))
+		WRITE_ONCE(memcomp_writeback_carry[nid], quota);
+
+	queue_delayed_work(system_power_efficient_wq,
+			   &memcomp_writeback_drain_work,
+			   MEMCOMP_WRITEBACK_DRAIN_DELAY);
+}
+
+static void memcomp_writeback_drain_worker(struct work_struct *work)
+{
+	unsigned int noreclaim_flag;
+	bool more = false;
+	int nid;
+
+	(void)work;
+
+	if (!memcomp_is_enabled() || !total_swap_pages)
+		return;
+	/* A full device is no drain, but exactly when a defrag pass helps. */
+	if (get_nr_swap_pages() <= 0)
+		goto defrag;
+
+	for_each_node_state(nid, N_MEMORY) {
+		struct memcomp_lru *lru = memcomp_lru_nid(nid);
+		unsigned long freed = 0;
+		unsigned long scanned;
+		unsigned long excess;
+		unsigned long quota;
+		unsigned long limit;
+		u64 pool_bytes;
+		bool attempted = false;
+		int write_ret = 0;
+
+		quota = READ_ONCE(memcomp_writeback_carry[nid]);
+		if (!quota || !lru)
+			continue;
+		/*
+		 * The quota was settled against the pool as it was when the
+		 * period ended; the level is re-read every pass, so the drain
+		 * stops at the gate's close point rather than at the quota.
+		 */
+		pool_bytes = memcomp_pool_total_size();
+		excess = memcomp_writeback_gate_excess(nid, pool_bytes);
+		if (!excess) {
+			WRITE_ONCE(memcomp_writeback_carry[nid], 0);
+			continue;
+		}
+		/*
+		 * A reopened scope owns the node again.  Leave the quota
+		 * alone and come back for it: the scope will settle a fresh
+		 * one when its period ends, but if it does not - a period can
+		 * end without the node recovering - this is the only thing
+		 * that would retry, so it has to re-arm itself rather than
+		 * wait to be armed.
+		 */
+		if (memcomp_writeback_scope_active(nid)) {
+			more = true;
+			continue;
+		}
+
+		limit = min(memcomp_writeback_drain_slice(quota), excess);
+
+		noreclaim_flag = memalloc_noreclaim_save();
+		mutex_lock(&memcomp_writeback_lock);
+		scanned = mc16_writeback_drain_queue(nid, lru, limit,
+						     &freed, &write_ret,
+						     &attempted);
+		mutex_unlock(&memcomp_writeback_lock);
+		memalloc_noreclaim_restore(noreclaim_flag);
+
+		if (freed)
+			memcomp_pool_compact();
+
+		/*
+		 * Only an empty queue or a device error ends the drain early.
+		 * A pass can walk its whole slice without writing anything,
+		 * and that is progress through the queue, not a reason to
+		 * abandon the quota.
+		 */
+		if (!scanned || write_ret)
+			quota = 0;
+		else
+			quota -= min(scanned, quota);
+		(void)attempted;
+		WRITE_ONCE(memcomp_writeback_carry[nid], quota);
+		if (quota)
+			more = true;
+	}
+
+defrag:
+	if (memcomp_writeback_defrag_pass())
+		more = true;
+	if (more)
+		queue_delayed_work(system_power_efficient_wq,
+				   &memcomp_writeback_drain_work,
+				   MEMCOMP_WRITEBACK_DRAIN_DELAY);
+}
+
+/*
+ * Swapoff: every swap-backed entry is read back from the dying device and
+ * its payload rebuilt in the pool.  The slot held the original page, so
+ * coming back it pays compression again rather than occupying a page of
+ * pool for ever; anything the compressor rejects is kept raw instead of
+ * failing the swapoff.  The ops indirection exists so the KUnit suite can
+ * drive the restore logic without a swap device.
+ */
+struct memcomp_swapoff_ops {
+	int (*read_page)(swp_entry_t swap, void *dst);
+	int (*alloc_payload)(const void *src, unsigned int *length,
+			     unsigned long *handle, u8 *pool_idx, void *ctx);
+	void (*free_payload)(u8 pool_idx, unsigned long handle, void *ctx);
+	bool (*interrupted)(void *ctx);
+	void *ctx;
+};
+
+#include "memcomp/swapoff.h"
+#include "memcomp/swapoff_walk.h"
+
+/*
+ * Precharge outside the token mutex, then publish only if the slot still
+ * belongs to this entry.  Return 1 on commit, 0 on a race, or a charge error.
+ * The caller frees the new payload unless this returns 1.
+ */
+
+/* Restore one entry.  1 restored, 0 nothing to do, negative on error. */
+
+/* The slot image as it is on the device; the caller decodes it. */
+static int memcomp_swapoff_read_page(swp_entry_t swap, void *dst)
+{
+	return memcomp_read_swapped_page(swap, false, 0, 0, dst,
+					     GFP_HIGHUSER_MOVABLE | __GFP_NOWARN);
+}
+
+static int memcomp_swapoff_alloc_payload(const void *src,
+					 unsigned int *length,
+					     unsigned long *handle,
+					     u8 *pool_idx, void *ctx)
+{
+	int ret;
+
+	*pool_idx = 0;
+	ret = memcomp_prepare_payload(src, PAGE_SIZE, length, handle,
+				      pool_idx,
+					  MEMCOMP_PAYLOAD_MUST_SUCCEED,
+					  true);
+	if (!ret)
+		return 0;
+
+	/* No context or no fit: keep the page raw rather than fail. */
+	*pool_idx = memcomp_select_pool_idx();
+	return memcomp_alloc_raw_payload(*pool_idx, src, PAGE_SIZE, length,
+					     handle, true, NULL);
+}
+
+static void memcomp_swapoff_free_payload(u8 pool_idx, unsigned long handle,
+					 void *ctx)
+{
+	memcomp_zs_free(pool_idx, handle);
+}
+
+static bool memcomp_swapoff_interrupted(void *ctx)
+{
+	return signal_pending(current);
+}
+
+static const struct memcomp_swapoff_ops memcomp_swapoff_ops = {
+	.read_page = memcomp_swapoff_read_page,
+	.alloc_payload = memcomp_swapoff_alloc_payload,
+	.free_payload = memcomp_swapoff_free_payload,
+	.interrupted = memcomp_swapoff_interrupted,
+};
+
+static int mc16_swapoff_flush(void *ctx)
+{
+	return mc16_writeback_batch_flush(NULL);
+}
+
+static int mc16_swapoff_restore(struct memcomp_ref *ref, unsigned int type,
+				void *ctx)
+{
+	return mc16_swapoff_entry(ref, type, &memcomp_swapoff_ops);
+}
+
+int memcomp_swapoff(unsigned int type)
+{
+	const struct mc16_swapoff_walk_ops ops = {
+		.lock = &memcomp_writeback_lock,
+		.flush = mc16_swapoff_flush,
+		.restore = mc16_swapoff_restore,
+	};
+
+	if (!memcomp_is_enabled())
+		return 0;
+	cancel_delayed_work_sync(&memcomp_writeback_drain_work);
+	return mc16_swapoff_walk(type, &ops);
+}
+
+/*
+ * Conservative defragmentation of packed slots.
+ *
+ * A packed slot frees when its last entry goes, so one whose other payloads
+ * have all been faulted back or freed keeps a whole slot for one small
+ * survivor.  That is never worse than raw writeback, which would have spent
+ * the slot on it anyway, so nothing here is needed for correctness or to
+ * bound the device's use; it only matters once swap is running short.
+ *
+ * So it does as little as it can, as rarely as it can: only when the level
+ * gate is closed, no node has a reclaim scope open, and less than an eighth
+ * of swap is free.  It moves only a packed entry that is the sole reference
+ * on its slot - nothing else living there and no fault on its way to it -
+ * back into the pool by copying its compressed bytes, one slot read and no
+ * write, no recompression.  The slot frees, and writeback packs the payload
+ * again with the next cold ones if the pool ever needs it gone.  A slot that
+ * still holds several payloads is never read, moved or rewritten.
+ *
+ * A pass looks at a bounded number of entries and moves a bounded number of
+ * them, and passes run from the drain worker's delay, so a pass is a few
+ * reads at most, spaced out, and never on a fault or reclaim path.  The walk
+ * resumes where the last pass stopped and ends at the end of the table;
+ * the next gate-closed period end with swap still short starts another.
+ */
+#define MEMCOMP_WRITEBACK_DEFRAG_SCAN	1024U
+#define MEMCOMP_WRITEBACK_DEFRAG_MOVE	16U
+#define MEMCOMP_WRITEBACK_DEFRAG_FREE_SHIFT	3
+
+/* The device side of a move, so the suite can drive it without swap. */
+struct memcomp_defrag_ops {
+	int (*slot_count)(swp_entry_t swap);
+	int (*read_page)(swp_entry_t swap, void *dst);
+};
+
+/* Whether defragmentation may run now; see above.  Pure. */
+static bool memcomp_writeback_defrag_wanted(bool gate_open,
+					    bool scope_active,
+						long free_pages,
+						long total_pages)
+{
+	if (gate_open || scope_active || total_pages <= 0)
+		return false;
+
+	return free_pages <
+	       (total_pages >> MEMCOMP_WRITEBACK_DEFRAG_FREE_SHIFT);
+}
+
+static bool memcomp_writeback_any_scope_active(void)
+{
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY)
+		if (memcomp_writeback_scope_active(nid))
+			return true;
+	return false;
+}
+
+static bool memcomp_writeback_defrag_due(void)
+{
+	bool open = atomic_read(&memcomp_writeback_gate_open);
+	bool scope = memcomp_writeback_any_scope_active();
+
+	return memcomp_writeback_defrag_wanted(open, scope,
+						   get_nr_swap_pages(),
+						   total_swap_pages);
+}
+
+/*
+ * Move @entry back into the pool if it is a packed slot's sole survivor.
+ * 1 moved, 0 not a candidate or lost a race, negative on failure.
+ */
+
+/*
+ * One bounded pass from *@index.  Returns true while the walk has more of
+ * the table to cover; *@index is where the next pass resumes.
+ */
+
+static int memcomp_defrag_slot_count(swp_entry_t swap)
+{
+	return memcomp_slot_count(swap);
+}
+
+/* No direct reclaim for a page that exists only to tidy the device. */
+static int memcomp_defrag_read_page(swp_entry_t swap, void *dst)
+{
+	return memcomp_read_swapped_page(swap, false, 0, 0, dst,
+					     GFP_NOWAIT | __GFP_NOWARN);
+}
+
+#include "memcomp/defrag.h"
+
+static const struct memcomp_defrag_ops memcomp_defrag_ops = {
+	.slot_count = memcomp_defrag_slot_count,
+	.read_page = memcomp_defrag_read_page,
+};
+
+static u64 memcomp_writeback_defrag_index;
+
+/* One pass of the walk; true when the worker should come back for more. */
+static bool memcomp_writeback_defrag_pass(void)
+{
+	if (!READ_ONCE(memcomp_writeback_defrag_armed))
+		return false;
+	if (!memcomp_writeback_defrag_due() ||
+	    !mc16_defrag_scan(&memcomp_writeback_defrag_index,
+					       &memcomp_defrag_ops)) {
+		WRITE_ONCE(memcomp_writeback_defrag_armed, false);
+		return false;
+	}
+	return true;
+}
+#endif /* CONFIG_SWAP */
+
+/*
+ * Core load - decompress one page from @entry into @dst.  Sleeps on the
+ * token lock and possibly swap IO; never called under the PTE lock.
+ */
+#include "memcomp/load.h"
+#include "memcomp/consumers.h"
+
+/*
+ * Claim a reclaimable entry for writeback.
+ */
+
+static unsigned long memcomp_shrinker_count(struct shrinker *shrinker,
+					    struct shrink_control *sc)
+{
+#ifdef CONFIG_SWAP
+	unsigned long nr_freeable;
+	struct memcomp_lru *lru;
+
+	if (!memcomp_is_enabled() || !total_swap_pages)
+		return 0;
+	if (get_nr_swap_pages() <= 0)
+		return 0;
+	/* Backing swap can live in a swapfile filesystem. */
+	if (!gfp_has_io_fs(sc->gfp_mask))
+		return 0;
+	/* A direct-reclaim caller must never issue backing I/O. */
+	if (!current_is_kswapd())
+		return 0;
+
+	/*
+	 * Outside a severe VM reclaim scope nothing is offered: MC_STORED
+	 * payloads stay in zsmalloc pool as soon as pressure falls, rather than
+	 * turning allocator or zsmalloc pool activity into I/O.
+	 */
+	if (!memcomp_writeback_pressure_active(sc->nid))
+		return 0;
+
+	lru = memcomp_lru_nid(sc->nid);
+	nr_freeable = lru ? atomic_long_read(&lru->nr_entries) : 0;
+	return nr_freeable;
+#else
+	return 0;
+#endif
+}
+
+#ifdef CONFIG_SWAP
+/*
+ * Migrate up to @limit of @nid's coldest payloads out to swap as original
+ * pages.  Returns the number of entries scanned.  Caller holds
+ * memcomp_writeback_lock with memalloc_noreclaim_save() in force.
+ *
+ * Writes are asynchronous; the batch is waited on once per
+ * MEMCOMP_WRITEBACK_BATCH stagings and once at the end, so a pass
+ * costs about limit/batch blocking waits rather than one per page, with
+ * the device kept at batch depth in between.
+ */
+
+#endif
+
+static unsigned long memcomp_shrinker_scan(struct shrinker *shrinker,
+					   struct shrink_control *sc)
+{
+#ifdef CONFIG_SWAP
+	unsigned long scanned = 0;
+	unsigned long freed = 0;
+	unsigned long writeback_limit;
+	unsigned long pool_pages;
+	unsigned long pool_pages_after;
+	unsigned long compacted;
+	unsigned int noreclaim_flag;
+	struct memcomp_lru *lru;
+	int write_ret = 0;
+	bool writeback_attempted = false;
+
+	if (!memcomp_is_enabled() || !total_swap_pages)
+		return SHRINK_STOP;
+	if (get_nr_swap_pages() <= 0)
+		return SHRINK_STOP;
+	if (!gfp_has_io_fs(sc->gfp_mask))
+		return SHRINK_STOP;
+	if (!current_is_kswapd())
+		return SHRINK_STOP;
+
+	lru = memcomp_lru_nid(sc->nid);
+	if (!lru || !memcomp_writeback_pressure_active(sc->nid))
+		return SHRINK_STOP;
+	memcomp_debug_inc(&memcomp_writeback_pressure_scans);
+
+	/* Compact first: avoid backing I/O if zsmalloc can release pages. */
+	pool_pages = memcomp_pool_total_size() >> PAGE_SHIFT;
+	compacted = memcomp_pool_compact();
+	if (compacted) {
+		pool_pages_after = memcomp_pool_total_size() >> PAGE_SHIFT;
+		if (pool_pages_after < pool_pages) {
+			memcomp_wb_reclaimed(pool_pages - pool_pages_after);
+			return pool_pages - pool_pages_after;
+		}
+		/* Baseline covers payload frees and final compaction. */
+		pool_pages = memcomp_pool_total_size() >> PAGE_SHIFT;
+	}
+
+	/*
+	 * The scope budget, not the shrinker scan share, paces writeback -
+	 * but spend it in the same bounded slices the off-reclaim drain
+	 * uses, not all at once.  A pass waits once per batch, but a
+	 * saturated controller still grants half
+	 * the cold payloads - six figures on a full pool - and unsliced
+	 * that parks kswapd in one shrinker callback and blocks swapoff and
+	 * the drain worker behind the global writeback mutex.
+	 *
+	 * Nothing is given up by slicing.  memcomp_writeback_budget_consume()
+	 * below subtracts only what was scanned, so the remainder stays in
+	 * memcomp_writeback_budget[nid] and memcomp_writeback_pressure_active()
+	 * keeps reporting pressure until it is spent - the next shrinker call
+	 * in the same scope picks up where this one stopped.
+	 */
+	writeback_limit = memcomp_writeback_pass_limit(sc->nid);
+	noreclaim_flag = memalloc_noreclaim_save();
+	mutex_lock(&memcomp_writeback_lock);
+	scanned = mc16_writeback_drain_queue(sc->nid, lru,
+					     writeback_limit, &freed,
+					     &write_ret,
+					     &writeback_attempted);
+	mutex_unlock(&memcomp_writeback_lock);
+	memalloc_noreclaim_restore(noreclaim_flag);
+
+	if (freed) {
+		memcomp_pool_compact();
+		pool_pages_after = memcomp_pool_total_size() >> PAGE_SHIFT;
+		if (pool_pages_after < pool_pages)
+			memcomp_wb_reclaimed(pool_pages - pool_pages_after);
+		else
+			memcomp_debug_inc(&memcomp_writeback_zs_no_progress);
+	}
+	if (scanned &&
+	    !memcomp_writeback_budget_consume(sc->nid, scanned)) {
+		/* Budget spent: only observe until the next severe scope. */
+		memcomp_debug_inc(&memcomp_writeback_limited_batches);
+		memcomp_reclaim_writeback_stop(sc->nid);
+	}
+
+	sc->nr_scanned = scanned;
+	if (write_ret)
+		return freed ? freed : SHRINK_STOP;
+	return (scanned || freed) ? freed : SHRINK_STOP;
+#else
+	return SHRINK_STOP;
+#endif
+}
 
-#endif
-
 unsigned int memcomp_pte_batch(pte_t *start_pte, unsigned int max_nr)
 {
 	pte_t first_pte;
@@ -2735,6 +4359,19 @@ static void memcomp_destroy_decomp_ctxs(void)
 	}
 }
 
+static void memcomp_destroy_pools(void)
+{
+	int i;
+
+	for (i = 0; i < memcomp_nr_pools; i++) {
+		if (!memcomp_pools[i])
+			continue;
+		zs_destroy_pool(memcomp_pools[i]);
+		memcomp_pools[i] = NULL;
+	}
+	memcomp_nr_pools = 0;
+}
+
 /* Set everything up for memcomp_compressor and enable memcomp. */
 static int memcomp_start(void)
 {
@@ -2747,6 +4384,16 @@ static int memcomp_start(void)
 		spin_lock_init(&memcomp_lrus[i].lock);
 		INIT_LIST_HEAD(&memcomp_lrus[i].entries);
 		atomic_long_set(&memcomp_lrus[i].nr_entries, 0);
+		spin_lock_init(&memcomp_writeback_scope_locks[i]);
+		atomic_set(&memcomp_writeback_scopes[i], 0);
+		atomic_set(&memcomp_writeback_stopped[i], 0);
+		memcomp_writeback_reclaim_idx[i] = 0;
+		memcomp_writeback_stored_bytes[i] = 0;
+		memcomp_writeback_pool_bytes[i] = 0;
+		memcomp_writeback_feedback_valid[i] = false;
+		memcomp_writeback_drain[i] = 0;
+		memcomp_writeback_carry[i] = 0;
+		memcomp_writeback_budget[i] = 0;
 	}
 
 	for (i = 0; i < MEMCOMP_NR_LOCKS; i++)
@@ -2850,9 +4497,22 @@ static int memcomp_start(void)
 		goto err_decomp;
 	}
 
+#ifdef CONFIG_SWAP
+	INIT_DELAYED_WORK(&memcomp_writeback_drain_work,
+			  memcomp_writeback_drain_worker);
+#endif
 	memcomp_meta_shrinker = shrinker_alloc(0, "memcomp-meta");
 	if (!memcomp_meta_shrinker)
 		pr_warn("metadata shrinker allocation failed; pressure reclaim unavailable\n");
+	memcomp_shrinker = shrinker_alloc(SHRINKER_NONSLAB |
+					SHRINKER_NUMA_AWARE, "memcomp");
+	if (!memcomp_shrinker) {
+		ret = -ENOMEM;
+		goto err_pools;
+	}
+	memcomp_shrinker->count_objects = memcomp_shrinker_count;
+	memcomp_shrinker->scan_objects = memcomp_shrinker_scan;
+	shrinker_register(memcomp_shrinker);
 	if (memcomp_meta_shrinker) {
 		memcomp_meta_shrinker->count_objects = mc16_meta_shrinker_count;
 		memcomp_meta_shrinker->scan_objects = mc16_meta_shrinker_scan;
@@ -2864,6 +4524,10 @@ static int memcomp_start(void)
 
 	return 0;
 
+err_pools:
+	shrinker_free(memcomp_meta_shrinker);
+	memcomp_meta_shrinker = NULL;
+	memcomp_destroy_pools();
 err_decomp:
 	memcomp_destroy_decomp_ctxs();
 err_comp:
@@ -3272,6 +4936,47 @@ static ssize_t placement_events_show(struct kobject *kobj,
  * maps to exactly one entry and frees with it - so what remains here is
  * the writeback control loop and its outcomes.
  */
+static ssize_t packed_swap_events_show(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *buf)
+{
+	unsigned long pool_pages = memcomp_pool_total_size() >> PAGE_SHIFT;
+
+	return sysfs_emit(buf,
+			  "writeback_pool_pages %lu\n"
+			  "writeback_pressure_scopes %lu\n"
+			  "writeback_pressure_events %llu\n"
+			  "writeback_pressure_scans %llu\n"
+			  "writeback_compression_throttled %llu\n"
+			  "writeback_limited_batches %llu\n"
+			  "writeback_budget_granted %llu\n"
+			  "writeback_payloads %llu\n"
+			  "writeback_zs_reclaimed %llu\n"
+			  "writeback_zs_no_progress %llu\n"
+			  "writeback_decompress_error %llu\n"
+			  "writeback_write_error %llu\n"
+			  "writeback_gate_open %d\n"
+			  "writeback_gate_opens %llu\n"
+			  "writeback_packed_slots %llu\n"
+			  "writeback_packed_payloads %llu\n"
+			  "writeback_defrag_moved %llu\n",
+			  pool_pages,
+			  memcomp_writeback_pressure_scope_count(),
+			  (u64)atomic64_read(&memcomp_writeback_pressure_events),
+			  (u64)atomic64_read(&memcomp_writeback_pressure_scans),
+			  (u64)atomic64_read(&memcomp_writeback_compression_throttled),
+			  (u64)atomic64_read(&memcomp_writeback_limited_batches),
+			  (u64)atomic64_read(&memcomp_writeback_budget_granted),
+			  (u64)atomic64_read(&memcomp_writeback_payloads),
+			  (u64)atomic64_read(&memcomp_writeback_zs_reclaimed),
+			  (u64)atomic64_read(&memcomp_writeback_zs_no_progress),
+			  (u64)atomic64_read(&memcomp_writeback_decompress_error),
+			  (u64)atomic64_read(&memcomp_writeback_write_error),
+			  atomic_read(&memcomp_writeback_gate_open),
+			  (u64)atomic64_read(&memcomp_writeback_gate_opens),
+			  (u64)atomic64_read(&memcomp_writeback_packed_slots),
+			  (u64)atomic64_read(&memcomp_writeback_packed_payloads),
+			  (u64)atomic64_read(&memcomp_writeback_defrag_moved));
+}
 #endif
 
 #ifdef CONFIG_MEMCOMP_DEBUG_STATS
@@ -3582,6 +5287,8 @@ static struct kobj_attribute compressor_attr = __ATTR_RO(compressor);
 #ifdef CONFIG_MEMCOMP_DEBUG_STATS
 static struct kobj_attribute placement_events_attr =
 	__ATTR_RO(placement_events);
+static struct kobj_attribute packed_swap_events_attr =
+	__ATTR_RO(packed_swap_events);
 static struct kobj_attribute events_attr = __ATTR_RO(events);
 static struct kobj_attribute admission_events_attr =
 	__ATTR_RO(admission_events);
@@ -3596,6 +5303,7 @@ static struct attribute *memcomp_attrs[] = {
 	&compressor_attr.attr,
 #ifdef CONFIG_MEMCOMP_DEBUG_STATS
 	&placement_events_attr.attr,
+	&packed_swap_events_attr.attr,
 	&events_attr.attr,
 	&admission_events_attr.attr,
 	&context_events_attr.attr,
diff --git a/mm/memcomp/defrag.h b/mm/memcomp/defrag.h
new file mode 100644
index 0000000000000000000000000000000000000000..39374f48c007f22ea728139027dd2992ff668689
--- /dev/null
+++ b/mm/memcomp/defrag.h
@@ -0,0 +1,163 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_DEFRAG_H
+#define _MM_MEMCOMP_DEFRAG_H
+#ifdef CONFIG_SWAP
+
+/* Include after memcomp_defrag_ops, its scan/move limits, swapoff.h and scan.h. */
+static inline void *mc16_defrag_buffer_alloc(void)
+{
+	return kmalloc(PAGE_SIZE, GFP_NOWAIT | __GFP_NOWARN);
+}
+
+/* Copy already-compressed bytes verbatim; no codec or slow allocation. */
+static inline int mc16_defrag_copy_payload(const void *src, unsigned int bytes,
+					   struct mc16_payload *payload)
+{
+	unsigned long handle = 0;
+	unsigned int copied = 0;
+	int ret;
+
+	ret = memcomp_alloc_raw_payload(0, src, bytes, &copied, &handle,
+					false, NULL);
+	if (!ret)
+		*payload = (struct mc16_payload) { .word = handle, .bytes = copied };
+	return ret;
+}
+
+/* Unlike swapoff, defrag removes a packed owner and its cached slot page. */
+static inline void mc16_defrag_finish(struct mc16_swapoff_tail *tail)
+{
+	if (!tail->swap.val)
+		return;
+	memcomp_slot_put_packed(tail->swap);
+	memcomp_debug_long_dec(&memcomp_swapped_entries);
+	if (tail->new_bytes != tail->old_bytes) {
+		memcomp_compressed_bytes_add(tail->new_bytes);
+		memcomp_compressed_bytes_sub(tail->old_bytes);
+	}
+	*tail = (struct mc16_swapoff_tail) { };
+}
+
+/*
+ * Caller retains the same guard through the tail. ops->slot_count cannot
+ * sleep under T; ops->read_page must use GFP_NOWAIT, as the existing defrag
+ * reader does. Return 1 moved, 0 noncandidate/stale, or a negative errno.
+ */
+static inline int mc16_defrag_entry(struct memcomp_ref *ref,
+				    const struct memcomp_defrag_ops *ops)
+{
+	struct mc16_swapoff_tail tail = { };
+	struct mc16_payload payload = { };
+	struct mc16_swap_fields fields;
+	struct mc16_view view;
+	swp_entry_t swap;
+	u64 word;
+	u16 length;
+	void *buf;
+	int ret;
+
+	if (!ref || !ref->slot || !ops || !ops->slot_count || !ops->read_page)
+		return -EINVAL;
+	mutex_lock(memcomp_lock_of(ref->token));
+	if (!mc16_view_locked(ref, &view) || !mc16_flags_valid(*view.flags)) {
+		ret = -EIO;
+		goto unlock;
+	}
+	ret = 0;
+	if (mc16_flags_state(*view.flags) != MC16_SWAPPED)
+		goto unlock;
+	word = *view.word;
+	length = *view.length;
+	if (!mc16_swap_decode(word, length, &fields)) {
+		ret = -EIO;
+		goto unlock;
+	}
+	if (!fields.packed)
+		goto unlock;
+	swap = swp_entry(fields.type, fields.swap_offset);
+	if (!swap.val) {
+		ret = -EIO;
+		goto unlock;
+	}
+	if (ops->slot_count(swap) != 1)
+		goto unlock;
+	ret = memcomp_slot_dup(swap);
+	mutex_unlock(memcomp_lock_of(ref->token));
+	if (ret)
+		return ret;
+
+	buf = mc16_defrag_buffer_alloc();
+	if (!buf) {
+		ret = -ENOMEM;
+		goto read_put;
+	}
+	ret = ops->read_page(swap, buf);
+	if (!ret)
+		ret = mc16_defrag_copy_payload(buf + fields.byte_offset,
+					       fields.length, &payload);
+	kfree(buf);
+	if (ret)
+		goto abort;
+	ret = mc16_swapoff_commit(ref, word, length, &payload,
+				  GFP_NOWAIT | __GFP_NOWARN, &tail);
+	if (ret != 1)
+		goto abort;
+	/* The temporary read pin is ordinary; the consumed owner is packed. */
+	memcomp_slot_put(swap);
+	mc16_defrag_finish(&tail);
+	memcomp_debug_inc(&memcomp_writeback_defrag_moved);
+	return 1;
+abort:
+	/* Commit refunds its own failed charge; prepared ownership stays here. */
+	mc16_payload_abort(ref, &payload);
+read_put:
+	memcomp_slot_put(swap);
+	return ret;
+unlock:
+	mutex_unlock(memcomp_lock_of(ref->token));
+	return ret;
+}
+
+/*
+ * The caller supplies gating. Defrag does not take W: T snapshots, backing
+ * read pins and commit revalidation protect each move independently of WB.
+ * Retain only the numeric cursor between passes.
+ */
+static inline bool mc16_defrag_scan(u64 *cursor,
+				    const struct memcomp_defrag_ops *ops)
+{
+	unsigned int scanned = 0, moved = 0;
+
+	if (!cursor || !ops || !ops->slot_count || !ops->read_page)
+		return false;
+	while (scanned < MEMCOMP_WRITEBACK_DEFRAG_SCAN &&
+	       moved < MEMCOMP_WRITEBACK_DEFRAG_MOVE) {
+		struct memcomp_ref ref;
+		enum mc16_scan_result result;
+		unsigned int used;
+		int ret;
+
+		result = mc16_scan_next(cursor, MEMCOMP_WRITEBACK_DEFRAG_SCAN -
+					scanned, &ref, &used);
+		scanned += used;
+		if (result == MC16_SCAN_END) {
+			*cursor = 0;
+			return false;
+		}
+		if (result == MC16_SCAN_BUDGET)
+			return true;
+		ret = mc16_defrag_entry(&ref, ops);
+		mc16_ref_put(&ref);
+		if (*cursor == MC16_SCAN_END_CURSOR) {
+			*cursor = 0;
+			return false;
+		}
+		if (ret < 0)
+			return false;
+		moved += ret;
+		cond_resched();
+	}
+	return true;
+}
+#endif /* CONFIG_SWAP */
+#endif /* _MM_MEMCOMP_DEFRAG_H */
diff --git a/mm/memcomp/drain.h b/mm/memcomp/drain.h
new file mode 100644
index 0000000000000000000000000000000000000000..3c85f7d894f908a02547512f26e8b63109d527f4
--- /dev/null
+++ b/mm/memcomp/drain.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_DRAIN_H
+#define _MM_MEMCOMP_DRAIN_H
+
+#ifdef CONFIG_SWAP
+/* Include after the mc16 batch and the existing writeback pressure helpers. */
+
+/* Caller owns W in its nofs/noreclaim scope; every return drains staging. */
+static inline unsigned long
+mc16_writeback_drain_queue(int nid, struct memcomp_lru *fifo,
+			   unsigned long limit, unsigned long *freedp,
+			   int *write_retp, bool *attemptedp)
+{
+	unsigned long scanned = 0;
+
+	lockdep_assert_held(&memcomp_writeback_lock);
+	while (scanned < limit) {
+		struct mc16_writeback_member staged = { };
+		struct memcomp_ref ref;
+		unsigned int budget, before;
+		bool found;
+		int ret;
+
+		/* Leave headroom before claiming ownership under T. */
+		if (mc16_writeback_batch_full()) {
+			ret = mc16_writeback_batch_flush(freedp);
+			if (ret) {
+				if (ret == -ENOSPC)
+					memcomp_reclaim_writeback_stop(nid);
+				if (!*write_retp)
+					*write_retp = ret;
+				break;
+			}
+		}
+		budget = min_t(unsigned long, limit - scanned, UINT_MAX);
+		before = budget;
+		found = mc16_fifo_select(fifo, &budget, &ref);
+		scanned += before - budget;
+		if (!found) {
+			/* A limit wider than u32 may need another bounded slice. */
+			if (!budget && scanned < limit) {
+				cond_resched();
+				continue;
+			}
+			break;
+		}
+
+		/* No L or X survives the selector; reuse this one T for claim. */
+		mutex_lock(memcomp_lock_of(ref.token));
+		if (mc16_fifo_second_chance_locked(&ref))
+			ret = -EAGAIN;
+		else
+			ret = mc16_writeback_stage_locked(&ref, &staged);
+		mutex_unlock(memcomp_lock_of(ref.token));
+		if (!ret) {
+			*attemptedp = true;
+			ret = mc16_writeback_stage(&staged);
+		}
+		/* stage consumes its own guard; this is the selector's guard. */
+		mc16_ref_put(&ref);
+		if (ret && ret != -EAGAIN) {
+			if (!*write_retp)
+				*write_retp = ret;
+			if (ret == -ENOSPC)
+				memcomp_reclaim_writeback_stop(nid);
+			break;
+		}
+		cond_resched();
+	}
+
+	/* Also refund prefetched reservations after an allocation failure. */
+	{
+		int ret = mc16_writeback_batch_flush(freedp);
+
+		if (ret && !*write_retp)
+			*write_retp = ret;
+		if (ret == -ENOSPC)
+			memcomp_reclaim_writeback_stop(nid);
+	}
+	return scanned;
+}
+#endif /* CONFIG_SWAP */
+#endif /* _MM_MEMCOMP_DRAIN_H */
diff --git a/mm/memcomp/load.h b/mm/memcomp/load.h
index ccff6896dea95615b01604c09da467cec5857e12..ddfab6c83b4fc50ddf8ebb861296970e173774a6 100644
--- a/mm/memcomp/load.h
+++ b/mm/memcomp/load.h
@@ -40,6 +40,35 @@ static inline int mc16_load_page(struct memcomp_ref *ref, void *dst)
 		memset_l(dst, word, PAGE_SIZE / sizeof(unsigned long));
 		return 0;
 	}
+#ifdef CONFIG_SWAP
+	if (state == MC16_SWAPPED) {
+		struct mc16_swap_fields fields;
+		swp_entry_t swap;
+
+		if (!mc16_swap_decode(word, *view.length, &fields)) {
+			ret = -EIO;
+			goto out;
+		}
+		swap = swp_entry(fields.type, fields.swap_offset);
+		if (!swap.val) {
+			ret = -EIO;
+			goto out;
+		}
+		/* Swapoff may consume the entry's distinct owner after T drops. */
+		ret = memcomp_slot_dup(swap);
+		mutex_unlock(memcomp_lock_of(ref->token));
+		if (ret)
+			return ret == -ENOMEM ? -ENOMEM : -EIO;
+		ret = memcomp_read_swapped_page(swap, fields.packed,
+						fields.byte_offset, fields.length,
+						dst, GFP_HIGHUSER_MOVABLE |
+						     __GFP_NOWARN);
+		memcomp_slot_put(swap);
+		if (!ret)
+			memcomp_debug_inc(&memcomp_swapped_read_io);
+		return ret;
+	}
+#endif
 	if ((state != MC16_STORED && state != MC16_WRITEBACK) || !word) {
 		ret = -EIO;
 		goto out;
diff --git a/mm/memcomp/swapoff.h b/mm/memcomp/swapoff.h
new file mode 100644
index 0000000000000000000000000000000000000000..02460d353e593526a640e2893b8e8981e3985d71
--- /dev/null
+++ b/mm/memcomp/swapoff.h
@@ -0,0 +1,186 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_SWAPOFF_H
+#define _MM_MEMCOMP_SWAPOFF_H
+#ifdef CONFIG_SWAP
+
+struct mc16_swapoff_tail {
+	swp_entry_t swap;
+	u32 old_bytes;
+	u32 new_bytes;
+};
+
+/*
+ * The caller holds a slot guard throughout preparation, commit and the tail.
+ * No record pointer escapes T. The new payload stays caller-owned on failure.
+ * expected_word/length identify the complete old encoded backing snapshot.
+ */
+static inline int
+mc16_swapoff_commit(struct memcomp_ref *ref, u64 expected_word,
+		    u16 expected_length, struct mc16_payload *payload,
+		    gfp_t gfp, struct mc16_swapoff_tail *tail)
+{
+	struct obj_cgroup *objcg = ref->cluster->key->objcg;
+	struct mc16_swap_fields old;
+	struct mc16_view view;
+	unsigned int state;
+	u32 charged = 0;
+	u16 length;
+	int ret = 0;
+
+	state = payload->bytes ? MC16_STORED : MC16_SAMEFILL;
+	if (payload->charge || (payload->bytes && !payload->word) ||
+	    !mc16_payload_length_encode(state, payload->bytes, &length) ||
+	    !mc16_swap_decode(expected_word, expected_length, &old) ||
+	    !swp_entry(old.type, old.swap_offset).val)
+		return -EINVAL;
+	if (objcg && payload->bytes) {
+		ret = memcomp_objcg_charge(objcg, gfp, payload->bytes);
+		if (ret)
+			return ret;
+		charged = payload->bytes;
+	}
+	mutex_lock(memcomp_lock_of(ref->token));
+	if (!mc16_view_locked(ref, &view) || !mc16_flags_valid(*view.flags)) {
+		ret = -EIO;
+	} else if (mc16_flags_state(*view.flags) == MC16_SWAPPED &&
+	    *view.word == expected_word && *view.length == expected_length) {
+		*tail = (struct mc16_swapoff_tail) {
+			.swap = swp_entry(old.type, old.swap_offset),
+			.old_bytes = old.length, .new_bytes = payload->bytes,
+		};
+		*view.word = payload->word;
+		*view.length = length;
+		*view.flags = (*view.flags & ~MC16_STATE_MASK) | state;
+		if (view.member)
+			view.member->payload_charge = charged;
+		mc16_payload_account(MC16_SWAPPED, old.length, state, payload->bytes);
+		mc16_fifo_transition(ref, MC16_SWAPPED, state);
+		*payload = (struct mc16_payload) { };
+		ret = 1;
+	}
+	mutex_unlock(memcomp_lock_of(ref->token));
+	if (ret != 1)
+		memcomp_objcg_uncharge(objcg, charged);
+	return ret;
+}
+
+/* Match swapoff's two ordinary backing puts; swap core drains its cache. */
+static inline void mc16_swapoff_finish(struct mc16_swapoff_tail *tail)
+{
+	if (!tail->swap.val)
+		return;
+	memcomp_slot_put(tail->swap);
+	memcomp_debug_long_dec(&memcomp_swapped_entries);
+	if (tail->new_bytes != tail->old_bytes) {
+		memcomp_compressed_bytes_add(tail->new_bytes);
+		memcomp_compressed_bytes_sub(tail->old_bytes);
+	}
+	*tail = (struct mc16_swapoff_tail) { };
+}
+
+/* A guarded restore actor; W and periodic yield belong to the outer walker. */
+static inline int
+mc16_swapoff_entry(struct memcomp_ref *ref, unsigned int type,
+		   const struct memcomp_swapoff_ops *ops)
+{
+	struct mc16_swapoff_tail tail = { };
+	struct mc16_payload payload = { };
+	struct mc16_swap_fields fields;
+	struct mc16_view view;
+	unsigned long handle = 0;
+	unsigned int bytes = 0;
+	swp_entry_t swap;
+	u64 word;
+	u16 length;
+	u8 pool = 0;
+	void *buf;
+	int ret;
+
+	mutex_lock(memcomp_lock_of(ref->token));
+	if (!mc16_view_locked(ref, &view) || !mc16_flags_valid(*view.flags)) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+	if (mc16_flags_state(*view.flags) != MC16_SWAPPED) {
+		ret = 0;
+		goto out_unlock;
+	}
+	word = *view.word;
+	length = *view.length;
+	if (!mc16_swap_decode(word, length, &fields)) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+	swap = swp_entry(fields.type, fields.swap_offset);
+	if (!swap.val) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+	ret = memcomp_slot_dup(swap);
+	mutex_unlock(memcomp_lock_of(ref->token));
+	if (ret)
+		return ret;
+	if (fields.type != type) {
+		ret = 0;
+		goto out_read_ref;
+	}
+	if (ops->interrupted(ops->ctx)) {
+		ret = -EINTR;
+		goto out_read_ref;
+	}
+	buf = kmalloc(PAGE_SIZE, GFP_NOFS | __GFP_NOWARN);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out_read_ref;
+	}
+	ret = ops->read_page(swap, buf);
+	if (ret) {
+		kfree(buf);
+		goto out_failed;
+	}
+	memcomp_debug_inc(&memcomp_swapoff_read_io);
+	if (fields.packed) {
+		void *page = kmalloc(PAGE_SIZE, GFP_NOFS | __GFP_NOWARN);
+
+		ret = page ? memcomp_decode_slot(buf, true, fields.byte_offset,
+						fields.length, page) : -ENOMEM;
+		kfree(buf);
+		buf = page;
+		if (ret) {
+			kfree(buf);
+			goto out_failed;
+		}
+	}
+	ret = ops->alloc_payload(buf, &bytes, &handle, &pool, ops->ctx);
+	kfree(buf);
+	if (ret)
+		goto out_failed;
+	payload = (struct mc16_payload) { .word = handle, .bytes = bytes };
+	ret = pool ? -EINVAL :
+		mc16_swapoff_commit(ref, word, length, &payload,
+				    GFP_NOIO | __GFP_NOWARN, &tail);
+	if (ret <= 0) {
+		if (bytes)
+			ops->free_payload(pool, handle, ops->ctx);
+		if (ret < 0)
+			goto out_failed;
+		goto out_read_ref;
+	}
+	/* Consume the read pin separately from the old slot-owned reference. */
+	memcomp_slot_put(swap);
+	mc16_swapoff_finish(&tail);
+	memcomp_debug_inc(&memcomp_swapoff_entries);
+	return 1;
+out_failed:
+	memcomp_debug_inc(&memcomp_swapoff_fail);
+out_read_ref:
+	memcomp_slot_put(swap);
+	return ret;
+out_unlock:
+	if (ret < 0)
+		memcomp_debug_inc(&memcomp_swapoff_fail);
+	mutex_unlock(memcomp_lock_of(ref->token));
+	return ret;
+}
+#endif /* CONFIG_SWAP */
+#endif /* _MM_MEMCOMP_SWAPOFF_H */
diff --git a/mm/memcomp/swapoff_walk.h b/mm/memcomp/swapoff_walk.h
new file mode 100644
index 0000000000000000000000000000000000000000..518dc12e383c6cfbae67f9b96e1b5c94001cc109
--- /dev/null
+++ b/mm/memcomp/swapoff_walk.h
@@ -0,0 +1,122 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_SWAPOFF_WALK_H
+#define _MM_MEMCOMP_SWAPOFF_WALK_H
+
+#include "scan.h"
+
+#ifdef CONFIG_SWAP
+#define MC16_SWAPOFF_SCAN_BATCH 32U
+
+/*
+ * All required ops and ctx remain valid until the walk returns. flush returns
+ * zero or -errno and settles all staging under W. restore borrows ref; it
+ * owns state/type validation and must return with all actor-local resources
+ * released, without consuming or retaining the scanner's guard.
+ *
+ * interrupted may be NULL to use signal_pending(current). The optional test
+ * observers borrow their arguments only for the call: scanned runs under W,
+ * unlocked runs with no W and no scanner/actor guard. Neither may retain a
+ * slot, cluster, record or backing snapshot across W. Production bindings
+ * (mc16_swapoff_entry and the slot batch flush) are supplied by the caller.
+ */
+struct mc16_swapoff_walk_ops {
+	struct mutex *lock; /* Shared writeback mutex W. */
+	int (*flush)(void *ctx);
+	int (*restore)(struct memcomp_ref *ref, unsigned int type, void *ctx);
+	bool (*interrupted)(void *ctx);
+	void (*scanned)(u64 cursor, unsigned int used,
+			enum mc16_scan_result result,
+			const struct memcomp_ref *ref, void *ctx);
+	void (*unlocked)(void *ctx);
+	void *ctx;
+};
+
+static inline bool
+mc16_swapoff_walk_interrupted(const struct mc16_swapoff_walk_ops *ops)
+{
+	return ops->interrupted ? ops->interrupted(ops->ctx) :
+		signal_pending(current);
+}
+
+/*
+ * Caller cancels any W-taking drain work before entry. The same W serializes
+ * every flush and restore. Only a u64 forward cursor survives a batch unlock;
+ * no saved registry, new lookup or T acquisition is needed.
+ * The 32-position bound inherits scan.h's XA_RETRY_ENTRY retry exception and
+ * is not a fixed scheduling/latency bound. A full slice yields even when EOF
+ * is discovered only by the next scan; a known end never needs another flush.
+ */
+static inline int
+mc16_swapoff_walk(unsigned int type, const struct mc16_swapoff_walk_ops *ops)
+{
+	unsigned int nofs_flag, noreclaim_flag, scanned = 0;
+	u64 cursor = 0;
+	int ret;
+
+	nofs_flag = memalloc_nofs_save();
+	noreclaim_flag = memalloc_noreclaim_save();
+	mutex_lock(ops->lock);
+	ret = ops->flush(ops->ctx);
+	if (ret)
+		goto out_unlock;
+	for (;;) {
+		struct memcomp_ref ref = { };
+		enum mc16_scan_result result;
+		unsigned int used;
+
+		if (mc16_swapoff_walk_interrupted(ops)) {
+			ret = -EINTR;
+			break;
+		}
+		result = mc16_scan_next(&cursor,
+					MC16_SWAPOFF_SCAN_BATCH - scanned, &ref, &used);
+		scanned += used;
+		if (ops->scanned)
+			ops->scanned(cursor, used, result, &ref, ops->ctx);
+		/* As in the old walk, an empty EOF ends before another signal check. */
+		if (result == MC16_SCAN_END && !used)
+			break;
+		if (mc16_swapoff_walk_interrupted(ops)) {
+			if (ref.slot)
+				mc16_ref_put(&ref);
+			ret = -EINTR;
+			break;
+		}
+		if (result == MC16_SCAN_GUARD) {
+			ret = ops->restore(&ref, type, ops->ctx);
+			mc16_ref_put(&ref);
+			if (ret < 0)
+				break;
+			/* Counts restored by the actor must not reach try_to_unuse. */
+			ret = 0;
+		}
+		if (mc16_swapoff_walk_interrupted(ops)) {
+			ret = -EINTR;
+			break;
+		}
+		if (result == MC16_SCAN_END || cursor == MC16_SCAN_END_CURSOR)
+			break;
+		if (scanned == MC16_SWAPOFF_SCAN_BATCH) {
+			/* ref is empty; no scanner or actor resource survives W. */
+			mutex_unlock(ops->lock);
+			if (ops->unlocked)
+				ops->unlocked(ops->ctx);
+			cond_resched();
+			mutex_lock(ops->lock);
+			/* A writer may have retired slots and staged new writes. */
+			ret = ops->flush(ops->ctx);
+			if (ret)
+				break;
+			scanned = 0;
+		} else {
+			cond_resched();
+		}
+	}
+out_unlock:
+	mutex_unlock(ops->lock);
+	memalloc_noreclaim_restore(noreclaim_flag);
+	memalloc_nofs_restore(nofs_flag);
+	return ret;
+}
+#endif /* CONFIG_SWAP */
+#endif /* _MM_MEMCOMP_SWAPOFF_WALK_H */
diff --git a/mm/memcomp/writeback.h b/mm/memcomp/writeback.h
new file mode 100644
index 0000000000000000000000000000000000000000..e0dcd43940215c5d7b512b5249b2b794ec7b5754
--- /dev/null
+++ b/mm/memcomp/writeback.h
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_WRITEBACK_H
+#define _MM_MEMCOMP_WRITEBACK_H
+
+/* Include after access/fifo. All *_locked helpers borrow the caller's T. */
+struct mc16_writeback {
+	struct mc16_slot *slot;
+	u64 word;
+	u16 length;
+};
+
+/* Only old payload ownership, never a borrowed record/member pointer. */
+struct mc16_writeback_tail {
+	u64 word;
+	u32 charge;
+};
+
+/*
+ * The writer keeps a continuous slot guard from claim through finish. The
+ * snapshot's length is encoded, not bytes. It remains valid if owner-drop
+ * normalizes WRITEBACK; the guard alone does not pin the original record.
+ * Rejection leaves the snapshot untouched. One original eligibility L only.
+ */
+static inline bool
+mc16_writeback_claim_locked(struct memcomp_ref *ref,
+			    struct mc16_writeback *snapshot)
+{
+	struct mc16_view view;
+	u32 bytes;
+
+	if (!mc16_view_locked(ref, &view) ||
+	    !mc16_flags_valid(*view.flags) ||
+	    mc16_flags_state(*view.flags) != MC16_STORED ||
+	    (*view.flags & MC16_F_RESIDENT) || !*view.word ||
+	    !mc16_length_decode(*view.length, &bytes))
+		return false;
+	*snapshot = (struct mc16_writeback) {
+		.slot = ref->slot, .word = *view.word, .length = *view.length,
+	};
+	*view.flags = (*view.flags & ~MC16_STATE_MASK) | MC16_WRITEBACK;
+	mc16_fifo_transition(ref, MC16_STORED, MC16_WRITEBACK);
+	return true;
+}
+
+/* Idempotent failed-I/O rollback; no payload, charge or backing is consumed. */
+static inline bool mc16_writeback_revert_locked(struct memcomp_ref *ref)
+{
+	struct mc16_view view;
+
+	if (!mc16_view_locked(ref, &view) ||
+	    mc16_flags_state(*view.flags) != MC16_WRITEBACK)
+		return false;
+	*view.flags = (*view.flags & ~MC16_STATE_MASK) | MC16_STORED;
+	mc16_fifo_transition(ref, MC16_WRITEBACK, MC16_STORED);
+	return true;
+}
+
+/*
+ * Caller already owns ONE backing reference described by swap, even for a
+ * packed member. Success transfers it to this slot without a dup or put.
+ * The backing fields are real device type/offset/byte offset/length, not
+ * swap.val in word. Raw backing still preserves the old compressed length.
+ * Backing allocation, I/O and backing-device validation belong to caller.
+ *
+ * tail must be empty. On success finish it outside T BEFORE putting this
+ * guard, which keeps the key's accounting owner alive. OWNER retains the
+ * record; owner-drop may instead already have detached/freed it. Resolve
+ * the effective view afresh under T on every attempt. No extra T/A/X/RMW,
+ * and no L on success (WRITEBACK and SWAPPED are both ineligible).
+ *
+ * Rejection leaves tail and caller's backing ownership untouched. A payload
+ * identity mismatch rolls WRITEBACK back to STORED;
+ * invalid backing encoding leaves WRITEBACK for the caller's I/O rollback.
+ */
+static inline int
+mc16_writeback_settle_locked(struct memcomp_ref *ref,
+			     const struct mc16_writeback *snapshot,
+			     const struct mc16_swap_fields *swap,
+			     struct mc16_writeback_tail *tail)
+{
+	struct mc16_view view;
+	u64 word;
+	u32 bytes;
+	u16 length;
+
+	lockdep_assert_held(memcomp_lock_of(ref->token));
+	if (snapshot->slot != ref->slot || !mc16_view_locked(ref, &view) ||
+	    mc16_flags_state(*view.flags) != MC16_WRITEBACK)
+		return -ESTALE;
+	if (*view.word != snapshot->word || *view.length != snapshot->length) {
+		mc16_writeback_revert_locked(ref);
+		return -ESTALE;
+	}
+	if (!mc16_flags_valid(*view.flags) ||
+	    (*view.flags & MC16_F_RESIDENT) || !*view.word ||
+	    !mc16_length_decode(*view.length, &bytes))
+		return -EIO;
+	if (tail->word || tail->charge || !swap || swap->length != bytes ||
+	    !mc16_swap_encode(swap->type, swap->swap_offset, swap->byte_offset,
+			      swap->length, swap->packed, &word, &length) ||
+	    !swp_entry(swap->type, swap->swap_offset).val)
+		return -EINVAL;
+
+	*tail = (struct mc16_writeback_tail) {
+		.word = *view.word,
+		.charge = view.member ? view.member->payload_charge :
+			(ref->cluster->key->objcg ? bytes : 0),
+	};
+	*view.word = word;
+	*view.length = length;
+	*view.flags = (*view.flags & ~MC16_STATE_MASK) | MC16_SWAPPED;
+	if (view.member)
+		view.member->payload_charge = 0;
+	/* Length, raw/samefill, stored and compressed gauges do not change. */
+	memcomp_debug_long_inc(&memcomp_swapped_entries);
+	if (swap->packed)
+		memcomp_debug_inc(&memcomp_writeback_packed_payloads);
+	return 0;
+}
+
+/* No backing put: that reference now belongs to the effective SWAPPED slot. */
+static inline void
+mc16_writeback_finish(struct memcomp_ref *ref,
+		      struct mc16_writeback_tail *tail)
+{
+	if (!tail->word)
+		return;
+	memcomp_zs_free(0, tail->word);
+	memcomp_objcg_uncharge(ref->cluster->key->objcg, tail->charge);
+	*tail = (struct mc16_writeback_tail) { };
+}
+#endif /* _MM_MEMCOMP_WRITEBACK_H */
diff --git a/mm/memcomp/writeback_batch.h b/mm/memcomp/writeback_batch.h
new file mode 100644
index 0000000000000000000000000000000000000000..9fa6dc6473d2ed5f6b8aac1b3caaf83cc16271ca
--- /dev/null
+++ b/mm/memcomp/writeback_batch.h
@@ -0,0 +1,386 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_WRITEBACK_BATCH_H
+#define _MM_MEMCOMP_WRITEBACK_BATCH_H
+
+#ifdef CONFIG_SWAP
+
+/*
+ * Include in memcomp.c after the old writeback batch implementation.  Uses
+ * the existing W, backing slot pool, swapcache folio helpers and I/O plug.
+ * No production dispatch is changed by including this header.
+ *
+ * The caller holds memcomp_writeback_lock once for the whole pass, within
+ * its existing nofs/noreclaim scope.  Never mix old and mc16 live batches:
+ * both borrow the shared slot pool and plug.  Flush before dropping W,
+ * including every error/early-exit path and before a swapoff walk.
+ *
+ * stage_locked() borrows the caller's existing T acquisition to claim and
+ * clone exactly one staging guard.  Release T, then stage() consumes that
+ * guard on every outcome.  The caller still puts its own lookup guard.
+ * stage_abort() is the alternative if the caller cannot proceed to stage().
+ * No I/O, allocation, numeric lookup or new lock acquisition occurs in
+ * stage_locked().  The batch guard survives OWNER removal/normalization;
+ * no record/member address is saved here.  The successful pass retains the
+ * existing T3/L2/refs4/W1 budget; the selector's and validation's T/L scopes
+ * remain the caller's, and settle uses one T with no eligibility L.
+ */
+struct mc16_writeback_member {
+	struct memcomp_ref ref;
+	struct mc16_writeback snapshot;
+	u32 length;
+	u16 offset;
+};
+
+struct mc16_writeback_slot {
+	struct folio *folio;
+	swp_entry_t swap;
+	unsigned int first;
+	u8 nr;
+	bool packed;
+};
+
+static struct mc16_writeback_slot
+	mc16_writeback_batch[MEMCOMP_WRITEBACK_BATCH];
+static struct mc16_writeback_member
+	mc16_writeback_members[MEMCOMP_WRITEBACK_BATCH *
+			       MEMCOMP_WRITEBACK_PACK_MAX];
+static unsigned int mc16_writeback_batch_used;
+static unsigned int mc16_writeback_members_used;
+static unsigned int mc16_writeback_open_first;
+static unsigned int mc16_writeback_open_bytes;
+
+/* Test seams preserve the production allocator, submit and backing APIs. */
+static int mc16_writeback_folio_alloc(struct folio **folio, swp_entry_t *swap)
+{
+	return memcomp_swap_folio_alloc(folio, swap);
+}
+
+static void mc16_writeback_submit(struct folio *folio,
+				  struct writeback_control *wbc)
+{
+	__swap_writepage(folio, wbc);
+}
+
+static int mc16_writeback_backing_dup(swp_entry_t swap)
+{
+	return memcomp_slot_dup(swap);
+}
+
+static void mc16_writeback_member_put(struct mc16_writeback_member *m)
+{
+	if (m->ref.slot)
+		mc16_ref_put(&m->ref);
+	*m = (struct mc16_writeback_member) { };
+}
+
+/* Outside T. Only the staging guard is consumed; never the caller's guard. */
+static void mc16_writeback_stage_abort(struct mc16_writeback_member *m)
+{
+	lockdep_assert_held(&memcomp_writeback_lock);
+	if (!m->ref.slot)
+		return;
+	mutex_lock(memcomp_lock_of(m->ref.token));
+	mc16_writeback_revert_locked(&m->ref);
+	mutex_unlock(memcomp_lock_of(m->ref.token));
+	mc16_writeback_member_put(m);
+}
+
+static inline bool mc16_writeback_batch_full(void)
+{
+	return mc16_writeback_batch_used + 1 >= MEMCOMP_WRITEBACK_BATCH ||
+	       mc16_writeback_members_used >= ARRAY_SIZE(mc16_writeback_members);
+}
+
+/*
+ * staged is an empty caller-owned temporary, not another lookup.  On error
+ * it owns nothing and ref/state are unchanged.  A full batch must be flushed
+ * outside T before retrying; -ENOBUFS is not backing-device -ENOSPC.
+ */
+static inline int
+mc16_writeback_stage_locked(struct memcomp_ref *ref,
+			    struct mc16_writeback_member *staged)
+{
+	struct mc16_writeback snapshot;
+	u32 length = 0;
+
+	lockdep_assert_held(&memcomp_writeback_lock);
+	if (!ref || !ref->slot || !staged || staged->ref.slot)
+		return -EINVAL;
+	lockdep_assert_held(memcomp_lock_of(ref->token));
+	if (mc16_writeback_batch_full())
+		return -ENOBUFS;
+	if (!mc16_writeback_claim_locked(ref, &snapshot))
+		return -EAGAIN;
+	/* Claim already validated this encoding in its effective view. */
+	mc16_length_decode(snapshot.length, &length);
+	refcount_inc(&ref->slot->refs);
+	*staged = (struct mc16_writeback_member) {
+		.ref = *ref, .snapshot = snapshot, .length = length,
+	};
+	return 0;
+}
+
+/*
+ * One owned backing reference enters; success transfers it to the slot.
+ * Resolve the effective view under T, then finish before putting this guard.
+ * Rejections, including an unencodable backing, revert in this same T scope.
+ */
+static int mc16_writeback_convert(struct mc16_writeback_member *m,
+				  swp_entry_t swap, bool packed)
+{
+	struct mc16_swap_fields fields = {
+		.swap_offset = swp_offset(swap),
+		.byte_offset = packed ? m->offset : 0,
+		.length = m->length,
+		.type = swp_type(swap),
+		.packed = packed,
+	};
+	struct mc16_writeback_tail tail = { };
+	int ret;
+
+	mutex_lock(memcomp_lock_of(m->ref.token));
+	ret = mc16_writeback_settle_locked(&m->ref, &m->snapshot, &fields,
+					   &tail);
+	if (ret)
+		mc16_writeback_revert_locked(&m->ref);
+	mutex_unlock(memcomp_lock_of(m->ref.token));
+	mc16_writeback_finish(&m->ref, &tail);
+	return ret;
+}
+
+/* The swapcache folio still pins the backing while duplicates are taken. */
+static int mc16_writeback_resolve(struct mc16_writeback_slot *s,
+				  unsigned long *freedp)
+{
+	bool base = true;
+	unsigned int i;
+	int error = 0;
+
+	for (i = s->first; i < s->first + s->nr; i++) {
+		struct mc16_writeback_member *m = &mc16_writeback_members[i];
+		int ret;
+
+		ret = base ? 0 : mc16_writeback_backing_dup(s->swap);
+		if (ret) {
+			/* Failed dup created no backing reference to refund. */
+			mc16_writeback_stage_abort(m);
+		} else {
+			base = false;
+			ret = mc16_writeback_convert(m, s->swap, s->packed);
+			if (ret) {
+				memcomp_slot_put(s->swap);
+			} else {
+				memcomp_debug_inc(&memcomp_writeback_payloads);
+				if (freedp)
+					(*freedp)++;
+			}
+			mc16_writeback_member_put(m);
+		}
+		if (ret && !error)
+			error = ret;
+	}
+	return error;
+}
+
+/*
+ * Submit one raw page or a packed slot, without T.  The snapshots remain
+ * immutable while WRITEBACK, even if a producer detaches its record.  Pool 0
+ * is the mc16 payload pool; snapshot.length is encoded, m->length is bytes.
+ */
+static int mc16_writeback_write_slot(unsigned int first, unsigned int nr)
+{
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE,
+		.swap_plug = &memcomp_writeback_plugged,
+	};
+	struct mc16_writeback_slot *s;
+	bool packed = nr > 1;
+	unsigned int off = 0, i;
+	struct folio *folio;
+	swp_entry_t swap;
+	void *dst;
+	int ret;
+
+	lockdep_assert_held(&memcomp_writeback_lock);
+	if (WARN_ON_ONCE(mc16_writeback_batch_used >= MEMCOMP_WRITEBACK_BATCH ||
+			 !nr || nr > MEMCOMP_WRITEBACK_PACK_MAX ||
+			 first > mc16_writeback_members_used ||
+			 nr > mc16_writeback_members_used - first))
+		return -EIO;
+	ret = mc16_writeback_folio_alloc(&folio, &swap);
+	if (ret)
+		return ret;
+
+	dst = kmap_local_folio(folio, 0);
+	for (i = first; i < first + nr; i++) {
+		struct mc16_writeback_member *m = &mc16_writeback_members[i];
+		u16 encoded_length;
+		u64 encoded_word;
+		void *src;
+
+		/* Refuse unsupported backing geometry before any I/O is issued. */
+		if (!swap.val || !mc16_swap_encode(swp_type(swap), swp_offset(swap),
+						   packed ? off : 0, m->length,
+						   packed, &encoded_word,
+						   &encoded_length)) {
+			ret = -ERANGE;
+			break;
+		}
+		src = zs_map_object(memcomp_pools[0], m->snapshot.word, ZS_MM_RO);
+		if (!src) {
+			ret = -EIO;
+			break;
+		}
+		m->offset = packed ? off : 0;
+		if (packed) {
+			memcpy(dst + off, src, m->length);
+			off += m->length;
+		} else {
+			ret = memcomp_decompress_payload(src, m->length, dst);
+			if (ret)
+				memcomp_debug_inc(&memcomp_writeback_decompress_error);
+		}
+		zs_unmap_object(memcomp_pools[0], m->snapshot.word);
+		if (ret)
+			break;
+	}
+	if (!ret && packed)
+		memset(dst + off, 0, PAGE_SIZE - off);
+	kunmap_local(dst);
+	if (ret) {
+		memcomp_drop_swapcache_folio(folio, false);
+		memcomp_slot_put(swap);
+		return ret;
+	}
+
+	folio_set_reclaim(folio);
+	__folio_mark_uptodate(folio);
+	mc16_writeback_submit(folio, &wbc);
+	s = &mc16_writeback_batch[mc16_writeback_batch_used++];
+	*s = (struct mc16_writeback_slot) {
+		.folio = folio, .swap = swap, .first = first,
+		.nr = nr, .packed = packed,
+	};
+	if (packed)
+		memcomp_debug_inc(&memcomp_writeback_packed_slots);
+	return 0;
+}
+
+static int mc16_writeback_close_open(void)
+{
+	unsigned int first = mc16_writeback_open_first;
+	unsigned int nr = mc16_writeback_members_used - first;
+	unsigned int i;
+	int ret = 0;
+
+	if (nr)
+		ret = mc16_writeback_write_slot(first, nr);
+	if (ret) {
+		for (i = first; i < first + nr; i++)
+			mc16_writeback_stage_abort(&mc16_writeback_members[i]);
+		mc16_writeback_members_used = first;
+	}
+	mc16_writeback_open_first = mc16_writeback_members_used;
+	mc16_writeback_open_bytes = 0;
+	return ret;
+}
+
+/*
+ * Outside T, consumes staged on success AND failure.  A failed close of the
+ * preceding open page also returns this newly claimed member to STORED.
+ * Caller must flush submitted slots even if this function returns an error.
+ */
+static inline int mc16_writeback_stage(struct mc16_writeback_member *staged)
+{
+	struct mc16_writeback_member *m;
+	unsigned int nr;
+	int ret;
+
+	lockdep_assert_held(&memcomp_writeback_lock);
+	if (!staged || !staged->ref.slot)
+		return -EINVAL;
+	if (WARN_ON_ONCE(mc16_writeback_batch_full())) {
+		ret = -ENOBUFS;
+		goto abort;
+	}
+	nr = mc16_writeback_members_used - mc16_writeback_open_first;
+	if (!memcomp_writeback_pack_fits(nr, mc16_writeback_open_bytes,
+					 staged->length)) {
+		ret = mc16_writeback_close_open();
+		if (ret)
+			goto abort;
+	}
+	m = &mc16_writeback_members[mc16_writeback_members_used++];
+	*m = *staged;
+	*staged = (struct mc16_writeback_member) { };
+	mc16_writeback_open_bytes += m->length;
+	if (m->length == PAGE_SIZE)
+		return mc16_writeback_close_open();
+	return 0;
+abort:
+	mc16_writeback_stage_abort(staged);
+	return ret;
+}
+
+/*
+ * Unplug before the wait sweep, resolve only after I/O, then return every
+ * unused reservation.  No staging guard or prefetched backing crosses W.
+ * Successful slots can settle even if a sibling slot failed; ret is the
+ * first close/I/O/settle error and freedp counts only committed payloads.
+ */
+static inline int mc16_writeback_batch_flush(unsigned long *freedp)
+{
+	unsigned int i;
+	int ret;
+
+	lockdep_assert_held(&memcomp_writeback_lock);
+	ret = mc16_writeback_close_open();
+	if (memcomp_writeback_plugged) {
+		swap_write_unplug(memcomp_writeback_plugged);
+		memcomp_writeback_plugged = NULL;
+	}
+	for (i = 0; i < mc16_writeback_batch_used; i++)
+		folio_wait_writeback(mc16_writeback_batch[i].folio);
+	for (i = 0; i < mc16_writeback_batch_used; i++) {
+		struct mc16_writeback_slot *s = &mc16_writeback_batch[i];
+		struct folio *folio = s->folio;
+		int error;
+
+		folio_lock(folio);
+		if (folio_test_dirty(folio)) {
+			unsigned int j;
+
+			memcomp_drop_swapcache_folio(folio, true);
+			memcomp_debug_inc(&memcomp_writeback_write_error);
+			for (j = s->first; j < s->first + s->nr; j++)
+				mc16_writeback_stage_abort(&mc16_writeback_members[j]);
+			memcomp_slot_put(s->swap);
+			error = -EIO;
+		} else {
+			error = mc16_writeback_resolve(s, freedp);
+			memcomp_drop_swapcache_folio(folio, false);
+		}
+		if (error && !ret)
+			ret = error;
+		*s = (struct mc16_writeback_slot) { };
+	}
+	mc16_writeback_batch_used = 0;
+	mc16_writeback_members_used = 0;
+	mc16_writeback_open_first = 0;
+	mc16_writeback_open_bytes = 0;
+	memcomp_writeback_slots_return();
+	return ret;
+}
+
+/*
+ * Minimal KUnit seams above are folio_alloc, submit and backing_dup.  An
+ * allocator stub returns a locked folio plus one owned backing reference;
+ * a submit stub must unlock and complete writeback (dirty for failed I/O).
+ * Real compression/zsmalloc and the existing memcomp_slot_* tally model can
+ * cover raw/packed images, decoded-length boundaries, owner normalization
+ * between stage and settle, allocation/dup/dirty-I/O/settle failures and
+ * unused-slot refund.  Keep W and both T scopes out of fatal assertions;
+ * drain staged temporaries and flush in the test task before releasing W.
+ */
+#endif /* CONFIG_SWAP */
+#endif /* _MM_MEMCOMP_WRITEBACK_BATCH_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index db164301cfde631ce246929f0fe5944656edfb33..dd36a7bf3f961276df3b40b2170ec461ed73476f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2411,6 +2411,10 @@ static int try_to_unuse(unsigned int type)
 	if (retval)
 		return retval;
 
+	retval = memcomp_swapoff(type);
+	if (retval)
+		return retval;
+
 	prev_mm = &init_mm;
 	mmget(prev_mm);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 75ed55fcc09c627940e73ca7f6262cf06e5b0bce..0f11964567da39f3049282fa8c3ebe5b135c079b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6278,15 +6278,94 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, partial)));
 }
 
+#ifdef CONFIG_MEMCOMP
+/*
+ * Packed payload writeback starts as soon as kswapd must work to
+ * rebalance the node, not only at direct-reclaim-level scarcity.
+ */
+static bool memcomp_writeback_node_below_mark(pg_data_t *pgdat,
+					      struct scan_control *sc,
+						  enum zone_watermarks mark)
+{
+	struct zone *zone;
+	bool found = false;
+	int reclaim_idx;
+	int z;
+
+	if (sc->reclaim_idx < 0)
+		return false;
+
+	reclaim_idx = min_t(int, sc->reclaim_idx, MAX_NR_ZONES - 1);
+	for (z = 0; z <= reclaim_idx; z++) {
+		zone = pgdat->node_zones + z;
+		if (!managed_zone(zone))
+			continue;
+		found = true;
+		if (zone_watermark_ok_safe(zone, 0, wmark_pages(zone, mark),
+					   reclaim_idx))
+			return false;
+	}
+
+	return found;
+}
+
+static bool memcomp_writeback_node_below_low(pg_data_t *pgdat,
+					     struct scan_control *sc)
+{
+	return memcomp_writeback_node_below_mark(pgdat, sc, WMARK_LOW);
+}
+
+static bool memcomp_writeback_node_under_min(pg_data_t *pgdat,
+					     struct scan_control *sc)
+{
+	return memcomp_writeback_node_below_mark(pgdat, sc, WMARK_MIN);
+}
+
+static bool memcomp_writeback_context_permitted(struct scan_control *sc)
+{
+	return root_reclaim(sc) && !cgroup_reclaim(sc) && !sc->proactive &&
+		!sc->hibernation_mode && !sc->order && sc->may_swap &&
+		sc->may_writepage && gfp_has_io_fs(sc->gfp_mask);
+}
+
+/*
+ * Keep packed writeback out of direct reclaim and out of the critical
+ * band: below min, kswapd reclaims the LRU undistracted while
+ * compression absorbs anonymous pages at a far better ratio than swap.
+ * Writeback only rides the moderate band between min and low, where
+ * kswapd has the spare capacity to drain the pool.  Scan priority alone
+ * does not open a scope.
+ */
+static bool memcomp_writeback_high_pressure(pg_data_t *pgdat, struct scan_control *sc)
+{
+	return current_is_kswapd() && lru_gen_enabled() &&
+		memcomp_writeback_context_permitted(sc) &&
+		memcomp_writeback_node_below_low(pgdat, sc) &&
+		!memcomp_writeback_node_under_min(pgdat, sc);
+}
+
+#endif
 static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 {
 	unsigned long nr_reclaimed, nr_scanned, nr_node_reclaimed;
 	struct lruvec *target_lruvec;
 	bool reclaimable = false;
+#ifdef CONFIG_MEMCOMP
+	bool memcomp_writeback;
+#endif
 
+#ifdef CONFIG_MEMCOMP
+	memcomp_writeback = memcomp_writeback_high_pressure(pgdat, sc);
+	if (memcomp_writeback)
+		memcomp_reclaim_writeback_begin(pgdat->node_id, sc->reclaim_idx);
+#endif
 	if (lru_gen_enabled() && root_reclaim(sc)) {
 		lru_gen_shrink_node(pgdat, sc);
+#ifdef CONFIG_MEMCOMP
+		goto out_memcomp_writeback;
+#else
 		return;
+#endif
 	}
 
 	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
@@ -6389,6 +6468,11 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 		pgdat->kswapd_failures = 0;
 	else if (sc->cache_trim_mode)
 		sc->cache_trim_mode_failed = 1;
+#ifdef CONFIG_MEMCOMP
+out_memcomp_writeback:
+	if (memcomp_writeback)
+		memcomp_reclaim_writeback_end(pgdat->node_id);
+#endif
 }
 
 /*
