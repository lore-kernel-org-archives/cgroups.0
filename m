From: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [RFC PATCH 9/9] cgroup: rework cgroup_path
Date: Mon, 17 Dec 2012 14:43:35 +0800
Message-ID: <1355726615-15224-10-git-send-email-gaofeng@cn.fujitsu.com>
References: <1355726615-15224-1-git-send-email-gaofeng@cn.fujitsu.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1355726615-15224-1-git-send-email-gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

use cgrp == cgrp->top_cgroup instead of cgrp == NULL

Signed-off-by: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 kernel/cgroup.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b0caa1d..c111cf9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1976,12 +1976,14 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 		if ((start -= len) < buf)
 			return -ENAMETOOLONG;
 		memcpy(start, dentry->d_name.name, len);
-		cgrp = cgrp->parent;
-		if (!cgrp)
+
+		if (cgrp == cgrp->top_cgroup)
 			break;
 
+		cgrp = cgrp->parent;
 		dentry = cgrp->dentry;
-		if (!cgrp->parent)
+
+		if (cgrp == cgrp->top_cgroup)
 			continue;
 		if (--start < buf)
 			return -ENAMETOOLONG;
-- 
1.7.7.6
