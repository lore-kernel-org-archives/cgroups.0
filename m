Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0BA45C711
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 09:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981986; cv=none; b=JgTuW66nUMUP9KJT8fcg6wU3N2My7LEK1yBMsosD2J1410cjDOVZAfDawCDJG9DkewCmlFeZL+nteY8x6MCJ5izvVkGaqVjKiidoq6i6UWz2x4a3XqQLACf352Do27uNPDWP5JvNMiv4hacI8l+/vucBctBPfYK9txEuXIKyw1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981986; c=relaxed/simple;
	bh=TDH3vD9yd/dcLeLc/jAleyN9Qqat0NKvlnxsmihr/nM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=IbU3KSDKPj/EpBQaR6j1yVTZQmh5GjgrBra4CwaF4+1MGdmZcdgle+E0DM5MSD7/Mx979LJcyuxeR+IuEfvNPc4D/8j42jxg1QBHe+Z906+87qaKu7dHq4vDowe/xq0mhlAJzPgiNjS+lelyNozLh7cpQWgVmXs13dvJ7ITIQrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h1CwbFmm; arc=none smtp.client-ip=91.218.175.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h1CwbFmm"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TDH3vD9yd/dcLeLc/jAleyN9Qqat0NKvlnxsmihr/nM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789981982; v=1; x=1790586782;
 b=h1CwbFmmpll9Q7aI6HpACAo7/eqEd5FKAV6XZ7oS+IMPr2B/1EcGG7pKtz1QyGViCaFufY02
 TDARzFETiVuov/zV4x50qJzRSr7l3LTqFwZ1JBDNT2rppo8yFrYztpQpB8xGEOE8N3foPl68cro
 htpI9UGhPNjKAJZ+0vMngRHc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2b44032c6d1bb854;
	Mon, 21 Sep 2026 09:13:02 +0000
X-Mizu-Trace-ID: 2b44032c6d1bb854
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Subject: [PATCH 0/2] mm: fix hugetlb NR_HUGETLB accounting on folio
 migration
Date: Mon, 21 Sep 2026 17:12:33 +0800
Message-Id: <20260921-for-hugetlb_state-v1-0-8a6eec92661f@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBG4avIrA04CqntVYqIib86pWjJRBHEu
 5u2y2/x3kGKIFB6ZAcFbKKyzAmcZ+Snbh5hpE+msihtcWdrhiWYaR0R367V2EUY2BvXFXt2rqb
 UfQIG2X/PZ/O3ru4FH78jOs8LfbIOGnUAAAA=
X-Change-ID: 20260916-for-hugetlb_state-e671831c1bb8
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Chris Down <chris@chrisdown.name>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>
Cc: hongfu.li@linux.dev, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789981974; l=2043;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=TDH3vD9yd/dcLeLc/jAleyN9Qqat0NKvlnxsmihr/nM=;
 b=5SGaDRkirvqoNfdMgtlmPP3KU7kwjMhLUgb1e9QeRVHp4qxVn0rMhMIy01kpGfZMAOiVKtDaM
 UQcucSy2UbUDTzf5P+f6znaJUZyoTauMnD0nLr015Eh7OBzV75pTBiG
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
new node. Patch 2 moves that per-node accounting alongside the charge
in mem_cgroup_migrate().

---
Hongfu Li (2):
      mm/hugetlb: account migration target folio in per-node NR_HUGETLB vmstat
      mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio

 mm/hugetlb.c    | 35 +++++++++++++++++++++++------------
 mm/memcontrol.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 12 deletions(-)
---
base-commit: b08a65b93426d86e3f354d655d6225397b591877
change-id: 20260916-for-hugetlb_state-e671831c1bb8

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>

