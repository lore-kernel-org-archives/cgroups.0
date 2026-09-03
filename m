Received: from mta0.migadu.com (out-162.mta0.migadu.com [91.218.175.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F9E347FFE
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 03:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405641; cv=none; b=PfJnkWPVmtRvqX041DzaZZ5etbYqR8V+jomL1BQugwQNTJ/DNQ6xvUZvM1blWmAH1rp29MXaz2AquBFJ0Fm86Fg3tH3f5IBvRi1edo8umaDn0fvgv7zicRzJXYhxivDViUaoOq3HrX9rcYGS+27FvVfCpmiX+Wgtg24bjQmWDcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405641; c=relaxed/simple;
	bh=WriMjLytZ29spS2Jm+A0Dm4d9IUfhmOtVaV0HWcwC/c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mL4g4AEpHwsiPW+FfQm+w3iqJpu4wJm8qQPr0gIzyJGOY9/EchWrBR7G/6RC5BeIWBaBwvcdg0LPHtlYPTvkswigc8hQNdfbt6mD2WNeiowwlcxf5VMHS17bMwZLLiz+7Qr+vMndXH3M4eQcOD+30Tbol/hW4WaPziGPmwHAgAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QwwUeiRs; arc=none smtp.client-ip=91.218.175.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QwwUeiRs"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=WriMjLytZ29spS2Jm+A0Dm4d9IUfhmOtVaV0HWcwC/c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788405635; v=1; x=1789010435;
 b=QwwUeiRsQR9RLuoRiuZOodHeOCECXgfpq2XBBwh5FLhfzgN0m4tuQksf8wtWk9wpySIIzo5b
 p4aOOjaUs9zcFxSTsfC2kxswz56ivLAT4KQNeQwtYHxuXlTexREp8hpYB2ZbjkA2sFouJ5ZzRvf
 V7IsamE3isPwgREoL83X+6JY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0634c6904f5800d5;
	Thu, 03 Sep 2026 03:20:16 +0000
X-Mizu-Trace-ID: 0634c6904f5800d5
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
Subject: [PATCH v3 0/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Thu,  3 Sep 2026 11:19:50 +0800
Message-Id: <20260903031952.1120321-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

For MGLRU, memory.min/low is not honored during non-kswapd global
reclaim (global direct reclaim and root-level memory.reclaim), because
these paths shrink memcgs using stale effective protection (emin/elow).

Patch 2 is the actual fix. Patch 1 is a prerequisite: an integer overflow
in effective_protection(), spotted by the sashiko review tool, which
patch 2's new caller would also be exposed to.

---

v3:
- Per Barry Song's review comments

v2:
- Fix an issue caused by non-atomic read races in patch 1 [1]

[1] https://sashiko.dev/#/patchset/20260828092432.1257917-1-ridong.chen@linux.dev?part=1

Ridong Chen (2):
  mm/page_counter: avoid integer overflow in effective_protection()
  mm/mglru: fix ineffective memory protection for non-kswapd reclaim

 include/linux/memcontrol.h | 10 +++++++++
 mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
 mm/page_counter.c          | 19 +++++++++++-----
 mm/vmscan.c                |  8 ++++++-
 4 files changed, 75 insertions(+), 7 deletions(-)


base-commit: 32b6ef9a5d0eca44f9cd91f52f4faa89f145a0de
--
2.34.1
