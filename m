Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438C241BA77;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787585192; cv=none; b=bHO5zs2isrm6BtdqoOyXOMeyXxJ6XetjiKubs4y8LZBKYBUpeJuRsfHgnluKXPsbqabHaVMHFgH8ZMhJWY1DtBGFSPTyEBQ9X7t9DqQhuDeBOWZ21HChSLDkw6Qp5xdCRgnuIkH78e4meT+09y2BnT2GbyOe7sVmiyk6GrRG/7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787585192; c=relaxed/simple;
	bh=h/haknnj8pSvM1JoVwSzP1DECAsXwqNBvWxA9kRJxV0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ilakudCBeJBaHEBgXGICHhWiNHzR7LmiQi2pydyYfV2Q3AJnd7woo2jN5jzI0vYtA8pCEDHRSYQAB8n03CToJAcbC5GCZBsQTWj9oYXdpa4t9Rna4fHiQd2RMnrrpXdR9Nj156siDGzYWK8C8vK8rsk5RbHws9ciEz00/JIL5Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jf5rfTik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jf5rfTik"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C059EC2BCF6;
	Mon, 24 Aug 2026 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787585191;
	bh=h/haknnj8pSvM1JoVwSzP1DECAsXwqNBvWxA9kRJxV0=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Jf5rfTikOx0VrEQU0bgQUo3pujh8B4YWi731mwpPplwS/taKWi75TM6Y2TKXjUcmS
	 CZaMT7fNaSOpQwcw7oCsPDnWUxGZkgiFLCbcUPC77dJuLpMOz7X19arlua8J2B5GMW
	 AOJ6/dhoR0ZwMA10lFfnd0xGKuH0wYCLVjMqEJI0IQXi30n6NRyPkq+lZUBf428eIz
	 aifkyB5AiNnLJoBLY5GhWmQFD+Ur66WjX0nMts43WQIK7z4JzDBCqJjBPi/HJficnk
	 ooOaDTN5TVkFIkfph97cjhBz1i6Vw4dFKYeWAQgL7+IWLVWjGcDfO4oAHNXBm6sjy8
	 1giYRuMAVChew==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985F9C5DF81;
	Mon, 24 Aug 2026 15:26:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v2 0/6] mm/mglru: clean up folio counters and flag usage
Date: Mon, 24 Aug 2026 23:26:27 +0800
Message-Id: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32NQQ6CMBBFr0Jm7ZjSIKmuvAdhUaZTqIFC2kI0h
 LsLuHf5kvffXyFycBzhka0QeHHRjX4HecmAOu1bRmd2BilkKVSucGj7MKPtdRuRetZ+npCouJP
 VprwVFvblFNi691mt6h/HuXkxpSN1GJ2LaQyf83bJD+//w5KjQGWaxmgSRip6JvbEPl1pHKDet
 u0LpB498coAAAA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787585189; l=2302;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=h/haknnj8pSvM1JoVwSzP1DECAsXwqNBvWxA9kRJxV0=;
 b=a4Y23NvntoKAxWeXth0PVBJK9aQsc8tTuri17H2veCuuj+DP1oDuHP9/uIBmNoeGrNBypDJji
 9B/iyN22v/2Bs99/hfZzTq/PeAxTqFSLKyQcHl0lLzR88jeEEb7aKST
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
base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
change-id: 20260818-mglru-flags-cleanup-cc49cfad654f

Best regards,
--  
Kairui Song <kasong@tencent.com>


