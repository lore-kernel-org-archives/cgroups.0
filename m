Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1126637E5E7
	for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 05:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790401922; cv=none; b=arK6623NIAwhXWQb+ZrvvqQH5LsBB0/JMChnJofpFzfZi8TUnNbRWqyhZYCgZEwjw25/omYXppiLeH/+xei5y1PfhI81LZ6AvgKjxx5us4yhkML78pHyVdGjeyv1oltIVRtPWacG7hPGwnxgrcyx1LwnURbmAxhuufydZIafjxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790401922; c=relaxed/simple;
	bh=tWXmnir3aF9HZ+kf5/3hY0M3VXhh0dKm46bCuC6qUT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPx0rME7pxEUY9CdDkBzV8CaKj2KP408YreYvpvYp/88n0S65AAf3/4MvcDwLP6jmkYsj63FtKcQ5/GCpOsb6urqJHck8jiGNsSfrdxU/BbOEEVPuKZgDZ6H7tmdx4yyS8f9tVXd1CNtt9aYl2YHe67kYSMHHNrnfIA+eRGlauE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XI2QF1mG; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XI2QF1mG"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-488885c3844so96976f8f.0
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 22:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790401919; x=1791006719; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yi4dRtWZ8QVTscHUglSUHWaqYAQ6yrmnxvkOKTaKUMQ=;
        b=XI2QF1mGG/t18OHANjvdz6ONEx5kDBGyV6zb+HVqRD/DHFcCJwPV0yjI/y0M0IN/fY
         5WbGFc42Mv36r4GC0NjbUsHA/dSh/cKca5v8Onz9snaQV4cf71PXiVcdAK4+4RNJQEoL
         NrfquA16e9i+4LSdFWTXfeaghdSqe+0nIW7+PfZKwBsoXHxnZDdM3uEmkvRyXysfYI4Z
         2/eayRu5U3KzzhCY4EQb/yZwn7os+3os9hdvKXVo0jpT9DNa2+YAopoO1xsFZ17pV5DO
         k5utq6CpReUlEk4EUyAT4JqpWe4W/WyGy7orekQfBKw6rLvHBr3SRanM8IYx8CLmjTwq
         CH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790401919; x=1791006719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yi4dRtWZ8QVTscHUglSUHWaqYAQ6yrmnxvkOKTaKUMQ=;
        b=DO9/VpibeSlDZ8H2peAz1CJwGFov4Bqt51Xx5NlkF9S1bAxDI2kIxUSi7BlNxPQNZM
         nHo2h+OOmGRXlE4B9nZ1GYqStjwIVvJvUWvImpH4aEQrQ+y8ZwbN85eJkCHPnbhERrG/
         JfNhASfeA5IymzHR01QdRoTgi8k8fawCSBMHtbihadF5oITb2OG3T5V28S568t5bfOf/
         /pGT7wpsX8W2CzNe25K6r4hHSUDa39HLqfDYjXP6dk+IEVZIOLAGPUh1csZDRhESQmuA
         rB2eDydLQnVhJSeo3oGMbzmDwa9RvM7Z75uH3qbjeJgXJb4vU7XNbbcqzC9JQop1aCYX
         KHuA==
X-Forwarded-Encrypted: i=1; AKwUvBxNxmlOLYYqu91MG+XI+bf18LBragnVFfFChtkfdSC6ezaQd0UC0ttaY7mkItLqXX/hGO+Vl8Zd@vger.kernel.org
X-Gm-Message-State: AFuF++m+pwkBTQXshqiZBZLDJRIOefVfxBdKbXL2VAu/joZSyofKwN9/
	AFzsg/J6lveOtN5szlu88pWjpepRtBJxAuHicuL/aF9AeCPEdjq6qzp1
X-Gm-Gg: AYBFou3kiF/QIEXoI13hKm7gIKjIEEBll8ECNXXMDLyYZli+HJ642pprVcJyfQgaRcE
	8tw1NVbsStSkd/2w9eQSjLguPfxheQWRUx3Xpc4scQ25vBwJH6aaVfAN1bqY4mm7vYxftXXCKx4
	WoojVC/xwmKuCtgTkAy+w3NqX4nbJEqq4H4FnQZt7GPuru7BePko8P03iR9qeVnih8nvF07AhjC
	tvf4IZJwqlnG4NEnPOnz7N1Cq+Z+DsDgxBKv/tXOXAvpn/SZ4KJogCSNF2fo8et8OrkoH4u/xdS
	1xFEPRr3mkiQF/YLMDc+4XGKrWHpiYMk/aNkYmIG6f+7CqJZN7hdfnkjFdMs/1Axersx5o2Y14o
	EaAfTW7SrSYVjVbvzcv5pf+cxBHCxBRNsqCPs1mEVuWpDd1awiD1ezcV2rhAw6y+u5KkOKrLVXf
	nThnnJKLMi5avSZKBV6JW8+uJHPS5u0mnwOq+OUMjjeSePcwAwoh23qlPC/sdppC6VteKbzqxgb
	/Nri/6xtnAZxCcM1ID05uztI1WKvWxX6K/DE8c4e3OG
X-Received: by 2002:a05:6000:4b19:b0:488:8882:d504 with SMTP id ffacd0b85a97d-4888882d749mr1189407f8f.10.1790401919190;
        Fri, 25 Sep 2026 22:51:59 -0700 (PDT)
Received: from localhost.suse.org ([37.109.167.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a30bcc4sm12317560f8f.1.2026.09.25.22.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 22:51:59 -0700 (PDT)
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
Subject: [PATCH v2 1/2] selftests: cgroup: Use values_close_report in test_memcontrol
Date: Sat, 26 Sep 2026 07:51:47 +0200
Message-ID: <20260926055152.1684-2-sebastian.chlad@suse.com>
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

Convert the terminal tolerance checks in test_memcontrol to
values_close_report() so that a failure prints the observed and
expected values instead of failing silently. Also report the
"memory.current < size" check in alloc_anon_50M_check().

values_close() is kept where it is used as a loop or retry condition
(waiting for usage to settle in test_memcg_protection(), reclaim_until(),
the reclaim retry loop and the socket test), since a mismatch there is
expected and reporting it would print spurious failures.

Assisted-by: claude-opus-5-5
Signed-off-by: Sebastian Chlad <sebastian.chlad@suse.com>
---
 .../selftests/cgroup/test_memcontrol.c        | 25 +++++++++++--------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ed82347044e..8882c7faeb32 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -200,17 +200,20 @@ static int alloc_anon_50M_check(const char *cgroup, void *arg)
 		return -1;
 
 	current = cg_read_long(cgroup, "memory.current");
-	if (current < size)
+	if (current < size) {
+		fprintf(stderr, "memory.current %ld < expected %zu\n",
+			current, size);
 		goto cleanup;
+	}
 
-	if (!values_close(size, current, 3))
+	if (!values_close_report(current, size, 3))
 		goto cleanup;
 
 	anon = cg_read_key_long(cgroup, "memory.stat", "anon ");
 	if (anon < 0)
 		goto cleanup;
 
-	if (!values_close(anon, current, 3))
+	if (!values_close_report(anon, current, 3))
 		goto cleanup;
 
 	ret = 0;
@@ -241,7 +244,7 @@ static int alloc_pagecache_50M_check(const char *cgroup, void *arg)
 	if (file < 0)
 		goto cleanup;
 
-	if (!values_close(file, current, 10))
+	if (!values_close_report(file, current, 10))
 		goto cleanup;
 
 	ret = 0;
@@ -578,16 +581,16 @@ static int test_memcg_protection(const char *root, bool min)
 	if (cg_run(parent[2], alloc_anon, (void *)MB(148)))
 		goto cleanup;
 
-	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
+	if (!values_close_report(cg_read_long(parent[1], "memory.current"), MB(50), 3))
 		goto cleanup;
 
 	for (i = 0; i < ARRAY_SIZE(children); i++)
 		c[i] = cg_read_long(children[i], "memory.current");
 
-	if (!values_close(c[0], MB(29), 15))
+	if (!values_close_report(c[0], MB(29), 15))
 		goto cleanup;
 
-	if (!values_close(c[1], MB(21), 20))
+	if (!values_close_report(c[1], MB(21), 20))
 		goto cleanup;
 
 	if (c[3] != 0)
@@ -603,7 +606,7 @@ static int test_memcg_protection(const char *root, bool min)
 	}
 
 	current = min ? MB(50) : MB(30);
-	if (!values_close(cg_read_long(parent[1], "memory.current"), current, 3))
+	if (!values_close_report(cg_read_long(parent[1], "memory.current"), current, 3))
 		goto cleanup;
 
 	if (!reclaim_until(children[0], MB(10)))
@@ -691,7 +694,7 @@ static int alloc_pagecache_max_30M(const char *cgroup, void *arg)
 		goto cleanup;
 
 	current = cg_read_long(cgroup, "memory.current");
-	if (!values_close(current, MB(30), 5))
+	if (!values_close_report(current, MB(30), 5))
 		goto cleanup;
 
 	ret = 0;
@@ -1006,12 +1009,12 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 		return -1;
 
 	mem_current = cg_read_long(cgroup, "memory.current");
-	if (!mem_current || !values_close(mem_current, mem_max, 3))
+	if (!mem_current || !values_close_report(mem_current, mem_max, 3))
 		goto cleanup;
 
 	swap_current = cg_read_long(cgroup, "memory.swap.current");
 	if (!swap_current ||
-	    !values_close(mem_current + swap_current, size, 3))
+	    !values_close_report(mem_current + swap_current, size, 3))
 		goto cleanup;
 
 	ret = 0;
-- 
2.51.0

