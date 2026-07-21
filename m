Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2AD466B72
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 10:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784628575; cv=none; b=T7du1O2+Juq/cERs/ll/gHXfctR6nfunZMX93u8S6MVWkZ2bK0IjxQimxF0CpcJF1qYvtx3GyQBqsJlHnQ+25mcM8alHcCNH/pgzKy/Qeuox2X5+1T4Ti7RBYKzPIEN2AalPyAUdT6gAnZDvYvguvLG1GrIDe5qPvIvBUZ2t3p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784628575; c=relaxed/simple;
	bh=uLWJPiF6Igq7CJ8wP6aIgs1+ukbs6SMmz1olnhD6Ers=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XHW6hjKljqSKdWHz06qd+wdCFNmM6XHIx27GyvJvcNfenhECN7znlnIteN2FQT2vcv8an1KN9ogVPwI1a0880coSY/ffaUrpDiJYsdslVxDMwxY+LdqHbl/o4N+aJO5qfxPs/ViDzLrfDhpyPIrv2IfQUY5D4qO5RgSaTOlDDrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q935BXKH; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q935BXKH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784628571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rtXOsg2ueYVGRLW3PtOke69mX+SA5v4SjKosXuE4yoQ=;
	b=q935BXKHNaNk7Cj1nFZHQed1RmkLiDzz5keIA85fn4hJm5pJQbJciDxylDv2c9ZmtJnJ8M
	TCnhPv9od99ouSEGlU0OQUNDGTfcI50VVTvBgElzJX2ybjNcgjGbJpp3YKlht7eK7tRcYT
	Xtjzse3jV/ssqqPojYUZctyv2V6zyaE=
From: Hongfu Li <hongfu.li@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] mm/memcg: check kzalloc_node() return in memcg1_init()
Date: Tue, 21 Jul 2026 18:09:16 +0800
Message-ID: <20260721100916.76822-1-hongfu.li@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Hongfu Li <lihongfu@kylinos.cn>

Add NULL check for per-node kzalloc_node() allocations in memcg1_init().

Skip the NUMA node when allocation fails. All users of
soft_limit_tree.rb_tree_per_node[] safely handle NULL entries, only losing
soft-limit tracking for that node.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/memcontrol-v1.c | 2 +++++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 2dc599484d00..33ea693c9281 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2566,6 +2566,8 @@ static int __init memcg1_init(void)
 		struct mem_cgroup_tree_per_node *rtpn;
 
 		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
+		if (!rtpn)
+			continue;
 
 		rtpn->rb_root = RB_ROOT;
 		rtpn->rb_rightmost = NULL;
-- 
2.54.0

