Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827107;
	b=YjNqTEs5GXU0OVj5/jaFaDbbc36IByBXKBfYhIJguVM13nxSrd1bEy/HgxaPOTZWmH++
	 55najidJPREHqbjaH/7aXqQK+V8bFZFWlborPEbSPqTePwDYUIDyp8hNJ3LmxMzkBoaHB
	 uYAOj8GIOeS7iBzfhzyqVw+faQ+GJlOreG3ifBaDcmw+V4lzcpMbMt45tLfkIiodsyz+6
	 0/PMuvYuDstYwgoEHib+bJaIdP/6/UdZh4wJ9i6InWKBMU8wpLDqWqVAMVuY/Eh/5CDSH
	 ix5Nw+XnnZAouhVA5pfIVVoLMXguCYTIXJ+3G9AsbH4HB2neT9Q01Qxe7FpYtgn/fiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827107;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zS2lDzeHA/1L2L3MmL+yEtxhF4ntSvUOnFxLZtQr65E=;
	b=MnvctG45MA7Y+Jg1ZnrPTlIc7S2uvkTRR5VOmvYAfai2USv2kJ4XgI9+zdu15aizgQ8V
	 b/JL5C3fBW/B0dhjyK5qgFnsGeBku/4lVvYmYT6QIqd8br7f22R6gfYElzFJmRPu3PeYT
	 +zO3IdjHxkgkSv6NyrnznFh8vsqIIBZnToiDUFuhRiFqHBU10Ho5S0MSqXvqNz9/ttz4A
	 A8oqVqhVEWVGoyE72U0RwXFCxntI+rii8c+eed0qnYJPwT1ueZXc/sox8gVW5uHIRqQqA
	 8RDu6Xtfb/Rvf3OvRLVtnxIA905XpzCaYg3cBWkS5AW8/2gevyCGW0jFhl577xGCRbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VfHRdTs7;
	arc=none smtp.remote-ip=74.125.82.45
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DDB606AB72
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:05:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A9DDB606AB72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VfHRdTs7
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1b3b4944a0eso1339064c88.0
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827106; x=1795431906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zS2lDzeHA/1L2L3MmL+yEtxhF4ntSvUOnFxLZtQr65E=;
        b=VfHRdTs7cKqunsTwVdkhG1GeIW+d7qvKwn//2dJlRCqOxtdjjJZJ2Z3icOeCW252Cq
         WaqS7NO1RzvQ5YSV06ktL/xhVBeuWIdZS7ZT7IGRtYQAJquRtiGHEneLVkCUsMWOBR7V
         DsJymT1jXZivGloUVIRjI2VEIN5177njWiRTlFAY3/66BUczej/3FsgG7kPVCvFpm8/k
         tuF4sq3WRHqC5XTa5LP2N94kzeaQleFDg2JciiLZlsNUqDh8cSyoHxctO339ybCM22Ul
         sNbp2HoEfxKhC1c8OP+0Zs59ksvqFeEgycZLgjdEc7P3B/NVBp1QjalL/eT60s21qcxv
         HqLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827106; x=1795431906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zS2lDzeHA/1L2L3MmL+yEtxhF4ntSvUOnFxLZtQr65E=;
        b=vHJUnaoNJ66xy8ZanmZSwx2oPp6AfZeH8fZrGCTm6hBWN6Az9sxt434g1DSGUVLipI
         +YjDpkhR295fHLj9Ps0CTOyP8YaQF9H/R11PNlYCnyjDjYDz+AZ/UcFzUlgRHjIu42vW
         M7NjiAcql3u5+xRFoRXNUJyzocA8QZgWf0g/QdkknTxWgaYkib6Az59Y1ovKK+LR9zS/
         Hgyd1eLAt+3/7Q5OVnJPbz3QTWT/LX+GB7aVMkz0VyAgAdibPn8Wq/5eDCk7hiWdSRCK
         T8Lvikqe6Q2ugkeqZWSjVw0S96g8bDgjXl1lQnEKbSEuIZjTM0/2Ym/yfv8Hc601OdRL
         PeSw==
X-Forwarded-Encrypted: i=1; AL+hErEOcn5US3DjUIobj/Bad6u60ok/bHCghj8qgUeQdH4uyxwFKUnuw2WGgz+Vhhf8Ppzws8J9z+kT@vger.kernel.org
X-Gm-Message-State: APuU4Z//O5R5pLwCflH+Se5HKTPcnC5bh/f0rwp+FTOrW3kzl4Cj8WVO
	ZB22X+UstAfGLp7Dx82e0zu1xDOqVle4uziYZjX5Ys71rPi2gtbYlWLl
X-Gm-Gg: AYBFou2Shxs3wBaiMMVZEp9icF1E7BOC86jONvCBWo2NywMvBtIRn0rGUemJ40dePVn
	tM9Au4e8b3PQ7Z7mhCzWT6b53AsOL4H6vzaOj5TKqNWnT1xQlhS4yI9EwvzTR3Y4hPY6aeTVxy1
	1Pp3ZIpNdAL/+icT2kaGNWiDnVHQM8K99m/tqhi54Vzx17iESgR6yTNvroMaMIMgX8HT2uzPFQ5
	axaKx4nZLTDniXc/GRHDh4ceZ/MWnXGdRt1tKAeW7JjLNR54w6QpPEzlN3iHVqZB+llP7HBuFAE
	Uoj4sUucdA0ZJ23xkP50VdglnDYNoRGr7+vLQYC5E4++zEUqE18hoUBKiaG3j7Xgk6HkEOzVl4J
	s2hK+IPbdFSLjEX7pP+VCrCQwwGXj9pPJPPM3cMi4gMjL1r/Ya+mtImGcVkaTjb+jDBAC1Oitmq
	L3XGo7B7IfB6W2pqRKy1Kj0uZ+VqLomSR9sb34Yjayk9bxQ43YW6wnkJplLAKmCtUm0RmNHYWEo
	2hApqVPXVTKHlGZ7VjlsrqCinp50ROY/Vi1+66Pq9k+hDzbgDiuEwPATTsUWJ5rW+/JrxjEag3t
	lAk4rmWKbkLq/rfo8W1i6dAnD7/vuVUNp0FJF16sn89oL6g=
X-Received: by 2002:a05:7022:170f:b0:166:f097:6f12 with SMTP id a92af1059eb24-1b5030e76a5mr10196048c88.15.1794827105267;
        Mon, 16 Nov 2026 03:05:05 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:05:04 -0800 (PST)
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
Subject: [RFC PATCH 16/16] mm: memcomp: add the admin guide
Date: Mon, 16 Nov 2026 19:01:22 +0800
Message-ID: <20261116110122.309748-17-nakixii@gmail.com>
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

The memcomp backend has boot-time policy, compressor selection and
observable statistics that need an operational description separate from
the internal ownership design.

Explain the experimental configuration and default-off policy, including
built-in compressor requirements and the memcomp.compressor= override.
Describe initialization and compressor availability without implying a
runtime enable or disable interface.

Document stat and compressor under the established memcomp sysfs
directory, with optional diagnostic fields gated by MEMCOMP_DEBUG_STATS.
Describe writeback policy, accounting limits and supported operation.
Add the sysfs ABI descriptions and link the guide from the memory-
management index.

Keep implementation, documentation and selftest maintenance coverage
aligned with the series. State operational restrictions and untested
areas explicitly rather than promising behavior beyond the supported
configuration or available validation.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 .../ABI/testing/sysfs-kernel-mm-memcomp       | 363 ++++++++++++++++++
 Documentation/admin-guide/mm/index.rst        |   1 +
 Documentation/admin-guide/mm/memcomp.rst      | 149 +++++++
 MAINTAINERS                                   |   2 +
 4 files changed, 515 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-memcomp
 create mode 100644 Documentation/admin-guide/mm/memcomp.rst

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-memcomp b/Documentation/ABI/testing/sysfs-kernel-mm-memcomp
new file mode 100644
index 0000000000000000000000000000000000000000..0d68defd8d1a2b09f700d12827dad12743d94d6d
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-memcomp
@@ -0,0 +1,363 @@
+What:		/sys/kernel/mm/memcomp/stat
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Read-only memcomp capacity counters.  The three decimal
+		fields are logical stored bytes, compressed payload bytes, and
+		zsmalloc pool bytes, in that order.  A pending logical page is
+		still resident and must not be treated as committed capacity.
+
+		Slotless zero tokens contribute one base page per logical owner.
+		Anonymous PTEs and shmem page-cache shadows have independent
+		ownership counts. Fork adds a zero PTE owner; fault, zap and
+		MADV_FREE remove it. Moving a zero PTE does not change the count.
+		A present shmem mapping adds no owner beyond its cache shadow.
+		Positive slots retain the per-slot counting convention, so fork
+		can increase the logical zero capacity without allocating any
+		entry metadata. Counter fields remain observational snapshots.
+
+What:		/sys/kernel/mm/memcomp/compressor
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Read-only name of the compression algorithm selected at boot.
+		While memcomp is still waiting for a compressor that has
+		not registered yet, this is the name it waits for; it changes
+		to "zstd" if memcomp falls back to that.
+
+What:		/sys/kernel/mm/memcomp/events
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected independently, so a read is not a coherent snapshot
+		against concurrent work.
+
+		The ``folio_owner_pages``, ``samefill_pages``, ``raw_pages`` and
+		``shmem_pages`` fields are current entry-state gauges. They count
+		entries with a retained folio owner, same-filled payloads, page-sized
+		raw payloads and shmem ownership, respectively. Owner detachment
+		and payload replacement update the corresponding gauge;
+		entry removal subtracts its remaining state before payload release.
+		These are sums of signed per-CPU values, not an object index or a
+		transactional snapshot. Cross-CPU reads may race concurrent updates;
+		negative aggregate samples are clamped to zero. Compare quiescent
+		samples when checking balanced ownership.
+
+		Event counters accumulate; they are not instantaneous state. The
+		other current gauges are: ``enabled``, ``comp_ctx_count``,
+		``comp_ctx_reserved``, ``comp_ctx_borrow_limit``, ``comp_ctx_free``,
+		``comp_ctx_waiters``, ``comp_ctx_borrowed_active``, ``pending_pages``,
+		``swapped_entries`` and ``zs_huge_class_size``. ``enabled`` is 1
+		when memcomp is enabled and 0 otherwise. ``zs_huge_class_size`` is
+		the request boundary, in bytes, below which zsmalloc can share
+		backing pages; zero means memcomp is not enabled or no allocator
+		pool is initialized.
+
+		``comp_ctx_borrowed_peak`` is the largest recorded count of
+		simultaneously borrowed compression contexts, not current
+		occupancy. ``comp_ctx_count`` and ``comp_ctx_reserved`` report
+		the initialized compression-context pool sizes.
+
+		``swapped_read_io`` counts successful read/decode calls for
+		swap-backed pages, including calls satisfied from swapcache; it is
+		not a physical I/O count or proof of a later PTE mapping. ``swapped_read_error`` counts read-page or decode
+		failures. ``swapoff_entries`` counts entries successfully converted
+		back to RAM backing. ``swapoff_read_io`` counts successful read-page
+		operations in that conversion path. These four fields are
+		accumulated events, not current gauges.
+
+		Compression staging and reservation rollback/split diagnostics are
+		reported by ``execution_events``, not by this file.
+
+What:		/sys/kernel/mm/memcomp/placement_events
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected separately and do not form a coherent whole-file snapshot.
+
+		Accumulated routing-attempt counts: ``compress`` counts attempts to
+		route anonymous or shmem folios to memcomp; ``normal_swap_fallback``
+		counts fallback attempts to ordinary swap after a memcomp attempt.
+		These are routing events, not successful stores, reclaimed pages or
+		byte counts. An event can concern a multi-page folio; retries can
+		cause further events.
+
+What:		/sys/kernel/mm/memcomp/packed_swap_events
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected separately and do not form a coherent whole-file snapshot.
+
+		Compressed-pool writeback diagnostics. The following fields are
+		current gauges:
+
+		* ``writeback_pool_pages``: allocator backing footprint in base
+		  pages.
+		* ``writeback_pressure_scopes``: active reclaim writeback scopes,
+		  summed across memory nodes, including overlapping scopes.
+		* ``writeback_gate_open``: last evaluated writeback-gate state, 0
+		  for closed or 1 for open.
+
+		The remaining fields are accumulated counts:
+
+		* ``writeback_pressure_events``: node scope transitions from no
+		  active scope to an active scope.
+		* ``writeback_pressure_scans``: eligible pressure-driven writeback
+		  scan invocations.
+		* ``writeback_compression_throttled``: budget-grant episodes with
+		  effective compression feedback; this is not a count of compressor
+		  calls delayed. Feedback is effective after sufficient logical
+		  stored-byte growth when backing-byte growth is at most half that
+		  growth.
+		* ``writeback_limited_batches``: scanned batches which exhaust their
+		  node's writeback budget.
+		* ``writeback_budget_granted``: sum of payload-entry allowances
+		  granted, not bytes or completed writes.
+		* ``writeback_payloads``: payload entries successfully converted
+		  from in-pool storage to swap-backed storage.
+		* ``writeback_zs_reclaimed``: sum of observed decreases in
+		  allocator backing base pages during pressure scans, including
+		  compaction. It is not a logical-page count or exclusive
+		  attribution against concurrent pool changes.
+		* ``writeback_zs_no_progress``: pressure scans which converted
+		  payloads but observed no decrease in backing pages after
+		  compaction.
+		* ``writeback_decompress_error``: failures to decompress a payload
+		  when preparing an unpacked swap page.
+		* ``writeback_write_error``: submitted swap-page slots observed
+		  dirty after waiting for writeback, indicating write failure. This
+		  counts slots, not the payload entries within them.
+		* ``writeback_gate_opens``: recorded transitions from a closed gate
+		  to an open gate.
+		* ``writeback_packed_slots``: packed backing-page slots submitted
+		  for writeback, not successfully completed I/O.
+		* ``writeback_packed_payloads``: payload entries successfully
+		  converted to packed swap storage. Multiple payloads can share a
+		  slot.
+		* ``writeback_defrag_moved``: packed swap payload entries
+		  successfully moved back into the compressed pool by
+		  defragmentation.
+
+		Submission, conversion and page-footprint statistics have different
+		units and accounting points; they must not be equated.
+
+What:		/sys/kernel/mm/memcomp/admission_events
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected separately and do not form a coherent whole-file snapshot.
+
+		Accumulated direct-reclaim admission diagnostics:
+
+		``reclaim_ctx_early_reject`` counts direct-reclaim context prechecks
+		which rejected an attempt; ``reclaim_ctx_early_reject_pages`` sums
+		the associated base pages. This is a precheck result, not proof of
+		an eventual failed store.
+
+What:		/sys/kernel/mm/memcomp/context_events
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected separately and do not form a coherent whole-file snapshot.
+
+		Compression-context timing diagnostics. ``sample_interval`` is the
+		lease sampling period, currently 256 successful reclaim-context
+		acquisitions per context and reclaim source, with staggered initial
+		phases. Sampled values are raw measurements, not extrapolated totals
+		for all work.
+
+		``wait_events`` counts entries into the context wait path, including
+		retries, independently of lease sampling. ``wait_ns`` is accumulated
+		elapsed wait-path time in nanoseconds and ``wait_max_ns`` is its
+		largest recorded individual duration; a wait-path entry need not
+		actually sleep.
+
+		The prefixes ``direct`` and ``bg`` select direct reclaim and all
+		non-direct reclaim sources. Each prefix has the following suffixes,
+		joined with an underscore:
+
+		* ``samples`` counts accounted sampled leases; ``pages`` sums their
+		  associated base pages, not pages successfully reclaimed.
+		* ``store_samples`` counts sampled leases that reached a store
+		  attempt; ``store_success`` counts successful store outcomes among
+		  them.
+		* ``lease_ns`` is accumulated context-holding time; ``lease_max_ns``
+		  is its recorded maximum per sampled lease. A lease ends when the
+		  context is released or its output is transferred to a staging
+		  buffer; later store work may continue after it.
+		* ``pre_store_ns`` is accumulated time from lease acquisition to the
+		  beginning of a store; ``pre_store_max_ns`` is its recorded
+		  maximum. A lease that never starts a store contributes its full
+		  lease duration here.
+		* ``compress_ns`` is accumulated elapsed compression time;
+		  ``compress_max_ns`` is the maximum accumulated compression
+		  duration for one sampled lease.
+		* ``compress_cpu_ns`` is accumulated task CPU time spent in measured
+		  compression; ``compress_call_cpu_max_ns`` is the largest recorded
+		  CPU duration of a timed compression operation.
+		* ``compress_store_success_ns`` and
+		  ``compress_store_success_cpu_ns`` are elapsed and CPU
+		  compression-time totals for sampled leases whose store succeeded.
+		  ``compress_store_fail_ns`` and ``compress_store_fail_cpu_ns`` are
+		  the corresponding totals for leases without a successful store,
+		  including leases that never started one.
+		* ``zs_ns`` is accumulated measured allocator/payload-placement
+		  time; ``zs_max_ns`` is its maximum per sampled lease.
+		* ``store_other_ns`` is accumulated store elapsed time after
+		  subtracting measured compression and allocator time, floored at
+		  zero; ``store_other_max_ns`` is its maximum per sampled lease.
+
+		Each prefix additionally has ``compress_<outcome>_calls``,
+		``compress_<outcome>_ns`` and ``compress_<outcome>_cpu_ns`` for
+		``compressible``, ``raw_huge``, ``raw_ge_page`` and ``error``
+		outcomes. These count timed compression operations and accumulate
+		their elapsed and task CPU nanoseconds. The outcomes mean a result
+		below both storage boundaries, a result reaching the allocator
+		huge-class boundary but below input size, a result at least input
+		size, and a compression-result error. They are distinct from the
+		later store-success classification.
+
+		All durations are nanoseconds. Counts and duration totals
+		accumulate; maxima are recorded high-water durations, not gauges.
+		Lease and store phases must not be assumed to be a disjoint
+		decomposition of end-to-end request latency.
+
+What:		/sys/kernel/mm/memcomp/context_sources
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected separately and do not form a coherent whole-file snapshot.
+
+		Source-attributed context timing. ``sample_interval`` reports the
+		lease sampling period, currently 256 successful reclaim-context
+		acquisitions per context and source, with staggered initial phases.
+		Lease measurements are sampled, not extrapolated; wait-path
+		measurements are not lease-sampled.
+
+		Prefixes are ``direct`` for direct reclaim and ``kswapd`` for the
+		regular reclaim daemon. For each prefix, suffixes are joined with
+		an underscore:
+
+		* ``samples`` and ``pages`` count sampled leases and their
+		  associated base pages, not successful reclaim.
+		* ``store_samples`` and ``store_success`` count sampled store
+		  attempts and successful store outcomes.
+		* ``wait_events`` counts context wait-path entries, including
+		  retries; ``wait_ns`` sums their elapsed nanoseconds;
+		  ``wait_max_ns`` is the largest individual duration. A wait-path
+		  entry need not sleep.
+		* ``lease_ns``, ``pre_store_ns``, ``compress_ns``, ``zs_ns`` and
+		  ``store_other_ns`` are accumulated elapsed nanoseconds; each has a
+		  corresponding ``*_max_ns`` field for its recorded per-lease
+		  maximum.
+		* ``compress_cpu_ns`` is accumulated compression task CPU time;
+		  ``compress_call_cpu_max_ns`` is the maximum CPU duration of a
+		  timed compression operation.
+
+		Lease, pre-store, compression, allocator and residual store phases
+		have the same meanings as in
+		/sys/kernel/mm/memcomp/context_events. A context lease can end
+		before staged store work completes, and a lease without a store
+		contributes its full duration to pre-store time. Counts and times
+		accumulate; maxima are historical measurements, not current
+		occupancy. A read is not a consistent snapshot across source groups.
+
+What:		/sys/kernel/mm/memcomp/execution_events
+Date:		July 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		Present only when CONFIG_MEMCOMP_DEBUG_STATS=y.
+
+		Read-only text with one key, one space, a decimal value and a
+		newline per line. Reading does not reset statistics. Values are
+		collected separately and do not form a coherent whole-file snapshot.
+
+		Compression execution budget, staging-buffer and reservation
+		diagnostics. ``comp_budget_limit`` and
+		``comp_budget_background_limit`` report the current background
+		execution-credit limit; ``comp_budget_active`` and
+		``comp_budget_background_active`` report currently held background
+		credits. Their ``comp_budget_peak`` and
+		``comp_budget_background_peak`` fields are recorded occupancy
+		high-water counts. These are credits, not pages or all contexts in
+		use.
+
+		``comp_budget_direct_limit``, ``comp_budget_direct_active`` and
+		``comp_budget_direct_peak`` currently report zero: direct reclaim
+		does not consume these background execution credits. Zero does not
+		mean that direct compression is disabled. ``comp_budget_waiters`` is
+		the current number of registered context waiters, not only waiters
+		for budget exhaustion. Limits and occupancy are gauges; peaks can
+		restart if the associated context resources are reinitialized.
+
+		``reclaim_ctx_budget_pages`` accumulates base pages associated with
+		context misses attributed to execution-budget exhaustion.
+		``direct_budget_reject`` counts direct-reclaim precheck or
+		acquisition failures attributed to that budget;
+		``direct_budget_reject_pages`` sums their base pages.
+		``kswapd_budget_wait`` counts reclaim-daemon context wait-loop
+		attempts attributed to budget exhaustion, not slept time or unique
+		callers.
+
+		``direct_staging_count`` is the initialized number of staging
+		buffers. ``direct_staging_free`` and ``direct_staging_active`` are
+		current free and occupied buffer counts. ``direct_staging_peak`` is
+		a recorded occupancy high-water count and can restart on resource
+		reinitialization. ``direct_staging_miss`` counts unsuccessful
+		attempts to reserve a staging buffer; compression can continue
+		without staging. ``direct_staging_detach`` counts transfers of
+		output and timing state to staging that release the compression
+		context before completing the store; it does not indicate store
+		success.
+
+		Additional accumulated reservation/split diagnostics:
+
+		* ``restore_spans`` counts reservation rollbacks requiring an
+		  initial reverse-mapping restore walk; ``restore_rewalks`` counts
+		  additional walks while reservation tokens remain referenced.
+		* ``restore_ptes`` counts page-table entries mapped back to resident
+		  folio pages during those walks.
+		* ``restore_missed_pages`` sums base pages still referenced by
+		  reservation-token PTEs after those walks when the reservation is
+		  dropped. A subsequent fault restores the resident page instead.
+		* ``restore_ns`` sums elapsed reverse-mapping walk nanoseconds;
+		  ``restore_max_ns`` is the largest recorded individual walk
+		  duration.
+		* ``split_refused`` counts refused anonymous-folio splits due to a
+		  reservation; ``split_refused_pages`` sums their base pages.
+
+		Event counts and durations are accumulated statistics; gauge, limit,
+		initialized-capacity and peak fields are not interchangeable.
+		Separate locks and counter reads do not provide a coherent
+		whole-file snapshot.
+
+		``aging_work_calls`` counts retained-header aging callbacks;
+		``aging_detached_headers`` counts the empty current headers they
+		detach. Both are accumulated per-CPU events. They do not reset on
+		read and are not atomic with ``retained_empty_headers`` or the
+		metadata allocation/free gauges. Detaching queues existing RCU
+		callbacks; it does not mean those callbacks have completed.
diff --git a/Documentation/admin-guide/mm/index.rst b/Documentation/admin-guide/mm/index.rst
index 8b35795b664bee614fd941f12ba3a7df937f3a6f..c11d8c58d7e3cc26f87181f7bb4cb400c73c46e0 100644
--- a/Documentation/admin-guide/mm/index.rst
+++ b/Documentation/admin-guide/mm/index.rst
@@ -30,6 +30,7 @@ the Linux memory management.
    hugetlbpage
    idle_page_tracking
    ksm
+   memcomp
    memory-hotplug
    multigen_lru
    nommu-mmap
diff --git a/Documentation/admin-guide/mm/memcomp.rst b/Documentation/admin-guide/mm/memcomp.rst
new file mode 100644
index 0000000000000000000000000000000000000000..78298a51ad6eb198e6c5e00e94434e82d2966ed6
--- /dev/null
+++ b/Documentation/admin-guide/mm/memcomp.rst
@@ -0,0 +1,149 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
+memcomp administration
+======================
+
+memcomp is an experimental compressed backing store for anonymous and
+shmem/tmpfs pages. It keeps compressed payloads in RAM before using block
+I/O and can write cold payloads to real swap. It is not a block device and
+does not require a zram device or a swap file as its initial storage layer.
+
+Configuration
+=============
+
+Enable ``CONFIG_MEMCOMP`` in a 64-bit kernel with MMU, crypto and swap
+support. ``CONFIG_SWAP=y`` is required even when no swap device is active.
+The option selects stock zsmalloc, the crypto compression interface and
+xxhash; it does not require modified allocator or codec code.
+
+``CONFIG_ZRAM`` must be ``n``, not ``m``. ``CONFIG_ZSWAP`` must also be
+``n``. Coexistence is not supported in this version. Enabling memcomp
+reserves one swap-entry type, reducing the available swap-device types.
+
+``CONFIG_MEMCOMP_DEFAULT_COMPRESSOR`` names the default crypto compressor
+and defaults to ``zstd``. Build the desired compressor into the kernel or
+make it available during initialization. For zstd this includes
+``CONFIG_CRYPTO_ZSTD``. The exact registered crypto name matters.
+
+``CONFIG_MEMCOMP_DEBUG_STATS`` adds diagnostic counters and hot-path
+accounting. Enable it for validation and controlled measurement; disclose
+its setting when comparing results. It is not required for the two
+core read-only attributes.
+
+The ``memcomp.compressor=<name>`` command-line option overrides the
+configured default. Initialization waits up to ten seconds for a late
+algorithm registration, falls back to zstd if selection or setup fails,
+and leaves memcomp disabled if the fallback also fails. Check the kernel
+log and the reported compressor instead of assuming the request worked.
+There is no ``memcomp.fast=`` option in this implementation.
+
+Inspecting the pool
+===================
+
+After successful initialization, inspect::
+
+    cat /sys/kernel/mm/memcomp/stat
+    cat /sys/kernel/mm/memcomp/compressor
+
+``stat`` returns three decimal byte counts: logical stored bytes,
+compressed bytes and allocator pool bytes, in that order. ``compressor``
+reports the selected crypto algorithm. The implementation uses zsmalloc directly;
+there is no allocator-selection attribute.
+
+Logical bytes are not physical RAM usage. Same-filled entries, metadata,
+allocator fragmentation and swap-backed entries have different costs.
+Do not interpret a single ratio or the pool byte count as a complete
+measurement of memory saved. In particular, writing a payload to swap
+does not remove the logical data represented by its token. The first two
+stat values retain swap-backed entries and are not resident-RAM gauges.
+Pending reservations are not committed compressed capacity.
+
+Additional nodes exist only with debug statistics enabled. Their fields
+are documented in
+``Documentation/ABI/testing/sysfs-kernel-mm-memcomp``. Take snapshots
+around the measured workload and subtract counters with matching units.
+Counters can include repeated attempts on the same page; they do not
+necessarily count distinct pages. Gauges and high-water marks are not
+cumulative event counters.
+
+Swap and memory pressure
+========================
+
+Real swap is optional for in-memory stores. If it is available, normal VM
+swap can provide fallback before token ownership, and memcomp can write
+cold payloads back using packed or unpacked swap slots. Writeback limits
+are derived from total RAM, not from a fixed device-specific capacity.
+The pool is not a preallocated reservation of that fraction of RAM.
+
+Storage can fail because data is incompressible, memory-cgroup charging
+fails, an execution resource is unavailable, allocation fails, or a VM
+race changes the source mapping. A failure after unmap restores matching
+PTEs or retains resident backing before releasing ownership. It does not
+immediately overwrite the token span with normal swap entries.
+
+Unchanged incompressible contents are marked to avoid repeatedly paying
+compression cost. Modified contents can be retried. Same-filled contents
+need entry metadata but no allocated compressed payload. KSM-merged
+folios are excluded from anonymous memcomp reservation.
+
+``swapoff`` must resolve memcomp entries backed by the removed swap area.
+This can require RAM and can fail; a successful swapoff is not a promise
+that the compressed pool became empty. Do not use swapoff as an eviction
+or reset interface for memcomp.
+
+Memory cgroups
+==============
+
+Entry metadata and compressed payload storage are charged to the source
+folio's object cgroup rather than to the task doing reclaim. This is not
+a separate memcomp quota, target or per-cgroup writeback controller.
+Refaulted folios still follow the VM's ordinary memory-cgroup charging.
+Observe the normal cgroup memory interfaces as well as memcomp statistics
+when applying memory limits.
+
+Validation
+==========
+
+Run destructive pressure and swapoff tests in a disposable VM. Building a
+kernel or running KUnit does not validate every reclaim topology or
+workload. Keep the source revision, effective configuration, command and
+complete log with each result.
+
+The dedicated KUnit configuration is
+``mm/memcomp/tests/.kunitconfig``. For example::
+
+    python3 tools/testing/kunit/kunit.py run --arch=x86_64 \
+        --kunitconfig=mm/memcomp/tests/.kunitconfig \
+        --build_dir=<kunit-output> --jobs=<jobs> 'memcomp*'
+
+Tests that call madvise are registered only when
+``CONFIG_ADVISE_SYSCALLS=y``. A configuration that omits the syscall does
+not exercise those MADV_FREE cases; do not report the full configuration's
+case count for that build. KSM flag rejection in KUnit does not replace a
+real merge/pageout regression test.
+
+The MM selftest is built separately from the kernel::
+
+    selftest_out="$(pwd)/selftest-out"
+    mkdir -p "$selftest_out"
+    make -C tools/testing/selftests/mm OUTPUT="$selftest_out" \
+        "$selftest_out/memcomp_selftest"
+
+The accompanying harness covers pageout/refault, ownership churn,
+userfaultfd moves, shmem and swapoff. Match its requested features and
+resources to the guest configuration. A skipped feature is not proof of
+runtime coverage on a kernel that enables that feature.
+
+Known limitations
+=================
+
+This is an RFC implementation based on Linux 6.12. The swap-entry encoding,
+64-bit restriction, mutual exclusion with zram/zswap, multivalue sysfs ABI
+and source layout need further work before an upstream submission.
+
+Runtime coverage of hibernation, memory hot-remove, DAMON and all
+khugepaged interactions remains incomplete. VM correctness tests and
+relative VM measurements do not establish real-device latency, energy or
+compatibility. Device validation must use the intended release image and
+be reported separately from development-tree results.
diff --git a/MAINTAINERS b/MAINTAINERS
index d1d8f578f62cd9c0b824b0a5f95b49433970c377..5e557aaae70d25ec47f8a602fb89eb63729d14a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14806,6 +14806,8 @@ MEMCOMP IN-MEMORY COMPRESSION
 M:	nakixii <nakixii@gmail.com>
 L:	linux-mm@kvack.org
 S:	Experimental
+F:	Documentation/ABI/testing/sysfs-kernel-mm-memcomp
+F:	Documentation/admin-guide/mm/memcomp.rst
 F:	Documentation/mm/memcomp.rst
 F:	include/linux/memcomp.h
 F:	mm/memcomp.c
