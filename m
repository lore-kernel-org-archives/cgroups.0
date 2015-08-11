From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] memcg: generate file modified notifications on "memory.events"
Date: Tue, 11 Aug 2015 13:58:09 -0400
Message-ID: <1439315889-3492-9-git-send-email-tj@kernel.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jWAsYEVLB8eWd0Y5xHkwoCpVVyBmpVlpmlT4Q1FMdQ0=;
        b=yO1u1Im+A1ESsQodyOAvMzKF2E9KPTb8tOimP8DBljueV8h/nSF3AXMe0oOK1s7JLB
         vnFM7QGOuQAv4V/a/7JAg8xWot1c4eDSiLjpykgTcyENfr9AYg+bJ9enMeBbWVW/Bc+8
         iNRMKZMGy0xr0Kpd414OA2dMJfitr9NEmRoKcTw+TojjvxIJYTDOO+ecWGg9T41tM7hX
         Tu1y0+GIqCBRuwmjZ0QnDDUXp1N/UNixmEwG+sFjjmZVtLhrWssk+4egJd8O2zySIBKK
         LGP17X2rknN7h15yOka7N8/ls7R6q0m6yOKcgw87iV4h0sROrOxriZCPFb31GSLfMcUr
         kEVA==
In-Reply-To: <1439315889-3492-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, lizefan@huawei.com
Cc: mhocko@kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

cgroup core only recently grew generic notification support.  Wire up
"memory.events" so that it triggers a file modified event whenever its
content changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
---
 mm/memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 78ba418..10db5f1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -295,6 +295,9 @@ struct mem_cgroup {
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
+	/* handle for "memory.events" */
+	struct cgroup_file events_file;
+
 	/* protect arrays of thresholds */
 	struct mutex thresholds_lock;
 
@@ -5499,6 +5502,7 @@ static struct cftype memory_files[] = {
 	{
 		.name = "events",
 		.flags = CFTYPE_NOT_ON_ROOT,
+		.file_offset = offsetof(struct mem_cgroup, events_file),
 		.seq_show = memory_events_show,
 	},
 	{ }	/* terminate */
@@ -5530,6 +5534,7 @@ void mem_cgroup_events(struct mem_cgroup *memcg,
 		       unsigned int nr)
 {
 	this_cpu_add(memcg->stat->events[idx], nr);
+	cgroup_file_notify(&memcg->events_file);
 }
 
 /**
-- 
2.4.3
