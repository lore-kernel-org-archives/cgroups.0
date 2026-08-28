Received: from mta1.migadu.com (out-213.mta1.migadu.com [95.215.58.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8693911C9
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 09:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787909101; cv=none; b=na2FB05hvEsCv0ZByX3JzBIvhJHY8PwE2899RbbwWNdZjr9nelZf2e2MUE9azvp6DZECowq0QEaa/+LX0DdjOHqI21hRxgxTOEA12zyc6M2cNZSA8Dk+pl7dOIFTrbZ/PxtLALKiko2mIV55NCD2eEhBiLC1TCqRqOgLCsmvIqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787909101; c=relaxed/simple;
	bh=CDI22/xCoc9ddBdZXUhSYZ3MzxPYo2degC19Pq6FtgM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Pgx7CP1FZ35BziommkRFF59n6AJOgegQngeaKp5Yf3jCFOI9bYX6kM376C1TPJgkAHCi7nrGM9Ilnmxs/SPmwTt+VOHB0tje9oXMbMB6kRjkv5YXk7Gc2jIlrRqj1BbnXJMlk8PRIckudGnF9RU7iJz7ir7MrvO7Hr6HfuDjR8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pbkERHQJ; arc=none smtp.client-ip=95.215.58.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pbkERHQJ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=CDI22/xCoc9ddBdZXUhSYZ3MzxPYo2degC19Pq6FtgM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787909095; v=1; x=1788513895;
 b=pbkERHQJkaHElumOogHNEjWknXO+i1b5M+StdIo+zG6BnFCi7wMPV/RECNgeGCjdvJ4snv2h
 Ej0YNfsYEXscKQDCMuw7X9hMaLmy8aASChOhogmFclGZIJvs4rIk81ODwASU+uKXoHoS93ojBzg
 oHmQhIAvt0BQJv3SS/hGnSUE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 220f4142187c77b2;
	Fri, 28 Aug 2026 09:24:55 +0000
X-Mizu-Trace-ID: 220f4142187c77b2
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH 0/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Fri, 28 Aug 2026 17:24:30 +0800
Message-Id: <20260828092432.1257917-1-ridong.chen@linux.dev>
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

Ridong Chen (2):
  mm/page_counter: avoid integer overflow in effective_protection()
  mm/mglru: fix ineffective memory protection for non-kswapd reclaim

 include/linux/memcontrol.h | 11 +++++++++++
 mm/memcontrol.c            | 45 +++++++++++++++++++++++++++++++++++++++++++++
 mm/page_counter.c          | 10 ++++++----
 mm/vmscan.c                |  8 +++++++-
 4 files changed, 69 insertions(+), 5 deletions(-)

--
2.43.0
