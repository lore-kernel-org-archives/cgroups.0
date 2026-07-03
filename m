Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1357E32AAAB
	for <cgroups@vger.kernel.org>; Fri,  3 Jul 2026 06:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783060733; cv=none; b=YtXkHBoNghdbWG2lIC69gnZzDwIj7pQcilD+zAqi0jFU1QQSrgEMUZeieyArpkn3pjj1UPDZW7LACZznfftanKm5+fn+Divoi2ZCXnDJTfScdWubPbE02ZT1ShR7fqxeam40OpZYt2n7pUiZDw6tmlXmTVBE+ozVKezqPOsp3eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783060733; c=relaxed/simple;
	bh=lINfCFcB+MpDIDNuYF+TegAAW9co8SVImXKWpifj1pE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ie0FSycN5R0wxcQFq9ICRZgDzbOxoKPF4eJgfjn+cC10bEsIAzPVxy+5uCkZEfG5n7yEHBLhRBGuZezlVdpzh89AOyPO3nee/TS4TadOeK5AP/Vh8A6nG5swqm+OosFlECjmXuLk16pPDHnfcnLcJakVkz/gEhiTKJ56YneNQzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IlPBo5Ep; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IlPBo5Ep"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783060719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z0NILGVMEqCxDUwwsKsa9n9qfS5/GPIbQstMynaSZY0=;
	b=IlPBo5EpD5UJdecwEsnJy88CIxXeca2so8Drk7Be2zX9Vee+P4m1ajEMdFd+al5Qn6usSi
	xddm56PP7uTa2i04ZG1qXVQ3aLiylCYlRONRgTOd99jR27EvTy/w2nxXSnhJMP3MI7YsDK
	Xb+35SN9RVjLvVR81vgrQ7IfLw4pe+s=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Tao Cui <cuitao@kylinos.cn>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] mm: memcg: reset zswap settings in css_reset
Date: Fri,  3 Jul 2026 14:38:23 +0800
Message-ID: <20260703063826.306878-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jiayuan Chen <jiayuan.chen@shopee.com>

mem_cgroup_css_reset() is called when the memory controller is disabled
on a cgroup but the memcg cannot be destroyed because it is pinned by a
subsystem dependency -- for example, the io controller declares
.depends_on = 1 << memory_cgrp_id, so memory remains in the cgroup_ss_mask
and the css is hidden rather than killed.

The purpose of css_reset is to revert the memcg to its vanilla state so
that no policies are applied and the css can be safely made visible again
later.  Currently, all page counters (memory.max, swap.max, kmem.max,
tcpmem.max) and other limits (soft_limit, memory.high, swap.high) are
reset to their defaults, but zswap_max and zswap_writeback are not.

These fields are initialized in css_alloc (zswap_max = PAGE_COUNTER_MAX,
zswap_writeback inherited from parent) but were missing from css_reset.
As a result, stale zswap policies remain in effect after css_reset: the
zswap charge path (obj_cgroup_may_zswap) continues to enforce the old
zswap_max limit, and the writeback path continues to honor the old
zswap_writeback setting, even though the memory controller has been
"disabled" on this cgroup.

Reset zswap_max to PAGE_COUNTER_MAX and zswap_writeback to true, matching
their defaults in css_alloc.

Test:
	echo "+memory +io" > /sys/fs/cgroup/cgroup.subtree_control

	mkdir /sys/fs/cgroup/test
	mkdir /sys/fs/cgroup/test/child

	echo "+memory +io" > /sys/fs/cgroup/test/cgroup.subtree_control
	echo 10000 > /sys/fs/cgroup/test/child/memory.zswap.max

	# child/memory.swap.max and child/memory.zswap.max disappear
	echo "-memory" > /sys/fs/cgroup/test/cgroup.subtree_control

	# re-enable memory control
	echo "+memory" > /sys/fs/cgroup/test/cgroup.subtree_control

	# before this patch
	cat /sys/fs/cgroup/test/child/memory.zswap.max
	    8192

	# after this patch, same as memory.swap.max
	cat /sys/fs/cgroup/test/child/memory.zswap.max
	    max

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---

v2 -> v3 : typo in commit message and add Reviewed-by tag.
v1 -> v2 : add WRITE_ONCE.
https://lore.kernel.org/linux-mm/20260630100832.107062-1-jiayuan.chen@linux.dev/
---
 mm/memcontrol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d20ffc827306..c20ef3c1d6fe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4362,6 +4362,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
+#ifdef CONFIG_ZSWAP
+	WRITE_ONCE(memcg->zswap_max, PAGE_COUNTER_MAX);
+	WRITE_ONCE(memcg->zswap_writeback, true);
+#endif
 #ifdef CONFIG_MEMCG_V1
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
-- 
2.43.0

