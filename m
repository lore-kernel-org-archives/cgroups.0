Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827665;
	b=FRnkZMny0xNxdO509cl6iABSz3L1UDEUTxfyeNLEEsxEqqq/EN8ls9cnySUB99zjLiLr
	 7ZyQUE1l7yuCowTUJ51V7LUap1OowEPv7HGvtSsgByAyOEWNVxlnbQmkXYjHHs+JDiyUk
	 MGgOVEKOie3qRzdVRpRcNFQ7PMOcWGct29ql5dmGj4oHIeusHQnWSNMWnbRB5u/KteTDo
	 vZ2T9EmkvwJ24zKzytzZ6xkD3hMdBr5wM7U83mojfdT2JlAswz2AqLsCZTjqC0RvRDCz9
	 GAiFC+KG3+mWrZzzAyz0CtRQetQeInxHLrHC7pfReAcOnb72byRjGvCzi0ZiwGC6Jmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827665;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=KNPAh5bBD/DCtRCxR0hqcD+XfwtFgFjRzluMrGXNBRI=;
	b=EHGgpGHAm59gYeWg3WzBjjHLH9Osy2AQEeOqqq+eZlj+K1jUKVh1vkg8wDsEaPpRlykL
	 CwJidtbAR8Oir0hTyHrlATWVVBoig5DWsOv3GG5w9jXJSMR/tkpimOvBAmPisaAG6WwL4
	 MI2BidJRYE5o4odai9ScrL054newRaUv2LNZ6U/1Ji9KAdpyj/cGUxov3dcc3lETkGSdN
	 m3glhh4ecGXiie6YWmW/1l2ejHHy0Qvg35hSm+/k5Bi1tHaIdlkwYbUX6j4rblNz7pBSW
	 O5sYQxuUM6mDfKLiC/4wwD4CQ7RJV0ufQ+IzNDTe+tO0C1Gku/dbd97GTbt6Jky8kFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5zrqDaC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07E2606A332;
	Mon, 16 Nov 2026 11:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5zrqDaC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E331F000C4;
	Mon, 16 Nov 2026 11:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827664;
	bh=KNPAh5bBD/DCtRCxR0hqcD+XfwtFgFjRzluMrGXNBRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O5zrqDaCTmINWztAloFXN+rib9w6MXO+Cig6Cqk8sJgar8MILTmb6qSQTzdhtT5vQ
	 /ai9JqDwBZCd7Bj+66UtHdzRGQDUWraCnMEPl+H+91qobdHvRBE09minUyXSPTDOHN
	 SR+Z1HO69AKxCZozQX2A13wcm5W1p7E/BSAAzcXVEhs/gGNPHLVeJwRsAhCy42glLk
	 sZzo45Lyuk1zo5M3067MD/U5Kh3sJlqEb0fmFvM6jPpWFQNAtIp4vwa8652NKBEqcq
	 gXMnfrqG3xlHcUMPkCUaZyXk5hZd2JZpuKmAXRzngkZkn3miQVNMe57FPiGEnq0Vq6
	 plAw86jLVh3yQ==
Date: Mon, 16 Nov 2026 13:14:16 +0200
From: Mike Rapoport <rppt@kernel.org>
To: nakixii <nakixii@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed
 pages
Message-ID: <avrliOfBi326au6B@kernel.org>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>

Hi,

On Mon, Nov 16, 2026 at 07:01:06PM +0800, nakixii wrote:
> This is a proof of concept, posted to ask whether the approach is worth
> pursuing. It is not meant for merging. The series is based on Linux
> 6.12.23, not on mm-unstable, and has not been ported to the swap-table
> and zpool changes that have landed since. If there is interest, the
> next version will be rebased onto mm-unstable.
> 
> memcomp stores reclaimed anonymous and shmem pages in compressed form
> in memory, using the kernel's compressors and zsmalloc unchanged.
> Reclaim replaces the PTE, or the shmem page-cache entry, with a
> swap-like token that names a 16-byte slot. A fault on the token
> decompresses the page and maps it again. No block device is needed. If
> swap is configured, cold entries can be written back to it. The sysfs
> interface is under /sys/kernel/mm/memcomp.
> 
> Results
> =======
> 
> The comparison ran 965 fresh guest boots on real application pages,
> under nested KVM on WSL2, with a paired rule fixed before collection.
> Selected results:
> 
>   Without real swap, single-page refault p99 was 10.7 us against 20.7 us
>   for zram with lz4, and 22.0 us against 27.3 us with zstd. Under
>   512 MiB of anonymous pressure, refault p99 was 37% lower than zram
>   with lz4 and 36% lower than zswap.
>   Completed-switch p99 with zstd was 33-36% lower than zram in 10/10
>   rounds and 20-22% lower than zswap in 9/10; these differences were
>   smaller than the reference's variation between rounds.
>   After writeback, readback p50 over an 832 MiB target was 11.9 us
>   against 105.5 us for zswap and 114.0 us for zram writeback, with
>   70-76% fewer bytes written before readback; p99 was about the same.
> 
> Less favorable:
> 
>   With real swap, single-page refault p99 was 4.8 times zram with lz4
>   and about 1.5 times zram and zswap with zstd.
>   Sequential refault was 30-31% slower than zswap, since there is no
>   swap readahead. Single-page pageout p99 was 35-38% slower than zswap.
>   In the pageout and refault workload, 64 MiB of real pages per
>   application, memcomp used 5-8% more memory than zram; this leaves
>   out zram's disksize-sized table, which was larger than the difference.
> 
> nakixii (16):
>   mm: userfaultfd: check the exclusivity of the page being moved
>   mm: add a swap entry type for in-memory compressed pages
>   mm: memcomp: compress reclaimed anonymous pages in memory
>   mm: userfaultfd: let UFFDIO_MOVE move memcomp entries
>   mm: memcomp: charge compressed pages to the source memcg
>   mm: memcomp: store shmem and tmpfs pages
>   mm: memcomp: write cold pages back to swap
>   mm: memcomp: compress foreground batches asynchronously
>   mm: memcomp: batch unmap reserved large folios
>   mm: memcomp: queue restored large folios for splitting
>   mm: memcomp: account user eviction and refault
>   mm: memcomp: report precise token residency
>   mm: memcomp: add KUnit tests
>   selftests/mm: add a memcomp pageout and refault test
>   mm: memcomp: add the design doc
>   mm: memcomp: add the admin guide
> 
>  .../ABI/testing/sysfs-kernel-mm-memcomp       |  363 +
>  .../admin-guide/kernel-parameters.txt         |   10 +
>  Documentation/admin-guide/mm/index.rst        |    1 +
>  Documentation/admin-guide/mm/memcomp.rst      |  149 +
>  Documentation/mm/index.rst                    |    1 +
>  Documentation/mm/memcomp.rst                  |  215 +
>  MAINTAINERS                                   |   12 +
>  fs/proc/task_mmu.c                            |   20 +
>  include/linux/memcomp.h                       |  481 ++
>  include/linux/memcontrol.h                    |   45 +
>  include/linux/swap.h                          |   52 +-
>  include/linux/swapops.h                       |   22 +
>  mm/Kconfig                                    |   75 +
>  mm/Makefile                                   |    1 +
>  mm/hmm.c                                      |    3 +
>  mm/huge_memory.c                              |   44 +
>  mm/internal.h                                 |   84 +
>  mm/madvise.c                                  |   10 +-
>  mm/memcomp.c                                  | 6181 +++++++++++++++++

... (a lot of memcomp/ +++ changes)

>  mm/memcontrol.c                               |   99 +
>  mm/memory.c                                   |   42 +-
>  mm/migrate.c                                  |   11 +-
>  mm/mincore.c                                  |  125 +-
>  mm/page_io.c                                  |   42 +
>  mm/rmap.c                                     |   41 +-
>  mm/shmem.c                                    |  251 +
>  mm/swap.h                                     |    4 +
>  mm/swap_state.c                               |    5 +
>  mm/swapfile.c                                 |   49 +
>  mm/userfaultfd.c                              |   94 +-
>  mm/vmscan.c                                   |  651 +-
>  mm/workingset.c                               |   32 +
>  tools/testing/selftests/mm/Makefile           |    9 +-
>  tools/testing/selftests/mm/config             |   11 +
>  tools/testing/selftests/mm/hmm-tests.c        |  112 +
>  tools/testing/selftests/mm/memcomp.c          |  831 +++
>  134 files changed, 46825 insertions(+), 14 deletions(-)

This seems to big of a change and the wall of text in your "results"
section does not explain clearly why would we want to bother reading this.

-- 
Sincerely yours,
Mike.
