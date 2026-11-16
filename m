Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827101;
	b=JgbIkh+6HmUnHfwwHFaJF24y2GB1CKL+JZKZ6jIkZneY1dwhFSecCClCgVqRd1ySthHn
	 NildKp9zehWRrUlTw366aNbUApNGZRiUyABiG6+/yncD5SEZoibe2aek9KEs1zI+0tw2F
	 RA+SJPrE68jhXYXj0W9SvMOn/q5N0C0FXktqo3FrQdSmDmcTps/6J5Sc8rWkSyEPb0R0z
	 l1oyAqfGzGa3WNx/x/FgRVEEbS8schGFNuns2NA4zIKSVzSCfWevk2ATe2TZo1gN9lcX2
	 PbeiwiQGFW8wb2g8dIUzNrFwiq3otgUOP0fIF+59uZd2nAkjISqJiyVqTRgh1upDsPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827101;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dEwMuEk6L9PkuPwgRk5o/Rg0G4cgqI2PeNM611PKi+o=;
	b=iYr6At4DT13+MPTEkzy/C4fBvPYiamWalse+alf8SY6uAzRINNC0VsBLjDi4ew70TK2E
	 pLDWGw+y+C3vOHXC7n2uUAPgv6bITDdz4D7bjxqPNOdQvNFRltjsMZQ8Rt8CQxoTfzzj6
	 s2VbSzpXG8L99KBG0F2PxwZPAWicXOa9IByvEHsIb2cmFCSZ2viwyoJFiufFNwIa8ezxT
	 tAMpL7F244gAxUjC528tv4UP8vC9Lkfha/oY/5K8JKMY5Pu48CAIINN2vWxFRHWVtYRuB
	 VgymhIf7PamoFUhgYaOFhznDMdsBXutVl3NF52AHGbDhrQljfGIG3mrflZbZV00L/Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GOoGILCv;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23A3606F1F0
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:05:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A23A3606F1F0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GOoGILCv
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1b3b4944abeso738217c88.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827100; x=1795431900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dEwMuEk6L9PkuPwgRk5o/Rg0G4cgqI2PeNM611PKi+o=;
        b=GOoGILCvCuhzJ24yqD64fgscCFyZU2GvWZSgqXjeTyVP7A8Fq+LNSHIDWMeshGOlIh
         jV+WSIm9E/WLuVBMGODfcM5ECbXAZAuFoPSSAHKQdoUE6uo7GionU8lEAIjMem2mD6EG
         Fr58kwQ1ZrTpDa+aQ+NKbX7HzLGaKhTIYofTXX3LTHit1F/f6iBp0kPunM8k9pUXDwRR
         7Ppq8/7R+6BdF9rBGnavJCeBHdF8PCV1lmUzSN8/ZnWGSV05mllpuGpJkC29nQk3lwnj
         AWsqmx1WYUjzmGMBYNkU1IWmq9CROytYhsXgx95rIpKx0G/Z0qpiyqRN26ODOjnPLphC
         IGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827100; x=1795431900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dEwMuEk6L9PkuPwgRk5o/Rg0G4cgqI2PeNM611PKi+o=;
        b=tgaBCPHt+DBroujDLM9FOrmeWczMxaIKY8khGW/9i7wlPIWquwMKfz1SaWvdA8lcsu
         taHuGQOj1e5dXynJs8Pw0otdGH2fj2Bd8mHLVamXRZmM/nMylNBOZfil+pPpLh8BtLbr
         yOY/C+ZNBhVdMBlfg7IYkRjY/LeFTY1wZaST4UlEL33DV3hDgiPH1ym0F5mEH3+81WXq
         ATD7oV77UTDsNow0/o0QIaRC53Ni3VnPNNcnk3Z/A7I5W6fo3gjs9f+wUS8DOhz7BbEP
         aDlJfkR5aH6Z4f+KXOdzozlIU+YBbPL19ihm06wD2qBtwPZeHKRWRkYrb9b06Sv0m4wS
         i8vg==
X-Forwarded-Encrypted: i=1; AL+hErE2f6KGOI+BJCEgCWhZT+GufMClAf7DiD8t6NNxWLx8dEn0vp0XV7c+vom3clQl52kbfkFicwxm@vger.kernel.org
X-Gm-Message-State: APuU4Z+r6Aop9O5nGchppf+Gm4qFKZp0Vtv3XbB+vq59gB2OUgRCuXaq
	tkmmXKuqvj59RwC34BbuwhBcL0TcXWagB5E2nrgVk1zinScjmnbLoO4P
X-Gm-Gg: AYBFou3t4zhdpI2Kxi+LNcoNnmMOPtIxUISdAxvFGTJcoJ913uHDm5vlbRLFBiUo4pE
	U2QvNIhetk7EgFgG3SzYvGYg9B6S4wHnH+NnMFSpGQ/OwNTMfVVVN16z1KOTqCmCZPcBFGU4nl4
	g9kfY2JRE60GrAC3OpNVnaPA3rmihHG2parGCWxvZyAribFDn/r0WXyc9vw0raHUSzyESJswq/K
	n7F94qtqi6zLjQSPpNHBwtWHcBKWiPTMMd87q3lhNKi5iHqYYMTRU28hiUPMg/eIPhdLpDXW+Gj
	UqKVNYl8teJvjPwF80rNDrLDCHIK+1ShdairsSLfpjxeU0XPItUsX9HBQD+BCzk0mILWEhefLBb
	AUwhhNAS88nPg3b+JRfQAaLG3gSjfRIWsinBh1Y5QLvLVVeTr78ruuYGw4tlA7J7TT/qzu9Zu+y
	TXpZS4jbWUYRugkqZG3/GEKUEJfGxBXDA6YUTWQPWqS85KLoUi7RUpR3pBJOXyYfHESJ2CyKM57
	sSNhFDBmpXOoYPnmR7mH3x7gTSqpg21kd8+PI9kdpNQNK165U+MJSrEPhxz6ORTd0CR7QHT9RoC
	4b0dABpYOeDMZ/HGIrz9Bho1G8Rz0g+ygS76UsF3ZMP4gjk=
X-Received: by 2002:a05:7022:ea81:10b0:193:3274:aac with SMTP id a92af1059eb24-1b50312f210mr9875871c88.37.1794827099537;
        Mon, 16 Nov 2026 03:04:59 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:58 -0800 (PST)
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
Subject: [RFC PATCH 15/16] mm: memcomp: add the design doc
Date: Mon, 16 Nov 2026 19:01:21 +0800
Message-ID: <20261116110122.309748-16-nakixii@gmail.com>
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

The memcomp backend spans page-table ownership, compressed storage and
real swap. Document the design so readers can follow which object keeps
contents alive when reclaim, faults, fork and backing conversion
overlap.

Describe token encoding, 16-byte slots, per-key clusters and temporary
resident records. Explain the separate zero-owner domain, nonzero same-
filled values and source-object-cgroup accounting without treating the
slot layout as the entire per-page metadata cost.

Document anonymous unmap and rollback, single-PTE rmap restoration,
fault revalidation, shmem shadows, writeback and swapoff. Explain the
lookup, producer and mapping references and the locking boundaries that
keep allocation or I/O out of non-reclaimable critical sections.

Describe bounded compression contexts, foreground asynchronous batches
and metadata aging in batches of at most 32 examined entries per storage
lock acquisition. Document the stock crypto and zsmalloc dependencies,
supported contexts and restrictions, and link the design from the
memory-management documentation index.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 Documentation/mm/index.rst   |   1 +
 Documentation/mm/memcomp.rst | 215 +++++++++++++++++++++++++++++++++++
 MAINTAINERS                  |   1 +
 3 files changed, 217 insertions(+)
 create mode 100644 Documentation/mm/memcomp.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 0be1c7503a010de78c1c1965b43bffc6311a6ca6..dc00d0b5db14d1a323715ceb8bdefe66e4179d17 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -46,6 +46,7 @@ documentation, or deleted if it has served its purpose.
    hwpoison
    hugetlbfs_reserv
    ksm
+   memcomp
    memory-model
    mmu_notifier
    multigen_lru
diff --git a/Documentation/mm/memcomp.rst b/Documentation/mm/memcomp.rst
new file mode 100644
index 0000000000000000000000000000000000000000..08524581e26a88119d9b2bd0f327fc7c3ccf9cf9
--- /dev/null
+++ b/Documentation/mm/memcomp.rst
@@ -0,0 +1,215 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================================
+memcomp: compressed page backing
+================================
+
+memcomp provides experimental in-memory backing for reclaimed anonymous
+and shmem pages. It uses the crypto compression API and stock zsmalloc.
+It does not route the first store through a swap block device. Optional
+writeback can move cold payloads to real swap without replacing the
+memcomp tokens held by their mappings.
+
+This document describes the lifetime and VM integration rules. The
+administrator guide describes configuration and the existing sysfs ABI.
+No particular compression ratio, latency or energy saving is guaranteed.
+
+Tokens and backing states
+=========================
+
+A dedicated non-swap entry type distinguishes memcomp tokens from real
+swap offsets, migration entries and PTE markers. Enabling memcomp consumes
+one of the swap-entry type values. The implementation requires 64-bit
+kernels: a token must round-trip through a PTE offset, and the compression
+paths must be able to address a whole folio through its local mapping.
+
+An anonymous folio reserves a consecutive token span before reclaim
+unmaps it. Each entry records its position and the size of the source
+span. An entry can refer to the resident source folio, a compressed
+payload, a same-filled value, or swap backing. A token identifies the
+entry, not the address of a zsmalloc object or a swap slot.
+
+Entry references include mapping and internal references. Fork acquires a
+reference before copying a token PTE. Zap and MADV_FREE drop only the
+references represented by the PTEs they remove. Discarding one mapping
+must not invalidate another mapping's reference to the same entry.
+
+An entry's owner relationship with a folio is distinct from the reference
+that keeps a resident folio faultable. A failed store can release its
+owner hold while a token that escaped rollback still refers to the
+resident contents. Releasing that resident reference too early would
+leave a valid PTE pointing at a freed folio.
+
+Anonymous reclaim and rollback
+==============================
+
+Reservation requires a locked, swap-backed anonymous folio outside the
+swap cache. KSM folios are excluded. Their reverse-mapping rules are not
+the anonymous rules used by memcomp's restore walk; a still-merged folio
+must not acquire a token even after its mapcount falls to one.
+
+Reservation pins the anon_vma while the folio still has its mappings.
+The normal single-PTE reverse-map walk then installs token PTEs and takes
+the corresponding entry references. Reclaim must flush pending unmaps
+before reading contents for compression.
+
+Compression, backing allocation or a subsequent ownership check can
+fail after some PTEs have changed. That is not an opportunity to overwrite
+the reservation with a normal swap entry. The failure path restores
+matching PTEs through the pinned anonymous reverse mapping, updates RSS
+and reverse-map accounting, and drops the reservation. It re-walks a
+maximum of three times while escaped references remain. The initial walk
+can be retried even if it restores nothing; a later re-walk that makes no
+progress stops the loop.
+
+When every page of a large folio has been mapped back, rollback repairs
+the partially-mapped deferred-split accounting. Otherwise a failed store
+could leave a fully mapped folio queued as though part of it were absent.
+The anonymous reverse-map pin is released on both successful store and
+rollback. Entries that escaped restoration retain resident backing until
+fault or invalidation resolves them.
+
+Normal swap is a forward-progress fallback before a fresh reservation
+owns post-unmap tokens. A failure after unmap restores or retains resident
+backing first. An unchanged incompressible folio can take normal swap on
+a later reclaim attempt instead of repeating the failed compression.
+
+A dirty anonymous swap-cache folio gives up its swap slot so that its new
+contents can be compressed again. The locked-folio check also reads dirty
+state still held only in PTEs or PMDs, without clearing or write-protecting
+those mappings. Checking a clean mapped folio can require a reverse-map
+walk, but its usual swap-backed eviction is unchanged. Writeback or
+outstanding swap references leave the folio on the normal swap path.
+
+Compression and allocation
+==========================
+
+The allocator is zsmalloc, called directly rather than through a custom
+allocator interface. Compressor selection uses the crypto API and does
+not require private hints or changes to a codec. Allocation and context
+admission must obey the caller's reclaim constraints.
+
+Bounded compression contexts and detached staging buffers limit concurrent
+resource occupancy and allow foreground admission to fail. They do not
+guarantee bounded reclaim latency: background context acquisition and
+asynchronous completion waits have no timeout. The lease
+needed for a synchronous store is acquired before unmapping and consumed
+by the store on every return. It is released before finishing or rolling
+back the folio. Foreground admission failures can stop repeated anonymous
+attempts in the current reclaim pass so that file reclaim can proceed.
+
+Same-filled pages store the repeated value without a zsmalloc payload.
+A folio whose contents did not compress can carry an incompressible mark
+and a content hash in folio->swap while outside the swap cache. The mark
+is not a reserved token. Reclaim recomputes the hash and clears a stale
+mark when contents change; migration carries the mark with the contents.
+A split cannot assume that the original whole-folio hash describes each
+new smaller folio.
+
+Payload thresholds depend on the allocator's actual class geometry.
+Logical compressed length and allocator footprint are different costs.
+The implementation must not assume that a threshold measured with a
+modified allocator also applies to stock zsmalloc.
+
+Asynchronous foreground batches
+================================
+
+A crypto implementation with an asynchronous form can compress a bounded
+batch of already-unmapped folios in the reclaiming task's path. The
+reclaimer flushes their pending TLB invalidations, submits requests,
+waits for completion and then publishes the resulting payloads. Small
+batches can use the synchronous path instead.
+
+A batch does not hold the limited store leases while waiting for the
+compressor. Failure to acquire a lease when publishing a completed folio
+fails that store and invokes the same rollback rules. No private crypto
+execution hints or independent background compression worker are needed.
+
+Fault, migration and userfaultfd
+================================
+
+A token fault resolves the entry and its backing, prepares a folio, and
+revalidates the PTE before publishing a present mapping. A concurrent zap,
+move or invalidation can require retry rather than installation of stale
+contents. Fault results use vm_fault_t rather than negative errno values.
+
+A resident token must be restored where the source folio's reverse mapping
+expects it. UFFDIO_MOVE first faults that token back at the source address
+and retries through the present-PTE path. A nonresident exclusive token
+can move like a swap entry. A stable entry reference spans the lookup and
+PTE revalidation; entry locks must not be acquired while the temporary
+PTE mapping keeps an RCU read-side section active.
+
+For a present PTE, UFFDIO_MOVE checks exclusivity on the actual source
+page, not the first page of its folio. Reclaim can clear exclusivity one
+page at a time. A genuinely shared page remains rejected, while an
+exclusive tail page is not rejected just because the head differs.
+
+Migration transfers the resident/owner relationship together with the
+contents and restores that relationship if the VM mapping transfer fails.
+Splitting a folio with a live reservation is refused; rollback must first
+resolve that reservation and repair deferred-split state.
+
+Shmem and memory cgroups
+========================
+
+Shmem keeps memcomp tokens in its page-cache exceptional entries rather
+than installing the anonymous reservation protocol on an inode mapping.
+The writepage handoff and the swapin path balance the mapping's entry
+reference separately from an anonymous folio-owner reference. Truncate,
+fault races and allocation failures must undo the associated inode and
+entry accounting.
+
+Compressed storage is charged to the source folio's object cgroup, not
+the task that happens to execute reclaim. Metadata and allocated payload
+bytes have distinct lifetimes. A pending charge must be refunded if
+allocation, publication or a competing operation prevents its transfer
+to the entry. Same-filled payloads still require entry metadata.
+
+Dropping a mapping does not necessarily destroy the backing entry. The
+payload charge is refunded when allocated backing is freed, including
+conversion to swap backing. The metadata charge and object-cgroup reference
+remain until the RCU-delayed entry free. This is compressed-storage
+accounting, not a separate per-cgroup admission controller or swap budget.
+Normal VM charging is still required for folios allocated on refault.
+
+Swap writeback
+==============
+
+Cold allocated payloads can move from the pool to real swap. Packed slots
+share a swap page between multiple payloads; the hybrid representation can
+also use an unpacked slot when packing does not fit. Slot ownership,
+packed-member lifetime and read-cache references are balanced independently
+of the mapping's token reference.
+
+Writeback selection and its drain budget are bounded. The policy derives
+its limits from total RAM rather than a device-specific memory size.
+The level controller observes zsmalloc's physical pool footprint. It must
+not close its feedback loop on total stored logical bytes: moving a
+payload to swap leaves those bytes represented by the entry, so that
+quantity does not measure memory released by writeback.
+
+Writeback pressure scopes exclude inappropriate reclaim contexts and
+avoid doing packed I/O in direct reclaim. Swapoff resolves entries backed
+by the disappearing swap device into RAM, balances failures and lost
+races, and does not report a failed conversion as successful. Allocation
+and I/O must not recurse into reclaim under an entry lock. Conservative
+packed-slot defragmentation remains separate from active pool draining.
+
+Observability and limitations
+=============================
+
+The stable stat file reports logical stored bytes, compressed bytes and
+allocator pool bytes, in that order. These are not interchangeable gauges.
+Debug event counters can count repeated attempts for the same page; their
+deltas are not counts of unique pages. See the ABI descriptions for each
+field's units and accounting point.
+
+The current implementation is mutually exclusive with zram and zswap,
+supports only 64-bit configurations, and reserves one swap-entry type.
+Its multivalue sysfs files and large implementation are RFC limitations,
+not the intended final upstream interface or source layout.
+
+Runtime validation of hibernation, memory hot-remove, DAMON and all
+khugepaged interactions remains incomplete. A successful build or a test
+in one VM topology does not establish coverage of those interactions.
diff --git a/MAINTAINERS b/MAINTAINERS
index 98c920275f276ba29fdd459a39aa8db7c83042e7..d1d8f578f62cd9c0b824b0a5f95b49433970c377 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14806,6 +14806,7 @@ MEMCOMP IN-MEMORY COMPRESSION
 M:	nakixii <nakixii@gmail.com>
 L:	linux-mm@kvack.org
 S:	Experimental
+F:	Documentation/mm/memcomp.rst
 F:	include/linux/memcomp.h
 F:	mm/memcomp.c
 F:	mm/memcomp/
