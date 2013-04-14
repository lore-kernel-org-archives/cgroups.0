From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.10] cgroup: make cgroup_path() not print double
 slashes
Date: Sun, 14 Apr 2013 10:37:04 -0700
Message-ID: <20130414173704.GB3050@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:mime-version
         :content-type:content-disposition:user-agent;
        bh=AEQK3Hp5p/SJ1zZqG6YOd9MQDx9et3Udt49RDtXQdUU=;
        b=mffB9M1RZdT1MEQ7w8tJawnnie3v04R/UmgLSdX6AfgFtkBrCQ5DixyXpCjUG6sZjF
         9YRhtIxAXk5EPmSWRDW1ZwY6GfbjhAZFI8QM0oF8xeJShFFL5Nd0Eo7I8EnPz0PL8wHr
         PTP30nSCGUCZYjdRKuR/6tO9A8UrufS1fGidh18AHUS+lQA8/7zh1wibeMcDQIXkudmT
         MOM2yj2QUcgBJb9zD3UAaBpus6t91dx2K02bjFCi6vfA1zr4HAWDftyszNRYaDdh+dKw
         SjJMQx+kJZM7aiK9BuQ5fNfjs6SoZjukqoHqrNuKcA7akwdExI4dtV+nRDpighDBTUxl
         tQNQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From 277f3d4be79aefe2071d9053a9c7c89c4e5dad30 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Sun, 14 Apr 2013 10:32:19 -0700

While reimplementing cgroup_path(), 65dff759d2 ("cgroup: fix
cgroup_path() vs rename() race") introduced a bug where the path of a
non-root cgroup would have two slahses at the beginning, which is
caused by adding '/' before the name of the root cgroup which is an
empty string.

 $ grep systemd /proc/self/cgroup
 1:name=systemd://user/root/1

Fix it by special casing root cgroup.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
Applying to cgroup/for-3.10.

Thanks.

 kernel/cgroup.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 678a22c..faf55f5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1811,11 +1811,17 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 	int ret = -ENAMETOOLONG;
 	char *start;
 
+	if (!cgrp->parent) {
+		if (strlcpy(buf, "/", buflen) >= buflen)
+			return -ENAMETOOLONG;
+		return 0;
+	}
+
 	start = buf + buflen - 1;
 	*start = '\0';
 
 	rcu_read_lock();
-	while (cgrp) {
+	do {
 		const char *name = cgroup_name(cgrp);
 		int len;
 
@@ -1824,15 +1830,12 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 			goto out;
 		memcpy(start, name, len);
 
-		if (!cgrp->parent)
-			break;
-
 		if (--start < buf)
 			goto out;
 		*start = '/';
 
 		cgrp = cgrp->parent;
-	}
+	} while (cgrp->parent);
 	ret = 0;
 	memmove(buf, start, buf + buflen - start);
 out:
-- 
1.8.1.4
