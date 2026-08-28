Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF003EFFC4
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 11:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787915395; cv=none; b=uVZ+tcrjKhvWITpSQKJaVWJoQTApWZtmiBP6vpCXTqvKqrdNBuNc/r4CQrldwoEpdcdyzDooQfy8VAsJv2cku8DykGILRNaE153+WhhVYEuY5bIYOUoyHL+OjJEss2USZRplvcsbKx9nKobCnvZRFzOVYMt80Gvk0pcPGOqRk0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787915395; c=relaxed/simple;
	bh=aB2sPXe8ZSnNuzSPG400K7+aKsUxWLpt5p1IJqhSTDk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Kdb9egtV37EzOUVCJzkvbBp1vjbaQBO9fR924O8s/xEuomSlK9P5KRyYl6ozNcAidSN0ixpskcARU7YbNgOj82tIJKm1YQ/FfZpDNkrBmrapmmac8v8OVBXKqFnxt+QuDGGd+8Gize53IicE6GyjPdsROX1rsjynur4lobfdEIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q/MAiruP; arc=none smtp.client-ip=91.218.175.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q/MAiruP"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=aB2sPXe8ZSnNuzSPG400K7+aKsUxWLpt5p1IJqhSTDk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787915389; v=1; x=1788520189;
 b=q/MAiruP6z7DqG5e7rjLjwFB90It1swu5Sln7BlhPNHhSxMuHu04+R3WTwqw6+bX04y4J8R0
 Xx4VxquQEKd3tpIcY7AF18o/gA/YXvLX2apf7y+ZCXsHrIcA8EZcl9031LR3tSJXkAQAPMpc2o/
 UgkEKFX0fK6BNm1JXWPD4ulw=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 55830487e16c8120;
	Fri, 28 Aug 2026 11:09:39 +0000
X-Mizu-Trace-ID: 55830487e16c8120
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 0/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Fri, 28 Aug 2026 19:09:17 +0800
Message-Id: <20260828110919.1324028-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

This series fixes memory.min/low being silently bypassed for MGLRU
during non-kswapd global reclaim (global direct reclaim and root-level
memory.reclaim).

Patch 2 is the actual fix. Patch 1 is a prerequisite: an integer overflow
in effective_protection(), spotted by the sashiko review tool, which
patch 2's new caller would also be exposed to.

---

v2:
- Fix an issue caused by non-atomic read races in patch 1 [1]

[1] https://sashiko.dev/#/patchset/20260828092432.1257917-1-ridong.chen@linux.dev?part=1

Ridong Chen (2):
  mm/page_counter: avoid integer overflow in effective_protection()
  mm/mglru: fix ineffective memory protection for non-kswapd reclaim

 include/linux/memcontrol.h | 11 ++++++++++
 mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
 mm/page_counter.c          | 19 +++++++++++-----
 mm/vmscan.c                |  8 ++++++-
 4 files changed, 76 insertions(+), 7 deletions(-)

-- 
2.34.1

