From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] memcg: expose root cgroup's memory.stat
Date: Fri,  8 May 2020 10:06:30 -0700
Message-ID: <20200508170630.94406-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BNj9Z6arsMIsAVorXWKDmEgiJTCFic/kTsm/LbalWf8=;
        b=cWd8iE2BULhsuzGBLhEY2ZykQklRkw+mBHU/UMcTu++CnkoD19Vwbyu9ZXAq+Hvjm3
         eKnZGz1RV/GJTLIu+z8x3At8UyE3gi6rwQ2pKfNtHATsjtlhYJDACFP5XqkImrYM4REU
         o+Cqrm1AXu9jkv3QQPIjtPsZLxcHhocu8oRlAndWoiWFd4gsXxte2X28wRZ3L6ck0q1U
         fbOVueB3efN0mUTnXzEm1dz447Ij8sdDOPniira68MQcgRhGm0xO5FH37HOmdlVHeoTl
         61LMlaKmNqqB299IJUdkAwrLrEj457QuNL3sBadYKkE8dCyJi8rIl7w0ts4Nwgy2jbxC
         Z4MQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yafang Shao <laoar.shao@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

One way to measure the efficiency of memory reclaim is to look at the
ratio (pgscan+pfrefill)/pgsteal. However at the moment these stats are
not updated consistently at the system level and the ratio of these are
not very meaningful. The pgsteal and pgscan are updated for only global
reclaim while pgrefill gets updated for global as well as cgroup
reclaim.

Please note that this difference is only for system level vmstats. The
cgroup stats returned by memory.stat are actually consistent. The
cgroup's pgsteal contains number of reclaimed pages for global as well
as cgroup reclaim. So, one way to get the system level stats is to get
these stats from root's memory.stat, so, expose memory.stat for the root
cgroup.

	from Johannes Weiner:
	There are subtle differences between /proc/vmstat and
	memory.stat, and cgroup-aware code that wants to watch the full
	hierarchy currently has to know about these intricacies and
	translate semantics back and forth.

	Generally having the fully recursive memory.stat at the root
	level could help a broader range of usecases.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 05dcb72314b5..c300d52c07a5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6230,7 +6230,6 @@ static struct cftype memory_files[] = {
 	},
 	{
 		.name = "stat",
-		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = memory_stat_show,
 	},
 	{
-- 
2.26.2.645.ge9eca65c58-goog

