From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v4.3-rc2
Date: Fri, 25 Sep 2015 16:31:58 -0400
Message-ID: <20150925203158.GK4449@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=aYZ0nCnKYxFowrEtfMgk/YCkrQWg92RTz1ikttprCaA=;
        b=VxbXeRGEi28gghD5uAuN5tX87nbYlflo7EjttnJ6rG6pOm+or2I72wmV5ikS0r3G4u
         Y7TcMpZt1D9vjtLi97zfmSODABCU89oKRkra4tz7pMmtNBwdEjT7O8CRVrWjQ4NvRQO/
         qyL3TUkJ9/zY27ZwHfU+tBBnMRJsEUgpLvIhU5ugUqCEgSjus1xqlVmINN/HaX3cvBWt
         B3lY+5Eo5Kb6VxdOt8u0k/UDDx+x6JODkYJ6TM++qiqz34RUIlrAQrmxcAt4DR3fXXoV
         uiTfpcDnKLFb3XhOhikQo0N8fkzxMglhgsyw/OM3SPegbnF6O3KN9zIhwddat0+HV9yS
         D6tA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Hello, Linus.

Another cgroup fix pull.  The cgroup writeback support got
inadvertently enabled for traditional hierarchies revealing two
regressions which are currently being worked on.  It shouldn't have
been enabled on traditional hierarchies, so disable it on them.  This
is enough for making the regressions go away for people who aren't
experimenting with cgroup.

Thanks.

The following changes since commit 0c986253b939cc14c69d4adbe2b4121bdf4aa220:

  Revert "sched, cgroup: replace signal_struct->group_rwsem with a global percpu_rwsem" (2015-09-16 11:51:12 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.3-fixes

for you to fetch changes up to 9badce000e2ce68ba74838a3cd356dde58221c2f:

  cgroup, writeback: don't enable cgroup writeback on traditional hierarchies (2015-09-24 16:48:52 -0400)

----------------------------------------------------------------
Tejun Heo (1):
      cgroup, writeback: don't enable cgroup writeback on traditional hierarchies

 include/linux/backing-dev.h | 11 +++++++++--
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
