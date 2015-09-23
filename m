From: Tejun Heo <tj@kernel.org>
Subject: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable cgroup
 writeback on traditional hierarchies
Date: Wed, 23 Sep 2015 17:07:29 -0400
Message-ID: <20150923210729.GA23180@mtj.duckdns.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
 <20150923180934.GE26647@mtj.duckdns.org>
 <20150923185137.GJ26647@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7JfP6Z+qXMEoeCYlrOcl3ZPAK9djNFHqsDdc8pnh2LI=;
        b=T+M67p3TIRfk7Vaztlmnw4T0xEMydEL3oEximJfq1O0GiGI8ygx3G7J3ZnNvG58qW+
         FuMwcjUj39NTVa76G9KZ2XsUpAj7xVE3bGglpidjo+vKAxRi/TRQkryyR92bmNAHFg87
         JK8jJkqbfXSyK80jPrJ02H4iB6SrBAu9tzsFfE4vOrq583S45uWLUj6EcgCaT2G652PH
         PjjFffa5J4p7GHvwXkX2JeLujYvIlykFjquCwbc/AiPQERVMHNjxXKgj1QFJikE4lVZ3
         0RqbdYEjUO1KZbdCRCdiHI0nMnwJMyVVHNWt+XcQTF48WCc/ZF5H3cbbto0mLxzwZ72o
         Nz8A==
Content-Disposition: inline
In-Reply-To: <20150923185137.GJ26647@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, kernel-team@fb.com, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, Dexuan Cui <decui@microsoft.com>

inode_cgwb_enabled() gates cgroup writeback support.  If it returns
true, each inode is attached to the corresponding memory domain which
gets mapped to io domain.  It currently only tests whether the
filesystem and bdi support cgroup writeback; however, cgroup writeback
support doesn't work on traditional hierarchies and thus it should
also test whether memcg and iocg are on the default hierarchy.

This caused traditional hierarchy setups to hit the cgroup writeback
path inadvertently and ended up creating separate writeback domains
for each memcg and mapping them all to the root iocg uncovering a
couple issues in the cgroup writeback path.

cgroup writeback was never meant to be enabled on traditional
hierarchies.  Make inode_cgwb_enabled() test whether both memcg and
iocg are on the default hierarchy.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Artem Bityutskiy <dedekind1@gmail.com>
Reported-by: Dexuan Cui <decui@microsoft.com>
Link: http://lkml.kernel.org/g/1443012552.19983.209.camel@gmail.com
Link: http://lkml.kernel.org/g/f30d4a6aa8a546ff88f73021d026a453@SIXPR30MB031.064d.mgd.msft.net
---
Hello,

So, this should make the regression go away.  It doesn't fix the
underlying bugs but they shouldn't get triggered by people not
experimenting with cgroup.

I'm gonna keep digging the underlying issues but this should make the
regressions go away.  If it's okay, I think it'd be better to route
this through cgroup/for-4.3-fixes as it's gonna cause a conflict with
for-4.4 branch and handling the merge there is easier.

Thanks.

 include/linux/backing-dev.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 5a5d79e..d5eb4ad1 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
+#include <linux/memcontrol.h>
 #include <linux/blk-cgroup.h>
 #include <linux/backing-dev-defs.h>
 #include <linux/slab.h>
@@ -252,13 +253,19 @@ int inode_congested(struct inode *inode, int cong_bits);
  * @inode: inode of interest
  *
  * cgroup writeback requires support from both the bdi and filesystem.
- * Test whether @inode has both.
+ * Also, both memcg and iocg have to be on the default hierarchy.  Test
+ * whether all conditions are met.
+ *
+ * Note that the test result may change dynamically on the same inode
+ * depending on how memcg and iocg are configured.
  */
 static inline bool inode_cgwb_enabled(struct inode *inode)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 
-	return bdi_cap_account_dirty(bdi) &&
+	return cgroup_on_dfl(mem_cgroup_root_css->cgroup) &&
+		cgroup_on_dfl(blkcg_root_css->cgroup) &&
+		bdi_cap_account_dirty(bdi) &&
 		(bdi->capabilities & BDI_CAP_CGROUP_WRITEBACK) &&
 		(inode->i_sb->s_iflags & SB_I_CGROUPWB);
 }
