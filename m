Received: from mta1.migadu.com (out-251.mta1.migadu.com [95.215.58.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E145130D40D
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 21:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791666612; cv=none; b=Tz0LG6n/v+El8E6tGrqz2VJhDpbPGZQLAMKWc1GSWUyJexG81IEnYd/fSxoNH5xZy/GnssM6KqJM6K180nGipfDT2IyvX5EkgFlSi8KxykJxfutJp6+bTLfEd3kijyfijNxgpozpRo6z/WmvtsDp0zYkgCp+6RDyUfyC76Jv4vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791666612; c=relaxed/simple;
	bh=R6hukEq+j5VBimksOBhczcPosF9ZrdYYxIc4MT00GpA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ABmdUUV1GCEcZE15YqMoaue8a3uDzquVZ2XZ8kdbyPlzB3iDfkwId8FT+IqbROW5MocTNKU0ehgPK1i1p1wEYmQ/Vnm8dHuD27Ab/wiqp5FI+Av4/SvzL6cV2yK93bDQHit1Rdp0D24OaNHYjO0y2Dms+MQtQ5VuHtnaH/AZKAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nZYB7QHr; arc=none smtp.client-ip=95.215.58.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nZYB7QHr"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=R6hukEq+j5VBimksOBhczcPosF9ZrdYYxIc4MT00GpA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791666607; v=1; x=1792271407;
 b=nZYB7QHrTFjY9naZCt4x788AaOV4ZYrKtZXUVJmqXtLQCExPfsVUFTveIVQNg5mg2cnGfZIQ
 KouCV64llHWXdSt3oxBJU+sBEHKWwEWb7V0qZQFuNDWDkC4PL9gBRogZj+A67N9frD4km2iyvXH
 R/sE2NdB2ruvkOdvRS9mhIh4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d8c3c3c2c6b85a0b;
	Sat, 10 Oct 2026 21:10:06 +0000
X-Mizu-Trace-ID: d8c3c3c2c6b85a0b
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
Subject: [PATCH for-7.5 0/5] memcg: clean up memory.high enforcement
Date: Sat, 10 Oct 2026 14:09:52 -0700
Message-ID: <20261010210957.1350874-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
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

Skip queuing work from PF_MEMALLOC tasks. Reclaim can charge memory
itself, for example when zswap stores a page, and high_work must not
keep queuing itself from its own reclaim.

This is best effort. A fast allocator can keep usage well above
memory.high. The worker paths also skip memory.swap.high throttling
and its high-event reporting. The memory.max and memory.swap.max checks
stay the same.

The first patch moves enforcement into memcg_enforce_high(). The next
two add kernel thread and remote charge handling. The fourth adds the
reclaim guard. The last simplifies the scan and comments. The first
and last patches have no intended behavior change.

Based on next-20261009. Tested in an x86-64 VM with loop writes, threaded
NAPI, remote faults, notifications, and both vhost worker modes. The
remote tests kept same-cgroup and ancestor charges on the local path.
An incompressible zswap test queued high_work from its own reclaim 163
times without the guard.

Shakeel Butt (5):
  memcg: move memory.high enforcement out of try_charge_memcg()
  memcg: use high_work for kernel threads
  memcg: use high_work for remote charges
  memcg: avoid queuing high_work from reclaim
  memcg: simplify high limit handling after a charge

 mm/memcontrol.c | 136 +++++++++++++++++++++++++++---------------------
 1 file changed, 77 insertions(+), 59 deletions(-)


base-commit: becb95e45ef0dda9ffb35156d909d3da7a2789c3
-- 
2.53.0-Meta
