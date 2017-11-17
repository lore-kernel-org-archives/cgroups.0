From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH] mm/shmem: set default tmpfs size according to memcg limit
Date: Fri, 17 Nov 2017 03:09:59 +0000
Message-ID: <1510888199-5886-1-git-send-email-laoar.shao@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=52bt+Zxw0Bdm6Jyhfur1mjFpF4gEblymnQogxCM9vkI=;
        b=HaL2SX2WNqoMkOoFW4Sd7kDLm14z6VzHU9dhryOpVN9C96kNI2NTbTTU2kweWk+L9r
         51sWQdlmhPWo9/C2xrPSidDY2NfSr9zXmxeCUkCJQQMPDFnBhaFG64zp/BzVfyG37AP0
         BJLKouDSoU0rKWzwyUHMQrD2RNNsoYafiq2rzqYLf7q6pmBrIzRDVXUYDiqihhOX+l9F
         2eAJgMc+iFnT3F/fpNOyXLnW3GZV3DIIoSt+MmLvIlaDmJPS3rJXDOL5rwk3Z9OQGPGX
         p/dLYoNjDl/+tYA3CGQg+wiS5WkDMcCXFVIYDJJEOChyJGy/Ag0Hzh+ZkF2i2T+gzmgM
         eZGw==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com, mhocko@suse.com, tj@kernel.org, guro@fb.com, khlebnikov@yandex-team.ru, mka@chromium.org, hughd@google.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>

Currently the default tmpfs size is totalram_pages / 2 if mount tmpfs
without "-o size=XXX".
When we mount tmpfs in a container(i.e. docker), it is also
totalram_pages / 2 regardless of the memory limit on this container.
That may easily cause OOM if tmpfs occupied too much memory when swap is
off.
So when we mount tmpfs in a memcg, the default size should be limited by
the memcg memory.limit.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            |  2 +-
 mm/shmem.c                 | 20 +++++++++++++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69966c4..79c6709 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -265,6 +265,7 @@ struct mem_cgroup {
 	/* WARNING: nodeinfo must be the last member here */
 };
 
+extern struct mutex memcg_limit_mutex;
 extern struct mem_cgroup *root_mem_cgroup;
 
 static inline bool mem_cgroup_disabled(void)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 661f046..ad32f3c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2464,7 +2464,7 @@ static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
 }
 #endif
 
-static DEFINE_MUTEX(memcg_limit_mutex);
+DEFINE_MUTEX(memcg_limit_mutex);
 
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 				   unsigned long limit)
diff --git a/mm/shmem.c b/mm/shmem.c
index 07a1d22..1c320dd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -35,6 +35,7 @@
 #include <linux/uio.h>
 #include <linux/khugepaged.h>
 #include <linux/hugetlb.h>
+#include <linux/memcontrol.h>
 
 #include <asm/tlbflush.h> /* for arch/microblaze update_mmu_cache() */
 
@@ -108,7 +109,24 @@ struct shmem_falloc {
 #ifdef CONFIG_TMPFS
 static unsigned long shmem_default_max_blocks(void)
 {
-	return totalram_pages / 2;
+	unsigned long size;
+
+#ifdef CONFIG_MEMCG
+	struct mem_cgroup *memcg = mem_cgroup_from_task(current);
+
+	if (memcg == NULL || memcg == root_mem_cgroup)
+		size = totalram_pages / 2;
+	else {
+		mutex_lock(&memcg_limit_mutex);
+		size = memcg->memory.limit > totalram_pages ?
+				 totalram_pages / 2 : memcg->memory.limit / 2;
+		mutex_unlock(&memcg_limit_mutex);
+	}
+#else
+	size = totalram_pages / 2;
+#endif
+
+	return size;
 }
 
 static unsigned long shmem_default_max_inodes(void)
-- 
1.8.3.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
