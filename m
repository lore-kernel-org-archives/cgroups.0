Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.76
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793393687;
	b=Iy3tynTT3NNp+kRGToV3QQmt7+Opd6Xn8QS8lyJsQiDv7W4e9Ua5TjT70EgZJ3ckpc9e
	 NA2iOQAMTWLQliY7/TCh6pt87mMfxAf632Kavf7a+f51nHWZXrOLpk5kgHHDahzDoNLvb
	 ePMtWrF6g24qZ65Z6GHM9DBQ3fINDD9H9hvUDVh6NS5PleXngVDVZn86T1vpGinFuwlLP
	 fTEPr2QIh6mVMGLPLZx8kNSViqkpjQRp2Aqvu+r4It3/fca82NlP56h/0mEZR6BQ2a0io
	 AZjDPHR5d2BSDiGPBd4r27Y70zstMJ97P42rcgt7TkUtcWSwzCaA22jxmJW8LaEPbBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793393687;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3LOOMBiRudcRqqourx6yGwP6bpaJtTp0XqlHxDY1cLk=;
	b=MVFpn5BRN4C6QTxqcEd7Qlwf3LBztqUq0L9X9TvBZeThkbGoDagIdXBR7/G2hK2VIl6Q
	 6ksSkvS9u8SZGTcXTc9HhLvyXj9bVFr47fqHz080ZeN2aCMl06iXdR+c9nuo6zFU188cW
	 Ck4uwGO8cV7H2LEXnfvqzBvpP4msIYSTWH3wFBEWSDzDXhpicW+1fqQYsMr64muScnG70
	 TdhZGj3IK3MeFifHkKldu7YrpUnxG0QpCL9xDnqEncWBB9phg8qPam1/2NX1WQD56hEqQ
	 BHdCxzgbgwqUnv0U4xnVYr9iva7VNiIQpLfQpY+6fR2AY8lOAFboOarQUxYfUzx/R3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HLnG1BJU;
	arc=none smtp.remote-ip=91.218.175.76
Received: from mta0.migadu.com (out-76.mta0.migadu.com [91.218.175.76])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BAE606A32D
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 20:54:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54BAE606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HLnG1BJU
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xZeayaJ9A4XXrBIo9cgThSGbAkjlrpMHtlIOd0m03/A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793393684; v=1; x=1793998484;
 b=HLnG1BJURJTLZ1LncN0Z2qcRAyII+KMaZKF4L2tHQhNjHHsajh5PT+R8AE7AC6lxsPg+p2rc
 0HFhcpowfb4uvaN5VdumBpcMt36rtEOist1HkbpArNpG74ib1SXKxeoTWnHv70jKJvdF2hIXl4b
 L9yLEmgpw4sc7t6nGWZE/ZF8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 07d861093bbb3087;
	Fri, 30 Oct 2026 20:54:44 +0000
X-Mizu-Trace-ID: 07d861093bbb3087
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
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2 4/5] memcg: use high_work for remote charges
Date: Fri, 30 Oct 2026 13:54:15 -0700
Message-ID: <20261030205418.341214-5-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030205418.341214-1-shakeel.butt@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
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

Some charges go to a cgroup outside the current mm's cgroup and its
ancestors. The high handler uses current->mm, so it cannot handle these
overages. Filesystem notifications and remote page faults can take
this path.

Use mm_match_cgroup() before checking the high limits. If it does not
match, use high_work instead of recording task overage or doing
synchronous reclaim and throttling. Charges to the current mm's cgroup
or one of its ancestors keep their current handling. Tasks without an
mm also use the worker.

Like kernel threads, remote chargers skip memory.swap.high throttling
and its high-event reporting, and a fast allocator can outrun the worker.
The memory.max and memory.swap.max checks stay the same.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/memcontrol.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 42bdaaacafb7..e8d9c001b6ce 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2708,7 +2708,8 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 			       gfp_t gfp_mask)
 {
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
-	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
+	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
+		!current->mm || !mm_match_cgroup(current->mm, memcg);
 
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
@@ -2731,6 +2732,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		 * Don't make an unrelated interrupted task handle this charge.
 		 * Kernel threads may be working for other tasks, so let a worker
 		 * reclaim instead.
+		 * Remote charges need reclaim from their charged hierarchy.
 		 */
 		if (use_worker) {
 			if (mem_high) {
@@ -2759,7 +2761,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
-	/* Interrupts and kernel threads stop here. */
+	/* Interrupts, kernel threads, and remote chargers stop here. */
 	if (use_worker)
 		return;
 
-- 
2.53.0-Meta

