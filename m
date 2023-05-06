From: chengkaitao <chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
Subject: [PATCH v3 2/2] memcg: add oom_kill_inherit event indicator
Date: Sat, 6 May 2023 19:49:48 +0800
Message-ID: <20230506114948.6862-3-chengkaitao@didiglobal.com>
References: <20230506114948.6862-1-chengkaitao@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230506114948.6862-1-chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Liam.Howlett-Onf44Ee+mfbQT0dZR+AlfA@public.gmane.org, chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sujiaxun-xX5NlYq76+e1Z/+hSey0Gg@public.gmane.org, feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

From: chengkaitao <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Oom_kill_inherit can reflect the number of child cgroups selected by
the parent cgroup's OOM killer. We can refer to the proportion of the
indicator to adjust the value of oom_protect. The larger oom_protect,
the smaller oom_kill_inherit.

Signed-off-by: chengkaitao <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 4 ++++
 include/linux/memcontrol.h              | 1 +
 mm/memcontrol.c                         | 6 ++++++
 3 files changed, 11 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 51e9a84d508a..e6f56443d049 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1358,6 +1358,10 @@ PAGE_SIZE multiple when read back.
 		The number of processes belonging to this cgroup
 		killed by any kind of OOM killer.
 
+	  oom_kill_inherit
+		The number of processes belonging to this cgroup
+		killed by all Ancestral memcg's OOM killer.
+
           oom_group_kill
                 The number of times a group OOM has occurred.
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 23ea28d98c0e..d7797f9a0605 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -46,6 +46,7 @@ enum memcg_memory_event {
 	MEMCG_MAX,
 	MEMCG_OOM,
 	MEMCG_OOM_KILL,
+	MEMCG_OOM_INHERIT,
 	MEMCG_OOM_GROUP_KILL,
 	MEMCG_SWAP_HIGH,
 	MEMCG_SWAP_MAX,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5a382359ed49..47e7647d8d7e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2129,6 +2129,10 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 
 		if (memcg == oom_domain)
 			break;
+		/* we use oom.group's logic to update the OOM_INHERIT indicator,
+		 * but OOM_INHERIT and oom.group are independent of each other.
+		 */
+		memcg_memory_event(memcg, MEMCG_OOM_INHERIT);
 	}
 
 	if (oom_group)
@@ -6622,6 +6626,8 @@ static void __memory_events_show(struct seq_file *m, atomic_long_t *events)
 	seq_printf(m, "oom %lu\n", atomic_long_read(&events[MEMCG_OOM]));
 	seq_printf(m, "oom_kill %lu\n",
 		   atomic_long_read(&events[MEMCG_OOM_KILL]));
+	seq_printf(m, "oom_kill_inherit %lu\n",
+		   atomic_long_read(&events[MEMCG_OOM_INHERIT]));
 	seq_printf(m, "oom_group_kill %lu\n",
 		   atomic_long_read(&events[MEMCG_OOM_GROUP_KILL]));
 }
-- 
2.14.1

