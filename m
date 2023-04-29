From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.3 2/3] selftests: cgroup: Add 'malloc' failures checks in test_memcontrol
Date: Fri, 28 Apr 2023 21:58:49 -0400
Message-ID: <20230429015850.3027243-2-sashal@kernel.org>
References: <20230429015850.3027243-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682733535;
        bh=zoqRFyKFzbksP21+pdzLOmw6DiAmo5NhTPCpktIbKRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETVDfQFp8Y+vqBcpJB0h6XagxYvEvbxh1PkzPxgRG1b+6CCRO7Kk199Xy0lCPNVqm
         pCZ2dw12DVGn879IctYEsZ1I8edMf5Ss8TCeUNJH1wVGbX4ljWwdf71JeHlfAGspLt
         blPGIoX5SCee7xa9ULddDdizlNZc7krtA4mq9Zv6bAYlb8ZgKnrxZv5FVbcxv91x6o
         l1EQDexyIEUaVLmTbiEMGygjFm31IbNgTwUxDBDmmRWARFTe69w+quRzQ86ngZnqxV
         C88+zHDRm2o+GPxkI+QsZuvqu1xLleeIwXvwncwrUutVicljSecRUgiTIiHR8Unbdv
         0wqLTVp9938fA==
In-Reply-To: <20230429015850.3027243-1-sashal@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ivan Orlov <ivan.orlov0322@gmail.com>, Muchun Song <songmuchun@bytedance.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, hannes@cmpxchg.org, mhocko@kernel.org, tj@kernel.org, lizefan.x@bytedance.com, shuah@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org

From: Ivan Orlov <ivan.orlov0322@gmail.com>

[ Upstream commit c83f320e55a49abd90629f42a72897afd579e0de ]

There are several 'malloc' calls in test_memcontrol, which can be
unsuccessful. This patch will add 'malloc' failures checking to
give more details about test's fail reasons and avoid possible
undefined behavior during the future null dereference (like the
one in alloc_anon_50M_check_swap function).

Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 1e616a8c6a9cf..f4f7c0aef702b 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -98,6 +98,11 @@ static int alloc_anon_50M_check(const char *cgroup, void *arg)
 	int ret = -1;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
@@ -211,6 +216,11 @@ static int alloc_anon_noexit(const char *cgroup, void *arg)
 	char *buf, *ptr;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
@@ -778,6 +788,11 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 	int ret = -1;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
-- 
2.39.2

