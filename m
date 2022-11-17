From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cgroup/cpuset: Improve cpuset_css_alloc() description
Date: Thu, 17 Nov 2022 12:45:57 +0530
Message-ID: <20221117071557.165742-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=9kopYNd6jIPcxgzNvcy2sDx186qQDHRpN+Dt2XgO6jk=;
 b=2fk7wvcguQPJsQt27KH18YVDsK0dxAJgIAOiB6dNsvXhbUP5H+Q7DoJYRFD86oQrQ1YH
 li9rLPrZPwY3rQDOc9NAS0Fx+oMNi6FTRWHRKrT1v6HJrUILUBWnmwwbHgjeKDz4mlCf
 rafvqWqtZtDjrztrl1M4LzH7gn7Fo+Hw8gQ57pPAZo019GfsG9T+YWyj2lEy4sNlWSfA
 +GtMjI8iRnUfPECor7wkfk4QCRYm+htH/NwkVd1ANYU6r28CG4tzx0bCfnkIMuHQ21vD
 igwtMXWF4fLuec+Vev9OYMPG1WulctC8J4AAKk921IoiQVY2ltlXOUMDPvI5CRLrl+J8 bg== 
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
v2: Reworded the description to be more accurate, as suggested
    by Waiman Long

 kernel/cgroup/cpuset.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b474289c15b8..ce789e1b2a2f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3046,11 +3046,15 @@ static struct cftype dfl_files[] = {
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
+ * Allocate and initialize a new cpuset css, for non-NULL @parent_css, return
+ * top cpuset css otherwise.
  */
-
 static struct cgroup_subsys_state *
 cpuset_css_alloc(struct cgroup_subsys_state *parent_css)
 {
-- 
2.34.3

