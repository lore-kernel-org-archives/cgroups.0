Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E5615539A
	for <cgroups@vger.kernel.org>; Wed, 29 Apr 2026 08:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777452169; cv=none; b=f+HlVaTlzN91dfDzXnRjDqLEncAkOHiX9PAYI3JlswNDh3A7xPXk3/1aSH9oRy/lCwEiJBLP0gt4x4Q5Qn+zeqI2W/qSO7N3SMWrquSKSimiRkCewuj5e5r1wuSiW1IzCY3/EMitWXQSnuc1pyNCZZe0PKA07PCa14J7FQ3XykU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777452169; c=relaxed/simple;
	bh=NWkO/HuI3fbYa68soOI2FL7fCKWMUHqVul+UllHdWFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t1Ng94KOcKNH0Ybl5JaewVvmkSofQoqMK7LQZT0Br99lOtrdgf+QT0EBncYwgfi88MKkoNFqONLqTfPuDWt3P272gpEb0z4HWBE/yFlreC5R1gG6CZp4PWG2g/ghjtUbouaxC49yryh70M10GEXsSvmlf+w0prUgzvMKTPrPZao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RUMX91KS; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RUMX91KS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777452165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kHHye3OD5C3a9QpoeBC/kUEHYAfNMmW71MhL7O0n4Fw=;
	b=RUMX91KSTk3uaUQrNPKok1v0sYN/1C6TvYdMHB3ULoMGrn2LCss8ED4STcddVBt1uEjWRl
	fs2O2EQA6gSn3ixhwkHo15lOeRnPKdpg7bgHck0DIIXdlp9WULZ5ELvkhMv/5Of1PWrNAI
	8A4hL++CkWq+hBqzpF7+a0s0VtLuw/c=
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm/memcontrol: hoist pstatc_pcpu assignment out of CPU loop
Date: Wed, 29 Apr 2026 16:42:16 +0800
Message-ID: <20260429084216.186238-1-hui.zhu@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Hui Zhu <zhuhui@kylinos.cn>

In mem_cgroup_alloc(), the assignment of pstatc_pcpu is invariant
with respect to the for_each_possible_cpu() loop: both the 'parent'
pointer and 'parent->vmstats_percpu' remain constant throughout all
iterations.

The original code redundantly re-evaluated the 'if (parent)'
condition and reassigned pstatc_pcpu on every CPU iteration, then
repeated the same ternary check 'parent ? pstatc_pcpu : NULL' when
storing into statc->parent_pcpu.

Move the single conditional assignment of pstatc_pcpu to before the
loop, resolving both the loop-invariant placement issue and the
duplicated null check. On systems with a large number of possible
CPUs, this eliminates repeated branch evaluation with no functional
change.

No functional change intended.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f..4f4a60e57a08 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3993,11 +3993,10 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	if (!memcg1_alloc_events(memcg))
 		goto fail;
 
+	pstatc_pcpu = parent ? parent->vmstats_percpu : NULL;
 	for_each_possible_cpu(cpu) {
-		if (parent)
-			pstatc_pcpu = parent->vmstats_percpu;
 		statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
-		statc->parent_pcpu = parent ? pstatc_pcpu : NULL;
+		statc->parent_pcpu = pstatc_pcpu;
 		statc->vmstats = memcg->vmstats;
 	}
 
-- 
2.43.0

