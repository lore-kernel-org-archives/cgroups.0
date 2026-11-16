Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827019;
	b=C2dy5aoWO/ZAP1R6zUM93icYLLkK+nonTWDtIbrAkCqOmbO7FMr+71U1Ruyqoc1cY11D
	 zWu+TzDhH3AtdrCWTs8j2ztcNxTvn7vzrBjRlzz9XBA5ypubVJsQWbJ5TGSfHg9IdcVbi
	 AgF63QlvQ9kK5mve/vRTzEeBns9Yl08Ww+/Q+z11dfRZt/O0MiP/ojZn5bPQi6tlpcOex
	 3G1NAqcf+NkPZLzTCBYMHs6vnkzS7lkjJJ6bsTlvGt/N08ySWjiFHG1qLDpTnZ3Wx+H5W
	 N7FmlFSEl3U/jqayECU7DpKfwl40sONUJOT9Ggx4hQLXp9rkADraUyaHuu7C2QuQZ8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827019;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dtkPIsMJSzldfEnqyfpO3Kcdd14xhNY/Wofzn7QSnQ0=;
	b=c7mH3urpnM8GlNEman1WRg3SnyRJDXznfBPavQKfu5SivZHGWafPzr7cl+XmTFP5UYub
	 GymxnVPxNMG4p1Csy6zGZB1AV4mEQFl9D71WCOO5M4glup2/DdM3gyMsel7qj69Ev7X/b
	 6T4VektIVC8WpksBeR2jBsH72Ewgovw2PkvtFxEP+PA93vXyV9t7qrKBEdghDb1+LzVeB
	 7QmqkS3lhIWlidID3aivxE1aWNhqGoGS6ICFaW74dtVM6qSdOAARQ3cZHZLl5UBTONYS2
	 MRAK2Vg46Epei/u7w4vrDQALIBAyfPM+WkJLoL1ZwKQ+1S24ShEIblHPRf7JeYxdfEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tSwk4lAY;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61776606A32C
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 11:03:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61776606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tSwk4lAY
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1b244fb7fffso3721551c88.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 03:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827017; x=1795431817; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dtkPIsMJSzldfEnqyfpO3Kcdd14xhNY/Wofzn7QSnQ0=;
        b=tSwk4lAY/r4MS2ukFXMqVOozQLGiuXdPPHWZBkdB3Llq+XJI3tATZtFa8Kq4ICjdDr
         6bD3NEvrysJ1fmrAY4Zy8lsKLzuL+iLnGo9BBU2ZUsQHE4ykVJEjpS/FXVydHrJAc+kl
         Ap75D3BQsRgAPgzvLeWXgSuJWNvpWdAoko8IuHn2N/+ldTWEqyGZkHYdSgDcpIZTBpNG
         qy9o1aJ/ytjhXs3AOwhjjpVmU+GFty9m1a4/pWLQfw18niFHfiBEtp/f9MlYqUYFf3qR
         f620pld34IYPbV9qPqHMSZLfsWaVT2tikhqn8P/jHl/S/LuzmpYWjHNK8WyiVuMijn1P
         avYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827017; x=1795431817;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dtkPIsMJSzldfEnqyfpO3Kcdd14xhNY/Wofzn7QSnQ0=;
        b=kf7Fg1VUJ+ELyBGIs2DqWr1ZipglF0+nlPMAQ2gKl/lVf8fYecSsAesQcJDRKtml09
         LDHk2sHI2x3fD6imTVI5OqU26wFTqptrs6QJmp7RLp96NecOlhli2XzOhjwl8RSjBttv
         60p/r6DrpvDilY1QqgRfme1GF8nCzPMOiPVlqNLf5g6x/608YNjwVd3+VreWYybcg3c7
         i3MyuWa8PgAhFybumFEnsJOH6nFJDWa45qtP+mGuy+fCgQHM+M2Bgd30WJyFYOIaLDUM
         neCFaytU5W0++19effkweqPMg2Wbpgb98aceBkmZgncXDOA+Z1quXWXEIdGxK+kJpheY
         Q34w==
X-Forwarded-Encrypted: i=1; AL+hErFz9XRWH7TAyMkpN6iJ5otN0e0vVfHl/7f64rrUPrKk2CBdjiyVX2wEuhgd/WpGYvSefJ38AfaP@vger.kernel.org
X-Gm-Message-State: APuU4Z+SMy72KUkbhxkiG39X/opj84kwi1mEOpRHF/0cc0B/vKyaxP3G
	A/SgaJ8qnWtzIwVPdGzardROVcuMFXZNhtFS1JCIly0Qt/IEVmixqwJ1
X-Gm-Gg: AYBFou2hk3B85lYHv8Yuka2bQGhdrl9gwRsAIC5XxZuF2Jykw6+vESxf3JWQtwI+iRm
	zJH2yi2dUd0leBQV99hiErty5zoBHQ0fpwWDIaMNC2UGvjV4KQ/ZK8+uMOhB7BXzE6QK1G0gR1u
	esHhkyCLUY/G7pg3VtnSmYAERWTkHQm+0x68iAWMOiC5PNq4WTmm8sxEal47JGjtbadJFV3GK3b
	wMEJqMWzl0ZdrKpTFgm6QpFmEOyPyeoLz0du8Ctv0Fbq0UmO9kLDZTlnylZzXuuZ+k2pfyFWLwO
	+cQiuwyjtvbD0M5uAtrOlcqOPwxvV874Y2WG04sAVlETkjBdUu7uuB3GqT8CwqNfMqA76hFekKc
	D/XKp6rwfrgUTfjrnq+RSg6W9m7rvOKgaJVAc3Zb3fs21PzCZ4EZpCSkJwvmFC1wUXX7rRtuU08
	BRl78SqxmvPVqjSa4HWEQnXoiI8CHZev1De0p291tq0LhDXx4nDchI7HZ45pjAzSKvvQ5g3RxJe
	KWh/5Mkc4MfOK2U4eiG8Nboy43KYiuB8ZZ10b4SBn/V7LerJ1eiyuciKbQ5HzIXb2cEKWW/0hOr
	SFau8cWNasxW0Zxnsktlx1pnTYVVgQKE8Y2gn2StiS4bsps=
X-Received: by 2002:a05:7022:5f01:b0:151:2e62:fe8a with SMTP id a92af1059eb24-1b50313d8a1mr9131206c88.40.1794827016955;
        Mon, 16 Nov 2026 03:03:36 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:03:36 -0800 (PST)
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
Subject: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
Date: Mon, 16 Nov 2026 19:01:06 +0800
Message-ID: <20261116110122.309748-1-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
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

This is a proof of concept, posted to ask whether the approach is worth
pursuing. It is not meant for merging. The series is based on Linux
6.12.23, not on mm-unstable, and has not been ported to the swap-table
and zpool changes that have landed since. If there is interest, the
next version will be rebased onto mm-unstable.

memcomp stores reclaimed anonymous and shmem pages in compressed form
in memory, using the kernel's compressors and zsmalloc unchanged.
Reclaim replaces the PTE, or the shmem page-cache entry, with a
swap-like token that names a 16-byte slot. A fault on the token
decompresses the page and maps it again. No block device is needed. If
swap is configured, cold entries can be written back to it. The sysfs
interface is under /sys/kernel/mm/memcomp.

The implementation uses 16-byte slots, a separate owner domain for zero
pages, per-key storage and bounded metadata aging. Memory-cgroup
accounting, cold-page writeback, asynchronous compression, precise
residency reporting and mincore support are separate patches.

Refaults follow stock workingset accounting. The first reader claims
and clears the shadow under the slot lock. Feedback runs after
charging, outside the PTL and slot locks, before the page is read and
installed. Consumed feedback is not restored if the read or the
installation fails. An mTHP uses the shadow of its first base page and
clears the shadows of all its pages. Swapoff returns payloads to the
pool without building user pages.

Base and branches
=================

The 16 patches sit on Linux 6.12.23 plus eight prerequisite commits;
base-commit below names the top of that layer. The prerequisites make
the series work on 6.12 and are not part of the proposal. Those already
upstream drop out on a newer base. An android16-6.12 port carries 18
patches, the 16 here plus two ANDROID patches for vendor hooks and
gki_defconfig, on a nine-commit prerequisite layer.

  mainline: https://github.com/nakixii/linux/tree/memcomp/series-v1
  ACK:      https://github.com/nakixii/linux/tree/memcomp/android16-6.12
  whitepaper, benchmarks and results: https://github.com/nakixii/memcomp

Testing
=======

KUnit: 492 tests pass on x86, both with the classic LRU in a debug
configuration and with MGLRU. On arm64 ACK with MTE (HW_TAGS), 487 pass
and six are skipped as architecture-specific.

All 17 cases of an end-to-end test in KVM guests passed their checks.
The nine cases with swap ran every check; in the eight cases without
swap the checker stops early, so those results are partial.

These are retained results, not reruns. KUnit ran on the final test
candidate, before the sysfs directory was renamed and the matching
comments and documentation were updated. The end-to-end test ran on an
earlier implementation checkpoint, before later test additions and the
rename.

checkpatch --strict reports no errors and no checks, and 17 warnings:
six FILE_PATH_CHANGES notes for new files; one allocation that would
use kzalloc_obj(), which 6.12 does not have; one ENOSYS in a selftest
that compares a userspace errno; and nine BUG_ON warnings, eight on
assertions carried over from stock page_io.c and workingset.c code and
one on a shmem token reference. sparse was run on x86 with LLVM and
GCC; arm64 sparse and W=1 were not run.

Not covered by tests
====================

Hibernation, memory hot-remove, DAMON and khugepaged have had static
review only. The paths without an exact test include swapon unwind and
retry after a bitmap allocation failure, a genuine shmem charge failure
as distinct from an earlier allocation failure, zero-page refault
windows attributable to one operation, two concurrent readers of one
token, a pool return followed by its first consumption, and ordinary
reuse of the same swap offset. The error path for a failed pin of a
still-online source memory cgroup is defensive and was never reached at
runtime.

Questions for review
====================

- The source and patch layout: the implementation is one compilation
  unit with internal headers split by function.
- The multivalue sysfs ABI and the debug counters.
- Whether direct reclaim should skip folios with a high mapcount. A
  failed store can cost an unmap plus a reverse-map walk.
- The encoding uses one swap type and supports only 64-bit
  configurations, and memcomp cannot run together with zram or zswap.
- KUnit probes are kept in production code.

Results
=======

The comparison ran 965 fresh guest boots on real application pages,
under nested KVM on WSL2, with a paired rule fixed before collection.
Selected results:

  Without real swap, single-page refault p99 was 10.7 us against 20.7 us
  for zram with lz4, and 22.0 us against 27.3 us with zstd. Under
  512 MiB of anonymous pressure, refault p99 was 37% lower than zram
  with lz4 and 36% lower than zswap.
  Completed-switch p99 with zstd was 33-36% lower than zram in 10/10
  rounds and 20-22% lower than zswap in 9/10; these differences were
  smaller than the reference's variation between rounds.
  After writeback, readback p50 over an 832 MiB target was 11.9 us
  against 105.5 us for zswap and 114.0 us for zram writeback, with
  70-76% fewer bytes written before readback; p99 was about the same.

Less favorable:

  With real swap, single-page refault p99 was 4.8 times zram with lz4
  and about 1.5 times zram and zswap with zstd.
  Sequential refault was 30-31% slower than zswap, since there is no
  swap readahead. Single-page pageout p99 was 35-38% slower than zswap.
  In the pageout and refault workload, 64 MiB of real pages per
  application, memcomp used 5-8% more memory than zram; this leaves
  out zram's disksize-sized table, which was larger than the difference.

The measured kernels differ from this series only by the sysfs directory
rename and by seven removed header-comment lines. All decisions,
including undecided rows, are in the whitepaper. No phone results are
reported: the variables on a phone could not be controlled, so all
numbers come from KVM guests, and they do not establish device latency,
energy use or compatibility.

Tool use
========

Most of the code, the tests, the changelogs and this letter were
written with LLM coding assistants, working from my design decisions
and under my review over many iterations. I reviewed every patch and
take responsibility for it. The assistants also ran the builds, KUnit,
the KVM end-to-end test and the 965-boot comparison described above;
the test programs and raw results are in the GitHub repository.

nakixii (16):
  mm: userfaultfd: check the exclusivity of the page being moved
  mm: add a swap entry type for in-memory compressed pages
  mm: memcomp: compress reclaimed anonymous pages in memory
  mm: userfaultfd: let UFFDIO_MOVE move memcomp entries
  mm: memcomp: charge compressed pages to the source memcg
  mm: memcomp: store shmem and tmpfs pages
  mm: memcomp: write cold pages back to swap
  mm: memcomp: compress foreground batches asynchronously
  mm: memcomp: batch unmap reserved large folios
  mm: memcomp: queue restored large folios for splitting
  mm: memcomp: account user eviction and refault
  mm: memcomp: report precise token residency
  mm: memcomp: add KUnit tests
  selftests/mm: add a memcomp pageout and refault test
  mm: memcomp: add the design doc
  mm: memcomp: add the admin guide

 .../ABI/testing/sysfs-kernel-mm-memcomp       |  363 +
 .../admin-guide/kernel-parameters.txt         |   10 +
 Documentation/admin-guide/mm/index.rst        |    1 +
 Documentation/admin-guide/mm/memcomp.rst      |  149 +
 Documentation/mm/index.rst                    |    1 +
 Documentation/mm/memcomp.rst                  |  215 +
 MAINTAINERS                                   |   12 +
 fs/proc/task_mmu.c                            |   20 +
 include/linux/memcomp.h                       |  481 ++
 include/linux/memcontrol.h                    |   45 +
 include/linux/swap.h                          |   52 +-
 include/linux/swapops.h                       |   22 +
 mm/Kconfig                                    |   75 +
 mm/Makefile                                   |    1 +
 mm/hmm.c                                      |    3 +
 mm/huge_memory.c                              |   44 +
 mm/internal.h                                 |   84 +
 mm/madvise.c                                  |   10 +-
 mm/memcomp.c                                  | 6181 +++++++++++++++++
 mm/memcomp/access.h                           |  132 +
 mm/memcomp/anon_folio.h                       |   84 +
 mm/memcomp/anon_store.h                       |  268 +
 mm/memcomp/api.h                              |  205 +
 mm/memcomp/cache_folio.h                      |  103 +
 mm/memcomp/cache_store.h                      |   97 +
 mm/memcomp/consumers.h                        |  129 +
 mm/memcomp/defrag.h                           |  169 +
 mm/memcomp/drain.h                            |   83 +
 mm/memcomp/fault.h                            |  320 +
 mm/memcomp/fault_alloc.h                      |   23 +
 mm/memcomp/fifo.h                             |  136 +
 mm/memcomp/folio.h                            |  434 ++
 mm/memcomp/format.h                           |  308 +
 mm/memcomp/lifetime.h                         |   87 +
 mm/memcomp/load.h                             |   96 +
 mm/memcomp/migrate.h                          |  155 +
 mm/memcomp/mincore.h                          |   83 +
 mm/memcomp/owner.h                            |  157 +
 mm/memcomp/payload.h                          |  151 +
 mm/memcomp/query.h                            |  187 +
 mm/memcomp/refs.h                             |   83 +
 mm/memcomp/resident.h                         |  106 +
 mm/memcomp/scan.h                             |  115 +
 mm/memcomp/span.h                             |   89 +
 mm/memcomp/storage.h                          | 1131 +++
 mm/memcomp/swapoff.h                          |  190 +
 mm/memcomp/swapoff_walk.h                     |  122 +
 mm/memcomp/tests/.kunitconfig                 |   16 +
 mm/memcomp/tests/access_test.h                |  197 +
 mm/memcomp/tests/aging_test.h                 |  771 ++
 mm/memcomp/tests/anon_store_test.h            |  704 ++
 mm/memcomp/tests/async_test.h                 |  703 ++
 mm/memcomp/tests/budget_packed_test.h         |  435 ++
 mm/memcomp/tests/budget_swapped_test.h        |  292 +
 mm/memcomp/tests/budget_test.h                |  542 ++
 mm/memcomp/tests/cache_folio_test.h           |  627 ++
 mm/memcomp/tests/cache_reserve_test.h         |  447 ++
 mm/memcomp/tests/cache_store_test.h           |  216 +
 mm/memcomp/tests/cache_xarray_race_test.h     |  193 +
 mm/memcomp/tests/codec_scope_test.h           |   94 +
 mm/memcomp/tests/consumers_test.h             |  478 ++
 mm/memcomp/tests/core_test.h                  |  119 +
 mm/memcomp/tests/defrag_test.h                |  601 ++
 mm/memcomp/tests/drain_test.h                 |  581 ++
 mm/memcomp/tests/enospc_test.h                |  236 +
 mm/memcomp/tests/fault_alloc_test.h           |  119 +
 mm/memcomp/tests/fault_test.h                 |  851 +++
 mm/memcomp/tests/folio_test.h                 |  769 ++
 mm/memcomp/tests/format_test.h                |  520 ++
 mm/memcomp/tests/late_async_test.h            |  331 +
 mm/memcomp/tests/load_test.h                  |  133 +
 mm/memcomp/tests/migrate_test.h               |  795 +++
 mm/memcomp/tests/mincore_test.h               |  462 ++
 mm/memcomp/tests/owner_test.h                 |  400 ++
 mm/memcomp/tests/payload_test.h               |  220 +
 mm/memcomp/tests/public_api_test.h            |  422 ++
 mm/memcomp/tests/public_driver_test.h         |  358 +
 mm/memcomp/tests/query_test.h                 |  480 ++
 mm/memcomp/tests/refs_test.h                  |  224 +
 mm/memcomp/tests/replacement_test.h           |  360 +
 mm/memcomp/tests/resident_test.h              |  796 +++
 mm/memcomp/tests/rollback_test.h              |  163 +
 mm/memcomp/tests/scan_test.h                  |  422 ++
 mm/memcomp/tests/shared_test.h                | 3477 ++++++++++
 mm/memcomp/tests/shmem_retry_test.h           |  340 +
 mm/memcomp/tests/shmem_zero_fault_test.h      |  121 +
 mm/memcomp/tests/span_test.h                  |  128 +
 mm/memcomp/tests/storage_fixture.h            |   84 +
 mm/memcomp/tests/storage_test.h               |  468 ++
 mm/memcomp/tests/store_transaction_test.h     |  587 ++
 mm/memcomp/tests/suite.h                      |  693 ++
 mm/memcomp/tests/swapoff_test.h               |  558 ++
 mm/memcomp/tests/swapoff_walk_test.h          |  562 ++
 mm/memcomp/tests/swapoff_yield_test.h         |  532 ++
 mm/memcomp/tests/test_api.h                   |   41 +
 mm/memcomp/tests/transport_reclaim_test.h     |  298 +
 mm/memcomp/tests/transport_test.h             |  114 +
 mm/memcomp/tests/workingset_load_test.h       | 1095 +++
 mm/memcomp/tests/workingset_mthp_error_test.h |  164 +
 mm/memcomp/tests/workingset_storage_test.h    |  442 ++
 mm/memcomp/tests/workingset_store_test.h      |  572 ++
 mm/memcomp/tests/writeback_batch_test.h       |  688 ++
 mm/memcomp/tests/writeback_test.h             |  540 ++
 mm/memcomp/tests/zero_callers_test.h          |  717 ++
 mm/memcomp/tests/zero_carrier_test.h          |  405 ++
 mm/memcomp/tests/zero_convert_test.h          |  694 ++
 mm/memcomp/tests/zero_hint_test.h             |  860 +++
 mm/memcomp/tests/zero_load_test.h             |  645 ++
 mm/memcomp/tests/zero_test.h                  |  313 +
 mm/memcomp/workingset_load.h                  |   97 +
 mm/memcomp/workingset_store.h                 |   62 +
 mm/memcomp/writeback.h                        |  133 +
 mm/memcomp/writeback_batch.h                  |  398 ++
 mm/memcomp/zero.h                             |  205 +
 mm/memcomp/zero_convert.h                     |   78 +
 mm/memcomp/zero_load.h                        |   91 +
 mm/memcomp_rmap.h                             |  139 +
 mm/memcontrol.c                               |   99 +
 mm/memory.c                                   |   42 +-
 mm/migrate.c                                  |   11 +-
 mm/mincore.c                                  |  125 +-
 mm/page_io.c                                  |   42 +
 mm/rmap.c                                     |   41 +-
 mm/shmem.c                                    |  251 +
 mm/swap.h                                     |    4 +
 mm/swap_state.c                               |    5 +
 mm/swapfile.c                                 |   49 +
 mm/userfaultfd.c                              |   94 +-
 mm/vmscan.c                                   |  651 +-
 mm/workingset.c                               |   32 +
 tools/testing/selftests/mm/Makefile           |    9 +-
 tools/testing/selftests/mm/config             |   11 +
 tools/testing/selftests/mm/hmm-tests.c        |  112 +
 tools/testing/selftests/mm/memcomp.c          |  831 +++
 134 files changed, 46825 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-memcomp
 create mode 100644 Documentation/admin-guide/mm/memcomp.rst
 create mode 100644 Documentation/mm/memcomp.rst
 create mode 100644 include/linux/memcomp.h
 create mode 100644 mm/memcomp.c
 create mode 100644 mm/memcomp/access.h
 create mode 100644 mm/memcomp/anon_folio.h
 create mode 100644 mm/memcomp/anon_store.h
 create mode 100644 mm/memcomp/api.h
 create mode 100644 mm/memcomp/cache_folio.h
 create mode 100644 mm/memcomp/cache_store.h
 create mode 100644 mm/memcomp/consumers.h
 create mode 100644 mm/memcomp/defrag.h
 create mode 100644 mm/memcomp/drain.h
 create mode 100644 mm/memcomp/fault.h
 create mode 100644 mm/memcomp/fault_alloc.h
 create mode 100644 mm/memcomp/fifo.h
 create mode 100644 mm/memcomp/folio.h
 create mode 100644 mm/memcomp/format.h
 create mode 100644 mm/memcomp/lifetime.h
 create mode 100644 mm/memcomp/load.h
 create mode 100644 mm/memcomp/migrate.h
 create mode 100644 mm/memcomp/mincore.h
 create mode 100644 mm/memcomp/owner.h
 create mode 100644 mm/memcomp/payload.h
 create mode 100644 mm/memcomp/query.h
 create mode 100644 mm/memcomp/refs.h
 create mode 100644 mm/memcomp/resident.h
 create mode 100644 mm/memcomp/scan.h
 create mode 100644 mm/memcomp/span.h
 create mode 100644 mm/memcomp/storage.h
 create mode 100644 mm/memcomp/swapoff.h
 create mode 100644 mm/memcomp/swapoff_walk.h
 create mode 100644 mm/memcomp/tests/.kunitconfig
 create mode 100644 mm/memcomp/tests/access_test.h
 create mode 100644 mm/memcomp/tests/aging_test.h
 create mode 100644 mm/memcomp/tests/anon_store_test.h
 create mode 100644 mm/memcomp/tests/async_test.h
 create mode 100644 mm/memcomp/tests/budget_packed_test.h
 create mode 100644 mm/memcomp/tests/budget_swapped_test.h
 create mode 100644 mm/memcomp/tests/budget_test.h
 create mode 100644 mm/memcomp/tests/cache_folio_test.h
 create mode 100644 mm/memcomp/tests/cache_reserve_test.h
 create mode 100644 mm/memcomp/tests/cache_store_test.h
 create mode 100644 mm/memcomp/tests/cache_xarray_race_test.h
 create mode 100644 mm/memcomp/tests/codec_scope_test.h
 create mode 100644 mm/memcomp/tests/consumers_test.h
 create mode 100644 mm/memcomp/tests/core_test.h
 create mode 100644 mm/memcomp/tests/defrag_test.h
 create mode 100644 mm/memcomp/tests/drain_test.h
 create mode 100644 mm/memcomp/tests/enospc_test.h
 create mode 100644 mm/memcomp/tests/fault_alloc_test.h
 create mode 100644 mm/memcomp/tests/fault_test.h
 create mode 100644 mm/memcomp/tests/folio_test.h
 create mode 100644 mm/memcomp/tests/format_test.h
 create mode 100644 mm/memcomp/tests/late_async_test.h
 create mode 100644 mm/memcomp/tests/load_test.h
 create mode 100644 mm/memcomp/tests/migrate_test.h
 create mode 100644 mm/memcomp/tests/mincore_test.h
 create mode 100644 mm/memcomp/tests/owner_test.h
 create mode 100644 mm/memcomp/tests/payload_test.h
 create mode 100644 mm/memcomp/tests/public_api_test.h
 create mode 100644 mm/memcomp/tests/public_driver_test.h
 create mode 100644 mm/memcomp/tests/query_test.h
 create mode 100644 mm/memcomp/tests/refs_test.h
 create mode 100644 mm/memcomp/tests/replacement_test.h
 create mode 100644 mm/memcomp/tests/resident_test.h
 create mode 100644 mm/memcomp/tests/rollback_test.h
 create mode 100644 mm/memcomp/tests/scan_test.h
 create mode 100644 mm/memcomp/tests/shared_test.h
 create mode 100644 mm/memcomp/tests/shmem_retry_test.h
 create mode 100644 mm/memcomp/tests/shmem_zero_fault_test.h
 create mode 100644 mm/memcomp/tests/span_test.h
 create mode 100644 mm/memcomp/tests/storage_fixture.h
 create mode 100644 mm/memcomp/tests/storage_test.h
 create mode 100644 mm/memcomp/tests/store_transaction_test.h
 create mode 100644 mm/memcomp/tests/suite.h
 create mode 100644 mm/memcomp/tests/swapoff_test.h
 create mode 100644 mm/memcomp/tests/swapoff_walk_test.h
 create mode 100644 mm/memcomp/tests/swapoff_yield_test.h
 create mode 100644 mm/memcomp/tests/test_api.h
 create mode 100644 mm/memcomp/tests/transport_reclaim_test.h
 create mode 100644 mm/memcomp/tests/transport_test.h
 create mode 100644 mm/memcomp/tests/workingset_load_test.h
 create mode 100644 mm/memcomp/tests/workingset_mthp_error_test.h
 create mode 100644 mm/memcomp/tests/workingset_storage_test.h
 create mode 100644 mm/memcomp/tests/workingset_store_test.h
 create mode 100644 mm/memcomp/tests/writeback_batch_test.h
 create mode 100644 mm/memcomp/tests/writeback_test.h
 create mode 100644 mm/memcomp/tests/zero_callers_test.h
 create mode 100644 mm/memcomp/tests/zero_carrier_test.h
 create mode 100644 mm/memcomp/tests/zero_convert_test.h
 create mode 100644 mm/memcomp/tests/zero_hint_test.h
 create mode 100644 mm/memcomp/tests/zero_load_test.h
 create mode 100644 mm/memcomp/tests/zero_test.h
 create mode 100644 mm/memcomp/workingset_load.h
 create mode 100644 mm/memcomp/workingset_store.h
 create mode 100644 mm/memcomp/writeback.h
 create mode 100644 mm/memcomp/writeback_batch.h
 create mode 100644 mm/memcomp/zero.h
 create mode 100644 mm/memcomp/zero_convert.h
 create mode 100644 mm/memcomp/zero_load.h
 create mode 100644 mm/memcomp_rmap.h
 create mode 100644 tools/testing/selftests/mm/memcomp.c


base-commit: e728da875eb1d50add12357d01f44a3edf9a6f8c
