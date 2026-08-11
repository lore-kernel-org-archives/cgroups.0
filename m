Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8701A262D
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 03:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786417737; cv=none; b=j0HKpTF7VMu3smNUEDY8fhwLdfF1OPQoo/BwlmbYWC1E2kiQ5Lh0DZLp49Ba+8o3xzjagJgQjgUjzAHy+ifo6CFFyT/gTH/G3L6QE40HArNIKywJdsZ0hcqpPxLNKxp3uz+TQAQPPtgDt41FvdxvSp3/57FNPq9yhF/5FnYgM2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786417737; c=relaxed/simple;
	bh=VCAzXrgIve0GcAap/eyOUMmG8L4KNb/c3kOjjuzKbCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CtqQhbOg3mq6kYCdJx8ZmZu0vk6xU1lGU+4JY+qsoGfctyzcFmcdr795aCBCXfEXoBiMlgxKnBwoL3gnPh7LxBuzXSM1BqTjeFB1xlUdQcz8wPg6z0YrpjWmq5ixoPanWqzvi+Y45ln3KCUPzW+qf41u5d7prmr6Q1+RVSHXuQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z7i1XOOk; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z7i1XOOk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786417732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6RU1QcglTKSplI+6h+9d2ONdsvNoRJa+0z35rhprdP8=;
	b=Z7i1XOOkFFAUellA3NV7lMdxMXnkv4B5/1E1WrWvNwTIf7s+0fgOl20XIMzJpjCbsdMr19
	l8PvtayKaT6f4jbWCJF+wqLEy/9tsDYpRDTLSmfok/0Rbebn1m/09lu+Y5cfjazRWYWzx/
	++iU1n3QmmKsS9NtWMjZiSZq/3ULpkk=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	akpm@linux-foundation.org
Cc: roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2] mm: memcg-v1: fix memsw and TCP failcnt accounting
Date: Tue, 11 Aug 2026 11:08:43 +0800
Message-ID: <20260811030843.109104-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
cgroups") made failcnt accounting conditional on track_failcnt. It
enabled the flag for memcg->memory, but not for memcg->memsw or
memcg->tcpmem.

Consequently, memory.memsw.failcnt remains zero when the memory+swap
limit is hit. memory.kmem.tcp.limit_in_bytes still sets
memcg->tcpmem.max, but TCP charge failures are not reflected in
memory.kmem.tcp.failcnt.

Enable failcnt accounting for both v1 counters.

To reproduce memory.memsw.failcnt:

    CG=/sys/fs/cgroup/memory/memsw-test
    LIMIT=33554432
    mkdir "$CG"
    echo "$LIMIT" > "$CG/memory.limit_in_bytes"
    echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"

Start a child process in the cgroup and make it allocate and touch 96 MiB
of memory, causing a memcg OOM.

    cat "$CG/memory.memsw.failcnt"

Without the patch, memory.memsw.failcnt is 0. With the patch,
memory.memsw.failcnt is greater than 0.

To reproduce memory.kmem.tcp.failcnt:

    CG=/sys/fs/cgroup/memory/tcpmem-test
    LIMIT=65536
    mkdir "$CG"
    echo "$LIMIT" > "$CG/memory.kmem.tcp.limit_in_bytes"

Start a child process in the cgroup, create a TCP socket, and reserve
1 MiB of socket memory with SO_RESERVE_MEM. The reservation fails with
ENOMEM.

    cat "$CG/memory.kmem.tcp.failcnt"

Without the patch, memory.kmem.tcp.failcnt is 0. With the patch,
memory.kmem.tcp.failcnt is greater than 0.

Closes: https://sashiko.dev/#/patchset/20260810074247.52747-1-guopeng.zhang@linux.dev?part=1
Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
Cc: stable@vger.kernel.org
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
Changes in v2:
- Enable failcnt tracking for tcpmem as suggested by Johannes Weiner.
- Add the memory.kmem.tcp.failcnt reproducer and test result.
- Update the subject and changelog to cover both counters.
- Add Cc: stable@vger.kernel.org and the received Acked-by tags.

Link to v1: https://lore.kernel.org/r/20260810074247.52747-1-guopeng.zhang@linux.dev

 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 70806373d5a9..17da1f43b7d3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4235,9 +4235,11 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
+		memcg->memsw.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
+		memcg->tcpmem.track_failcnt = !memcg_on_dfl;
 #endif
 	} else {
 		init_memcg_stats();
-- 
2.43.0
