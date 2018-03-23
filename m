From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.17 1/2] cgroup: Explicitly remove core interface
 files
Date: Fri, 23 Mar 2018 12:47:22 -0700
Message-ID: <20180323194722.GE2149215@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=bplhk+i4mlhtBowJXHAdpxdbwJuRMZ2/B3b8WkTl6dI=;
        b=ih9zV4g7gUIvBkc8K6pPSJpFs75z/Am3cnGwkBJ4K/cokjZcBotXevtrHAhKRKLRYg
         axfKdHt/B3x7ZUgdHd2ceMb/YCvg8s9LwH5qEVygDEDcBUdrkLRS/pFa+vVsf1l6VeEj
         RC8pzWLmz89PZg4rpKLnE7WTZP0wOqkRSCJlBqwApyY6pUmGgzvytCcfyKiFvH+6v8L+
         /whu4erozy8EehBnZ8XRKEDj4DRYZmLWTFURqpIFUmXdtfGoCWJFvuXtRO+pH8AfZfre
         TQ7nC7I+XydlwOE3eJKmnhUQgSpYhgQDFPaEWY6EzQy1Cmhq/dr+kf1Z1p8WhGRKCuG0
         ocWA==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org

The "cgroup." core interface files bypass the usual interface removal
path and get removed recursively along with the cgroup itself.  While
this works now, the subtle discrepancy gets in the way of implementing
common mechanisms.

This patch updates cgroup core interface file handling so that it's
consistent with controller interface files.  When added, the css is
marked CSS_VISIBLE and they're explicitly removed before the cgroup is
destroyed.

This doesn't cause user-visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1573,8 +1573,17 @@ static void css_clear_dir(struct cgroup_
 
 	css->flags &= ~CSS_VISIBLE;
 
-	list_for_each_entry(cfts, &css->ss->cfts, node)
+	if (!css->ss) {
+		if (cgroup_on_dfl(cgrp))
+			cfts = cgroup_base_files;
+		else
+			cfts = cgroup1_base_files;
+
 		cgroup_addrm_files(css, cgrp, cfts, false);
+	} else {
+		list_for_each_entry(cfts, &css->ss->cfts, node)
+			cgroup_addrm_files(css, cgrp, cfts, false);
+	}
 }
 
 /**
@@ -1598,14 +1607,16 @@ static int css_populate_dir(struct cgrou
 		else
 			cfts = cgroup1_base_files;
 
-		return cgroup_addrm_files(&cgrp->self, cgrp, cfts, true);
-	}
-
-	list_for_each_entry(cfts, &css->ss->cfts, node) {
-		ret = cgroup_addrm_files(css, cgrp, cfts, true);
-		if (ret < 0) {
-			failed_cfts = cfts;
-			goto err;
+		ret = cgroup_addrm_files(&cgrp->self, cgrp, cfts, true);
+		if (ret < 0)
+			return ret;
+	} else {
+		list_for_each_entry(cfts, &css->ss->cfts, node) {
+			ret = cgroup_addrm_files(css, cgrp, cfts, true);
+			if (ret < 0) {
+				failed_cfts = cfts;
+				goto err;
+			}
 		}
 	}
 
@@ -5097,10 +5108,8 @@ static int cgroup_destroy_locked(struct
 	for_each_css(css, ssid, cgrp)
 		kill_css(css);
 
-	/*
-	 * Remove @cgrp directory along with the base files.  @cgrp has an
-	 * extra ref on its kn.
-	 */
+	/* clear and remove @cgrp dir, @cgrp has an extra ref on its kn */
+	css_clear_dir(&cgrp->self);
 	kernfs_remove(cgrp->kn);
 
 	if (parent && cgroup_is_threaded(cgrp))
