Received: from mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE521336886
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 18:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790275692; cv=none; b=dgGbUjzCUGUUsEdvCX+LueFY9Apvxggafcrci44KaVGnOfxI5uk5z1tUB5Ek2wzy8hxMJirf7/QavoXVSweii8QiPw0yiw6ECqvC784VwibBpq/AbGiKAg2oAph9pZZTt5gA0k4ZYZ/7MHdq8q1+yc3snFyXk3TQuUfYUvqjSas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790275692; c=relaxed/simple;
	bh=vhv2GOBN4FsPRGu+ZsZgfVd3kVqXyiVymVSJNtKa9ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLAE9NrVDLx7i2h/O5kS4zJp1cet/sWduWK4gtNlKxgHOGHHWRFGRilw7hlyPTM0AkvjXrk2x5NtBiSvBcxONWUpsMLtG+k3LUAtv6vv5YDYEqh5KjNaoQcM3hrE/zvwAGFY0hJ9VnDk+bXgK40tMLmgQ74GWS1RBde6jeU9if8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hAD3XP6R; arc=none smtp.client-ip=95.215.58.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hAD3XP6R"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vhv2GOBN4FsPRGu+ZsZgfVd3kVqXyiVymVSJNtKa9ts=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275681; v=1; x=1790880481;
 b=hAD3XP6R9aGJHbBjel4SliVEZcMmOYmFPVeqheIfk61X6C9KBVu4XThcsfqnyJlMIG2ZFEX9
 aDJl9pxnpOwbXl/I+ZtGK3bajDqSoSSRrqXncelufYFwCDezVY75FqacEmQR5bNYGQsRNCTVoVP
 RSRvVn/dR3AJshcwNK3lsVC8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 57a02f3e5119bc77;
	Thu, 24 Sep 2026 18:48:01 +0000
X-Mizu-Trace-ID: 57a02f3e5119bc77
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	David Dai <david.dai@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Frederic Weisbecker <frederic@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Hao Lee <haolee.swjtu@gmail.com>,
	kernel-team@meta.com,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 6/7] memcg: charge high_work reclaim to the memcg
Date: Thu, 24 Sep 2026 11:47:10 -0700
Message-ID: <20260924184714.912181-7-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a charge from IRQ context puts a memcg over memory.high, the
reclaim runs later from high_work on a kworker. The kworker is in the
root cgroup, so the reclaim does not show up in the memcg's cpu.stat
or memory.pressure, and does not count against its cpu.max.

Run the reclaim under set_active_cgroup(). Its CPU time and memory
stalls are then charged to the memcg's cgroup, and its CPU time comes
out of that cgroup's cpu.max quota.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4d00748c8a5b..f1d0ba8b48cb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2456,9 +2456,14 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 static void high_work_func(struct work_struct *work)
 {
 	struct mem_cgroup *memcg;
+	struct cgroup *old;
 
 	memcg = container_of(work, struct mem_cgroup, high_work);
+
+	/* Charge the reclaim to the memcg's cgroup, not to the root. */
+	old = set_active_cgroup(memcg->css.cgroup);
 	reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
+	set_active_cgroup(old);
 }
 
 static void high_irq_work_func(struct irq_work *work)
-- 
2.53.0-Meta

