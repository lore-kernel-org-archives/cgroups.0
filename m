Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.119
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793870566;
	b=44juxwOhuo1/BCZi0a2Cb8bkryMnOfD+3vAfTqrzqMvME4C3+cFsiNRnfplolLVwONjY
	 1XdmPap2DgO3DXw52GZZ0mmCgXJw6TVMkiNrUtwxh/gtuAYvfX7sHLzwiFvMhO2UqgL1E
	 r41cspCRnH1SGq4g/NW6vfHJMtV93JiQkRnGfQOvT0s5d3Cp1Q4WcigzZn0lk3LJOwx8+
	 e+e09eIO3WW8JO19p4YS7vxBZEAYvNRR7oJOM9BAayISkO2HKeAopM2g4rOJm69FRm6HX
	 dGYIKgxYzwE73i9vVdySWr75Pgzi3fW9rmr+KEFM3oiUaqxR5Uyi71eBtNGXvRpsv+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793870566;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=goZgGhsuDnXRMkG633Mg/AsrAm2B4reGrlV8Qh0TTu0=;
	b=H8up4n7pOr3t90hiKt9eO0JAfFh6DB7rpJTuaIGE2DBxhSdjp6Uh2J3raHuJPDmYpEbr
	 ElV0YT/YEyzQ9IRb6KmyMTBqaCl9yatV/xFoTIDD1lPn3QBApVePWRB7n0JdJTv3oREfE
	 5YCjCtM1GOj22UKjC1K5Dqr7IKihUOEBEA+CowKW2OyzL3n+UxTb70xSzmnO3qYlEdJFB
	 QD8htCpgMmf8k/Sg7FU9rWqBC3FeyipvuQIB8gIxb0q4IA3F0M6wcWVK4ar679X/QMI5P
	 1E/WZ6x2eZ3CywNM3NGqwebhfj9qOW4xIAdPaYryfao69SL5Lf62JkbMQh4A0aHHJlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b="Hf/ZmZfs";
	arc=none smtp.remote-ip=115.124.30.119
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B980B606A32D;
	Thu,  5 Nov 2026 09:22:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B980B606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Hf/ZmZfs
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793870562; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=goZgGhsuDnXRMkG633Mg/AsrAm2B4reGrlV8Qh0TTu0=;
	b=Hf/ZmZfs8Bt7rqtU0X3yk6m8VruR1zcr+763I6MIe/J2UZ3hKSDs0OqpunV+kJxgu8cvaM1DussguJILE0dkjQ7IZnlLMmRBqSNHkkBATJHyOP1MH7/CoAfDSmZs5Y0hmA9Ntb7AgkLsiG1qr9n5GaBsWSCwfBKsaJmu+pWzfYI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XE8K-0p_1793870559;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XE8K-0p_1793870559 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:22:40 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	xlpang@linux.alibaba.com,
	ryncsn@gmail.com,
	gourry@gourry.net,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v4 RESEND 3/5] mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
Date: Thu,  5 Nov 2026 17:22:31 +0800
Message-ID: <20261105092233.3558950-4-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
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

With cgroup.memory=nokmem, __list_lru_init() collapses every list_lru
into per-node lists.  That is fine for slab objects, which are not
charged per memcg without kmem accounting.  But a lru backed by a
SHRINKER_NONSLAB shrinker, e.g. the THP deferred split queue or the
zswap entries, holds user memory, which is charged regardless of
nokmem.  Collapsing such an lru loses the per-memcg view of its
objects.  Reclaim can no longer target just the cgroup under pressure.

Keep such lrus memcg aware under nokmem when their backing shrinker is
registered SHRINKER_NONSLAB.

This leaves the savings of nokmem intact: slab-backed lrus (e.g. the
superblock dentry/inode lrus) still fall back to the per-node lists,
and the per-memcg lists are allocated only when a memcg actually holds
such objects.

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 8e9577c5cb19..7c8d0b959bed 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -690,7 +690,9 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	else
 		lru->shrinker_id = -1;
 
-	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
+	if (mem_cgroup_disabled() ||
+	    (mem_cgroup_kmem_disabled() &&
+	     (!shrinker || !(shrinker->flags & SHRINKER_NONSLAB))))
 		memcg_aware = false;
 #endif
 
-- 
2.43.7

