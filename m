From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v5 3/4] selftests: cgroup: fix alloc_anon_noexit() instantly
 freeing memory
Date: Mon, 25 Apr 2022 19:00:39 +0000
Message-ID: <20220425190040.2475377-4-yosryahmed@google.com>
References: <20220425190040.2475377-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eqHPhXVFsY1aWd5kzuU1eL2wsGrZ6tPFgC+x7Ju6qxo=;
        b=PBg+H68ojw1koOQnEJrZ6MMtj1acWkPTyAwFIkSY0wqW+D0Ubjw5x2Ksetg2ivOCuZ
         5+tPJvp8xXIWyTgLtC+OXULAzhoJB2tO+3NY5OZB2VK0H+IoAxoJ8VoDcAmflY6BOnuZ
         drcAFgQM1a/JXp2LFIgumdKBshtSyBa72bu7b+fT/jUHqCsFpJwyLx4jLvX1rBMK8Z4s
         SzNgZFO9Pt8mEDE9EBL/QcCwmtAnQ/dCvFYOcWA5AQ4H3e0AstKYC+NIlkg1m6J2jkIK
         +O74AyMLPo8rXFTpkOOt9jzBOKCtuVYM0QLUxRJQhzNOwiQgVR+/6fI4u/oBy+9Lpov5
         1sZg==
In-Reply-To: <20220425190040.2475377-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Currently, alloc_anon_noexit() calls alloc_anon() which instantly frees
the allocated memory. alloc_anon_noexit() is usually used with
cg_run_nowait() to run a process in the background that allocates
memory. It makes sense for the background process to keep the memory
allocated and not instantly free it (otherwise there is no point of
running it in the background).

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeelb@google.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 36ccf2322e21..f2ffb3a30194 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -211,13 +211,17 @@ static int alloc_pagecache_50M_noexit(const char *cgroup, void *arg)
 static int alloc_anon_noexit(const char *cgroup, void *arg)
 {
 	int ppid = getppid();
+	size_t size = (unsigned long)arg;
+	char *buf, *ptr;
 
-	if (alloc_anon(cgroup, arg))
-		return -1;
+	buf = malloc(size);
+	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+		*ptr = 0;
 
 	while (getppid() == ppid)
 		sleep(1);
 
+	free(buf);
 	return 0;
 }
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

