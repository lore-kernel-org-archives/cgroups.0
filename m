Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827038;
	b=sY0LiBQgiZTcCxQZ+15Ah/zhUnqkHH/PW1Afvfj8sFaaqxicP56KQC6X7FJqkGasmNfp
	 NpdHmW7kHAw9tAR4WDSJjg68eO4b2+x1IJp3ETu2eur0F3g2nh2zu0OB0skQt5axkSets
	 4YAhf+1x3TSJh5u5F+tAntnKQeexksnR6Akh40rhAn+WHK/VSwTbhpCbIyUqqxIeKLVXG
	 iWPB9zANZJvtSFvi7CcLxWB7IoIjrZLthnqO/2LEWAk39b5lVcIJ4HX24ETzh7QxnY4+r
	 x6uPA1x9jdMRtMZQI392NrqUVXsSNaFkkkh3vYfPUgE0WWEsFYoRsF6+b6S22lmukQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827038;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YD0MZm1yvcwF443ZA8ltod5+V7f3+RAJtD6vZbCV4Ng=;
	b=dNN4ahkQvodxMAcxv0yZBsAwIUVJD0ZAmgOVF8OdZ1+3+WLZBVqxTtMkneqiYSn1Z+/L
	 8qf9lb+gvS79+Sotfd6fke53wVXLH2aaxVULc9kvi1r7Xzg54/rrOE69isivkmWFv4ejM
	 gaq9U8+gEHJ0wOnq3o1MtAKvGWAuiqNuw8jO3LUCVU4oVugo87XOPOzyEPJ23NobJvSQo
	 ndhGlWdhoE842sc45G33QOnHOyghqlyxJT3s7FwgzFwWt6Ph/xMh2V2J6vhQXJYpzt/bq
	 kcUJnM+exNpD8NW9mtg1tj8kYgy/kyUxHWlESs1wH+yXa7Mk9sYXNSWiU2nD1M4ogsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=doa8G1l2;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18CD606A330
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D18CD606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=doa8G1l2
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1a3c08d6928so4428725c88.0
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827036; x=1795431836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YD0MZm1yvcwF443ZA8ltod5+V7f3+RAJtD6vZbCV4Ng=;
        b=doa8G1l2IFT6GcWvGiLA1mD+u0vcWETNgwuKgloHpUVpm1yRQP5RB7+kUPTuwFAyB1
         dB4+M1dEVZDBgnD34mTEK0PTRD0VFUFrAiaUnkWK1mPygWO61jse5m6dGPnaSN/ZYAZ2
         1izk2bmE8CN67XyknQX9GETpMH9koFOtBBRrOu6d7L9JVjliEul2rPTwhFcsNeT3j7Wm
         /QisrMW1W/m0wpB+n/96Cizl7tzz1ayU72upbdMWeCH8PuTRSGGFmYmimxQCPL+57nQN
         hjxfR6Jn/oy/c/uTPnFxD3vBQQ+VZTI40zSq5bjJgnUZTHi1VUvaYdZ4/VePONS3aQWv
         gAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827036; x=1795431836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YD0MZm1yvcwF443ZA8ltod5+V7f3+RAJtD6vZbCV4Ng=;
        b=CTVkweRGTnj4F7jTHYoTwYUvx+hdNc78ZDl3HrdptJ1lSwvoFD4p6A5iG0VSZCduri
         +hcwUPIhKQ826r9BLxgbHK1uUouoNudasVLxxceSs102lVzm4CaFYIaDQk0Me5yCFyHV
         iP2QWycJApBg6YaAZehAiVCrrb4QYMIfe3ciOKb2Z20nCmGiuZozpxLy9wPX2SiCjb1y
         rw06qTkrzTGTtTxm1/HPCnsbM701Pg2sEQHxTMd6IG1HylRvkEvn9lr5hAByPaFcACMx
         ERdCms7S9EvHanaehdPv+6gCxxMbNHe5qUy/rvfc8u8xW0PqwJAdUxUHwd2Fp5gyrZzl
         fDcw==
X-Forwarded-Encrypted: i=1; AL+hErFWJxy4TxpXFeIsRZK1fzOsmVfBE2C+zqNtPlAPkHN5sswk1YGA4352A4kDIjKrpjWpEPSF/Tea@vger.kernel.org
X-Gm-Message-State: APuU4Z8x+wtFtO1dR+91Uec3OxYc0zBkC5yPqxaDQ3n8m14QzWQyQaIm
	EOf44PqzhWqEJKXPaunzTvllep0xsq8ZsY0wawYwGvqIPrPRPALt7Y3h
X-Gm-Gg: AYBFou04eVFJFSaQW7WZotzLpHk/omPGy5leiBt6vDl4itIm/I1vZruTHfxDbqnvYdk
	kr3OQEWCt5YdEfAGee30McZ1kqvlx441xG94zvG2ZkubJQkeznf7gDQOqfPvS2kbtstBdZpgpI9
	FBZInykRPPXU77r22fruwylq5XEZriwjQZyGTAY/NUniLxcgOGnIBmaIia0PJkOsmD3fNAwGfU+
	MUsCYQTyX7oYmy2ucAocGXq+oIwnsFtAV5/L4ScADrPTydb9BwEVFRvx3blXQjaTG4/K0kqIBw5
	kdZme2m5fsYFHhdx6y2eXmCV849P7u1v7zd3mqgh4v4EPnbbldSLouzwRQQrUSxgskGk5rOtJGQ
	pluWjipTYJ9t+3ToJbydGsqFp+q1wVbkYMiIIsPdv5y1otrVDUibJUOLsC++IET52Z2lnXZ+mas
	BBYflzRv+a5tvYx2MG9vMyBqbnron7AcWWX+Nj6hGDiwocXAAKMc+G2ujL9YH0TGStjzfFADGag
	lTW9nH0WgoVPb1bnGY5RPMPmM+YZSgWCtU9RgxCPfU5eFhRfhfBqoFITMbz5S85luFBMnIgyFM5
	f388I0RUgdibA7kv1x81Pnqw6CtfNUAohFaeEVOn4ZIqYyw=
X-Received: by 2002:a05:701b:4508:20b0:149:1b5b:1f25 with SMTP id a92af1059eb24-1b50309fa41mr10000144c88.15.1794827033455;
        Mon, 16 Nov 2026 03:03:53 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:03:52 -0800 (PST)
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
Subject: [RFC PATCH 03/16] mm: memcomp: compress reclaimed anonymous pages in memory
Date: Mon, 16 Nov 2026 19:01:09 +0800
Message-ID: <20261116110122.309748-4-nakixii@gmail.com>
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

Anonymous reclaim normally needs a swap slot before it can unmap a page.
Compressing contents in RAM can release the source folio without first
issuing block I/O, but each non-present PTE still needs stable backing
and ownership across reclaim, fork and faults.

Reserve consecutive tokens before unmapping and publish compressed
payloads through the crypto compression API and zsmalloc. Add fault,
fork, zap, migration, smaps, HMM and MADV_FREE handling for memcomp
entries. Refuse KSM folios rather than applying anonymous restoration
rules to merged pages.

Keep stable backing in 16-byte slots containing a payload word,
reference count, length and flags. Allocate slot segments on demand
within per-key clusters. Keys identify the source object cgroup, NUMA
node, page kind and zero hint. Retain a separate record while a resident
folio or pending transaction needs producer, member and anonymous-rmap
state; the slot size is not a claim about total metadata bytes per
stored page.

Route all-zero contents through a separate zero domain without
allocating a slot or compressed payload. Account committed anonymous
zero PTE owners separately from page-cache zero owners. Same-filled
nonzero pages retain their value in a slot without allocating a zsmalloc
payload. Keep zero ownership outside slot reference counting and
writeback eligibility.

Retire unused metadata with RCU protection. Age retained empty cluster
headers using a persistent cursor and batches of 32: each acquisition of
the storage lock examines at most 32 xarray entries, including entries
that cannot be retired. Release the lock before queuing detached headers
for deferred freeing, and schedule another batch when work remains. This
bounds the scan count per lock acquisition, not its elapsed time.

Pin anon_vma before replacing present PTEs so rollback can still walk
the original anonymous mappings. Restore only matching token PTEs under
the page-table lock, with a single-PTE rmap update for the mapped
subpage. Use bounded re-walks when pending references remain, yielding
between passes. Call deferred_split_folio_remapped() after restoring a
large folio so deferred-split accounting follows its remapped state.

Keep the producer reference and pending-record ownership distinct from
PTE and lookup references. If bounded rollback leaves token PTEs behind,
retain their resident backing until faults or removal consume the last
references. Detach the producer's reservation and drop the anon_vma hold
only through the corresponding handoff paths.

Record genuine incompressible results using a content hash and marker in
folio->swap while the folio is outside the swap cache. Recompute the
hash on reclaim to skip unchanged contents, and clear the marker when
contents change. Compute the rollback hash before restored mappings can
be written. Other store failures do not mark a folio incompressible.

Acquire bounded compression resources before unmapping and release the
context before finishing or restoring the folio. Limit repeated
foreground anonymous-admission failures within a reclaim pass so file
reclaim can progress. Avoid reclaiming allocations while token or
storage locks are held.

On fault, handle zero tokens separately and retain slot lookup
references through allocation and decompression. Restore resident
pending backing through its dedicated path. Revalidate the original PTE
before installing a restored folio, preserve PTE attributes, and consume
only the ownership replaced by a successful installation. Fall back to a
single-page fault when a multi-page mapping cannot be restored together.
Return vm_fault_t results and release temporary references on retry and
error paths.

Observe dirty PTEs and PMDs before unmapping a swap-cache folio. Release
a dirty folio's swap slot so its current contents can be compressed;
drop a clean swap-cache folio through the normal path.

Expose stat and compressor attributes under the existing memcomp
sysfs directory and document memcomp.compressor= selection. Add direct
maintenance coverage for the core and its implementation headers.
Ordinary swap remains the fallback before token ownership; compressed
writeback is not part of this change. UFFDIO_MOVE returns -EFAULT for
memcomp entries until the following change adds their movement.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 .../admin-guide/kernel-parameters.txt         |   10 +
 MAINTAINERS                                   |    9 +-
 fs/proc/task_mmu.c                            |   20 +
 include/linux/memcomp.h                       |  297 +-
 mm/Kconfig                                    |   55 +
 mm/Makefile                                   |    1 +
 mm/hmm.c                                      |    3 +
 mm/huge_memory.c                              |   44 +
 mm/internal.h                                 |   84 +
 mm/madvise.c                                  |   10 +-
 mm/memcomp.c                                  | 3561 +++++++++++++++++
 mm/memcomp/access.h                           |  132 +
 mm/memcomp/anon_folio.h                       |   84 +
 mm/memcomp/anon_store.h                       |  245 ++
 mm/memcomp/api.h                              |  149 +
 mm/memcomp/consumers.h                        |   64 +
 mm/memcomp/fault.h                            |  254 ++
 mm/memcomp/fault_alloc.h                      |   23 +
 mm/memcomp/fifo.h                             |  136 +
 mm/memcomp/folio.h                            |  386 ++
 mm/memcomp/format.h                           |  308 ++
 mm/memcomp/lifetime.h                         |   87 +
 mm/memcomp/load.h                             |   59 +
 mm/memcomp/migrate.h                          |  152 +
 mm/memcomp/owner.h                            |  111 +
 mm/memcomp/payload.h                          |  151 +
 mm/memcomp/query.h                            |  187 +
 mm/memcomp/refs.h                             |   83 +
 mm/memcomp/resident.h                         |  103 +
 mm/memcomp/scan.h                             |  115 +
 mm/memcomp/span.h                             |   89 +
 mm/memcomp/storage.h                          |  963 +++++
 mm/memcomp/zero.h                             |  205 +
 mm/memcomp/zero_convert.h                     |   78 +
 mm/memcomp/zero_load.h                        |   71 +
 mm/memory.c                                   |   42 +-
 mm/migrate.c                                  |   11 +-
 mm/rmap.c                                     |   29 +-
 mm/swapfile.c                                 |   11 +
 mm/vmscan.c                                   |  313 +-
 40 files changed, 8723 insertions(+), 12 deletions(-)
 create mode 100644 mm/memcomp.c
 create mode 100644 mm/memcomp/access.h
 create mode 100644 mm/memcomp/anon_folio.h
 create mode 100644 mm/memcomp/anon_store.h
 create mode 100644 mm/memcomp/api.h
 create mode 100644 mm/memcomp/consumers.h
 create mode 100644 mm/memcomp/fault.h
 create mode 100644 mm/memcomp/fault_alloc.h
 create mode 100644 mm/memcomp/fifo.h
 create mode 100644 mm/memcomp/folio.h
 create mode 100644 mm/memcomp/format.h
 create mode 100644 mm/memcomp/lifetime.h
 create mode 100644 mm/memcomp/load.h
 create mode 100644 mm/memcomp/migrate.h
 create mode 100644 mm/memcomp/owner.h
 create mode 100644 mm/memcomp/payload.h
 create mode 100644 mm/memcomp/query.h
 create mode 100644 mm/memcomp/refs.h
 create mode 100644 mm/memcomp/resident.h
 create mode 100644 mm/memcomp/scan.h
 create mode 100644 mm/memcomp/span.h
 create mode 100644 mm/memcomp/storage.h
 create mode 100644 mm/memcomp/zero.h
 create mode 100644 mm/memcomp/zero_convert.h
 create mode 100644 mm/memcomp/zero_load.h

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index d401577b5a6ace87d250d9b1cc200691c6a0ed4e..d666ec6157f622f47ccf3401337e4555d7fed3ae 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3339,6 +3339,16 @@
 			[KNL,SH] Allow user to override the default size for
 			per-device physically contiguous DMA buffers.
 
+	memcomp.compressor=
+			[KNL] Set the crypto compression algorithm used by
+			CONFIG_MEMCOMP. The default is
+			CONFIG_MEMCOMP_DEFAULT_COMPRESSOR. memcomp
+			waits up to ten seconds for an algorithm that is not
+			registered by late_initcall; if it does not appear,
+			or memcomp cannot be set up on it, memcomp
+			falls back to "zstd", and is disabled if that
+			fails too.
+
 	memhp_default_state=online/offline/online_kernel/online_movable
 			[KNL] Set the initial state for the memory hotplug
 			onlining policy. If not specified, the default value is
diff --git a/MAINTAINERS b/MAINTAINERS
index dc29bbc6e53547cba9fc1763104463bb1091f7ec..d9e7e3bd65e4dfcd6eb4fd9e23d587959bac096e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14802,6 +14802,14 @@ F:	mm/memblock.c
 F:	mm/mm_init.c
 F:	tools/testing/memblock/
 
+MEMCOMP IN-MEMORY COMPRESSION
+M:	nakixii <nakixii@gmail.com>
+L:	linux-mm@kvack.org
+S:	Experimental
+F:	include/linux/memcomp.h
+F:	mm/memcomp.c
+F:	mm/memcomp/
+
 MEMORY ALLOCATION PROFILING
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Kent Overstreet <kent.overstreet@linux.dev>
@@ -14852,7 +14860,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
-F:	include/linux/memcomp.h
 F:	include/linux/memfd.h
 F:	include/linux/memory.h
 F:	include/linux/memory_hotplug.h
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 536b7dc453818209037a5aa4f8b3d069d93edfd7..9c6ba341927b98264d7f9427bbed75009b653694 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -15,6 +15,7 @@
 #include <linux/swap.h>
 #include <linux/sched/mm.h>
 #include <linux/swapops.h>
+#include <linux/memcomp.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
 #include <linux/shmem_fs.h>
@@ -807,7 +808,26 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 	} else if (is_swap_pte(ptent)) {
 		swp_entry_t swpent = pte_to_swp_entry(ptent);
 
+#ifdef CONFIG_MEMCOMP
+		if (is_memcomp_entry(swpent)) {
+			int mapcount;
+
+			if (memcomp_entry_stat(swp_offset(swpent),
+					       NULL, &mapcount)) {
+				mss->swap += PAGE_SIZE;
+				if (mapcount >= 2) {
+					u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
+
+					do_div(pss_delta, mapcount);
+					mss->swap_pss += pss_delta;
+				} else {
+					mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
+				}
+			}
+		} else if (!non_swap_entry(swpent)) {
+#else
 		if (!non_swap_entry(swpent)) {
+#endif
 			int mapcount;
 
 			mss->swap += PAGE_SIZE;
diff --git a/include/linux/memcomp.h b/include/linux/memcomp.h
index d399e76bd6b62fdbe377b905cd649960d802bcec..20b553d12151f7bc0202c25d52e4f6832c6ae0b6 100644
--- a/include/linux/memcomp.h
+++ b/include/linux/memcomp.h
@@ -2,12 +2,305 @@
 #ifndef _LINUX_MEMCOMP_H
 #define _LINUX_MEMCOMP_H
 
+#include <linux/errno.h>
+#include <linux/mm_types.h>
+#include <linux/stddef.h>
 #include <linux/types.h>
 
-/* The encoding reservation alone does not provide a compression backend. */
+struct folio;
+struct mc16_slot;
+struct mc16_cluster;
+struct memcomp_reclaim_ctx;
+struct vm_fault;
+
+/*
+ * Caller-owned lookup guard.  Initialize to zero and test only @slot for a
+ * held guard; storage fields are opaque to callers.  Release consumes and
+ * clears the whole guard, including when the underlying put is not final.
+ */
+struct memcomp_ref {
+	struct mc16_slot *slot;
+	struct mc16_cluster *cluster;
+	u32 token;
+};
+
+enum memcomp_reclaim_source {
+	MEMCOMP_RECLAIM_DIRECT,
+	MEMCOMP_RECLAIM_KSWAPD,
+	MEMCOMP_RECLAIM_SOURCE_NR,
+};
+
+enum memcomp_anon_fail_event {
+	MEMCOMP_ANON_UNMAP_FAIL,
+	MEMCOMP_ANON_FINISH_FAIL,
+	/* Not tried, for having not compressed before. */
+	MEMCOMP_ANON_INCOMPRESSIBLE_SKIP,
+};
+
+#ifdef CONFIG_MEMCOMP
+
+bool memcomp_available(void);
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+void memcomp_count_initial_compress(void);
+void memcomp_count_normal_swap_fallback(void);
+#else
+static inline void memcomp_count_initial_compress(void)
+{
+}
+
+static inline void memcomp_count_normal_swap_fallback(void)
+{
+}
+#endif
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+void memcomp_count_anon_fail(enum memcomp_anon_fail_event event,
+			     unsigned int nr_pages);
+void memcomp_count_split_refused(struct folio *folio);
+#else
+
+static inline void
+memcomp_count_anon_fail(enum memcomp_anon_fail_event event,
+			unsigned int nr_pages)
+{
+}
+
+static inline void memcomp_count_split_refused(struct folio *folio)
+{
+}
+#endif
+/*
+ * Reject fresh foreground reservations early when no context can currently
+ * be admitted.  A true result is advisory; acquisition can still race.
+ */
+bool memcomp_reclaim_ctx_precheck(unsigned int nr_pages,
+				  enum memcomp_reclaim_source source);
+/* Acquire after reserving tokens and release before rollback or finish. */
+struct memcomp_reclaim_ctx *
+memcomp_reclaim_ctx_get(unsigned int nr_pages,
+			enum memcomp_reclaim_source source);
+void memcomp_reclaim_ctx_put(struct memcomp_reclaim_ctx *ctx);
+/* Read-only reservation preflight; allocation can still fail afterwards. */
+bool memcomp_reserve_eligible(struct folio *folio);
+/* Reserve tokens for an eligible folio before unmapping it. */
+bool memcomp_reserve(struct folio *folio);
+/* A non-NULL *@ctxp lease is consumed and cleared on every return. */
+bool memcomp_store_after_unmap(struct folio *folio,
+			       struct memcomp_reclaim_ctx **ctxp);
+void memcomp_rollback_folio(struct folio *folio);
+bool memcomp_folio_dirty(struct folio *folio);
+bool memcomp_folio_incompressible(struct folio *folio);
+/* Return fault flags (or zero to retry), never negative errno. */
+vm_fault_t memcomp_load(struct vm_fault *vmf, bool *locked);
+/* Return 1 if resident, 0 if movable/absent, or -EAGAIN if busy. */
+int memcomp_entry_resident(unsigned long token);
+/*
+ * Return 1 if resident, 0 if movable/absent, or -EAGAIN if busy.
+ * A successful lookup holds a guard even for a nonresident token; absent
+ * and busy lookups clear it.  The caller must put any held guard.
+ */
+int memcomp_entry_resident_get(unsigned long token, struct memcomp_ref *ref);
+void memcomp_entry_resident_put(struct memcomp_ref *ref);
+/* Consumes and clears the held guard on every return. */
+int memcomp_restore_resident(struct vm_fault *vmf, struct memcomp_ref *ref);
+void memcomp_invalidate(unsigned long token);
+void memcomp_invalidate_nr(unsigned long token, unsigned int nr_pages);
+void memcomp_invalidate_folio(struct folio *folio);
+bool memcomp_release_folio(struct folio *folio);
+int memcomp_migrate_folio(struct folio *dst, struct folio *src);
+void memcomp_migrate_folio_rollback(struct folio *dst, struct folio *src);
+unsigned int memcomp_entry_nr_pages(unsigned long token,
+				    unsigned long *base_token);
+/*
+ * Mapcount approximates unified references, including temporary guards.
+ * A compressed-size query may return false when busy and clears outputs;
+ * compressed == NULL is a refs-only observation permitted under PTL.
+ */
+bool memcomp_entry_stat(unsigned long token, unsigned long *compressed,
+			int *mapcount);
+/* Internal guards, not PTE references; a failed get clears the output. */
+bool memcomp_entry_get_ref(unsigned long token, struct memcomp_ref *ref);
+void memcomp_entry_put_ref(struct memcomp_ref *ref);
+bool memcomp_entry_set_refresh_pending(unsigned long token);
+void memcomp_entry_clear_refresh_pending(unsigned long token);
+bool memcomp_entry_get(unsigned long token);
+bool memcomp_entry_present(unsigned long token);
+
+#else
+
 static inline bool memcomp_available(void)
 {
 	return false;
 }
 
-#endif /* _LINUX_MEMCOMP_H */
+static inline void memcomp_count_initial_compress(void)
+{
+}
+
+static inline void memcomp_count_normal_swap_fallback(void)
+{
+}
+
+static inline void
+memcomp_count_anon_fail(enum memcomp_anon_fail_event event,
+			unsigned int nr_pages)
+{
+}
+
+static inline void memcomp_count_split_refused(struct folio *folio)
+{
+}
+
+static inline struct memcomp_reclaim_ctx *
+memcomp_reclaim_ctx_get(unsigned int nr_pages,
+			enum memcomp_reclaim_source source)
+{
+	return NULL;
+}
+
+static inline bool
+memcomp_reclaim_ctx_precheck(unsigned int nr_pages,
+			     enum memcomp_reclaim_source source)
+{
+	return true;
+}
+
+static inline void
+memcomp_reclaim_ctx_put(struct memcomp_reclaim_ctx *ctx)
+{
+}
+
+static inline bool memcomp_reserve_eligible(struct folio *folio)
+{
+	return false;
+}
+
+static inline bool memcomp_reserve(struct folio *folio)
+{
+	return false;
+}
+
+static inline bool
+memcomp_store_after_unmap(struct folio *folio,
+			  struct memcomp_reclaim_ctx **ctxp)
+{
+	if (ctxp)
+		*ctxp = NULL;
+	return false;
+}
+
+static inline void memcomp_rollback_folio(struct folio *folio)
+{
+}
+
+static inline vm_fault_t memcomp_load(struct vm_fault *vmf, bool *locked)
+{
+	return VM_FAULT_SIGBUS;
+}
+
+static inline int memcomp_entry_resident(unsigned long token)
+{
+	return 0;
+}
+
+static inline int memcomp_entry_resident_get(unsigned long token,
+					     struct memcomp_ref *ref)
+{
+	*ref = (struct memcomp_ref) { };
+	return 0;
+}
+
+static inline void memcomp_entry_resident_put(struct memcomp_ref *ref)
+{
+	*ref = (struct memcomp_ref) { };
+}
+
+static inline int memcomp_restore_resident(struct vm_fault *vmf,
+					   struct memcomp_ref *ref)
+{
+	*ref = (struct memcomp_ref) { };
+	return 0;
+}
+
+static inline void memcomp_invalidate(unsigned long token)
+{
+}
+
+static inline void memcomp_invalidate_nr(unsigned long token,
+					 unsigned int nr_pages)
+{
+}
+
+static inline void memcomp_invalidate_folio(struct folio *folio)
+{
+}
+
+static inline bool memcomp_folio_incompressible(struct folio *folio)
+{
+	return false;
+}
+
+static inline bool memcomp_release_folio(struct folio *folio)
+{
+	return false;
+}
+
+static inline int memcomp_migrate_folio(struct folio *dst,
+					struct folio *src)
+{
+	return 0;
+}
+
+static inline void memcomp_migrate_folio_rollback(struct folio *dst,
+						  struct folio *src)
+{
+}
+
+static inline unsigned int memcomp_entry_nr_pages(unsigned long token,
+						  unsigned long *base_token)
+{
+	if (base_token)
+		*base_token = token;
+	return 0;
+}
+
+static inline bool memcomp_entry_stat(unsigned long token,
+				      unsigned long *compressed,
+					  int *mapcount)
+{
+	return false;
+}
+
+static inline bool memcomp_entry_get_ref(unsigned long token,
+					 struct memcomp_ref *ref)
+{
+	*ref = (struct memcomp_ref) { };
+	return false;
+}
+
+static inline void memcomp_entry_put_ref(struct memcomp_ref *ref)
+{
+	*ref = (struct memcomp_ref) { };
+}
+
+static inline bool memcomp_entry_set_refresh_pending(unsigned long token)
+{
+	return false;
+}
+
+static inline void memcomp_entry_clear_refresh_pending(unsigned long token)
+{
+}
+
+static inline bool memcomp_entry_get(unsigned long token)
+{
+	return false;
+}
+
+static inline bool memcomp_entry_present(unsigned long token)
+{
+	return false;
+}
+
+#endif
+
+#endif
diff --git a/mm/Kconfig b/mm/Kconfig
index 33fa51d608dc517490c47790ad053816a1baf57a..d88c27e0235bf8ac79e05e009b8a4625d9d0c693 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -170,6 +170,61 @@ config ZSWAP_ZPOOL_DEFAULT
        default "zsmalloc" if ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
        default ""
 
+config MEMCOMP
+	bool "Compress reclaimed pages in memory (memcomp)"
+	#
+	# SWAP: memcomp installs swap PTEs of its own type and uses the
+	# generic swap-entry encoding and page-table helpers.
+	#
+	# ZRAM=n: !ZRAM also permits ZRAM=m for this bool, so require it off.
+	#
+	# zsmalloc is selected below because memcomp is built-in code and needs
+	# its allocator available in the same kernel.
+	#
+	# 64BIT: two independent 64-bit assumptions.  Tokens are u32 and
+	# allocated across the whole range, but a 32-bit swp_offset carries
+	# only BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT = 26 bits, so a token
+	# past 64M could not round-trip through a PTE.  And the load and
+	# refresh paths map a multi-page folio with kmap_local_folio(folio, 0)
+	# and then address nr_pages * PAGE_SIZE through it, which is only the
+	# whole folio because a 64-bit kernel has no highmem.
+	#
+	depends on MMU && 64BIT && CRYPTO && SWAP && ZRAM=n && !ZSWAP
+	select ZSMALLOC
+	select CRYPTO_ACOMP
+	select XXHASH
+	default n
+	help
+	  Enable direct in-memory compression for reclaimed anonymous pages.
+
+	  Pages are compressed into RAM and mapped through a special
+	  non-swap PTE entry type. This does not require swap block I/O as
+	  the first storage layer.
+
+	  If unsure, say N.
+
+config MEMCOMP_DEFAULT_COMPRESSOR
+	string "Default memcomp compressor"
+	depends on MEMCOMP
+	default "zstd"
+	help
+	  The crypto compression algorithm memcomp uses unless
+	  memcomp.compressor= names another. If the selected algorithm is
+	  unavailable, memcomp waits up to 10 seconds from initialization
+	  for registration before trying zstd. Setup failures also fall back
+	  to zstd. Memcomp stays disabled if neither can be set up.
+
+config MEMCOMP_DEBUG_STATS
+	bool "Debug statistics for memcomp"
+	depends on MEMCOMP
+	default n
+	help
+	  Collect and export memcomp debug counters beyond the core
+	  stat and compressor attributes.
+
+	  These counters add hot-path accounting and are intended for
+	  diagnosis and tuning.  If unsure, say N.
+
 config ZBUD
 	tristate "2:1 compression allocator (zbud)"
 	depends on ZSWAP
diff --git a/mm/Makefile b/mm/Makefile
index d5639b03616636e4d49913f76865e24edb270f73..adba38637a0e4f9a2b423c20aaf1cb10e9062f33 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -76,6 +76,7 @@ endif
 
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o swap_slots.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
+obj-$(CONFIG_MEMCOMP)	+= memcomp.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
 obj-$(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP)	+= hugetlb_vmemmap.o
diff --git a/mm/hmm.c b/mm/hmm.c
index 7e0229ae4a5a6bfc06bc8fde06abf31f6198093c..4ff6159b0e2da75130c19393b407d931450bf58f 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -273,6 +273,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		if (is_device_exclusive_entry(entry))
 			goto fault;
 
+		if (is_memcomp_entry(entry))
+			goto fault;
+
 		if (is_migration_entry(entry)) {
 			pte_unmap(ptep);
 			hmm_vma_walk->last = addr;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54ee918fc15707e1bd96b7bcd2fd097d9e0cb2d6..ebfa0b43166ff2e31ff6ff9e7b781f009057f0ee 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -41,6 +41,9 @@
 #include <linux/compat.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#ifdef CONFIG_MEMCOMP
+#include <linux/memcomp.h>
+#endif
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -3417,6 +3420,14 @@ int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 
 	if (folio_test_writeback(folio))
 		return -EBUSY;
+#ifdef CONFIG_MEMCOMP
+	if (is_anon && folio_test_swapbacked(folio) &&
+	    !folio_test_swapcache(folio) &&
+	    folio_memcomp_reserved(folio)) {
+		memcomp_count_split_refused(folio);
+		return -EBUSY;
+	}
+#endif
 
 	if (is_anon) {
 		/*
@@ -3692,6 +3703,39 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 		if (memcg)
 			set_shrinker_bit(memcg, folio_nid(folio),
 					 deferred_split_shrinker->id);
+#endif
+#ifdef CONFIG_MEMCOMP
+	}
+	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
+}
+
+/*
+ * Every page of @folio is mapped again, as when memcomp puts back the
+ * PTEs that reclaim replaced with its tokens before a store failed.  Undo
+ * deferred_split_folio(folio, true), so that neither reclaim nor the
+ * shrinker splits the folio as partially mapped; the shrinker drops it
+ * from the queue once it finds it no longer is.
+ *
+ * Called with the folio locked, which keeps split_folio() away.  The
+ * mapped count is read under split_queue_lock: an unmap that the read
+ * misses sets the flag again under that lock once it is dropped.
+ */
+void deferred_split_folio_remapped(struct folio *folio)
+{
+	struct deferred_split *ds_queue;
+	unsigned long flags;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	if (!folio_test_partially_mapped(folio))
+		return;
+
+	ds_queue = get_deferred_split_queue(folio);
+	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	if (folio_test_partially_mapped(folio) &&
+	    folio_nr_pages_mapped(folio) == folio_nr_pages(folio)) {
+		folio_clear_partially_mapped(folio);
+		mod_mthp_stat(folio_order(folio),
+			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 #endif
 	}
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
diff --git a/mm/internal.h b/mm/internal.h
index 398633d6b6c9f09f56e628dd08249b5390b90d7f..6f4967131933f176e111c82a71b5857a943922a4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -17,12 +17,88 @@
 #include <linux/swapops.h>
 #include <linux/swap_cgroup.h>
 #include <linux/tracepoint-defs.h>
+#include <linux/xxhash.h>
 
 /* Internal core VMA manipulation functions. */
 #include "vma.h"
 
 struct folio_batch;
 
+#ifdef CONFIG_MEMCOMP
+unsigned int memcomp_pte_batch(pte_t *start_pte, unsigned int max_nr);
+#else
+static inline unsigned int memcomp_pte_batch(pte_t *start_pte,
+					     unsigned int max_nr)
+{
+	return 0;
+}
+#endif
+
+/*
+ * Outside the swap cache, folio->swap of an anonymous folio is memcomp's:
+ * it names the first token of the span reclaim reserved for the folio, if
+ * any.  Tokens are 32-bit, so an offset with MEMCOMP_INCOMPRESSIBLE set
+ * is never one.  That bit, and a hash of the contents below it, mark a folio
+ * whose contents did not compress, so that reclaim stops compressing them
+ * while they hash the same.  The mark goes when the folio is reserved again,
+ * added to the swap cache or freed, and migration carries it over with the
+ * contents.  A split leaves it on the first page, where it no longer matches.
+ */
+#define MEMCOMP_INCOMPRESSIBLE	BIT_ULL(32)
+
+static inline bool memcomp_entry_is_mark(swp_entry_t entry)
+{
+	return is_memcomp_entry(entry) &&
+	       (swp_offset(entry) & MEMCOMP_INCOMPRESSIBLE);
+}
+
+/* Whether folio->swap names a span reclaim holds for the anonymous @folio. */
+static inline bool folio_memcomp_reserved(struct folio *folio)
+{
+	return is_memcomp_entry(folio->swap) &&
+	       !memcomp_entry_is_mark(folio->swap);
+}
+
+/* Not a file folio's private, which may look like a mark. */
+static inline bool folio_test_incompressible(struct folio *folio)
+{
+	return folio_test_anon(folio) &&
+	       memcomp_entry_is_mark(folio->swap);
+}
+
+/* @folio is locked and holds no reservation. */
+static inline void folio_set_incompressible(struct folio *folio, u32 hash)
+{
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio) ||
+			      folio_test_swapcache(folio), folio);
+	folio->swap = make_memcomp_entry(MEMCOMP_INCOMPRESSIBLE | hash);
+}
+
+/*
+ * The contents of the locked @folio, hashed for the mark.  The length goes
+ * into the hash, so the first page of a split folio no longer matches.
+ */
+static inline u32 memcomp_folio_hash(struct folio *folio)
+{
+	void *src = kmap_local_folio(folio, 0);
+	u32 hash;
+
+	hash = xxh64(src, folio_size(folio), 0);
+	kunmap_local(src);
+	return hash;
+}
+
+static inline u32 folio_incompressible_hash(struct folio *folio)
+{
+	return (u32)swp_offset(folio->swap);
+}
+
+static inline void folio_clear_incompressible(struct folio *folio)
+{
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_incompressible(folio), folio);
+	folio->swap.val = 0;
+}
+
 /*
  * The set of flags that only affect watermark checking and reclaim
  * behaviour. This is used by the MM to obey the caller constraints
@@ -701,6 +777,14 @@ static inline bool folio_unqueue_deferred_split(struct folio *folio)
 	return __folio_unqueue_deferred_split(folio);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void deferred_split_folio_remapped(struct folio *folio);
+#else
+static inline void deferred_split_folio_remapped(struct folio *folio)
+{
+}
+#endif
+
 static inline struct folio *page_rmappable_folio(struct page *page)
 {
 	struct folio *folio = (struct folio *)page;
diff --git a/mm/madvise.c b/mm/madvise.c
index c211e8fa4e49bb1f2ae5d73ea12e9436077514f5..cd55e3c093ed6570a0d37c59422c5bb607283ac3 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/mman.h>
+#include <linux/memcomp.h>
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/mempolicy.h>
@@ -680,7 +681,14 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 			swp_entry_t entry;
 
 			entry = pte_to_swp_entry(ptent);
-			if (!non_swap_entry(entry)) {
+			if (is_memcomp_entry(entry)) {
+				max_nr = (end - addr) / PAGE_SIZE;
+				nr = memcomp_pte_batch(pte, max_nr);
+				nr_swap -= nr;
+				memcomp_invalidate_nr(swp_offset(entry), nr);
+				clear_not_present_full_ptes(mm, addr, pte, nr,
+							    tlb->fullmm);
+			} else if (!non_swap_entry(entry)) {
 				max_nr = (end - addr) / PAGE_SIZE;
 				nr = swap_pte_batch(pte, max_nr, ptent);
 				nr_swap -= nr;
diff --git a/mm/memcomp.c b/mm/memcomp.c
new file mode 100644
index 0000000000000000000000000000000000000000..80b71e217ff5a6a2fa1d033edf6079a670a55020
--- /dev/null
+++ b/mm/memcomp.c
@@ -0,0 +1,3561 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * memcomp - direct in-memory compression for reclaimed pages.
+ *
+ * Reclaim compresses anonymous and shmem pages straight into zsmalloc
+ * and installs SWP_MEMCOMP PTEs (or page-cache shadows) that carry a
+ * token into a global xarray.  Faults decompress synchronously.  Under
+ * continued pressure a shrinker writes cold payloads to real swap.  Compressible
+ * payloads share packed slots; raw payloads use individual slots.  Refaults
+ * recover the payload according to the entry's backing format.
+ *
+ * Metadata is kept deliberately small: entries carry no private mutex
+ * (payload state is serialized by a hashed lock table), and a swap-backed
+ * entry needs no descriptor - its slot lives in the handle word.
+ */
+#define pr_fmt(fmt) "memcomp: " fmt
+
+#include <crypto/algapi.h>
+#include <linux/atomic.h>
+#include <linux/bitmap.h>
+#include <linux/cacheflush.h>
+#include <linux/cpumask.h>
+#include <linux/crypto.h>
+#include <linux/errno.h>
+#include <linux/gfp.h>
+#include <linux/hash.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/kobject.h>
+#include <linux/kref.h>
+#include <linux/kthread.h>
+#include <linux/local_lock.h>
+#include <linux/list.h>
+#include <linux/log2.h>
+#include <linux/memcomp.h>
+#include <linux/mempolicy.h>
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/mmu_notifier.h>
+#include <linux/huge_mm.h>
+#include <linux/mm_inline.h>
+#include <linux/memcontrol.h>
+#include <linux/numa.h>
+#include <linux/percpu.h>
+#include <linux/preempt.h>
+#include <linux/printk.h>
+#include <linux/rmap.h>
+#include <linux/sched/cputime.h>
+#include <linux/shrinker.h>
+#include <linux/slab.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
+#include <linux/timekeeping.h>
+#include <linux/wait.h>
+#include <linux/wait_bit.h>
+#include <linux/writeback.h>
+#include <linux/workqueue.h>
+#include <linux/pagemap.h>
+#include <linux/pgtable.h>
+#include <linux/xarray.h>
+#include <linux/zsmalloc.h>
+
+#include "swap.h"
+#include "memcomp/fault_alloc.h"
+#include "internal.h"
+
+/*
+ * A single zsmalloc pool minimizes partially-filled zspages and thus
+ * fragmentation; zsmalloc's per-class locks provide the parallelism
+ * (zram uses one pool per device the same way).
+ */
+#define MEMCOMP_NR_POOLS 1
+#define MEMCOMP_MAX_COMP_CTXS 32
+#define MEMCOMP_MAX_BORROWED_COMP_CTXS 1
+#define MEMCOMP_DEFAULT_COMPRESSOR CONFIG_MEMCOMP_DEFAULT_COMPRESSOR
+#define MEMCOMP_MAX_COMPRESSED_SIZE (2 * PAGE_SIZE)
+#define MEMCOMP_MAX_COMPRESS_PAGES 16
+#define MEMCOMP_COMPRESSOR_NAME_LEN 32
+#define MEMCOMP_CTX_TIMING_SAMPLE_SHIFT 8
+#define MEMCOMP_CTX_TIMING_SAMPLE_INTERVAL \
+	(1U << MEMCOMP_CTX_TIMING_SAMPLE_SHIFT)
+#define MEMCOMP_CTX_TIMING_SAMPLE_MASK \
+	(MEMCOMP_CTX_TIMING_SAMPLE_INTERVAL - 1)
+/* Foreground reclaim is limited by contexts, not the background budget. */
+#define MEMCOMP_DIRECT_COMP_BUDGET 0
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+#define memcomp_debug_inc(counter)		atomic64_inc(counter)
+#define memcomp_debug_dec(counter)		atomic64_dec(counter)
+#define memcomp_debug_add(value, counter)	atomic64_add(value, counter)
+#define memcomp_debug_long_inc(counter)	atomic_long_inc(counter)
+#define memcomp_debug_long_dec(counter)	atomic_long_dec(counter)
+#define memcomp_debug_long_add(value, counter) \
+	atomic_long_add(value, counter)
+#define memcomp_debug_long_sub(value, counter) \
+	atomic_long_sub(value, counter)
+#define memcomp_debug_this_cpu_inc(field)	this_cpu_inc(field)
+#define memcomp_debug_this_cpu_dec(field)	this_cpu_dec(field)
+
+static void memcomp_atomic64_update_max(atomic64_t *counter, u64 value);
+
+static u64 memcomp_debug_clock(void)
+{
+	return ktime_get_ns();
+}
+
+/* Add the time since @start to @total, and keep the longest in @max. */
+static void memcomp_debug_elapsed(u64 start, atomic64_t *total,
+				  atomic64_t *max)
+{
+	u64 delta = ktime_get_ns() - start;
+
+	atomic64_add(delta, total);
+	memcomp_atomic64_update_max(max, delta);
+}
+#else
+#define memcomp_debug_inc(...)		do { } while (0)
+#define memcomp_debug_dec(...)		do { } while (0)
+#define memcomp_debug_add(...)		do { } while (0)
+#define memcomp_debug_long_inc(...)		do { } while (0)
+#define memcomp_debug_long_dec(...)		do { } while (0)
+#define memcomp_debug_long_add(...)		do { } while (0)
+#define memcomp_debug_long_sub(...)		do { } while (0)
+#define memcomp_debug_this_cpu_inc(...)	do { } while (0)
+#define memcomp_debug_this_cpu_dec(...)	do { } while (0)
+
+static inline u64 memcomp_debug_clock(void)
+{
+	return 0;
+}
+
+#define memcomp_debug_elapsed(start, ...)		((void)(start))
+#endif
+
+#define memcomp_wb_reclaimed(nr) \
+	memcomp_debug_add(nr, &memcomp_writeback_zs_reclaimed)
+
+#define MEMCOMP_LOCK_BITS 10
+#define MEMCOMP_NR_LOCKS ((unsigned int)BIT(MEMCOMP_LOCK_BITS))
+
+/* Slot layout and effective payload states are defined by storage headers. */
+
+enum memcomp_payload_mode {
+	MEMCOMP_PAYLOAD_BEST_EFFORT,
+	MEMCOMP_PAYLOAD_MUST_SUCCEED,
+};
+
+enum memcomp_comp_ctx_miss {
+	MEMCOMP_COMP_CTX_AVAILABLE,
+	MEMCOMP_COMP_CTX_BUDGET,
+	MEMCOMP_COMP_CTX_RESERVED_FREE,
+	MEMCOMP_COMP_CTX_BORROW_LIMIT,
+	MEMCOMP_COMP_CTX_BACKGROUND_WAITERS,
+	MEMCOMP_COMP_CTX_ALL_BUSY,
+};
+
+enum memcomp_compress_timing_outcome {
+	MEMCOMP_COMPRESS_TIMING_COMPRESSIBLE,
+	MEMCOMP_COMPRESS_TIMING_RAW_HUGE,
+	MEMCOMP_COMPRESS_TIMING_RAW_GE_PAGE,
+	MEMCOMP_COMPRESS_TIMING_ERROR,
+	MEMCOMP_COMPRESS_TIMING_NR,
+};
+
+struct memcomp_ctx_timing_record {
+	u64 timing_start_ns;
+	u64 timing_lease_end_ns;
+	u64 timing_store_start_ns;
+	u64 timing_store_end_ns;
+	u64 timing_compress_ns;
+	u64 timing_compress_cpu_ns;
+	u64 timing_compress_call_cpu_max_ns;
+	u64 timing_compress_outcome_ns[MEMCOMP_COMPRESS_TIMING_NR];
+	u64 timing_compress_outcome_cpu_ns[MEMCOMP_COMPRESS_TIMING_NR];
+	u64 timing_zs_ns;
+	u32 timing_compress_outcome_calls[MEMCOMP_COMPRESS_TIMING_NR];
+	u32 timing_pages;
+	enum memcomp_reclaim_source timing_source;
+	bool timing_active;
+	bool timing_store_success;
+};
+
+/*
+ * A direct single-page store writes into a detached buffer so its compression
+ * context can be published before reenabling preemption and beginning zsmalloc pool
+ * work.  Slots are preallocated and never waited on from reclaim.
+ */
+struct memcomp_direct_staging {
+	unsigned char *dst;
+	struct memcomp_ctx_timing_record timing;
+};
+
+/* Borrowed under the locked source folio's OWNER; never put this carrier. */
+struct mc16_zero_carrier {
+	struct memcomp_ref ref;
+	unsigned long token;
+	bool valid;
+	bool ready;
+};
+
+struct memcomp_store_ctx {
+	struct memcomp_direct_staging *staging;
+	/* The span's anon_vma reference, for the caller to drop once stored. */
+	struct anon_vma *anon_vma;
+	struct mc16_zero_carrier zero;
+};
+
+/*
+ * Hashed payload locks.  One entry's state and payload are protected by
+ * the mutex its token hashes to.  Never hold two token locks at once.
+ */
+static struct mutex memcomp_locks[MEMCOMP_NR_LOCKS];
+
+static inline struct mutex *memcomp_lock_of(u32 token)
+{
+	return &memcomp_locks[hash_32(token, MEMCOMP_LOCK_BITS)];
+}
+
+/*
+ * Move an entry between the states documented above.
+ *
+ * @state and @flags are written under the token lock, and lockdep cannot infer
+ * that on its own - it reports a lock taken in the wrong order, not one that
+ * was never taken.  Routing every transition through here turns the invariant
+ * into something CONFIG_PROVE_LOCKING checks on every store.
+ */
+
+/*
+ * Keep the cold compressed stream local to its MGLRU source node.  MGLRU
+ * feeds folios to memcomp from oldest to youngest; insertion and a fault
+ * both put an entry at the hot end, so the tail remains the coldest safe
+ * candidate for swap writeback on that node.
+ */
+struct memcomp_lru {
+	spinlock_t lock; /* protects entries and on_lru */
+	struct list_head entries;
+	atomic_long_t nr_entries;
+};
+
+static struct memcomp_lru memcomp_lrus[MAX_NUMNODES];
+
+static struct shrinker *memcomp_meta_shrinker;
+
+static struct zs_pool *memcomp_pools[MEMCOMP_NR_POOLS];
+static int memcomp_nr_pools;
+
+/* Independently leased compression contexts for the store/refresh paths. */
+struct memcomp_reclaim_ctx {
+	/* Serializes compression context use. */
+	struct mutex lock;
+	struct crypto_comp *tfm;
+	unsigned char *dst;
+	struct memcomp_ctx_timing_record timing;
+	u32 timing_seq[MEMCOMP_RECLAIM_SOURCE_NR];
+	bool borrowed;
+	bool background;
+	bool direct_staging;
+};
+
+enum memcomp_ctx_timing_kind {
+	MEMCOMP_CTX_TIMING_DIRECT,
+	MEMCOMP_CTX_TIMING_BACKGROUND,
+	MEMCOMP_CTX_TIMING_NR,
+};
+
+struct memcomp_compress_timing_stats {
+	atomic64_t calls;
+	atomic64_t wall_ns;
+	atomic64_t cpu_ns;
+};
+
+struct memcomp_compress_timing_stamp {
+	u64 wall_ns;
+	u64 cpu_ns;
+};
+
+struct memcomp_ctx_timing_stats {
+	atomic64_t samples;
+	atomic64_t pages;
+	atomic64_t store_samples;
+	atomic64_t store_success;
+	atomic64_t lease_ns;
+	atomic64_t lease_max_ns;
+	atomic64_t pre_store_ns;
+	atomic64_t pre_store_max_ns;
+	atomic64_t compress_ns;
+	atomic64_t compress_max_ns;
+	atomic64_t compress_cpu_ns;
+	atomic64_t compress_call_cpu_max_ns;
+	atomic64_t compress_store_success_ns;
+	atomic64_t compress_store_success_cpu_ns;
+	atomic64_t compress_store_fail_ns;
+	atomic64_t compress_store_fail_cpu_ns;
+	struct memcomp_compress_timing_stats
+		compress_outcome[MEMCOMP_COMPRESS_TIMING_NR];
+	atomic64_t zs_ns;
+	atomic64_t zs_max_ns;
+	atomic64_t store_other_ns;
+	atomic64_t store_other_max_ns;
+};
+
+struct memcomp_ctx_wait_stats {
+	atomic64_t events;
+	atomic64_t ns;
+	atomic64_t max_ns;
+};
+
+struct memcomp_comp_budget {
+	unsigned int active;
+	unsigned int background_active;
+	unsigned int peak;
+	unsigned int background_peak;
+};
+
+static struct memcomp_reclaim_ctx
+	memcomp_comp_ctxs[MEMCOMP_MAX_COMP_CTXS];
+/* Each element is protected by the corresponding compression context lock. */
+static struct memcomp_direct_staging
+	memcomp_direct_staging[MEMCOMP_MAX_COMP_CTXS];
+static unsigned int memcomp_nr_comp_ctxs;
+static unsigned int memcomp_nr_direct_staging;
+static unsigned int memcomp_nr_reserved_comp_ctxs;
+static unsigned int memcomp_nr_borrowable_comp_ctxs;
+static DEFINE_SPINLOCK(memcomp_comp_ctx_lock);
+static unsigned long memcomp_comp_ctx_free;
+static unsigned long memcomp_comp_ctx_all;
+static unsigned long memcomp_comp_ctx_foreground;
+static unsigned long memcomp_comp_ctx_borrowed;
+static unsigned int memcomp_comp_ctx_borrowed_active;
+static unsigned int memcomp_comp_ctx_borrowed_peak;
+static unsigned int memcomp_comp_ctx_waiters;
+static struct memcomp_comp_budget memcomp_comp_budget;
+static DECLARE_WAIT_QUEUE_HEAD(memcomp_comp_ctx_wait);
+static DEFINE_SPINLOCK(memcomp_direct_staging_lock);
+static unsigned long memcomp_direct_staging_free;
+static unsigned int memcomp_direct_staging_active;
+static unsigned int memcomp_direct_staging_peak;
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static atomic64_t memcomp_comp_ctx_waits = ATOMIC64_INIT(0);
+static atomic64_t memcomp_comp_ctx_wait_ns = ATOMIC64_INIT(0);
+static atomic64_t memcomp_comp_ctx_wait_max_ns = ATOMIC64_INIT(0);
+static struct memcomp_ctx_timing_stats
+	memcomp_ctx_timing[MEMCOMP_CTX_TIMING_NR];
+static struct memcomp_ctx_timing_stats
+	memcomp_ctx_source_timing[MEMCOMP_RECLAIM_SOURCE_NR];
+static struct memcomp_ctx_wait_stats
+	memcomp_ctx_source_wait[MEMCOMP_RECLAIM_SOURCE_NR];
+static atomic64_t
+	memcomp_comp_budget_waits[MEMCOMP_RECLAIM_SOURCE_NR];
+#endif
+
+/* Per-CPU decompression contexts for the page-fault load hot path. */
+struct memcomp_decomp_ctx {
+	local_lock_t lock;
+	struct crypto_comp *tfm;
+};
+
+static DEFINE_PER_CPU(struct memcomp_decomp_ctx, memcomp_decomp_ctxs) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
+
+static bool memcomp_enabled;
+static char memcomp_compressor[MEMCOMP_COMPRESSOR_NAME_LEN] =
+	MEMCOMP_DEFAULT_COMPRESSOR;
+/* Serializes synchronous compressor selection. */
+static DEFINE_MUTEX(memcomp_select_lock);
+
+static bool memcomp_is_enabled(void)
+{
+	/* Pairs with the init-time store publishing all backing resources. */
+	return smp_load_acquire(&memcomp_enabled);
+}
+
+static int __init memcomp_compressor_setup(char *str)
+{
+	if (!str || !*str)
+		return 0;
+
+	strscpy(memcomp_compressor, str, sizeof(memcomp_compressor));
+	return 1;
+}
+__setup("memcomp.compressor=", memcomp_compressor_setup);
+
+/* Bytes represented by live memcomp entries (pre-compression payload). */
+static atomic64_t memcomp_stored_bytes = ATOMIC64_INIT(0);
+/* Compressed bytes represented by live memcomp entries. */
+static atomic64_t memcomp_compressed_bytes = ATOMIC64_INIT(0);
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+/* Keep debug-only selection diagnostics off a globally contended cacheline. */
+enum memcomp_placement_stat {
+	MEMCOMP_PLACEMENT_STAT_COMPRESS,
+	MEMCOMP_PLACEMENT_STAT_NORMAL_SWAP_FALLBACK,
+	MEMCOMP_PLACEMENT_STAT_NR,
+};
+
+struct memcomp_placement_stats {
+	unsigned long count[MEMCOMP_PLACEMENT_STAT_NR];
+};
+
+static DEFINE_PER_CPU(struct memcomp_placement_stats,
+			      memcomp_placement_stats);
+
+/* Cumulative hot-path events used to diagnose reclaim capacity. */
+static atomic64_t memcomp_ctx_busy = ATOMIC64_INIT(0);
+static atomic64_t memcomp_reclaim_ctx_busy_reserved_free_pages =
+	ATOMIC64_INIT(0);
+static atomic64_t memcomp_reclaim_ctx_busy_all_busy_pages =
+	ATOMIC64_INIT(0);
+static atomic64_t memcomp_reclaim_ctx_borrow_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_reclaim_ctx_borrow_limit_pages =
+	ATOMIC64_INIT(0);
+static atomic64_t memcomp_reclaim_ctx_borrow_waiter_pages =
+	ATOMIC64_INIT(0);
+static atomic64_t memcomp_reclaim_ctx_budget_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_reclaim_ctx_budget_reject = ATOMIC64_INIT(0);
+static atomic64_t memcomp_reclaim_ctx_budget_reject_pages =
+	ATOMIC64_INIT(0);
+static atomic64_t memcomp_reclaim_ctx_early_reject = ATOMIC64_INIT(0);
+static atomic64_t memcomp_reclaim_ctx_early_reject_pages =
+	ATOMIC64_INIT(0);
+static atomic64_t memcomp_direct_staging_miss = ATOMIC64_INIT(0);
+static atomic64_t memcomp_direct_staging_detach = ATOMIC64_INIT(0);
+static atomic64_t memcomp_compress_fail = ATOMIC64_INIT(0);
+static atomic64_t memcomp_zs_fast_fail = ATOMIC64_INIT(0);
+static atomic64_t memcomp_zs_retries = ATOMIC64_INIT(0);
+static atomic64_t memcomp_zs_retry_success = ATOMIC64_INIT(0);
+static atomic64_t memcomp_zs_retry_fail = ATOMIC64_INIT(0);
+static atomic64_t memcomp_zs_fail = ATOMIC64_INIT(0);
+static atomic64_t memcomp_zs_other_fail = ATOMIC64_INIT(0);
+static atomic64_t memcomp_raw_store = ATOMIC64_INIT(0);
+static atomic64_t memcomp_raw_candidate_huge = ATOMIC64_INIT(0);
+static atomic64_t memcomp_raw_candidate_ge_page = ATOMIC64_INIT(0);
+static atomic64_t memcomp_raw_reject_huge = ATOMIC64_INIT(0);
+static atomic64_t memcomp_raw_reject_ge_page = ATOMIC64_INIT(0);
+static atomic64_t memcomp_raw_reject_zs_fallback = ATOMIC64_INIT(0);
+static atomic64_t memcomp_raw_reject_net = ATOMIC64_INIT(0);
+static atomic64_t memcomp_reserve_entry_alloc_fail = ATOMIC64_INIT(0);
+static atomic64_t memcomp_refresh_state_fail = ATOMIC64_INIT(0);
+static atomic64_t memcomp_refresh_payload_fail = ATOMIC64_INIT(0);
+static atomic64_t memcomp_anon_unmap_fail_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_refresh_preflight_fail_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_refresh_folio_busy_fail_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_refresh_arch_fail_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_refresh_state_fail_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_refresh_payload_fail_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_anon_finish_fail_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_incompressible_marked_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_incompressible_changed_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_incompressible_folio_skip_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_shmem_store_ok_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_shmem_store_fail_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_shmem_eligibility_fail_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_shmem_payload_fail_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_shmem_arch_fail_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_pending_pages = ATOMIC64_INIT(0);
+/*
+ * Rolling a span back once its tokens are in PTEs: the spans whose folio was
+ * mapped back, the PTEs that took, the pages a PTE still named after it, and
+ * the walks made again for those.
+ */
+static atomic64_t memcomp_restore_spans = ATOMIC64_INIT(0);
+static atomic64_t memcomp_restore_ptes = ATOMIC64_INIT(0);
+static atomic64_t memcomp_restore_missed_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_restore_rewalks = ATOMIC64_INIT(0);
+static atomic64_t memcomp_restore_ns = ATOMIC64_INIT(0);
+static atomic64_t memcomp_restore_max_ns = ATOMIC64_INIT(0);
+static atomic64_t memcomp_split_refused = ATOMIC64_INIT(0);
+static atomic64_t memcomp_split_refused_pages = ATOMIC64_INIT(0);
+static atomic64_t memcomp_bg_store_ok = ATOMIC64_INIT(0);
+static atomic64_t memcomp_bg_store_fail = ATOMIC64_INIT(0);
+static atomic64_t memcomp_direct_store_ok = ATOMIC64_INIT(0);
+static atomic64_t memcomp_direct_store_fail = ATOMIC64_INIT(0);
+static atomic64_t memcomp_pageout_store_ok = ATOMIC64_INIT(0);
+static atomic64_t memcomp_pageout_store_fail = ATOMIC64_INIT(0);
+#endif
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static atomic64_t memcomp_swapped_read_io = ATOMIC64_INIT(0);
+static atomic64_t memcomp_swapped_read_error = ATOMIC64_INIT(0);
+static atomic64_t memcomp_swapped_read_cached = ATOMIC64_INIT(0);
+static atomic_long_t memcomp_swapped_entries = ATOMIC_LONG_INIT(0);
+static atomic64_t memcomp_swapoff_entries = ATOMIC64_INIT(0);
+static atomic64_t memcomp_swapoff_read_io = ATOMIC64_INIT(0);
+static atomic64_t memcomp_swapoff_fail = ATOMIC64_INIT(0);
+#endif
+
+/*
+ * Current entry state gauges.  Updates stay CPU-local because every
+ * stored base page otherwise adds several contended global atomics to the
+ * reclaim path.  A decrement need not run on the CPU which incremented it,
+ * so the per-CPU fields must remain signed; only their global sum is useful.
+ */
+struct memcomp_state_stats {
+	s64 folio_owner_pages;
+	s64 samefill_pages;
+	s64 raw_pages;
+	s64 shmem_pages;
+};
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static DEFINE_PER_CPU(struct memcomp_state_stats,
+			      memcomp_state_stats);
+
+static void
+memcomp_state_add(struct memcomp_state_stats *snapshot,
+		  const struct memcomp_state_stats *stats)
+{
+	snapshot->folio_owner_pages += READ_ONCE(stats->folio_owner_pages);
+	snapshot->samefill_pages += READ_ONCE(stats->samefill_pages);
+	snapshot->raw_pages += READ_ONCE(stats->raw_pages);
+	snapshot->shmem_pages += READ_ONCE(stats->shmem_pages);
+}
+
+static void
+memcomp_state_clamp(struct memcomp_state_stats *snapshot)
+{
+	snapshot->folio_owner_pages =
+		max_t(s64, 0, snapshot->folio_owner_pages);
+	snapshot->samefill_pages = max_t(s64, 0, snapshot->samefill_pages);
+	snapshot->raw_pages = max_t(s64, 0, snapshot->raw_pages);
+	snapshot->shmem_pages = max_t(s64, 0, snapshot->shmem_pages);
+}
+
+static void
+memcomp_state_read(struct memcomp_state_stats *snapshot)
+{
+	int cpu;
+
+	memset(snapshot, 0, sizeof(*snapshot));
+	for_each_possible_cpu(cpu) {
+		struct memcomp_state_stats *stats;
+
+		stats = per_cpu_ptr(&memcomp_state_stats, cpu);
+		memcomp_state_add(snapshot, stats);
+	}
+
+	/* Cross-CPU reads are not transactional with concurrent migration. */
+	memcomp_state_clamp(snapshot);
+}
+
+static void memcomp_state_drop_owner(void)
+{
+	this_cpu_dec(memcomp_state_stats.folio_owner_pages);
+}
+
+/* Caller serializes the payload fields with the token lock. */
+
+#else
+static void memcomp_state_drop_owner(void)
+{
+}
+
+#endif
+
+enum memcomp_anon_store_fail {
+	MEMCOMP_ANON_STORE_PREFLIGHT,
+	MEMCOMP_ANON_STORE_FOLIO_BUSY,
+	MEMCOMP_ANON_STORE_ARCH,
+	MEMCOMP_ANON_STORE_REFRESH,
+};
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static void memcomp_account_anon_store(bool success,
+				       unsigned int nr_pages)
+{
+	atomic64_t *counter;
+
+	if (current_is_kswapd())
+		counter = success ? &memcomp_bg_store_ok :
+				    &memcomp_bg_store_fail;
+	else if (current->reclaim_state)
+		counter = success ? &memcomp_direct_store_ok :
+				    &memcomp_direct_store_fail;
+	else
+		counter = success ? &memcomp_pageout_store_ok :
+				    &memcomp_pageout_store_fail;
+
+	atomic64_add(nr_pages, counter);
+}
+
+static void
+memcomp_account_anon_store_fail(enum memcomp_anon_store_fail failure,
+				unsigned int nr_pages)
+{
+	switch (failure) {
+	case MEMCOMP_ANON_STORE_PREFLIGHT:
+		atomic64_add(nr_pages,
+			     &memcomp_refresh_preflight_fail_pages);
+		break;
+	case MEMCOMP_ANON_STORE_FOLIO_BUSY:
+		atomic64_add(nr_pages,
+			     &memcomp_refresh_folio_busy_fail_pages);
+		break;
+	case MEMCOMP_ANON_STORE_ARCH:
+		atomic64_add(nr_pages, &memcomp_refresh_arch_fail_pages);
+		break;
+	case MEMCOMP_ANON_STORE_REFRESH:
+		/* memcomp_do_refresh() accounts its exclusive reason. */
+		break;
+	}
+}
+
+void memcomp_count_anon_fail(enum memcomp_anon_fail_event event,
+			     unsigned int nr_pages)
+{
+	switch (event) {
+	case MEMCOMP_ANON_UNMAP_FAIL:
+		atomic64_add(nr_pages, &memcomp_anon_unmap_fail_pages);
+		break;
+	case MEMCOMP_ANON_FINISH_FAIL:
+		atomic64_add(nr_pages, &memcomp_anon_finish_fail_pages);
+		break;
+	case MEMCOMP_ANON_INCOMPRESSIBLE_SKIP:
+		atomic64_add(nr_pages,
+			     &memcomp_incompressible_folio_skip_pages);
+		break;
+	}
+}
+
+#else
+static void memcomp_account_anon_store(bool success,
+				       unsigned int nr_pages)
+{
+}
+
+static void
+memcomp_account_anon_store_fail(enum memcomp_anon_store_fail failure,
+				unsigned int nr_pages)
+{
+}
+#endif
+
+static inline void memcomp_stored_bytes_inc(void)
+{
+	atomic64_add(PAGE_SIZE, &memcomp_stored_bytes);
+}
+
+static inline void memcomp_stored_bytes_dec(void)
+{
+	atomic64_sub(PAGE_SIZE, &memcomp_stored_bytes);
+}
+
+static inline void memcomp_compressed_bytes_add(unsigned int bytes)
+{
+	atomic64_add(bytes, &memcomp_compressed_bytes);
+}
+
+static inline void memcomp_compressed_bytes_sub(unsigned int bytes)
+{
+	atomic64_sub(bytes, &memcomp_compressed_bytes);
+}
+
+static void memcomp_arch_restore(unsigned long token, struct folio *folio)
+{
+	arch_swap_restore(make_memcomp_entry(token), folio);
+}
+
+/* "Payload can satisfy a fault without swap IO". */
+
+static void memcomp_zs_free(u8 pool_idx, unsigned long handle)
+{
+	zs_free(memcomp_pools[pool_idx], handle);
+}
+
+static struct obj_cgroup *memcomp_objcg_get(struct folio *folio)
+{
+	/* Compressed objects do not have an accounting owner yet. */
+	return NULL;
+}
+
+/* Hold an additional metadata owner without bypassing the test model. */
+static __maybe_unused void memcomp_objcg_get_ref(struct obj_cgroup *objcg)
+{
+	/* No accounting owner was acquired. */
+}
+
+static void memcomp_objcg_put(struct obj_cgroup *objcg)
+{
+	/* No accounting owner was acquired. */
+}
+
+static int memcomp_objcg_charge(struct obj_cgroup *objcg, gfp_t gfp,
+				size_t size)
+{
+	return 0;
+}
+
+static void memcomp_objcg_uncharge(struct obj_cgroup *objcg, size_t size)
+{
+}
+
+#include "memcomp/format.h"
+#include "memcomp/zero.h"
+#include "memcomp/lifetime.h"
+#include "memcomp/storage.h"
+
+#ifdef CONFIG_SWAP
+/* An entry owns one reference on its raw or packed backing slot. */
+
+/*
+ * Take and drop a slot's reference count outside swap core.  These exist
+ * as named steps because the KUnit suite builds entries with synthetic
+ * slots and must not touch swap_info[] - under UML there is no device, so
+ * the real calls would log errors on every staged case.  The suite
+ * compiles them to tallies instead, so a case can still assert that a
+ * release or a restore handed its slot reference back; the production
+ * build keeps the direct calls.
+ */
+
+static void memcomp_slot_put(swp_entry_t swap)
+{
+	swap_free(swap);
+}
+
+/*
+ * Drop an entry's reference on a packed slot.  A sibling's fault may have
+ * left the slot's page in the swap cache for the others - see
+ * memcomp_read_swapped_page() - so the last entry to go takes that page
+ * with it rather than leaving the slot pinned until reclaim finds it.  The
+ * page is only trylocked, so this stays safe wherever a put is.
+ */
+static void memcomp_slot_put_packed(swp_entry_t swap)
+{
+	free_swap_and_cache(swap);
+}
+
+/* References on the slot, of entries and in-flight faults; racy by nature. */
+
+/*
+ * Detach a swap-backed entry from its slot.  Caller holds the token lock
+ * and must memcomp_slot_put() the returned entry after unlocking.
+ */
+
+/* Release the slot of a dying swap-backed entry.  Atomic-context safe. */
+
+#else /* !CONFIG_SWAP */
+
+#endif /* CONFIG_SWAP */
+
+#include "memcomp/access.h"
+#include "memcomp/fifo.h"
+#include "memcomp/refs.h"
+#include "memcomp/owner.h"
+#include "memcomp/span.h"
+#include "memcomp/migrate.h"
+#include "memcomp/query.h"
+#include "memcomp/scan.h"
+#include "memcomp/payload.h"
+
+/* Caller holds the token lock. */
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+void memcomp_count_split_refused(struct folio *folio)
+{
+	atomic64_inc(&memcomp_split_refused);
+	atomic64_add(folio_nr_pages(folio), &memcomp_split_refused_pages);
+}
+#endif
+
+/* Drop the caller's temporary lookup plus one long-lived owner/PTE ref. */
+
+/* Cache and PTE owners have independent zero-token accounting. */
+
+/*
+ * Clear @flag on @head, the first entry of the span reserved for the locked
+ * @folio, and return whether it was set.
+ */
+
+/*
+ * Take over the reference memcomp_reserve() took on the anon_vma of the
+ * locked @folio, if it took one, for the span @head is the first entry of.
+ */
+
+/*
+ * Drop the owner-folio reference of @entry if @folio still owns it.
+ * Consumes the caller's lookup reference either way.
+ */
+
+/*
+ * Take a stored folio off its entries, unless it no longer names any or
+ * someone else holds it.  On success it is frozen at no references, ready to
+ * be freed.
+ */
+
+/* Drop the PTE references of held @entries, which a fault replaced. */
+
+/*
+ * What the @nr_pages entries from @token are to @folio, finding each once:
+ * MC_SPAN_PENDING if it owns them all as the span they were reserved as and
+ * they are all still pending, MC_SPAN_STORED if it owns them all and none is,
+ * MC_SPAN_NONE for anything else.  With @entries, a span found pending or
+ * stored is left there with a reference on each entry for the caller to drop,
+ * so that it need not look them up again.
+ */
+
+/* Pin while the caller's PTL or page-cache lookup still names this token. */
+
+/* Consume the caller-owned guard before its final put can free storage. */
+
+static u64 memcomp_pool_total_size(void)
+{
+	u64 total = 0;
+	int i;
+
+	if (!memcomp_is_enabled())
+		return 0;
+
+	for (i = 0; i < memcomp_nr_pools; i++)
+		total += (zs_get_total_pages(memcomp_pools[i]) << PAGE_SHIFT);
+
+	return total;
+}
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static unsigned int memcomp_pool_huge_class_size(void)
+{
+	if (!memcomp_is_enabled() || !memcomp_nr_pools)
+		return 0;
+
+	return zs_huge_class_size(memcomp_pools[0]);
+}
+
+#endif
+
+static u8 memcomp_select_pool_idx(void)
+{
+	return raw_smp_processor_id() % memcomp_nr_pools;
+}
+
+bool memcomp_available(void)
+{
+	return memcomp_is_enabled() &&
+	       READ_ONCE(memcomp_nr_comp_ctxs);
+}
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static void memcomp_placement_stat_inc(enum memcomp_placement_stat stat)
+{
+	this_cpu_inc(memcomp_placement_stats.count[stat]);
+}
+
+static u64 memcomp_placement_stat_read(enum memcomp_placement_stat stat)
+{
+	u64 total = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct memcomp_placement_stats *stats;
+
+		stats = per_cpu_ptr(&memcomp_placement_stats, cpu);
+		total += READ_ONCE(stats->count[stat]);
+	}
+
+	return total;
+}
+
+void memcomp_count_initial_compress(void)
+{
+	memcomp_placement_stat_inc(MEMCOMP_PLACEMENT_STAT_COMPRESS);
+}
+
+void memcomp_count_normal_swap_fallback(void)
+{
+	enum memcomp_placement_stat stat =
+		MEMCOMP_PLACEMENT_STAT_NORMAL_SWAP_FALLBACK;
+
+	memcomp_placement_stat_inc(stat);
+}
+#endif
+
+static bool memcomp_can_retry_alloc(void)
+{
+	/* PF_MEMALLOC prevents recursive reclaim and permits net progress. */
+	return current_is_kswapd() &&
+	       (current->flags & (PF_MEMALLOC | PF_KTHREAD)) ==
+		       (PF_MEMALLOC | PF_KTHREAD);
+}
+
+static bool
+memcomp_comp_ctx_background(enum memcomp_payload_mode mode,
+			    enum memcomp_reclaim_source source,
+				bool can_retry)
+{
+	return mode != MEMCOMP_PAYLOAD_BEST_EFFORT &&
+	       source != MEMCOMP_RECLAIM_DIRECT && can_retry;
+}
+
+/*
+ * Drivers that compress entirely within the workspace allocated with their
+ * transform, so a lease can be carried into a preempt-disabled staging
+ * region, and whose output is the plain zstd frame the entropy shadow
+ * predictor is calibrated against.
+ */
+static bool memcomp_driver_is_zstd(const char *driver)
+{
+	return !strcmp(driver, "zstd-generic");
+}
+
+static bool
+memcomp_staging_policy(enum memcomp_payload_mode mode,
+		       enum memcomp_reclaim_source source,
+			   unsigned int nr_pages, const char *driver)
+{
+	return !IS_ENABLED(CONFIG_PREEMPT_RT) &&
+	       mode == MEMCOMP_PAYLOAD_MUST_SUCCEED &&
+	       source == MEMCOMP_RECLAIM_DIRECT && nr_pages == 1 &&
+	       memcomp_driver_is_zstd(driver);
+}
+
+/* Reserve a staging buffer for direct-reclaim compression. */
+static struct memcomp_direct_staging *
+memcomp_direct_staging_try_get(void)
+{
+	struct memcomp_direct_staging *staging = NULL;
+	unsigned int nr_staging;
+	unsigned long flags;
+	unsigned int idx;
+
+	nr_staging = READ_ONCE(memcomp_nr_direct_staging);
+	spin_lock_irqsave(&memcomp_direct_staging_lock, flags);
+	idx = find_first_bit(&memcomp_direct_staging_free, nr_staging);
+	if (idx < nr_staging) {
+		__clear_bit(idx, &memcomp_direct_staging_free);
+		memcomp_direct_staging_active++;
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+		memcomp_direct_staging_peak =
+			max(memcomp_direct_staging_peak,
+			    memcomp_direct_staging_active);
+#endif
+		staging = &memcomp_direct_staging[idx];
+	}
+	spin_unlock_irqrestore(&memcomp_direct_staging_lock, flags);
+	if (!staging)
+		memcomp_debug_inc(&memcomp_direct_staging_miss);
+	return staging;
+}
+
+static void
+memcomp_direct_staging_put(struct memcomp_direct_staging *staging)
+{
+	unsigned long flags;
+	unsigned int idx;
+
+	if (!staging)
+		return;
+	idx = staging - memcomp_direct_staging;
+	if (WARN_ON_ONCE(idx >= memcomp_nr_direct_staging))
+		return;
+	staging->timing.timing_active = false;
+	spin_lock_irqsave(&memcomp_direct_staging_lock, flags);
+	if (WARN_ON_ONCE(test_bit(idx, &memcomp_direct_staging_free))) {
+		spin_unlock_irqrestore(&memcomp_direct_staging_lock, flags);
+		return;
+	}
+	if (!WARN_ON_ONCE(!memcomp_direct_staging_active))
+		memcomp_direct_staging_active--;
+	__set_bit(idx, &memcomp_direct_staging_free);
+	spin_unlock_irqrestore(&memcomp_direct_staging_lock, flags);
+}
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static bool memcomp_ctx_timing_should_sample(u32 *seq)
+{
+	(*seq)++;
+	return !(*seq & MEMCOMP_CTX_TIMING_SAMPLE_MASK);
+}
+
+static u32 memcomp_ctx_timing_seed(unsigned int index)
+{
+	/* The odd multiplier permutes the power-of-two sampling interval. */
+	return index * 0x9e3779b9U & MEMCOMP_CTX_TIMING_SAMPLE_MASK;
+}
+
+static u64 memcomp_ctx_timing_remainder(u64 total, u64 measured)
+{
+	if (measured >= total)
+		return 0;
+	return total - measured;
+}
+
+static enum memcomp_ctx_timing_kind
+memcomp_ctx_timing_aggregate_kind(enum memcomp_reclaim_source source)
+{
+	return source == MEMCOMP_RECLAIM_DIRECT ?
+		MEMCOMP_CTX_TIMING_DIRECT :
+		MEMCOMP_CTX_TIMING_BACKGROUND;
+}
+
+static void memcomp_atomic64_update_max(atomic64_t *counter, u64 value)
+{
+	s64 old = atomic64_read(counter);
+	s64 new = min_t(u64, value, S64_MAX);
+
+	while (new > old &&
+	       !atomic64_try_cmpxchg_relaxed(counter, &old, new))
+		;
+}
+
+static void
+memcomp_ctx_timing_wait_start(enum memcomp_reclaim_source source)
+{
+	atomic64_inc(&memcomp_comp_ctx_waits);
+	atomic64_inc(&memcomp_ctx_source_wait[source].events);
+}
+
+static void
+memcomp_ctx_timing_wait_end(u64 start_ns,
+			    enum memcomp_reclaim_source source)
+{
+	struct memcomp_ctx_wait_stats *stats;
+	u64 delta = ktime_get_ns() - start_ns;
+
+	atomic64_add(delta, &memcomp_comp_ctx_wait_ns);
+	memcomp_atomic64_update_max(&memcomp_comp_ctx_wait_max_ns, delta);
+	stats = &memcomp_ctx_source_wait[source];
+	atomic64_add(delta, &stats->ns);
+	memcomp_atomic64_update_max(&stats->max_ns, delta);
+}
+
+static void memcomp_ctx_timing_start(struct memcomp_reclaim_ctx *ctx,
+				     unsigned int nr_pages,
+					 enum memcomp_reclaim_source source)
+{
+	struct memcomp_ctx_timing_record *timing = &ctx->timing;
+
+	timing->timing_active = false;
+	if (WARN_ON_ONCE((unsigned int)source >=
+			 MEMCOMP_RECLAIM_SOURCE_NR))
+		source = MEMCOMP_RECLAIM_DIRECT;
+	if (!memcomp_ctx_timing_should_sample(&ctx->timing_seq[source]))
+		return;
+
+	timing->timing_store_start_ns = 0;
+	timing->timing_store_end_ns = 0;
+	timing->timing_lease_end_ns = 0;
+	timing->timing_compress_ns = 0;
+	timing->timing_compress_cpu_ns = 0;
+	timing->timing_compress_call_cpu_max_ns = 0;
+	memset(timing->timing_compress_outcome_ns, 0,
+	       sizeof(timing->timing_compress_outcome_ns));
+	memset(timing->timing_compress_outcome_cpu_ns, 0,
+	       sizeof(timing->timing_compress_outcome_cpu_ns));
+	memset(timing->timing_compress_outcome_calls, 0,
+	       sizeof(timing->timing_compress_outcome_calls));
+	timing->timing_zs_ns = 0;
+	timing->timing_pages = nr_pages;
+	timing->timing_source = source;
+	timing->timing_store_success = false;
+	timing->timing_start_ns = ktime_get_ns();
+	timing->timing_active = true;
+}
+
+static __always_inline u64
+memcomp_ctx_timing_phase_start(struct memcomp_ctx_timing_record *timing)
+{
+	if (likely(!timing->timing_active))
+		return 0;
+	return ktime_get_ns();
+}
+
+static __always_inline void
+memcomp_ctx_timing_phase_end(struct memcomp_ctx_timing_record *timing,
+			     u64 start_ns, u64 *total_ns)
+{
+	if (unlikely(timing->timing_active))
+		*total_ns += ktime_get_ns() - start_ns;
+}
+
+static __always_inline struct memcomp_compress_timing_stamp
+memcomp_compress_timing_start(struct memcomp_ctx_timing_record *timing)
+{
+	struct memcomp_compress_timing_stamp stamp = {};
+
+	if (likely(!timing->timing_active))
+		return stamp;
+	stamp.wall_ns = ktime_get_ns();
+	stamp.cpu_ns = task_sched_runtime(current);
+	return stamp;
+}
+
+static __always_inline struct memcomp_compress_timing_stamp
+memcomp_compress_timing_end(struct memcomp_ctx_timing_record *timing,
+			    struct memcomp_compress_timing_stamp start)
+{
+	struct memcomp_compress_timing_stamp delta = {};
+	u64 cpu_ns;
+
+	if (likely(!timing->timing_active))
+		return delta;
+	cpu_ns = task_sched_runtime(current);
+	delta.wall_ns = ktime_get_ns() - start.wall_ns;
+	delta.cpu_ns = cpu_ns - start.cpu_ns;
+	timing->timing_compress_ns += delta.wall_ns;
+	timing->timing_compress_cpu_ns += delta.cpu_ns;
+	return delta;
+}
+
+static __always_inline void
+memcomp_compress_timing_account(struct memcomp_ctx_timing_record *timing,
+				struct memcomp_compress_timing_stamp delta,
+				    enum memcomp_compress_timing_outcome outcome)
+{
+	if (likely(!timing->timing_active))
+		return;
+	timing->timing_compress_outcome_calls[outcome]++;
+	timing->timing_compress_outcome_ns[outcome] += delta.wall_ns;
+	timing->timing_compress_outcome_cpu_ns[outcome] += delta.cpu_ns;
+	timing->timing_compress_call_cpu_max_ns =
+		max(timing->timing_compress_call_cpu_max_ns, delta.cpu_ns);
+}
+
+static void
+memcomp_ctx_timing_store_start(struct memcomp_ctx_timing_record *timing)
+{
+	if (timing->timing_active)
+		timing->timing_store_start_ns = ktime_get_ns();
+}
+
+static void
+memcomp_ctx_timing_store_end(struct memcomp_ctx_timing_record *timing,
+			     bool success)
+{
+	if (!timing->timing_active)
+		return;
+	timing->timing_store_end_ns = ktime_get_ns();
+	timing->timing_store_success = success;
+}
+
+static void
+memcomp_ctx_timing_account_bucket(struct memcomp_ctx_timing_record *timing,
+				  struct memcomp_ctx_timing_stats *stats,
+				      u64 lease_ns, u64 pre_store_ns,
+				      u64 store_other_ns)
+{
+	unsigned int i;
+
+	atomic64_inc(&stats->samples);
+	atomic64_add(timing->timing_pages, &stats->pages);
+	if (timing->timing_store_start_ns)
+		atomic64_inc(&stats->store_samples);
+	if (timing->timing_store_success)
+		atomic64_inc(&stats->store_success);
+	atomic64_add(lease_ns, &stats->lease_ns);
+	memcomp_atomic64_update_max(&stats->lease_max_ns, lease_ns);
+	atomic64_add(pre_store_ns, &stats->pre_store_ns);
+	memcomp_atomic64_update_max(&stats->pre_store_max_ns, pre_store_ns);
+	atomic64_add(timing->timing_compress_ns, &stats->compress_ns);
+	memcomp_atomic64_update_max(&stats->compress_max_ns,
+				    timing->timing_compress_ns);
+	atomic64_add(timing->timing_compress_cpu_ns, &stats->compress_cpu_ns);
+	memcomp_atomic64_update_max(&stats->compress_call_cpu_max_ns,
+				    timing->timing_compress_call_cpu_max_ns);
+	if (timing->timing_store_success) {
+		atomic64_add(timing->timing_compress_ns,
+			     &stats->compress_store_success_ns);
+		atomic64_add(timing->timing_compress_cpu_ns,
+			     &stats->compress_store_success_cpu_ns);
+	} else {
+		atomic64_add(timing->timing_compress_ns,
+			     &stats->compress_store_fail_ns);
+		atomic64_add(timing->timing_compress_cpu_ns,
+			     &stats->compress_store_fail_cpu_ns);
+	}
+	for (i = 0; i < MEMCOMP_COMPRESS_TIMING_NR; i++) {
+		struct memcomp_compress_timing_stats *outcome;
+
+		if (!timing->timing_compress_outcome_calls[i])
+			continue;
+		outcome = &stats->compress_outcome[i];
+		atomic64_add(timing->timing_compress_outcome_calls[i],
+			     &outcome->calls);
+		atomic64_add(timing->timing_compress_outcome_ns[i],
+			     &outcome->wall_ns);
+		atomic64_add(timing->timing_compress_outcome_cpu_ns[i],
+			     &outcome->cpu_ns);
+	}
+	atomic64_add(timing->timing_zs_ns, &stats->zs_ns);
+	memcomp_atomic64_update_max(&stats->zs_max_ns,
+				    timing->timing_zs_ns);
+	atomic64_add(store_other_ns, &stats->store_other_ns);
+	memcomp_atomic64_update_max(&stats->store_other_max_ns, store_other_ns);
+}
+
+static void
+memcomp_ctx_timing_account(struct memcomp_ctx_timing_record *timing)
+{
+	struct memcomp_ctx_timing_stats *stats;
+	enum memcomp_ctx_timing_kind kind;
+	u64 measured_store_ns;
+	u64 store_other_ns = 0;
+	u64 pre_store_ns;
+	u64 lease_ns;
+	u64 now_ns;
+
+	if (!timing->timing_active)
+		return;
+
+	now_ns = timing->timing_lease_end_ns ?: ktime_get_ns();
+	lease_ns = now_ns - timing->timing_start_ns;
+	if (timing->timing_store_start_ns) {
+		u64 store_end_ns = timing->timing_store_end_ns ?: now_ns;
+		u64 store_ns = store_end_ns - timing->timing_store_start_ns;
+
+		pre_store_ns = timing->timing_store_start_ns -
+				timing->timing_start_ns;
+		measured_store_ns = timing->timing_compress_ns +
+				    timing->timing_zs_ns;
+		store_other_ns =
+			memcomp_ctx_timing_remainder(store_ns,
+						     measured_store_ns);
+	} else {
+		/* The lease ended while unmapping or validating the folio. */
+		pre_store_ns = lease_ns;
+	}
+
+	kind = memcomp_ctx_timing_aggregate_kind(timing->timing_source);
+	stats = &memcomp_ctx_timing[kind];
+	memcomp_ctx_timing_account_bucket(timing, stats, lease_ns,
+					  pre_store_ns, store_other_ns);
+	stats = &memcomp_ctx_source_timing[timing->timing_source];
+	memcomp_ctx_timing_account_bucket(timing, stats, lease_ns,
+					  pre_store_ns, store_other_ns);
+	timing->timing_active = false;
+}
+#else
+static void memcomp_ctx_timing_start(struct memcomp_reclaim_ctx *ctx,
+				     unsigned int nr_pages,
+					 enum memcomp_reclaim_source source)
+{
+}
+
+static __always_inline u64
+memcomp_ctx_timing_phase_start(struct memcomp_ctx_timing_record *timing)
+{
+	return 0;
+}
+
+static __always_inline void
+memcomp_ctx_timing_phase_end(struct memcomp_ctx_timing_record *timing,
+			     u64 start_ns, u64 *total_ns)
+{
+}
+
+static __always_inline struct memcomp_compress_timing_stamp
+memcomp_compress_timing_start(struct memcomp_ctx_timing_record *timing)
+{
+	return (struct memcomp_compress_timing_stamp){};
+}
+
+static __always_inline struct memcomp_compress_timing_stamp
+memcomp_compress_timing_end(struct memcomp_ctx_timing_record *timing,
+			    struct memcomp_compress_timing_stamp start)
+{
+	return (struct memcomp_compress_timing_stamp){};
+}
+
+static __always_inline void
+memcomp_compress_timing_account(struct memcomp_ctx_timing_record *timing,
+				struct memcomp_compress_timing_stamp delta,
+				    enum memcomp_compress_timing_outcome outcome)
+{
+}
+
+static void
+memcomp_ctx_timing_store_start(struct memcomp_ctx_timing_record *timing)
+{
+}
+
+static void
+memcomp_ctx_timing_store_end(struct memcomp_ctx_timing_record *timing,
+			     bool success)
+{
+}
+
+static void
+memcomp_ctx_timing_account(struct memcomp_ctx_timing_record *timing)
+{
+}
+#endif
+
+static gfp_t memcomp_zs_gfp(bool fast)
+{
+	gfp_t gfp = __GFP_KSWAPD_RECLAIM | __GFP_NOWARN | __GFP_HIGHMEM |
+		    __GFP_MOVABLE;
+
+	/*
+	 * Match zram's two-stage allocation policy.  Keep direct reclaim
+	 * explicitly disabled for the first attempt instead of depending on
+	 * the caller already having PF_MEMALLOC set.  The second attempt is
+	 * restricted to background reclaim by memcomp_can_retry_alloc().
+	 */
+	if (!fast)
+		gfp |= __GFP_DIRECT_RECLAIM;
+
+	return gfp;
+}
+
+static int memcomp_zs_malloc(struct zs_pool *pool, unsigned int size,
+			     unsigned long *handle, bool allow_slow)
+{
+	unsigned long obj;
+	int ret;
+
+	obj = zs_malloc(pool, size, memcomp_zs_gfp(true));
+	if (!IS_ERR_VALUE(obj)) {
+		*handle = obj;
+		return 0;
+	}
+	ret = PTR_ERR((void *)obj);
+	if (ret != -ENOMEM)
+		memcomp_debug_inc(&memcomp_zs_other_fail);
+	memcomp_debug_inc(&memcomp_zs_fast_fail);
+
+	if (allow_slow) {
+		memcomp_debug_inc(&memcomp_zs_retries);
+		obj = zs_malloc(pool, size, memcomp_zs_gfp(false));
+		if (IS_ERR_VALUE(obj)) {
+			ret = PTR_ERR((void *)obj);
+			if (ret != -ENOMEM)
+				memcomp_debug_inc(&memcomp_zs_other_fail);
+			memcomp_debug_inc(&memcomp_zs_retry_fail);
+		} else {
+			*handle = obj;
+			ret = 0;
+			memcomp_debug_inc(&memcomp_zs_retry_success);
+		}
+	}
+	if (ret)
+		memcomp_debug_inc(&memcomp_zs_fail);
+
+	return ret;
+}
+
+static int
+memcomp_payload_zs_malloc(struct zs_pool *pool, unsigned int size,
+			  unsigned long *handle, bool allow_slow,
+			  struct memcomp_store_ctx *store)
+{
+	return memcomp_zs_malloc(pool, size, handle, allow_slow);
+}
+
+static int memcomp_decompress_payload(const void *src,
+				      unsigned int compressed_len,
+					  void *dst)
+{
+	struct memcomp_decomp_ctx *decomp_ctx;
+	unsigned int decompressed_len;
+	int ret;
+
+	if (compressed_len > PAGE_SIZE)
+		return -EIO;
+
+	if (compressed_len == PAGE_SIZE) {
+		memcpy(dst, src, PAGE_SIZE);
+		return 0;
+	}
+
+	local_lock(&memcomp_decomp_ctxs.lock);
+	decomp_ctx = this_cpu_ptr(&memcomp_decomp_ctxs);
+	decompressed_len = PAGE_SIZE;
+	ret = crypto_comp_decompress(decomp_ctx->tfm, src, compressed_len,
+				     dst, &decompressed_len);
+	local_unlock(&memcomp_decomp_ctxs.lock);
+
+	if (ret)
+		return ret;
+	if (decompressed_len != PAGE_SIZE)
+		return -EIO;
+	return 0;
+}
+
+/*
+ * Check whether a page is entirely filled with the same unsigned long
+ * value (common for zero pages and uninitialised BSS).  Borrowed from
+ * zram - same-filled pages are stored with no zsmalloc allocation.
+ */
+static bool page_same_filled(const void *addr, unsigned long *element)
+{
+	const unsigned long *page = addr;
+	const unsigned int last = PAGE_SIZE / sizeof(*page) - 1;
+	unsigned long val = page[0];
+	unsigned int pos;
+
+	/*
+	 * Probe the neighbour first, then the two ends: a page whose leading
+	 * words happen to repeat - a partially written buffer, a zeroed
+	 * leading field - would otherwise be walked all the way to its first
+	 * mismatch before being rejected.  The words probed here are then
+	 * known equal, so the loop skips them and the result is unchanged.
+	 */
+	if (val != page[1] || val != page[last] || val != page[last / 2])
+		return false;
+
+	for (pos = 2; pos < last; pos++) {
+		if (val != page[pos])
+			return false;
+	}
+	*element = val;
+	return true;
+}
+
+static unsigned int
+memcomp_comp_budget_limit(unsigned int online_cpus,
+			  unsigned int nr_contexts)
+{
+	unsigned int limit = online_cpus > 1 ? online_cpus - 1 : 1;
+
+	return min(limit, nr_contexts);
+}
+
+static unsigned int memcomp_current_comp_budget_limit(void)
+{
+	return memcomp_comp_budget_limit(num_online_cpus(),
+					     memcomp_nr_comp_ctxs);
+}
+
+static bool
+memcomp_comp_budget_available(const struct memcomp_comp_budget *budget,
+			      unsigned int limit)
+{
+	return budget->background_active < limit;
+}
+
+static bool
+memcomp_comp_budget_try_acquire(struct memcomp_comp_budget *budget,
+				unsigned int limit)
+{
+	if (!memcomp_comp_budget_available(budget, limit))
+		return false;
+
+	budget->active++;
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	budget->peak = max(budget->peak, budget->active);
+#endif
+	budget->background_active++;
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	budget->background_peak = max(budget->background_peak,
+				      budget->background_active);
+#endif
+	return true;
+}
+
+static bool
+memcomp_comp_budget_release(struct memcomp_comp_budget *budget)
+{
+	if (!budget->active)
+		return false;
+	if (!budget->background_active)
+		return false;
+	budget->background_active--;
+	budget->active--;
+	return true;
+}
+
+static bool memcomp_comp_budget_available_locked(void)
+{
+	lockdep_assert_held(&memcomp_comp_ctx_lock);
+	return memcomp_comp_budget_available(&memcomp_comp_budget,
+		memcomp_current_comp_budget_limit());
+}
+
+static bool memcomp_comp_budget_get_locked(void)
+{
+	lockdep_assert_held(&memcomp_comp_ctx_lock);
+	return memcomp_comp_budget_try_acquire(&memcomp_comp_budget,
+		memcomp_current_comp_budget_limit());
+}
+
+static bool memcomp_comp_budget_put_locked(void)
+{
+	lockdep_assert_held(&memcomp_comp_ctx_lock);
+	return memcomp_comp_budget_release(&memcomp_comp_budget);
+}
+
+static int memcomp_comp_ctx_claim(unsigned long *free_mask,
+				  unsigned long eligible_mask)
+{
+	unsigned long available = *free_mask & eligible_mask;
+	unsigned int idx;
+
+	if (!available)
+		return -EBUSY;
+
+	idx = __ffs(available);
+	__clear_bit(idx, free_mask);
+	return idx;
+}
+
+static bool memcomp_comp_ctx_release(unsigned long *free_mask,
+				     unsigned int idx)
+{
+	if (test_bit(idx, free_mask))
+		return false;
+
+	__set_bit(idx, free_mask);
+	return true;
+}
+
+static enum memcomp_comp_ctx_miss
+memcomp_comp_ctx_classify(unsigned long free_mask,
+			  unsigned long foreground_mask,
+			      unsigned long all_mask)
+{
+	if (free_mask & foreground_mask)
+		return MEMCOMP_COMP_CTX_AVAILABLE;
+	if (free_mask & all_mask & ~foreground_mask)
+		return MEMCOMP_COMP_CTX_RESERVED_FREE;
+	return MEMCOMP_COMP_CTX_ALL_BUSY;
+}
+
+static enum memcomp_comp_ctx_miss
+memcomp_comp_ctx_borrow_decision(unsigned int borrowed,
+				 unsigned int limit,
+				     unsigned int waiters)
+{
+	if (waiters)
+		return MEMCOMP_COMP_CTX_BACKGROUND_WAITERS;
+	if (borrowed >= limit)
+		return MEMCOMP_COMP_CTX_BORROW_LIMIT;
+	return MEMCOMP_COMP_CTX_AVAILABLE;
+}
+
+static enum memcomp_comp_ctx_miss
+memcomp_comp_ctx_foreground_status(unsigned long free_mask,
+				   unsigned long foreground_mask,
+				       unsigned long all_mask,
+				       unsigned int borrowed,
+				       unsigned int borrow_limit,
+				       unsigned int waiters)
+{
+	unsigned long borrow_mask = all_mask & ~foreground_mask;
+
+	if (free_mask & foreground_mask)
+		return MEMCOMP_COMP_CTX_AVAILABLE;
+	if (free_mask & borrow_mask)
+		return memcomp_comp_ctx_borrow_decision(borrowed,
+							    borrow_limit,
+							    waiters);
+	return memcomp_comp_ctx_classify(free_mask, foreground_mask,
+					     all_mask);
+}
+
+static enum memcomp_comp_ctx_miss
+memcomp_comp_ctx_foreground_status_locked(void)
+{
+	unsigned long all = memcomp_comp_ctx_all;
+	unsigned long foreground = memcomp_comp_ctx_foreground;
+	unsigned long free = memcomp_comp_ctx_free;
+	unsigned int borrowed = memcomp_comp_ctx_borrowed_active;
+	unsigned int borrow_limit = memcomp_nr_borrowable_comp_ctxs;
+	unsigned int waiters = memcomp_comp_ctx_waiters;
+
+	lockdep_assert_held(&memcomp_comp_ctx_lock);
+	return memcomp_comp_ctx_foreground_status(free, foreground, all,
+						      borrowed, borrow_limit,
+						      waiters);
+}
+
+static void
+memcomp_account_reclaim_ctx_miss(enum memcomp_comp_ctx_miss miss,
+				 unsigned int nr_pages)
+{
+	switch (miss) {
+	case MEMCOMP_COMP_CTX_BUDGET:
+		memcomp_debug_add(nr_pages,
+				  &memcomp_reclaim_ctx_budget_pages);
+		break;
+	case MEMCOMP_COMP_CTX_BORROW_LIMIT:
+		memcomp_debug_add(nr_pages,
+				  &memcomp_reclaim_ctx_borrow_limit_pages);
+		memcomp_debug_add(nr_pages,
+				  &memcomp_reclaim_ctx_busy_reserved_free_pages);
+		break;
+	case MEMCOMP_COMP_CTX_BACKGROUND_WAITERS:
+		memcomp_debug_add(nr_pages,
+				  &memcomp_reclaim_ctx_borrow_waiter_pages);
+		memcomp_debug_add(nr_pages,
+				  &memcomp_reclaim_ctx_busy_reserved_free_pages);
+		break;
+	case MEMCOMP_COMP_CTX_RESERVED_FREE:
+		memcomp_debug_add(nr_pages,
+				  &memcomp_reclaim_ctx_busy_reserved_free_pages);
+		break;
+	case MEMCOMP_COMP_CTX_ALL_BUSY:
+		memcomp_debug_add(nr_pages,
+				  &memcomp_reclaim_ctx_busy_all_busy_pages);
+		break;
+	case MEMCOMP_COMP_CTX_AVAILABLE:
+		WARN_ON_ONCE(1);
+		return;
+	}
+}
+
+static bool
+memcomp_reclaim_ctx_precheck_result(unsigned int nr_pages,
+				    enum memcomp_comp_ctx_miss miss)
+{
+	if (miss == MEMCOMP_COMP_CTX_AVAILABLE)
+		return true;
+
+	memcomp_debug_inc(&memcomp_ctx_busy);
+	memcomp_debug_inc(&memcomp_reclaim_ctx_early_reject);
+	memcomp_debug_add(nr_pages,
+			  &memcomp_reclaim_ctx_early_reject_pages);
+	if (miss == MEMCOMP_COMP_CTX_BUDGET) {
+		memcomp_debug_inc(&memcomp_reclaim_ctx_budget_reject);
+		memcomp_debug_add(nr_pages,
+				  &memcomp_reclaim_ctx_budget_reject_pages);
+	}
+	memcomp_account_reclaim_ctx_miss(miss, nr_pages);
+	memcomp_account_anon_store(false, nr_pages);
+	return false;
+}
+
+bool memcomp_reclaim_ctx_precheck(unsigned int nr_pages,
+				  enum memcomp_reclaim_source source)
+{
+	enum memcomp_comp_ctx_miss miss;
+	unsigned long flags;
+
+	if (WARN_ON_ONCE((unsigned int)source >=
+			 MEMCOMP_RECLAIM_SOURCE_NR))
+		source = MEMCOMP_RECLAIM_DIRECT;
+	if (source != MEMCOMP_RECLAIM_DIRECT)
+		return true;
+
+	spin_lock_irqsave(&memcomp_comp_ctx_lock, flags);
+	miss = memcomp_comp_ctx_foreground_status_locked();
+	spin_unlock_irqrestore(&memcomp_comp_ctx_lock, flags);
+	return memcomp_reclaim_ctx_precheck_result(nr_pages, miss);
+}
+
+static void memcomp_comp_ctx_waiter_done(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&memcomp_comp_ctx_lock, flags);
+	if (WARN_ON_ONCE(!memcomp_comp_ctx_waiters)) {
+		spin_unlock_irqrestore(&memcomp_comp_ctx_lock, flags);
+		return;
+	}
+	memcomp_comp_ctx_waiters--;
+	spin_unlock_irqrestore(&memcomp_comp_ctx_lock, flags);
+}
+
+static bool memcomp_comp_ctx_wait_ready(void)
+{
+	unsigned long flags;
+	bool ready;
+
+	spin_lock_irqsave(&memcomp_comp_ctx_lock, flags);
+	ready = memcomp_comp_ctx_free &&
+		memcomp_comp_budget_available_locked();
+	spin_unlock_irqrestore(&memcomp_comp_ctx_lock, flags);
+	return ready;
+}
+
+static void
+memcomp_comp_ctx_unclaim_locked(unsigned int idx, bool borrowed,
+				bool budget_acquired)
+{
+	lockdep_assert_held(&memcomp_comp_ctx_lock);
+	if (borrowed) {
+		WARN_ON_ONCE(!test_bit(idx, &memcomp_comp_ctx_borrowed));
+		__clear_bit(idx, &memcomp_comp_ctx_borrowed);
+		if (!WARN_ON_ONCE(!memcomp_comp_ctx_borrowed_active))
+			memcomp_comp_ctx_borrowed_active--;
+	} else {
+		WARN_ON_ONCE(test_bit(idx, &memcomp_comp_ctx_borrowed));
+	}
+	if (budget_acquired)
+		WARN_ON_ONCE(!memcomp_comp_budget_put_locked());
+	WARN_ON_ONCE(!memcomp_comp_ctx_release(&memcomp_comp_ctx_free,
+					       idx));
+}
+
+static struct memcomp_reclaim_ctx *
+memcomp_try_get_comp_ctx(bool background, bool allow_borrow,
+			 enum memcomp_comp_ctx_miss *miss,
+			     bool *registered_waiter)
+{
+	struct memcomp_reclaim_ctx *ctx;
+	unsigned long *freep = &memcomp_comp_ctx_free;
+	unsigned long all_mask;
+	unsigned long borrow_mask;
+	unsigned long eligible;
+	unsigned long foreground_mask;
+	unsigned long free_mask;
+	unsigned long flags;
+	unsigned int borrowed_active;
+	unsigned int borrow_limit;
+	unsigned int waiters;
+	bool borrowed = false;
+	bool budget_acquired;
+	int idx;
+
+	eligible = background ? memcomp_comp_ctx_all :
+				memcomp_comp_ctx_foreground;
+	spin_lock_irqsave(&memcomp_comp_ctx_lock, flags);
+	if (background && !memcomp_comp_budget_available_locked()) {
+		if (miss)
+			*miss = MEMCOMP_COMP_CTX_BUDGET;
+		idx = -EBUSY;
+		goto unavailable;
+	}
+
+	idx = memcomp_comp_ctx_claim(freep, eligible);
+	if (idx < 0 && allow_borrow) {
+		borrow_mask = memcomp_comp_ctx_all &
+			      ~memcomp_comp_ctx_foreground;
+		if (memcomp_comp_ctx_free & borrow_mask) {
+			borrowed_active = memcomp_comp_ctx_borrowed_active;
+			borrow_limit = memcomp_nr_borrowable_comp_ctxs;
+			waiters = memcomp_comp_ctx_waiters;
+			*miss = memcomp_comp_ctx_borrow_decision(borrowed_active,
+								 borrow_limit,
+								     waiters);
+			if (*miss == MEMCOMP_COMP_CTX_AVAILABLE) {
+				idx = memcomp_comp_ctx_claim(freep, borrow_mask);
+				if (idx >= 0)
+					borrowed = true;
+			}
+		}
+	}
+	if (idx < 0 && miss) {
+		if (background) {
+			*miss = MEMCOMP_COMP_CTX_ALL_BUSY;
+		} else if (*miss == MEMCOMP_COMP_CTX_AVAILABLE) {
+			free_mask = memcomp_comp_ctx_free;
+			foreground_mask = memcomp_comp_ctx_foreground;
+			all_mask = memcomp_comp_ctx_all;
+			*miss = memcomp_comp_ctx_classify(free_mask,
+							  foreground_mask,
+							      all_mask);
+		}
+	}
+	budget_acquired = false;
+	if (idx >= 0 && background)
+		budget_acquired = memcomp_comp_budget_get_locked();
+	if (idx >= 0 && background && WARN_ON_ONCE(!budget_acquired)) {
+		memcomp_comp_ctx_unclaim_locked(idx, false, false);
+		if (miss)
+			*miss = MEMCOMP_COMP_CTX_BUDGET;
+		idx = -EBUSY;
+	}
+	if (idx >= 0 && borrowed) {
+		__set_bit(idx, &memcomp_comp_ctx_borrowed);
+		memcomp_comp_ctx_borrowed_active++;
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+		memcomp_comp_ctx_borrowed_peak =
+			max(memcomp_comp_ctx_borrowed_peak,
+			    memcomp_comp_ctx_borrowed_active);
+#endif
+	}
+
+unavailable:
+	if (idx < 0 && background && !*registered_waiter) {
+		memcomp_comp_ctx_waiters++;
+		*registered_waiter = true;
+	}
+	if (idx >= 0 && *registered_waiter) {
+		WARN_ON_ONCE(!memcomp_comp_ctx_waiters);
+		if (memcomp_comp_ctx_waiters)
+			memcomp_comp_ctx_waiters--;
+		*registered_waiter = false;
+	}
+	spin_unlock_irqrestore(&memcomp_comp_ctx_lock, flags);
+	if (idx < 0)
+		return NULL;
+
+	ctx = &memcomp_comp_ctxs[idx];
+	/* The free bit is published only after the previous owner unlocks. */
+	if (background) {
+		mutex_lock(&ctx->lock);
+	} else if (WARN_ON_ONCE(!mutex_trylock(&ctx->lock))) {
+		spin_lock_irqsave(&memcomp_comp_ctx_lock, flags);
+		memcomp_comp_ctx_unclaim_locked(idx, borrowed, false);
+		spin_unlock_irqrestore(&memcomp_comp_ctx_lock, flags);
+		if (miss)
+			*miss = MEMCOMP_COMP_CTX_ALL_BUSY;
+		wake_up(&memcomp_comp_ctx_wait);
+		return NULL;
+	}
+	ctx->borrowed = borrowed;
+	ctx->background = background;
+	ctx->direct_staging = false;
+	return ctx;
+}
+
+/*
+ * Lease a compression context.  PF_MEMALLOC kswapd may use
+ * every context and wait for both a context and an execution-budget slot.
+ * Foreground reclaim may borrow a bounded number of reserved contexts when
+ * no background waiter exists, but never waits.  BEST_EFFORT shmem stores
+ * only try non-reserved contexts.  Admission remains held until ctx_put().
+ * A direct single-page zstd store may transfer its output to a staging slot
+ * and put the context immediately after compression; every other store keeps
+ * the context until its caller finishes.  Either way, an unmapped folio keeps
+ * a stable destination through its payload snapshot.
+ */
+static struct memcomp_reclaim_ctx *
+memcomp_get_comp_ctx(enum memcomp_payload_mode mode,
+		     enum memcomp_comp_ctx_miss *miss,
+			 enum memcomp_reclaim_source source)
+{
+	struct memcomp_reclaim_ctx *ctx;
+	bool allow_borrow;
+	bool background;
+	bool can_retry;
+	bool registered_waiter = false;
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	u64 wait_start_ns;
+#endif
+	int ret;
+
+	if (miss)
+		*miss = MEMCOMP_COMP_CTX_AVAILABLE;
+
+	can_retry = memcomp_can_retry_alloc();
+	background = memcomp_comp_ctx_background(mode, source, can_retry);
+	if (mode != MEMCOMP_PAYLOAD_BEST_EFFORT &&
+	    source != MEMCOMP_RECLAIM_DIRECT)
+		WARN_ON_ONCE(!can_retry);
+	allow_borrow = mode == MEMCOMP_PAYLOAD_MUST_SUCCEED &&
+		       !background && miss;
+	for (;;) {
+		ctx = memcomp_try_get_comp_ctx(background, allow_borrow, miss,
+					       &registered_waiter);
+		if (ctx)
+			return ctx;
+		if (!background)
+			break;
+		WARN_ON_ONCE(!registered_waiter);
+		if (miss && *miss == MEMCOMP_COMP_CTX_BUDGET)
+			memcomp_debug_inc(&memcomp_comp_budget_waits[source]);
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+		memcomp_ctx_timing_wait_start(source);
+		wait_start_ns = ktime_get_ns();
+#endif
+		ret = wait_event_freezable_exclusive(memcomp_comp_ctx_wait,
+						     memcomp_comp_ctx_wait_ready() ||
+						     kthread_should_stop());
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+		memcomp_ctx_timing_wait_end(wait_start_ns, source);
+#endif
+		if (ret || kthread_should_stop()) {
+			memcomp_comp_ctx_waiter_done();
+			return NULL;
+		}
+	}
+
+	/* Only the foreground path breaks out; background either wins or waits. */
+	memcomp_debug_inc(&memcomp_ctx_busy);
+	return NULL;
+}
+
+static void memcomp_put_comp_ctx(struct memcomp_reclaim_ctx *ctx)
+{
+	unsigned long flags;
+	unsigned int waiters;
+	unsigned int idx;
+	bool background;
+	bool borrowed;
+
+	idx = ctx - memcomp_comp_ctxs;
+	if (WARN_ON_ONCE(idx >= memcomp_nr_comp_ctxs))
+		return;
+	/*
+	 * We hold the lease, so our own bit is clear and stays clear until we
+	 * publish it below; only the other bits of the word need the lock.
+	 * The test itself must stay: releasing ctx->lock for a context we no
+	 * longer own would unlock a mutex held by another task.
+	 */
+	if (WARN_ON_ONCE(test_bit(idx, &memcomp_comp_ctx_free)))
+		return;
+
+	borrowed = ctx->borrowed;
+	background = ctx->background;
+	ctx->borrowed = false;
+	ctx->background = false;
+	ctx->direct_staging = false;
+	/*
+	 * Unlock before publishing the free bit: a claimer trylocks ctx->lock
+	 * as soon as it sees the bit, and expects the previous owner to be
+	 * gone.
+	 */
+	mutex_unlock(&ctx->lock);
+	spin_lock_irqsave(&memcomp_comp_ctx_lock, flags);
+	memcomp_comp_ctx_unclaim_locked(idx, borrowed, background);
+	/*
+	 * A waiter registers itself in the same critical section in which its
+	 * claim failed, and only then sleeps, so reading the count here - in
+	 * the critical section that makes a context available again - cannot
+	 * miss one.  With no waiter there is nobody to wake and the wait queue
+	 * head's lock stays off this path entirely.
+	 */
+	waiters = memcomp_comp_ctx_waiters;
+	spin_unlock_irqrestore(&memcomp_comp_ctx_lock, flags);
+	if (waiters)
+		wake_up(&memcomp_comp_ctx_wait);
+}
+
+struct memcomp_reclaim_ctx *
+memcomp_reclaim_ctx_get(unsigned int nr_pages,
+			enum memcomp_reclaim_source source)
+{
+	enum memcomp_payload_mode mode = MEMCOMP_PAYLOAD_MUST_SUCCEED;
+	struct memcomp_reclaim_ctx *ctx;
+	enum memcomp_comp_ctx_miss miss;
+	const char *driver;
+
+	if (WARN_ON_ONCE((unsigned int)source >=
+			 MEMCOMP_RECLAIM_SOURCE_NR))
+		source = MEMCOMP_RECLAIM_DIRECT;
+	ctx = memcomp_get_comp_ctx(mode, &miss, source);
+	if (ctx) {
+		driver = crypto_tfm_alg_driver_name(crypto_comp_tfm(ctx->tfm));
+		ctx->direct_staging =
+			memcomp_staging_policy(mode, source, nr_pages,
+					       driver);
+		if (ctx->borrowed)
+			memcomp_debug_add(nr_pages,
+					  &memcomp_reclaim_ctx_borrow_pages);
+		memcomp_ctx_timing_start(ctx, nr_pages, source);
+		return ctx;
+	}
+
+	if (source == MEMCOMP_RECLAIM_DIRECT &&
+	    miss == MEMCOMP_COMP_CTX_BUDGET) {
+		memcomp_debug_inc(&memcomp_reclaim_ctx_budget_reject);
+		memcomp_debug_add(nr_pages,
+				  &memcomp_reclaim_ctx_budget_reject_pages);
+	}
+	memcomp_account_reclaim_ctx_miss(miss, nr_pages);
+	memcomp_account_anon_store(false, nr_pages);
+	return NULL;
+}
+
+void memcomp_reclaim_ctx_put(struct memcomp_reclaim_ctx *ctx)
+{
+	if (!ctx)
+		return;
+	lockdep_assert_held(&ctx->lock);
+	memcomp_ctx_timing_account(&ctx->timing);
+	memcomp_put_comp_ctx(ctx);
+}
+
+static int memcomp_alloc_raw_payload(u8 pool_idx, const void *src,
+				     unsigned int src_len,
+					 unsigned int *length,
+					 unsigned long *handle,
+					 bool allow_slow,
+					  struct memcomp_store_ctx *store)
+{
+	struct zs_pool *pool = memcomp_pools[pool_idx];
+	void *dst;
+	int ret;
+
+	ret = memcomp_payload_zs_malloc(pool, src_len, handle, allow_slow,
+					store);
+	if (ret)
+		return ret;
+
+	dst = zs_map_object(pool, *handle, ZS_MM_WO);
+	if (!dst) {
+		zs_free(pool, *handle);
+		return -EIO;
+	}
+
+	memcpy(dst, src, src_len);
+	zs_unmap_object(pool, *handle);
+
+	*length = src_len;
+	return 0;
+}
+
+enum memcomp_raw_reason {
+	MEMCOMP_RAW_NONE,
+	MEMCOMP_RAW_HUGE_CLASS,
+	MEMCOMP_RAW_GE_PAGE,
+};
+
+static enum memcomp_raw_reason
+memcomp_payload_raw_reason(unsigned int compressed_len,
+			   unsigned int src_len,
+			       unsigned int huge_class_size)
+{
+	if (compressed_len >= src_len)
+		return MEMCOMP_RAW_GE_PAGE;
+	if (huge_class_size && compressed_len >= huge_class_size)
+		return MEMCOMP_RAW_HUGE_CLASS;
+	return MEMCOMP_RAW_NONE;
+}
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static unsigned int
+memcomp_raw_payload_count(const unsigned int *lengths,
+			  unsigned int nr_pages)
+{
+	unsigned int raw = 0;
+	unsigned int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		if (lengths[i] == PAGE_SIZE)
+			raw++;
+	}
+
+	return raw;
+}
+#endif
+
+/*
+ * A raw object can still make progress as part of a larger folio when the
+ * other payloads save enough space.  Require at least one page of aggregate
+ * payload headroom before replacing the resident folio.  zsmalloc class
+ * rounding is measured separately by the device tests; pool-wide size deltas
+ * cannot be a correctness check here because stores run concurrently.
+ */
+static bool
+memcomp_payloads_net_reclaimable(const unsigned int *lengths,
+				 unsigned int nr_pages)
+{
+	u64 total = 0;
+	unsigned int raw = 0;
+	unsigned int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		if (lengths[i] > PAGE_SIZE)
+			return false;
+		if (lengths[i] == PAGE_SIZE)
+			raw++;
+		total += lengths[i];
+	}
+	if (!raw)
+		return true;
+	if (nr_pages < 2)
+		return false;
+
+	return total <= (u64)(nr_pages - 1) * PAGE_SIZE;
+}
+
+/*
+ * Compress @src and place the result in zsmalloc, or detect a same-fill
+ * page.  On success: *length == 0 means same-fill with the pattern in
+ * *handle; otherwise the handle and pool index name the payload.
+ */
+static void
+memcomp_detach_reclaim_ctx(struct memcomp_reclaim_ctx **ctxp,
+			   struct memcomp_direct_staging *staging)
+{
+	struct memcomp_reclaim_ctx *ctx = *ctxp;
+
+	lockdep_assert_preemption_disabled();
+	lockdep_assert_held(&ctx->lock);
+	staging->timing = ctx->timing;
+	ctx->timing.timing_active = false;
+	*ctxp = NULL;
+	memcomp_put_comp_ctx(ctx);
+	if (staging->timing.timing_active)
+		staging->timing.timing_lease_end_ns = ktime_get_ns();
+	memcomp_debug_inc(&memcomp_direct_staging_detach);
+}
+
+/*
+ * A compressor that cannot fit a page into less than the page - a hardware
+ * engine stopping at its output limit, say - may say so with -E2BIG or
+ * -ENOSPC instead of producing that output.  Take it as the payload a CPU
+ * compressor would have produced for such a page: one at least a page long,
+ * which is stored raw where the caller allows it and refused where it does
+ * not.
+ */
+static int memcomp_compress_result(int ret, unsigned int *dst_len,
+				   unsigned int src_len)
+{
+	if (ret != -E2BIG && ret != -ENOSPC)
+		return ret;
+	*dst_len = src_len;
+	return 0;
+}
+
+static int
+memcomp_prepare_payload_locked(struct memcomp_reclaim_ctx **ctxp,
+			       const void *src, unsigned int src_len,
+				   unsigned int *length,
+				   unsigned long *handle, u8 *pool_idx,
+				   bool allow_provisional_raw,
+				   struct memcomp_store_ctx *store)
+{
+	struct memcomp_compress_timing_stamp compress_timing;
+	struct memcomp_direct_staging *staging = NULL;
+	struct memcomp_reclaim_ctx *ctx = *ctxp;
+	struct memcomp_ctx_timing_record *timing = &ctx->timing;
+	struct zs_pool *pool;
+	enum memcomp_compress_timing_outcome timing_outcome;
+	enum memcomp_raw_reason raw_reason = MEMCOMP_RAW_NONE;
+	void *compressed;
+	unsigned long element;
+	unsigned int huge_class_size;
+	unsigned int dst_len;
+	u64 timing_start;
+	u8 target;
+	bool allow_slow;
+	void *dst;
+	int ret;
+
+	lockdep_assert_held(&ctx->lock);
+
+	if (page_same_filled(src, &element)) {
+		*length = 0;
+		*handle = element;
+		return 0;
+	}
+
+	target = memcomp_select_pool_idx();
+	pool = memcomp_pools[target];
+	huge_class_size = zs_huge_class_size(pool);
+	allow_slow = ctx->background;
+	if (store && ctx->direct_staging) {
+		WARN_ON_ONCE(store->staging);
+		staging = memcomp_direct_staging_try_get();
+		store->staging = staging;
+	}
+	compressed = staging ? staging->dst : ctx->dst;
+
+	dst_len = MEMCOMP_MAX_COMPRESSED_SIZE;
+	if (staging)
+		preempt_disable();
+	compress_timing = memcomp_compress_timing_start(timing);
+		ret = crypto_comp_compress(ctx->tfm, src, src_len,
+					   compressed, &dst_len);
+	ret = memcomp_compress_result(ret, &dst_len, src_len);
+	if (!ret)
+		raw_reason = memcomp_payload_raw_reason(dst_len, src_len,
+							huge_class_size);
+	/* Nothing after this point is compression. */
+	compress_timing =
+		memcomp_compress_timing_end(timing, compress_timing);
+	if (ret)
+		timing_outcome = MEMCOMP_COMPRESS_TIMING_ERROR;
+	else if (raw_reason == MEMCOMP_RAW_HUGE_CLASS)
+		timing_outcome = MEMCOMP_COMPRESS_TIMING_RAW_HUGE;
+	else if (raw_reason == MEMCOMP_RAW_GE_PAGE)
+		timing_outcome = MEMCOMP_COMPRESS_TIMING_RAW_GE_PAGE;
+	else
+		timing_outcome = MEMCOMP_COMPRESS_TIMING_COMPRESSIBLE;
+	memcomp_compress_timing_account(timing, compress_timing,
+					timing_outcome);
+	if (staging) {
+		memcomp_detach_reclaim_ctx(ctxp, staging);
+		timing = &staging->timing;
+		preempt_enable();
+	}
+	if (ret) {
+		memcomp_debug_inc(&memcomp_compress_fail);
+		return ret;
+	}
+	if (raw_reason != MEMCOMP_RAW_NONE) {
+		if (raw_reason == MEMCOMP_RAW_HUGE_CLASS)
+			memcomp_debug_inc(&memcomp_raw_candidate_huge);
+		else
+			memcomp_debug_inc(&memcomp_raw_candidate_ge_page);
+		if (!allow_provisional_raw) {
+			if (raw_reason == MEMCOMP_RAW_HUGE_CLASS)
+				memcomp_debug_inc(&memcomp_raw_reject_huge);
+			else
+				memcomp_debug_inc(&memcomp_raw_reject_ge_page);
+			return -E2BIG;
+		}
+		/* zram stores incompressible pages in its PAGE_SIZE class. */
+		timing_start = memcomp_ctx_timing_phase_start(timing);
+		ret = memcomp_alloc_raw_payload(target, src, src_len,
+						length, handle,
+						    allow_slow, store);
+		memcomp_ctx_timing_phase_end(timing, timing_start,
+					     &timing->timing_zs_ns);
+		if (!ret)
+			*pool_idx = target;
+		return ret;
+	}
+
+	timing_start = memcomp_ctx_timing_phase_start(timing);
+	ret = memcomp_payload_zs_malloc(pool, dst_len, handle, allow_slow,
+					store);
+	if (ret) {
+		if (!allow_provisional_raw) {
+			memcomp_debug_inc(&memcomp_raw_reject_zs_fallback);
+			memcomp_ctx_timing_phase_end(timing, timing_start,
+						     &timing->timing_zs_ns);
+			return ret;
+		}
+		/*
+		 * A small-object class can need a multi-page zspage even when
+		 * the one-page raw class can still grow.  Keep this fallback
+		 * fast-only: background reclaim already paid for the slow
+		 * compressed allocation, and foreground reclaim must not stall.
+		 */
+		ret = memcomp_alloc_raw_payload(target, src, src_len,
+						length, handle, false,
+						    store);
+		memcomp_ctx_timing_phase_end(timing, timing_start,
+					     &timing->timing_zs_ns);
+		if (!ret)
+			*pool_idx = target;
+		return ret;
+	}
+
+	dst = zs_map_object(pool, *handle, ZS_MM_WO);
+	if (!dst) {
+		zs_free(pool, *handle);
+		memcomp_ctx_timing_phase_end(timing, timing_start,
+					     &timing->timing_zs_ns);
+		return -EIO;
+	}
+	memcpy(dst, compressed, dst_len);
+	zs_unmap_object(pool, *handle);
+	memcomp_ctx_timing_phase_end(timing, timing_start,
+				     &timing->timing_zs_ns);
+
+	*length = dst_len;
+	*pool_idx = target;
+	return 0;
+}
+
+static __always_inline int
+memcomp_arch_prepare_to_swap(struct folio *folio)
+{
+	return arch_prepare_to_swap(folio);
+}
+
+/* Allocate @nr_pages consecutive tokens, skipping fragmented free ranges. */
+
+/*
+ * Core store - compress @nr_pages pages and insert them into the global
+ * entries xarray under consecutive tokens.  Returns 0 with *token set
+ * to the first id.
+ */
+
+/*
+ * Reserve tokens for @folio before it is unmapped.  The entries stay in
+ * MC_PENDING with a reference on the resident folio, so faults arriving
+ * between unmap and the payload store can map the original pages back.
+ */
+
+#include "memcomp/anon_store.h"
+
+/*
+ * Fill an existing MC_PENDING span after unmap while keeping tokens stable.
+ * @held are the span's entries if the caller has them and holds a reference
+ * on each, NULL to have them looked up here.
+ */
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
+unsigned int memcomp_pte_batch(pte_t *start_pte, unsigned int max_nr)
+{
+	pte_t first_pte;
+	swp_entry_t first_entry;
+	unsigned int i;
+
+	if (!max_nr)
+		return 0;
+
+	first_pte = ptep_get(start_pte);
+	if (!is_swap_pte(first_pte))
+		return 0;
+
+	first_entry = pte_to_swp_entry(first_pte);
+	if (!is_memcomp_entry(first_entry))
+		return 0;
+
+	for (i = 0; i < max_nr; i++) {
+		pte_t pte;
+		swp_entry_t entry;
+
+		pte = ptep_get(start_pte + i);
+		if (!is_swap_pte(pte))
+			break;
+
+		entry = pte_to_swp_entry(pte);
+		if (!is_memcomp_entry(entry))
+			break;
+		if (swp_offset(entry) != (swp_offset(first_entry) ?
+					  swp_offset(first_entry) + i : 0))
+			break;
+		if (pte_swp_exclusive(pte) != pte_swp_exclusive(first_pte))
+			break;
+		if (pte_swp_soft_dirty(pte) != pte_swp_soft_dirty(first_pte))
+			break;
+		if (pte_swp_uffd_wp(pte) != pte_swp_uffd_wp(first_pte))
+			break;
+	}
+
+	return i;
+}
+
+/*
+ * Use as a branch condition: a successful map retains both its PTE spinlock
+ * and the RCU read lock from __pte_offset_map(); NULL retains neither.
+ * Keep both real conditional contexts visible here rather than returning
+ * them through pte_offset_map_lock()'s inline wrapper.
+ */
+#define memcomp_pte_map_lock(mm, pmd, address, ptep, ptlp) \
+	({ \
+		spinlock_t **__ptlp = (ptlp); \
+		__cond_lock(RCU, __cond_lock(*__ptlp, \
+			*(ptep) = __pte_offset_map_lock((mm), (pmd), \
+						     (address), __ptlp))); \
+	})
+
+#include "memcomp/zero_load.h"
+
+static vm_fault_t memcomp_fault_sigbus_or_retry(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+
+	if (!memcomp_pte_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
+				  &vmf->pte, &vmf->ptl))
+		return 0;
+	if (!pte_same(ptep_get(vmf->pte), vmf->orig_pte)) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		vmf->pte = NULL;
+		return 0;
+	}
+
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	vmf->pte = NULL;
+	return VM_FAULT_SIGBUS;
+}
+
+/*
+ * Map @page of the locked @folio at @address, where @ptep, locked, holds
+ * @orig_pte, a resident token for it.  The caller has taken the folio
+ * reference the mapping needs and drops the token's entry reference.
+ * Returns whether the PTE was made dirty for a @write.
+ */
+static bool memcomp_map_resident(struct vm_area_struct *vma,
+				 unsigned long address, pte_t *ptep,
+				     pte_t orig_pte, struct folio *folio,
+				     struct page *page, bool write)
+{
+	bool exclusive = pte_swp_exclusive(orig_pte);
+	rmap_t rmap_flags = RMAP_NONE;
+	bool dirty = false;
+	pte_t pte;
+
+	pte = mk_pte(page, vma->vm_page_prot);
+	if (pte_swp_soft_dirty(orig_pte))
+		pte = pte_mksoft_dirty(pte);
+	if (pte_swp_uffd_wp(orig_pte))
+		pte = pte_mkuffd_wp(pte);
+	if (exclusive &&
+	    (vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
+	    !pte_needs_soft_dirty_wp(vma, pte)) {
+		pte = pte_mkwrite(pte, vma);
+		if (write) {
+			pte = pte_mkdirty(pte);
+			dirty = true;
+		}
+	}
+	if (exclusive)
+		rmap_flags = RMAP_EXCLUSIVE;
+
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
+	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -1);
+	flush_icache_pages(vma, page, 1);
+	folio_add_anon_rmap_pte(folio, page, vma, address, rmap_flags);
+	set_pte_at(vma->vm_mm, address, ptep, pte);
+	arch_do_swap_page_nr(vma->vm_mm, vma, address, pte, pte, 1);
+	update_mmu_cache(vma, address, ptep);
+	return dirty;
+}
+
+/*
+ * Fast path for the pending window: reclaim reserved the token but has
+ * not stored the payload yet, so the original folio is still resident.
+ * Map it back instead of decompressing.
+ */
+#include "memcomp/resident.h"
+#include "memcomp/fault.h"
+#include "memcomp/zero_convert.h"
+
+/*
+ * Every token but a resident pending one is position independent: loads
+ * allocate a fresh folio wherever the PTE is found.  A resident token is
+ * not, because the fault maps the original folio back and that folio's
+ * anon rmap still names the address the token was unmapped from.  Moving
+ * such a PTE elsewhere would map the folio where rmap cannot find it.
+ *
+ * Return the lookup reference to the caller.  Keeping it across a PTE
+ * retry prevents the token ID from being reused for a different entry.
+ * A token never re-enters MC_PENDING, so a false answer stays valid for as
+ * long as the caller holds this reference and a PTE that names the token.
+ */
+
+/*
+ * Map a resident token's folio back at the address in @vmf, without the
+ * decompression fallback memcomp_load() would take once the window has
+ * closed.  Returns -EFAULT if the PTE still names a token that is gone and 0
+ * otherwise; the caller re-reads the PTE either way.  May sleep on the folio
+ * lock.
+ */
+
+/*
+ * Map the locked @folio back wherever try_to_unmap() left one of the resident
+ * tokens of its span at @token, the way remove_migration_ptes() puts back a
+ * folio that failed to migrate.  Each PTE restored drops its token's
+ * reference.  The caller keeps the folio's anon_vma alive, as rmap walks of
+ * a folio that is no longer mapped must.
+ *
+ * Tokens only get into PTEs by try_to_unmap(), which needs the folio lock,
+ * and by fork() copying one that is already in a PTE.  The walk visits a
+ * parent's VMAs before a child linked to the same anon_vma, as migration
+ * relies on too, so a token fork copies meanwhile is found in the child.
+ * Returns how many PTEs it mapped back.
+ */
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+
+#endif
+
+/* Check if a page-cache xa_value is a memcomp entry. */
+
+/*
+ * Shmem/tmpfs variant: compress a folio and return the token.  This does not
+ * leave a token in folio->swap; the caller (shmem_writepage) stores it in the
+ * page-cache xarray via shmem_delete_from_page_cache().
+ */
+
+/*
+ * Shmem/tmpfs swapin: pin the entry, decompress into a pre-allocated
+ * folio, then commit (after the page-cache shadow was replaced) or
+ * abort.  The caller handles locking, page-cache insertion and rmap.
+ */
+/* Explicit zero transport: no sentinel guard or owner consumption. */
+
+/* Fill an existing token span after every mapping has been removed. */
+
+#include "memcomp/anon_folio.h"
+
+static bool memcomp_reserve_nr_pages_valid(unsigned int nr_pages)
+{
+	return nr_pages && nr_pages <= MEMCOMP_MAX_COMPRESS_PAGES;
+}
+
+bool memcomp_reserve_eligible(struct folio *folio)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+
+	if (!folio_test_locked(folio))
+		return false;
+	if (!folio_test_anon(folio) || !folio_test_swapbacked(folio))
+		return false;
+	if (folio_test_mlocked(folio) || folio_test_ksm(folio) ||
+	    folio_mapping(folio))
+		return false;
+	if (folio_test_swapcache(folio))
+		return false;
+	if (!memcomp_reserve_nr_pages_valid(nr_pages))
+		return false;
+	return true;
+}
+
+#include "memcomp/folio.h"
+#include "memcomp/api.h"
+
+/*
+ * A pending entry starts with one owner reference.  memcomp_get_entry()
+ * adds the lookup reference observed below, so any further reference means
+ * the token may have escaped the folio, normally into a PTE installed by
+ * try_to_unmap().  A lookup can look the same, which costs no more than an
+ * rmap walk that finds nothing.  Nothing escapes once this finds no further
+ * reference: try_to_unmap() needs the folio lock, and fork() only copies a
+ * token that is already in a PTE.
+ */
+
+/*
+ * Map the locked @folio back wherever a token of its pending span went.  A
+ * reference left after a walk is normally a fault holding a lookup while it
+ * waits for the folio lock, with its PTE already mapped back.  But it may be
+ * a PTE the walk missed, which would pin the folio until faulted on, so walk
+ * again for as long as walks find PTEs, a few times at most.
+ */
+#define MEMCOMP_RESTORE_WALKS	3
+
+static bool memcomp_folio_dirty_one(struct folio *folio,
+				    struct vm_area_struct *vma,
+				    unsigned long address, void *arg)
+{
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
+	bool *dirty = arg;
+
+	while (page_vma_mapped_walk(&pvmw)) {
+		if (pvmw.pte)
+			*dirty = pte_dirty(ptep_get(pvmw.pte));
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		else
+			*dirty = pmd_dirty(*pvmw.pmd);
+#endif
+		if (*dirty) {
+			page_vma_mapped_walk_done(&pvmw);
+			return false;
+		}
+	}
+	return true;
+}
+
+/* Check a locked anonymous folio without clearing or write-protecting PTEs. */
+bool memcomp_folio_dirty(struct folio *folio)
+{
+	bool dirty = false;
+	struct rmap_walk_control rwc = {
+		.arg = &dirty,
+		.rmap_one = memcomp_folio_dirty_one,
+		.anon_lock = folio_lock_anon_vma_read,
+	};
+
+	if (folio_test_dirty(folio))
+		return true;
+	/* A writable swap-in PTE can be dirtied without another write fault. */
+	rmap_walk(folio, &rwc);
+	return dirty || folio_test_dirty(folio);
+}
+
+/*
+ * Whether reclaim should leave the locked @folio uncompressed, because it
+ * holds the contents it was marked incompressible with.  A folio written to
+ * since loses the mark.
+ */
+bool memcomp_folio_incompressible(struct folio *folio)
+{
+	if (!folio_test_incompressible(folio))
+		return false;
+	if (memcomp_folio_hash(folio) == folio_incompressible_hash(folio))
+		return true;
+
+	folio_clear_incompressible(folio);
+	memcomp_debug_add(folio_nr_pages(folio),
+			  &memcomp_incompressible_changed_pages);
+	return false;
+}
+
+/*
+ * Drop the locked @folio's reservation.  Reclaim reserves resident tokens
+ * before unmap so PTEs have a stable non-swap entry to install; if the store
+ * then fails, or the folio cannot be unmapped completely, the folio is mapped
+ * back wherever a token went first, so that nothing is left naming the span.
+ * The folio goes back to the LRU as it was, holding no reservation, but
+ * marked incompressible if that is why the store failed.
+ */
+
+static bool
+__memcomp_store_after_unmap(struct folio *folio,
+			    struct memcomp_reclaim_ctx **ctxp)
+{
+	struct memcomp_ctx_timing_record *timing;
+	struct memcomp_store_ctx store = { };
+	enum memcomp_anon_store_fail failure;
+	struct memcomp_reclaim_ctx *ctx;
+	unsigned int nr_pages;
+	bool success;
+
+	nr_pages = folio_nr_pages(folio);
+	if (WARN_ON_ONCE(!ctxp || !*ctxp))
+		return false;
+
+	ctx = *ctxp;
+	memcomp_ctx_timing_store_start(&ctx->timing);
+	success = mc16_anon_store_internal(folio, ctxp, &store, &failure);
+	if (!success)
+		memcomp_account_anon_store_fail(failure, nr_pages);
+	memcomp_account_anon_store(success, nr_pages);
+	if (store.staging) {
+		WARN_ON_ONCE(*ctxp);
+		timing = &store.staging->timing;
+	} else {
+		ctx = *ctxp;
+		if (WARN_ON_ONCE(!ctx))
+			return false;
+		timing = &ctx->timing;
+	}
+	memcomp_ctx_timing_store_end(timing, success);
+	if (*ctxp) {
+		ctx = *ctxp;
+		*ctxp = NULL;
+		memcomp_reclaim_ctx_put(ctx);
+	} else {
+		memcomp_ctx_timing_account(timing);
+	}
+	memcomp_direct_staging_put(store.staging);
+	if (success && store.anon_vma)
+		mc16_zero_convert_folio(folio, &store.zero);
+	store.zero = (struct mc16_zero_carrier) { };
+	if (store.anon_vma)
+		put_anon_vma(store.anon_vma);
+	return success;
+}
+
+bool memcomp_store_after_unmap(struct folio *folio,
+			       struct memcomp_reclaim_ctx **ctxp)
+{
+	return __memcomp_store_after_unmap(folio, ctxp);
+}
+
+static void memcomp_destroy_comp_ctxs(void)
+{
+	unsigned int i;
+
+	WARN_ON_ONCE(memcomp_direct_staging_active);
+	for (i = 0; i < memcomp_nr_direct_staging; i++) {
+		kfree(memcomp_direct_staging[i].dst);
+		memcomp_direct_staging[i].dst = NULL;
+	}
+	memcomp_nr_direct_staging = 0;
+	memcomp_direct_staging_free = 0;
+	memcomp_direct_staging_active = 0;
+	memcomp_direct_staging_peak = 0;
+
+	for (i = 0; i < memcomp_nr_comp_ctxs; i++) {
+		struct memcomp_reclaim_ctx *ctx = &memcomp_comp_ctxs[i];
+
+		if (ctx->tfm) {
+			crypto_free_comp(ctx->tfm);
+			ctx->tfm = NULL;
+		}
+		kfree(ctx->dst);
+		ctx->dst = NULL;
+	}
+	memcomp_nr_comp_ctxs = 0;
+	memcomp_nr_reserved_comp_ctxs = 0;
+	memcomp_nr_borrowable_comp_ctxs = 0;
+	memcomp_comp_ctx_free = 0;
+	memcomp_comp_ctx_all = 0;
+	memcomp_comp_ctx_foreground = 0;
+	memcomp_comp_ctx_borrowed = 0;
+	memcomp_comp_ctx_borrowed_active = 0;
+	memcomp_comp_ctx_borrowed_peak = 0;
+	memcomp_comp_ctx_waiters = 0;
+	memset(&memcomp_comp_budget, 0, sizeof(memcomp_comp_budget));
+}
+
+static void memcomp_destroy_decomp_ctxs(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct memcomp_decomp_ctx *ctx;
+
+		ctx = &per_cpu(memcomp_decomp_ctxs, cpu);
+		if (ctx->tfm) {
+			crypto_free_comp(ctx->tfm);
+			ctx->tfm = NULL;
+		}
+	}
+}
+
+/* Set everything up for memcomp_compressor and enable memcomp. */
+static int memcomp_start(void)
+{
+	unsigned int target_comp_ctxs;
+	int ret = -ENOMEM;
+	int cpu;
+	int i;
+
+	for (i = 0; i < MAX_NUMNODES; i++) {
+		spin_lock_init(&memcomp_lrus[i].lock);
+		INIT_LIST_HEAD(&memcomp_lrus[i].entries);
+		atomic_long_set(&memcomp_lrus[i].nr_entries, 0);
+	}
+
+	for (i = 0; i < MEMCOMP_NR_LOCKS; i++)
+		mutex_init(&memcomp_locks[i]);
+
+	target_comp_ctxs = min_t(unsigned int, MEMCOMP_MAX_COMP_CTXS,
+				 4 * num_possible_cpus());
+	for (i = 0; i < target_comp_ctxs; i++) {
+		struct memcomp_reclaim_ctx *ctx = &memcomp_comp_ctxs[i];
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+		unsigned int source;
+#endif
+
+		mutex_init(&ctx->lock);
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+		for (source = 0; source < MEMCOMP_RECLAIM_SOURCE_NR;
+		     source++) {
+			unsigned int seed;
+
+			seed = i * MEMCOMP_RECLAIM_SOURCE_NR + source;
+			ctx->timing_seq[source] =
+				memcomp_ctx_timing_seed(seed);
+		}
+#endif
+		ctx->tfm = crypto_alloc_comp(memcomp_compressor, 0, 0);
+		if (IS_ERR(ctx->tfm)) {
+			ret = PTR_ERR(ctx->tfm);
+			ctx->tfm = NULL;
+			break;
+		}
+		ctx->dst = kmalloc(MEMCOMP_MAX_COMPRESSED_SIZE,
+				   GFP_KERNEL);
+		if (!ctx->dst) {
+			crypto_free_comp(ctx->tfm);
+			ctx->tfm = NULL;
+			break;
+		}
+		memcomp_nr_comp_ctxs++;
+		__set_bit(i, &memcomp_comp_ctx_all);
+	}
+	if (!memcomp_nr_comp_ctxs)
+		goto err_comp;
+	if (memcomp_nr_comp_ctxs < target_comp_ctxs)
+		pr_warn("initialized %u of %u compression contexts\n",
+			memcomp_nr_comp_ctxs, target_comp_ctxs);
+	memcomp_nr_reserved_comp_ctxs =
+		min_t(unsigned int, num_possible_cpus(),
+		      memcomp_nr_comp_ctxs / 2);
+	if (memcomp_nr_reserved_comp_ctxs)
+		memcomp_nr_borrowable_comp_ctxs =
+			min_t(unsigned int, MEMCOMP_MAX_BORROWED_COMP_CTXS,
+			      memcomp_nr_reserved_comp_ctxs - 1);
+	memcomp_comp_ctx_foreground = memcomp_comp_ctx_all;
+	bitmap_clear(&memcomp_comp_ctx_foreground, 0,
+		     memcomp_nr_reserved_comp_ctxs);
+	memcomp_comp_ctx_free = memcomp_comp_ctx_all;
+	memcomp_comp_ctx_borrowed = 0;
+	memcomp_comp_ctx_borrowed_active = 0;
+	memcomp_comp_ctx_borrowed_peak = 0;
+	memcomp_comp_ctx_waiters = 0;
+	memset(&memcomp_comp_budget, 0, sizeof(memcomp_comp_budget));
+	for (i = 0; i < memcomp_nr_comp_ctxs; i++) {
+		struct memcomp_direct_staging *staging;
+
+		staging = &memcomp_direct_staging[i];
+		staging->dst = kmalloc(MEMCOMP_MAX_COMPRESSED_SIZE,
+				       GFP_KERNEL);
+		if (!staging->dst)
+			break;
+		memcomp_nr_direct_staging++;
+		__set_bit(i, &memcomp_direct_staging_free);
+	}
+	if (memcomp_nr_direct_staging < memcomp_nr_comp_ctxs)
+		pr_warn("initialized %u of %u direct staging buffers\n",
+			memcomp_nr_direct_staging, memcomp_nr_comp_ctxs);
+
+	for_each_possible_cpu(cpu) {
+		struct memcomp_decomp_ctx *ctx;
+
+		ctx = &per_cpu(memcomp_decomp_ctxs, cpu);
+		ctx->tfm = crypto_alloc_comp(memcomp_compressor, 0, 0);
+		if (IS_ERR(ctx->tfm)) {
+			ret = PTR_ERR(ctx->tfm);
+			ctx->tfm = NULL;
+			goto err_decomp;
+		}
+	}
+
+	for (i = 0; i < MEMCOMP_NR_POOLS; i++) {
+		char name[24];
+
+		snprintf(name, sizeof(name), "memcomp%d", i);
+		memcomp_pools[i] = zs_create_pool(name);
+		if (!memcomp_pools[i])
+			break;
+		memcomp_nr_pools++;
+	}
+
+	if (!memcomp_nr_pools) {
+		ret = -ENODEV;
+		goto err_decomp;
+	}
+
+	memcomp_meta_shrinker = shrinker_alloc(0, "memcomp-meta");
+	if (!memcomp_meta_shrinker)
+		pr_warn("metadata shrinker allocation failed; pressure reclaim unavailable\n");
+	if (memcomp_meta_shrinker) {
+		memcomp_meta_shrinker->count_objects = mc16_meta_shrinker_count;
+		memcomp_meta_shrinker->scan_objects = mc16_meta_shrinker_scan;
+		shrinker_register(memcomp_meta_shrinker);
+	}
+	/* Make every initialized resource visible before enabling callers. */
+	smp_store_release(&memcomp_enabled, true);
+	pr_info("using %s\n", memcomp_compressor);
+
+	return 0;
+
+err_decomp:
+	memcomp_destroy_decomp_ctxs();
+err_comp:
+	memcomp_destroy_comp_ctxs();
+	pr_warn("%s: init failed: %d\n", memcomp_compressor,
+		ret);
+	return ret;
+}
+
+/*
+ * The compressor memcomp is built to use may be one whose driver only
+ * registers it after late_initcall - a hardware engine that probes once the
+ * IOMMU in front of it does, from a module, say.  Wait that long for it, and
+ * take MEMCOMP_FALLBACK_COMPRESSOR once it is plain it is not coming or
+ * memcomp cannot be set up on it.  memcomp stays disabled until one
+ * of the two is decided on: payloads of two compressors cannot share it.
+ */
+#define MEMCOMP_FALLBACK_COMPRESSOR	"zstd"
+/* As long as the driver core waits for the modules a device's probe needs. */
+#define MEMCOMP_COMPRESSOR_WAIT	(10 * HZ)
+
+/* The startup decision is protected by memcomp_select_lock. */
+struct memcomp_compressor_select {
+	struct delayed_work work;
+	struct notifier_block nb;
+	char *compressor;
+	unsigned long deadline;
+	bool decided;
+};
+
+static void memcomp_select_worker(struct work_struct *work);
+static int memcomp_crypto_notify(struct notifier_block *nb,
+				 unsigned long msg, void *data);
+
+static struct memcomp_compressor_select memcomp_select = {
+	.work = __DELAYED_WORK_INITIALIZER(memcomp_select.work,
+					   memcomp_select_worker, 0),
+	.nb = {
+		.notifier_call = memcomp_crypto_notify,
+	},
+	.compressor = memcomp_compressor,
+};
+
+static int memcomp_crypto_notify(struct notifier_block *nb,
+				 unsigned long msg, void *data)
+{
+	struct memcomp_compressor_select *select;
+
+	if (msg != CRYPTO_MSG_ALG_LOADED)
+		return NOTIFY_DONE;
+	select = container_of(nb, struct memcomp_compressor_select, nb);
+	/*
+	 * crypto_alg_sem is held.  Neither allocate a tfm nor take the
+	 * selection lock here: selection takes that semaphore in turn.
+	 * The worker looks up only its selected name under the mutex, so
+	 * neither a fallback name change nor the event's lifetime can race.
+	 */
+	mod_delayed_work(system_unbound_wq, &select->work, 0);
+	return NOTIFY_OK;
+}
+
+static void memcomp_select_worker(struct work_struct *work)
+{
+	struct memcomp_compressor_select *select;
+	unsigned long now = jiffies;
+
+	select = container_of(to_delayed_work(work),
+			      struct memcomp_compressor_select, work);
+	mutex_lock(&memcomp_select_lock);
+	if (select->decided)
+		goto out;
+
+	if (crypto_has_comp(select->compressor, 0, 0) != 1) {
+		if (time_before(now, select->deadline)) {
+			/* Not mod_: a registration may have asked for sooner. */
+			queue_delayed_work(system_unbound_wq, &select->work,
+					   select->deadline - now);
+			goto out;
+		}
+		pr_warn("compressor %s unavailable\n", select->compressor);
+	}
+	/* The synchronous compressor choice is final. */
+	select->decided = true;
+	if (crypto_has_comp(select->compressor, 0, 0) == 1 &&
+	    !memcomp_start()) {
+		goto out;
+	}
+
+	if (strcmp(select->compressor, MEMCOMP_FALLBACK_COMPRESSOR)) {
+		pr_warn("falling back to %s\n", MEMCOMP_FALLBACK_COMPRESSOR);
+		strscpy(select->compressor, MEMCOMP_FALLBACK_COMPRESSOR,
+			sizeof(memcomp_compressor));
+		if (crypto_has_comp(select->compressor, 0, 0) == 1 &&
+		    !memcomp_start()) {
+			goto out;
+		}
+	}
+	pr_warn("disabled, no usable compressor\n");
+out:
+	mutex_unlock(&memcomp_select_lock);
+}
+
+static int __init memcomp_init(void)
+{
+	int ret;
+
+	BUILD_BUG_ON(MAX_NUMNODES > U16_MAX);
+	BUILD_BUG_ON(MEMCOMP_MAX_COMP_CTXS > BITS_PER_LONG);
+
+	/* Listen first, so a registration racing the check is not missed. */
+	memcomp_select.deadline = jiffies + MEMCOMP_COMPRESSOR_WAIT;
+	ret = crypto_register_notifier(&memcomp_select.nb);
+	if (ret)
+		return ret;
+	/* A compressor that is already there is set up before this returns. */
+	memcomp_select_worker(&memcomp_select.work.work);
+	return 0;
+}
+late_initcall(memcomp_init);
+
+#ifdef CONFIG_SYSFS
+static ssize_t stat_show(struct kobject *kobj,
+			 struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu %llu %llu\n",
+			  mc16_zero_stored_bytes(atomic64_read(&memcomp_stored_bytes)),
+			  (u64)atomic64_read(&memcomp_compressed_bytes),
+			  memcomp_pool_total_size());
+}
+
+static ssize_t compressor_show(struct kobject *kobj,
+			       struct kobj_attribute *attr, char *buf)
+{
+	ssize_t len;
+
+	/* The name can still fall back while a late compressor is awaited. */
+	mutex_lock(&memcomp_select_lock);
+	len = sysfs_emit(buf, "%s\n", memcomp_compressor);
+	mutex_unlock(&memcomp_select_lock);
+	return len;
+}
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+/* The span upkeep part of execution_events, appended at @len. */
+static ssize_t memcomp_span_events_show(char *buf, ssize_t len)
+{
+	len += sysfs_emit_at(buf, len,
+			     "restore_spans %llu\n"
+			     "restore_ptes %llu\n"
+			     "restore_missed_pages %llu\n"
+			     "restore_rewalks %llu\n"
+			     "restore_ns %llu\n"
+			     "restore_max_ns %llu\n"
+			     "split_refused %llu\n"
+			     "split_refused_pages %llu\n",
+			     (u64)atomic64_read(&memcomp_restore_spans),
+			     (u64)atomic64_read(&memcomp_restore_ptes),
+			     (u64)atomic64_read(&memcomp_restore_missed_pages),
+			     (u64)atomic64_read(&memcomp_restore_rewalks),
+			     (u64)atomic64_read(&memcomp_restore_ns),
+			     (u64)atomic64_read(&memcomp_restore_max_ns),
+			     (u64)atomic64_read(&memcomp_split_refused),
+			     (u64)atomic64_read(&memcomp_split_refused_pages));
+
+	return len;
+}
+
+static ssize_t __events_show(char *buf)
+{
+	struct memcomp_state_stats state;
+	u64 raw_candidate_ge_page;
+	u64 raw_candidate_huge;
+	u64 raw_reject_ge_page;
+	u64 raw_reject_huge;
+	u64 raw_reject_net;
+	u64 raw_reject_zs_fallback;
+	u64 incompressible;
+	u64 raw_reject;
+	u64 refresh_preflight_fail_pages;
+	u64 refresh_folio_busy_fail_pages;
+	u64 shmem_eligibility_fail_pages;
+	u64 reclaim_ctx_borrow_limit_pages;
+	u64 reclaim_ctx_borrow_waiter_pages;
+	u64 reclaim_ctx_borrow_pages;
+	u64 reclaim_ctx_busy_reserved_free_pages;
+	u64 reclaim_ctx_busy_all_busy_pages;
+	unsigned long comp_ctx_flags;
+	unsigned int comp_ctx_borrowed_active;
+	unsigned int comp_ctx_borrowed_peak;
+	unsigned int comp_ctx_borrow_limit;
+	unsigned int comp_ctx_free;
+	unsigned int comp_ctx_waiters;
+
+	memcomp_state_read(&state);
+	{
+		struct mc16_zero_owners zero;
+
+		mc16_zero_owners_read(&zero);
+		state.samefill_pages += max_t(s64, zero.pte_pages, 0) +
+			max_t(s64, zero.cache_pages, 0);
+		state.shmem_pages += max_t(s64, zero.cache_pages, 0);
+	}
+	raw_candidate_huge = atomic64_read(&memcomp_raw_candidate_huge);
+	raw_candidate_ge_page =
+		atomic64_read(&memcomp_raw_candidate_ge_page);
+	raw_reject_huge = atomic64_read(&memcomp_raw_reject_huge);
+	raw_reject_ge_page = atomic64_read(&memcomp_raw_reject_ge_page);
+	raw_reject_zs_fallback =
+		atomic64_read(&memcomp_raw_reject_zs_fallback);
+	raw_reject_net = atomic64_read(&memcomp_raw_reject_net);
+	incompressible = raw_candidate_huge + raw_candidate_ge_page;
+	raw_reject = raw_reject_huge + raw_reject_ge_page +
+		     raw_reject_zs_fallback + raw_reject_net;
+	refresh_preflight_fail_pages =
+		atomic64_read(&memcomp_refresh_preflight_fail_pages);
+	refresh_folio_busy_fail_pages =
+		atomic64_read(&memcomp_refresh_folio_busy_fail_pages);
+	shmem_eligibility_fail_pages =
+		atomic64_read(&memcomp_shmem_eligibility_fail_pages);
+	reclaim_ctx_busy_reserved_free_pages =
+		atomic64_read(&memcomp_reclaim_ctx_busy_reserved_free_pages);
+	reclaim_ctx_busy_all_busy_pages =
+		atomic64_read(&memcomp_reclaim_ctx_busy_all_busy_pages);
+	reclaim_ctx_borrow_pages =
+		atomic64_read(&memcomp_reclaim_ctx_borrow_pages);
+	reclaim_ctx_borrow_limit_pages =
+		atomic64_read(&memcomp_reclaim_ctx_borrow_limit_pages);
+	reclaim_ctx_borrow_waiter_pages =
+		atomic64_read(&memcomp_reclaim_ctx_borrow_waiter_pages);
+	spin_lock_irqsave(&memcomp_comp_ctx_lock, comp_ctx_flags);
+	comp_ctx_free = hweight_long(memcomp_comp_ctx_free);
+	comp_ctx_borrowed_active = memcomp_comp_ctx_borrowed_active;
+	comp_ctx_borrowed_peak = memcomp_comp_ctx_borrowed_peak;
+	comp_ctx_borrow_limit = memcomp_nr_borrowable_comp_ctxs;
+	comp_ctx_waiters = memcomp_comp_ctx_waiters;
+	spin_unlock_irqrestore(&memcomp_comp_ctx_lock, comp_ctx_flags);
+	return sysfs_emit(buf,
+			  "enabled %u\n"
+			  "comp_ctx_count %u\n"
+			  "comp_ctx_reserved %u\n"
+			  "comp_ctx_borrow_limit %u\n"
+			  "comp_ctx_free %u\n"
+			  "comp_ctx_wait %llu\n"
+			  "comp_ctx_waiters %u\n"
+			  "comp_ctx_borrowed_active %u\n"
+			  "comp_ctx_borrowed_peak %u\n"
+			  "ctx_busy %llu\n"
+			  "reclaim_ctx_busy_pages %llu\n"
+			  "reclaim_ctx_busy_reserved_free_pages %llu\n"
+			  "reclaim_ctx_busy_all_busy_pages %llu\n"
+			  "reclaim_ctx_borrow_pages %llu\n"
+			  "reclaim_ctx_borrow_limit_pages %llu\n"
+			  "reclaim_ctx_borrow_waiter_pages %llu\n"
+			  "compress_fail %llu\n"
+			  "incompressible %llu\n"
+			  "zs_fast_fail %llu\n"
+			  "zs_retry %llu\n"
+			  "zs_retry_success %llu\n"
+			  "zs_retry_fail %llu\n"
+			  "zs_fail %llu\n"
+			  "zs_alloc_other_fail %llu\n"
+			  "zs_huge_class_size %u\n"
+			  "raw_store %llu\n"
+			  "raw_candidate_huge_class %llu\n"
+			  "raw_candidate_ge_page %llu\n"
+			  "raw_reject %llu\n"
+			  "raw_reject_huge_class %llu\n"
+			  "raw_reject_ge_page %llu\n"
+			  "raw_reject_zs_fallback %llu\n"
+			  "raw_reject_net %llu\n"
+			  "reserve_entry_alloc_fail %llu\n"
+			  "refresh_state_fail %llu\n"
+			  "refresh_payload_fail %llu\n"
+			  "anon_unmap_fail_pages %llu\n"
+			  "refresh_preflight_fail_pages %llu\n"
+			  "refresh_folio_busy_fail_pages %llu\n"
+			  "refresh_arch_fail_pages %llu\n"
+			  "refresh_state_fail_pages %llu\n"
+			  "refresh_payload_fail_pages %llu\n"
+			  "anon_finish_fail_pages %llu\n"
+			  "incompressible_marked_pages %llu\n"
+			  "incompressible_changed_pages %llu\n"
+			  "incompressible_folio_skip_pages %llu\n"
+			  "shmem_store_ok_pages %llu\n"
+			  "shmem_store_fail_pages %llu\n"
+			  "shmem_eligibility_fail_pages %llu\n"
+			  "shmem_payload_fail_pages %llu\n"
+			  "shmem_arch_fail_pages %llu\n"
+			  "folio_owner_pages %lld\n"
+			  "samefill_pages %lld\n"
+			  "raw_pages %lld\n"
+			  "shmem_pages %lld\n"
+			  "pending_pages %llu\n"
+			  "bg_store_ok %llu\n"
+			  "bg_store_fail %llu\n"
+			  "direct_store_ok %llu\n"
+			  "direct_store_fail %llu\n"
+			  "pageout_store_ok %llu\n"
+			  "pageout_store_fail %llu\n"
+			  "swapped_read_io %llu\n"
+			  "swapped_read_error %llu\n"
+			  "swapped_read_cached %llu\n"
+			  "swapped_entries %lu\n"
+			  "swapoff_entries %llu\n"
+			  "swapoff_read_io %llu\n"
+			  "swapoff_fail %llu\n",
+			  memcomp_is_enabled(),
+			  READ_ONCE(memcomp_nr_comp_ctxs),
+			  READ_ONCE(memcomp_nr_reserved_comp_ctxs),
+			  comp_ctx_borrow_limit,
+			  comp_ctx_free,
+			  (u64)atomic64_read(&memcomp_comp_ctx_waits),
+			  comp_ctx_waiters,
+			  comp_ctx_borrowed_active,
+			  comp_ctx_borrowed_peak,
+			  (u64)atomic64_read(&memcomp_ctx_busy),
+			  reclaim_ctx_busy_reserved_free_pages +
+				reclaim_ctx_busy_all_busy_pages,
+			  reclaim_ctx_busy_reserved_free_pages,
+			  reclaim_ctx_busy_all_busy_pages,
+			  reclaim_ctx_borrow_pages,
+			  reclaim_ctx_borrow_limit_pages,
+			  reclaim_ctx_borrow_waiter_pages,
+			  (u64)atomic64_read(&memcomp_compress_fail),
+			  incompressible,
+			  (u64)atomic64_read(&memcomp_zs_fast_fail),
+			  (u64)atomic64_read(&memcomp_zs_retries),
+			  (u64)atomic64_read(&memcomp_zs_retry_success),
+			  (u64)atomic64_read(&memcomp_zs_retry_fail),
+			  (u64)atomic64_read(&memcomp_zs_fail),
+			  (u64)atomic64_read(&memcomp_zs_other_fail),
+			  memcomp_pool_huge_class_size(),
+			  (u64)atomic64_read(&memcomp_raw_store),
+			  raw_candidate_huge,
+			  raw_candidate_ge_page,
+			  raw_reject,
+			  raw_reject_huge,
+			  raw_reject_ge_page,
+			  raw_reject_zs_fallback,
+			  raw_reject_net,
+			  (u64)atomic64_read(&memcomp_reserve_entry_alloc_fail),
+			  (u64)atomic64_read(&memcomp_refresh_state_fail),
+			  (u64)atomic64_read(&memcomp_refresh_payload_fail),
+			  (u64)atomic64_read(&memcomp_anon_unmap_fail_pages),
+			  refresh_preflight_fail_pages,
+			  refresh_folio_busy_fail_pages,
+			  (u64)atomic64_read(&memcomp_refresh_arch_fail_pages),
+			  (u64)atomic64_read(&memcomp_refresh_state_fail_pages),
+			  (u64)atomic64_read(&memcomp_refresh_payload_fail_pages),
+			  (u64)atomic64_read(&memcomp_anon_finish_fail_pages),
+			  (u64)atomic64_read(&memcomp_incompressible_marked_pages),
+			  (u64)atomic64_read(&memcomp_incompressible_changed_pages),
+			  (u64)atomic64_read(&memcomp_incompressible_folio_skip_pages),
+			  (u64)atomic64_read(&memcomp_shmem_store_ok_pages),
+			  (u64)atomic64_read(&memcomp_shmem_store_fail_pages),
+			  shmem_eligibility_fail_pages,
+			  (u64)atomic64_read(&memcomp_shmem_payload_fail_pages),
+			  (u64)atomic64_read(&memcomp_shmem_arch_fail_pages),
+			  state.folio_owner_pages,
+			  state.samefill_pages,
+			  state.raw_pages,
+			  state.shmem_pages,
+			  (u64)atomic64_read(&memcomp_pending_pages),
+			  (u64)atomic64_read(&memcomp_bg_store_ok),
+			  (u64)atomic64_read(&memcomp_bg_store_fail),
+			  (u64)atomic64_read(&memcomp_direct_store_ok),
+			  (u64)atomic64_read(&memcomp_direct_store_fail),
+			  (u64)atomic64_read(&memcomp_pageout_store_ok),
+			  (u64)atomic64_read(&memcomp_pageout_store_fail),
+			  (u64)atomic64_read(&memcomp_swapped_read_io),
+			  (u64)atomic64_read(&memcomp_swapped_read_error),
+			  (u64)atomic64_read(&memcomp_swapped_read_cached),
+			  atomic_long_read(&memcomp_swapped_entries),
+			  (u64)atomic64_read(&memcomp_swapoff_entries),
+			  (u64)atomic64_read(&memcomp_swapoff_read_io),
+			  (u64)atomic64_read(&memcomp_swapoff_fail));
+}
+
+static ssize_t events_show(struct kobject *kobj,
+			   struct kobj_attribute *attr, char *buf)
+{
+	return __events_show(buf);
+}
+
+#endif /* CONFIG_MEMCOMP_DEBUG_STATS */
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static ssize_t placement_events_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	u64 stats[MEMCOMP_PLACEMENT_STAT_NR];
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(stats); i++)
+		stats[i] = memcomp_placement_stat_read(i);
+
+	return sysfs_emit(buf,
+			  "compress %llu\n"
+			  "normal_swap_fallback %llu\n",
+			  stats[MEMCOMP_PLACEMENT_STAT_COMPRESS],
+			  stats[MEMCOMP_PLACEMENT_STAT_NORMAL_SWAP_FALLBACK]);
+}
+
+/*
+ * The swap-backed store has no descriptor state left to report - a slot
+ * maps to exactly one entry and frees with it - so what remains here is
+ * the writeback control loop and its outcomes.
+ */
+#endif
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+
+static ssize_t
+memcomp_context_bucket_emit(char *buf, ssize_t at, const char *prefix,
+			    const struct memcomp_ctx_timing_stats *stats)
+{
+	return at + sysfs_emit_at(buf, at,
+			     "%s_samples %llu\n"
+			     "%s_pages %llu\n"
+			     "%s_store_samples %llu\n"
+			     "%s_store_success %llu\n"
+			     "%s_lease_ns %llu\n"
+			     "%s_lease_max_ns %llu\n"
+			     "%s_pre_store_ns %llu\n"
+			     "%s_pre_store_max_ns %llu\n"
+			     "%s_compress_ns %llu\n"
+			     "%s_compress_max_ns %llu\n"
+			     "%s_compress_cpu_ns %llu\n"
+			     "%s_compress_call_cpu_max_ns %llu\n"
+			     "%s_compress_store_success_ns %llu\n"
+			     "%s_compress_store_success_cpu_ns %llu\n"
+			     "%s_compress_store_fail_ns %llu\n"
+			     "%s_compress_store_fail_cpu_ns %llu\n"
+			     "%s_zs_ns %llu\n"
+			     "%s_zs_max_ns %llu\n"
+			     "%s_store_other_ns %llu\n"
+			     "%s_store_other_max_ns %llu\n",
+			     prefix, (u64)atomic64_read(&stats->samples),
+			     prefix, (u64)atomic64_read(&stats->pages),
+			     prefix, (u64)atomic64_read(&stats->store_samples),
+			     prefix, (u64)atomic64_read(&stats->store_success),
+			     prefix, (u64)atomic64_read(&stats->lease_ns),
+			     prefix, (u64)atomic64_read(&stats->lease_max_ns),
+			     prefix, (u64)atomic64_read(&stats->pre_store_ns),
+			     prefix, (u64)atomic64_read(&stats->pre_store_max_ns),
+			     prefix, (u64)atomic64_read(&stats->compress_ns),
+			     prefix, (u64)atomic64_read(&stats->compress_max_ns),
+			     prefix, (u64)atomic64_read(&stats->compress_cpu_ns),
+			     prefix,
+			     (u64)atomic64_read(&stats->compress_call_cpu_max_ns),
+			     prefix,
+			     (u64)atomic64_read(&stats->compress_store_success_ns),
+			     prefix,
+			     (u64)atomic64_read(&stats->compress_store_success_cpu_ns),
+			     prefix,
+			     (u64)atomic64_read(&stats->compress_store_fail_ns),
+			     prefix,
+			     (u64)atomic64_read(&stats->compress_store_fail_cpu_ns),
+			     prefix, (u64)atomic64_read(&stats->zs_ns),
+			     prefix, (u64)atomic64_read(&stats->zs_max_ns),
+			     prefix, (u64)atomic64_read(&stats->store_other_ns),
+			     prefix, (u64)atomic64_read(&stats->store_other_max_ns));
+}
+
+static ssize_t memcomp_outcome_emit(char *buf, ssize_t at,
+				    const char *prefix, const char *name,
+					const struct memcomp_compress_timing_stats *stats)
+{
+	return at + sysfs_emit_at(buf, at,
+			     "%s_compress_%s_calls %llu\n"
+			     "%s_compress_%s_ns %llu\n"
+			     "%s_compress_%s_cpu_ns %llu\n",
+			     prefix, name, (u64)atomic64_read(&stats->calls),
+			     prefix, name, (u64)atomic64_read(&stats->wall_ns),
+			     prefix, name, (u64)atomic64_read(&stats->cpu_ns));
+}
+
+static ssize_t
+memcomp_outcomes_emit(char *buf, ssize_t at, const char *prefix,
+		      const struct memcomp_ctx_timing_stats *stats)
+{
+	const struct memcomp_compress_timing_stats *outcome;
+	unsigned int index;
+
+	index = MEMCOMP_COMPRESS_TIMING_COMPRESSIBLE;
+	outcome = &stats->compress_outcome[index];
+	at = memcomp_outcome_emit(buf, at, prefix, "compressible", outcome);
+	outcome = &stats->compress_outcome[MEMCOMP_COMPRESS_TIMING_RAW_HUGE];
+	at = memcomp_outcome_emit(buf, at, prefix, "raw_huge", outcome);
+	index = MEMCOMP_COMPRESS_TIMING_RAW_GE_PAGE;
+	outcome = &stats->compress_outcome[index];
+	at = memcomp_outcome_emit(buf, at, prefix, "raw_ge_page", outcome);
+	outcome = &stats->compress_outcome[MEMCOMP_COMPRESS_TIMING_ERROR];
+	at = memcomp_outcome_emit(buf, at, prefix, "error", outcome);
+	return at;
+}
+
+static ssize_t context_events_show(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *buf)
+{
+	const struct memcomp_ctx_timing_stats *stats;
+	ssize_t at;
+
+	at = sysfs_emit(buf,
+			"sample_interval %u\n"
+			"wait_events %llu\n"
+			"wait_ns %llu\n"
+			"wait_max_ns %llu\n",
+			MEMCOMP_CTX_TIMING_SAMPLE_INTERVAL,
+			(u64)atomic64_read(&memcomp_comp_ctx_waits),
+			(u64)atomic64_read(&memcomp_comp_ctx_wait_ns),
+			(u64)atomic64_read(&memcomp_comp_ctx_wait_max_ns));
+	stats = &memcomp_ctx_timing[MEMCOMP_CTX_TIMING_DIRECT];
+	at = memcomp_context_bucket_emit(buf, at, "direct", stats);
+	at = memcomp_outcomes_emit(buf, at, "direct", stats);
+	stats = &memcomp_ctx_timing[MEMCOMP_CTX_TIMING_BACKGROUND];
+	at = memcomp_context_bucket_emit(buf, at, "bg", stats);
+	at = memcomp_outcomes_emit(buf, at, "bg", stats);
+	return at;
+}
+
+static ssize_t
+memcomp_context_source_emit(char *buf, ssize_t at, const char *prefix,
+			    const struct memcomp_ctx_timing_stats *stats,
+				const struct memcomp_ctx_wait_stats *wait)
+{
+	return at + sysfs_emit_at(buf, at,
+			     "%s_samples %llu\n"
+			     "%s_pages %llu\n"
+			     "%s_store_samples %llu\n"
+			     "%s_store_success %llu\n"
+			     "%s_wait_events %llu\n"
+			     "%s_wait_ns %llu\n"
+			     "%s_wait_max_ns %llu\n"
+			     "%s_lease_ns %llu\n"
+			     "%s_lease_max_ns %llu\n"
+			     "%s_pre_store_ns %llu\n"
+			     "%s_pre_store_max_ns %llu\n"
+			     "%s_compress_ns %llu\n"
+			     "%s_compress_max_ns %llu\n"
+			     "%s_compress_cpu_ns %llu\n"
+			     "%s_compress_call_cpu_max_ns %llu\n"
+			     "%s_zs_ns %llu\n"
+			     "%s_zs_max_ns %llu\n"
+			     "%s_store_other_ns %llu\n"
+			     "%s_store_other_max_ns %llu\n",
+			     prefix, (u64)atomic64_read(&stats->samples),
+			     prefix, (u64)atomic64_read(&stats->pages),
+			     prefix, (u64)atomic64_read(&stats->store_samples),
+			     prefix, (u64)atomic64_read(&stats->store_success),
+			     prefix, (u64)atomic64_read(&wait->events),
+			     prefix, (u64)atomic64_read(&wait->ns),
+			     prefix, (u64)atomic64_read(&wait->max_ns),
+			     prefix, (u64)atomic64_read(&stats->lease_ns),
+			     prefix, (u64)atomic64_read(&stats->lease_max_ns),
+			     prefix, (u64)atomic64_read(&stats->pre_store_ns),
+			     prefix, (u64)atomic64_read(&stats->pre_store_max_ns),
+			     prefix, (u64)atomic64_read(&stats->compress_ns),
+			     prefix, (u64)atomic64_read(&stats->compress_max_ns),
+			     prefix, (u64)atomic64_read(&stats->compress_cpu_ns),
+			     prefix,
+			     (u64)atomic64_read(&stats->compress_call_cpu_max_ns),
+			     prefix, (u64)atomic64_read(&stats->zs_ns),
+			     prefix, (u64)atomic64_read(&stats->zs_max_ns),
+			     prefix, (u64)atomic64_read(&stats->store_other_ns),
+			     prefix, (u64)atomic64_read(&stats->store_other_max_ns));
+}
+
+static ssize_t context_sources_show(struct kobject *kobj,
+				    struct kobj_attribute *attr, char *buf)
+{
+	const struct memcomp_ctx_timing_stats *stats;
+	const struct memcomp_ctx_wait_stats *wait;
+	ssize_t at;
+
+	at = sysfs_emit(buf, "sample_interval %u\n",
+			MEMCOMP_CTX_TIMING_SAMPLE_INTERVAL);
+	stats = &memcomp_ctx_source_timing[MEMCOMP_RECLAIM_DIRECT];
+	wait = &memcomp_ctx_source_wait[MEMCOMP_RECLAIM_DIRECT];
+	at = memcomp_context_source_emit(buf, at, "direct", stats, wait);
+	stats = &memcomp_ctx_source_timing[MEMCOMP_RECLAIM_KSWAPD];
+	wait = &memcomp_ctx_source_wait[MEMCOMP_RECLAIM_KSWAPD];
+	at = memcomp_context_source_emit(buf, at, "kswapd", stats, wait);
+	return at;
+}
+
+static ssize_t __execution_events_show(char *buf)
+{
+	atomic64_t *budget_waits = memcomp_comp_budget_waits;
+	struct memcomp_comp_budget budget;
+	u64 refresh_cross_node_pages = 0;
+	u64 budget_pages;
+	u64 budget_reject;
+	u64 budget_reject_pages;
+	u64 kswapd_wait;
+	unsigned int staging_active;
+	unsigned int staging_count;
+	unsigned int staging_free;
+	unsigned int staging_peak;
+	unsigned int limit;
+	unsigned int waiters;
+	int cpu;
+	unsigned long flags;
+
+	spin_lock_irqsave(&memcomp_comp_ctx_lock, flags);
+	budget = memcomp_comp_budget;
+	limit = memcomp_current_comp_budget_limit();
+	waiters = memcomp_comp_ctx_waiters;
+	spin_unlock_irqrestore(&memcomp_comp_ctx_lock, flags);
+	spin_lock_irqsave(&memcomp_direct_staging_lock, flags);
+	staging_count = memcomp_nr_direct_staging;
+	staging_free = bitmap_weight(&memcomp_direct_staging_free,
+				     staging_count);
+	staging_active = memcomp_direct_staging_active;
+	staging_peak = memcomp_direct_staging_peak;
+	spin_unlock_irqrestore(&memcomp_direct_staging_lock, flags);
+	budget_pages = atomic64_read(&memcomp_reclaim_ctx_budget_pages);
+	budget_reject = atomic64_read(&memcomp_reclaim_ctx_budget_reject);
+	budget_reject_pages =
+		atomic64_read(&memcomp_reclaim_ctx_budget_reject_pages);
+	kswapd_wait = atomic64_read(&budget_waits[MEMCOMP_RECLAIM_KSWAPD]);
+	for_each_possible_cpu(cpu)
+		refresh_cross_node_pages +=
+			READ_ONCE(per_cpu(mc16_refresh_cross_node_pages, cpu));
+
+	return sysfs_emit(buf,
+			  "comp_budget_limit %u\n"
+			  "comp_budget_background_limit %u\n"
+			  "comp_budget_direct_limit %u\n"
+			  "comp_budget_active %u\n"
+			  "comp_budget_background_active %u\n"
+			  "comp_budget_direct_active %u\n"
+			  "comp_budget_peak %u\n"
+			  "comp_budget_background_peak %u\n"
+			  "comp_budget_direct_peak %u\n"
+			  "comp_budget_waiters %u\n"
+			  "reclaim_ctx_budget_pages %llu\n"
+			  "direct_budget_reject %llu\n"
+			  "direct_budget_reject_pages %llu\n"
+			  "kswapd_budget_wait %llu\n"
+			  "direct_staging_count %u\n"
+			  "direct_staging_free %u\n"
+			  "direct_staging_active %u\n"
+			  "direct_staging_peak %u\n"
+			  "direct_staging_miss %llu\n"
+			  "direct_staging_detach %llu\n"
+			  "refresh_cross_node_pages %llu\n",
+			  limit, limit,
+			  MEMCOMP_DIRECT_COMP_BUDGET,
+			  budget.active, budget.background_active,
+			  0U, budget.peak,
+			  budget.background_peak, 0U, waiters,
+			  budget_pages, budget_reject, budget_reject_pages,
+			  kswapd_wait,
+			  staging_count, staging_free, staging_active,
+			  staging_peak,
+			  (u64)atomic64_read(&memcomp_direct_staging_miss),
+			  (u64)atomic64_read(&memcomp_direct_staging_detach),
+			  refresh_cross_node_pages);
+}
+
+static ssize_t mc16_metadata_events_show(char *buf, ssize_t at)
+{
+	unsigned long retained = READ_ONCE(mc16_retained_empty_headers);
+	u64 count_calls = 0, scan_calls = 0, detached = 0;
+	u64 aging_calls = 0, aging_detached = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct mc16_storage_debug *debug;
+
+		debug = per_cpu_ptr(&mc16_storage_debug, cpu);
+		count_calls += READ_ONCE(debug->meta_count_calls);
+		scan_calls += READ_ONCE(debug->meta_scan_calls);
+		detached += READ_ONCE(debug->meta_detached);
+		aging_calls += READ_ONCE(debug->aging_work_calls);
+		aging_detached += READ_ONCE(debug->aging_detached);
+	}
+	return at + sysfs_emit_at(buf, at,
+		"meta_shrinker_registered %u\n"
+		"meta_shrinker_count_calls %llu\n"
+		"meta_shrinker_scan_calls %llu\n"
+		"meta_shrinker_detached_headers %llu\n"
+		"retained_empty_headers %lu\n"
+		"retained_empty_header_bytes %lu\n"
+		"aging_work_calls %llu\n"
+		"aging_detached_headers %llu\n",
+		!!memcomp_meta_shrinker, count_calls, scan_calls, detached,
+		retained, retained * kmalloc_size_roundup(sizeof(struct mc16_cluster)),
+		aging_calls, aging_detached);
+}
+
+static ssize_t execution_events_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	return mc16_metadata_events_show(buf,
+		memcomp_span_events_show(buf, __execution_events_show(buf)));
+}
+
+static ssize_t admission_events_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	u64 early_reject = atomic64_read(&memcomp_reclaim_ctx_early_reject);
+	u64 early_reject_pages =
+		atomic64_read(&memcomp_reclaim_ctx_early_reject_pages);
+
+	return sysfs_emit(buf,
+			  "reclaim_ctx_early_reject %llu\n"
+			  "reclaim_ctx_early_reject_pages %llu\n",
+			  early_reject, early_reject_pages);
+}
+#endif
+
+static struct kobj_attribute stat_attr = __ATTR_RO(stat);
+static struct kobj_attribute compressor_attr = __ATTR_RO(compressor);
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static struct kobj_attribute placement_events_attr =
+	__ATTR_RO(placement_events);
+static struct kobj_attribute events_attr = __ATTR_RO(events);
+static struct kobj_attribute admission_events_attr =
+	__ATTR_RO(admission_events);
+static struct kobj_attribute context_events_attr = __ATTR_RO(context_events);
+static struct kobj_attribute context_sources_attr = __ATTR_RO(context_sources);
+static struct kobj_attribute execution_events_attr =
+	__ATTR_RO(execution_events);
+#endif
+
+static struct attribute *memcomp_attrs[] = {
+	&stat_attr.attr,
+	&compressor_attr.attr,
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	&placement_events_attr.attr,
+	&events_attr.attr,
+	&admission_events_attr.attr,
+	&context_events_attr.attr,
+	&context_sources_attr.attr,
+	&execution_events_attr.attr,
+#endif
+	NULL,
+};
+
+static const struct attribute_group memcomp_attr_group = {
+	.name = "memcomp",
+	.attrs = memcomp_attrs,
+};
+
+static int __init memcomp_sysfs_init(void)
+{
+	if (!mm_kobj)
+		return -EINVAL;
+
+	return sysfs_create_group(mm_kobj, &memcomp_attr_group);
+}
+subsys_initcall(memcomp_sysfs_init);
+#endif
diff --git a/mm/memcomp/access.h b/mm/memcomp/access.h
new file mode 100644
index 0000000000000000000000000000000000000000..f9916937c1e267ed88eafa49c4b5a8fba5e9ada5
--- /dev/null
+++ b/mm/memcomp/access.h
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_ACCESS_H
+#define _MM_MEMCOMP_ACCESS_H
+
+/* A borrowed view is valid under T, or for the unique refs-zero finalizer. */
+struct mc16_view {
+	struct mc16_record *record;
+	struct mc16_member *member;
+	u64 *word;
+	u16 *length;
+	u16 *flags;
+};
+
+static inline bool mc16_view_owned(struct memcomp_ref *ref, struct mc16_view *view)
+{
+	struct mc16_record *record;
+	u32 index;
+
+	*view = (struct mc16_view) { };
+	if (mc16_flags_state(ref->slot->flags) != MC16_PENDING) {
+		view->word = &ref->slot->word;
+		view->length = &ref->slot->length;
+		view->flags = &ref->slot->flags;
+		return true;
+	}
+	record = (void *)(unsigned long)ref->slot->word;
+	if (WARN_ON_ONCE(!mc16_member_index(record, ref->token, &index)))
+		return false;
+	view->record = record;
+	view->member = &record->member[index];
+	view->word = &view->member->word;
+	view->length = &view->member->length;
+	view->flags = &view->member->flags;
+	return true;
+}
+
+static inline bool mc16_view_locked(struct memcomp_ref *ref, struct mc16_view *view)
+{
+	lockdep_assert_held(memcomp_lock_of(ref->token));
+	return mc16_view_owned(ref, view);
+}
+
+/*
+ * Transfer the attached member to a private detach tail. The tail consumes
+ * its own saved fields before exactly one member put, outside T if desired.
+ * A payload's charge/ownership transfers to the stable slot, never to tail.
+ */
+static inline struct mc16_record *mc16_normalize_locked(struct memcomp_ref *ref)
+{
+	struct mc16_view view;
+	unsigned int state;
+	u16 flags;
+
+	if (!mc16_view_locked(ref, &view) || !view.record)
+		return NULL;
+	flags = *view.flags;
+	state = mc16_flags_state(flags);
+	if ((flags & (MC16_F_OWNER | MC16_F_RESIDENT)) ||
+	    state == MC16_PENDING || state == MC16_EMPTY)
+		return NULL;
+	ref->slot->word = *view.word;
+	ref->slot->length = *view.length;
+	/* Immutable SAMEFILL readers pair with this release publication. */
+	smp_store_release(&ref->slot->flags, flags);
+	view.member->payload_charge = 0;
+	return view.record;
+}
+
+static inline bool
+mc16_owner_matches_locked(struct memcomp_ref *ref, struct folio *folio,
+			  unsigned int nr_pages, unsigned int page_idx)
+{
+	struct mc16_view view;
+	u32 index;
+
+	if (!mc16_view_locked(ref, &view) || !view.record ||
+	    !mc16_member_index(view.record, ref->token, &index))
+		return false;
+	return (*view.flags & MC16_F_OWNER) &&
+		view.member->owner_folio == folio &&
+		view.record->nr_pages == nr_pages && index == page_idx;
+}
+
+/*
+ * Sole refs-zero winner only. Call state/FIFO/stat retirement before this
+ * helper, while the slot and cluster are still live. It frees the payload
+ * synchronously; the caller then invokes mc16_retire_slot() exactly once.
+ * No T is acquired, so PTL/atomic final puts remain legal.
+ */
+static inline void mc16_release_resources(struct memcomp_ref *ref)
+{
+	struct mc16_view view;
+	struct obj_cgroup *objcg;
+	unsigned int state;
+	u32 charge = 0;
+
+	if (WARN_ON_ONCE(refcount_read(&ref->slot->refs)) ||
+	    !mc16_view_owned(ref, &view))
+		return;
+	state = mc16_flags_state(*view.flags);
+	objcg = view.record ? view.record->objcg : ref->cluster->key->objcg;
+	if (view.member) {
+		charge = view.member->payload_charge;
+	} else if (objcg && (state == MC16_STORED || state == MC16_WRITEBACK)) {
+		if (WARN_ON_ONCE(!mc16_length_decode(*view.length, &charge)))
+			return;
+	}
+	if (state == MC16_STORED || state == MC16_WRITEBACK) {
+		memcomp_zs_free(0, *view.word);
+	} else if (state == MC16_SWAPPED) {
+#ifdef CONFIG_SWAP
+		struct mc16_swap_fields swap;
+
+		if (WARN_ON_ONCE(!mc16_swap_decode(*view.word, *view.length, &swap)))
+			return;
+		if (swap.packed)
+			memcomp_slot_put_packed(swp_entry(swap.type, swap.swap_offset));
+		else
+			memcomp_slot_put(swp_entry(swap.type, swap.swap_offset));
+#endif
+	}
+	memcomp_objcg_uncharge(objcg, charge);
+	if (*view.flags & MC16_F_RESIDENT) {
+		if (WARN_ON_ONCE(!view.member || !view.member->owner_folio))
+			return;
+		folio_put(view.member->owner_folio);
+	}
+	/* This is the final access to record/member by this owner. */
+	if (view.record)
+		mc16_record_member_put(view.record);
+}
+#endif /* _MM_MEMCOMP_ACCESS_H */
diff --git a/mm/memcomp/anon_folio.h b/mm/memcomp/anon_folio.h
new file mode 100644
index 0000000000000000000000000000000000000000..a1ee0f272b1b8a8ab1cb490851c8cd8e075aef82
--- /dev/null
+++ b/mm/memcomp/anon_folio.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_ANON_FOLIO_H
+#define _MM_MEMCOMP_ANON_FOLIO_H
+
+/* Caller owns the context lease; the shared finish tail consumes it. */
+static inline bool
+mc16_anon_store_internal(struct folio *folio,
+			 struct memcomp_reclaim_ctx **ctxp,
+			 struct memcomp_store_ctx *store,
+			 enum memcomp_anon_store_fail *failure)
+{
+	struct memcomp_ref refs[MEMCOMP_MAX_COMPRESS_PAGES];
+	unsigned int nr_pages = folio_nr_pages(folio), old_nr = 1, i;
+	struct memcomp_ref head;
+	unsigned long token;
+	u32 base;
+	bool has_anon_vma;
+	void *src;
+	int ret;
+
+	lockdep_assert_held(&(*ctxp)->lock);
+	if (store)
+		store->zero = (struct mc16_zero_carrier) { };
+	*failure = MEMCOMP_ANON_STORE_PREFLIGHT;
+	if (!folio_test_locked(folio))
+		return false;
+	if (folio_mapped(folio)) {
+		*failure = MEMCOMP_ANON_STORE_FOLIO_BUSY;
+		return false;
+	}
+	if (!nr_pages || nr_pages > MEMCOMP_MAX_COMPRESS_PAGES ||
+	    !folio_test_anon(folio) || !folio_test_swapbacked(folio) ||
+	    folio_test_mlocked(folio) || folio_mapping(folio) ||
+	    folio_test_swapcache(folio) || !is_memcomp_entry(folio->swap))
+		return false;
+	token = swp_offset(folio->swap);
+	if (!token || token > U32_MAX)
+		return false;
+	if (folio_test_large(folio) && mc16_get(token, &head)) {
+		old_nr = mc16_ref_geometry(&head, &base, NULL);
+		if (old_nr)
+			token = base;
+		mc16_ref_put(&head);
+	}
+	if (old_nr != nr_pages ||
+	    !mc16_span_get(token, folio, nr_pages, true, refs))
+		return false;
+	if (folio_maybe_dma_pinned(folio) ||
+	    folio_ref_count(folio) != 1 + nr_pages || folio_mapped(folio)) {
+		*failure = MEMCOMP_ANON_STORE_FOLIO_BUSY;
+		ret = -EBUSY;
+		goto out;
+	}
+	if (memcomp_arch_prepare_to_swap(folio)) {
+		*failure = MEMCOMP_ANON_STORE_ARCH;
+		ret = -EIO;
+		goto out;
+	}
+	src = kmap_local_folio(folio, 0);
+	ret = mc16_anon_refresh_full(ctxp, src, nr_pages, store, refs,
+				     &has_anon_vma);
+	kunmap_local(src);
+	if (!ret && has_anon_vma) {
+		mutex_lock(memcomp_lock_of(refs[0].token));
+		store->anon_vma = mc16_span_take_anon_vma_locked(&refs[0], folio,
+								 nr_pages);
+		mutex_unlock(memcomp_lock_of(refs[0].token));
+	} else if (ret) {
+		*failure = MEMCOMP_ANON_STORE_REFRESH;
+		if (ret == -E2BIG) {
+			struct mc16_view view;
+
+			mutex_lock(memcomp_lock_of(refs[0].token));
+			if (mc16_view_locked(&refs[0], &view) && view.record)
+				*view.flags |= MC16_F_INCOMPRESSIBLE;
+			mutex_unlock(memcomp_lock_of(refs[0].token));
+		}
+	}
+out:
+	for (i = 0; i < nr_pages; i++)
+		mc16_ref_put(&refs[i]);
+	return !ret;
+}
+#endif /* _MM_MEMCOMP_ANON_FOLIO_H */
diff --git a/mm/memcomp/anon_store.h b/mm/memcomp/anon_store.h
new file mode 100644
index 0000000000000000000000000000000000000000..110c315cbcad938385f826d77067adc5f661f190
--- /dev/null
+++ b/mm/memcomp/anon_store.h
@@ -0,0 +1,245 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_ANON_STORE_H
+#define _MM_MEMCOMP_ANON_STORE_H
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static DEFINE_PER_CPU(u64, mc16_refresh_cross_node_pages);
+#endif
+
+/* Placement hint only: store remains responsible for payload validation. */
+static inline bool mc16_folio_zero_hint(struct folio *folio)
+{
+	unsigned int i;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	for (i = 0; i < folio_nr_pages(folio); i++) {
+		void *src = kmap_local_folio(folio, i * PAGE_SIZE);
+		bool zero = !memchr_inv(src, 0, PAGE_SIZE);
+
+		kunmap_local(src);
+		if (!zero)
+			return false;
+	}
+	return true;
+}
+
+/* Called in the existing successful payload-commit T critical section. */
+static inline void
+mc16_zero_carrier_prepare_locked(struct memcomp_store_ctx *store,
+				 struct memcomp_ref *ref, unsigned int nr_pages)
+{
+	struct mc16_view view;
+
+	if (!store)
+		return;
+	store->zero = (struct mc16_zero_carrier) { };
+	lockdep_assert_held(memcomp_lock_of(ref->token));
+	if (nr_pages != 1 || !mc16_view_locked(ref, &view) ||
+	    !mc16_flags_valid(*view.flags) ||
+	    mc16_flags_state(*view.flags) != MC16_SAMEFILL ||
+	    (*view.flags & (MC16_F_RESIDENT | MC16_F_REFRESH_PENDING)) ||
+	    *view.word || *view.length)
+		return;
+	store->zero = (struct mc16_zero_carrier) {
+		.ref = *ref, .token = ref->token, .valid = true, .ready = true,
+	};
+}
+
+/* Success transfers anon_vma; failure leaves its hold with the caller. */
+static inline int
+mc16_anon_reserve(struct folio *folio, unsigned int nr_pages,
+		  struct anon_vma *anon_vma, unsigned long *token)
+{
+	struct memcomp_ref refs[MEMCOMP_MAX_COMPRESS_PAGES];
+	struct mc16_record *record;
+	unsigned int i;
+	bool zero_hint;
+	int ret;
+
+	if (!token || !folio || nr_pages != folio_nr_pages(folio))
+		return -EINVAL;
+	if (!memcomp_is_enabled())
+		return -EOPNOTSUPP;
+	zero_hint = mc16_folio_zero_hint(folio);
+	record = mc16_record_alloc(folio, nr_pages, false);
+	if (IS_ERR(record)) {
+		memcomp_debug_inc(&memcomp_reserve_entry_alloc_fail);
+		return PTR_ERR(record);
+	}
+	record->anon_vma = anon_vma;
+	if (anon_vma)
+		record->record_flags |= MC16_RECORD_ANON_VMA;
+	ret = mc16_reserve_hint(record, nr_pages, MC16_KEY_ANON,
+				zero_hint, refs);
+	if (ret) {
+		/* No published member and no transfer of the caller's hold. */
+		record->anon_vma = NULL;
+		record->record_flags &= ~MC16_RECORD_ANON_VMA;
+		mc16_record_abort(record);
+		return ret;
+	}
+	for (i = 0; i < nr_pages; i++)
+		mc16_account_reservation(&refs[i]);
+	/* These are the initial folio-owner references, not lookup guards. */
+	*token = refs[0].token;
+	return 0;
+}
+
+static inline int
+mc16_refresh_validate(struct memcomp_ref *ref, struct folio **folio,
+		      unsigned int nr_pages, unsigned int index,
+		      bool *has_anon_vma)
+{
+	struct mc16_view view;
+	int ret = 0;
+
+	mutex_lock(memcomp_lock_of(ref->token));
+	if (!mc16_view_locked(ref, &view) || !view.record ||
+	    view.record->nr_pages != nr_pages ||
+	    ref->token - view.record->token_base != index) {
+		ret = -EIO;
+	} else if (!mc16_flags_valid(*view.flags) ||
+		   mc16_flags_state(*view.flags) != MC16_PENDING ||
+		   (*view.flags & (MC16_F_RESIDENT | MC16_F_OWNER)) !=
+				 (MC16_F_RESIDENT | MC16_F_OWNER) ||
+		   !view.member->owner_folio) {
+		ret = -EAGAIN;
+	} else if (*folio && view.member->owner_folio != *folio) {
+		ret = -EIO;
+	} else {
+		*folio = view.member->owner_folio;
+		if (has_anon_vma)
+			*has_anon_vma = view.record->record_flags &
+					MC16_RECORD_ANON_VMA;
+	}
+	mutex_unlock(memcomp_lock_of(ref->token));
+	return ret;
+}
+
+static inline int mc16_refresh_commit_error(struct memcomp_store_ctx *store)
+{
+	return 0;
+}
+
+/*
+ * The caller owns one lookup guard per member and the locked source folio.
+ * The shared codec helper retains its context/staging lease-transfer rules.
+ * Validation and each commit hold T; all
+ * preparation/charge/old-payload release runs outside T. A partial commit
+ * leaves completed members in place for the existing folio rollback walk.
+ */
+static inline int
+mc16_anon_refresh_full(struct memcomp_reclaim_ctx **ctxp, const void *src,
+		       unsigned int nr_pages, struct memcomp_store_ctx *store,
+		       struct memcomp_ref *refs, bool *has_anon_vma)
+{
+	struct mc16_payload payloads[MEMCOMP_MAX_COMPRESS_PAGES] = { };
+	unsigned int lengths[MEMCOMP_MAX_COMPRESS_PAGES] = { };
+	struct mc16_payload_tail tail = { };
+	struct folio *folio = NULL;
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	unsigned int nr_raw = 0;
+#endif
+	unsigned int i;
+	bool held_anon_vma = false;
+	int ret;
+
+	if (store)
+		store->zero = (struct mc16_zero_carrier) { };
+	if (has_anon_vma)
+		*has_anon_vma = false;
+	if (!ctxp || !*ctxp || !src || !refs || !nr_pages ||
+	    nr_pages > MEMCOMP_MAX_COMPRESS_PAGES || !is_power_of_2(nr_pages))
+		return -EINVAL;
+	if (!memcomp_is_enabled())
+		return -EOPNOTSUPP;
+	lockdep_assert_held(&(*ctxp)->lock);
+	/* Check the complete caller-owned array before any cleanup can use it. */
+	for (i = 0; i < nr_pages; i++) {
+		if (!refs[i].slot)
+			return -EINVAL;
+	}
+	for (i = 0; i < nr_pages; i++) {
+		ret = mc16_refresh_validate(&refs[i], &folio, nr_pages, i,
+					    i ? NULL : &held_anon_vma);
+		if (ret)
+			goto state_fail;
+	}
+	for (i = 0; i < nr_pages; i++) {
+		unsigned long handle = 0;
+		u8 pool = 0;
+
+		ret = memcomp_prepare_payload_locked(ctxp, src + i * PAGE_SIZE,
+						     PAGE_SIZE, &lengths[i], &handle,
+						     &pool, nr_pages > 1,
+						     nr_pages == 1 ? store : NULL);
+		if (ret)
+			goto payload_fail;
+		payloads[i].word = handle;
+		payloads[i].bytes = lengths[i];
+	}
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	nr_raw = memcomp_raw_payload_count(lengths, nr_pages);
+#endif
+	if (!memcomp_payloads_net_reclaimable(lengths, nr_pages)) {
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+		memcomp_debug_add(nr_raw, &memcomp_raw_reject_net);
+#endif
+		ret = -E2BIG;
+		goto payload_fail;
+	}
+	for (i = 0; i < nr_pages; i++) {
+		ret = mc16_payload_charge(&refs[i], &payloads[i]);
+		if (ret)
+			goto out;
+	}
+	for (i = 0; i < nr_pages; i++) {
+		ret = mc16_refresh_commit_error(store);
+		if (ret)
+			goto state_fail;
+		mutex_lock(memcomp_lock_of(refs[i].token));
+		ret = mc16_payload_commit_locked(&refs[i], folio, nr_pages, i,
+						 &payloads[i], &tail);
+		if (!ret)
+			mc16_zero_carrier_prepare_locked(store, &refs[i], nr_pages);
+		mutex_unlock(memcomp_lock_of(refs[i].token));
+		if (ret)
+			goto state_fail;
+		/* The reserved node is immutable even if the folio migrated. */
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+		if (refs[i].cluster->key->nid != folio_nid(folio))
+			this_cpu_inc(mc16_refresh_cross_node_pages);
+#endif
+		mc16_payload_finish(&refs[i], &tail);
+	}
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	memcomp_debug_add(nr_raw, &memcomp_raw_store);
+#endif
+	if (has_anon_vma)
+		*has_anon_vma = held_anon_vma;
+	ret = 0;
+	goto out;
+payload_fail:
+	memcomp_debug_inc(&memcomp_refresh_payload_fail);
+	memcomp_debug_add(nr_pages, &memcomp_refresh_payload_fail_pages);
+	goto out;
+state_fail:
+	memcomp_debug_inc(&memcomp_refresh_state_fail);
+	memcomp_debug_add(nr_pages, &memcomp_refresh_state_fail_pages);
+out:
+	if (ret && store)
+		store->zero = (struct mc16_zero_carrier) { };
+	for (i = 0; i < nr_pages; i++)
+		mc16_payload_abort(&refs[i], &payloads[i]);
+	return ret;
+}
+
+/* Direct refresh callers do not transfer the producer's anon_vma hold. */
+static inline int
+mc16_anon_refresh(struct memcomp_reclaim_ctx **ctxp, const void *src,
+		  unsigned int nr_pages, struct memcomp_store_ctx *store,
+		  struct memcomp_ref *refs)
+{
+	return mc16_anon_refresh_full(ctxp, src, nr_pages, store, refs, NULL);
+}
+#endif /* _MM_MEMCOMP_ANON_STORE_H */
diff --git a/mm/memcomp/api.h b/mm/memcomp/api.h
new file mode 100644
index 0000000000000000000000000000000000000000..5e49d8484f0a303533f5ae04e0477960775c3512
--- /dev/null
+++ b/mm/memcomp/api.h
@@ -0,0 +1,149 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_API_H
+#define _MM_MEMCOMP_API_H
+
+/* Public dispatch uses clustered slots; a miss never probes another table. */
+bool memcomp_entry_get_ref(unsigned long token, struct memcomp_ref *ref)
+{
+	return mc16_get(token, ref);
+}
+
+void memcomp_entry_put_ref(struct memcomp_ref *ref)
+{
+	if (ref->slot)
+		mc16_ref_put(ref);
+}
+
+bool memcomp_entry_get(unsigned long token)
+{
+	return mc16_pte_get(token);
+}
+
+void memcomp_invalidate(unsigned long token)
+{
+	mc16_pte_put_nr(token, 1);
+}
+
+void memcomp_invalidate_nr(unsigned long token, unsigned int nr)
+{
+	mc16_pte_put_nr(token, nr);
+}
+
+bool memcomp_entry_present(unsigned long token)
+{
+	return mc16_entry_present(token);
+}
+
+bool memcomp_entry_stat(unsigned long token, unsigned long *compressed,
+			int *mapcount)
+{
+	return mc16_entry_stat(token, compressed, mapcount);
+}
+
+unsigned int memcomp_entry_nr_pages(unsigned long token, unsigned long *base)
+{
+	return mc16_entry_nr_pages(token, base);
+}
+
+int memcomp_entry_resident_get(unsigned long token, struct memcomp_ref *ref)
+{
+	return mc16_entry_resident_get(token, ref);
+}
+
+void memcomp_entry_resident_put(struct memcomp_ref *ref)
+{
+	mc16_entry_resident_put(ref);
+}
+
+int memcomp_entry_resident(unsigned long token)
+{
+	struct memcomp_ref ref;
+	int ret;
+
+	ret = mc16_entry_resident_get(token, &ref);
+	mc16_entry_resident_put(&ref);
+	return ret;
+}
+
+static bool mc16_refresh_pending(unsigned long token, bool pending)
+{
+	struct memcomp_ref ref;
+	struct mc16_view view;
+	bool valid;
+
+	if (!mc16_get(token, &ref))
+		return false;
+	mutex_lock(memcomp_lock_of(ref.token));
+	valid = mc16_view_locked(&ref, &view) && mc16_flags_valid(*view.flags);
+	if (valid) {
+		if (pending)
+			*view.flags |= MC16_F_REFRESH_PENDING;
+		else
+			*view.flags &= ~MC16_F_REFRESH_PENDING;
+	}
+	mutex_unlock(memcomp_lock_of(ref.token));
+	mc16_ref_put(&ref);
+	return valid;
+}
+
+bool memcomp_entry_set_refresh_pending(unsigned long token)
+{
+	return mc16_refresh_pending(token, true);
+}
+
+void memcomp_entry_clear_refresh_pending(unsigned long token)
+{
+	mc16_refresh_pending(token, false);
+}
+
+bool memcomp_reserve(struct folio *folio)
+{
+	return mc16_reserve_folio(folio);
+}
+
+void memcomp_invalidate_folio(struct folio *folio)
+{
+	mc16_invalidate_folio(folio);
+}
+
+bool memcomp_release_folio(struct folio *folio)
+{
+	return mc16_release_folio(folio);
+}
+
+void memcomp_rollback_folio(struct folio *folio)
+{
+	mc16_rollback_folio(folio);
+}
+
+int memcomp_migrate_folio(struct folio *dst, struct folio *src)
+{
+	return mc16_migrate_folio(dst, src);
+}
+
+void memcomp_migrate_folio_rollback(struct folio *dst, struct folio *src)
+{
+	mc16_migrate_folio_rollback(dst, src);
+}
+
+vm_fault_t memcomp_load(struct vm_fault *vmf, bool *locked)
+{
+	return mc16_load(vmf, locked);
+}
+
+int memcomp_restore_resident(struct vm_fault *vmf, struct memcomp_ref *ref)
+{
+	vm_fault_t ret;
+	bool handled;
+
+	if (!ref->slot)
+		return -EFAULT;
+	ret = mc16_load_resident(vmf, ref, &handled);
+	if (!handled) {
+		mc16_ref_put(ref);
+		return 0;
+	}
+	return (ret & VM_FAULT_SIGBUS) ? -EFAULT : 0;
+}
+
+#endif /* _MM_MEMCOMP_API_H */
diff --git a/mm/memcomp/consumers.h b/mm/memcomp/consumers.h
new file mode 100644
index 0000000000000000000000000000000000000000..929c046bf98d52c878e727e14d859d81c871b743
--- /dev/null
+++ b/mm/memcomp/consumers.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_CONSUMERS_H
+#define _MM_MEMCOMP_CONSUMERS_H
+
+#include <linux/highmem.h>
+
+/*
+ * Include after load.h and zero.h, with memcomp_arch_restore() available.
+ * load.h must touch MC16_F_REFERENCED in its existing T critical section.
+ * These adapters do not publish PTEs or replace page-cache xarray entries.
+ */
+
+/* Parent PTL protects its owner; the new reference becomes the child PTE's. */
+static inline bool mc16_pte_get(unsigned long token)
+{
+	struct memcomp_ref ref;
+
+	if (!token)
+		return mc16_zero_pte_get(1);
+	/* Successful lookup ownership transfers directly to the new PTE. */
+	return mc16_get(token, &ref);
+}
+
+/*
+ * Caller already removed nr PTE owners. Positive tokens name consecutive
+ * slots; zero names nr logical PTEs in the zero domain. Reject an invalid
+ * positive range in full before consuming anything; absent slots are skipped.
+ */
+static inline void mc16_pte_put_nr(unsigned long token, unsigned int nr)
+{
+	struct memcomp_ref ref;
+	unsigned int i;
+
+	if (!nr)
+		return;
+	if (!token) {
+		mc16_zero_pte_put(nr);
+		return;
+	}
+	if (token > U32_MAX || nr - 1 > U32_MAX - token)
+		return;
+	for (i = 0; i < nr; i++) {
+		if (mc16_get(token + i, &ref))
+			mc16_ref_put_count(&ref, 2); /* lookup + removed PTE */
+	}
+}
+
+/* The caller removed one cache owner, independently of any PTE owner. */
+
+/* Empty output on failure, including token0; caller handles zero explicitly. */
+
+/*
+ * Keep this same guard through load and the caller's xarray transaction.
+ * Failure leaves both the guard and cache owner intact for abort/retry.
+ */
+
+/* Only the winner replacing the expected cache shadow may consume its owner. */
+
+/*
+ * Explicit token0 branch: no guard, lookup or owner consumption. After the
+ * expected zero shadow is replaced successfully, caller must cache_drop(0).
+ * An aborted xarray transaction leaves the zero cache owner unchanged.
+ */
+#endif /* _MM_MEMCOMP_CONSUMERS_H */
diff --git a/mm/memcomp/fault.h b/mm/memcomp/fault.h
new file mode 100644
index 0000000000000000000000000000000000000000..b83ee7011aedf754173dd90034be3d6d25536414
--- /dev/null
+++ b/mm/memcomp/fault.h
@@ -0,0 +1,254 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_FAULT_H
+#define _MM_MEMCOMP_FAULT_H
+
+/*
+ * Include after zero_load.h, memcomp_fault_sigbus_or_retry(), and the
+ * resident actor. span.h/load.h and the generic THP/PTE helpers must be visible.
+ * Caller has the same mmap/rmap preparation as the existing memcomp_load().
+ * Resident handled=true consumes ref on every return; false retains it.
+ * Stable non-PENDING slots bypass that actor without another T acquisition.
+ */
+static inline vm_fault_t mc16_load_resident(struct vm_fault *vmf,
+					    struct memcomp_ref *ref, bool *handled);
+
+static inline vm_fault_t mc16_load(struct vm_fault *vmf, bool *locked)
+{
+	const unsigned int max_pages = MEMCOMP_MAX_COMPRESS_PAGES;
+	struct vm_area_struct *vma = vmf->vma;
+	swp_entry_t swp = pte_to_swp_entry(vmf->orig_pte);
+	unsigned long id = swp_offset(swp);
+	struct memcomp_ref refs[MEMCOMP_MAX_COMPRESS_PAGES] = { };
+	unsigned int nr_pages = 1, fault_index = 0, i;
+	unsigned long start_addr = vmf->address, id_start = id;
+	struct folio *folio = NULL;
+	pte_t *install_pte;
+	vm_fault_t ret = 0;
+	gfp_t alloc_gfp;
+	void *dst;
+	pte_t pte;
+	int err;
+
+	if (locked)
+		*locked = false;
+	if (!is_memcomp_entry(swp))
+		return VM_FAULT_SIGBUS;
+	if (!id)
+		return mc16_load_zero(vmf, locked);
+	if (!mc16_get(id, &refs[0]))
+		return memcomp_fault_sigbus_or_retry(vmf);
+
+	/* Stable tags never become PENDING; the resident actor validates under T. */
+	if (is_cow_mapping(vma->vm_flags) && vma->anon_vma &&
+	    mc16_flags_state(READ_ONCE(refs[0].slot->flags)) == MC16_PENDING) {
+		bool handled;
+
+		ret = mc16_load_resident(vmf, &refs[0], &handled);
+		if (handled)
+			return ret;
+	}
+
+	if (!userfaultfd_armed(vma) && vma_is_anonymous(vma) && vma->anon_vma) {
+		unsigned int encoded_pages, encoded_idx, order;
+		unsigned long base_addr, max_end, orders;
+		pte_t *start_pte;
+		u32 base_id;
+
+		encoded_pages = mc16_ref_geometry(&refs[0], &base_id, &encoded_idx);
+		if (encoded_pages <= 1 || encoded_pages > max_pages ||
+		    encoded_idx >= encoded_pages || id < encoded_idx || !base_id ||
+		    base_id > U32_MAX - (encoded_pages - 1) ||
+		    !is_power_of_2(encoded_pages))
+			goto fallback_single;
+		if (vmf->address < ((unsigned long)encoded_idx << PAGE_SHIFT))
+			goto fallback_single;
+		base_addr = vmf->address - ((unsigned long)encoded_idx << PAGE_SHIFT);
+		max_end = pmd_addr_end(vmf->address, vma->vm_end);
+		if (base_addr < max(vmf->address & PMD_MASK, vma->vm_start) ||
+		    base_addr < vma->vm_start ||
+		    base_addr + ((unsigned long)encoded_pages << PAGE_SHIFT) > max_end)
+			goto fallback_single;
+		orders = thp_vma_allowable_orders(vma, vma->vm_flags,
+						  TVA_IN_PF | TVA_ENFORCE_SYSFS,
+						  BIT(PMD_ORDER) - 1);
+		orders = thp_vma_suitable_orders(vma, vmf->address, orders);
+		order = order_base_2(encoded_pages);
+		if (!(orders & BIT(order)))
+			goto fallback_single;
+		if (!memcomp_pte_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
+					  &vmf->pte, &vmf->ptl))
+			goto out_put;
+		if (!pte_same(ptep_get(vmf->pte), vmf->orig_pte))
+			goto out_unlock;
+		start_pte = vmf->pte - encoded_idx;
+		if (!pte_same(ptep_get(start_pte),
+			      pte_move_swp_offset(vmf->orig_pte, -(int)encoded_idx)) ||
+		    memcomp_pte_batch(start_pte, encoded_pages) != encoded_pages) {
+			pte_unmap_unlock(vmf->pte, vmf->ptl);
+			vmf->pte = NULL;
+			goto fallback_single;
+		}
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		vmf->pte = NULL;
+		nr_pages = encoded_pages;
+		fault_index = encoded_idx;
+		start_addr = base_addr;
+		id_start = base_id;
+		goto fallback_alloc;
+	}
+
+fallback_single:
+	nr_pages = 1;
+	fault_index = 0;
+	start_addr = vmf->address;
+	id_start = id;
+fallback_alloc:
+	alloc_gfp = memcomp_fault_alloc_gfp(vma, nr_pages);
+	folio = vma_alloc_folio(alloc_gfp, order_base_2(nr_pages),
+				vma, start_addr, false);
+	if (!folio) {
+		if (nr_pages > 1)
+			goto fallback_single;
+		ret = VM_FAULT_OOM;
+		goto out_put;
+	}
+		err = mem_cgroup_charge(folio, vma->vm_mm, alloc_gfp);
+	if (err) {
+		if (nr_pages > 1) {
+			folio_put(folio);
+			folio = NULL;
+			goto fallback_single;
+		}
+		ret = VM_FAULT_OOM;
+		goto out_put;
+	}
+	__folio_set_locked(folio);
+	if (locked)
+		*locked = true;
+	__folio_set_swapbacked(folio);
+	folio->swap.val = 0;
+	if (nr_pages > 1) {
+		struct memcomp_ref fault_ref = refs[0];
+		bool batch_ok = true;
+
+		refs[0] = (struct memcomp_ref) { };
+		refs[fault_index] = fault_ref;
+		for (i = 0; i < nr_pages; i++) {
+			if (i != fault_index && !mc16_get(id_start + i, &refs[i])) {
+				batch_ok = false;
+				break;
+			}
+		}
+		for (i = 0; batch_ok && i < nr_pages; i++) {
+			unsigned int index;
+			u32 base;
+
+			if (mc16_ref_geometry(&refs[i], &base, &index) != nr_pages ||
+			    base != id_start || index != i)
+				batch_ok = false;
+		}
+		if (!batch_ok) {
+			for (i = 0; i < nr_pages; i++) {
+				if (i != fault_index && refs[i].slot)
+					mc16_ref_put(&refs[i]);
+			}
+			refs[fault_index] = (struct memcomp_ref) { };
+			refs[0] = fault_ref;
+			folio_unlock(folio);
+			folio_put(folio);
+			folio = NULL;
+			if (locked)
+				*locked = false;
+			goto fallback_single;
+		}
+	}
+	/* A local highmem mapping covers one page, even for a large folio. */
+	for (i = 0, err = 0; i < nr_pages; i++) {
+		dst = kmap_local_folio(folio, i * PAGE_SIZE);
+		err = mc16_load_page(&refs[i], dst);
+		kunmap_local(dst);
+		if (err)
+			break;
+	}
+	if (err) {
+		if (err == -EAGAIN)
+			ret = 0;
+		else if (err == -ENOMEM)
+			ret = VM_FAULT_OOM;
+		else
+			ret = memcomp_fault_sigbus_or_retry(vmf);
+		goto out_put;
+	}
+	memcomp_arch_restore(id_start, folio);
+	__folio_mark_uptodate(folio);
+	/* No T survives mc16_load_page; PTL is acquired only after it returns. */
+	if (!memcomp_pte_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
+				  &vmf->pte, &vmf->ptl))
+		goto out_put;
+	if (!pte_same(ptep_get(vmf->pte), vmf->orig_pte))
+		goto out_unlock;
+	install_pte = vmf->pte;
+	if (nr_pages > 1) {
+		install_pte -= fault_index;
+		if (!pte_same(ptep_get(install_pte),
+			      pte_move_swp_offset(vmf->orig_pte, -(int)fault_index)) ||
+		    memcomp_pte_batch(install_pte, nr_pages) != nr_pages)
+			goto out_unlock;
+		for (i = 0; i < nr_pages; i++) {
+			swp_entry_t cur = pte_to_swp_entry(ptep_get(install_pte + i));
+
+			if (!is_memcomp_entry(cur) || swp_offset(cur) != id_start + i)
+				goto out_unlock;
+		}
+	}
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
+	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -(int)nr_pages);
+	pte = mk_pte(folio_page(folio, 0), vma->vm_page_prot);
+	if (pte_swp_soft_dirty(vmf->orig_pte))
+		pte = pte_mksoft_dirty(pte);
+	if (pte_swp_uffd_wp(vmf->orig_pte))
+		pte = pte_mkuffd_wp(pte);
+	if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
+	    !pte_needs_soft_dirty_wp(vma, pte)) {
+		pte = pte_mkwrite(pte, vma);
+		if (vmf->flags & FAULT_FLAG_WRITE)
+			pte = pte_mkdirty(pte);
+	}
+	flush_icache_pages(vma, folio_page(folio, 0), nr_pages);
+	folio_add_new_anon_rmap(folio, vma, start_addr, RMAP_EXCLUSIVE);
+	folio_add_lru_vma(folio, vma);
+	folio_ref_add(folio, nr_pages - 1);
+	if (nr_pages > 1)
+		set_ptes(vma->vm_mm, start_addr, install_pte, pte, nr_pages);
+	else
+		set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
+	arch_do_swap_page_nr(vma->vm_mm, vma, start_addr, pte, pte, nr_pages);
+	update_mmu_cache_range(vmf, vma, start_addr, install_pte, nr_pages);
+	folio_unlock(folio);
+	if (locked)
+		*locked = false;
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	vmf->pte = NULL;
+	/* Each committed PTE owns a folio ref and relinquishes its token owner. */
+	for (i = 0; i < nr_pages; i++)
+		mc16_ref_put_count(&refs[i], 2);
+	return VM_FAULT_NOPAGE;
+
+out_unlock:
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	vmf->pte = NULL;
+out_put:
+	for (i = 0; i < max_pages; i++) {
+		if (refs[i].slot)
+			mc16_ref_put(&refs[i]);
+	}
+	if (folio) {
+		if (folio_test_locked(folio))
+			folio_unlock(folio);
+		folio_put(folio);
+	}
+	if (locked)
+		*locked = false;
+	return ret;
+}
+#endif /* _MM_MEMCOMP_FAULT_H */
diff --git a/mm/memcomp/fault_alloc.h b/mm/memcomp/fault_alloc.h
new file mode 100644
index 0000000000000000000000000000000000000000..d02876c28b71257fb7d90c0dda6dfd82aa963cce
--- /dev/null
+++ b/mm/memcomp/fault_alloc.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_FAULT_ALLOC_H
+#define _MM_MEMCOMP_FAULT_ALLOC_H
+
+#include <linux/gfp.h>
+
+/* Use the returned mask for both folio allocation and memcg charging. */
+static inline gfp_t memcomp_fault_alloc_gfp(struct vm_area_struct *vma,
+					    unsigned int nr_pages)
+{
+	if (nr_pages > 1) {
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		return vma_thp_gfp_mask(vma);
+#else
+		/* Keep the original large-folio mask without THP support. */
+		return GFP_HIGHUSER_MOVABLE | __GFP_NORETRY | __GFP_NOWARN;
+#endif
+	}
+
+	return GFP_HIGHUSER_MOVABLE;
+}
+
+#endif /* _MM_MEMCOMP_FAULT_ALLOC_H */
diff --git a/mm/memcomp/fifo.h b/mm/memcomp/fifo.h
new file mode 100644
index 0000000000000000000000000000000000000000..5da52894655a673f6b8e80e69859e41a1d6be905
--- /dev/null
+++ b/mm/memcomp/fifo.h
@@ -0,0 +1,136 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_FIFO_H
+#define _MM_MEMCOMP_FIFO_H
+
+/* These lists contain clusters after the production caller switches over. */
+static inline struct memcomp_lru *mc16_fifo_of(const struct memcomp_ref *ref)
+{
+	unsigned int nid = ref->cluster->key->nid;
+
+	if (WARN_ON_ONCE(nid >= MAX_NUMNODES))
+		nid = 0;
+	return &memcomp_lrus[nid];
+}
+
+/* Caller serializes each slot transition with T, or owns refs-zero release. */
+static inline void
+mc16_fifo_transition(struct memcomp_ref *ref, unsigned int old_state,
+		     unsigned int new_state)
+{
+	struct mc16_cluster *cluster = ref->cluster;
+	struct memcomp_lru *fifo;
+	unsigned long irqflags;
+	bool old_eligible = old_state == MC16_STORED;
+	bool new_eligible = new_state == MC16_STORED;
+
+	if (old_eligible == new_eligible)
+		return;
+	fifo = mc16_fifo_of(ref);
+	spin_lock_irqsave(&fifo->lock, irqflags);
+	if (new_eligible) {
+		if (WARN_ON_ONCE(cluster->eligible_slots == MC16_CLUSTER_SLOTS))
+			goto out;
+		if (!cluster->eligible_slots++)
+			list_add(&cluster->fifo, &fifo->entries);
+		atomic_long_inc(&fifo->nr_entries);
+	} else {
+		if (WARN_ON_ONCE(!cluster->eligible_slots))
+			goto out;
+		if (!--cluster->eligible_slots)
+			list_del_init(&cluster->fifo);
+		atomic_long_dec(&fifo->nr_entries);
+	}
+ out:
+	spin_unlock_irqrestore(&fifo->lock, irqflags);
+}
+
+/*
+ * Finish first cache initialization exactly once; never revive a retired slot.
+ * Payload/flags and live protection were published by reserve. STORED becomes
+ * selectable only after eligibility is accounted under the selector's L.
+ * SAMEFILL needs no L: all data already precedes reserve's next publication,
+ * and external tokens are exposed only after this infallible initialization.
+ */
+static inline void mc16_cache_activate(struct memcomp_ref *ref)
+{
+	struct mc16_cluster *cluster = ref->cluster;
+	struct memcomp_lru *fifo;
+	unsigned long irqflags;
+
+	if (mc16_flags_state(ref->slot->flags) == MC16_STORED) {
+		fifo = mc16_fifo_of(ref);
+		spin_lock_irqsave(&fifo->lock, irqflags);
+		if (!cluster->eligible_slots++)
+			list_add(&cluster->fifo, &fifo->entries);
+		atomic_long_inc(&fifo->nr_entries);
+		refcount_set(&ref->slot->refs, 1);
+		spin_unlock_irqrestore(&fifo->lock, irqflags);
+	} else {
+		/* Finish accounting before a scanner can take its first guard. */
+		smp_wmb();
+		refcount_set(&ref->slot->refs, 1);
+	}
+}
+
+/*
+ * One L scope, bounded slot scanning. Every call reselects from the FIFO,
+ * never from a link retained after unlock. The caller validates effective
+ * state/hotness under T; an acquired reference alone protects only lifetime.
+ * RCU protects a concurrently detached segment while its zero refs are read.
+ */
+static inline bool mc16_fifo_select(struct memcomp_lru *fifo,
+				    unsigned int *budget, struct memcomp_ref *ref)
+{
+	struct mc16_cluster *cluster;
+	struct mc16_slot *segment, *slot;
+	unsigned int index, next;
+	unsigned long irqflags;
+	bool found = false;
+
+	*ref = (struct memcomp_ref) { };
+	rcu_read_lock();
+	spin_lock_irqsave(&fifo->lock, irqflags);
+	while (*budget && !list_empty(&fifo->entries)) {
+		cluster = list_last_entry(&fifo->entries, struct mc16_cluster, fifo);
+		/* Pair with reserve publication of initialized slots and holes. */
+		next = smp_load_acquire(&cluster->next);
+		if (WARN_ON_ONCE(!next || !cluster->eligible_slots))
+			break;
+		if (cluster->wb_cursor >= next) {
+			cluster->wb_cursor = 0;
+			list_move(&cluster->fifo, &fifo->entries);
+		}
+		index = cluster->wb_cursor++;
+		(*budget)--;
+		/* Segment retirement nulls the pointer before a real RCU grace. */
+		segment = smp_load_acquire(&cluster->segments[index >> MC16_SEGMENT_SHIFT]);
+		if (!segment)
+			continue;
+		slot = &segment[index & (MC16_SEGMENT_SLOTS - 1)];
+		if (!refcount_inc_not_zero(&slot->refs))
+			continue;
+		*ref = (struct memcomp_ref) {
+			.slot = slot, .cluster = cluster,
+			.token = (cluster->id << MC16_CLUSTER_SHIFT) + index,
+		};
+		found = true;
+		break;
+	}
+	spin_unlock_irqrestore(&fifo->lock, irqflags);
+	rcu_read_unlock();
+	return found;
+}
+
+/* Called under T after selecting a held guard and validating its payload. */
+static inline bool mc16_fifo_second_chance_locked(struct memcomp_ref *ref)
+{
+	struct mc16_view view;
+
+	if (!mc16_view_locked(ref, &view))
+		return false;
+	if (!(*view.flags & MC16_F_REFERENCED))
+		return false;
+	*view.flags &= ~MC16_F_REFERENCED;
+	return true;
+}
+#endif /* _MM_MEMCOMP_FIFO_H */
diff --git a/mm/memcomp/folio.h b/mm/memcomp/folio.h
new file mode 100644
index 0000000000000000000000000000000000000000..de8eeed276d9af56816d31ce85bd9341a9ee34a7
--- /dev/null
+++ b/mm/memcomp/folio.h
@@ -0,0 +1,386 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_FOLIO_H
+#define _MM_MEMCOMP_FOLIO_H
+
+/*
+ * Author: nakixii
+ *
+ * Include after the generic eligibility, PTE-map/resident-map, hash/statistics
+ * helpers and the mc16 anon/span/owner helpers. Production dispatch is separate.
+ * All producer entry points require the original folio's lock. No record or
+ * member pointer is retained across T; only the head's slot guard survives.
+ */
+enum mc16_folio_state {
+	MC16_FOLIO_NONE,
+	MC16_FOLIO_PENDING,
+	MC16_FOLIO_STORED,
+};
+
+static inline bool mc16_folio_geometry(struct folio *folio, u32 *token,
+				       unsigned int *nr)
+{
+	unsigned long value = swp_offset(folio->swap);
+
+	*nr = folio_nr_pages(folio);
+	if (!value || !*nr || *nr > MEMCOMP_MAX_COMPRESS_PAGES ||
+	    value > U32_MAX - (*nr - 1))
+		return false;
+	*token = value;
+	return true;
+}
+
+/* A successful uniform-span probe transfers one continuous head guard out. */
+static inline enum mc16_folio_state
+mc16_folio_span(struct folio *folio, struct memcomp_ref *head)
+{
+	enum mc16_folio_state span = MC16_FOLIO_NONE;
+	unsigned int nr, i;
+	u32 token;
+
+	*head = (struct memcomp_ref) { };
+	if (!mc16_folio_geometry(folio, &token, &nr) || !mc16_get(token, head))
+		return MC16_FOLIO_NONE;
+	for (i = 0; i < nr; i++) {
+		struct memcomp_ref sibling = { }, *ref = head;
+		enum mc16_folio_state state = MC16_FOLIO_NONE;
+		struct mc16_view view;
+
+		if (i) {
+			if (!mc16_get(token + i, &sibling))
+				goto fail;
+			ref = &sibling;
+		}
+		mutex_lock(memcomp_lock_of(ref->token));
+		if (mc16_owner_matches_locked(ref, folio, nr, i) &&
+		    mc16_view_locked(ref, &view) && mc16_flags_valid(*view.flags)) {
+			unsigned int effective = mc16_flags_state(*view.flags);
+
+			if (effective == MC16_PENDING && (*view.flags & MC16_F_RESIDENT))
+				state = MC16_FOLIO_PENDING;
+			else if (effective >= MC16_STORED && effective <= MC16_SAMEFILL &&
+				 !(*view.flags & MC16_F_RESIDENT))
+				state = MC16_FOLIO_STORED;
+		}
+		mutex_unlock(memcomp_lock_of(ref->token));
+		if (i)
+			mc16_ref_put(&sibling);
+		if (state == MC16_FOLIO_NONE || (i && state != span))
+			goto fail;
+		span = state;
+	}
+	return span;
+fail:
+	mc16_ref_put(head);
+	return MC16_FOLIO_NONE;
+}
+
+/* Transfer producer-owned bookkeeping before any member can be detached. */
+static inline struct anon_vma *
+mc16_folio_take(struct folio *folio, struct memcomp_ref *head, unsigned int nr,
+		bool *incompressible)
+{
+	struct anon_vma *anon_vma = NULL;
+	struct mc16_view view;
+
+	mutex_lock(memcomp_lock_of(head->token));
+	if (mc16_owner_matches_locked(head, folio, nr, 0) &&
+	    mc16_view_locked(head, &view) && mc16_flags_valid(*view.flags)) {
+		anon_vma = mc16_span_take_anon_vma_locked(head, folio, nr);
+		if (incompressible) {
+			*incompressible = *view.flags & MC16_F_INCOMPRESSIBLE;
+			*view.flags &= ~MC16_F_INCOMPRESSIBLE;
+		}
+	}
+	mutex_unlock(memcomp_lock_of(head->token));
+	return anon_vma;
+}
+
+/* Consumes head, including its lookup, last. Never inspect its record again. */
+static inline void mc16_folio_detach(struct folio *folio,
+				     struct memcomp_ref *head, unsigned int nr)
+{
+	unsigned int i;
+	u32 token = head->token;
+
+	for (i = nr; i > 1; ) {
+		struct memcomp_ref sibling;
+
+		i--;
+		if (mc16_get(token + i, &sibling))
+			mc16_owner_drop_folio_held(&sibling, folio, nr, i);
+	}
+	mc16_owner_drop_folio_held(head, folio, nr, 0);
+}
+
+static inline void mc16_invalidate_folio(struct folio *folio)
+{
+	struct anon_vma *anon_vma;
+	struct memcomp_ref head;
+	unsigned int nr;
+	u32 token;
+
+	if (!folio_test_locked(folio) || !folio_memcomp_reserved(folio))
+		return;
+	if (!mc16_folio_geometry(folio, &token, &nr) || !mc16_get(token, &head)) {
+		folio->swap.val = 0;
+		return;
+	}
+	anon_vma = mc16_folio_take(folio, &head, nr, NULL);
+	mc16_folio_detach(folio, &head, nr);
+	folio->swap.val = 0;
+	if (anon_vma)
+		put_anon_vma(anon_vma);
+}
+
+/* Success leaves the source frozen at zero, owned by the caller for freeing. */
+static inline bool mc16_release_folio(struct folio *folio)
+{
+	struct mc16_owner_tail tail = { };
+	struct anon_vma *anon_vma = NULL;
+	struct memcomp_ref head;
+	struct mc16_view view;
+	unsigned int nr, i;
+	u32 token;
+	bool dropped = false;
+
+	if (!folio_test_locked(folio) || !folio_memcomp_reserved(folio))
+		return false;
+	if (!swp_offset(folio->swap)) {
+		/* Token0 transport owns no slot, record or zero ledger. */
+		if (folio_test_large(folio) || folio_test_anon(folio) ||
+		    folio_mapped(folio) || folio_mapping(folio) ||
+		    !folio_ref_freeze(folio, 1))
+			return false;
+		folio->swap.val = 0;
+		return true;
+	}
+	if (!mc16_folio_geometry(folio, &token, &nr) || !mc16_get(token, &head))
+		return false;
+	/* Resident PENDING holds reject the freeze without another T probe. */
+	if (!folio_ref_freeze(folio, 1)) {
+		mc16_ref_put(&head);
+		return false;
+	}
+	/* The still-attached head owns the record throughout sibling detach. */
+	for (i = nr; i > 1; ) {
+		struct memcomp_ref sibling;
+
+		i--;
+		if (mc16_get(token + i, &sibling) &&
+		    !mc16_owner_drop_folio_held(&sibling, folio, nr, i)) {
+			mc16_ref_put(&head);
+			folio_ref_unfreeze(folio, 1);
+			return false;
+		}
+	}
+	mutex_lock(memcomp_lock_of(token));
+	if (mc16_owner_matches_locked(&head, folio, nr, 0) &&
+	    mc16_view_locked(&head, &view) && mc16_flags_valid(*view.flags) &&
+	    mc16_flags_state(*view.flags) != MC16_PENDING &&
+	    !(*view.flags & MC16_F_RESIDENT)) {
+		dropped = mc16_owner_drop_locked(&head, folio, nr, 0, &tail);
+		/* The detach tail owns this member until its final put below. */
+		if (dropped && tail.record &&
+		    (tail.record->record_flags & MC16_RECORD_ANON_VMA)) {
+			anon_vma = tail.record->anon_vma;
+			tail.record->anon_vma = NULL;
+			tail.record->record_flags &= ~MC16_RECORD_ANON_VMA;
+		}
+	}
+	mutex_unlock(memcomp_lock_of(token));
+	mc16_ref_put_count(&head, dropped ? 2 : 1);
+	mc16_owner_tail_put(&tail);
+	if (anon_vma)
+		put_anon_vma(anon_vma);
+	if (!dropped) {
+		folio_ref_unfreeze(folio, 1);
+		return false;
+	}
+	folio->swap.val = 0;
+	return true;
+}
+
+/* OWNER + this probe's lookup is two, including the borrowed head lookup. */
+static inline bool mc16_folio_pending_refs(struct folio *folio,
+					   struct memcomp_ref *head, unsigned int nr)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr; i++) {
+		struct memcomp_ref sibling = { }, *ref = head;
+		struct mc16_view view;
+		bool escaped;
+
+		if (i) {
+			if (!mc16_get(head->token + i, &sibling))
+				continue;
+			ref = &sibling;
+		}
+		mutex_lock(memcomp_lock_of(ref->token));
+		escaped = mc16_owner_matches_locked(ref, folio, nr, i) &&
+			mc16_view_locked(ref, &view) && mc16_flags_valid(*view.flags) &&
+			mc16_flags_state(*view.flags) == MC16_PENDING &&
+			(*view.flags & MC16_F_RESIDENT) && refcount_read(&ref->slot->refs) > 2;
+		mutex_unlock(memcomp_lock_of(ref->token));
+		if (i)
+			mc16_ref_put(&sibling);
+		if (escaped)
+			return true;
+	}
+	return false;
+}
+
+struct mc16_folio_restore {
+	u32 token;
+	unsigned int found;
+	bool count_only;
+};
+
+static bool mc16_folio_restore_one(struct folio *folio,
+				   struct vm_area_struct *vma,
+				   unsigned long address, void *arg)
+{
+	struct mc16_folio_restore *walk = arg;
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned int nr = folio_nr_pages(folio), index = 0;
+
+	if (nr > 1) {
+		pgoff_t page_index = linear_page_index(vma, address);
+		pgoff_t first = folio_pgoff(folio);
+
+		if (page_index < first || page_index - first >= nr)
+			return true;
+		index = page_index - first;
+	}
+	for (; index < nr && address < vma->vm_end; index++, address += PAGE_SIZE) {
+		struct memcomp_ref removed;
+		spinlock_t *ptl; /* Protects the complete original token PTE. */
+		pte_t *ptep, orig;
+		pmd_t *pmd = mm_find_pmd(mm, address);
+		u32 token = walk->token + index;
+
+		if (!pmd || !memcomp_pte_map_lock(mm, pmd, address, &ptep, &ptl))
+			continue;
+		orig = ptep_get(ptep);
+		if (!is_swap_pte(orig) || pte_to_swp_entry(orig).val !=
+		    make_memcomp_entry(token).val)
+			goto out_pte;
+		if (walk->count_only) {
+			walk->found++;
+			goto out_pte;
+		}
+		/* Get before publishing: a failed lookup leaves the PTE unchanged. */
+		if (!mc16_get(token, &removed))
+			goto out_pte;
+		folio_get(folio);
+		memcomp_map_resident(vma, address, ptep, orig, folio,
+				     folio_page(folio, index), false);
+		pte_unmap_unlock(ptep, ptl);
+		/* The folio_get now belongs to the new PTE; retire lookup + token. */
+		mc16_ref_put_count(&removed, 2);
+		memcomp_debug_inc(&memcomp_restore_ptes);
+		walk->found++;
+		continue;
+out_pte:
+		pte_unmap_unlock(ptep, ptl);
+	}
+	return true;
+}
+
+static inline unsigned int
+mc16_folio_restore_span(struct folio *folio, u32 token, bool count_only)
+{
+	struct mc16_folio_restore walk = { .token = token, .count_only = count_only };
+	struct rmap_walk_control rwc = {
+		.rmap_one = mc16_folio_restore_one,
+		.arg = &walk,
+	};
+	u64 start = memcomp_debug_clock();
+
+	rmap_walk(folio, &rwc);
+	if (!count_only) {
+		if (folio_test_large(folio))
+			deferred_split_folio_remapped(folio);
+		memcomp_debug_elapsed(start, &memcomp_restore_ns, &memcomp_restore_max_ns);
+	}
+	return walk.found;
+}
+
+#define MC16_FOLIO_RESTORE_WALKS 3U
+
+static inline void mc16_rollback_folio(struct folio *folio)
+{
+	struct anon_vma *anon_vma;
+	struct memcomp_ref head;
+	unsigned int nr, walks;
+	bool incompressible = false;
+	u32 token, hash = 0;
+
+	if (!folio_test_locked(folio) || !folio_memcomp_reserved(folio))
+		return;
+	if (!mc16_folio_geometry(folio, &token, &nr) || !mc16_get(token, &head)) {
+		folio->swap.val = 0;
+		return;
+	}
+	anon_vma = mc16_folio_take(folio, &head, nr, &incompressible);
+	/* Hash before any restored mapping can be written by another task. */
+	if (incompressible)
+		hash = memcomp_folio_hash(folio);
+	if (anon_vma) {
+		for (walks = 0; walks < MC16_FOLIO_RESTORE_WALKS; walks++) {
+			if (!mc16_folio_pending_refs(folio, &head, nr))
+				break;
+			if (!walks) {
+				memcomp_debug_inc(&memcomp_restore_spans);
+			} else {
+				memcomp_debug_inc(&memcomp_restore_rewalks);
+				cond_resched();
+			}
+			if (!mc16_folio_restore_span(folio, token, false) && walks)
+				break;
+		}
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+		memcomp_debug_add(mc16_folio_restore_span(folio, token, true),
+				  &memcomp_restore_missed_pages);
+#endif
+	}
+	mc16_folio_detach(folio, &head, nr);
+	if (incompressible) {
+		folio_set_incompressible(folio, hash);
+		memcomp_debug_add(nr, &memcomp_incompressible_marked_pages);
+	} else {
+		folio->swap.val = 0;
+	}
+	if (anon_vma)
+		put_anon_vma(anon_vma);
+}
+
+static inline bool mc16_reserve_folio(struct folio *folio)
+{
+	struct memcomp_ref head;
+	struct anon_vma *anon_vma;
+	unsigned long token;
+	int ret;
+
+	if (!memcomp_reserve_eligible(folio))
+		return false;
+	if (folio_memcomp_reserved(folio)) {
+		enum mc16_folio_state span = mc16_folio_span(folio, &head);
+
+		if (head.slot)
+			mc16_ref_put(&head);
+		if (span == MC16_FOLIO_PENDING)
+			return true;
+		mc16_rollback_folio(folio);
+	}
+	anon_vma = folio_get_anon_vma(folio);
+	ret = mc16_anon_reserve(folio, folio_nr_pages(folio), anon_vma, &token);
+	if (ret) {
+		if (anon_vma)
+			put_anon_vma(anon_vma);
+		return false;
+	}
+	folio->swap = make_memcomp_entry(token);
+	return true;
+}
+#endif /* _MM_MEMCOMP_FOLIO_H */
diff --git a/mm/memcomp/format.h b/mm/memcomp/format.h
new file mode 100644
index 0000000000000000000000000000000000000000..e086dfda998b0e2d8192384e16a2ade13f682434
--- /dev/null
+++ b/mm/memcomp/format.h
@@ -0,0 +1,308 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MM_MEMCOMP_FORMAT_H
+#define _MM_MEMCOMP_FORMAT_H
+
+#include <linux/bits.h>
+#include <linux/build_bug.h>
+#include <linux/limits.h>
+#include <linux/minmax.h>
+#include <linux/refcount.h>
+#include <linux/stddef.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
+#include <linux/types.h>
+
+#include <asm/page.h>
+
+struct anon_vma;
+struct folio;
+struct obj_cgroup;
+
+enum mc16_state {
+	MC16_EMPTY = 0,
+	MC16_PENDING = 1,
+	MC16_STORED = 2,
+	MC16_WRITEBACK = 3,
+	MC16_SWAPPED = 4,
+	MC16_SAMEFILL = 5,
+};
+
+#define MC16_STATE_MASK		GENMASK(2, 0)
+#define MC16_F_OWNER		BIT(3)
+#define MC16_F_RESIDENT		BIT(4)
+#define MC16_F_REFRESH_PENDING	BIT(5)
+#define MC16_ORDER_SHIFT	6
+#define MC16_ORDER_MASK		GENMASK(8, 6)
+#define MC16_F_REFERENCED	BIT(9)
+#define MC16_F_INCOMPRESSIBLE	BIT(10)
+#define MC16_RESERVED_MASK	GENMASK(15, 11)
+#define MC16_MAX_ORDER		4
+#define MC16_MAX_PAGES		BIT(MC16_MAX_ORDER)
+#define MC16_MODIFIER_MASK	(MC16_F_OWNER | MC16_F_RESIDENT | \
+				 MC16_F_REFRESH_PENDING | MC16_F_REFERENCED | \
+				 MC16_F_INCOMPRESSIBLE)
+#define MC16_FLAGS_MASK		(MC16_STATE_MASK | MC16_ORDER_MASK | \
+				 MC16_MODIFIER_MASK)
+
+#define MC16_RECORD_ANON_VMA	BIT(0)
+#define MC16_RECORD_SHMEM	BIT(1)
+
+/* Zero tokens have no slot. word preserves every bit of a zs handle/fill. */
+struct mc16_slot {
+	u64 word;
+	refcount_t refs;
+	u16 length;
+	u16 flags;
+} __aligned(8);
+
+struct mc16_member {
+	u64 word;
+	struct folio *owner_folio;
+	u16 length;
+	u16 flags;
+	u32 payload_charge;
+} __aligned(8);
+
+struct mc16_record {
+	refcount_t members;
+	u32 token_base;
+	struct folio *producer;
+	struct anon_vma *anon_vma;
+	struct obj_cgroup *objcg;
+	u64 alloc_bytes;
+	u64 charge_bytes;
+	u16 nid;
+	u16 nr_pages;
+	u32 record_flags;
+	u8 reserved[8];
+	struct mc16_member member[];
+} __aligned(8);
+
+static_assert(PAGE_SHIFT >= 12 && PAGE_SHIFT <= 16);
+static_assert(MAX_SWAPFILES_SHIFT == 5);
+static_assert(sizeof(refcount_t) == 4);
+static_assert(sizeof(void *) == 8);
+
+static_assert(sizeof(struct mc16_slot) == 16);
+static_assert(__alignof__(struct mc16_slot) == 8);
+static_assert(offsetof(struct mc16_slot, word) == 0);
+static_assert(offsetof(struct mc16_slot, refs) == 8);
+static_assert(offsetof(struct mc16_slot, length) == 12);
+static_assert(offsetof(struct mc16_slot, flags) == 14);
+
+static_assert(sizeof(struct mc16_member) == 24);
+static_assert(__alignof__(struct mc16_member) == 8);
+static_assert(offsetof(struct mc16_member, word) == 0);
+static_assert(offsetof(struct mc16_member, owner_folio) == 8);
+static_assert(offsetof(struct mc16_member, length) == 16);
+static_assert(offsetof(struct mc16_member, flags) == 18);
+static_assert(offsetof(struct mc16_member, payload_charge) == 20);
+
+/* These are C layout sizes, not allocator bucket or charge sizes. */
+static_assert(sizeof(struct mc16_record) == 64);
+static_assert(__alignof__(struct mc16_record) == 8);
+static_assert(offsetof(struct mc16_record, members) == 0);
+static_assert(offsetof(struct mc16_record, token_base) == 4);
+static_assert(offsetof(struct mc16_record, producer) == 8);
+static_assert(offsetof(struct mc16_record, anon_vma) == 16);
+static_assert(offsetof(struct mc16_record, objcg) == 24);
+static_assert(offsetof(struct mc16_record, alloc_bytes) == 32);
+static_assert(offsetof(struct mc16_record, charge_bytes) == 40);
+static_assert(offsetof(struct mc16_record, nid) == 48);
+static_assert(offsetof(struct mc16_record, nr_pages) == 50);
+static_assert(offsetof(struct mc16_record, record_flags) == 52);
+static_assert(offsetof(struct mc16_record, reserved) == 56);
+static_assert(sizeof_field(struct mc16_record, reserved) == 8);
+static_assert(offsetof(struct mc16_record, member) == 64);
+
+/*
+ * These helpers only check representation. The caller serializes access and
+ * checks state-specific ownership; a member may retain OWNER for an effective
+ * payload while its physical slot is PENDING. No helper takes a lock or ref.
+ * Checked encoders leave every output untouched on failure.
+ */
+static inline bool mc16_flags_valid(u64 flags)
+{
+	return !(flags & ~(u64)MC16_FLAGS_MASK) &&
+	       (flags & MC16_STATE_MASK) <= MC16_SAMEFILL &&
+	       ((flags & MC16_ORDER_MASK) >> MC16_ORDER_SHIFT) <= MC16_MAX_ORDER;
+}
+
+static inline bool mc16_flags_encode(u64 state, u64 order, u64 modifiers,
+				     u16 *encoded)
+{
+	u64 flags;
+
+	if (!encoded || state > MC16_SAMEFILL || order > MC16_MAX_ORDER ||
+	    (modifiers & ~(u64)MC16_MODIFIER_MASK))
+		return false;
+
+	flags = state | (order << MC16_ORDER_SHIFT) | modifiers;
+	*encoded = (u16)flags;
+	return true;
+}
+
+/* Call only after validating the flags representation. */
+static inline unsigned int mc16_flags_state(u16 flags)
+{
+	return flags & MC16_STATE_MASK;
+}
+
+static inline unsigned int mc16_flags_order(u16 flags)
+{
+	return (flags & MC16_ORDER_MASK) >> MC16_ORDER_SHIFT;
+}
+
+/* Only real payloads use bytes - 1; encoded zero means one payload byte. */
+static inline bool mc16_length_encode(u64 bytes, u16 *encoded)
+{
+	if (!encoded || !bytes || bytes > PAGE_SIZE)
+		return false;
+
+	*encoded = (u16)(bytes - 1);
+	return true;
+}
+
+static inline bool mc16_length_decode(u64 encoded, u32 *bytes)
+{
+	if (!bytes || encoded >= PAGE_SIZE)
+		return false;
+
+	*bytes = (u32)encoded + 1;
+	return true;
+}
+
+/* SAMEFILL keeps its complete word, has length zero and needs no codec. */
+static inline bool mc16_payload_length_encode(u64 state, u64 bytes,
+					      u16 *encoded)
+{
+	if (!encoded)
+		return false;
+	if (state == MC16_SAMEFILL) {
+		if (bytes)
+			return false;
+		*encoded = 0;
+		return true;
+	}
+	if (state != MC16_STORED && state != MC16_WRITEBACK &&
+	    state != MC16_SWAPPED)
+		return false;
+
+	return mc16_length_encode(bytes, encoded);
+}
+
+static inline bool mc16_payload_length_decode(u64 state, u64 encoded,
+					      u32 *bytes)
+{
+	if (!bytes)
+		return false;
+	if (state == MC16_SAMEFILL) {
+		if (encoded)
+			return false;
+		*bytes = 0;
+		return true;
+	}
+	if (state != MC16_STORED && state != MC16_WRITEBACK &&
+	    state != MC16_SWAPPED)
+		return false;
+
+	return mc16_length_decode(encoded, bytes);
+}
+
+#define MC16_SWAP_TYPE_MASK	GENMASK_ULL(4, 0)
+#define MC16_SWAP_BYTE_SHIFT	5
+#define MC16_SWAP_BYTE_MASK	((u64)PAGE_SIZE - 1)
+#define MC16_SWAP_PACKED		BIT_ULL(PAGE_SHIFT + 5)
+#define MC16_SWAP_OFFSET_SHIFT	(PAGE_SHIFT + 6)
+#define MC16_SWAP_OFFSET_MASK	(U64_MAX >> MC16_SWAP_OFFSET_SHIFT)
+
+struct mc16_swap_fields {
+	u64 swap_offset;
+	u32 byte_offset;
+	u32 length;
+	u8 type;
+	bool packed;
+};
+
+static inline u64 mc16_swap_offset_limit(void)
+{
+	return min_t(u64, SWP_OFFSET_MASK, MC16_SWAP_OFFSET_MASK);
+}
+
+/* Backing device/slot ownership validation remains the caller's job. */
+static inline bool mc16_swap_encode(u64 type, u64 swap_offset,
+				    u64 byte_offset, u64 bytes, bool packed,
+				    u64 *word, u16 *length)
+{
+	u16 encoded;
+	u64 value;
+
+	if (!word || !length || type > MC16_SWAP_TYPE_MASK ||
+	    type >= MAX_SWAPFILES || swap_offset > mc16_swap_offset_limit() ||
+	    byte_offset >= PAGE_SIZE || !mc16_length_encode(bytes, &encoded))
+		return false;
+	if (packed) {
+		if (bytes >= PAGE_SIZE || bytes > PAGE_SIZE - byte_offset)
+			return false;
+	} else if (byte_offset) {
+		return false;
+	}
+
+	value = type | (byte_offset << MC16_SWAP_BYTE_SHIFT) |
+		(swap_offset << MC16_SWAP_OFFSET_SHIFT);
+	if (packed)
+		value |= MC16_SWAP_PACKED;
+	*word = value;
+	*length = encoded;
+	return true;
+}
+
+static inline bool mc16_swap_decode(u64 word, u64 length,
+				    struct mc16_swap_fields *fields)
+{
+	struct mc16_swap_fields decoded;
+	u16 checked_length;
+	u64 checked_word;
+
+	if (!fields || !mc16_length_decode(length, &decoded.length))
+		return false;
+
+	decoded.type = word & MC16_SWAP_TYPE_MASK;
+	decoded.swap_offset = word >> MC16_SWAP_OFFSET_SHIFT;
+	decoded.byte_offset = (word >> MC16_SWAP_BYTE_SHIFT) &
+			      MC16_SWAP_BYTE_MASK;
+	decoded.packed = !!(word & MC16_SWAP_PACKED);
+	if (!mc16_swap_encode(decoded.type, decoded.swap_offset,
+			      decoded.byte_offset, decoded.length, decoded.packed,
+			      &checked_word, &checked_length))
+		return false;
+
+	*fields = decoded;
+	return true;
+}
+
+/* Caller owns the record; this only validates immutable span geometry. */
+static inline bool mc16_member_index(const struct mc16_record *record,
+				     u64 token, u32 *index)
+{
+	u32 base, nr;
+	u64 delta;
+
+	if (!record || !index)
+		return false;
+
+	base = record->token_base;
+	nr = record->nr_pages;
+	if (!base || !nr || nr > MC16_MAX_PAGES || (nr & (nr - 1)) ||
+	    (base & (nr - 1)) || base > U32_MAX - (nr - 1) || token < base)
+		return false;
+
+	delta = token - base;
+	if (delta >= nr)
+		return false;
+
+	*index = (u32)delta;
+	return true;
+}
+
+#endif /* _MM_MEMCOMP_FORMAT_H */
diff --git a/mm/memcomp/lifetime.h b/mm/memcomp/lifetime.h
new file mode 100644
index 0000000000000000000000000000000000000000..642c76ce08139122a1090bd6feac7aa3a9bc9950
--- /dev/null
+++ b/mm/memcomp/lifetime.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_LIFETIME_H
+#define _MM_MEMCOMP_LIFETIME_H
+
+/* Included after memcomp's accounting wrappers. No payload is freed here. */
+#include <linux/err.h>
+#include <linux/log2.h>
+#include <linux/overflow.h>
+#include <linux/slab.h>
+
+static inline void mc16_record_destroy(struct mc16_record *record)
+{
+	struct obj_cgroup *objcg = record->objcg;
+	u64 charge = record->charge_bytes;
+
+	/* A detached tail may outlive the key and every cluster callback. */
+	memcomp_objcg_uncharge(objcg, charge);
+	if (objcg)
+		memcomp_objcg_put(objcg);
+	kfree(record);
+}
+
+static inline void mc16_record_member_put(struct mc16_record *record)
+{
+	/* The caller must not touch record after returning its own member. */
+	if (refcount_sub_and_test(1, &record->members))
+		mc16_record_destroy(record);
+}
+
+/* The failed reserve owns all members privately; no member was published. */
+static inline void mc16_record_abort(struct mc16_record *record)
+{
+	unsigned int nr_pages = record->nr_pages;
+
+	if (WARN_ON_ONCE(!refcount_sub_and_test(nr_pages, &record->members)))
+		return;
+	mc16_record_destroy(record);
+}
+
+static inline struct mc16_record *
+mc16_record_alloc(struct folio *folio, unsigned int nr_pages, bool shmem)
+{
+	struct mc16_record *record;
+	struct obj_cgroup *objcg;
+	unsigned int order, i;
+	size_t bytes;
+	int ret;
+
+	if (!folio || !nr_pages || nr_pages > MEMCOMP_MAX_COMPRESS_PAGES ||
+	    !is_power_of_2(nr_pages))
+		return ERR_PTR(-EINVAL);
+	bytes = struct_size(record, member, nr_pages);
+	record = kzalloc(bytes, GFP_NOIO | __GFP_NOWARN);
+	if (!record)
+		return ERR_PTR(-ENOMEM);
+
+	/* Charge the actual slab size, not the flexible-array requested size. */
+	record->alloc_bytes = ksize(record);
+	objcg = memcomp_objcg_get(folio);
+	if (objcg) {
+		ret = memcomp_objcg_charge(objcg, GFP_NOWAIT | __GFP_NOWARN,
+					   record->alloc_bytes);
+		if (ret) {
+			memcomp_objcg_put(objcg);
+			kfree(record);
+			return ERR_PTR(ret);
+		}
+		record->charge_bytes = record->alloc_bytes;
+	}
+	record->objcg = objcg;
+	record->producer = folio;
+	record->nid = folio_nid(folio);
+	record->nr_pages = nr_pages;
+	if (shmem)
+		record->record_flags |= MC16_RECORD_SHMEM;
+	refcount_set(&record->members, nr_pages);
+	order = ilog2(nr_pages);
+	for (i = 0; i < nr_pages; i++) {
+		record->member[i].owner_folio = folio;
+		record->member[i].flags = MC16_PENDING | MC16_F_OWNER |
+			MC16_F_RESIDENT | (order << MC16_ORDER_SHIFT);
+	}
+	/* Reserve acquires resident folio refs only when slots are committed. */
+	return record;
+}
+
+#endif /* _MM_MEMCOMP_LIFETIME_H */
diff --git a/mm/memcomp/load.h b/mm/memcomp/load.h
new file mode 100644
index 0000000000000000000000000000000000000000..ccff6896dea95615b01604c09da467cec5857e12
--- /dev/null
+++ b/mm/memcomp/load.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_LOAD_H
+#define _MM_MEMCOMP_LOAD_H
+
+/* A slot guard protects lifetime; T separately protects mutable payloads. */
+static inline int mc16_load_page(struct memcomp_ref *ref, void *dst)
+{
+	struct mc16_view view;
+	unsigned long word;
+	unsigned int state;
+	u32 bytes;
+	void *src;
+	int ret;
+
+	if (!ref->slot || !dst)
+		return -EINVAL;
+	mutex_lock(memcomp_lock_of(ref->token));
+	if (!mc16_view_locked(ref, &view) || !mc16_flags_valid(*view.flags)) {
+		ret = -EIO;
+		goto out;
+	}
+	if (*view.flags & MC16_F_REFRESH_PENDING) {
+		ret = -EAGAIN;
+		goto out;
+	}
+	state = mc16_flags_state(*view.flags);
+	if (state == MC16_PENDING) {
+		ret = -EAGAIN;
+		goto out;
+	}
+	if (!mc16_payload_length_decode(state, *view.length, &bytes)) {
+		ret = -EIO;
+		goto out;
+	}
+	/* Reuse this T scope for the FIFO second-chance hint. */
+	*view.flags |= MC16_F_REFERENCED;
+	word = *view.word;
+	if (state == MC16_SAMEFILL) {
+		mutex_unlock(memcomp_lock_of(ref->token));
+		memset_l(dst, word, PAGE_SIZE / sizeof(unsigned long));
+		return 0;
+	}
+	if ((state != MC16_STORED && state != MC16_WRITEBACK) || !word) {
+		ret = -EIO;
+		goto out;
+	}
+	/* Refresh and writeback cannot free this handle while T is held. */
+	src = zs_map_object(memcomp_pools[0], word, ZS_MM_RO);
+	if (!src) {
+		ret = -EIO;
+		goto out;
+	}
+	ret = memcomp_decompress_payload(src, bytes, dst);
+	zs_unmap_object(memcomp_pools[0], word);
+out:
+	mutex_unlock(memcomp_lock_of(ref->token));
+	return ret;
+}
+#endif /* _MM_MEMCOMP_LOAD_H */
diff --git a/mm/memcomp/migrate.h b/mm/memcomp/migrate.h
new file mode 100644
index 0000000000000000000000000000000000000000..66c06ec4d34744869d1e310bad23b6e8fb6c3072
--- /dev/null
+++ b/mm/memcomp/migrate.h
@@ -0,0 +1,152 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_MIGRATE_H
+#define _MM_MEMCOMP_MIGRATE_H
+
+/* Include after access.h, span.h and refs.h; no public dispatch is changed. */
+static inline bool
+mc16_migrate_owner_locked(struct memcomp_ref *ref, struct folio *folio,
+			  unsigned int nr_pages, unsigned int index,
+			  struct mc16_view *view)
+{
+	unsigned int offset;
+
+	lockdep_assert_held(memcomp_lock_of(ref->token));
+	if (!mc16_owner_matches_locked(ref, folio, nr_pages, index) ||
+	    !mc16_view_locked(ref, view) || !mc16_flags_valid(*view->flags) ||
+	    mc16_flags_state(*view->flags) == MC16_PENDING ||
+	    mc16_flags_state(*view->flags) == MC16_EMPTY ||
+	    (*view->flags & MC16_F_RESIDENT))
+		return false;
+	return mc16_ref_geometry(ref, NULL, &offset) == nr_pages && offset == index;
+}
+
+/* Failure window only: successful ownership changes always execute below. */
+static inline int
+mc16_migrate_move_error(struct memcomp_ref *ref, struct folio *from,
+			struct folio *to, unsigned int index)
+{
+	return 0;
+}
+
+static inline bool
+mc16_migrate_move_owner(struct memcomp_ref *ref, struct folio *from,
+			struct folio *to, unsigned int nr_pages,
+			unsigned int index)
+{
+	struct mc16_view view;
+	bool move;
+
+	if (mc16_migrate_move_error(ref, from, to, index))
+		return false;
+	mutex_lock(memcomp_lock_of(ref->token));
+	move = mc16_migrate_owner_locked(ref, from, nr_pages, index, &view);
+	if (move)
+		view.member->owner_folio = to;
+	mutex_unlock(memcomp_lock_of(ref->token));
+	return move;
+}
+
+/*
+ * Both folios stay locked throughout the transaction and any core rollback.
+ * Get every slot before preflight; the guards protect slots, never records.
+ * An attached member's OWNER cannot detach while its owner folio is locked.
+ * All record/member access is under its own T; no borrowed view escapes T.
+ *
+ * The record's producer is its immutable reservation anchor, only dereferenced
+ * during reserve/publication. Post-publication ownership uses owner_folio.
+ * Moving a nonresident OWNER transfers no resident folio reference or charge.
+ * key->nid and FIFO eligibility stay at the reservation node (approved N6).
+ */
+static inline int mc16_migrate_folio(struct folio *dst, struct folio *src)
+{
+	struct memcomp_ref refs[MEMCOMP_MAX_COMPRESS_PAGES] = { };
+	unsigned int nr_pages = folio_nr_pages(src), i;
+	unsigned long token;
+	struct mc16_view view;
+	swp_entry_t swap;
+	int ret = -EAGAIN;
+	bool match;
+
+	if (src == dst || !folio_test_locked(src) || !folio_test_locked(dst))
+		return -EAGAIN;
+	if (!folio_test_anon(src) || !folio_test_swapbacked(src) ||
+	    folio_mapping(src) || folio_test_swapcache(src))
+		return 0;
+	swap = src->swap;
+	if (!folio_memcomp_reserved(src)) {
+		if (folio_test_incompressible(src))
+			dst->swap = swap;
+		return 0;
+	}
+	token = swp_offset(swap);
+	if (!token || !nr_pages || nr_pages > MEMCOMP_MAX_COMPRESS_PAGES ||
+	    token > U32_MAX - (nr_pages - 1) || folio_nr_pages(dst) != nr_pages)
+		return -EAGAIN;
+	for (i = 0; i < nr_pages; i++) {
+		if (!mc16_get(token + i, &refs[i]))
+			goto out;
+	}
+	for (i = 0; i < nr_pages; i++) {
+		mutex_lock(memcomp_lock_of(refs[i].token));
+		match = mc16_migrate_owner_locked(&refs[i], src, nr_pages, i, &view);
+		mutex_unlock(memcomp_lock_of(refs[i].token));
+		if (!match)
+			goto out;
+	}
+	for (i = 0; i < nr_pages; i++) {
+		if (mc16_migrate_move_owner(&refs[i], src, dst, nr_pages, i))
+			continue;
+		while (i) {
+			i--;
+			WARN_ON_ONCE(!mc16_migrate_move_owner(&refs[i], dst, src,
+							      nr_pages, i));
+		}
+		goto out;
+	}
+	dst->swap = swap;
+	ret = 1;
+out:
+	for (i = 0; i < nr_pages; i++) {
+		if (refs[i].slot)
+			mc16_ref_put(&refs[i]);
+	}
+	return ret;
+}
+
+/*
+ * Core migration failed after a successful handoff. Prefetch all available
+ * guards, then restore owners in reverse order, skipping missing/nonmatching
+ * members. Clear only a reserved destination mark, including
+ * malformed ranges; an incompressible mark remains the core's responsibility.
+ * Invalid lock callers retain the mark so they can retry while correctly held.
+ */
+static inline void
+mc16_migrate_folio_rollback(struct folio *dst, struct folio *src)
+{
+	struct memcomp_ref refs[MEMCOMP_MAX_COMPRESS_PAGES] = { };
+	unsigned int nr_pages = folio_nr_pages(src), i;
+	unsigned long token;
+
+	if (src == dst || !folio_test_locked(src) || !folio_test_locked(dst))
+		return;
+	if (!folio_memcomp_reserved(dst))
+		return;
+	token = swp_offset(dst->swap);
+	if (!token || !nr_pages || nr_pages > MEMCOMP_MAX_COMPRESS_PAGES ||
+	    token > U32_MAX - (nr_pages - 1))
+		goto clear;
+	for (i = 0; i < nr_pages; i++)
+		mc16_get(token + i, &refs[i]);
+	for (i = nr_pages; i; ) {
+		i--;
+		if (refs[i].slot)
+			mc16_migrate_move_owner(&refs[i], dst, src, nr_pages, i);
+	}
+	for (i = 0; i < nr_pages; i++) {
+		if (refs[i].slot)
+			mc16_ref_put(&refs[i]);
+	}
+clear:
+	dst->swap.val = 0;
+}
+#endif /* _MM_MEMCOMP_MIGRATE_H */
diff --git a/mm/memcomp/owner.h b/mm/memcomp/owner.h
new file mode 100644
index 0000000000000000000000000000000000000000..2d5505fb81ae1e19dab39b1201df6573668c102e
--- /dev/null
+++ b/mm/memcomp/owner.h
@@ -0,0 +1,111 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_OWNER_H
+#define _MM_MEMCOMP_OWNER_H
+
+/* Include after access/refs and memcomp_state_drop_owner(). */
+struct mc16_owner_tail {
+	struct mc16_record *record;
+	bool resident;
+};
+
+/*
+ * T is held and ref owns a real lookup in addition to the attached OWNER.
+ * tail is initially zero and remains untouched on rejection. Success moves
+ * only detached member ownership to tail; payload/charge move to the slot.
+ * No slot ref is consumed here. After unlocking, the caller invalidates arch
+ * state for tail->resident, then puts lookup+OWNER with ONE put_count(ref, 2).
+ * Rejection instead puts only the lookup. All record-dependent local work
+ * must finish before owner_tail_put(), which is the last record access.
+ *
+ * The producer keeps its head member until every span/identity/anon_vma use
+ * is complete and drops that head last. A slot guard is not a record pin.
+ * anon_vma must be handed off by the producer, never put by a PTL finalizer.
+ */
+static inline bool
+mc16_owner_drop_locked(struct memcomp_ref *ref, struct folio *folio,
+		       unsigned int nr_pages, unsigned int page_idx,
+		       struct mc16_owner_tail *tail)
+{
+	struct mc16_swap_fields swap;
+	struct mc16_view view;
+	unsigned int state;
+	u32 bytes, index;
+	u16 flags;
+	bool resident;
+
+	if (!mc16_view_locked(ref, &view) || !view.record ||
+	    !mc16_member_index(view.record, ref->token, &index))
+		return false;
+	flags = *view.flags;
+	if (!mc16_flags_valid(flags) || !(flags & MC16_F_OWNER) ||
+	    view.member->owner_folio != folio ||
+	    view.record->nr_pages != nr_pages || index != page_idx ||
+	    refcount_read(&ref->slot->refs) < 2)
+		return false;
+	state = mc16_flags_state(flags);
+	resident = state == MC16_PENDING && (flags & MC16_F_RESIDENT);
+	if (!resident) {
+		if ((flags & MC16_F_RESIDENT) ||
+		    (state != MC16_STORED && state != MC16_WRITEBACK &&
+		     state != MC16_SAMEFILL && state != MC16_SWAPPED) ||
+		    !mc16_payload_length_decode(state, *view.length, &bytes))
+			return false;
+		if (((state == MC16_STORED || state == MC16_WRITEBACK) &&
+		     !*view.word) ||
+		    (state == MC16_SWAPPED &&
+		     !mc16_swap_decode(*view.word, *view.length, &swap)))
+			return false;
+	}
+
+	memcomp_state_drop_owner();
+	*view.flags = flags & ~MC16_F_OWNER;
+	*tail = (struct mc16_owner_tail) { .resident = resident };
+	if (!resident) {
+		view.member->owner_folio = NULL;
+		tail->record = mc16_normalize_locked(ref);
+	} else {
+		/* Mirror OWNER for refs-only queries; retain the attached record. */
+		WRITE_ONCE(ref->slot->flags,
+			   READ_ONCE(ref->slot->flags) & ~MC16_F_OWNER);
+	}
+	/* Resident PENDING retains its member and resident folio reference. */
+	return true;
+}
+
+/* Outside T. Consume all saved record fields before this final member put. */
+static inline void mc16_owner_tail_put(struct mc16_owner_tail *tail)
+{
+	struct mc16_record *record = tail->record;
+
+	*tail = (struct mc16_owner_tail) { };
+	if (record)
+		mc16_record_member_put(record);
+	/* Neither record nor any of its members may be accessed hereafter. */
+}
+
+/*
+ * Consumes the lookup on either outcome, and OWNER only on success. Callers
+ * needing record fields after unlocking use drop_locked()/tail_put() instead.
+ * One existing T acquisition, no allocation or extra lookup/pin. A successful
+ * nonresident drop costs one slot sub(2) and one detached member decrement.
+ */
+static inline bool
+mc16_owner_drop_folio_held(struct memcomp_ref *ref, struct folio *folio,
+			   unsigned int nr_pages, unsigned int page_idx)
+{
+	struct mc16_owner_tail tail = { };
+	struct mutex *lock = memcomp_lock_of(ref->token);
+	bool dropped;
+
+	mutex_lock(lock);
+	dropped = mc16_owner_drop_locked(ref, folio, nr_pages, page_idx, &tail);
+	mutex_unlock(lock);
+	/* Match the resident rollback invalidation even with surviving guards. */
+	if (dropped && tail.resident)
+		arch_swap_invalidate_page(SWP_MEMCOMP, ref->token);
+	mc16_ref_put_count(ref, dropped ? 2 : 1);
+	/* ref may already be empty and its slot/cluster/key already retired. */
+	mc16_owner_tail_put(&tail);
+	return dropped;
+}
+#endif /* _MM_MEMCOMP_OWNER_H */
diff --git a/mm/memcomp/payload.h b/mm/memcomp/payload.h
new file mode 100644
index 0000000000000000000000000000000000000000..34ba364cfcc8a073e80c417bed226837a78443b5
--- /dev/null
+++ b/mm/memcomp/payload.h
@@ -0,0 +1,151 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_PAYLOAD_H
+#define _MM_MEMCOMP_PAYLOAD_H
+
+/* Prepared outside T; charge and zs ownership transfer only on commit. */
+struct mc16_payload {
+	u64 word;
+	u32 bytes;
+	u32 charge;
+};
+
+/* Finish before putting the guard: its key still owns the accounting owner. */
+struct mc16_payload_tail {
+	struct folio *resident;
+	u64 word;
+	u32 bytes;
+	u32 new_bytes;
+	u32 charge;
+	u16 length;
+	u16 flags;
+};
+
+static inline int mc16_payload_charge(struct memcomp_ref *ref,
+				      struct mc16_payload *payload)
+{
+	struct obj_cgroup *objcg = ref->cluster->key->objcg;
+	int ret;
+
+	if (payload->bytes > PAGE_SIZE || payload->charge)
+		return -EINVAL;
+	if (!objcg || !payload->bytes)
+		return 0;
+	ret = memcomp_objcg_charge(objcg, GFP_NOWAIT | __GFP_NOWARN,
+				   payload->bytes);
+	if (!ret)
+		payload->charge = payload->bytes;
+	return ret;
+}
+
+/* The guard must still be held; same-fill word is never a zs handle. */
+static inline void mc16_payload_abort(struct memcomp_ref *ref,
+				      struct mc16_payload *payload)
+{
+	if (payload->bytes && payload->word)
+		memcomp_zs_free(0, payload->word);
+	memcomp_objcg_uncharge(ref->cluster->key->objcg, payload->charge);
+	*payload = (struct mc16_payload) { };
+}
+
+static inline void mc16_payload_account(unsigned int old_state, u32 old_bytes,
+					unsigned int new_state, u32 new_bytes)
+{
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	bool old_same = old_state == MC16_SAMEFILL;
+	bool new_same = new_state == MC16_SAMEFILL;
+	bool old_raw = !old_same && old_bytes == PAGE_SIZE;
+	bool new_raw = !new_same && new_bytes == PAGE_SIZE;
+
+	if (old_same != new_same)
+		this_cpu_add(memcomp_state_stats.samefill_pages, new_same ? 1 : -1);
+	if (old_raw != new_raw)
+		this_cpu_add(memcomp_state_stats.raw_pages, new_raw ? 1 : -1);
+#endif
+}
+
+/*
+ * T is already held. No new ref, allocation, or T/X acquisition is needed.
+ * A rejected identity/state leaves both payloads and their charges intact.
+ * OWNER keeps this member attached; owner removal normalizes it later.
+ */
+static inline int
+mc16_payload_commit_locked(struct memcomp_ref *ref, struct folio *folio,
+			   unsigned int nr_pages, unsigned int page_idx,
+			   struct mc16_payload *payload,
+			   struct mc16_payload_tail *tail)
+{
+	struct mc16_view view;
+	unsigned int old_state, new_state;
+	u32 old_bytes = 0;
+	u16 length, flags;
+
+	if (!mc16_view_locked(ref, &view) || !view.record ||
+	    !(*view.flags & MC16_F_OWNER) || view.member->owner_folio != folio ||
+	    view.record->nr_pages != nr_pages ||
+	    ref->token - view.record->token_base != page_idx)
+		return -ESTALE;
+	old_state = mc16_flags_state(*view.flags);
+	if (old_state == MC16_WRITEBACK)
+		return -EAGAIN;
+	if (old_state != MC16_PENDING && old_state != MC16_STORED &&
+	    old_state != MC16_SAMEFILL && old_state != MC16_SWAPPED)
+		return -EIO;
+	if (old_state != MC16_PENDING &&
+	    !mc16_payload_length_decode(old_state, *view.length, &old_bytes))
+		return -EIO;
+	new_state = payload->bytes ? MC16_STORED : MC16_SAMEFILL;
+	if (payload->bytes > PAGE_SIZE ||
+	    !mc16_payload_length_encode(new_state, payload->bytes, &length) ||
+	    payload->charge != (view.record->objcg ? payload->bytes : 0))
+		return -EINVAL;
+	*tail = (struct mc16_payload_tail) {
+		.resident = (*view.flags & MC16_F_RESIDENT) ?
+			    view.member->owner_folio : NULL,
+		.word = *view.word, .bytes = old_bytes,
+		.new_bytes = payload->bytes, .charge = view.member->payload_charge,
+		.length = *view.length, .flags = *view.flags,
+	};
+	flags = *view.flags & ~(MC16_STATE_MASK | MC16_F_RESIDENT |
+				 MC16_F_REFRESH_PENDING);
+	*view.word = payload->word;
+	*view.length = length;
+	*view.flags = flags | new_state;
+	view.member->payload_charge = payload->charge;
+	mc16_payload_account(old_state, old_bytes, new_state, payload->bytes);
+	mc16_fifo_transition(ref, old_state, new_state);
+	*payload = (struct mc16_payload) { };
+	return 0;
+}
+
+static inline void mc16_payload_finish(struct memcomp_ref *ref,
+				       struct mc16_payload_tail *tail)
+{
+	unsigned int state = mc16_flags_state(tail->flags);
+
+	if (state == MC16_STORED) {
+		memcomp_zs_free(0, tail->word);
+	} else if (state == MC16_SWAPPED) {
+#ifdef CONFIG_SWAP
+		struct mc16_swap_fields swap;
+
+		if (WARN_ON_ONCE(!mc16_swap_decode(tail->word, tail->length, &swap)))
+			return;
+		if (swap.packed)
+			memcomp_slot_put_packed(swp_entry(swap.type, swap.swap_offset));
+		else
+			memcomp_slot_put(swp_entry(swap.type, swap.swap_offset));
+		memcomp_debug_long_dec(&memcomp_swapped_entries);
+#endif
+	}
+	memcomp_objcg_uncharge(ref->cluster->key->objcg, tail->charge);
+	if (tail->resident)
+		folio_put(tail->resident);
+	if (state == MC16_PENDING)
+		memcomp_debug_dec(&memcomp_pending_pages);
+	if (tail->new_bytes != tail->bytes) {
+		memcomp_compressed_bytes_add(tail->new_bytes);
+		memcomp_compressed_bytes_sub(tail->bytes);
+	}
+	*tail = (struct mc16_payload_tail) { };
+}
+#endif /* _MM_MEMCOMP_PAYLOAD_H */
diff --git a/mm/memcomp/query.h b/mm/memcomp/query.h
new file mode 100644
index 0000000000000000000000000000000000000000..467064a7ac9ae576058e6e6450825957365c3310
--- /dev/null
+++ b/mm/memcomp/query.h
@@ -0,0 +1,187 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_QUERY_H
+#define _MM_MEMCOMP_QUERY_H
+
+#include <linux/errno.h>
+#include <linux/limits.h>
+#include <linux/minmax.h>
+
+/* Include after zero/storage/access/refs/span. Public dispatch is separate. */
+
+/* RCU-only observation: no reference acquisition and no lifetime guarantee. */
+static inline bool mc16_entry_present(unsigned long token)
+{
+	struct mc16_cluster *cluster;
+	struct mc16_slot *segment;
+	unsigned int id, index;
+	bool present = false;
+
+	if (mc16_zero_entry_stat(token, NULL, NULL))
+		return true;
+	if (token > U32_MAX)
+		return false;
+	id = token >> MC16_CLUSTER_SHIFT;
+	index = token & (MC16_CLUSTER_SLOTS - 1);
+	if (!id)
+		return false;
+
+	rcu_read_lock();
+	cluster = xa_load(&mc16_clusters, id);
+	/* Pair with reserve's release-next before reading initialized slots. */
+	if (!cluster || index >= smp_load_acquire(&cluster->next))
+		goto out;
+	/* Pair with segment publication; RCU protects a detached segment. */
+	segment = smp_load_acquire(&cluster->segments[index >> MC16_SEGMENT_SHIFT]);
+	if (!segment)
+		goto out;
+	present = refcount_read(&segment[index & (MC16_SEGMENT_SLOTS - 1)].refs) != 0;
+out:
+	rcu_read_unlock();
+	return present;
+}
+
+/*
+ * compressed == NULL: refs-only query, no T attempt or record access, valid
+ * under PTL/RCU. Mapcount approximates unified refs minus this lookup and the
+ * mirrored OWNER; temporary/WB refs and concurrent changes remain included.
+ *
+ * compressed != NULL: process-context diagnostic with one T trylock. False
+ * also means busy/invalid payload, not just absent; every requested output is
+ * zero on failure. Successful lengths are decoded effective-state snapshots.
+ */
+static inline bool mc16_entry_stat(unsigned long token,
+				   unsigned long *compressed, int *mapcount)
+{
+	struct memcomp_ref ref;
+	struct mc16_view view;
+	struct mutex *lock; /* Existing hashed token mutex T. */
+	unsigned int refs, state;
+	u32 bytes = 0;
+	u16 flags;
+	bool valid;
+
+	if (compressed)
+		*compressed = 0;
+	if (mapcount)
+		*mapcount = 0;
+	if (mc16_zero_entry_stat(token, compressed, mapcount))
+		return true;
+	if (!mc16_get(token, &ref))
+		return false;
+
+	if (compressed) {
+		lock = memcomp_lock_of(token);
+		if (!mutex_trylock(lock))
+			goto fail;
+		valid = mc16_view_locked(&ref, &view);
+		if (valid) {
+			flags = *view.flags;
+			state = mc16_flags_state(flags);
+			valid = mc16_flags_valid(flags);
+			if (valid && state == MC16_PENDING)
+				valid = flags & MC16_F_RESIDENT;
+			else if (valid)
+				valid = !(flags & MC16_F_RESIDENT) &&
+					mc16_payload_length_decode(state, *view.length,
+								   &bytes);
+		}
+		mutex_unlock(lock);
+		if (!valid)
+			goto fail;
+	}
+	if (mapcount) {
+		refs = refcount_read(&ref.slot->refs);
+		if (refs)
+			refs--;
+		if (refs && (READ_ONCE(ref.slot->flags) & MC16_F_OWNER))
+			refs--;
+		*mapcount = clamp_t(unsigned int, refs, 1, INT_MAX);
+	}
+	if (compressed)
+		*compressed = bytes;
+	mc16_ref_put(&ref);
+	return true;
+fail:
+	mc16_ref_put(&ref);
+	return false;
+}
+
+/* Zero is one pure-value page; a repeated zero token does not encode a span. */
+static inline unsigned int
+mc16_entry_geometry(unsigned long token, unsigned long *base_token,
+		    unsigned long *page_idx)
+{
+	struct memcomp_ref ref;
+	unsigned int nr, index;
+	u32 base;
+
+	if (base_token)
+		*base_token = token;
+	if (page_idx)
+		*page_idx = 0;
+	if (mc16_zero_entry_stat(token, NULL, NULL))
+		return 1;
+	if (!mc16_get(token, &ref))
+		return 0;
+	nr = mc16_ref_geometry(&ref, &base, &index);
+	mc16_ref_put(&ref);
+	if (nr) {
+		if (base_token)
+			*base_token = base;
+		if (page_idx)
+			*page_idx = index;
+	}
+	return nr;
+}
+
+static inline unsigned int
+mc16_entry_nr_pages(unsigned long token, unsigned long *base_token)
+{
+	return mc16_entry_geometry(token, base_token, NULL);
+}
+
+/*
+ * Return 1 for resident, 0 for nonresident/absent, -EAGAIN for busy/unreadable.
+ * ref must be non-NULL. A successful positive lookup retains its guard even
+ * when nonresident; zero, absent and negative returns leave an empty guard.
+ */
+static inline int mc16_entry_resident_get(unsigned long token,
+					  struct memcomp_ref *ref)
+{
+	struct mc16_view view;
+	struct mutex *lock; /* Existing hashed token mutex T. */
+	u16 flags;
+	bool valid, resident = false;
+
+	*ref = (struct memcomp_ref) { };
+	if (mc16_zero_entry_stat(token, NULL, NULL))
+		return 0;
+	if (!mc16_get(token, ref))
+		return 0;
+	lock = memcomp_lock_of(token);
+	if (!mutex_trylock(lock)) {
+		mc16_ref_put(ref);
+		return -EAGAIN;
+	}
+	valid = mc16_view_locked(ref, &view);
+	if (valid) {
+		flags = *view.flags;
+		valid = mc16_flags_valid(flags);
+		resident = mc16_flags_state(flags) == MC16_PENDING &&
+			   (flags & MC16_F_RESIDENT);
+	}
+	mutex_unlock(lock);
+	if (!valid) {
+		mc16_ref_put(ref);
+		return -EAGAIN;
+	}
+	return resident;
+}
+
+static inline void mc16_entry_resident_put(struct memcomp_ref *ref)
+{
+	if (ref->slot)
+		mc16_ref_put(ref);
+}
+
+#endif /* _MM_MEMCOMP_QUERY_H */
diff --git a/mm/memcomp/refs.h b/mm/memcomp/refs.h
new file mode 100644
index 0000000000000000000000000000000000000000..c7c3b616755e3e559a57b7b579b523e8d5bb3817
--- /dev/null
+++ b/mm/memcomp/refs.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_REFS_H
+#define _MM_MEMCOMP_REFS_H
+
+/* Counters describe effective payloads, not the physical PENDING tag. */
+static inline void mc16_account_state(struct memcomp_ref *ref, bool publish)
+{
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	struct mc16_view view;
+	unsigned int state;
+	u32 bytes = 0;
+	int delta = publish ? 1 : -1;
+
+	if (!mc16_view_owned(ref, &view))
+		return;
+	state = mc16_flags_state(*view.flags);
+	if (*view.flags & MC16_F_OWNER)
+		this_cpu_add(memcomp_state_stats.folio_owner_pages, delta);
+	if (state == MC16_SAMEFILL)
+		this_cpu_add(memcomp_state_stats.samefill_pages, delta);
+	else if (state != MC16_PENDING &&
+		 mc16_payload_length_decode(state, *view.length, &bytes) &&
+		 bytes == PAGE_SIZE)
+		this_cpu_add(memcomp_state_stats.raw_pages, delta);
+	if (ref->cluster->key->kind == MC16_KEY_SHMEM)
+		this_cpu_add(memcomp_state_stats.shmem_pages, delta);
+#endif
+}
+
+/* Producer owns these slots exclusively until its publication completes. */
+static inline void mc16_account_reservation(struct memcomp_ref *ref)
+{
+	memcomp_stored_bytes_inc();
+	memcomp_debug_inc(&memcomp_pending_pages);
+	mc16_account_state(ref, true);
+}
+
+/* Unique refs-zero winner; no T, and no access after retiring the slot. */
+static inline void mc16_ref_release(struct memcomp_ref *ref)
+{
+	struct mc16_view view;
+	unsigned int state;
+	u32 bytes = 0;
+
+	if (!mc16_view_owned(ref, &view))
+		return;
+	state = mc16_flags_state(*view.flags);
+	if (state != MC16_PENDING &&
+	    WARN_ON_ONCE(!mc16_payload_length_decode(state, *view.length, &bytes)))
+		return;
+	/* L removal finishes before X can remove the last cluster live slot. */
+	mc16_fifo_transition(ref, state, MC16_EMPTY);
+	arch_swap_invalidate_page(SWP_MEMCOMP, ref->token);
+	mc16_account_state(ref, false);
+	if (state == MC16_PENDING)
+		memcomp_debug_dec(&memcomp_pending_pages);
+	else if (state == MC16_SWAPPED)
+		memcomp_debug_long_dec(&memcomp_swapped_entries);
+	memcomp_stored_bytes_dec();
+	memcomp_compressed_bytes_sub(bytes);
+	mc16_release_resources(ref);
+	mc16_retire_slot(ref);
+}
+
+/* The caller proves ownership of nr actual references; no speculative sub. */
+static inline void mc16_ref_put_count(struct memcomp_ref *ref, unsigned int nr)
+{
+	bool last;
+
+	if (WARN_ON_ONCE(!ref->slot || !nr))
+		return;
+	last = refcount_sub_and_test(nr, &ref->slot->refs);
+	if (last)
+		mc16_ref_release(ref);
+	/* A non-final put consumes the caller's guard just as a final one does. */
+	*ref = (struct memcomp_ref) { };
+}
+
+static inline void mc16_ref_put(struct memcomp_ref *ref)
+{
+	mc16_ref_put_count(ref, 1);
+}
+#endif /* _MM_MEMCOMP_REFS_H */
diff --git a/mm/memcomp/resident.h b/mm/memcomp/resident.h
new file mode 100644
index 0000000000000000000000000000000000000000..fad9ddb2cc8def141dd330578eae2c8abe6aff82
--- /dev/null
+++ b/mm/memcomp/resident.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_RESIDENT_H
+#define _MM_MEMCOMP_RESIDENT_H
+
+/* Include after memcomp_map_resident() and memcomp_fault_sigbus_or_retry(). */
+static inline vm_fault_t
+mc16_resident_lock_or_retry(struct folio *folio, struct vm_fault *vmf)
+{
+	return folio_lock_or_retry(folio, vmf);
+}
+
+/*
+ * Borrow ref until handled is set: nonresident returns leave it intact. Every
+ * handled path consumes the lookup, and a successful PTE install consumes the
+ * removed token's PTE reference too, without another registry lookup.
+ *
+ * The folio_get under the first T protects the folio, not record/member. Re-read
+ * the effective view after locking the folio; never retain a record across T.
+ * Release T before taking PTL. The locked folio then excludes the producer's
+ * store/owner transition while the original complete PTE is checked.
+ *
+ * Success transfers this folio_get to the PTE. The producer's OWNER, resident
+ * hold and record anon_vma hold remain its responsibility. In particular this
+ * fault does not detach the head or put the producer's anon_vma. Retry inherits
+ * folio_lock_or_retry's fault-lock contract, including RETRY_NOWAIT retaining it.
+ */
+static inline vm_fault_t
+mc16_load_resident(struct vm_fault *vmf, struct memcomp_ref *ref, bool *handled)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct mc16_view view;
+	struct folio *folio;
+	unsigned int page_idx, index;
+	vm_fault_t ret;
+	bool valid;
+
+	*handled = false;
+	mutex_lock(memcomp_lock_of(ref->token));
+	if (!mc16_view_locked(ref, &view) || !mc16_flags_valid(*view.flags))
+		goto invalid;
+	if (mc16_flags_state(*view.flags) != MC16_PENDING ||
+	    !(*view.flags & MC16_F_RESIDENT)) {
+		mutex_unlock(memcomp_lock_of(ref->token));
+		return 0;
+	}
+	if (!view.record || !view.member ||
+	    !mc16_member_index(view.record, ref->token, &page_idx))
+		goto invalid;
+	folio = view.member->owner_folio;
+	if (!folio || page_idx >= folio_nr_pages(folio))
+		goto invalid;
+	folio_get(folio);
+	mutex_unlock(memcomp_lock_of(ref->token));
+	*handled = true;
+
+	ret = mc16_resident_lock_or_retry(folio, vmf);
+	if (ret) {
+		folio_put(folio);
+		mc16_ref_put(ref);
+		return ret;
+	}
+	mutex_lock(memcomp_lock_of(ref->token));
+	valid = mc16_view_locked(ref, &view) && mc16_flags_valid(*view.flags) &&
+		mc16_flags_state(*view.flags) == MC16_PENDING &&
+		(*view.flags & MC16_F_RESIDENT) && view.record && view.member &&
+		view.member->owner_folio == folio &&
+		mc16_member_index(view.record, ref->token, &index) &&
+		index == page_idx && index < folio_nr_pages(folio);
+	mutex_unlock(memcomp_lock_of(ref->token));
+	if (!valid)
+		goto out_put_folio;
+
+	if (!memcomp_pte_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
+				  &vmf->pte, &vmf->ptl))
+		goto out_put_folio;
+	if (!pte_same(ptep_get(vmf->pte), vmf->orig_pte)) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		vmf->pte = NULL;
+		goto out_put_folio;
+	}
+	if (memcomp_map_resident(vma, vmf->address, vmf->pte, vmf->orig_pte,
+				 folio, folio_page(folio, page_idx),
+				 vmf->flags & FAULT_FLAG_WRITE))
+		vmf->flags &= ~FAULT_FLAG_WRITE;
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	vmf->pte = NULL;
+	folio_unlock(folio);
+	/* This folio_get is now the PTE's; lookup + old PTE leave together. */
+	mc16_ref_put_count(ref, 2);
+	return VM_FAULT_NOPAGE;
+
+out_put_folio:
+	folio_unlock(folio);
+	folio_put(folio);
+	mc16_ref_put(ref);
+	return 0;
+invalid:
+	mutex_unlock(memcomp_lock_of(ref->token));
+	mc16_ref_put(ref);
+	*handled = true;
+	return memcomp_fault_sigbus_or_retry(vmf);
+}
+#endif /* _MM_MEMCOMP_RESIDENT_H */
diff --git a/mm/memcomp/scan.h b/mm/memcomp/scan.h
new file mode 100644
index 0000000000000000000000000000000000000000..0a766838c0726fad43cb281eb4e6c5d6048393dc
--- /dev/null
+++ b/mm/memcomp/scan.h
@@ -0,0 +1,115 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_SCAN_H
+#define _MM_MEMCOMP_SCAN_H
+
+/* Include after storage.h. No token lookup, T, W or record access here. */
+enum mc16_scan_result {
+	MC16_SCAN_GUARD,
+	MC16_SCAN_BUDGET,
+	MC16_SCAN_END,
+};
+
+#define MC16_SCAN_END_CURSOR	((u64)U32_MAX + 1)
+
+/*
+ * cursor/ref/scanned are non-NULL; ref must not own a guard on entry.
+ * Start at cursor 0 (or any token). END canonicalizes cursor to 2^32.
+ * A zero budget does no lookup and leaves a non-END cursor unchanged.
+ *
+ * Each initialized slot position costs one probe, including alignment holes,
+ * zero refs and absent segments. A reserved XA_ZERO_ENTRY cluster ID and
+ * an empty published header each cost one probe. Sparse absent IDs and a
+ * known unpublished tail are skipped for free. After a tail skip the next
+ * found entry consumes a probe or ends the walk, so skips cannot evade it.
+ * XA_RETRY_ENTRY follows xas_retry/reset semantics without consuming a probe;
+ * concurrent tree retries have no fixed scheduler/latency bound. The budget
+ * bounds examined positions/markers, not these primitive-internal restarts.
+ *
+ * GUARD owns exactly one reference, cursor is past its token, and scanned
+ * includes that probe. BUDGET is distinct from END; neither owns a guard.
+ * scanned is per call and never exceeds budget. No state filter is applied:
+ * the caller checks the effective state under T, then puts the guard before
+ * dropping W. Across W or between calls retain only the numeric cursor.
+ * This is a forward walk, not a snapshot of concurrent publications.
+ */
+static inline enum mc16_scan_result
+mc16_scan_next(u64 *cursor, unsigned int budget, struct memcomp_ref *ref,
+	       unsigned int *scanned)
+{
+	const u64 end = MC16_SCAN_END_CURSOR;
+	enum mc16_scan_result result;
+	unsigned int used = 0;
+	u64 pos = *cursor;
+
+	*ref = (struct memcomp_ref) { };
+	*scanned = 0;
+	if (pos >= end) {
+		*cursor = end;
+		return MC16_SCAN_END;
+	}
+	if (!budget)
+		return MC16_SCAN_BUDGET;
+	if (pos < MC16_CLUSTER_SLOTS)
+		pos = MC16_CLUSTER_SLOTS;
+
+	rcu_read_lock();
+	while (used < budget && pos < end) {
+		struct mc16_cluster *cluster;
+		struct mc16_slot *segment, *slot;
+		XA_STATE(xas, &mc16_clusters, pos >> MC16_CLUSTER_SHIFT);
+		unsigned long id;
+		unsigned int index, next;
+		void *entry;
+		u64 base;
+
+		/* Retain zero entries for accounting, unlike xa_find(). */
+		do {
+			entry = xas_find(&xas, MC16_MAX_CLUSTER_ID);
+		} while (!xa_is_zero(entry) && xas_retry(&xas, entry));
+		if (!entry) {
+			pos = end;
+			break;
+		}
+		id = xas.xa_index;
+		if (xa_is_zero(entry)) {
+			used++;
+			pos = ((u64)id + 1) << MC16_CLUSTER_SHIFT;
+			continue;
+		}
+		cluster = entry;
+		base = (u64)id << MC16_CLUSTER_SHIFT;
+		if (pos < base)
+			pos = base;
+		index = pos - base;
+		/* Initialized slots and holes precede release-next. */
+		next = smp_load_acquire(&cluster->next);
+		if (index >= next) {
+			if (!next)
+				used++;
+			pos = ((u64)id + 1) << MC16_CLUSTER_SHIFT;
+			continue;
+		}
+		used++;
+		pos++;
+		/* A detached segment stays allocated until its RCU grace. */
+		segment = smp_load_acquire(&cluster->segments[index >> MC16_SEGMENT_SHIFT]);
+		if (!segment)
+			continue;
+		slot = &segment[index & (MC16_SEGMENT_SLOTS - 1)];
+		if (!refcount_inc_not_zero(&slot->refs))
+			continue;
+		*ref = (struct memcomp_ref) {
+			.slot = slot, .cluster = cluster,
+			.token = (u32)(base + index),
+		};
+		result = MC16_SCAN_GUARD;
+		goto out;
+	}
+	result = pos == end ? MC16_SCAN_END : MC16_SCAN_BUDGET;
+out:
+	rcu_read_unlock();
+	*cursor = pos;
+	*scanned = used;
+	return result;
+}
+#endif /* _MM_MEMCOMP_SCAN_H */
diff --git a/mm/memcomp/span.h b/mm/memcomp/span.h
new file mode 100644
index 0000000000000000000000000000000000000000..58524f9bca2feb68bc6a3c8ca33e15c1b56a476a
--- /dev/null
+++ b/mm/memcomp/span.h
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_SPAN_H
+#define _MM_MEMCOMP_SPAN_H
+
+/* Immutable order bits suffice even after a member has been normalized. */
+static inline unsigned int mc16_ref_geometry(const struct memcomp_ref *ref,
+					     u32 *base, unsigned int *index)
+{
+	unsigned int nr, offset;
+	u16 flags;
+
+	if (!ref->slot)
+		return 0;
+	/* Normalize release-publishes the payload and preserves the order. */
+	flags = smp_load_acquire(&ref->slot->flags);
+	if (!mc16_flags_valid(flags))
+		return 0;
+	nr = 1U << ((flags & MC16_ORDER_MASK) >> MC16_ORDER_SHIFT);
+	offset = ref->token & (nr - 1);
+	if (base)
+		*base = ref->token - offset;
+	if (index)
+		*index = offset;
+	return nr;
+}
+
+/* Owns one lookup per successful output; failure consumes every lookup. */
+static inline bool mc16_span_get(u32 token, struct folio *folio,
+				 unsigned int nr_pages, bool pending,
+				 struct memcomp_ref *refs)
+{
+	unsigned int i, state, nr_found = 0;
+	struct mc16_view view;
+	bool match;
+
+	if (!nr_pages || nr_pages > MEMCOMP_MAX_COMPRESS_PAGES ||
+	    !is_power_of_2(nr_pages))
+		return false;
+	for (i = 0; i < nr_pages; i++)
+		refs[i] = (struct memcomp_ref) { };
+	if (!token || token > U32_MAX - (nr_pages - 1))
+		return false;
+	for (i = 0; i < nr_pages; i++) {
+		if (!mc16_get(token + i, &refs[i]))
+			goto fail;
+		nr_found++;
+		mutex_lock(memcomp_lock_of(refs[i].token));
+		match = mc16_owner_matches_locked(&refs[i], folio, nr_pages, i);
+		if (match) {
+			mc16_view_locked(&refs[i], &view);
+			state = mc16_flags_state(*view.flags);
+			match = mc16_flags_valid(*view.flags) && (pending ?
+				(state == MC16_PENDING &&
+				 (*view.flags & MC16_F_RESIDENT)) :
+				(state >= MC16_STORED && state <= MC16_SAMEFILL));
+		}
+		mutex_unlock(memcomp_lock_of(refs[i].token));
+		if (!match)
+			goto fail;
+	}
+	return true;
+fail:
+	while (nr_found)
+		mc16_ref_put(&refs[--nr_found]);
+	return false;
+}
+
+/*
+ * The locked folio's producer still owns its head member. Transfer its one
+ * anon_vma hold before head detach; put_anon_vma belongs to that sleepable
+ * producer tail, never to the PTL-safe final slot/member release.
+ */
+static inline struct anon_vma *
+mc16_span_take_anon_vma_locked(struct memcomp_ref *head, struct folio *folio,
+			       unsigned int nr_pages)
+{
+	struct mc16_view view;
+	struct anon_vma *anon_vma;
+
+	if (!mc16_owner_matches_locked(head, folio, nr_pages, 0) ||
+	    !mc16_view_locked(head, &view) ||
+	    !(view.record->record_flags & MC16_RECORD_ANON_VMA))
+		return NULL;
+	anon_vma = view.record->anon_vma;
+	view.record->anon_vma = NULL;
+	view.record->record_flags &= ~MC16_RECORD_ANON_VMA;
+	return anon_vma;
+}
+#endif /* _MM_MEMCOMP_SPAN_H */
diff --git a/mm/memcomp/storage.h b/mm/memcomp/storage.h
new file mode 100644
index 0000000000000000000000000000000000000000..bae605f20e79bec5d6dc5573f3148ef15e95ee84
--- /dev/null
+++ b/mm/memcomp/storage.h
@@ -0,0 +1,963 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_STORAGE_H
+#define _MM_MEMCOMP_STORAGE_H
+
+/*
+ * Include in memcomp.c after its accounting wrappers. Required static hooks:
+ * void memcomp_objcg_get_ref(struct obj_cgroup *); (test-model aware)
+ * void memcomp_objcg_put(struct obj_cgroup *);
+ * int memcomp_objcg_charge(struct obj_cgroup *, gfp_t, size_t);
+ * void memcomp_objcg_uncharge(struct obj_cgroup *, size_t);
+ *
+ * Record allocation/member lifetime, payload, T and L belong to the caller.
+ * reserve failure never consumes record members or resident folio references.
+ * Successful resident refs[] hold initial OWNER ownership. Cache refs[] are
+ * private, not-yet-activated reservations with zero refs; activate infallibly
+ * after accounting, before exposing tokens. They are never lookup guards.
+ * Cache reservation does not allocate a record.
+ * After refs reaches zero, release payload and complete L eligibility removal
+ * before mc16_retire_slot(). A guard is put by the caller without XA relookup.
+ *
+ * Metadata is allocated against the source owner and freed after RCU.
+ */
+#include <linux/err.h>
+#include <linux/atomic.h>
+#include <linux/hashtable.h>
+#include <linux/log2.h>
+#include <linux/memcontrol.h>
+#include <linux/mm.h>
+#include <linux/percpu.h>
+#include <linux/rcupdate.h>
+#include <linux/sched/mm.h>
+#include <linux/slab.h>
+#include <linux/shrinker.h>
+#include <linux/workqueue.h>
+#include <linux/xarray.h>
+
+#include "format.h"
+
+#define MC16_CLUSTER_SHIFT	9
+#define MC16_CLUSTER_SLOTS	BIT(MC16_CLUSTER_SHIFT)
+#define MC16_SEGMENT_SHIFT	6
+#define MC16_SEGMENT_SLOTS	BIT(MC16_SEGMENT_SHIFT)
+#define MC16_SEGMENTS		(MC16_CLUSTER_SLOTS / MC16_SEGMENT_SLOTS)
+#define MC16_MAX_CLUSTER_ID	(U32_MAX >> MC16_CLUSTER_SHIFT)
+#define MC16_KEY_HASH_BITS	8
+#define MC16_CLUSTER_AGED	BIT(0)
+#define MC16_AGING_BATCH	32
+
+struct mc16_key;
+
+struct mc16_cluster {
+	struct mc16_slot *segments[MC16_SEGMENTS];
+	struct mc16_key *key;
+	union {
+		struct list_head fifo;
+		struct rcu_head rcu;
+	};
+	u32 id;
+	u32 live_slots;
+	u16 next;
+	u16 wb_cursor;
+	u16 flags;
+	u16 eligible_slots;
+	u64 metadata_bytes;
+	u8 segment_live[MC16_SEGMENTS];
+	u8 reserved[8];
+};
+
+enum mc16_key_kind {
+	MC16_KEY_ANON,
+	MC16_KEY_SHMEM,
+};
+
+struct mc16_key {
+	struct hlist_node node;
+	struct obj_cgroup *objcg;
+	struct mc16_cluster *current_cluster;
+	u64 metadata_bytes;
+	u32 clusters;		/* X protected, including queued header callbacks. */
+	u16 nid;
+	u8 kind;
+	u8 zero_hint;
+};
+
+struct mc16_segment_retire {
+	struct rcu_head rcu;
+	struct mc16_slot *segment;
+};
+
+static_assert(sizeof(struct mc16_cluster) == 128);
+static_assert(offsetof(struct mc16_cluster, segments) == 0);
+static_assert(offsetof(struct mc16_cluster, key) == 64);
+static_assert(offsetof(struct mc16_cluster, fifo) == 72);
+static_assert(offsetof(struct mc16_cluster, rcu) == 72);
+static_assert(offsetof(struct mc16_cluster, id) == 88);
+static_assert(offsetof(struct mc16_cluster, live_slots) == 92);
+static_assert(offsetof(struct mc16_cluster, next) == 96);
+static_assert(offsetof(struct mc16_cluster, wb_cursor) == 98);
+static_assert(offsetof(struct mc16_cluster, flags) == 100);
+static_assert(offsetof(struct mc16_cluster, eligible_slots) == 102);
+static_assert(offsetof(struct mc16_cluster, metadata_bytes) == 104);
+static_assert(offsetof(struct mc16_cluster, segment_live) == 112);
+static_assert(offsetof(struct mc16_cluster, reserved) == 120);
+static_assert(sizeof(struct memcomp_ref) == 24);
+static_assert(MC16_SEGMENT_SLOTS * sizeof(struct mc16_slot) == 1024);
+
+enum mc16_storage_class {
+	MC16_META_SEGMENT,
+	MC16_META_CLUSTER,
+	MC16_META_KEY,
+	MC16_META_DESCRIPTOR,
+	MC16_META_CLASSES,
+};
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+struct mc16_storage_debug {
+	u64 allocated[MC16_META_CLASSES];
+	u64 freed[MC16_META_CLASSES];
+	u64 allocated_bytes[MC16_META_CLASSES];
+	u64 freed_bytes[MC16_META_CLASSES];
+	u64 descriptor_failures;
+	u64 meta_count_calls;
+	u64 meta_scan_calls;
+	u64 meta_detached;
+	u64 aging_work_calls;
+	u64 aging_detached;
+};
+
+static DEFINE_PER_CPU(struct mc16_storage_debug, mc16_storage_debug);
+#endif
+
+static inline void mc16_meta_alloc(enum mc16_storage_class type, void *ptr)
+{
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	this_cpu_inc(mc16_storage_debug.allocated[type]);
+	this_cpu_add(mc16_storage_debug.allocated_bytes[type], ksize(ptr));
+#endif
+}
+
+static inline void mc16_meta_free(enum mc16_storage_class type, void *ptr)
+{
+	if (!ptr)
+		return;
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	this_cpu_inc(mc16_storage_debug.freed[type]);
+	this_cpu_add(mc16_storage_debug.freed_bytes[type], ksize(ptr));
+#endif
+	kfree(ptr);
+}
+
+static DEFINE_XARRAY_FLAGS(mc16_clusters,
+			   XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_IRQ);
+static DEFINE_HASHTABLE(mc16_keys, MC16_KEY_HASH_BITS);
+static unsigned long mc16_retained_empty_headers;
+static unsigned long mc16_meta_shrinker_cursor = 1;
+static void mc16_retained_age_work(struct work_struct *work);
+static DECLARE_DEFERRABLE_WORK(mc16_retained_aging, mc16_retained_age_work);
+
+/* X protects the numeric sweep state; no iterator survives an unlock. */
+static struct {
+	unsigned long next_id;
+	unsigned long not_before;
+	bool active;
+	bool deadline_valid;
+	bool requested;
+} mc16_aging = { .next_id = 1 };
+
+static unsigned long mc16_aging_now(void)
+{
+	return jiffies;
+}
+
+static void mc16_queue_aging(unsigned long delay)
+{
+	mod_delayed_work(system_unbound_wq, &mc16_retained_aging, delay);
+}
+
+static void mc16_schedule_aging(void)
+{
+	unsigned long irqflags, now, delay;
+
+	xa_lock_irqsave(&mc16_clusters, irqflags);
+	if (mc16_aging.requested) {
+		xa_unlock_irqrestore(&mc16_clusters, irqflags);
+		return;
+	}
+	now = mc16_aging_now();
+	mc16_aging.requested = true;
+	if (!mc16_aging.deadline_valid) {
+		mc16_aging.not_before = now + HZ;
+		mc16_aging.deadline_valid = true;
+	}
+	delay = !mc16_aging.active &&
+		time_before(now, mc16_aging.not_before) ?
+		mc16_aging.not_before - now : 0;
+	xa_unlock_irqrestore(&mc16_clusters, irqflags);
+	/* An early concurrent kick cannot bypass the callback's deadline. */
+	mc16_queue_aging(delay);
+}
+
+static inline bool mc16_retained_empty_inc_locked(void)
+{
+	unsigned long count;
+
+	lockdep_assert_held(&mc16_clusters.xa_lock);
+	count = READ_ONCE(mc16_retained_empty_headers);
+	WRITE_ONCE(mc16_retained_empty_headers, count + 1);
+	return !count;
+}
+
+static inline void mc16_retained_empty_dec_locked(void)
+{
+	unsigned long count;
+
+	lockdep_assert_held(&mc16_clusters.xa_lock);
+	count = READ_ONCE(mc16_retained_empty_headers);
+	if (WARN_ON_ONCE(!count))
+		return;
+	WRITE_ONCE(mc16_retained_empty_headers, count - 1);
+}
+
+/* A real source objcg reference is held by record/caller/key in this scope. */
+static inline void *mc16_kmalloc_owner(size_t bytes, gfp_t gfp,
+				       struct obj_cgroup *objcg)
+{
+	/* Metadata remains unaccounted until a source owner is introduced. */
+	return kmalloc(bytes, gfp & ~__GFP_ACCOUNT);
+}
+
+static inline void *mc16_owner_alloc(size_t bytes, gfp_t gfp,
+				     struct obj_cgroup *objcg)
+{
+	return mc16_kmalloc_owner(bytes, gfp, objcg);
+}
+
+static inline void mc16_queue_rcu(struct rcu_head *head, rcu_callback_t func)
+{
+	call_rcu(head, func);
+}
+
+static inline void *mc16_alloc_zero(enum mc16_storage_class type,
+				    size_t bytes, struct obj_cgroup *objcg)
+{
+	void *ptr;
+
+	ptr = mc16_owner_alloc(bytes, GFP_NOIO | __GFP_NOWARN, objcg);
+	if (ptr) {
+		memset(ptr, 0, bytes);
+		mc16_meta_alloc(type, ptr);
+	}
+	return ptr;
+}
+
+/* Caller holds mc16_clusters.xa_lock for every key/current operation. */
+static inline unsigned long mc16_key_tag(struct obj_cgroup *objcg,
+					 unsigned int nid, u8 kind,
+					 bool zero_hint)
+{
+	return (unsigned long)objcg ^ ((unsigned long)nid << 1) ^ kind ^
+		((unsigned long)zero_hint << 3);
+}
+
+static inline struct mc16_key *
+mc16_key_find(struct obj_cgroup *objcg, unsigned int nid, u8 kind,
+	      bool zero_hint)
+{
+	struct mc16_key *key;
+	unsigned long tag = mc16_key_tag(objcg, nid, kind, zero_hint);
+
+	lockdep_assert_held(&mc16_clusters.xa_lock);
+	hash_for_each_possible(mc16_keys, key, node, tag) {
+		if (key->objcg == objcg && key->nid == nid && key->kind == kind &&
+		    key->zero_hint == zero_hint)
+			return key;
+	}
+	return NULL;
+}
+
+static inline int mc16_private_id_alloc(u32 *id)
+{
+	return __xa_alloc(&mc16_clusters, id, NULL,
+			  XA_LIMIT(1, MC16_MAX_CLUSTER_ID),
+			  GFP_NOWAIT | __GFP_NOWARN);
+}
+
+static inline struct mc16_key *mc16_key_zalloc(void)
+{
+	return kzalloc(sizeof(struct mc16_key), GFP_NOIO | __GFP_NOWARN);
+}
+
+/* Key slab is manually charged, with one independent test-aware objcg hold. */
+static inline struct mc16_key *
+mc16_key_alloc(struct obj_cgroup *objcg, unsigned int nid, u8 kind,
+	       bool zero_hint)
+{
+	struct mc16_key *key;
+	int ret;
+
+	key = mc16_key_zalloc();
+	if (!key)
+		return ERR_PTR(-ENOMEM);
+	mc16_meta_alloc(MC16_META_KEY, key);
+	key->metadata_bytes = ksize(key);
+	if (objcg) {
+		ret = memcomp_objcg_charge(objcg, GFP_NOIO | __GFP_NOWARN,
+					   key->metadata_bytes);
+		if (ret) {
+			mc16_meta_free(MC16_META_KEY, key);
+			return ERR_PTR(ret);
+		}
+		memcomp_objcg_get_ref(objcg);
+	}
+	key->objcg = objcg;
+	key->nid = nid;
+	key->kind = kind;
+	key->zero_hint = zero_hint;
+	return key;
+}
+
+static inline void mc16_key_free(struct mc16_key *key)
+{
+	struct obj_cgroup *objcg;
+
+	if (!key)
+		return;
+	objcg = key->objcg;
+	if (objcg) {
+		memcomp_objcg_uncharge(objcg, key->metadata_bytes);
+		memcomp_objcg_put(objcg);
+	}
+	mc16_meta_free(MC16_META_KEY, key);
+}
+
+static inline bool mc16_get(unsigned long token, struct memcomp_ref *out)
+{
+	struct mc16_cluster *cluster;
+	struct mc16_slot *segment, *slot;
+	unsigned int index, id;
+	bool found = false;
+
+	if (!out)
+		return false;
+	*out = (struct memcomp_ref) { };
+	if (!token || token > U32_MAX)
+		return false;
+	id = token >> MC16_CLUSTER_SHIFT;
+	index = token & (MC16_CLUSTER_SLOTS - 1);
+	if (!id)
+		return false;
+
+	rcu_read_lock();
+	cluster = xa_load(&mc16_clusters, id);
+	if (!cluster)
+		goto out;
+	/* Pair with release-next: all slots and alignment holes are initialized. */
+	if (index >= smp_load_acquire(&cluster->next))
+		goto out;
+	/* Pair with segment install; RCU protects a concurrently detached one. */
+	segment = smp_load_acquire(&cluster->segments[index >> MC16_SEGMENT_SHIFT]);
+	if (!segment)
+		goto out;
+	slot = &segment[index & (MC16_SEGMENT_SLOTS - 1)];
+	if (!refcount_inc_not_zero(&slot->refs))
+		goto out;
+	out->slot = slot;
+	out->cluster = cluster;
+	out->token = token;
+	found = true;
+out:
+	rcu_read_unlock();
+	return found;
+}
+
+static inline void mc16_segment_rcu_free(struct rcu_head *rcu)
+{
+	struct mc16_segment_retire *retired;
+
+	retired = container_of(rcu, struct mc16_segment_retire, rcu);
+	mc16_meta_free(MC16_META_SEGMENT, retired->segment);
+	mc16_meta_free(MC16_META_DESCRIPTOR, retired);
+}
+
+static inline void mc16_cluster_rcu_free(struct rcu_head *rcu)
+{
+	struct mc16_cluster *cluster;
+	struct mc16_key *key, *last = NULL;
+	unsigned int i;
+	unsigned long irqflags;
+
+	cluster = container_of(rcu, struct mc16_cluster, rcu);
+	key = cluster->key;
+	for (i = 0; i < MC16_SEGMENTS; i++)
+		mc16_meta_free(MC16_META_SEGMENT, cluster->segments[i]);
+	mc16_meta_free(MC16_META_CLUSTER, cluster);
+
+	/* A queued header still owns its key until this exact transaction. */
+	xa_lock_irqsave(&mc16_clusters, irqflags);
+	if (WARN_ON_ONCE(!key->clusters)) {
+		xa_unlock_irqrestore(&mc16_clusters, irqflags);
+		return;
+	}
+	if (!--key->clusters) {
+		WARN_ON_ONCE(key->current_cluster);
+		hash_del(&key->node);
+		last = key;
+	}
+	xa_unlock_irqrestore(&mc16_clusters, irqflags);
+	mc16_key_free(last);
+}
+
+/* A detached header owns its key until mc16_cluster_rcu_free(). */
+static inline void mc16_queue_cluster(struct mc16_cluster *cluster)
+{
+	mc16_queue_rcu(&cluster->rcu, mc16_cluster_rcu_free);
+}
+
+/* Return -1 to stop, zero to continue, or the next full-pass delay. */
+static long mc16_aging_step_locked(unsigned long now,
+				   struct mc16_cluster **detached, unsigned int *nr_detached,
+				   unsigned int *checked)
+{
+	bool complete = false;
+
+	lockdep_assert_held(&mc16_clusters.xa_lock);
+	*nr_detached = 0;
+	*checked = 0;
+	mc16_aging.requested = false;
+	if (!READ_ONCE(mc16_retained_empty_headers)) {
+		mc16_aging.active = false;
+		mc16_aging.next_id = 1;
+		return -1;
+	}
+	if (!mc16_aging.active && mc16_aging.deadline_valid &&
+	    time_before(now, mc16_aging.not_before))
+		return mc16_aging.not_before - now;
+	mc16_aging.active = true;
+
+	while (*checked < MC16_AGING_BATCH) {
+		XA_STATE(xas, &mc16_clusters, mc16_aging.next_id);
+		struct mc16_cluster *cluster;
+		unsigned long id;
+		void *entry;
+
+		/* Raw lookup exposes private reservations hidden by xa_find(). */
+		entry = xas_find(&xas, MC16_MAX_CLUSTER_ID);
+		if (!entry) {
+			complete = true;
+			break;
+		}
+		(*checked)++;
+		id = xas.xa_index;
+		if (id == MC16_MAX_CLUSTER_ID)
+			complete = true;
+		else
+			mc16_aging.next_id = id + 1;
+		if (xa_is_value(entry) || xa_is_internal(entry))
+			goto next;
+		cluster = entry;
+		if (cluster->id != id ||
+		    cluster->key->current_cluster != cluster ||
+		    cluster->live_slots || !cluster->next ||
+		    cluster->next >= MC16_CLUSTER_SLOTS ||
+		    cluster->eligible_slots || !list_empty(&cluster->fifo))
+			goto next;
+		if (!(cluster->flags & MC16_CLUSTER_AGED)) {
+			cluster->flags |= MC16_CLUSTER_AGED;
+			goto next;
+		}
+		mc16_retained_empty_dec_locked();
+		cluster->key->current_cluster = NULL;
+		__xa_erase(&mc16_clusters, cluster->id);
+		detached[(*nr_detached)++] = cluster;
+next:
+		/* Rebuild XA_STATE before the next lookup, including after erase. */
+		if (complete)
+			break;
+	}
+	if (complete) {
+		mc16_aging.next_id = 1;
+		mc16_aging.active = false;
+		mc16_aging.not_before = mc16_aging_now() + HZ;
+		mc16_aging.deadline_valid = true;
+	}
+	if (!READ_ONCE(mc16_retained_empty_headers)) {
+		mc16_aging.next_id = 1;
+		mc16_aging.active = false;
+		return -1;
+	}
+	return mc16_aging.active ? 0 : HZ;
+}
+
+/* Detached headers retain their keys until the existing RCU callback. */
+static void mc16_retained_age_work(struct work_struct *work)
+{
+	struct mc16_cluster *detached[MC16_AGING_BATCH];
+	unsigned long irqflags;
+	unsigned int checked, nr_detached, i;
+	long delay;
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	this_cpu_inc(mc16_storage_debug.aging_work_calls);
+#endif
+	xa_lock_irqsave(&mc16_clusters, irqflags);
+	delay = mc16_aging_step_locked(mc16_aging_now(), detached,
+				       &nr_detached, &checked);
+	xa_unlock_irqrestore(&mc16_clusters, irqflags);
+
+	for (i = 0; i < nr_detached; i++) {
+		mc16_queue_cluster(detached[i]);
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+		this_cpu_inc(mc16_storage_debug.aging_detached);
+#endif
+	}
+	if (delay >= 0)
+		mc16_queue_aging(delay);
+}
+
+static unsigned long mc16_meta_shrinker_count(struct shrinker *shrinker,
+					      struct shrink_control *sc)
+{
+	unsigned long count = READ_ONCE(mc16_retained_empty_headers);
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	this_cpu_inc(mc16_storage_debug.meta_count_calls);
+#endif
+	return count ? count : SHRINK_EMPTY;
+}
+
+static unsigned long mc16_meta_shrinker_scan(struct shrinker *shrinker,
+					     struct shrink_control *sc)
+{
+	struct mc16_cluster *detached[64];
+	unsigned long irqflags, start, id, max = MC16_MAX_CLUSTER_ID;
+	unsigned long limit = min_t(unsigned long, sc->nr_to_scan,
+				    ARRAY_SIZE(detached));
+	unsigned int checked = 0, nr_detached = 0, i;
+	bool wrapped = false;
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	this_cpu_inc(mc16_storage_debug.meta_scan_calls);
+#endif
+	sc->nr_scanned = 0;
+	if (!limit)
+		return 0;
+
+	xa_lock_irqsave(&mc16_clusters, irqflags);
+	start = mc16_meta_shrinker_cursor;
+	id = start;
+	while (checked < limit) {
+		struct mc16_cluster *cluster;
+
+		/* The normal API skips private zero entries as well as holes. */
+		cluster = xa_find(&mc16_clusters, &id, max, XA_PRESENT);
+		if (!cluster) {
+			if (wrapped || start == 1) {
+				id = 1;
+				break;
+			}
+			/* The disjoint second range cannot revisit an entry. */
+			id = 1;
+			max = start - 1;
+			wrapped = true;
+			continue;
+		}
+		if (xa_is_value(cluster) || xa_is_internal(cluster)) {
+			id++;
+			continue;
+		}
+		checked++;
+		if (cluster->id == id &&
+		    cluster->key->current_cluster == cluster &&
+		    !cluster->live_slots && cluster->next &&
+		    cluster->next < MC16_CLUSTER_SLOTS &&
+		    !cluster->eligible_slots && list_empty(&cluster->fifo)) {
+			mc16_retained_empty_dec_locked();
+			cluster->key->current_cluster = NULL;
+			__xa_erase(&mc16_clusters, id);
+			detached[nr_detached++] = cluster;
+		}
+		id++;
+	}
+	mc16_meta_shrinker_cursor = id > MC16_MAX_CLUSTER_ID ? 1 : id;
+	xa_unlock_irqrestore(&mc16_clusters, irqflags);
+	sc->nr_scanned = checked;
+
+	for (i = 0; i < nr_detached; i++)
+		mc16_queue_cluster(detached[i]);
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	this_cpu_add(mc16_storage_debug.meta_detached, nr_detached);
+#endif
+	/* do_shrink_slab() repeats a pass that scanned nothing until it stops. */
+	return checked ? nr_detached : SHRINK_STOP;
+}
+
+/* refs is already zero; no caller may use slot/cluster after this function. */
+static inline void mc16_retire_slot(struct memcomp_ref *ref)
+{
+	struct mc16_segment_retire *retired = NULL;
+	struct mc16_cluster *cluster, *last = NULL;
+	bool schedule_aging = false;
+	struct mc16_slot *segment;
+	unsigned int seg;
+	unsigned long irqflags;
+
+	if (WARN_ON_ONCE(!ref || !ref->slot || !ref->cluster))
+		return;
+	cluster = ref->cluster;
+	seg = (ref->token & (MC16_CLUSTER_SLOTS - 1)) >> MC16_SEGMENT_SHIFT;
+	if (WARN_ON_ONCE(refcount_read(&ref->slot->refs)))
+		return;
+
+	xa_lock_irqsave(&mc16_clusters, irqflags);
+	if (WARN_ON_ONCE(!cluster->live_slots || !cluster->segment_live[seg]) ||
+	    WARN_ON_ONCE(cluster->live_slots == 1 && cluster->eligible_slots)) {
+		xa_unlock_irqrestore(&mc16_clusters, irqflags);
+		return;
+	}
+	cluster->live_slots--;
+	cluster->segment_live[seg]--;
+	segment = cluster->segments[seg];
+	if (!cluster->segment_live[seg] &&
+	    cluster->next >= (seg + 1) * MC16_SEGMENT_SLOTS) {
+		retired = mc16_owner_alloc(sizeof(*retired),
+					   GFP_NOWAIT | __GFP_NOWARN, cluster->key->objcg);
+		if (retired) {
+			mc16_meta_alloc(MC16_META_DESCRIPTOR, retired);
+			retired->segment = segment;
+			/* Old RCU readers retain permanently zero refs until grace. */
+			smp_store_release(&cluster->segments[seg], NULL);
+		} else {
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+			this_cpu_inc(mc16_storage_debug.descriptor_failures);
+#endif
+		}
+	}
+	if (!cluster->live_slots) {
+		WARN_ON_ONCE(!list_empty(&cluster->fifo));
+		if (cluster->key->current_cluster == cluster &&
+		    cluster->next < MC16_CLUSTER_SLOTS) {
+			schedule_aging = mc16_retained_empty_inc_locked();
+		} else {
+			if (cluster->key->current_cluster == cluster)
+				cluster->key->current_cluster = NULL;
+			__xa_erase(&mc16_clusters, cluster->id);
+			last = cluster;
+		}
+	}
+	xa_unlock_irqrestore(&mc16_clusters, irqflags);
+	/* Non-winners never dereference cluster or slot after releasing X. */
+	*ref = (struct memcomp_ref) { };
+	if (schedule_aging)
+		mc16_schedule_aging();
+	if (retired)
+		mc16_queue_rcu(&retired->rcu, mc16_segment_rcu_free);
+	if (last)
+		mc16_queue_rcu(&last->rcu, mc16_cluster_rcu_free);
+}
+
+/* Under X, return an aligned range wholly inside one segment/cluster. */
+static inline bool mc16_range(struct mc16_cluster *cluster, unsigned int nr,
+			      unsigned int *index)
+{
+	unsigned int start;
+
+	if (!cluster)
+		return false;
+	start = ALIGN(cluster->next, nr);
+	if (start + nr > MC16_CLUSTER_SLOTS)
+		return false;
+	*index = start;
+	return true;
+}
+
+/* Independent of the later payload/T helpers; bytes zero means SAMEFILL. */
+struct mc16_initial_payload {
+	u64 word;
+	u32 bytes;
+};
+
+/* Stack-only identity; record or caller keeps objcg alive across X1/X2. */
+struct mc16_reserve_request {
+	struct mc16_record *record;
+	const struct mc16_initial_payload *payloads;
+	struct obj_cgroup *objcg;
+	unsigned int nid;
+	unsigned int nr;
+	u8 kind;
+	bool zero_hint;
+};
+
+/* Infallible commit: all input validation and allocation precedes this. */
+static inline void
+mc16_publish_slots(struct mc16_cluster *cluster,
+		   const struct mc16_reserve_request *request,
+		   unsigned int index, struct memcomp_ref refs[])
+{
+	struct mc16_slot *segment = cluster->segments[index >> MC16_SEGMENT_SHIFT];
+	struct mc16_record *record = request->record;
+	unsigned int i, nr = request->nr, order = ilog2(nr);
+	u32 base = (cluster->id << MC16_CLUSTER_SHIFT) | index;
+
+	cluster->flags &= ~MC16_CLUSTER_AGED;
+	if (record)
+		record->token_base = base;
+	for (i = 0; i < nr; i++) {
+		struct mc16_slot *slot;
+		u16 flags = order << MC16_ORDER_SHIFT;
+
+		slot = &segment[(index + i) & (MC16_SEGMENT_SLOTS - 1)];
+		if (record) {
+			folio_get(record->producer);
+			slot->word = (u64)(unsigned long)record;
+			slot->length = 0;
+			flags |= MC16_PENDING | MC16_F_OWNER | MC16_F_RESIDENT;
+		} else {
+			const struct mc16_initial_payload *initial;
+
+			initial = &request->payloads[i];
+			slot->word = initial->word;
+			slot->length = initial->bytes ? initial->bytes - 1 : 0;
+			flags |= initial->bytes ? MC16_STORED : MC16_SAMEFILL;
+		}
+		/* Cache initialization completes only after caller accounting. */
+		refcount_set(&slot->refs, record ? 1 : 0);
+		/* Stable SAMEFILL readers acquire flags before reading word. */
+		smp_store_release(&slot->flags, flags);
+		refs[i] = (struct memcomp_ref) {
+			.slot = slot, .cluster = cluster, .token = base + i,
+		};
+	}
+	cluster->live_slots += nr;
+	cluster->segment_live[index >> MC16_SEGMENT_SHIFT] += nr;
+	/* Includes permanently zero, never-reused alignment holes. */
+	smp_store_release(&cluster->next, index + nr);
+}
+
+/*
+ * P0: one X. P1: X1 preflight, source-owned allocation, X2 commit/cancel.
+ * No A/T/L, no reserve-local retry, no third X, no record-member put here.
+ * Validated request identity is independently owned across both sections.
+ */
+static inline int
+mc16_reserve_request(const struct mc16_reserve_request *request,
+		     struct memcomp_ref refs[])
+{
+	struct mc16_cluster *cluster = NULL, *spare_cluster = NULL;
+	struct mc16_cluster *replaced = NULL;
+	struct mc16_slot *spare_segment = NULL;
+	struct mc16_key *key, *spare_key = NULL;
+	struct obj_cgroup *objcg = request->objcg;
+	unsigned int nr = request->nr, nid = request->nid;
+	unsigned int index = 0, target_next = 0, target_id = 0, seg;
+	u32 private_id = 0;
+	unsigned long irqflags;
+	bool new_cluster, new_key, reserved = false;
+	u8 kind = request->kind;
+	int ret = 0;
+	void *old;
+
+	memset(refs, 0, sizeof(*refs) * nr);
+
+	xa_lock_irqsave(&mc16_clusters, irqflags);
+	key = mc16_key_find(objcg, nid, kind, request->zero_hint);
+	cluster = key ? key->current_cluster : NULL;
+	if (mc16_range(cluster, nr, &index)) {
+		seg = index >> MC16_SEGMENT_SHIFT;
+		if (cluster->segments[seg]) {
+			if (!cluster->live_slots && cluster->next)
+				mc16_retained_empty_dec_locked();
+			mc16_publish_slots(cluster, request, index, refs);
+			xa_unlock_irqrestore(&mc16_clusters, irqflags);
+			return 0;
+		}
+		new_cluster = false;
+		target_id = cluster->id;
+		target_next = cluster->next;
+	} else {
+		new_cluster = true;
+		/* NULL is converted internally to a private reserved marker. */
+		ret = mc16_private_id_alloc(&private_id);
+		if (ret) {
+			xa_unlock_irqrestore(&mc16_clusters, irqflags);
+			return ret;
+		}
+		reserved = true;
+		if (cluster) {
+			target_id = cluster->id;
+			target_next = cluster->next;
+		}
+	}
+	new_key = !key;
+	/* Carry only scalar geometry and independently owned source identity. */
+	cluster = NULL;
+	key = NULL;
+	xa_unlock_irqrestore(&mc16_clusters, irqflags);
+
+	spare_segment = mc16_alloc_zero(MC16_META_SEGMENT,
+					MC16_SEGMENT_SLOTS * sizeof(*spare_segment), objcg);
+	if (!spare_segment) {
+		ret = -ENOMEM;
+		goto recheck;
+	}
+	if (new_cluster) {
+		spare_cluster = mc16_alloc_zero(MC16_META_CLUSTER,
+						sizeof(*spare_cluster), objcg);
+		if (!spare_cluster) {
+			ret = -ENOMEM;
+			goto recheck;
+		}
+		spare_cluster->metadata_bytes = ksize(spare_cluster);
+		INIT_LIST_HEAD(&spare_cluster->fifo);
+	}
+	if (new_key) {
+		spare_key = mc16_key_alloc(objcg, nid, kind,
+					   request->zero_hint);
+		if (IS_ERR(spare_key)) {
+			ret = PTR_ERR(spare_key);
+			spare_key = NULL;
+		}
+	}
+recheck:
+	xa_lock_irqsave(&mc16_clusters, irqflags);
+	if (ret)
+		goto cancel;
+	key = mc16_key_find(objcg, nid, kind, request->zero_hint);
+	cluster = key ? key->current_cluster : NULL;
+	/* Reject competing consumption/retirement without another allocation. */
+	if ((cluster ? cluster->id : 0) != target_id ||
+	    (cluster && cluster->next != target_next)) {
+		ret = -EAGAIN;
+		goto cancel;
+	}
+	if (!new_cluster) {
+		if (!key || !mc16_range(cluster, nr, &index) ||
+		    cluster->segments[index >> MC16_SEGMENT_SHIFT]) {
+			ret = -EAGAIN;
+			goto cancel;
+		}
+	} else {
+		if (!key && !spare_key) {
+			ret = -EAGAIN;
+			goto cancel;
+		}
+		if (!key)
+			key = spare_key;
+		replaced = cluster && !cluster->live_slots ? cluster : NULL;
+		cluster = spare_cluster;
+		cluster->id = private_id;
+		cluster->key = key;
+		old = __xa_store(&mc16_clusters, private_id, cluster,
+				 GFP_NOWAIT | __GFP_NOWARN);
+		if (WARN_ON_ONCE(xa_is_err(old))) {
+			ret = xa_err(old);
+			replaced = NULL;
+			goto cancel;
+		}
+		WARN_ON_ONCE(old);
+		reserved = false;
+		spare_cluster = NULL;
+		if (key == spare_key) {
+			hash_add(mc16_keys, &key->node,
+				 mc16_key_tag(objcg, nid, kind,
+					      request->zero_hint));
+			spare_key = NULL;
+		}
+		key->clusters++;
+		if (replaced) {
+			mc16_retained_empty_dec_locked();
+			__xa_erase(&mc16_clusters, replaced->id);
+		}
+		key->current_cluster = cluster;
+		index = 0;
+	}
+	seg = index >> MC16_SEGMENT_SHIFT;
+	/* Pair with lookup acquire; only new, zeroed storage is installed. */
+	smp_store_release(&cluster->segments[seg], spare_segment);
+	spare_segment = NULL;
+	if (!new_cluster && !cluster->live_slots && cluster->next)
+		mc16_retained_empty_dec_locked();
+	mc16_publish_slots(cluster, request, index, refs);
+cancel:
+	if (reserved)
+		__xa_erase(&mc16_clusters, private_id);
+	xa_unlock_irqrestore(&mc16_clusters, irqflags);
+	/* Unpublished resources only; source/payload ownership stays with caller. */
+	mc16_meta_free(MC16_META_SEGMENT, spare_segment);
+	mc16_meta_free(MC16_META_CLUSTER, spare_cluster);
+	mc16_key_free(spare_key);
+	if (replaced)
+		mc16_queue_cluster(replaced);
+	return ret;
+}
+
+/* Existing resident reserve API and its record/member ownership are unchanged. */
+static inline int mc16_reserve_hint(struct mc16_record *record, unsigned int nr,
+				    u8 kind, bool zero_hint,
+				    struct memcomp_ref refs[])
+{
+	struct mc16_reserve_request request;
+
+	if (!record || !refs || !record->producer || !nr ||
+	    nr > MC16_MAX_PAGES || !is_power_of_2(nr) ||
+	    record->nr_pages != nr ||
+	    kind != !!(record->record_flags & MC16_RECORD_SHMEM))
+		return -EINVAL;
+	request = (struct mc16_reserve_request) {
+		.record = record, .objcg = record->objcg,
+		.nid = record->nid, .nr = nr, .kind = kind,
+		.zero_hint = zero_hint,
+	};
+	return mc16_reserve_request(&request, refs);
+}
+
+static inline int mc16_reserve(struct mc16_record *record, unsigned int nr,
+			       u8 kind, struct memcomp_ref refs[])
+{
+	return mc16_reserve_hint(record, nr, kind, false, refs);
+}
+
+/*
+ * Direct SHMEM cache ownership: no record, resident folio hold or lookup ref.
+ * Caller holds objcg (NULL for root), zs handles and exact bytes charges before
+ * entry, keeps objcg alive until return, and keeps payloads immutable throughout.
+ * Validate the entire span before X1: no error may follow partial publication.
+ * bytes == 0 is a full-width SAMEFILL word; otherwise word is a nonzero zs handle.
+ * Success transfers payload/charge ownership to stable slots, backed by the key's
+ * independent objcg hold. The source array is unchanged: caller must not abort it.
+ * Failure consumes nothing. refs[] is untouched on invalid input, zeroed after
+ * valid input reaches reserve. Caller must finish stats and infallible first
+ * activation before exposing tokens. Until then live_slots protects storage,
+ * but refs stay zero so FIFO/lookup cannot acquire a guard. Never get/put this
+ * private reservation or confuse its initial zero with a retired index.
+ */
+static inline int
+mc16_reserve_cache(struct obj_cgroup *objcg, unsigned int nid,
+		   const struct mc16_initial_payload payloads[],
+		   unsigned int nr, struct memcomp_ref refs[])
+{
+	struct mc16_reserve_request request;
+	unsigned int i, order, state;
+	u16 length, flags;
+
+	/* Check wide inputs before any narrowing, array access or output clearing. */
+	if (!payloads || !refs || nid > U16_MAX || nid >= MAX_NUMNODES ||
+	    !nr || nr > MC16_MAX_PAGES || !is_power_of_2(nr))
+		return -EINVAL;
+	order = ilog2(nr);
+	for (i = 0; i < nr; i++) {
+		state = payloads[i].bytes ? MC16_STORED : MC16_SAMEFILL;
+		if ((payloads[i].bytes && !payloads[i].word) ||
+		    !mc16_payload_length_encode(state, payloads[i].bytes, &length) ||
+		    !mc16_flags_encode(state, order, 0, &flags))
+			return -EINVAL;
+	}
+	request = (struct mc16_reserve_request) {
+		.payloads = payloads, .objcg = objcg,
+		.nid = nid, .nr = nr, .kind = MC16_KEY_SHMEM,
+		.zero_hint = false,
+	};
+	return mc16_reserve_request(&request, refs);
+}
+
+#endif /* _MM_MEMCOMP_STORAGE_H */
diff --git a/mm/memcomp/zero.h b/mm/memcomp/zero.h
new file mode 100644
index 0000000000000000000000000000000000000000..e5c5e67f1a83988f61498d829b5c346b0c650f4b
--- /dev/null
+++ b/mm/memcomp/zero.h
@@ -0,0 +1,205 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_ZERO_H
+#define _MM_MEMCOMP_ZERO_H
+
+#include <linux/compiler.h>
+#include <linux/limits.h>
+#include <asm/page.h>
+#include <linux/minmax.h>
+#include <linux/percpu.h>
+#include <linux/string.h>
+
+/*
+ * Pure-value ownership only: no slot, record, folio reference or objcg.
+ * The winning PTL/xa transaction accounts the actual committed owner count.
+ * Initial anonymous PTEs use pte_init; fork uses pte_get; removal uses pte_put.
+ * A failed installation accounts nothing, MOVE is neutral, and neither a
+ * transport folio nor a present shmem mapping owns an additional zero count.
+ * Cache ownership has its own get/put pair, independent of anonymous PTEs.
+ * These helpers neither publish PTEs nor select the producer's zero branch.
+ *
+ * The always-on production ledger is perCPU, not a new global hot-path RMW.
+ * Get and put may run on different CPUs, so individual CPU values can be
+ * negative. Sum ALL possible CPUs before interpreting either signed domain.
+ * Snapshots are observational, like the existing memcomp logical statistics;
+ * an in-flight cross-CPU transfer need not yield a transactional snapshot.
+ * There is no runtime reset and no per-CPU underflow test.
+ */
+struct mc16_zero_owners {
+	s64 pte_pages;
+	s64 cache_pages;
+};
+
+static DEFINE_PER_CPU(struct mc16_zero_owners, mc16_zero_owners);
+
+enum mc16_zero_event {
+	MC16_ZERO_PTE_INIT,
+	MC16_ZERO_PTE_GET,
+	MC16_ZERO_PTE_PUT,
+	MC16_ZERO_CACHE_GET,
+	MC16_ZERO_CACHE_PUT,
+	MC16_ZERO_EVENTS,
+};
+
+/* Separate from slot get/put, members, stored/compressed RMW and eligibility. */
+struct mc16_zero_diagnostics {
+	u64 calls[MC16_ZERO_EVENTS];
+	u64 pages[MC16_ZERO_EVENTS];
+};
+
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+static DEFINE_PER_CPU(struct mc16_zero_diagnostics, mc16_zero_diagnostics);
+#endif
+
+static inline void mc16_zero_event(enum mc16_zero_event event,
+				   unsigned long nr)
+{
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	this_cpu_inc(mc16_zero_diagnostics.calls[event]);
+	this_cpu_add(mc16_zero_diagnostics.pages[event], nr);
+#endif
+}
+
+/* Reject a wide unsigned input before signed conversion/negation. */
+static inline bool mc16_zero_nr_valid(unsigned long nr)
+{
+	return nr <= LONG_MAX;
+}
+
+static inline bool mc16_zero_pte_add(unsigned long nr,
+				     enum mc16_zero_event event)
+{
+	if (!mc16_zero_nr_valid(nr))
+		return false;
+	if (nr) {
+		this_cpu_add(mc16_zero_owners.pte_pages, (s64)nr);
+		mc16_zero_event(event, nr);
+	}
+	return true;
+}
+
+/* Initial committed PTEs, not fork gets and not a counter reset. */
+static inline bool mc16_zero_pte_init(unsigned long nr)
+{
+	return mc16_zero_pte_add(nr, MC16_ZERO_PTE_INIT);
+}
+
+static inline bool mc16_zero_pte_get(unsigned long nr)
+{
+	return mc16_zero_pte_add(nr, MC16_ZERO_PTE_GET);
+}
+
+/* Caller owns nr logical PTEs; this is not a speculative refcount put. */
+static inline bool mc16_zero_pte_put(unsigned long nr)
+{
+	if (!mc16_zero_nr_valid(nr))
+		return false;
+	if (nr) {
+		this_cpu_add(mc16_zero_owners.pte_pages, -(s64)nr);
+		mc16_zero_event(MC16_ZERO_PTE_PUT, nr);
+	}
+	return true;
+}
+
+static inline bool mc16_zero_cache_get(unsigned long nr)
+{
+	if (!mc16_zero_nr_valid(nr))
+		return false;
+	if (nr) {
+		this_cpu_add(mc16_zero_owners.cache_pages, (s64)nr);
+		mc16_zero_event(MC16_ZERO_CACHE_GET, nr);
+	}
+	return true;
+}
+
+static inline bool mc16_zero_cache_put(unsigned long nr)
+{
+	if (!mc16_zero_nr_valid(nr))
+		return false;
+	if (nr) {
+		this_cpu_add(mc16_zero_owners.cache_pages, -(s64)nr);
+		mc16_zero_event(MC16_ZERO_CACHE_PUT, nr);
+	}
+	return true;
+}
+
+/* Keep raw signed totals available to quiescent diagnostic/balance checks. */
+static inline void mc16_zero_owners_read(struct mc16_zero_owners *snapshot)
+{
+	u64 pte = 0, cache = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		const struct mc16_zero_owners *owners;
+
+		owners = per_cpu_ptr(&mc16_zero_owners, cpu);
+		/* Unsigned accumulation also handles negative perCPU contributions. */
+		pte += (u64)READ_ONCE(owners->pte_pages);
+		cache += (u64)READ_ONCE(owners->cache_pages);
+	}
+	snapshot->pte_pages = (s64)pte;
+	snapshot->cache_pages = (s64)cache;
+}
+
+static inline void
+mc16_zero_diagnostics_read(struct mc16_zero_diagnostics *snapshot)
+{
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	int cpu, event;
+#endif
+
+	memset(snapshot, 0, sizeof(*snapshot));
+#ifdef CONFIG_MEMCOMP_DEBUG_STATS
+	for_each_possible_cpu(cpu) {
+		const struct mc16_zero_diagnostics *debug;
+
+		debug = per_cpu_ptr(&mc16_zero_diagnostics, cpu);
+		for (event = 0; event < MC16_ZERO_EVENTS; event++) {
+			snapshot->calls[event] += READ_ONCE(debug->calls[event]);
+			snapshot->pages[event] += READ_ONCE(debug->pages[event]);
+		}
+	}
+#endif
+}
+
+static inline u64 mc16_zero_pages(void)
+{
+	struct mc16_zero_owners owners;
+
+	mc16_zero_owners_read(&owners);
+	/* Clamp only after summing each entire domain, never per CPU. */
+	return (u64)max_t(s64, 0, owners.pte_pages) +
+	       (u64)max_t(s64, 0, owners.cache_pages);
+}
+
+/*
+ * stat stored = slot stored + logical zero bytes, compressed = slot compressed.
+ * Do not also call the slot stored/compressed add/sub wrappers for zero owners,
+ * even with argument zero. No slot metadata, payload charge or eligible page.
+ * Debug samefill totals can add zero_pages once, as in the old zero backend.
+ */
+static inline u64 mc16_zero_stored_bytes(u64 slot_stored_bytes)
+{
+	return slot_stored_bytes + (mc16_zero_pages() << PAGE_SHIFT);
+}
+
+/* Already decoded MEMCOMP token only. Nonzero leaves optional outputs alone. */
+static inline bool mc16_zero_entry_stat(unsigned long token,
+					unsigned long *compressed, int *mapcount)
+{
+	if (token)
+		return false;
+	if (compressed)
+		*compressed = 0;
+	if (mapcount)
+		*mapcount = 1;
+	return true;
+}
+
+/* Exactly one readable base page; supports unaligned input, no codec/alloc. */
+static inline bool mc16_zero_is_page(const void *src, size_t bytes)
+{
+	return src && bytes == PAGE_SIZE && !memchr_inv(src, 0, PAGE_SIZE);
+}
+
+#endif /* _MM_MEMCOMP_ZERO_H */
diff --git a/mm/memcomp/zero_convert.h b/mm/memcomp/zero_convert.h
new file mode 100644
index 0000000000000000000000000000000000000000..f4fa549d490481cb264db6d2c773ea10afcdaa01
--- /dev/null
+++ b/mm/memcomp/zero_convert.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_ZERO_CONVERT_H
+#define _MM_MEMCOMP_ZERO_CONVERT_H
+
+/* Include after PTE map helpers, zero.h, refs.h and payload accessors. */
+struct mc16_zero_walk {
+	struct memcomp_ref ref;
+	unsigned int converted;
+};
+
+static bool mc16_zero_convert_one(struct folio *folio,
+				  struct vm_area_struct *vma,
+				  unsigned long address, void *arg)
+{
+	struct mc16_zero_walk *walk = arg;
+	struct mm_struct *mm = vma->vm_mm;
+	struct memcomp_ref removed;
+	spinlock_t *ptl; /* Protects the swap-format PTE transaction. */
+	pte_t *ptep;
+	pte_t orig;
+	pmd_t *pmd;
+
+	pmd = mm_find_pmd(mm, address);
+	if (!pmd || !memcomp_pte_map_lock(mm, pmd, address, &ptep, &ptl))
+		return true;
+	orig = ptep_get(ptep);
+	if (!is_swap_pte(orig) || pte_to_swp_entry(orig).val !=
+	    make_memcomp_entry(walk->ref.token).val) {
+		pte_unmap_unlock(ptep, ptl);
+		return true;
+	}
+
+	/* Only the winning PTL transaction creates a logical zero owner. */
+	set_pte_at(mm, address, ptep,
+		   pte_move_swp_offset(orig, -(long)walk->ref.token));
+	mc16_zero_pte_init(1);
+	/* Transfer the removed PTE's existing ownership, without a new get. */
+	removed = walk->ref;
+	mc16_ref_put(&removed);
+	pte_unmap_unlock(ptep, ptl);
+	walk->converted++;
+	return true;
+}
+
+/*
+ * Run after releasing the codec context and before dropping the pinned
+ * anon_vma. The folio remains locked through release_folio. A continuous
+ * source OWNER protects the borrowed carrier; no record/member is carried.
+ * Fork/MOVE may leave positive tokens behind: their SAMEFILL data stays
+ * valid, so this is a best-effort metadata saving, not a correctness gate.
+ */
+static inline unsigned int
+mc16_zero_convert_folio(struct folio *folio,
+			const struct mc16_zero_carrier *carrier)
+{
+	struct mc16_zero_walk walk = { };
+	struct rmap_walk_control rwc = {
+		.rmap_one = mc16_zero_convert_one,
+		.arg = &walk,
+	};
+	unsigned long token;
+
+	if (!carrier || !carrier->valid || !carrier->ready ||
+	    !carrier->ref.slot || !carrier->ref.cluster)
+		return 0;
+	token = carrier->token;
+	if (!folio_test_locked(folio) || folio_test_large(folio) ||
+	    !folio_test_anon(folio) || folio_mapped(folio) ||
+	    folio_maybe_dma_pinned(folio) || !token || token > U32_MAX ||
+	    carrier->ref.token != token ||
+	    !pages_identical(&folio->page, ZERO_PAGE(0)))
+		return 0;
+	/* OWNER survives until release_folio; only matching PTEs consume refs. */
+	walk.ref = carrier->ref;
+	rmap_walk(folio, &rwc);
+	return walk.converted;
+}
+#endif /* _MM_MEMCOMP_ZERO_CONVERT_H */
diff --git a/mm/memcomp/zero_load.h b/mm/memcomp/zero_load.h
new file mode 100644
index 0000000000000000000000000000000000000000..41f7af3f3699147907b57dd1f4c6d70e88312a67
--- /dev/null
+++ b/mm/memcomp/zero_load.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_ZERO_LOAD_H
+#define _MM_MEMCOMP_ZERO_LOAD_H
+
+#include <linux/highmem.h>
+
+/* Include after zero.h and memcomp_pte_map_lock(), in memcomp.c. */
+
+static inline vm_fault_t mc16_load_zero(struct vm_fault *vmf, bool *locked)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
+	vm_fault_t ret;
+	pte_t pte;
+
+	if (locked)
+		*locked = false;
+	ret = vmf_anon_prepare(vmf);
+	if (ret)
+		return ret;
+	folio = vma_alloc_zeroed_movable_folio(vma, vmf->address);
+	if (!folio)
+		return VM_FAULT_OOM;
+	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_HIGHUSER_MOVABLE)) {
+		folio_put(folio);
+		return VM_FAULT_OOM;
+	}
+	__folio_set_locked(folio);
+	__folio_set_swapbacked(folio);
+	folio->swap.val = 0;
+	__folio_mark_uptodate(folio);
+	if (!memcomp_pte_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
+				  &vmf->pte, &vmf->ptl))
+		goto out_free;
+	if (!pte_same(ptep_get(vmf->pte), vmf->orig_pte)) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		vmf->pte = NULL;
+		goto out_free;
+	}
+
+	pte = mk_pte(&folio->page, vma->vm_page_prot);
+	if (pte_swp_soft_dirty(vmf->orig_pte))
+		pte = pte_mksoft_dirty(pte);
+	if (pte_swp_uffd_wp(vmf->orig_pte))
+		pte = pte_mkuffd_wp(pte);
+	if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
+	    !pte_needs_soft_dirty_wp(vma, pte)) {
+		pte = pte_mkwrite(pte, vma);
+		if (vmf->flags & FAULT_FLAG_WRITE)
+			pte = pte_mkdirty(pte);
+	}
+	flush_icache_pages(vma, &folio->page, 1);
+	folio_add_new_anon_rmap(folio, vma, vmf->address, RMAP_EXCLUSIVE);
+	folio_add_lru_vma(folio, vma);
+	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
+	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -1);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
+	mc16_zero_pte_put(1);
+	arch_do_swap_page_nr(vma->vm_mm, vma, vmf->address, pte, pte, 1);
+	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
+	folio_unlock(folio);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	vmf->pte = NULL;
+	return VM_FAULT_NOPAGE;
+
+out_free:
+	folio_unlock(folio);
+	folio_put(folio);
+	return 0;
+}
+#endif /* _MM_MEMCOMP_ZERO_LOAD_H */
diff --git a/mm/memory.c b/mm/memory.c
index fcea5aa4c20a5c2dfe252e2d36a547891ede1396..6eca33a353da117e82c1238b64d724b034e03a1f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -78,6 +78,7 @@
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/sysctl.h>
+#include <linux/memcomp.h>
 
 #include <trace/events/kmem.h>
 
@@ -818,6 +819,29 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			set_pte_at(src_mm, addr, src_pte, pte);
 		}
 		rss[MM_SWAPENTS]++;
+	} else if (is_memcomp_entry(entry)) {
+		/*
+		 * Not -EIO.  That tells copy_pte_range() a swap count needs a
+		 * continuation page, and it answers by calling
+		 * add_swap_count_continuation() on this entry - whose type is
+		 * past MAX_SWAPFILES, so get_swap_device() logs a bad-entry
+		 * error and returns NULL, add_swap_count_continuation()
+		 * returns 0 rather than a failure, and the loop retries the
+		 * same pte for ever, one pr_err() per pass.
+		 *
+		 * A live memcomp pte holds a reference, so a failed lookup
+		 * here should not be possible; say so, and fail the fork
+		 * rather than hang it.
+		 */
+		if (!memcomp_entry_get(swp_offset(entry))) {
+			VM_WARN_ON_ONCE(1);
+			return -EBUSY;
+		}
+		rss[MM_SWAPENTS]++;
+		if (pte_swp_exclusive(orig_pte)) {
+			pte = pte_swp_clear_exclusive(orig_pte);
+			set_pte_at(src_mm, addr, src_pte, pte);
+		}
 	} else if (is_migration_entry(entry)) {
 		folio = pfn_swap_entry_folio(entry);
 
@@ -1651,6 +1675,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				continue;
 			rss[MM_SWAPENTS] -= nr;
 			free_swap_and_cache_nr(entry, nr);
+		} else if (is_memcomp_entry(entry)) {
+			max_nr = (end - addr) / PAGE_SIZE;
+			nr = memcomp_pte_batch(pte, max_nr);
+			if (!nr)
+				nr = 1;
+			if (!should_zap_cows(details))
+				continue;
+			rss[MM_SWAPENTS] -= nr;
+			memcomp_invalidate_nr(swp_offset(entry), nr);
 		} else if (is_migration_entry(entry)) {
 			folio = pfn_swap_entry_folio(entry);
 			if (!should_zap_folio(details, folio))
@@ -4220,7 +4253,14 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 	entry = pte_to_swp_entry(vmf->orig_pte);
 	if (unlikely(non_swap_entry(entry))) {
-		if (is_migration_entry(entry)) {
+		if (is_memcomp_entry(entry)) {
+			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+				vma_end_read(vma);
+				ret = VM_FAULT_RETRY;
+				goto out;
+			}
+			ret = memcomp_load(vmf, NULL);
+		} else if (is_migration_entry(entry)) {
 			migration_entry_wait(vma->vm_mm, vmf->pmd,
 					     vmf->address);
 		} else if (is_device_exclusive_entry(entry)) {
diff --git a/mm/migrate.c b/mm/migrate.c
index 927bf3354918d121d3e550b2360e625f6cb29696..7989111dd238aeb23b03885295071d2865a12124 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -44,6 +44,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
+#include <linux/memcomp.h>
 
 #include <asm/tlbflush.h>
 
@@ -757,6 +758,7 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
 			   enum migrate_mode mode)
 {
 	int rc, expected_count = folio_expected_refs(mapping, src);
+	int memcomp_migrated;
 
 	/* Check whether src does not have extra refs before we do more work */
 	if (folio_ref_count(src) != expected_count)
@@ -766,9 +768,16 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
 	if (unlikely(rc))
 		return rc;
 
+	memcomp_migrated = memcomp_migrate_folio(dst, src);
+	if (memcomp_migrated < 0)
+		return memcomp_migrated;
+
 	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
-	if (rc != MIGRATEPAGE_SUCCESS)
+	if (rc != MIGRATEPAGE_SUCCESS) {
+		if (memcomp_migrated > 0)
+			memcomp_migrate_folio_rollback(dst, src);
 		return rc;
+	}
 
 	if (src_private)
 		folio_attach_private(dst, folio_detach_private(src));
diff --git a/mm/rmap.c b/mm/rmap.c
index 5818b65141780ab068eadb81676fadbf7622b4b0..41f1b9f645a261021698d7972649264de391601f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -76,6 +76,7 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/mm_inline.h>
 #include <linux/oom.h>
+#include <linux/memcomp.h>
 
 #include <asm/tlbflush.h>
 
@@ -1852,17 +1853,26 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
 			swp_entry_t entry = page_swap_entry(subpage);
+			/* A reserved token, not an incompressible mark. */
+			bool reserved = folio_memcomp_reserved(folio);
 			pte_t swp_pte;
 			/*
 			 * Store the swap location in the pte.
 			 * See handle_pte_fault() ...
 			 */
 			if (unlikely(folio_test_swapbacked(folio) !=
-					folio_test_swapcache(folio))) {
+					folio_test_swapcache(folio)) && !reserved) {
 				WARN_ON_ONCE(1);
 				goto walk_abort;
 			}
 
+			/* Swapbacked folios take their token reference below. */
+			if (reserved && !folio_test_swapbacked(folio) &&
+			    !memcomp_entry_present(swp_offset(entry))) {
+				set_pte_at(mm, address, pvmw.pte, pteval);
+				goto walk_abort;
+			}
+
 			/* MADV_FREE page check */
 			if (!folio_test_swapbacked(folio)) {
 				int ref_count, map_count;
@@ -1913,12 +1923,20 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				goto walk_abort;
 			}
 
-			if (swap_duplicate(entry) < 0) {
+			if (reserved) {
+				if (!memcomp_entry_get(swp_offset(entry))) {
+					set_pte_at(mm, address, pvmw.pte, pteval);
+					goto walk_abort;
+				}
+			} else if (swap_duplicate(entry) < 0) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				swap_free(entry);
+				if (reserved)
+					memcomp_invalidate(swp_offset(entry));
+				else
+					swap_free(entry);
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
@@ -1926,7 +1944,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			/* See folio_try_share_anon_rmap(): clear PTE first. */
 			if (anon_exclusive &&
 			    folio_try_share_anon_rmap_pte(folio, subpage)) {
-				swap_free(entry);
+				if (reserved)
+					memcomp_invalidate(swp_offset(entry));
+				else
+					swap_free(entry);
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index b0a9071cfe1daee66f07a4d78454e0e4385526e1..db164301cfde631ce246929f0fe5944656edfb33 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -43,6 +43,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/memcomp.h>
 
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
@@ -1633,6 +1634,11 @@ void swap_free_nr(swp_entry_t entry, int nr_pages)
 	struct swap_info_struct *sis;
 	unsigned long offset = swp_offset(entry);
 
+	if (is_memcomp_entry(entry)) {
+		memcomp_invalidate_nr(offset, nr_pages);
+		return;
+	}
+
 	sis = _swap_info_get(entry);
 	if (!sis)
 		return;
@@ -1896,6 +1902,11 @@ void free_swap_and_cache_nr(swp_entry_t entry, int nr)
 	bool any_only_cache = false;
 	unsigned long offset;
 
+	if (is_memcomp_entry(entry)) {
+		memcomp_invalidate_nr(swp_offset(entry), nr);
+		return;
+	}
+
 	if (non_swap_entry(entry))
 		return;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b0a2ede6622674f546a2118a07ea76d14e7b6a33..75ed55fcc09c627940e73ca7f6262cf06e5b0bce 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -57,6 +57,9 @@
 #include <linux/rculist_nulls.h>
 #include <linux/random.h>
 #include <linux/mmu_notifier.h>
+#ifdef CONFIG_MEMCOMP
+#include <linux/memcomp.h>
+#endif
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -70,6 +73,12 @@
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>
+#ifdef CONFIG_MEMCOMP
+
+static inline int is_page_cache_freeable(struct folio *folio);
+static void handle_write_error(struct address_space *mapping,
+			       struct folio *folio, int error);
+#endif
 
 struct scan_control {
 	/* How many pages shrink_list() should reclaim */
@@ -183,6 +192,69 @@ struct scan_control {
 	struct reclaim_state reclaim_state;
 };
 
+#ifdef CONFIG_MEMCOMP
+
+static bool memcomp_fresh_reservation(struct folio *folio)
+{
+	return memcomp_reserve_eligible(folio) &&
+	       !folio_memcomp_reserved(folio);
+}
+
+static bool
+memcomp_precheck_fresh_ctx(struct folio *folio, unsigned int nr_pages,
+			   enum memcomp_reclaim_source source)
+{
+	if (!memcomp_fresh_reservation(folio))
+		return true;
+
+	return memcomp_reclaim_ctx_precheck(nr_pages, source);
+}
+
+static void memcomp_count_unmap_fail(unsigned int nr_pages)
+{
+	memcomp_count_anon_fail(MEMCOMP_ANON_UNMAP_FAIL, nr_pages);
+}
+
+static void memcomp_count_finish_fail(unsigned int nr_pages)
+{
+	memcomp_count_anon_fail(MEMCOMP_ANON_FINISH_FAIL, nr_pages);
+}
+
+static void memcomp_count_incompressible_skip(unsigned int nr_pages)
+{
+	memcomp_count_anon_fail(MEMCOMP_ANON_INCOMPRESSIBLE_SKIP,
+				nr_pages);
+}
+
+/*
+ * Reclaim stored the locked @folio but keeps it after all, normally because
+ * someone else holds a reference.  Whoever drops that reference last frees
+ * the folio with nothing to release its span, which would leave the entries
+ * owned by a folio that is gone, so drop its hold on them now.  Its PTEs
+ * already name the stored payloads; reclaimed again, it is stored afresh.
+ */
+static void memcomp_finish_fail(struct folio *folio,
+				unsigned int nr_pages)
+{
+	memcomp_count_finish_fail(nr_pages);
+	memcomp_invalidate_folio(folio);
+}
+
+static bool
+memcomp_swap_permitted(bool may_swap, unsigned long nr_swap,
+		       gfp_t gfp_mask)
+{
+	return may_swap && nr_swap && (gfp_mask & __GFP_IO);
+}
+
+/* A memcomp fallback must obey the same reclaim permission as swap. */
+static bool memcomp_can_swap(struct scan_control *sc)
+{
+	return memcomp_swap_permitted(sc->may_swap, total_swap_pages,
+					 sc->gfp_mask);
+}
+#endif
+
 #ifdef ARCH_HAS_PREFETCHW
 #define prefetchw_prev_lru_folio(_folio, _base, _field)			\
 	do {								\
@@ -339,6 +411,11 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 					  int nid,
 					  struct scan_control *sc)
 {
+#ifdef CONFIG_MEMCOMP
+	if (memcomp_available())
+		return true;
+
+#endif
 	if (memcg == NULL) {
 		/*
 		 * For non-memcg reclaim, is there
@@ -1067,9 +1144,17 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	while (!list_empty(folio_list)) {
 		struct address_space *mapping;
 		struct folio *folio;
+#ifdef CONFIG_MEMCOMP
+		struct memcomp_reclaim_ctx *memcomp_ctx = NULL;
+		enum memcomp_reclaim_source memcomp_source;
+#endif
 		enum folio_references references = FOLIOREF_RECLAIM;
 		bool dirty, writeback;
 		unsigned int nr_pages;
+#ifdef CONFIG_MEMCOMP
+		bool memcomp_reserved = false;
+		bool memcomp_stored = false;
+#endif
 
 		cond_resched();
 
@@ -1233,9 +1318,108 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 * Lazyfree folio could be freed directly
 		 */
 		if (folio_test_anon(folio) && folio_test_swapbacked(folio)) {
+#ifdef CONFIG_MEMCOMP
+			/* New dirty contents must get another compression attempt. */
+			if (memcomp_available() && folio_test_swapcache(folio) &&
+			    !folio_test_writeback(folio) && memcomp_folio_dirty(folio))
+				folio_free_swap(folio);
+#endif
 			if (!folio_test_swapcache(folio)) {
+#ifdef CONFIG_MEMCOMP
+				bool memcomp_attempted = false;
+				bool swap_attempted = false;
+
+				if (memcomp_available()) {
+					memcomp_count_initial_compress();
+					goto memcomp_try;
+				}
+				if (!memcomp_can_swap(sc))
+#else
 				if (!(sc->gfp_mask & __GFP_IO))
+#endif
 					goto keep_locked;
+#ifdef CONFIG_MEMCOMP
+				goto swap_try;
+
+memcomp_try:
+				memcomp_attempted = true;
+				if (nr_pages > 1 && !folio_test_large(folio)) {
+					sc->nr_scanned -= nr_pages - 1;
+					nr_pages = 1;
+				}
+				if (folio_maybe_dma_pinned(folio))
+					goto keep_locked;
+				/*
+				 * It did not compress last time and has not
+				 * changed: swap it if there is swap, rather than
+				 * compress it again for nothing, and otherwise
+				 * leave it be.
+				 */
+				if (memcomp_folio_incompressible(folio)) {
+					memcomp_count_incompressible_skip(nr_pages);
+					goto memcomp_fallback_swap;
+				}
+				if (folio_test_large(folio)) {
+					/* cannot split folio, skip it */
+					if (!can_split_folio(folio, 1, NULL))
+						goto activate_locked;
+					/*
+					 * Split partially mapped folios right away.
+					 * We can free the unmapped pages without IO.
+					 */
+					if (data_race(!list_empty(&folio->_deferred_list) &&
+						      folio_test_partially_mapped(folio)) &&
+					    split_folio_to_list(folio, folio_list))
+						goto activate_locked;
+					if (nr_pages > 1 && !folio_test_large(folio)) {
+						sc->nr_scanned -= nr_pages - 1;
+						nr_pages = 1;
+					}
+				}
+				memcomp_source = current_is_kswapd() ?
+					MEMCOMP_RECLAIM_KSWAPD :
+					MEMCOMP_RECLAIM_DIRECT;
+				if (!memcomp_precheck_fresh_ctx(folio, nr_pages,
+								memcomp_source))
+					goto memcomp_fallback_swap;
+				if (!memcomp_reserve(folio))
+					goto memcomp_fallback_swap;
+				memcomp_reserved = true;
+				memcomp_ctx = memcomp_reclaim_ctx_get(nr_pages,
+								      memcomp_source);
+				if (!memcomp_ctx) {
+					memcomp_rollback_folio(folio);
+					memcomp_reserved = false;
+					goto memcomp_fallback_swap;
+				}
+				goto anon_backing_ready;
+
+memcomp_fallback_swap:
+				/*
+				 * This is ordinary VM forward-progress fallback before
+				 * memcomp owns post-unmap tokens.  Policy writeback of
+				 * an owned payload is handled only by packed-swap reclaim.
+				 * No rollback leaves a span in folio->swap for
+				 * add_to_swap() to overwrite, only maybe a mark.
+				 */
+				if (WARN_ON_ONCE(folio_memcomp_reserved(folio)))
+					goto activate_locked;
+				if (!swap_attempted && memcomp_can_swap(sc)) {
+					memcomp_count_normal_swap_fallback();
+					goto swap_try;
+				}
+				goto activate_locked;
+
+swap_try:
+				swap_attempted = true;
+				if (!memcomp_can_swap(sc))
+					goto keep_locked;
+				if (get_nr_swap_pages() <= 0 &&
+				    memcomp_available() && !memcomp_attempted) {
+					memcomp_count_initial_compress();
+					goto memcomp_try;
+				}
+#endif
 				if (folio_maybe_dma_pinned(folio))
 					goto keep_locked;
 				if (folio_test_large(folio)) {
@@ -1254,6 +1438,13 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				if (!add_to_swap(folio)) {
 					int __maybe_unused order = folio_order(folio);
 
+#ifdef CONFIG_MEMCOMP
+					if (!memcomp_attempted &&
+					    memcomp_available()) {
+						memcomp_count_initial_compress();
+						goto memcomp_try;
+					}
+#endif
 					if (!folio_test_large(folio))
 						goto activate_locked_split;
 					/* Fallback to swap normal pages */
@@ -1270,6 +1461,10 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 					if (!add_to_swap(folio))
 						goto activate_locked_split;
 				}
+#ifdef CONFIG_MEMCOMP
+anon_backing_ready:
+				;
+#endif
 			}
 		}
 
@@ -1282,7 +1477,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			sc->nr_scanned -= (nr_pages - 1);
 			nr_pages = 1;
 		}
-
 		/*
 		 * The folio is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
@@ -1314,8 +1508,65 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				if (!was_swapbacked &&
 				    folio_test_swapbacked(folio))
 					stat->nr_lazyfree_fail += nr_pages;
+#ifdef CONFIG_MEMCOMP
+				if (memcomp_reserved) {
+					memcomp_count_unmap_fail(nr_pages);
+					memcomp_reclaim_ctx_put(memcomp_ctx);
+					memcomp_ctx = NULL;
+					memcomp_rollback_folio(folio);
+					memcomp_reserved = false;
+				}
+#endif
 				goto activate_locked;
 			}
+#ifdef CONFIG_MEMCOMP
+			if (memcomp_reserved) {
+				try_to_unmap_flush();
+				if (folio_mapped(folio)) {
+					memcomp_count_unmap_fail(nr_pages);
+					memcomp_reclaim_ctx_put(memcomp_ctx);
+					memcomp_ctx = NULL;
+					memcomp_rollback_folio(folio);
+					memcomp_reserved = false;
+					goto activate_locked;
+				}
+				if (!memcomp_store_after_unmap(folio,
+							       &memcomp_ctx)) {
+					memcomp_rollback_folio(folio);
+					memcomp_reserved = false;
+					goto activate_locked;
+				}
+				memcomp_stored = true;
+				if (folio_test_dirty(folio))
+					folio_clear_dirty(folio);
+				memcomp_reserved = false;
+			}
+		}
+
+		if (memcomp_reserved && !memcomp_stored &&
+		    !folio_mapped(folio)) {
+			try_to_unmap_flush();
+			if (folio_mapped(folio)) {
+				memcomp_count_unmap_fail(nr_pages);
+				memcomp_reclaim_ctx_put(memcomp_ctx);
+				memcomp_ctx = NULL;
+				memcomp_rollback_folio(folio);
+				memcomp_reserved = false;
+				goto activate_locked;
+			}
+			if (!memcomp_store_after_unmap(folio,
+						       &memcomp_ctx)) {
+				memcomp_rollback_folio(folio);
+				memcomp_reserved = false;
+				goto activate_locked;
+			}
+			memcomp_stored = true;
+		}
+		if (memcomp_reserved) {
+			if (folio_test_dirty(folio))
+				folio_clear_dirty(folio);
+			memcomp_reserved = false;
+#endif
 		}
 
 		/*
@@ -1371,7 +1622,15 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			 * starts and then write it out here.
 			 */
 			try_to_unmap_flush_dirty();
+#ifdef CONFIG_MEMCOMP
+			{
+				pageout_t pout;
+
+				pout = pageout(folio, mapping, &plug, folio_list);
+				switch (pout) {
+#else
 			switch (pageout(folio, mapping, &plug, folio_list)) {
+#endif
 			case PAGE_KEEP:
 				goto keep_locked;
 			case PAGE_ACTIVATE:
@@ -1410,6 +1669,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				fallthrough;
 			case PAGE_CLEAN:
 				; /* try to free the folio below */
+#ifdef CONFIG_MEMCOMP
+				}
+#endif
 			}
 		}
 
@@ -1472,8 +1734,16 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			count_vm_events(PGLAZYFREED, nr_pages);
 			count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
 		} else if (!mapping || !__remove_mapping(mapping, folio, true,
+#ifdef CONFIG_MEMCOMP
+							 sc->target_mem_cgroup)) {
+			if (mapping || !memcomp_release_folio(folio))
+#else
 							 sc->target_mem_cgroup))
+#endif
 			goto keep_locked;
+#ifdef CONFIG_MEMCOMP
+		}
+#endif
 
 		folio_unlock(folio);
 free_it:
@@ -1501,6 +1771,10 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			nr_pages = 1;
 		}
 activate_locked:
+#ifdef CONFIG_MEMCOMP
+		memcomp_reclaim_ctx_put(memcomp_ctx);
+		memcomp_ctx = NULL;
+#endif
 		/* Not a candidate for swapping, so reclaim swap space. */
 		if (folio_test_swapcache(folio) &&
 		    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
@@ -1513,14 +1787,28 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
 		}
 keep_locked:
+#ifdef CONFIG_MEMCOMP
+		memcomp_reclaim_ctx_put(memcomp_ctx);
+		memcomp_ctx = NULL;
+		if (memcomp_stored) {
+			memcomp_finish_fail(folio, nr_pages);
+			memcomp_stored = false;
+		}
+#endif
 		folio_unlock(folio);
 keep:
+#ifdef CONFIG_MEMCOMP
+		/*
+		 * A folio stored above is neither dirty nor in need of
+		 * release, so it only leaves through keep_locked.
+		 */
+		VM_WARN_ON_ONCE_FOLIO(memcomp_stored, folio);
+#endif
 		list_add(&folio->lru, &ret_folios);
 		VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
 				folio_test_unevictable(folio), folio);
 	}
 	/* 'folio_list' is always empty here */
-
 	/* Migrate folios selected for demotion */
 	nr_demoted = demote_folio_list(&demote_folios, pgdat);
 	nr_reclaimed += nr_demoted;
@@ -2387,8 +2675,14 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	unsigned long ap, fp;
 	enum lru_list lru;
 
+#ifdef CONFIG_MEMCOMP
+	/* If we have no swap/memcomp backing, do not scan anon folios. */
+	if ((!sc->may_swap && !memcomp_available()) ||
+	    !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
+#else
 	/* If we have no swap space, do not bother scanning anon folios. */
 	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
+#endif
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -2582,6 +2876,11 @@ static bool can_age_anon_pages(struct pglist_data *pgdat,
 	if (total_swap_pages > 0)
 		return true;
 
+#ifdef CONFIG_MEMCOMP
+	if (memcomp_available())
+		return true;
+
+#endif
 	/* Also valuable if anon pages can be demoted: */
 	return can_demote(pgdat->node_id, sc);
 }
@@ -2654,11 +2953,21 @@ static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
+#ifdef CONFIG_MEMCOMP
+	if (!sc->may_swap && !memcomp_available())
+#else
 	if (!sc->may_swap)
+#endif
 		return 0;
 
+#ifdef CONFIG_MEMCOMP
+	if (!memcomp_available() &&
+	    !can_demote(pgdat->node_id, sc) &&
+	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
+#else
 	if (!can_demote(pgdat->node_id, sc) &&
 	    mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
+#endif
 		return 0;
 
 	return sc_swappiness(sc, memcg);
