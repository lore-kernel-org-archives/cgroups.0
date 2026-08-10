Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A7823E330
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 07:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786347821; cv=none; b=D4YlLaB9faUYhbwS2W9LYHNOQrTuNPlBUw1HIoDRpnV96V2b9cdhjpbMSlnKglruj/IZuZ1nmYN4JSOX3nmDjTP63LDktmnI3ctKol3+sv4/TDLR2yDO1/B98kDY3VjSpxHVqWZpkKoCwI4xTN96Xq6VdpdiLayh8c8hXUrK2ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786347821; c=relaxed/simple;
	bh=/VPBMDzPzS8760WlLQ1eHhETk6b6NCuS2tB+UeuE02g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EwDSRRrTTYQautvSjBH45FzEdm+KtrIVqpSfa1Nqm+9DXO6GXJEePhoGmw+wnMe2VthZnCib30V6wRYB2z0gQOn5GWRKRck3vvka0opy3QRXaiOGiOEri+8nFllbQlwSgElmGCIXVuSeUNJNa81LSR+CCylsGKiSpRaCO3zBhrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C6S/P4gc; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C6S/P4gc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786347816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mVpJ6V0RufPJd4lqnhOejWws1ST4k7JNg7UsqaSq5+w=;
	b=C6S/P4gcr49W+z0/h6tyOrwCcOMOribH32iiXx1Sfgz5nXuliLAvIh5TOkjzxGhe4Xr9Rh
	oUDXvbtPjLXkTTYni8ltgBToVEWjftn677uo/eUDMzsGKvldXWr2A+24lmXWbOmoioUsrq
	64SFBOrMp2V9nBkeUOzy0SdB0wUayFM=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: shakeel.butt@linux.dev,
	akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcg-v1: fix memory.memsw.failcnt accounting
Date: Mon, 10 Aug 2026 15:42:47 +0800
Message-ID: <20260810074247.52747-1-guopeng.zhang@linux.dev>
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
enabled the flag for memcg->memory, but not for memcg->memsw.

Consequently, memory.memsw.failcnt remains zero when the memory+swap
limit is hit. Enable failcnt accounting for the v1 memsw counter.

Reproducer:

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

Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6939a4fbb991..4ffe5b3733d9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4235,6 +4235,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
+		memcg->memsw.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
 		page_counter_init(&memcg->kmem, &parent->kmem, false);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
-- 
2.43.0

