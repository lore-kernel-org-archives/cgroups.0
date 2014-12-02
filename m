From: Michele Curti <michele.curti@gmail.com>
Subject: [PATCH] mm/memcontrol: fix defined but not used compiler warning
Date: Tue, 2 Dec 2014 12:07:52 +0100
Message-ID: <20141202110752.GA11327@powerline.azcom-win.it>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=uwHcwg+3HXBsgUCl3xNs9lo0ZN8lweUiiwbQ9BOyOn8=;
        b=oSZHgJuDeqeeSoUPs1otN83CAlRVgcbwpYlGdzlgciCiTiYLhXdQZ9wFpDjWfSCzYi
         3bm+xWx4NZ5BsBsnCZ/HNHSTiuaTTLoyWV+jlQyjb7IAynaCFchcNTx4px7F8g2SWIpu
         Fvf5wKKhz4fFS+5TArTwhvGlJNEZ3LnHua7Ymhfz/tHEOnjSbM5vO3LkDbhmWvdwPhqb
         qJms7kcHA32mG4ARDDVR/DLuQV++ZtlX9Q9p7PaLJGZoeDx1hx9gtFIqLmqkdD9dAFhA
         t6ZiWDyXSVY4kJ6g8kMOeUP86/KjzOJFmB4mB5GgGxZZvoJgRoMWHEKQ4U+dSFVBL1hZ
         fgjg==
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@suse.cz
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

test_mem_cgroup_node_reclaimable is used only when MAX_NUMNODES > 1,
so move it into the compiler if statement

Signed-off-by: Michele Curti <michele.curti@gmail.com>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c6ac50e..84531a9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1615,6 +1615,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	oom_kill_process(chosen, gfp_mask, order, points, totalpages, memcg,
 			 NULL, "Memory cgroup out of memory");
 }
+#if MAX_NUMNODES > 1
 
 /**
  * test_mem_cgroup_node_reclaimable
@@ -1638,7 +1639,6 @@ static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
 	return false;
 
 }
-#if MAX_NUMNODES > 1
 
 /*
  * Always updating the nodemask is not very good - even if we have an empty
-- 
2.1.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
