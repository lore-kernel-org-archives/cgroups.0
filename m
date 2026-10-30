Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.120
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793393671;
	b=vJ7+MdglJwQO0KjQsWltfgWaQ96F8aKS9gefylWwTxAi/F/zTEcMQBTKtp/7XDtyFVBP
	 buLy0Ocn678GqSx3T+q8Edvg+XFuWtfiGl4mut3PA9L82InZoSTvaBvkvz/cMxt8r5zK+
	 FJQJeg3qBX052FK2UTZyx1LWNQCql7EG5/fRR/7lAKRLNvs665LvGafqFH1/7EHmhybEP
	 zpQzxaAbj23Ygavk2tBJPr9GPVvOie0Zj3RWO90d6kp+RSwma2xEN6MGv8eknACcQJerv
	 A8RajrdsCRbgBQv6PUTTuy9+KMMTvSH3sE4iZBz4yaggSjBdVd8xkng76onxnhdskCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793393671;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=STYotNoZgg8knNd9pb1oCT8l0qfH9UiTH6m2MFo1QdM=;
	b=UNV4byHiWsRw4OxmK92TtHISsUsuMDaT6yx3ilvHfCFsYFk7lIHNLtSVx846inHc2tog
	 kQBZm8woTblX+UJ2IGKGsqWLW+V9Ed3/1IxR8qGf1H8MRSEM+CggmKvlUiFGnn93ALV+P
	 UXYnUao1LGOn2pdgMFAJuZmqF+IUFSQ0iZ++7ge7s6y5Syof+zGDj3zCQ8KKVLaeZdBnU
	 QM38bT+tRN7qfwnOggZRYoOuJuUrnJO3wiRvW3hdGRO0Uhp+C3BY2xcbnfx5UcWfjEHHe
	 YfWYv9b+Aba/tdgPx0kcxGZaNl0eeOPmkWdjjy7wIX0XN7NGNugX3u8AetQUHY6mZ9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=flNFtnST;
	arc=none smtp.remote-ip=95.215.58.120
Received: from mta1.migadu.com (out-120.mta1.migadu.com [95.215.58.120])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4198F606A31E
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 20:54:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4198F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=flNFtnST
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8clnnUmUC8q777oCgAvC8M6C04u5+OxxMaV3Uhj9mK4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793393667; v=1; x=1793998467;
 b=flNFtnSTl9wJzPFeGhajh+eZ5PWtuKFwlQJ/4gTTrkkHaepXb9UfmWHG0qxXFk/79wWXCWZV
 UjOupzlBz/SZ9J7KJSIp8hh72CLDI+TXr6HjamiM5XUCoaCrHdR55Lg+uwAeqhADvsqBek916sP
 U8SWk5gl2nGVuSnMzQs90cMA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6fa3195e4235a3b9;
	Fri, 30 Oct 2026 20:54:27 +0000
X-Mizu-Trace-ID: 6fa3195e4235a3b9
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] memcg: clean up memory.high enforcement
Date: Fri, 30 Oct 2026 13:54:11 -0700
Message-ID: <20261030205418.341214-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series cleans up memory.high enforcement and uses a worker for
kernel threads and remote charges.

Kernel threads never return to userspace to run deferred reclaim.
Reclaiming and sleeping during a charge can also delay work they do for
other tasks.

Remote charges can go to a different cgroup from the caller's mm, for
example through filesystem notifications or faults in another process's
memory. The high handler uses current->mm, so it can check the caller's
limits instead of the limits of the charged cgroup.

Use high_work to reclaim from the charged hierarchy in these cases.
mm_match_cgroup() identifies charges outside the current mm's cgroup
and its ancestors. Local user charges keep their current handling.

Before that, force charges from PF_MEMALLOC tasks before trying the
limits, so they skip memory.high enforcement. Reclaim can charge memory
itself, for example when zswap stores a page, and the high_work worker
must not queue itself from its own reclaim. These charges still raise
MEMCG_MAX for the same cgroup as before.

This is best effort. A fast allocator can keep usage well above
memory.high; memory.max stays the hard limit, as it already is for
interrupts. The worker paths also skip memory.swap.high throttling and
its high-event reporting. memory.swap.high only throttles the charging
task, and a worker has no task to throttle. The cgroup's own tasks are
still throttled on their own charges, and memory.swap.max still caps
swap.

The first patch moves enforcement into memcg_enforce_high(). The second
forces charges from reclaim before the limit checks. The next two add
kernel thread and remote charge handling. The last simplifies the scan
and comments. The first and last patches have no intended behavior
change.

Based on mm-everything-2026-10-29-04-31. v1 was tested in an x86-64 VM
with loop writes, threaded NAPI, remote faults, notifications, and both
vhost worker modes. For v2, each patch was built with GCC and Clang
(W=1). In a VM test with incompressible zswap data and remote faults,
the high_work worker queued itself from its own reclaim in 118 of 284
runs without the PF_MEMALLOC patch, and never with the series. The runs
were counted with bpftrace on queue_work_on() inside high_work_func().
In another test, a parent cgroup was over memory.max while its child
was reclaimed. The child's zswap charges raised MEMCG_MAX on the parent
7133 times with the series and 7124 times without it.

Changes in v2:
- Rebased on mm-everything-2026-10-29-04-31.
- Collected Reviewed-by and Acked-by tags.
- Patch 1: add the missing Signed-off-by (Harry).
- Patch 2 (was 4): replaced with Michal's suggestion. Charges from
  PF_MEMALLOC tasks are now forced before trying the limits, instead of
  skipping enforcement in memcg_enforce_high(). MEMCG_MAX is still
  raised for the first cgroup whose limit the charge goes over. Moved
  before the kernel thread patch, so that no commit lets the worker
  queue itself. (Michal)
- Patch 4: say more clearly which charges keep the local path.
- Patch 5: drop locals that are no longer needed, and update the
  comments.

v1: https://lore.kernel.org/20261010210957.1350874-1-shakeel.butt@linux.dev

Shakeel Butt (5):
  memcg: move memory.high enforcement out of try_charge_memcg()
  memcg: force charges from reclaim before trying the limits
  memcg: use high_work for kernel threads
  memcg: use high_work for remote charges
  memcg: simplify high limit handling after a charge

 mm/memcontrol.c | 157 +++++++++++++++++++++++++++---------------------
 1 file changed, 87 insertions(+), 70 deletions(-)


base-commit: 7e12256cff20c704fd5c0fbbd6a070fda8c341c9
-- 
2.53.0-Meta

