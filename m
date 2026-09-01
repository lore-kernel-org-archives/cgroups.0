Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA5846EF94;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788253097; cv=none; b=H3e3p1CYeqJL5Eo2rvFfz/gVUbqw5sXy0un8xjAOW77/6NWySLhystgxJhKILS7RdNRLan0psHm7LfgHYV4j01iy7+tfKGO0jSNsRn8Hou0GtCpInqCeid6nvjd54/OC9cIp35FlovODIPc1GNDL3P00wRnYxok+TlMhPdDv8V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788253097; c=relaxed/simple;
	bh=2rsNpbbKndbyocdYHBqGvoSTRhCZGAVV39aajeiQvbw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=dq6d+ag+MwoUEKctd1kZYBe/IQRsb7gXzMeWHuJ8fJRiyXmWG9fzjFAemRBJVfc6XIa1Iire0p+4sQbf+Z3uHYuYSvW38gJrARjYE4HL3Cyj0ZY5Plq3OgEtVPTsypQJSG0JYfA9cLQ+dARUTHL3X/TDxdtiQFomjm9TmsaMzyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kRCDP9kR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kRCDP9kR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6801C2BCF4;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788253096;
	bh=2rsNpbbKndbyocdYHBqGvoSTRhCZGAVV39aajeiQvbw=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=kRCDP9kRglnPQjyJSzcjD4Abzpt2HdWFARfsP7NYOJvQKKtr5fswRRJjnxHfiF6wy
	 gsPJRleHQdLRUIE7ZNGRH03IN/HReQQ5pG89j46UBJC260PPX5gIGZyEH2ylX0S06U
	 Y9//vQqqc+Cl5ROtPFzvW12eXNSJgqy/EHZXh2jEbEJ5uDZ72VZnZ25r7jyNOQqGNX
	 d4A/+MSH+2BuqjL09iBrFAZGDITjX5blBvXJnwCAMJCKlxGv9Qgpmon0tqZup1Usn/
	 EuKpyXd1KNiGvMLYUFviX+aJYITSMdDZ+4dnFHzFZsXjwutIv65hGTPepWREHP0xVH
	 TBYTpPCGqMUrw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33A5C61DD6;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Subject: [PATCH RFC v2 0/6] mm/memcg: move memcgid refcount to objcg to
 unpin dying memcgs
Date: Tue, 01 Sep 2026 16:57:59 +0800
Message-Id: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJeTlmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIzMDCyNz3aTMvPQ0oER6ab5ubmpucnpmim5Ranl+UbaupbFFqpFpanJiUqK
 REtCAgqLUtMwKsOHRSkFuzkqxtbUA5Vvo4HEAAAA=
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788253095; l=3096;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=2rsNpbbKndbyocdYHBqGvoSTRhCZGAVV39aajeiQvbw=;
 b=niyCOO6I31iqWLWbba9BN/RcyJmA4XUdfG73eXvhi2yvhf4G3il5zEqKw7xURsTT+nbknaOgH
 SEQtesn+OCHCSrV8AwoIdhtMQMgrZm5lhO4im7A0OvH0B6Hj8Ev/k12
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com

Although the dying memcg problem caused by LRU pages is fixed, I can
still see the issue on some workloads that use shmem after those pages
are swapped out.  This series binds the memcgid refcount to objcgs so
dying memcgs can be freed normally in this case.

The memcg private ID identifies memcgs for objects that can outlive the
cgroup itself: swap entries and workingset shadows.  Today the ID's
refcount is embedded in the css, and every outstanding ID reference
(mostly swap entries) pins the css, keeping the entire memcg alive,
which brings a problem: A swapped-out page holds a memcgid reference
that pins the css, so the memcg cannot be freed until the page is
swapped back in and charged back to its online parent.

The work done by Muchun Song and Qi Zheng already charges folios to the
objcg, which is reparented to its parent when the memcg offlines.  This
series applies similar idea to the memcg private ID: the ID's refcount
moves from the css into the objcg, and the memcgid xarray holds a
reference to an objcg instead of pinning the css.  When the memcg
offlines, the objcg is reparented and any remaining memcgid references
resolve to the ancestor, so swapped-out pages no longer pin the dying
memcg and get the online parent naturally on swapin.

Patches 1-4 are self-contained preparatory cleanups:
  - add a helper to drop the online-state reference on offlining
  - take the memcgid reference only after swap charging succeeds
  - make mem_cgroup_private_id_put() take the ID instead of the memcg
  - return the memcg from mem_cgroup_private_id_put() for uncharging

Patch 5 actually moves the refcount to objcgs, and patch 6 makes the
remaining callers (list_lru, workingset) to filter out memcgs that have
already been reparented.

Changes in v2:
- Rework the logic to try to keep changes small.
- Change order of the commits to make it cleaner.
- Fix problems reported by sashiko.
- Reparent to mm-unstable.

RFC v1 contains some scripts and codes for reproducing the problem and
testing the fix:

https://lore.kernel.org/linux-mm/20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com/T/#m0e8ce07568e16239ba113c803f27caf308b299e7

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
Bingfang Guo (6):
      mm/memcg: add a helper to kill the memcgid on offlining
      mm/memcg: get memcgid reference only after swap charging success
      mm/memcg: pass the id itself instead of memcg for putting ID
      mm/memcg: return the memcg when putting memcgid
      mm/memcg: move memcg private ID refcount to objcg
      mm/memcg: filter out reparented memcgs got from memcgid

 include/linux/memcontrol.h |  15 +++---
 mm/list_lru.c              |   2 +-
 mm/memcontrol.c            | 117 +++++++++++++++++++++++++++++++++++----------
 mm/workingset.c            |   2 +-
 4 files changed, 100 insertions(+), 36 deletions(-)
---
base-commit: 88297631d4d42f6004cb39c0ba3da7d2d10a616f
change-id: 20260827-bingfangguo-memcgid-rework-938e25ecaba2

Best regards,
-- 
Bingfang Guo <bingfangguo@tencent.com>


