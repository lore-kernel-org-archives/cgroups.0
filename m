From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] mm: memcontrol: fix data race in mem_cgroup_select_victim_node
Date: Mon, 28 Oct 2019 17:54:05 -0700
Message-ID: <20191029005405.201986-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CJNyfCkSt7mazdpKxm+NauccC7aNCXbzHO2WmG+WXZI=;
        b=VNIhRIVznNTE4231t1PB9Y892IckjdElWezZZVpfEZj80/mzanDBafaCAPwbWdo/2+
         A2IlnsRAL2Blt3IvIwX0ISb+ZmFwG9yrBZ55rX1/xuj9NUAqSD3FHneUmyprKlV5yl3q
         tTlgF3TG2RXMaFaXAlfpSDe9OiAODZDJ/pnsUOZfcjt++CXArvZZTjQ5fY2m5Jz4KDJj
         UImudqlau9RYfYGT+aEy1/m9RTwJwhjIFgij71FJyZX0avIJ5/L6Yy34dJ5ovk87MzOg
         vpUccTmI91a3yMxtIvMawk0rByNgb7F2mUfDUfz6Bqs+0lifTZdjCcjDQGftK7LTeiXB
         t6Tw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Eric Dumazet <edumazet@google.com>, Greg Thelen <gthelen@google.com>, syzbot+13f93c99c06988391efe@syzkaller.appspotmail.com

Syzbot reported the following bug:

BUG: KCSAN: data-race in mem_cgroup_select_victim_node / mem_cgroup_select_victim_node

write to 0xffff88809fade9b0 of 4 bytes by task 8603 on cpu 0:
 mem_cgroup_select_victim_node+0xb5/0x3d0 mm/memcontrol.c:1686
 try_to_free_mem_cgroup_pages+0x175/0x4c0 mm/vmscan.c:3376
 reclaim_high.constprop.0+0xf7/0x140 mm/memcontrol.c:2349
 mem_cgroup_handle_over_high+0x96/0x180 mm/memcontrol.c:2430
 tracehook_notify_resume include/linux/tracehook.h:197 [inline]
 exit_to_usermode_loop+0x20c/0x2c0 arch/x86/entry/common.c:163
 prepare_exit_to_usermode+0x180/0x1a0 arch/x86/entry/common.c:194
 swapgs_restore_regs_and_return_to_usermode+0x0/0x40

read to 0xffff88809fade9b0 of 4 bytes by task 7290 on cpu 1:
 mem_cgroup_select_victim_node+0x92/0x3d0 mm/memcontrol.c:1675
 try_to_free_mem_cgroup_pages+0x175/0x4c0 mm/vmscan.c:3376
 reclaim_high.constprop.0+0xf7/0x140 mm/memcontrol.c:2349
 mem_cgroup_handle_over_high+0x96/0x180 mm/memcontrol.c:2430
 tracehook_notify_resume include/linux/tracehook.h:197 [inline]
 exit_to_usermode_loop+0x20c/0x2c0 arch/x86/entry/common.c:163
 prepare_exit_to_usermode+0x180/0x1a0 arch/x86/entry/common.c:194
 swapgs_restore_regs_and_return_to_usermode+0x0/0x40

mem_cgroup_select_victim_node() can be called concurrently which reads
and modifies memcg->last_scanned_node without any synchrnonization. So,
read and modify memcg->last_scanned_node with READ_ONCE()/WRITE_ONCE()
to stop potential reordering.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: Greg Thelen <gthelen@google.com>
Reported-by: syzbot+13f93c99c06988391efe@syzkaller.appspotmail.com
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c4c555055a72..5a06739dd3e4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1667,7 +1667,7 @@ int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
 	int node;
 
 	mem_cgroup_may_update_nodemask(memcg);
-	node = memcg->last_scanned_node;
+	node = READ_ONCE(memcg->last_scanned_node);
 
 	node = next_node_in(node, memcg->scan_nodes);
 	/*
@@ -1678,7 +1678,7 @@ int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
 	if (unlikely(node == MAX_NUMNODES))
 		node = numa_node_id();
 
-	memcg->last_scanned_node = node;
+	WRITE_ONCE(memcg->last_scanned_node, node);
 	return node;
 }
 #else
-- 
2.24.0.rc0.303.g954a862665-goog

