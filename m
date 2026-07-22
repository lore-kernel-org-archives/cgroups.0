Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26732403AEC;
	Wed, 22 Jul 2026 23:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763680; cv=none; b=XZed4UfjS29gBDotwYqlvLQdDKNy/iTCho1E6DsImXCaLtB2VriTSvW+MXEc7Ur5RFSzKyx2KW0FOPN0Fql+6w87UJrXlByF0dzm57rgwlH9BG4ld1N7DG8pFnTEumLEXgxGUexhVxlAtprO8L48mEAVMMxVqNl5/RLy7dN0rqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763680; c=relaxed/simple;
	bh=NeJlLVVMf++c5nZhAc/KqZ/hq04Bz1Dk6297RE4toKs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=kib5jXwdj8rL2gb9F/57nPtocDUKhoYPAqh5h6n6W1dn4LlfC9ADtSX2hE2U/87x/Ku2+h1PcmqMgWxf/swgnFJpJ34+Xf2Zv0LY5Ehl4XWqbS2DTCTSTuD6MNcOJ8VwwxmUDi8bbGMVDo3Rx6Hqp9YDMQwofaDQ1plhfDEjtA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Trr2vdLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Trr2vdLh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A482DC19425;
	Wed, 22 Jul 2026 23:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763679;
	bh=NeJlLVVMf++c5nZhAc/KqZ/hq04Bz1Dk6297RE4toKs=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Trr2vdLhCdMV6FlD3ih3cgioCpipymobS5BR0iPYq8TOcB9z5cYLm/nNE0q05gzl6
	 jr45Wrb4Y9vCeLPaK7K2EGGMOwz1QsmLJNclQrA01YgfQX6ArjMZLArd/4+5ngNHmh
	 xHZisHt0xQLW7YKXsLAYq2+5LeJxZCz3t4ASwnQTzGcSee3UlkDVnCIs7pC5FQkeX9
	 9RsFPrCA9R7rMfZdYr1NlPeJpKXpypOFUySNGn7Xn7v0pxblChLh+o8D+NKBbchdh2
	 cGDoCDKWHl3OzUqzhVJdaxLnDPDvTHDo3/7uBG2CbxU42duCQeP13SQnS4KpGD3P9E
	 jCFS5eBprIj8Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC53C44532;
	Wed, 22 Jul 2026 23:41:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH v4 00/16] Fix bugs on HugeTLB folio allocation failure
 paths
Date: Wed, 22 Jul 2026 16:41:08 -0700
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABRVYWoC/33OwQqDMAyA4VeRntdRo7a6095j7NDWqIXOjlZlQ
 3z3VWHgGHj8E/iSmQT0BgO5JDPxOJlgXB8jPyVEd7JvkZo6NgEGnAnGaTe2OFhFpbVO00YaO3q
 kjXlhoFo0QhSoJVQNicLT47aIwO0euzNhcP69HZvSdfp1xaE7pZTRQqk6k7kqM15fW+dai2ftH
 mSFJ9hj5TEGEYufgtBK5RzUH5btMGDHWBYxUYNMeSVlhfiDLcvyAdjqG2xhAQAA
X-Change-ID: 20260706-hugetlb-alloc-failure-fixes-c7f775eca29f
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=8919;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=NeJlLVVMf++c5nZhAc/KqZ/hq04Bz1Dk6297RE4toKs=;
 b=7dRun2bww5d+94a6EUgKYhDHc0fhMbujyDJkpXqg7z757v09Akq7Esh/Vj/YQiD6CGXdvf1h9
 xn81To5pmSFBRP4n2Z4ZP3HY4t6A6qzSay8cWFJ6jYdnwkqejhXLXbr
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com

This series fixes a few bugs on HugeTLB folio allocation failure paths.

Some of these issues were pointed out by Sashiko while I was working on
[1], and others were revealed while fixing the original issues.

1. subpool usage leak on allocation failure (Sashiko pointed this out
   in [2])

   When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
   hugetlb cgroup charging failure) and gbl_chg == 1, the error path skips
   restoring the page to the subpool, leaking the subpool's used_hpages
   counter. Fix this by calling hugepage_subpool_put_pages()
   unconditionally if map_chg is true.

2. Folio refcount mismatch on memcg charge failure leading to
   VM_BUG_ON_FOLIO() (Sashiko pointed this out in [3])

   The error path in alloc_hugetlb_folio() calls free_huge_folio() directly
   on a folio with a refcount of 1 (set via folio_ref_unfreeze() earlier).
   This triggers VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) if
   CONFIG_DEBUG_VM is enabled, and can corrupt allocator state otherwise.
   Fix this by using folio_put() instead of free_huge_folio() to correctly
   drop the refcount before freeing.

3. Returning -ENOMEM on memcg charge failure causes infinite loop

   alloc_hugetlb_folio() propagates -ENOMEM on charge failure, which maps
   to VM_FAULT_OOM. Because HugeTLB physical allocations are high-order and
   use __GFP_RETRY_MAYFAIL, the OOM killer is bypassed. Returning
   VM_FAULT_OOM leaks to the #PF handler, which cannot make progress and
   retries the faulting instruction indefinitely. Fix this by returning
   -ENOSPC instead of -ENOMEM on charge failure, which maps to
   VM_FAULT_SIGBUS, terminating the process cleanly.

4. vma reservation leak on mem_cgroup_charge_hugetlb() failure

   When mem_cgroup_charge_hugetlb() fails, the error path historically
   bypassed vma_end_reservation(). Since the reservation had already been
   committed via vma_commit_reservation(), this left the reservation map in
   an inconsistent state, leaking resv_huge_pages when the process
   exited. Fix this by moving mem_cgroup_charge_hugetlb() earlier in
   alloc_hugetlb_folio(), before vma_commit_reservation() is called.

Cleaned up patches, updated documentation, and fixed Sashiko's comments on
v3:

1. subpool cleanup in alloc_hugetlb_folio() was incomplete - I folded the
   fix in.
2. More issues (UAF, and another accounting issue) reported [5] - I added
   two more patches.

Keeping this section since I think people didn't have much time to review
v3.

1. subpool page tracking

The subpool now tracks every page allocated via
the subpool through used_hpages, regardless of whether min_hpages or
max_hpages is requested by the user.

When min_hpages is set, rsv_hpages is initialized to be equal to
min_hpages. As reserved pages are used, the count is transferred from
rsv_hpages to used_hpages. When reserved pages run out, as long as
max_hpages is not requested or not yet met, used_hpages continues to be
incremented. The following invariant holds true while used_hpages <=
min_hpages:

  used_hpages + rsv_hpages = min_hpages

when used_hpages exceeds min_hpages, rsv_hpages must always be 0.

With this, pages can and must always be returned to the subpool if there's
some reservation or allocation failure after getting a page from the
subpool. One thing I missed in v2 was in processing the returned page. In
v2, the number of pages returned was compared to min_hpages, ignoring
used_hpages if it exists. v3 limits the number of pages returned to
min_hpages - used_hpages, upholding the invariant above.

2. (Re-)introduction of the try-commit-cancel protocol for memcg charging.

In v2, I took the shortcut where I moved mem_cgroup_charge_hugetlb() up
above committing vma reservations, and jumped to subpool cleanup when the
charging failed. With that, Sashiko pointed out that there are still issues
with subpool tracking.

In [4] I thought the issue was that gbl_chg == 0 (I flipped the condition
in [4], omg) doesn't always mean a reservation was actually used, but after
digging more, that doesn't seem to be true, since if gbl_chg == 0,
restore_reserve is set on the folio, and free_huge_folio() would have done
a h->resv_huge_pages++.

In my opinion, calling free_huge_folio() in the middle of the cleanup does
too much, and I think the cleaner approach would be to do all the charging
symmetrically, so that the subpool cleanup will also be symmetric
and (hopefully) easier to understand.

+ I would like reviews on all the non-WIP patches. Those are the ones that
  I'd like merged first.
+ There are reproducers (not meant to be merged) to help prove
  effectiveness of fixes.
+ There are WIP patches for subpool-related refactoring. Those helped me
  check that the subpool stuff is working and is posted to show how it
  works. I think the subpool-related refactoring and tests would be good to
  merge, but perhaps in another patch series? The refactoring was heavily
  AI-driven and should be considered RFC. Would like to have your feedback
  on that refactoring too.

+ libhugetlbfs tests pass
+ ./tools/testing/selftests/mm/ksft_hugetlb.sh passes
+ Reproducers all pass

v1: https://lore.kernel.org/r/20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com
v2: https://lore.kernel.org/r/20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com
v3: https://lore.kernel.org/r/20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com

The series [1] has some changes that are dependent on these fixes, so I'll wait
for your reviews before continuing on [1].

Thank you!

[1] https://lore.kernel.org/all/20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com/T/
[2] https://sashiko.dev/#/patchset/20260518-hugetlb-open-up-v3-0-e14b302477f8%40google.com?part=5
[3] https://sashiko.dev/#/patchset/20260702-hugetlb-open-up-v4-0-d53cefcccf34%40google.com?part=6
[4] https://lore.kernel.org/all/CAEvNRgGN0HSJ2iLSDD2haSKOxifa-uhkO9Hwossh0+Q_d9fzOw@mail.gmail.com/
[5] https://sashiko.dev/#/patchset/20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee%40google.com?part=8

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (16):
      mm: hugetlb: Track used_hpages when getting/putting pages from subpool
      mm: hugetlb: Return -ENOSPC on memcg charge failure
      mm: hugetlb: Use try-commit-cancel protocol for memcg charge of folios
      mm: hugetlb: Remove unused mem_cgroup_charge_hugetlb function
      mm: hugetlb: Fix subpool usage leak on allocation failure
      mm: hugetlb: Rename local variables for clarity in hugetlb_reserve_pages()
      mm: hugetlb: Fix Use-After-Free in unlock_or_release_subpool()
      fs: hugetlbfs: Fix global reservation leak in hugetlbfs_fill_super()
      WIP: mm: hugetlb: Move subpool functions to hugetlb_subpool.c
      WIP: fs: hugetlbfs: Refactor subpool getters and integrate with hugetlb_subpool API
      WIP: mm: hugetlb: Make struct hugepage_subpool private to hugetlb_subpool.c
      WIP: tools: testing: Add unit tests for HugeTLB subpool functions
      WIP: Reproducer for allocation failure due to cgroup v2 memory limits
      WIP: Reproducer for subpool usage leak
      WIP: Reproducer for false restoration on shared HugeTLB mappings
      WIP: Reproducer for out_put_pages subpool reserve leakage

 Documentation/mm/hugetlbfs_reserv.rst              |  17 +-
 .../translations/zh_CN/mm/hugetlbfs_reserv.rst     |  11 +-
 cgroup_v2_allocation_failure.c                     | 169 +++++++++
 fs/hugetlbfs/inode.c                               |  31 +-
 hugetlb_reserve_pages_out_put_pages.c              |  49 +++
 hugetlb_reserve_pages_out_put_pages.sh             | 153 ++++++++
 include/linux/hugetlb.h                            |  17 +-
 include/linux/memcontrol.h                         |  30 +-
 mm/Makefile                                        |   2 +-
 mm/hugetlb.c                                       | 260 +++-----------
 mm/hugetlb_subpool.c                               | 230 ++++++++++++
 mm/hugetlb_subpool.h                               |  21 ++
 mm/memcontrol.c                                    | 116 +++++-
 subpool_leak_max_size.sh                           |  72 ++++
 subpool_shared_leak.c                              |  43 +++
 subpool_shared_leak.sh                             |  87 +++++
 tools/testing/hugetlb_subpool/.gitignore           |   1 +
 tools/testing/hugetlb_subpool/Makefile             |  18 +
 tools/testing/hugetlb_subpool/test_subpool.c       | 400 +++++++++++++++++++++
 19 files changed, 1445 insertions(+), 282 deletions(-)
---
base-commit: 4539944e515183668109bdf4d0c3d7d228383d88
change-id: 20260706-hugetlb-alloc-failure-fixes-c7f775eca29f

Best regards,
--
Ackerley Tng <ackerleytng@google.com>


