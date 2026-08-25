Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D4448CD4B;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787680419; cv=none; b=XdNqNJHDWI+kJfhWbJlKfmLHOCep3an1JQ976K2uF7ezq/ApOCcETgNq4u+6tFn4sY7LHApMyswl0ZWqiJM2FKiaRl0gLbZkYy4C4EIzVleyRD2ol3+rc/zr54nkjN7VstI0P80MFVIK0ufCeLwuwGXCJyuzNd+4kTkEAmFjC3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787680419; c=relaxed/simple;
	bh=yGhBrxPFg7q4A7at7HAzLQQYUvr4U8KOXRLVnzUgTB4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=GNelFOID5W5glP5auEX0NdY8C6ft9QlDsdOTbP4Ua87UfQadGWDS3sRvd6q/QHrGnOW0HHFES8I6y0gTSZ/DQLCsNIxGTUYRuGAE/vZmiLox1w4BNyZ4Dlr0hSutwbxpNhnRpWvk4ifErnOGI2bJf01rbtRHjy9ZCBVru1XCxDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZlZINKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZlZINKj"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CFE6C2BCF4;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787680418;
	bh=yGhBrxPFg7q4A7at7HAzLQQYUvr4U8KOXRLVnzUgTB4=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=jZlZINKjJEQcQaaLf//L+XieljpgjnSINNQSXjq30GzY7JB0gPjt+U4tcFvI81scF
	 XiYFwhJVEZDm8DHbrC5ve0ZgFeGSekpilv9yUQvcpDNMjloftmX+Jy/1zi6uzotHDy
	 QLFW8Qq6xAg/QgDyCO2Ofylgiq7hAYcy/4/80GIBzqfCpEwERfNawQmnODTI6YvPT8
	 CgqY/TVICG0IfGxYslQ/0nOdtj7eSowV22JoLQpDFPPLCKTbxmPfE5HanJO5xmKSxB
	 T/TYrOuUFJOH7KPggmPx5Loq9ho0B8COWRVYu2xoYd64QSBS9VYl+ufU03MdZADcnc
	 bZaBCQCrbex/w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6587CC61DB9;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v3 0/6] mm/mglru: clean up folio counters and flag usage
Date: Wed, 26 Aug 2026 01:53:33 +0800
Message-Id: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NQQ7CIBQFr9KwFgMUm+rKexgX9PNpMZU2QBtN0
 7sLdaOJcTnJezMLCegtBnIqFuJxtsEOLkG5Kwh0yrVIrU5MBBMVq3lN723vJ2p61QYKPSo3jRR
 AHsEoXR2kIek5ejT2sVkv1zeHqbkhxKzKi86GOPjnlp153v0vzJwyWuum0QqYFjWcIzpAF/cw3
 EluzOLDIuRvi0gWxpnkpeBcKvy2rOv6AqPmaGYQAQAA
X-Change-ID: 20260818-mglru-flags-cleanup-cc49cfad654f
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Kairui Song <ryncsn@gmail.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787680416; l=2634;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=yGhBrxPFg7q4A7at7HAzLQQYUvr4U8KOXRLVnzUgTB4=;
 b=sHCVoCfyGamTgCWDX0xKsxNkLAKq3PcT7NYv721IP+dfR3tZSevLxl3Y8/geemFKddnMjWJjc
 TW7eb9p1+pPAR/L8wR2YLl/uXR34CYl/yr4USTabnbrTUwIfD2WQ2rF
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

This is a cleanup series separated out from the MGLRU-FG series [1]. As
that series is getting too long in following updates, seperate out the
clean up part for easier review and merge.

No feature change is intended, except one bugfix. It mostly replaces
the open-coded bit operations scattered throughout the MGLRU code with
new helpers, with proper kdocs, sanity debug checks, and hardens a few
MGLRU functions.

A subtle generation counter leak is also found during the refactoring
and the fix is included.

Also collected review feedbacks on the cleanup part from the posted
series.

Link: https://lore.kernel.org/linux-mm/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v3:
- Set PG_workingset before setting LRU refs bit to avoid any potential
  under report of folio tier.
- Migrate folio's referenced status before PG_update so lockless readers
  won't set stale referenced status.
- Link to v2: https://patch.msgid.link/20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com

Changes in v2:
- Dropped the redundant LRU_GEN_MAX macro.
- Renamed folio_migrate_refs() to folio_migrate_lru_refs() and reworded
  its commit message to describe the referenced state being transferred.
- Rewrote patch 6's commit message with a detailed analysis of the
  anon/file accounting race.
- Dropped patch 7, it doesn't really fix anything, and might be in
  conflict with other updating series.
- Collected Reviewed-by tags.
- Link to v1: https://patch.msgid.link/20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com

---
Kairui Song (6):
      mm/memcontrol: make lru_zone_size atomic and simplify sanity check
      mm/mglru: introduce helpers for manipulating gen and refs flags
      mm/migrate: copy all referenced state via folio_migrate_lru_refs
      mm/mglru: move max_seq read into walk_update_folio
      mm/mglru: use explicit tier range in read_ctrl_pos()
      mm/mglru: fix potential generation folio number leak

 include/linux/memcontrol.h |   9 +++-
 include/linux/mm_inline.h  | 103 +++++++++++++++++++++++++++++++++------
 include/linux/mmzone.h     |   3 ++
 mm/folio.c                 |  19 ++++----
 mm/memcontrol.c            |  18 +------
 mm/migrate.c               |   6 +--
 mm/vmscan.c                | 117 +++++++++++++++++++++++----------------------
 7 files changed, 175 insertions(+), 100 deletions(-)
---
base-commit: 169393fff5d1ec2690934067eeb95544ff5ebdd7
change-id: 20260818-mglru-flags-cleanup-cc49cfad654f

Best regards,
--  
Kairui Song <kasong@tencent.com>


