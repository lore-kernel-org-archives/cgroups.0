From: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroups: Documentation/cgroup/cgroup.txt - a trivial fix.
Date: Wed,  3 Apr 2013 20:32:04 +0300
Message-ID: <1365010324-3900-1-git-send-email-ramirose@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer;
        bh=fOBua2CknOu9IUrTWKTWAqKS96XOm0oDHujtiKRICA4=;
        b=wsJrXLLPrkDWTwe+Lby1wWfi9nDvPuU1Elh2lrnrtnmSW0pM3JHyH90nbXWk7zxqfq
         45n0lreVwmDOkCgQkmPhYS8gXd3nAVL4PCgqDSi47VQVlptqd8kk3AVZ5DvD+GEkZfZJ
         swB/VKAIG8jlN6PtDt56N2YQoqtw777n2Fpl643v0EZpdyf9DtFAq0HGzQQtvr7k5Cqi
         YxkJG+KnZkZznuszxGhnKNx1JmLYoLSA64A5Z0WC0yk5aB2g8c3mtx+9v4x4ew7SmVuG
         TOxFnDFwq63+UlN4DoBES9BoQAE5IbxabIXJtGkKgE6Set8SptYeckRnpwowOmtTrR/K
         3GIQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This trivial patch removes a word which appears twice in 
Documentation/cgroup/cgroup.txt.

Signed-off-by: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/cgroups/cgroups.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 0028e88..638bf17 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -442,7 +442,7 @@ You can attach the current shell task by echoing 0:
 You can use the cgroup.procs file instead of the tasks file to move all
 threads in a threadgroup at once. Echoing the PID of any task in a
 threadgroup to cgroup.procs causes all tasks in that threadgroup to be
-be attached to the cgroup. Writing 0 to cgroup.procs moves all tasks
+attached to the cgroup. Writing 0 to cgroup.procs moves all tasks
 in the writing task's threadgroup.
 
 Note: Since every task is always a member of exactly one cgroup in each
-- 
1.8.1.4
