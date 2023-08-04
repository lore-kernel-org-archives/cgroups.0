From: Lucas Karpinski <lkarpins@redhat.com>
Subject: [PATCH] selftests: cgroup: fix test_kmem_memcg_deletion false
 positives
Date: Fri, 4 Aug 2023 11:37:33 -0400
Message-ID: <edpx3ejic2cxolhoynxvwal2i4a35akopg6hshcfxker6oxcn7@l32pzfyucgec>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691163465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=sWUCadNhtS5nrUCHR//9fr6i9W+VBU3reP6ArzIMKD4=;
        b=IXgb4SEGI77dtLPfazeZyb8o4OIt5EX0rKx3Ymw8vmT0cOtpzk9FCHwKofKSPUKGPqgo27
        AbpEKS5x1RPkIClfAlQhHrr97ZgQkXQ4njrVL7+Qoxg76PVUu1rlCT1jcAbba/SMeaNq4r
        Z5zPk3k7jncUHKJ+AP1XGANyEmFneYA=
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Shuah Khan <shuah@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org

The test allocates dcache inside a cgroup, then destroys the cgroups and
then checks the sanity of numbers on the parent level. The reason it
fails is because dentries are freed with an RCU delay - a debugging
sleep shows that usage drops as expected shortly after.

Insert a 1s sleep after completing the cgroup creation/deletions. This
should be good enough, assuming that machines running those tests are
otherwise not very busy. This commit is directly inspired by Johannes
over at the link below.

Link: https://lore.kernel.org/all/20230801135632.1768830-1-hannes@cmpxchg.org/

Signed-off-by: Lucas Karpinski <lkarpins@redhat.com>
---
 tools/testing/selftests/cgroup/test_kmem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 67cc0182058d..7ac384bbfdd5 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -183,6 +183,9 @@ static int test_kmem_memcg_deletion(const char *root)
 	if (cg_run_in_subcgroups(parent, alloc_kmem_smp, NULL, 100))
 		goto cleanup;
 
+	/* wait for RCU freeing */
+	sleep(1);
+
 	current = cg_read_long(parent, "memory.current");
 	slab = cg_read_key_long(parent, "memory.stat", "slab ");
 	anon = cg_read_key_long(parent, "memory.stat", "anon ");
-- 
2.41.0

