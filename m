From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/10] cpuset: re-structure update_cpumask() a bit
Date: Fri, 19 Apr 2013 20:27:27 +0800
Message-ID: <5171382F.709@huawei.com>
References: <517137A7.4020605@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517137A7.4020605-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Check if cpus_allowed is to be changed before calling validate_change().

This won't change any behavior, but later it will allow us to do this:

 # mkdir /cpuset/child
 # echo $$ > /cpuset/child/tasks	/* empty cpuset */
 # echo > /cpuset/child/cpuset.cpus	/* do nothing, won't fail */

Without this patch, the last operation will fail.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 2e4c5af..63a5343 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -855,14 +855,15 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
 			return -EINVAL;
 	}
-	retval = validate_change(cs, trialcs);
-	if (retval < 0)
-		return retval;
 
 	/* Nothing to do if the cpus didn't change */
 	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
+	retval = validate_change(cs, trialcs);
+	if (retval < 0)
+		return retval;
+
 	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
 	if (retval)
 		return retval;
-- 
1.8.0.2
