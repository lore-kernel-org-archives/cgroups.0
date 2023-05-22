From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH 2/2] selftests: cgroup: fix unexpected failure on test_memcg_low
Date: Mon, 22 May 2023 09:52:33 +0000
Message-ID: <20230522095233.4246-2-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1684749203; x=1687341203;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hnIfipm8ADmVcPlfJeR2m6dzYHlF2xT+Sv9iRF6t3cY=;
        b=AOzpCt/R5/HiWo6POXCM45SpS08bNlo11NcaKUQY8fbE74t46SQzwFReeowIfN1QBH
         k42Pa4PS1GDGK68evYz8AKEVOtCHJrI1Ycb8tBHltfRKXUCfVX1cpN31oU4AKAUV/v3b
         atvu/X/oySVxlD9Eqt4fOQR6IS55Z8JZhWRWfm2AikBq/n8wh3FmecrWs6Y5Ev6ljHfQ
         u2sjZwIfVdOOAmurBV6Mx3WGS2fliHR2vLyTGHn7M5FHSLYPQ+zCv1C2h3ehMN+xzzZF
         3022G70xrM3eiXml5jDArQFZrTLKq5hqXeoebTIw7Z+yxmB0sA3rMeGeSB+1U4Ak/wmv
         Xm/w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko@kernel.org
Cc: roman.gushchin@linux.dev, hannes@cmpxchg.org, shakeelb@google.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Haifeng Xu <haifeng.xu@shopee.com>

Since commit f079a020ba95 ("selftests: memcg: factor out common parts
of memory.{low,min} tests"), the value used in second alloc_anon has
changed from 148M to 170M. Because memory.low allows reclaiming page
cache in child cgroups, so the memory.current is close to 30M instead
of 50M. Therefore, adjust the expected value of parent cgroup.

Fixes: f079a020ba95 ("selftests: memcg: factor out common parts of memory.{low,min} tests")
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index f4f7c0aef702..a2a90f4bfe9f 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -292,6 +292,7 @@ static int test_memcg_protection(const char *root, bool min)
 	char *children[4] = {NULL};
 	const char *attribute = min ? "memory.min" : "memory.low";
 	long c[4];
+	long current;
 	int i, attempts;
 	int fd;
 
@@ -400,7 +401,8 @@ static int test_memcg_protection(const char *root, bool min)
 		goto cleanup;
 	}
 
-	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
+	current = min ? MB(50) : MB(30);
+	if (!values_close(cg_read_long(parent[1], "memory.current"), current, 3))
 		goto cleanup;
 
 	if (!reclaim_until(children[0], MB(10)))
-- 
2.25.1

