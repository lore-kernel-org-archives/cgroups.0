Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDB4377541;
	Fri, 28 Aug 2026 13:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787924792; cv=none; b=ak5sft6B8ywpvukAnKAoNSvv104RrCQXleQc8/d772mM7yh555N+xS1CAa0GuSjotqt/rXLv8Pl4FMFqmoImWX4ToOJAN3+WBG4nMI+OjAIl3iAGYSgZRS058tJ+yKlLtEjZdfCnAlMlGdsiepCUfgy8jrBctQm7ONGHYhqQR14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787924792; c=relaxed/simple;
	bh=XcwqQt0zsMba/wWgzpxV9/sopkl/yMajXCVZy3181mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHILcESdWfwuGsnLBeqptMndXqGgK2e8IIxqTLHvhcDiSL1a5eshnW+dYwFxom+nWT1b06RsVMqoU9H9oUTPiGqSHCwjtL8c24ddUq75TIsgHnrDRafNo5ssn5S9/DfR1MfwecsIMWNAItDAQmYTUpe8ZEcR5AWI8RTER8s8t60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=PyJeeibl; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="PyJeeibl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=nQrVV3KHaCazWFUYZXrNswbqv+h44byMvxeCDxp4JpA=; b=PyJeei
	blAy2nprQ6IN8qEa87zXIN0nK2Eqq/oKUaRUx7D+RBs1PVvPN8RkO/vUg1nLLg4+dPfd16y1HaGCe
	DiF6PV40n3/aUHMOAQ/JqMVITDOmpJhICcf5PUZM/VjfOGGRuVCVXhLSIdXJPUxo7bUFqhoLyWapS
	vf75N5xdIiD8z/90t2OSpIhP8N72KmNW3qZk6hPqc1gaud4iG1SMaBaMUIICnaJoE6qqYBWQOVI2p
	neyOefzQUwgsSvGvkt9rREwPIIC4v6U4p6ZFLTFa3EU6ZnBkv+kCVWYDrLcTgAxyTQgeZOJgeTmEs
	0rcighijt0+LV3H1ZhBOXd9IwGTA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzwuY-00000008zmT-0pBE;
	Fri, 28 Aug 2026 13:46:26 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: [PATCH] mm/memcontrol: extract stock drain predicates into helpers
Date: Fri, 28 Aug 2026 09:46:20 -0400
Message-ID: <881654a39036c55ef90c9ec864d4ea9cab0a2821.1787890328.git.riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787890328.git.riel@surriel.com>
References: <cover.1787890328.git.riel@surriel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wrap the FLUSHING check plus is_memcg_drain_needed() /
obj_stock_flush_required() and the test_and_set into
memcg_stock_should_drain() and obj_stock_should_drain().

No functional change.

Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2
Signed-off-by: Rik van Riel <riel@surriel.com>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..a660ea0f820b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2306,6 +2306,30 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
+static bool memcg_stock_should_drain(struct memcg_stock_pcp *stock,
+				       struct mem_cgroup *root_memcg)
+{
+	if (test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+		return false;
+	if (!is_memcg_drain_needed(stock, root_memcg))
+		return false;
+	if (test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+		return false;
+	return true;
+}
+
+static bool obj_stock_should_drain(struct obj_stock_pcp *stock,
+				  struct mem_cgroup *root_memcg)
+{
+	if (test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+		return false;
+	if (!obj_stock_flush_required(stock, root_memcg))
+		return false;
+	if (test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+		return false;
+	return true;
+}
+
 static void schedule_drain_work(int cpu, struct work_struct *work)
 {
 	/*
@@ -2342,20 +2366,14 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 		struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
 		struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
-		if (!test_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags) &&
-		    is_memcg_drain_needed(memcg_st, root_memcg) &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
-				      &memcg_st->flags)) {
+		if (memcg_stock_should_drain(memcg_st, root_memcg)) {
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
 			else
 				schedule_drain_work(cpu, &memcg_st->work);
 		}
 
-		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
-		    obj_stock_flush_required(obj_st, root_memcg) &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
-				      &obj_st->flags)) {
+		if (obj_stock_should_drain(obj_st, root_memcg)) {
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
 			else
