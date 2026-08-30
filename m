Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F02244694;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788115418; cv=none; b=q8HqpsmDbbLyzBS+RkUFnyis2gP0rFVvtbXX5r79sTwH71v2JhS348Wp+rfbwvhlSVtbfqVW6/HL1lkBvhWp4nInr+ca6vxZlO5gm1efCdbwS7Dst7/ha8G5ZOaq3LyLs2dQQUhozVOG27s6c3l5LdApip1xz6QCuJWI9Y89fKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788115418; c=relaxed/simple;
	bh=r8MlvVN1Hrr7nFXT/twKw1mcbQBSoK+7gb7Pqz1TrzU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=KSfMmUR/AMW3+dpimCo/NnQ7gPGU6hfbgltkmxonvKMlBSbpcE0ZNnHB79mVcjXWcPeGzwgJ4iXL/u/OFaMuMBkqhsPtNwADB3lgtl3EzpmrJdx0PQyH1m2TBm9nLEhduZkppUB8Zuv2D2d+Sq/2SeDK5oTZyV/Abwdn0TWlJl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TgJLfl0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TgJLfl0w"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A51C3C2BCC7;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788115417;
	bh=r8MlvVN1Hrr7nFXT/twKw1mcbQBSoK+7gb7Pqz1TrzU=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=TgJLfl0wz14V18Wx5yNmcZ5PnrAtKMHEiuZabADBTR84kMn568rjpEjb0CWTm9w1S
	 SLO3wq4XrDirTVtd+VwgTvfMbcHmOr6376z2QqNHdnbP4YtXOn2kiOQkommp5OJMNv
	 exKhqS0LmhzA4BN+6D4W6U2YOKJ/dqIz4yhd1U7YqNlovHNWMjWJV+glUOT13m5/K3
	 RQtl1gGHX4JUUhe9H6HlaRQ1orAXeq9zOxAQ73w6MIFQqdR2WZKluetLU0H/633LR6
	 d0Jh9Rm9WjdKhKzpvvb6GV6rLW2HGIoV/kj2nf2sF2grWYNHKLbHa9aD/JtGoCbyBc
	 jj741jNX0OjVg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBA6C61DD9;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v4 0/6] mm/mglru: clean up folio counters and flag usage
Date: Mon, 31 Aug 2026 02:43:30 +0800
Message-Id: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33PQQ6CMBAF0KuYrq1pS8HqynsYF2U6hRospgWiM
 dzdghuMxOVP/ryfeZGIwWEkx82LBBxcdK1PQW43BGrtK6TOpEwEEwVTXNFb1YSe2kZXkUKD2vd
 3CiAPYLUpcmlJurwHtO4xq+fLJ8e+vCJ0EzU1ahe7Njzn2YFPvf8LA6eMKlOWRgMzQsGpQw/ou
 x20NzJtDGKhCLmuiKQwziTPBOdS46+SLZViXcmSYg6Wwz7P0+PqWxnH8Q3x40MQVgEAAA==
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
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788115415; l=3114;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=r8MlvVN1Hrr7nFXT/twKw1mcbQBSoK+7gb7Pqz1TrzU=;
 b=qvvnolvYWKShhvmr1tUm9SVdTo6PBNA1ZlhFYB/9rJqU/D1nqXkHACF4VUiZsG7q24kwA1i/q
 AoyKSNXNaiDDBhZ61n6ZzFVKQ+U6TYuP5GRyLpe7fIoC7KeswtgHzkw
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
Changes in v4:
- Rename lru_gen_set_flags/lru_gen_from_flags to
  lru_set_gen_flags/lru_get_gen_flags, similiar with lru refs helpers,
  as suggested by [ Barry Song ].
- Added some comments to cover concerned raised by [ Barry Song ] and [
  Baolin Wang ].
- A little code shuffling and better sanity check for concerns raised by 
  [ Ridong Chen ].
- Collect tags.
- Link to v3: https://patch.msgid.link/20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com

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
 include/linux/mm_inline.h  | 111 ++++++++++++++++++++++++++++++++++++------
 include/linux/mmzone.h     |   3 ++
 mm/folio.c                 |  19 ++++----
 mm/memcontrol.c            |  18 +------
 mm/migrate.c               |   6 +--
 mm/vmscan.c                | 117 +++++++++++++++++++++++----------------------
 7 files changed, 183 insertions(+), 100 deletions(-)
---
base-commit: aeddb4d52acfcc5ce5e988acd48f2906fe966ca3
change-id: 20260818-mglru-flags-cleanup-cc49cfad654f

Best regards,
--  
Kairui Song <kasong@tencent.com>


