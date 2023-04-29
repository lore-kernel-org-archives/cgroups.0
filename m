From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 2/3] selftests: cgroup: Add 'malloc' failures checks in test_memcontrol
Date: Fri, 28 Apr 2023 21:59:03 -0400
Message-ID: <20230429015904.3027337-2-sashal@kernel.org>
References: <20230429015904.3027337-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682733549;
        bh=qbSmFjkxX3HUcFYifbkogWWlpPQjlc1XuGkAs7z+xus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyjLfX5LU5Ra+/SHIgAtTuJodvrFxA99Phw/909EJxlxDm4ZsCcLjN5AC/tjxXGxK
         42Nt81awIlq3B7nVDbWc0lFV8Kq4JVleAF8LebdtVzoI9JjukPd9w50whpqk/WeMcK
         5C9F7MUPuT+TIErq0IJAvBg4tFSI3iQngL1FGKbNEGd2HgDg6OA/fkAsY4iZWHFvNF
         9M1qBP/m6zqxPZTWBSjoBzPYoalTQ4Jy1s0jAarAOCzv1ZbSRbrUFr+zGdmlV8Ytbk
         8r4FFHpV/3sOkfcG2V15kvNe/1OBQ7UDcjME8xO1cfLEf8bk6+EvJzYKNjfUNHAXnx
         1yx/+ThfKVTbQ==
In-Reply-To: <20230429015904.3027337-1-sashal@kernel.org>
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
index 8833359556f38..fe4f9f4302822 100644
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
 
@@ -759,6 +769,11 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
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

