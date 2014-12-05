From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: [PATCH] mm: memcontrol: Skip test_mem_cgroup_node_reclaimable() when
 no MAX_NUMNODES or not more than 1
Date: Sat, 06 Dec 2014 06:27:57 +0800
Message-ID: <5482316D.607@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        bh=jsWPaQ+NStinDzFYKFAA78JNUMWuB5tKJ5TrIHdRj1g=;
        b=FjI5KNsAZ0zXF3F2bqOO2/iqahHxbkp8LadYG80Q+DU6cdsDv+0zPU5uv1sSyfXFd3
         4AjcB4g9MJlbZEXZWkPqj1YGYKbIjeNWAC6ptu8ZajJVevruOPO0B3Z/Ac9tddhMeLi4
         D1uf/XD9VKNTLC5h/ypOrXexlEx3gNC/ew5kree9xwHWZX49fnCDiOUOXDQyxd8sz11L
         7R0rkOBhpJfAyJGraK715L+rofNe2cetoBaQSirClOuaXUtj7vXQeVtq4VA5I+/Ve+c7
         OMj+1S01P9pwrj/v3HnEEVu/ikUnNVP9V6aTMOcT+P3hoZCn7lfV5mc/4Ehh0bU39Ub/
         HVvg==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@suse.cz
Cc: cgroups@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org

test_mem_cgroup_node_reclaimable() is only used when "MAX_NUMNODES > 1",
so move it into related quote.

The related warning (with allmodconfig under parisc):

    CC      mm/memcontrol.o
  mm/memcontrol.c:1629:13: warning: 'test_mem_cgroup_node_reclaimable' defined but not used [-Wunused-function]
   static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
               ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c6ac50e..d538b08 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1616,6 +1616,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 NULL, "Memory cgroup out of memory");
 }
 
+#if MAX_NUMNODES > 1
 /**
  * test_mem_cgroup_node_reclaimable
  * @memcg: the target memcg
@@ -1638,7 +1639,6 @@ static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
 	return false;
 
 }
-#if MAX_NUMNODES > 1
 
 /*
  * Always updating the nodemask is not very good - even if we have an empty
-- 
1.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
