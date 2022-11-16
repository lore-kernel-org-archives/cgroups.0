From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: Improve cpuset_css_alloc() description
Date: Wed, 16 Nov 2022 11:14:15 +0530
Message-ID: <20221116054415.79157-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=jhSVHIUZfvFwsvGyEJwDiFx8Fn6QcA5O4eLJOA7BiSk=;
 b=3McIG5aA5Dw94XTVmrxS5nddi7fsYR/Zu3boldh7iUxTPaQ/+GGhtkiVvjXhb1aQPvz1
 z0Emyw6I0Trj/cycDerFjHPYCA8yF1cQOkhDtO5g7lwouBqgRy2+aa+e3d9jrD/ADPYw
 X7UbEwN6H1DhlqXhGY4n0cyZnf9qukedFmw6zVn5ppxttT0xEXfJSHqEtAUAv93TOA29
 UCO7skQYnbnVb+GW8z5qKN+kyF+w/CNiHNZx9P84AjQiup0P+ak07O9qHcW0pLQH4TTt
 XJwEvYJBisQgMgp7ap1yx+mBgpFGpJRwhrq7Ifndr0Hc06i8/aZPRun644p8Oa43qWB2 Yg== 
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Change the function argument in the description of cpuset_css_alloc()
from 'struct cgroup' -> 'struct cgroup_subsys_state'.  The change to the
argument type was introduced by commit eb95419b023a ("cgroup: pass
around cgroup_subsys_state instead of cgroup in subsystem methods").
Also, add more information to its description.

Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b474289c15b8..aac790462e74 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3046,9 +3046,14 @@ static struct cftype dfl_files[] = {
 };
 
 
-/*
- *	cpuset_css_alloc - allocate a cpuset css
- *	cgrp:	control group that the new cpuset will be part of
+/**
+ * cpuset_css_alloc - Allocate a cpuset css
+ * @parent_css: Parent css of the control group that the new cpuset will be
+ *              part of
+ * Return: cpuset css on success, -ENOMEM on failure.
+ *
+ * Allocate and initialize a new cpuset css, for non-root cpuset or return the
+ * top cpuset css for root cpuset.
  */
 
 static struct cgroup_subsys_state *
-- 
2.34.3

