Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033103749FB
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 21:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791666628; cv=none; b=VyHDpPkQBvX0w8OxXvpmOQ2WWlzZRYcv4OuxucIEReTVQhJAjMwFCWzOQVGvwAQ3bmiKOrBjFp853o1RxPe50efYSu2Z50+PNhVQFSJztsnLBwua9D+F8qY16VcxSiqFdBlJXDjNhjvavHviOkDBz/iITmsLMrsmdn63lLUl05I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791666628; c=relaxed/simple;
	bh=Ly0XDKz5aJx09UruibyzcA0mahI1HK/w5v/NpW9zEKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7NlE6BDkb1jIDVZEzvRjkTlphAv6FqzJvW+L5dnRFEKs8RP91IK7NnK2QcLiNq6cFdGYXXRnpQEVL36rNbmbuWKjxIHO+eu2xz3TBMla92HywmH2SeOsNQCGCyUdHJ4ntLUdNWxifPOW7K/GAsHR0np60JRUphbIIkMoSpjjR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SAllbrch; arc=none smtp.client-ip=91.218.175.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SAllbrch"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Ly0XDKz5aJx09UruibyzcA0mahI1HK/w5v/NpW9zEKk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791666624; v=1; x=1792271424;
 b=SAllbrch+JRv3seZFDZCGjm7gng8nzNsfCMbJPFNCv2ZMFB8XzH2R/d02QPdza1LJrklkA/5
 UHx/ZFLR37N63Fd9unAM9DC62RrEqAQm0DPVwH4PrwQtUpmyHpAQDdXjst3InSW2cgQ9qNA4ZJn
 I/r6wlTRopm2F6qufCiSgjJE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id db4aa6a7d8b211f2;
	Sat, 10 Oct 2026 21:10:23 +0000
X-Mizu-Trace-ID: db4aa6a7d8b211f2
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
Subject: [PATCH for-7.5 2/5] memcg: use high_work for kernel threads
Date: Sat, 10 Oct 2026 14:09:54 -0700
Message-ID: <20261010210957.1350874-3-shakeel.butt@linux.dev>
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

Kernel threads never return to userspace, so deferred memory.high
reclaim does not run. Reclaim and throttling during a charge can also
delay work they do for other tasks.

Treat kernel threads like interrupts. Queue high_work for the first
cgroup over memory.high and skip reclaim and throttling in the charging
thread.

User workers created by create_io_thread() and vhost_task_create() keep
their current behavior. Vhost kernel threads use the new path, even when
they borrow the owner's mm.

The worker requests a fixed batch of pages each time. A fast allocator
can keep usage well above memory.high. Kernel threads also skip
memory.swap.high throttling and its high-event reporting. The memory.max
and memory.swap.max checks stay the same.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 20c5dfe1a894..8116fce6ab96 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2705,6 +2705,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 			       gfp_t gfp_mask)
 {
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
 
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
@@ -2723,8 +2724,12 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		swap_high = page_counter_read(&memcg->swap) >
 			READ_ONCE(memcg->swap.high);
 
-		/* Don't bother a random interrupted task */
-		if (!in_task()) {
+		/*
+		 * Don't make an unrelated interrupted task handle this charge.
+		 * Kernel threads may be working for other tasks, so let a worker
+		 * reclaim instead.
+		 */
+		if (use_worker) {
 			if (mem_high) {
 				if (allow_spinning)
 					schedule_work(&memcg->high_work);
@@ -2751,6 +2756,10 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
+	/* Interrupts and kernel threads stop here. */
+	if (use_worker)
+		return;
+
 	/*
 	 * Reclaim is set up above to be called from the userland
 	 * return path. But also attempt synchronous reclaim to avoid
-- 
2.53.0-Meta

