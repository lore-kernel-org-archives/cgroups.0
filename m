Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3219A37F305
	for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 05:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790401924; cv=none; b=nvyOACj6Hvye3ItvrttzycGWP+5Aa1p5ZCRwaczD4lujtzCC5BigrrQTR/u4HK2heW2iZ8Dlte7i1zgijYcTFN0Nb7piTZzuCgJIFTfXlPmXIsMubjvq/0QQdltID5deFNNFZOp/kzzFkfZcT4I2P3xk4VDvHj6f+nEM41gAJlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790401924; c=relaxed/simple;
	bh=U2oS7pgjyyIjvqi/orzXz9qBfDp++XWRg3ncB3XLl8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiGkPw3Osc3ZbrKWPjhcnbWHL77qsaOOUGrFDEdpcHhNAlIdHfkHTovO33I3xEnx88zJRhTo98ZSC6svTDTSd/pOsPtjjqi67VBUOgLmtG+s7zr0BO/37T494El70CFg25iRSixWtrJrnR/1gRQ6nZ0MI4dsuwmQZl4Cg17Q7iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TZnFlP17; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TZnFlP17"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4887f690df6so897303f8f.1
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 22:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790401921; x=1791006721; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IlS6Cm29yDumSGG9d2x8b2HduKmhAprb8xwGaPSX0YE=;
        b=TZnFlP17yTqHURL/h8uDdkLEUqIMxh2rCjRS+ZaK8J6ZbHK7n4w/vBK5hJ0gO3Np8d
         WQ0w91HdGRy6iwtCWhj0D2M7JPCFk2YeUIchwKNxQ8R+dTgye74XiFLvCbouLdR7Rbol
         LsPpA62uuOWCYp+or69ff9tmdDXOdrcod+bwrVoiEG1Navofwc9zMvSoTXvCk13C9og6
         p3cLntt2r5Aqfs56m7XR+IRz34NpjkidSDia/Af9tpO6r9o2LxpE1AGEx2ubNryrPUAb
         YKcoEpqE+jsAEUOboxZ/5hZ3pI9eLr0HfdCFXbwTpvLfvi0ZOVDATikpI+gPhn69Jxci
         K9uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790401921; x=1791006721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IlS6Cm29yDumSGG9d2x8b2HduKmhAprb8xwGaPSX0YE=;
        b=TxD2tX3g2V2AEU+0+vcRqbUR5lc8R7ce2cdZIlHX8SeZD5Kg/nXJPPZc5Yb7A5LkQs
         h1/++WmcPfAyeIUMiMX8xlDybpekexPUOOodlrPKx5Uf/y/tSAJdkw/TCrjBtMhaNMa0
         lgLE4F68qW0Iga+SJ/JbgpTZs7dejvXA0+0h3Ma6Z7NxAUVG4HzoXQdEHrNZcNFb8DYN
         m1rt0XNGW/yyNlom3c5XEVsqvvfYngBuo+ct/wMRRwsNs0L8OaDyBWZ5XvxsYGWFlJDv
         DF8Aig+P7RRkLoz5XnjNu+Lvu2YEDhvMglzlIoKXcygjGJ+8ZaSVTvDNrVjHdeB1HRYo
         aL0Q==
X-Forwarded-Encrypted: i=1; AKwUvBxIMuV0lI5gnZ9U9vN92q5miLjBTu+7iKdQubLp1tQyfijofDUsPNYuuMyyJKi9P53mDT2V3jkF@vger.kernel.org
X-Gm-Message-State: AFuF++kk/U+ngCW5W+NXPcWZvYayGIvpYsSngTlNv9UwQPbbe9+9S6Co
	HPadANlIrh41IfEvxqzRCkf/SXCzu38dLfl/nrHUIAVMz3tFQw/sI3Mu
X-Gm-Gg: AYBFou2PjlfuEOXkIvY2OiWwYuWo4Mnw4uIWyemxn+lhhPnAO7dEBYFfnVE9wZ/SoK5
	ZQZ11Cf9D47nxiCJk+ti+ddtqPEut5FgbJ7gcDaJ3Thi6LKBSU5Z3dOc8bZnUgtoHQTJWpSXYDz
	scRc7LQ50ZAmEl/i6JkckdvxewTF/xa0yWfRW7J011NkAIiT80E1C0+aHL7cuIqB+n+4bBjFDqY
	Ail6WIRaX2QQWGDoUb4XRnZQqFnG5nTZy9IoDxXjtvIlbthod01U8+CCUMxhgjjKDPbR6ehw+Y8
	dQKNXr+w5wKtkY4e2CCdHaTlHEo5H7AJvsxBAzte0Sx1qzo0WRz/vnuOYktROeKWqoDTMNSrrOz
	WnfGUXEFBY/Q+FI5jLZYqhNnLW54fHD2WwrsVCItyxMdY8vNK99Ntc8ci/jgd9Y3/ttk0fT6h9T
	rLmUd1fpsgrn9+35CEQsW94uWjt2RMNu6bZ7FT4dCx8lZU+wjapmaJjyC424Hs1sDWv8clkVq5b
	LeqJOpLDGqS/m4FbtQOb/9A7+RNAbWUWMPhwXNd7MYa
X-Received: by 2002:a05:6000:388:b0:487:24a:f3ba with SMTP id ffacd0b85a97d-488716a63ffmr13631454f8f.26.1790401921483;
        Fri, 25 Sep 2026 22:52:01 -0700 (PDT)
Received: from localhost.suse.org ([37.109.167.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a30bcc4sm12317560f8f.1.2026.09.25.22.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 22:52:01 -0700 (PDT)
From: Sebastian Chlad <sebastianchlad@gmail.com>
X-Google-Original-From: Sebastian Chlad <sebastian.chlad@suse.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Sebastian Chlad <sebastian.chlad@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] selftests: cgroup: Report memory.current shortfall in alloc_pagecache_50M_check
Date: Sat, 26 Sep 2026 07:51:48 +0200
Message-ID: <20260926055152.1684-3-sebastian.chlad@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260926055152.1684-1-sebastian.chlad@suse.com>
References: <20260926055152.1684-1-sebastian.chlad@suse.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

alloc_pagecache_50M_check() fails silently when memory.current is below
the 50M that was just written to the page cache. This is the check that
can trip when the page cache of the test cgroup is reclaimed under
global memory pressure, so print the observed value.

test_memcg_high() runs the same helper with memory.high set to 30M and
expects it to fail, so reporting there would print a misleading failure
message on every passing run. Split the body into
__alloc_pagecache_50M_check() with a report flag, and give
test_memcg_high() a quiet variant.

Assisted-by: claude-opus-5-5
Signed-off-by: Sebastian Chlad <sebastian.chlad@suse.com>
---
 .../selftests/cgroup/test_memcontrol.c        | 27 ++++++++++++++++---
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 8882c7faeb32..759e1640746d 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -222,7 +222,7 @@ static int alloc_anon_50M_check(const char *cgroup, void *arg)
 	return ret;
 }
 
-static int alloc_pagecache_50M_check(const char *cgroup, void *arg)
+static int __alloc_pagecache_50M_check(const char *cgroup, bool report)
 {
 	size_t size = MB(50);
 	int ret = -1;
@@ -237,14 +237,19 @@ static int alloc_pagecache_50M_check(const char *cgroup, void *arg)
 		goto cleanup;
 
 	current = cg_read_long(cgroup, "memory.current");
-	if (current < size)
+	if (current < size) {
+		if (report)
+			fprintf(stderr, "memory.current %ld < expected %zu\n",
+				current, size);
 		goto cleanup;
+	}
 
 	file = cg_read_key_long(cgroup, "memory.stat", "file ");
 	if (file < 0)
 		goto cleanup;
 
-	if (!values_close_report(file, current, 10))
+	if (report ? !values_close_report(file, current, 10) :
+		     !values_close(file, current, 10))
 		goto cleanup;
 
 	ret = 0;
@@ -254,6 +259,20 @@ static int alloc_pagecache_50M_check(const char *cgroup, void *arg)
 	return ret;
 }
 
+static int alloc_pagecache_50M_check(const char *cgroup, void *arg)
+{
+	return __alloc_pagecache_50M_check(cgroup, true);
+}
+
+/*
+ * Same as alloc_pagecache_50M_check(), but silent on failure, for callers
+ * that expect the allocation to be held below 50M.
+ */
+static int alloc_pagecache_50M_check_quiet(const char *cgroup, void *arg)
+{
+	return __alloc_pagecache_50M_check(cgroup, false);
+}
+
 /*
  * This test create a memory cgroup, allocates
  * some anonymous memory and some pagecache
@@ -735,7 +754,7 @@ static int test_memcg_high(const char *root)
 	if (cg_run(memcg, alloc_anon, (void *)MB(31)))
 		goto cleanup;
 
-	if (!cg_run(memcg, alloc_pagecache_50M_check, NULL))
+	if (!cg_run(memcg, alloc_pagecache_50M_check_quiet, NULL))
 		goto cleanup;
 
 	if (cg_run(memcg, alloc_pagecache_max_30M, NULL))
-- 
2.51.0

