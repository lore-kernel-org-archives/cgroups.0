Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E1E41DE15
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 06:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788504762; cv=none; b=hjlFKRUTDTf7MjqAGtRU6EYzoivsB+7/Hlqejn3OGwSGFLjNf8bdHKPI0LFFCCXgl6V26QGQVblQL3B0c3Zf9IQsqom46KPBI/kF8mXFXYgqEReV2KRolZ2fTA6xSRE8WBnX/ztizfEJsLQ2DrUPnSbi2q0NfmOX9WB5cXUl+EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788504762; c=relaxed/simple;
	bh=T6Y/sOiGPvMRfPfHNQRfySVWMf63zFzZFk3cNSODLcs=;
	h=Subject:Date:Content-Type:Mime-Version:Message-Id:To:From:Cc; b=nh+OfFxI256cZWz+AIHLauNSVc/gDOuIX6pEpkm1Fg1uzCMRO+FiEwvrvnm07qSneS1usMeKpnIWP7yKecA8U6LHt84fDOlDtERtROTHcuQJmL+MVf3WxulG2JAaQiVK9PCTJSvNEwdPWgjWsheMD/UDlVlo+XohDYPfJUVwqAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=O6rjfpBa; arc=none smtp.client-ip=209.127.231.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="O6rjfpBa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788504748; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=28SnKEvKoJ3nWwHB2ftkFSyFO3g/G4nEKnDXDivfznM=;
 b=O6rjfpBak0JRuHQ3Q0TsStrZ5DrTED/F43Kw59lqymysp4p3BN9D37Hock/VNXTr6dzr72
 QcYCHW5/nKmaZTU2dNkVlYgv4dfDWdCNO1/jJ8N4ZJBn2Zyd1dw+KqNW2Q+LBkZ83nsjvj
 DgD/Op2O9pQMgQE+8k6BtSCU7qvsS4YtAU12lSzodKvysglQbp1wXvK3odRJI+q3rfHe4T
 bIFkmjqGZHhinSbbZHDakUuW4mrIyZpYtftbgg1fgIiTAxtFInMcuannl4HyXnsizMPR9C
 qgStbSE82nrAPeD4yCFjSK4Z0I0wCgIKR5dnI+e4Ri0YWlTqX8Ev+y0uIilkrw==
Subject: [RFC 0/2] mm: add explicit goals to memcg memory.reclaim
Date: Fri,  4 Sep 2026 14:51:57 +0800
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
Message-Id: <20260904065159.34409-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a9a6aaa+c4c0ab+vger.kernel.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>, 
	<mhocko@suse.com>, <tj@kernel.org>, <hannes@cmpxchg.org>, 
	<shakeel.butt@linux.dev>, <muchun.song@linux.dev>, <qi.zheng@linux.dev>
From: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>

memory.reclaim is used by userspace controllers as a proactive memcg
reclaim interface. On systems without memory tiering, a completed request
is normally interpreted as eviction-oriented progress: pages were freed
and the cgroup's charged footprint can drop.

Memory tiering makes that interpretation ambiguous. The reclaim scanner
may satisfy the requested amount by demoting cold folios from a faster
tier to a slower tier. That is useful aging behavior, but it means a
request can complete even though the cgroup's charged footprint is
unchanged. Userspace controllers that rely on memory.reclaim for actual
cgroup footprint reduction therefore lose the ability to request the same
kind of outcome they get on non-tiered systems.

At the same time, some controllers want the opposite operation: use the
reclaim scanner as a best-effort placement mechanism to move cold folios
from DRAM to CXL or other lower tiers, without evicting them from memory.
This can be used to maintain top-tier headroom or a desired
DRAM/CXL occupancy ratio according to workload policy.

This series keeps the existing behavior as the default, and adds explicit
opt-in goals for userspace controllers that want a more specific outcome
from memcg memory.reclaim:

  echo "1G goal=evict" > memory.reclaim

    Run the normal reclaim scanner and keep demotion enabled as part of
    tier aging, but do not count successful demotion toward completing the
    requested amount. This lets callers ask memory.reclaim to continue
    until eviction progress, rather than demotion-only progress, satisfies
    the request. If the cgroup has no usable demotion target, goal=evict
    falls back to the default goal=progress behavior.

  echo "1G goal=demote" > memory.reclaim

    Use the existing reclaim scanner for best-effort memory tier demotion
    without LRU folio eviction. This is intended for placement control,
    such as maintaining top-tier headroom or a desired DRAM/CXL occupancy
    ratio. Demoted folios remain charged to the cgroup, so this goal does
    not imply memory.current reduction. If the cgroup has no usable
    demotion target, the request fails early with -EAGAIN.

The default remains goal=progress, which is the current memory.reclaim
behavior. In that mode, the kernel's existing reclaim progress accounting
is unchanged and successful demotion can satisfy the requested amount.

Patch 1 preserves the tiered LRU aging model. It changes the completion
accounting for an eviction-oriented request, while still allowing demotion
to happen as an intermediate step. After enough demotion has been done in
a batch, reclaim avoids repeatedly scanning the top tiers in the cgroup's
allowed demotion hierarchy just to produce more demotion-only progress,
while still allowing lower tiers to age or reclaim normally.

Patch 2 constrains a request in the other direction: it allows best-effort
demotion as the requested action, while keeping folios that are not queued
for demotion instead of evicting them from the LRU. It also skips slab
shrinking, because slab reclaim cannot contribute demotion progress and
would otherwise be retried aggressively for an underfilled demotion
request.

This also keeps the ABI scoped to the existing memory.reclaim interface
instead of adding a new cgroup file. The goal key describes what kind of
progress the caller wants from the request; it does not select a source or
target tier, does not provide strict placement guarantees, and remains
subject to cgroup protection, swappiness balancing, reclaim eligibility,
and demotion target availability.

This series is memcg-only. The per-node reclaim interface shares the
parser but has different semantics: node reclaim can legitimately treat
demotion as the desired way to relieve pressure on a node. For that
reason, the new goals are rejected from the per-node path rather than
being given a different meaning there.

Li Zhe (2):
  mm: add goal=evict to memory.reclaim
  mm: add goal=demote to memory.reclaim

 Documentation/admin-guide/cgroup-v2.rst |  26 ++++
 include/linux/memory-tiers.h            |  13 ++
 mm/internal.h                           |   2 +
 mm/memory-tiers.c                       |  35 +++++-
 mm/vmscan.c                             | 154 ++++++++++++++++++++++--
 5 files changed, 219 insertions(+), 11 deletions(-)

-- 
2.20.1
