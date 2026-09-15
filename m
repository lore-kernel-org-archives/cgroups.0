Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06262EA754;
	Tue, 15 Sep 2026 04:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789446356; cv=none; b=d543yM3B2plZ9T+Dn1n1bBT2pB3YzZneNsSkDbBlZEzvg8kXt4qgKuWJO4TYGMpU5bL9i+1nNofLzUJiUggKDVbYevv4dZM4VOT8QjP4TwSzT2xT5DBbCsyAZEdyGKPOaKkt0KYLTiJeyjC2hDZ7VZ2rzClAIfRQPTF827GccUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789446356; c=relaxed/simple;
	bh=AYbkCNaCiSK0xor7pcXQRHmpYnNiOiM/TO+1ah5DmbU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lyt2ADZZDx4bY74vXs9V0jewzCSBFkCbLoXXAgRf6UG1y6faZPE2gEt717btheEUzTFJ8DZGMEF81/VTJS5sQQJUX52MGc+eUciaN+vKGUsX2w5yE+3lAj/YLt5JUAZFwmOJ3XRKdLT4Hj2QQMFnkpEQjeNXe3/sOj4bRtAV9Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wbT5Os0g; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wbT5Os0g"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789446350; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=WL2XPvPa5hKZgyLQVPqOjMB/mkqx2VtcNM7x/yo5l+8=;
	b=wbT5Os0gYWOGARBmy5TSX9OwGTeNzozvekbcjPu4ayMPQAc6Lrob5G64/DkqvbPyyGFbVDrv7xelXUXgOk0CW77ZvZIsDGIJV4D7L8c53xX5mxExQeX4maP4qMPkomrgrsBlUH51owH1tTvSgljR4w8gyQnwBrYZG4Ck36CPoaI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XB027Bp_1789446347;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XB027Bp_1789446347 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 15 Sep 2026 12:25:48 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	xlpang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	chris@chrisdown.name,
	kasong@tencent.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v2 0/1] mm: memcg: don't hand out large folios above memory.high
Date: Tue, 15 Sep 2026 12:25:45 +0800
Message-ID: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

memory.high is enforced at two points after a charge succeeds: on
return to userspace, and synchronously in try_charge_memcg() for
large overcharges, the latter gated on gfpflags_allow_blocking().

The THP fault paths pass the physical allocation gfp from
vma_thp_gfp_mask() to the memcg charge.  With the default
defrag=madvise (and no MADV_HUGEPAGE), as well as with defrag=defer,
that gfp does not allow blocking, so inside a single-syscall populate
loop - mlock(), MADV_POPULATE_*, any GUP-driven population - neither
enforcement point runs: usage grows from memory.high straight up to
memory.max with no reclaim and no penalty sleep, consuming the
reaction window that userspace OOM handlers (oomd, Kubernetes) depend
on.

v1 [1] settled the accrued over-high debt from the fault paths after
each non-blocking large folio charge.  As Zi Yan pointed out in his
review [2], falling back to order-0 above memory.high is the better
answer: above high the cgroup is meant to be under heavy reclaim
pressure, and the order-0 fallback's charge blocks, so it is throttled
synchronously as is.  v2 does that instead, and is a single patch now.

Qinyun Tan (1):
  mm: memcg: don't hand out large folios above memory.high

 include/linux/memcontrol.h | 33 ++++++++++++++++++++++
 mm/huge_memory.c           | 12 ++++++++
 mm/memcontrol.c            | 56 ++++++++++++++++++++++++++++++++++++++
 mm/memory.c                |  7 ++++++
 mm/swap_state.c            | 16 ++++++++++-
 5 files changed, 123 insertions(+), 1 deletion(-)

[1] https://lore.kernel.org/lkml/20260904035407.4098627-1-qinyuntan@linux.alibaba.com/
[2] https://lore.kernel.org/lkml/6B46E8DF-679B-4254-A4AF-7B992B0F6460@nvidia.com/

--
2.43.7

