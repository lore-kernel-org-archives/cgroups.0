From: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: remove unreachable code
Date: Wed,  7 Sep 2022 12:01:12 +0800
Message-ID: <20220907040112.82030-1-jiapeng.chong@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

The function sched_partition_show cannot execute seq_puts, delete the
invalid code.

kernel/cgroup/cpuset.c:2849 sched_partition_show() warn: ignoring unreachable code.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2087
Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Signed-off-by: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6baa977a71ba..b474289c15b8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2846,8 +2846,6 @@ static int sched_partition_show(struct seq_file *seq, void *v)
 		else
 			seq_printf(seq, "%s invalid\n", type);
 		break;
-		seq_puts(seq, "isolated invalid\n");
-		break;
 	}
 	return 0;
 }
-- 
2.20.1.7.g153144c

