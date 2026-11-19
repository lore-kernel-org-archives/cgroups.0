Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795131603;
	b=b349KRGr03BO7FTiPNEqBFAPaGwXcCpupGuXAWMoK+pQf7TNeLRkJ8Ml97XCq+bH4XTR
	 eK2flZZuZwD8Q/NaTAP74Dp+uSZBonwD7l+gDlmnJQcIBgwemLvrgZD2jmMHgBqM2oi7g
	 XQqUfUWrsKupBnRY26cejDBqzce1IuQJgSTAANRIAcpAA9+LGVD2v/Ha5XYsOoVs0pHZo
	 +YoxZ2EPwJzZySkhhoWQIlvOsO8aVUXEEspshf29iTK0oWEtYixF1VGe+XBh1tt5ewcz0
	 b591/yyZydp79h1MzA0UjbNHFJqYPM9cEo7Bi2jP0d4gorQvf1Th5ZvW/jNWbiaD3Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795131603;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=1DASm4ABHvydbCgPqdPTvCuRMoED8Hk0QLqB2S7niGg=;
	b=L7ku23S/LwmaY2H8uGqUBH2H+07brjfBfkyjFva6W9XGc3KC1RFmzKxLOrjaNu664okK
	 H34DNJRcvxztJCESYrAZiuAlTE/pu+7mDrzROG236EZMPAr9WC7M3mFDcL9f+2Et1jxg+
	 kAuUTmlQPSE8EDDSrhGN2e2ZDj//bYvjkLVsV6VQPnl2LBtRt6P0OMk8fH6HvwX7UA/pU
	 cOTUy9k22v7j7D1EuLMxYtp6GqUTDygR0gKvFLmgZ7cbSSR6Ypwa/TM2BQdAaiBXYFY15
	 uJJfGrR0xTUpRqoZFYjZ8pftOwcG2yib90hbQxn/VkuiCuAAMnkmFyYZ3X55dEfg0mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=U+0csrj6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C36606A325;
	Thu, 19 Nov 2026 23:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=U+0csrj6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD221F000C4;
	Thu, 19 Nov 2026 23:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795131603;
	bh=1DASm4ABHvydbCgPqdPTvCuRMoED8Hk0QLqB2S7niGg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=U+0csrj65wERCccDzC12LroJ2Kmi9pNSiZ1GLXYN+X4ITS8T6WSI63cqKE+cX4Hmm
	 L0hxYNeHlbh+eBUYUAc2PsDKL1D14zOI/mu4STeDpxOXDKv6VSo0+AzDC55vy6g569
	 KmmPM5xLsXz2U+B/JyPbFblGAVZAUVviXOydljfE=
Date: Thu, 19 Nov 2026 15:40:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Muchun Song
 <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Ying Huang
 <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He
 <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Nhat Pham
 <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan
 <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins
 <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes
 <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, Vernon Yang
 <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, Chen Ridong
 <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, Kairui Song
 <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh
 <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian
 Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, Kunwu
 Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 damon@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 00/17] mm/mglru: frequency guided promotion
 (MGLRU-FG) and flag cleanup
Message-Id: <20261119154001.9b9f953136935a09e8a50af6@linux-foundation.org>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
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

On Thu, 19 Nov 2026 05:03:32 +0800 Kairui Song <kasong@tencent.com> wrote:

> This series implements MGLRU-FG following the idea proposed at LSF/MM/BPF
> this year [1], based on current mm-new. Depending on the workload, it
> improves the performance or reduces IO by roughly 10% to over 50%,
> fixes multiple long-standing issues with MGLRU metrics, and drops one
> page flag.

This is looking really good - great stuff.

Review is thin, so I'll remain in wait-and-see mode for now.  What do
people think?

I told LLM to put this series through its paces.  The performance gains
were confirmed (actually muchly exceeded) and it couldn't find a way to
break anything.  It found a smallish slowdown in writes to clear_refs,
which doesn't seem very important?

Feel free to add
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: <whatever the URL of this email is>



wall-of-words for the brave:


: I tested v5 of "mm/mglru: frequency guided promotion (MGLRU-FG) and flag
: cleanup", a 17-patch series, in x86-64 QEMU guests with four CPUs, two
: NUMA nodes, 8 GiB RAM and matched kernel configurations. The main A/B
: comparison removed or applied the whole series. KASAN builds checked
: correctness and injected allocation failures. A 512 MiB ext4 file,
: four readers and a 192 MiB memory cgroup exercised cold-cache file
: reclaim. With QEMU host caching disabled for both kernels, the skewed
: mmap median was 137.5 seconds on A and 5.21 seconds on B; a fresh A
: repeat took 139.1 seconds. The full series also made repeated
: clear_refs/smaps scans about 7% slower. Separate builds tested selected
: patches immediately before and after application.
: 
: Series:
: https://lore.kernel.org/20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com
: 
: [1/17] mm/mglru: rename the generation offset in lru_gen_folio_seq() (pass)
: 
: The kernel with patch 1 built and booted. It passed 12 charged-cgroup
: removals and an 8192-page get_user_pages test without a warning. This
: preparatory rename makes no separate behavior claim.
: 
: [2/17] mm/memcontrol: allow update of LRU statistic without holding LRU lock (pass)
: 
: Kernels through patches 1 and 2 each passed 12 cycles of charging
: file pages to a cgroup and removing it while another task read the
: file. The charge and data were correct, with no warning. This
: preparatory change permits atomic LRU statistics updates without the
: LRU lock.
: 
: [3/17] mm/mglru: make generation page counters atomic (pass)
: 
: Kernels through patches 2 and 3 passed the cgroup-removal and
: 8192-page get_user_pages tests without a warning. After eight MGLRU
: aging passes on both NUMA nodes, each still accounted for about
: 512 MiB of anonymous memory. This is an atomic-counter conversion
: with no claimed behavior change; the run checked accounting after aging.
: 
: [4/17] mm/memcg: add folio-based lruvec live helper (full-series check passed)
: 
: A full-series KASAN kernel used a one-shot, task-scoped mdelay(800)
: in folio_inc_lru_refs(), just after folio_lruvec_live_get(), inside
: the RCU read-side section. Another task removed the file's charged
: memory cgroup. rmdir finished before the held reader was released;
: the read completed without a KASAN report or warning. This B-only
: test proves the observed removal/read overlap, not execution of an
: RCU callback or freeing of the memory cgroup during the hold.
: 
: [5/17] mm/mglru: skip the flags cmpxchg when nothing changes (speedup unconfirmed)
: 
: I compared kernels through patches 4 and 5 with a 2 GiB tmpfs file
: mapped by 1, 8, 32 and 64 readers. The file pages were verified on
: the NUMA node being aged. Across alternating A/B/B/A boots and five
: measured passes per reader count per boot, the 64-reader medians were
: 841.8 ms on A and 852.0 ms on B. The 32-reader medians were 425.8 and
: 429.1 ms. This VM did not reproduce the author's speedup; these small
: differences do not establish a material slowdown.
: 
: [6/17] mm/mglru: frequency guided workingset promotion (MGLRU-FG) (series gain)
: 
: In a repeat with QEMU cache=none for both root drives, the skewed
: mmap median was 137.5 seconds on A, 5.21 seconds on B and 139.1
: seconds on a fresh A repeat. Each round began with zero resident test
: pages. A had about 53 million file refaults and 820 million guest
: block-read sectors per round; B had about 0.22 million refaults and
: 5.6 million sectors. The much larger disk activity on A explains the
: slowdown in this constrained workload. This compares the full series,
: not patch 6 alone.
: 
: [7/17] mm/mglru: make folio lru referenced times count a generic API (pass)
: 
: Kernels through patches 6 and 7 each migrated 128 anonymous pages
: between guest NUMA nodes with MGLRU enabled, then repeated with MGLRU
: disabled at runtime. Data remained intact. At the real migration call,
: a temporary test module set the isolated source folio's encoded
: reference count to 4; the destination retained 4 on both kernels.
: The module also copied counts 0 through 7 between off-LRU folios.
: This patch moves the helper without claiming a behavior change.
: Disabling MGLRU at runtime did not test a !CONFIG_LRU_GEN build.
: 
: [8/17] mm/mglru: move add/del LRU size accounting out of lru_gen_update_size() (pass)
: 
: Kernels through patches 7 and 8 passed the cgroup-removal and
: get_user_pages checks. After aging both NUMA nodes, each still
: accounted for about 512 MiB of anonymous memory. The patch moves
: accounting between functions without intending a behavior change;
: these checks found none.
: 
: [9/17] mm/mglru, gup: mark folios referenced via a fast helper (pass)
: 
: vmsplice() reached get_user_pages_fast(), returned the expected 4096
: bytes on both kernels, and showed no material timing difference in
: the repeated 8192-page check.
: 
: [10/17] mm/mglru, smaps: convert to LRU refs based operations for MGLRU (smaps pass; series loss)
: 
: After clear_refs and reaccess, smaps reported 0 KiB referenced on A
: but 2048 KiB on B, as intended. For 400 clear_refs/smaps/reaccess
: cycles on a 128 MiB base-page mapping, A took 1.87 seconds and B
: 2.00 seconds across alternating guests. Most of the difference was
: in clear_refs itself: 0.187 versus 0.300 seconds per 400 calls.
: This slowdown belongs to the full-series comparison; it has not
: been assigned to patch 10 alone.
: 
: [11/17] mm/damon: convert to LRU refs based operations for MGLRU (pass)
: 
: DAMON pageout reclaimed a selected clean 4 KiB file page on both
: kernels; rereading it returned the expected data. A trace on B reached
: folio_reset_lru_refs() in kdamond.0. Comparing kernels through patches
: 10 and 11, an identical temporary source change set the page's MGLRU
: reference count to 2 just before the changed call. A left it at 2; B
: cleared it to 0. The ordinary workload reached that call with count 1,
: so this demonstrates the fix for a forced state, not a user-visible
: failure produced without the temporary change.
: 
: [12/17] mm/khugepaged: convert to LRU refs based operations for MGLRU (pass)
: 
: I compared kernels through patches 11 and 12. Identical temporary
: source changes set isolated folios' MGLRU reference count to 2 at
: khugepaged's referenced-page decision and cleared other positive
: indications. A did not collapse the 2 MiB range; B collapsed it and
: reported 512 referenced pages. The ordinary full-series workload also
: collapsed a huge mapping, but did not reach this even-reference state
: unaided.
: 
: [13/17] mm/madvise: adapt for LRU refs based operations for MGLRU (pass)
: 
: MADV_COLD and MADV_PAGEOUT succeeded and preserved page contents on
: both kernels. Ten-round MADV_RANDOM mmap medians were 5.35 seconds on
: A and 5.26 seconds on B, with no slowdown found.
: 
: [14/17] mm/huge_memory: mark folio as accessed more accurately on split (pass)
: 
: An automatically collapsed 2 MiB anonymous mapping split when the
: protection of one 4 KiB range changed. A shared-memory huge mapping
: also split at its PMD. The split count rose and contents stayed intact
: on both kernels. During the shared-memory split, a trace recorded
: folio_mark_accessed() on B and no such call on A.
: 
: [15/17] mm/mglru: folio LRU refs based active/inactive number accounting (pass)
: 
: With swap disabled, I compared kernels through patches 14 and 15.
: After allocating 512 MiB of untouched anonymous memory, I aged both
: NUMA nodes eight times. On A, the cgroup's active_anon fell from about
: 512 MiB to zero at the first pass; on B the memory was inactive from
: the start. A separate cold mapping gave the same classification
: change without corrupting data. This reproduces one wrong accounting
: result on A and its correction on B; the later oscillation described
: in the changelog was not separately produced.
: 
: [16/17] mm/mglru: make folio_inc_lru_refs lruvec lockless (full-series check passed)
: 
: The full-series KASAN kernel passed the cgroup-removal overlap above.
: A second one-shot, task-scoped mdelay(800) in folio_inc_lru_refs()
: held an old-generation folio's update after sampling max_seq=4 and
: calculating max_gen. Another task aged the file's charge cgroup on
: both NUMA nodes, advancing the sampled sequence to 5. The temporary
: source change set LRU_REF_FORCE after the hold to force promotion;
: the kernel logged its changed-sequence retry from 4 to 5.
: Both readers returned the expected data without a KASAN report or
: warning. These are B-only checks of forced concurrent paths; they
: do not reproduce a failure on A or measure the lockless operation's
: cost in isolation.
: 
: [17/17] mm/mglru: make folio_test_workingset() work based on folio LRU refs (pass)
: 
: A matching test module on kernels through patches 16 and 17 set an
: off-LRU folio's encoded reference counts to 0 through 7. At counts
: 4 and 5, PG_workingset was clear on both. The old helper returned
: false; patch 17 returned true. This reproduces the wrong answer and
: checks the correction for the encoded counts named in the changelog.
: 
: For allocation failures, per-task fail-nth tried positions 1 through
: 32 during huge-page collapse on each KASAN kernel. Only positions 1
: through 3 encountered eligible allocations in one attempt. The first
: two made MADV_COLLAPSE return ENOMEM; the third still allowed collapse.
: Page contents remained correct. The original full-series guests had
: no KASAN report, oops or warning. Uniform-random mmap and GUP-fast
: checks found no repeatable loss in the original runs. Those runs did
: not set cache=none. The later disk-backed A/B/A repeat did so on every
: private QEMU root drive; its mmap results replace the earlier mmap
: timings above. Guest cache residency and block reads were checked.
: Physical media throughput was not measured.
