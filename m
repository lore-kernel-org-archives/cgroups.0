From: Jing Xia <jing.xia.mail@gmail.com>
Subject: [PATCH] mm: memcg: fix use after free in mem_cgroup_iter()
Date: Thu, 19 Jul 2018 18:06:47 +0800
Message-ID: <1531994807-25639-1-git-send-email-jing.xia@unisoc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RJhJrPg5vB3sWmzaN5lFkpQiPrD9UBbb70hv06tTUJ4=;
        b=LGi5d0BhcB4tPQcG26h5D5OhpGUIlojIG4lB+mcxmmVOvO9fCPITFBLoriP8vcRM7W
         SsWSt7yC/SnEFr/o6aB/TXMiOQmREPLLkqVa5BQFvTDvHSqGJWKSHaGIIoOkVWSwLQe1
         KrU0wVvvDtdKlLueIiTTlwC8f9qMVPrqUMQjeYLuW5iTo4fpjHZNHexVbV+EM0LVpTOq
         uIMpyC1AYUc5TB2AyPETwm+MSx45Xw6DmgVOf4eeZ0KblVQ0eJ01Cl3zaeH6bgLE6HIA
         JN//NmrgXYw978tqx4SOoLj6fblWI+Afadq0lwGc9HEvu2zDHC5F0Xe7PUecthW5qKvg
         GJgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com
Cc: chunyan.zhang@unisoc.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

It was reported that a kernel crash happened in mem_cgroup_iter(),
which can be triggered if the legacy cgroup-v1 non-hierarchical
mode is used.

Unable to handle kernel paging request at virtual address 6b6b6b6b6b6b8f
......
Call trace:
  mem_cgroup_iter+0x2e0/0x6d4
  shrink_zone+0x8c/0x324
  balance_pgdat+0x450/0x640
  kswapd+0x130/0x4b8
  kthread+0xe8/0xfc
  ret_from_fork+0x10/0x20

  mem_cgroup_iter():
      ......
      if (css_tryget(css))    <-- crash here
	    break;
      ......

The crashing reason is that mem_cgroup_iter() uses the memcg object
whose pointer is stored in iter->position, which has been freed before
and filled with POISON_FREE(0x6b).

And the root cause of the use-after-free issue is that
invalidate_reclaim_iterators() fails to reset the value of
iter->position to NULL when the css of the memcg is released in non-
hierarchical mode.

Signed-off-by: Jing Xia <jing.xia.mail@gmail.com>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e6f0d5e..8c0280b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -850,7 +850,7 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
 	int nid;
 	int i;
 
-	while ((memcg = parent_mem_cgroup(memcg))) {
+	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
 		for_each_node(nid) {
 			mz = mem_cgroup_nodeinfo(memcg, nid);
 			for (i = 0; i <= DEF_PRIORITY; i++) {
-- 
1.9.1

