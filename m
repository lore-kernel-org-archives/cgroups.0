Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4835A364042
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 02:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790129157; cv=none; b=kmF2+Qo6qlp320NkBwEBiGfLWVncPlfoT9e6nt1fy6JRfP2g4c1OR6K1z6Ju5zDmBJZYQeuu5K+RiMyNNpferg70eW7CvkssPOEZSkuz+MRNLys8dwRUKgeW6Gf9hfwTwLK2NAZ+rxPFt+sNBWIOgCRXhCnIuqAxivxSqP+gXCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790129157; c=relaxed/simple;
	bh=Lh2KAWhxN/KUy7SbPIyEGCqRbIP1h0b+ba0VIRohGTs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=q7RSN5QY5Gmg8B/5F1oADRbXS81VvjQvk000Zd0uw4ix8iVRldTxbEtSHlu0ZNpemmne0mRvb5lW+ibWR6W7ccvZv7R1cgp/Pdnn7x1/dBATy4zpLT7w3AfKHo16j/K0l+lg/2BNjRXhtKIfjefPOlyyhnCIjDgMPont45XO0xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nQQrrWPb; arc=none smtp.client-ip=91.218.175.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nQQrrWPb"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Lh2KAWhxN/KUy7SbPIyEGCqRbIP1h0b+ba0VIRohGTs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790129151; v=1; x=1790733951;
 b=nQQrrWPboKTz3yKFJ1BDS/AX5JhakNG1qbKpKUiwGYvNNaI4UG9WpRucx+6sQub9Fr7fG5IT
 alfeMKyIqKA5MRYy8D3UtnWQ0sReZORsgFr+3pE7QHBohpYi1so/d9vai+YuqfNuHP1Vlj4BiNf
 mIimygs7NDFP7bXHJggsjLWA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 3e0c62f87578aba1;
	Wed, 23 Sep 2026 02:05:51 +0000
X-Mizu-Trace-ID: 3e0c62f87578aba1
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Subject: [PATCH v2 0/2] mm: fix hugetlb NR_HUGETLB accounting on folio
 migration
Date: Wed, 23 Sep 2026 10:05:14 +0800
Message-Id: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMSwqDQBBF0a1IjW3QUiPJVkTEz2utIBq62hAQ9
 25rhmdw704KJ1B6RTs5fEVlXQI4jqif2mWEkSGYOOFH8mQ2dnVm2kb4uWvUtx6ZKcrMcslpMeS
 gEH4crPzuaVX/rVv3Ru+vEx3HCZdqEap2AAAA
X-Change-ID: 20260922-for-hugetlb_state3-573f27215d4e
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: hongfu.li@linux.dev, Chris Down <chris@chrisdown.name>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790129144; l=3156;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=Lh2KAWhxN/KUy7SbPIyEGCqRbIP1h0b+ba0VIRohGTs=;
 b=YvOPgCX20y0ccSSoHy0fUm9cg0wU5mkNoQ2pYoGvL4Evn4zDlV5WAToIEiN7MaC94cVVFkqMs
 44lLGpFkrIFAZu91iI7yon669lqbXoigrE5wuglQhL7OyMsBEVVExQq
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=

The hugeTLB counters added by 05d4532b60e3 ("memcg/hugetlb: add hugeTLB
counters to memcg") are maintained in two per-node places:
  - the per-node vmstat counter NR_HUGETLB, exposed as nr_hugetlb in
    /proc/vmstat;
  - the per-node memcg lruvec stat, exposed via memory.numa_stat.

Both are accounted against the folio's node, and both drift when a
hugetlb folio is migrated, though in different ways.

A migration target folio is allocated by alloc_hugetlb_folio_nodemask()
and inherits the old folio's state without ever being accounted, while
the old folio is freed right after and its free is accounted. That
alone loses vmstat accounting: the target node has no matching increment
for the decrement on the old node, so /proc/vmstat's nr_hugetlb shrinks
by nr_pages per migration. Patch 1 accounts the folio where it is
obtained, so the increment pairs with the free in free_huge_folio() on
the successful as well as the failed migration path. The memfd page
cache preallocation helper has the same asymmetry and is fixed in the
same patch.

The per-node lruvec stat breaks differently. mem_cgroup_migrate()
moves the charge to the new folio and drops the old folio's memcg data,
so the old folio's free right after migration skips the memcg per-node
decrement; the count stays attributed to the old node for the rest of
the charge's life, and the target folio never gets an increment on its
new node. Patch 2 moves that per-node accounting along with the charge,
in move_hugetlb_state().

---
Changes in v2:
- In patch 2/2, move_hugetlb_lruvec_stat() no longer takes the objcg
  parameter; it takes the memcg from the new folio and uses guard(rcu)().
- In patch 2/2, move_hugetlb_lruvec_stat() is moved to mm/hugetlb.c and is
  now called from move_hugetlb_state() instead of mem_cgroup_migrate().
- In patch 2/2, make mod_memcg_lruvec_state() non-static (declared in
  include/linux/memcontrol.h).
- Collected tags on both patches.

To: Muchun Song <muchun.song@linux.dev>
To: Oscar Salvador <osalvador@suse.de>
To: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: Chris Down <chris@chrisdown.name>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
To: Michal Hocko <mhocko@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: hongfu.li@linux.dev
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: cgroups@vger.kernel.org

---
Hongfu Li (2):
      mm/hugetlb: account migration target folio in per-node NR_HUGETLB vmstat
      mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio

 include/linux/memcontrol.h |  8 +++++++
 mm/hugetlb.c               | 60 ++++++++++++++++++++++++++++++++++++----------
 mm/memcontrol.c            |  5 ++--
 3 files changed, 58 insertions(+), 15 deletions(-)
---
base-commit: 8d29b5365d528da545c1fe0768a55babadee95d0
change-id: 20260922-for-hugetlb_state3-573f27215d4e

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>

