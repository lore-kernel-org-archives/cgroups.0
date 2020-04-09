From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-5.7-fixes] Revert "cgroup: Add memory barriers to
 plug cgroup_rstat_updated() race window"
Date: Thu, 9 Apr 2020 15:08:12 -0400
Message-ID: <20200409190812.GB37608@mtj.thefacebook.com>
References: <20200409154413.GK3818@techsingularity.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ayL215ffxl6RjJBBrVofm8B1vxSMDd7VbUsUyBtw+QM=;
        b=bCjHWWd3Hfo9Zwt/UN+F0Hmriun0dZN9aT7DnbdFO67O+uTY8o4uHtiVMRsX+dpyJN
         uqSC7XBHSdVmBnjTb+GzXMxHG0leQir/TIZQehT1LbKR5q3MGPV4VDAXhy2xrBN7l9Gh
         ZajFf8FvKF10zqVXppmyPMPJ4I1g3bRutLOaQ2tdae0/BtP0lFDAlUfDlz9TyG8YvKsR
         s29MqYvn1Pi0UMZ5IDyJ2dEiekkwhXDhzTXrlcT5uetSE3RTRP55s7Qfd0nuI1BagM2J
         9eI0erzZctXjuuGgwj504H5ML+j0VUeK7dfkRyPIo7Tjr+6brZ00OPJwJqwjqtr8LsFS
         9S+A==
Content-Disposition: inline
In-Reply-To: <20200409154413.GK3818-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From d8ef4b38cb69d907f9b0e889c44d05fc0f890977 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Thu, 9 Apr 2020 14:55:35 -0400

This reverts commit 9a9e97b2f1f2 ("cgroup: Add memory barriers to plug
cgroup_rstat_updated() race window").

The commit was added in anticipation of memcg rstat conversion which needed
synchronous accounting for the event counters (e.g. oom kill count). However,
the conversion didn't get merged due to percpu memory overhead concern which
couldn't be addressed at the time.

Unfortunately, the patch's addition of smp_mb() to cgroup_rstat_updated()
meant that every scheduling event now had to go through an additional full
barrier and Mel Gorman noticed it as 1% regression in netperf UDP_STREAM test.

There's no need to have this barrier in tree now and even if we need
synchronous accounting in the future, the right thing to do is separating that
out to a separate function so that hot paths which don't care about
synchronous behavior don't have to pay the overhead of the full barrier. Let's
revert.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Link: http://lkml.kernel.org/r/20200409154413.GK3818-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org
Cc: v4.18+
---
Applying to cgroup/for-5.7-fixes.

Thanks!

 kernel/cgroup/rstat.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 6f87352f8219..41ca996568df 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -33,12 +33,9 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 		return;
 
 	/*
-	 * Paired with the one in cgroup_rstat_cpu_pop_updated().  Either we
-	 * see NULL updated_next or they see our updated stat.
-	 */
-	smp_mb();
-
-	/*
+	 * Speculative already-on-list test. This may race leading to
+	 * temporary inaccuracies, which is fine.
+	 *
 	 * Because @parent's updated_children is terminated with @parent
 	 * instead of NULL, we can tell whether @cgrp is on the list by
 	 * testing the next pointer for NULL.
@@ -134,13 +131,6 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 		*nextp = rstatc->updated_next;
 		rstatc->updated_next = NULL;
 
-		/*
-		 * Paired with the one in cgroup_rstat_cpu_updated().
-		 * Either they see NULL updated_next or we see their
-		 * updated stat.
-		 */
-		smp_mb();
-
 		return pos;
 	}
 
-- 
2.25.2

