From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/14] cgroup: move check_for_release() invocation
Date: Fri,  9 Oct 2015 23:29:31 -0400
Message-ID: <1444447781-16182-5-git-send-email-tj@kernel.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tLktk25MfPoT4fw/RFPv1vXYxn/L4dfsd0rtEeP/k+4=;
        b=KXrbss7nY0WQ+y2jmFHC+Q1yD4Qvozkbfa1YYINLa6L72cGaz/FQj8dYuHAl9DxLdp
         C71r87nhyCRQV8CP2fAkT/lGA90Ym/r42zvT73WQkPjrQGSt76OPqViT5Vdrh97Q14mO
         WmZTy6NT3npqAAwg8CrVq06eZg/Vw3zggca+XqOr3v8NsOzVWR5qk4DF5U9BKJOQ6XOm
         QWJTTuZEwJ634WnvBEesv8LRAF8ueMnhYTZ7/mGbNI4par7JEpPqJVobVDoY2j9c3G9w
         z3XBZSqMwCD9MV9iJ6HuTgh6b9egrMRkSLgtW3RVBP+isaCicraEz4azzXAy6zMPu5sM
         3mOQ==
In-Reply-To: <1444447781-16182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, cyphar@cyphar.com, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

To trigger release agent when the last task leaves the cgroup,
check_for_release() is called from put_css_set_locked(); however,
css_set being unlinked is being decoupled from task leaving the cgroup
and the correct condition to test is cgroup->nr_populated dropping to
zero which check_for_release() is already updated to test.

This patch moves check_for_release() invocation from
put_css_set_locked() to cgroup_update_populated().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 435aa68..855313d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -623,6 +623,7 @@ static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 		if (!trigger)
 			break;
 
+		check_for_release(cgrp);
 		cgroup_file_notify(&cgrp->events_file);
 
 		cgrp = cgroup_parent(cgrp);
@@ -686,15 +687,8 @@ static void put_css_set_locked(struct css_set *cset)
 	css_set_count--;
 
 	list_for_each_entry_safe(link, tmp_link, &cset->cgrp_links, cgrp_link) {
-		struct cgroup *cgrp = link->cgrp;
-
 		list_del(&link->cset_link);
 		list_del(&link->cgrp_link);
-
-		/* @cgrp can't go away while we're holding css_set_rwsem */
-		if (list_empty(&cgrp->cset_links))
-			check_for_release(cgrp);
-
 		kfree(link);
 	}
 
-- 
2.4.3
