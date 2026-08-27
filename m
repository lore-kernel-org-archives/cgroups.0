Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9913EBF3B
	for <cgroups@vger.kernel.org>; Thu, 27 Aug 2026 09:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787822329; cv=none; b=pavXaLGF8sy+keRQr4aq0EOthzKRKCho253HtCpZFDQyYETybykoAd2tsl7rdGEfrrRkEy03+ifQr9+o1SHUMLg4EkrtzVe2GoIpeJ+SnXprZkxV6um1Yk8XeMZ7q5SaSPWwsUTw1pnub52EkPl+FOqOfRn/B0GYwk4ULEtz4IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787822329; c=relaxed/simple;
	bh=geZOW1WODXXVi+0e58r8VoYK2l317YOTRPYNa/62Gi0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vsfu8s4jawRMsN1hFQy1J/wRIggsPSu7dLPDZFb04K05ltRBzoUSNwOmxS+LYZqB1QMBW0K8WICRqBQnFKTQUQrvU9vPcyyE6cNaC380fD3cIs5hqap4/HURYlou+87sz/5RYJH/kR3/6Lv91ByEXF0Wb0JL3mZu/mZtntKP27k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gW6CCbBi; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gW6CCbBi"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=geZOW1WODXXVi+0e58r8VoYK2l317YOTRPYNa/62Gi0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787822316; v=1; x=1788427116;
 b=gW6CCbBiyjVh9Qp4y0feZ2bOqcX6iQ3ILUlfboAWZ4qdUvgXTiPMTdpjB6YoxFF+qC4Ub/dF
 CaB4u3ztZlDRmDTWuoXdboKUBmWmtAbSGD544cIx8y0v3R6Qzp5hLeFoMjgxM/Y7bEh3ewABewJ
 lU6RRiTJw9oicYbKjBM0crUo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 75b3eba5054843c9;
	Thu, 27 Aug 2026 09:18:36 +0000
X-Mizu-Trace-ID: 75b3eba5054843c9
X-Migadu-Flow: FLOW_OUT
From: Hao Li <hao.li@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH] mm: memcontrol: treat disabled memcg as kmem accounting disabled
Date: Thu, 27 Aug 2026 17:17:50 +0800
Message-ID: <20260827091813.22327-1-hao.li@linux.dev>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mem_cgroup_kmem_disabled() currently only checks whether the
"cgroup.memory=nokmem" option is specified. However, kmem accounting is
also unavailable when memcg itself is disabled.

Check both conditions to ensure the function accurately reflects the
kmem accounting state.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ebceade4021..b28f6165c354 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -132,7 +132,7 @@ static DEFINE_SPINLOCK(objcg_lock);
 
 bool mem_cgroup_kmem_disabled(void)
 {
-	return cgroup_memory_nokmem;
+	return cgroup_memory_nokmem || mem_cgroup_disabled();
 }
 
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
-- 
2.54.0

