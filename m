From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2 cgroup/for-4.14] cgroup: replace css_set walking
 populated test with testing cgrp->nr_populated_csets
Date: Sun, 16 Jul 2017 21:44:18 -0400
Message-ID: <20170717014418.GB3519177@devbig577.frc2.facebook.com>
References: <20170717014333.GA3519177@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Hguh/RsGdR9CSMoagvCtJpM0zYqntCKolTcG4hnMrco=;
        b=YxCOJp8+JcPIkNeB5GvVz551gfquOMl1GmKQHbfh8tzPCo2YzADXJ1m9wu70zHQphh
         6iJxZ+WiNE1ajc9j7LvQp6HXXqKKkItg4sLmUk6peCrLF1exmEg+sGyb8MWveFCzvIRj
         SBY4ru5OT+kSTNg7AoaGhf8SXrEpWD3J6rIOdOm2ctZCcNsc7aMOqLQvRg3gZ48RwGje
         aMnxfq0P+9VZFit2L2YZ1wSNT6d04b1uFCjeW+SpcmpE75tZmKMGXOaO9ZCC+mc65js8
         abEXLSoai4ZK6L0aqtxYafJhw7FEJ7krOIoXdPoVRTSSff+V7onvu92AUbbjldzgTT4B
         fV1A==
Content-Disposition: inline
In-Reply-To: <20170717014333.GA3519177-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

Implement trivial cgroup_has_tasks() which tests whether
cgrp->nr_populated_csets is zero and replace the explicit local
populated test in cgroup_subtree_control().  This simplifies the code
and cgroup_has_tasks() will be used in more places later.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Applying to cgroup/for-4.14.

Thanks.

 kernel/cgroup/cgroup.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -325,6 +325,11 @@ static struct cgroup *cgroup_parent(stru
 	return NULL;
 }
 
+static bool cgroup_has_tasks(struct cgroup *cgrp)
+{
+	return cgrp->nr_populated_csets;
+}
+
 /* subsystems visibly enabled on a cgroup */
 static u16 cgroup_control(struct cgroup *cgrp)
 {
@@ -2971,28 +2976,9 @@ static ssize_t cgroup_subtree_control_wr
 	 * Except for the root, subtree_control must be zero for a cgroup
 	 * with tasks so that child cgroups don't compete against tasks.
 	 */
-	if (enable && cgroup_parent(cgrp)) {
-		struct cgrp_cset_link *link;
-
-		/*
-		 * Because namespaces pin csets too, @cgrp->cset_links
-		 * might not be empty even when @cgrp is empty.  Walk and
-		 * verify each cset.
-		 */
-		spin_lock_irq(&css_set_lock);
-
-		ret = 0;
-		list_for_each_entry(link, &cgrp->cset_links, cset_link) {
-			if (css_set_populated(link->cset)) {
-				ret = -EBUSY;
-				break;
-			}
-		}
-
-		spin_unlock_irq(&css_set_lock);
-
-		if (ret)
-			goto out_unlock;
+	if (enable && cgroup_parent(cgrp) && cgroup_has_tasks(cgrp)) {
+		ret = -EBUSY;
+		goto out_unlock;
 	}
 
 	/* save and update control masks and prepare csses */
