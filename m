From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v14 1/4] cgroup: fix uninitialised iterator in for_each_subsys_which
Date: Tue,  9 Jun 2015 21:32:07 +1000
Message-ID: <1433849530-22845-2-git-send-email-cyphar@cyphar.com>
References: <1433849530-22845-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433849530-22845-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Fix the fact that @ssid is uninitialised in the case where
CGROUP_SUBSYS_COUNT = 0 by setting ssid to 0.

Fixes: cb4a31675270 ("cgroup: use bitmask to filter for_each_subsys")
Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6d6d3c7..12b580f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -424,7 +424,7 @@ static int notify_on_release(const struct cgroup *cgrp)
  */
 #define for_each_subsys_which(ss, ssid, ss_maskp)			\
 	if (!CGROUP_SUBSYS_COUNT) /* to avoid spurious gcc warning */	\
-		;							\
+		(ssid) = 0;						\
 	else								\
 		for_each_set_bit(ssid, ss_maskp, CGROUP_SUBSYS_COUNT)	\
 			if (((ss) = cgroup_subsys[ssid]) && false)	\
-- 
2.4.2
