From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Thu, 30 Apr 2020 11:27:12 -0700
Message-ID: <20200430182712.237526-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Jd1/haHiGLsB9DtO70aA7TDJJ8F7SbAfwTGIrfE2+1I=;
        b=iErXb3iypgOLBQLKzSmwYHMdYYIq4FQ/Fs5O99JN5OVPg/URrWQYpUpa4kY7FYf/BC
         XiR39ubKq+M9XC9dm4+/NQtJp45w0zaUOcxMguhS1TnX7J/535wLELSBBjUKWJ1dWqE6
         iO6IpODegKvCUHTwKkjF0rYnv7hlPTcyspEUr8iVEgu2zy0g1ZGqrG9JyyK0cqlnx0xy
         hfdzksqUkq3dN7eAwinITbGyet9pI6lrH090wPE8vGhavh9k/dzJUFPKlX79cfP3D+ls
         gIS1rabZP18mssvRf0qDpla0A4w7qoWT35CVtPk8OJxUx9mN9fMmyxMODtpX9appu2eY
         Js8g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>
Cc: Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

Lowering memory.max can trigger an oom-kill if the reclaim does not
succeed. However if oom-killer does not find a process for killing, it
dumps a lot of warnings.

Deleting a memcg does not reclaim memory from it and the memory can
linger till there is a memory pressure. One normal way to proactively
reclaim such memory is to set memory.max to 0 just before deleting the
memcg. However if some of the memcg's memory is pinned by others, this
operation can trigger an oom-kill without any process and thus can log a
lot un-needed warnings. So, ignore all such warnings from memory.max.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 include/linux/oom.h | 3 +++
 mm/memcontrol.c     | 9 +++++----
 mm/oom_kill.c       | 2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index c696c265f019..6345dc55df64 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -52,6 +52,9 @@ struct oom_control {
 
 	/* Used to print the constraint info. */
 	enum oom_constraint constraint;
+
+	/* Do not warn even if there is no process to be killed. */
+	bool no_warn;
 };
 
 extern struct mutex oom_lock;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 317dbbaac603..a1f00d9b9bb0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1571,7 +1571,7 @@ unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
 }
 
 static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				     int order)
+				     int order, bool no_warn)
 {
 	struct oom_control oc = {
 		.zonelist = NULL,
@@ -1579,6 +1579,7 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		.memcg = memcg,
 		.gfp_mask = gfp_mask,
 		.order = order,
+		.no_warn = no_warn,
 	};
 	bool ret;
 
@@ -1821,7 +1822,7 @@ static enum oom_status mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int
 		mem_cgroup_oom_notify(memcg);
 
 	mem_cgroup_unmark_under_oom(memcg);
-	if (mem_cgroup_out_of_memory(memcg, mask, order))
+	if (mem_cgroup_out_of_memory(memcg, mask, order, false))
 		ret = OOM_SUCCESS;
 	else
 		ret = OOM_FAILED;
@@ -1880,7 +1881,7 @@ bool mem_cgroup_oom_synchronize(bool handle)
 		mem_cgroup_unmark_under_oom(memcg);
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 		mem_cgroup_out_of_memory(memcg, current->memcg_oom_gfp_mask,
-					 current->memcg_oom_order);
+					 current->memcg_oom_order, false);
 	} else {
 		schedule();
 		mem_cgroup_unmark_under_oom(memcg);
@@ -6106,7 +6107,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		}
 
 		memcg_memory_event(memcg, MEMCG_OOM);
-		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
+		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0, true))
 			break;
 	}
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 463b3d74a64a..5ace39f6fe1e 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1098,7 +1098,7 @@ bool out_of_memory(struct oom_control *oc)
 
 	select_bad_process(oc);
 	/* Found nothing?!?! */
-	if (!oc->chosen) {
+	if (!oc->chosen && !oc->no_warn) {
 		dump_header(oc, NULL);
 		pr_warn("Out of memory and no killable processes...\n");
 		/*
-- 
2.26.2.526.g744177e7f7-goog

