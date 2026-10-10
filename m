Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59F536F8F2
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 21:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791666633; cv=none; b=uDFC4GDfyOoK+gdThUAkpqsOaGo6zoWkYyPSUiII0KnAQGopAsnNci4swnnFrfkn3wWahJrAe76SN/+SxSm0h+Fsj8cGqis73MHXrNdF8tPNicCsRW6fIDzYS32BesZhzYk/2Eto8/ap1nzUFrndeasJYiTUDEimUO0jL0/BbCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791666633; c=relaxed/simple;
	bh=K4VhJxKnrOb5JULTRJwVmPmQZaODKrai9O1wrnPYCE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tq8qiPROg8POCnlqKu/IJKuADdCCb4nk9QJnfR+XNE/Lb+qWJfocKaCPrEy8p1VT5xhIyMGxQe1CAcznqWbxZe2LR+R0bm5G4peVUjEux7dgWCqFVpRDUmcjrSBBNZyppMd13HIQzsgcJ9MborBW3pwOPiUP2gA7yxUh1kOmKf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KS7OyI/Q; arc=none smtp.client-ip=95.215.58.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KS7OyI/Q"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=K4VhJxKnrOb5JULTRJwVmPmQZaODKrai9O1wrnPYCE0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791666629; v=1; x=1792271429;
 b=KS7OyI/QiwHPJLu/LUwVrDl6Ey7PH1uBA2Q9RXEHgh9MAmLjQItfSy+ETIMisXJIU72sdDty
 QRZODZzTkiSVb3qOsHbBsQYBu5lM3h1+oKQeGD0B4Uh8wQv0hRHaiQd/W3Cmnr8MuNgDYWWlBqJ
 qKpa3TnSeTZnbFIC13ivWuUM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dc4302c868f365d5;
	Sat, 10 Oct 2026 21:10:29 +0000
X-Mizu-Trace-ID: dc4302c868f365d5
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Date: Sat, 10 Oct 2026 14:09:56 -0700
Message-ID: <20261010210957.1350874-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261010210957.1350874-1-shakeel.butt@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel threads and remote chargers use high_work when memory.high is
exceeded. Their allocations during reclaim can also charge memory,
for example when zswap stores a page.

Without a check, the high_work worker can queue itself from its own
reclaim. The pending bit is cleared before high_work runs, so each run
can queue another run.

Skip memory.high enforcement for charges from task context with
PF_MEMALLOC set when they would use high_work. This covers kernel
threads and remote charges. The memory is still charged. Interrupt
charges keep their current path.

In a VM with incompressible zswap data, the worker queued itself 163 times
without this check.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3456960cbe68..d1e022e6572f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2708,6 +2708,14 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
 		!current->mm || !mm_match_cgroup(current->mm, memcg);
 
+	/*
+	 * Reclaim can charge memory, for example when zswap stores a page.
+	 * Don't queue high_work from a reclaiming task, or the
+	 * high_work worker could keep queuing itself.
+	 */
+	if (in_task() && use_worker && (current->flags & PF_MEMALLOC))
+		return;
+
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
-- 
2.53.0-Meta

