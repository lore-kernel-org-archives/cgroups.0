From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v2 3/4] selftests: cgroup: fix alloc_anon_noexit() instantly
 freeing memory
Date: Thu,  7 Apr 2022 22:42:43 +0000
Message-ID: <20220407224244.1374102-4-yosryahmed@google.com>
References: <20220407224244.1374102-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Jvjn52nSnpi6AIEmLCqBtZ2YPBYOJR0f93U1cJFGil4=;
        b=BlJpoAori7PwrN2hsipxJJDSi4wgn/as3nxmzLr88juJGOy2S6rEG7V00aGQgCSTHY
         ZNeLpQ7dvj8Hd8f2uKY3PM4t8YzG4U7hjFvVUweBLVzRLDlBEhe8BsgIzBcall+ZQJjb
         RPmHI1AgA0xcAWsHBU6nUBXP4j/Qs5Rx/E8Wr0LgywADaOrox9cPikVY7Zk5LHs9aJsI
         uYO5+DRm85pOBgmDgSagFEONAmNKfXh6jeWKiyIC0PTeAqnmLYDiGdO0cUmn3uUb8FMn
         RB6QH+QGMmuZ8QdxXV2+7mFdNZ7MiJOGD77KzHGBxmCz+qSG7OpNtheats4G2DMt9zSR
         UG6A==
In-Reply-To: <20220407224244.1374102-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Huang@google.com, Ying <ying.huang@intel.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Currently, alloc_anon_noexit() calls alloc_anon() which instantly frees
the allocated memory. alloc_anon_noexit() is usually used with
cg_run_nowait() to run a process in the background that allocates
memory. It makes sense for the background process to keep the memory
allocated and not instantly free it (otherwise there is no point of
running it in the background).

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 36ccf2322e21..c1ec71d83af7 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -211,13 +211,18 @@ static int alloc_pagecache_50M_noexit(const char *cgroup, void *arg)
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
 
+	printf("Freeing buffer");
+	free(buf);
 	return 0;
 }
 
-- 
2.35.1.1178.g4f1659d476-goog

