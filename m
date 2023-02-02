From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Subject: [PATCH] mm: introduce entrance for root_mem_cgroup's current
Date: Thu, 2 Feb 2023 12:32:57 +0800
Message-ID: <1675312377-4782-1-git-send-email-zhaoyang.huang@unisoc.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Zhaoyang Huang <huangzhaoyang@gmail.com>, ke.wang@unisoc.com

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Introducing memory.root_current for the memory charges on root_mem_cgroup.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 mm/memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ab457f0..158d4232 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6681,6 +6681,11 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 
 static struct cftype memory_files[] = {
 	{
+		.name = "root_current",
+		.flags = CFTYPE_ONLY_ON_ROOT,
+		.read_u64 = memory_current_read,
+	},
+	{
 		.name = "current",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.read_u64 = memory_current_read,
-- 
1.9.1

