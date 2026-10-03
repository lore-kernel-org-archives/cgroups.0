Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54744334CD;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791032119; cv=none; b=B4uiaO3HyIiiDcibIGW2iUa1Zz3cG/XtSY6Lw7d284cB/ZEcne0o5zJYCsOH623ncNary4qclvh0HJj43b4jkUWPtI1xutsXA4HAanRmWGnXKneHwVnNHOMA9L9YT8Eu5z9F7izKLW0ooSoTeuwyl6eZZFoxGmno6+9RqnCISN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791032119; c=relaxed/simple;
	bh=bvlwLo+f3lqZRNSnnjkqTGuXRJFGyVhG1DvB+XQ/2xo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SMOG/yAY/82APg1BBBJ/Awv/DtUtu7fi1g3TJQHWrmJi+jeIpdVjuMhEV8E2FD783LZwlk+AAHbn/w/QWE7BnZJtM8nu6Vnf34l7mxQg/jm6YVdmpZaw/1BWQiOUbrSGkYUA3c0APKkvy1BXplZEiQlYEP7Qqja9Vgj5zeS942A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B9cRjHRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B9cRjHRy"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0C7EC4AF14;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=bvlwLo+f3lqZRNSnnjkqTGuXRJFGyVhG1DvB+XQ/2xo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=B9cRjHRyHOU3qoJSUdEbbcEBzvoia9dCrEg7oQDuSbh3iT0lNSbkcRs/HU/gpufLd
	 pMQaPxmkGd0wvs8GUPnUPdD/6DEMSXJToHAyScEZvUBotnvwA2NK++VHSW0RYXo2Xj
	 NmOfsnSNei0aSlHkfj95ydMS0bn6IHOFw5dDrbhT2IblDTVc16RuC7hDz4yOvW9xy2
	 uVMA/SE7RP25C1lxkzwSP5uLlP42JGc2Ocwui2XA8xp/Sa0Ah9sTMgAq+mw/5q3FhB
	 2o+mw5O7I5krjyOLjfsxBvOJkfaK8rCEXMNesnxL2gj7jZ9m7KJs7rSbzUwhbjLFn0
	 xhmfSvBV3WzVQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC47BCA5FEF;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:28 +0800
Subject: [PATCH RFC v3 17/17] Documentation/mm: multi-gen LRU: update for
 frequency guided promotion
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-17-cbd4546a5bd9@tencent.com>
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=5784;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=j02R/N4wDd5tuvRxCLtAnoFnZEzIETZrPJrk4BlFk8o=;
 b=/e3lLeVO7s3peT3r24x5FdfjgN97h/4EKdHB7aQf+0QVxMnEuyyYTfJbN71sfS9Dyuiaab18M
 b8mL1aI363OAPorcJCWZlpLBOqPofT+fkS2fBgMEQFB4/DYp5vPTz4L
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

From: Kairui Song <kasong@tencent.com>

The design doc still describes the old tier and promotion model:

- Tiers are no longer order_base_2() of the file descriptor accesses.
  A folio's tier is derived from its referenced count, which counts
  accesses from both page tables and file descriptors.

- A young PTE no longer always promotes a folio to the newest
  generation.  The first access only moves a folio out of the oldest
  generation, a second access promotes it, and executable file folios
  are promoted on their first access.

- The eviction no longer uses the first tier as the only baseline.
  The type is selected by comparing all tiers of each type, and a tier
  is protected by comparing it against the tiers below it.

Update the aging and eviction sections accordingly.

Assisted-by: LLM
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 Documentation/mm/multigen_lru.rst | 56 ++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/Documentation/mm/multigen_lru.rst b/Documentation/mm/multigen_lru.rst
index 52ed5092022f..e3dab858887d 100644
--- a/Documentation/mm/multigen_lru.rst
+++ b/Documentation/mm/multigen_lru.rst
@@ -95,16 +95,19 @@ at most ``MAX_NR_GENS`` generations. The gen counter stores a value
 within ``[1, MAX_NR_GENS]`` while a page is on one of
 ``lrugen->folios[]``; otherwise it stores zero.
 
-Each generation is divided into multiple tiers. A page accessed ``N``
-times through file descriptors is in tier ``order_base_2(N)``. Unlike
-generations, tiers do not have dedicated ``lrugen->folios[]``. In
-contrast to moving across generations, which requires the LRU lock,
-moving across tiers only involves atomic operations on
-``folio->flags`` and therefore has a negligible cost. A feedback loop
-modeled after the PID controller monitors refaults over all the tiers
-from anon and file types and decides which tiers from which types to
-evict or protect. The desired effect is to balance refault percentages
-between anon and file types proportional to the swappiness level.
+Each generation is divided into multiple tiers. A page's tier is
+derived from its referenced count, which counts the accesses collected
+from both channels above and is capped at ``LRU_REFS_MAX``: pages
+accessed at most once are in the lowest tier, and the tiers above hold
+pages accessed at least twice. Unlike generations, tiers do not have
+dedicated ``lrugen->folios[]``. In contrast to moving across
+generations, which requires the LRU lock, updating the referenced
+count only involves atomic operations on ``folio->flags`` and
+therefore has a negligible cost. A feedback loop modeled after the PID
+controller monitors refaults over all the tiers from anon and file
+types and decides which tiers from which types to evict or protect.
+The desired effect is to balance refault percentages between anon and
+file types proportional to the swappiness level.
 
 There are two conceptually independent procedures: the aging and the
 eviction. They form a closed-loop system, i.e., the page reclaim.
@@ -122,25 +125,30 @@ and calls ``walk_page_range()`` with each ``mm_struct`` on this list
 to scan PTEs, and after each iteration, it increments ``max_seq``. For
 the latter, when the eviction walks the rmap and finds a young PTE,
 the aging scans the adjacent PTEs. For both, on finding a young PTE,
-the aging clears the accessed bit and updates the gen counter of the
-page mapped by this PTE to ``(max_seq%MAX_NR_GENS)+1``.
+the aging clears the accessed bit and bumps the referenced count of
+the page mapped by this PTE. A second access promotes the page by
+updating its gen counter to ``(max_seq%MAX_NR_GENS)+1``; the first
+access only moves a page out of the oldest generation, so that the
+next time it becomes the oldest one, its accessed bit reflects
+whether it has been used again. Executable file pages are promoted on
+their first access, since reclaiming them causes typical I/O
+thrashing.
 
 Eviction
 --------
 The eviction consumes old generations. Given an ``lruvec``, it
 increments ``min_seq`` when ``lrugen->folios[]`` indexed by
-``min_seq%MAX_NR_GENS`` becomes empty. To select a type and a tier to
-evict from, it first compares ``min_seq[]`` to select the older type.
-If both types are equally old, it selects the one whose first tier has
-a lower refault percentage. The first tier contains single-use
-unmapped clean pages, which are the best bet. The eviction sorts a
-page according to its gen counter if the aging has found this page
-accessed through page tables and updated its gen counter. It also
-moves a page to the next generation, i.e., ``min_seq+1``, if this page
-was accessed multiple times through file descriptors and the feedback
-loop has detected outlying refaults from the tier this page is in. To
-this end, the feedback loop uses the first tier as the baseline, for
-the reason stated earlier.
+``min_seq%MAX_NR_GENS`` becomes empty. To select a type to evict from,
+it first compares ``min_seq[]`` to select the older type. If both
+types are equally old, it compares the refault percentages of all the
+tiers of each type proportional to the swappiness level. To select a
+tier to protect, it compares the refault percentage of each tier
+against that of the tiers below it. The lowest tier contains pages
+accessed at most once, which are the best bet. The eviction sorts a
+page according to its gen counter if the aging or an access has
+updated its gen counter. It also moves a page to the next generation,
+i.e., ``min_seq+1``, if the feedback loop has detected outlying
+refaults from the tier this page is in.
 
 Working set protection
 ----------------------

-- 
2.55.0


