From: Hui Zhu <teawater@gmail.com>
Subject: [RFC] memcg: Add swappiness to cgroup2
Date: Wed, 25 Dec 2019 13:36:48 +0800
Message-ID: <1577252208-32419-1-git-send-email-teawater@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org
Cc: Hui Zhu <teawater@gmail.com>, Hui Zhu <teawaterz@linux.alibaba.com>

Even if cgroup2 has swap.max, swappiness is still a very useful config.
This commit add swappiness to cgroup2.

Signed-off-by: Hui Zhu <teawaterz@linux.alibaba.com>
---
 mm/memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c5b5f74..e966396 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7143,6 +7143,11 @@ static struct cftype swap_files[] = {
 		.file_offset = offsetof(struct mem_cgroup, swap_events_file),
 		.seq_show = swap_events_show,
 	},
+	{
+		.name = "swappiness",
+		.read_u64 = mem_cgroup_swappiness_read,
+		.write_u64 = mem_cgroup_swappiness_write,
+	},
 	{ }	/* terminate */
 };
 
-- 
2.7.4

