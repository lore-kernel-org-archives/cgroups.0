From: Jeff Liu <jeff.liu@oracle.com>
Subject: [RFC PATCH v1 4/4] cgroup quota: validate and charge  inode quota
 for XFS
Date: Fri, 09 Mar 2012 19:21:22 +0800
Message-ID: <4F59E7B2.6090006@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org
Cc: lxc-devel@lists.sourceforge.net, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, tj@kernel.org, Li Zefan <lizf@cn.fujitsu.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, Christopher Jones <christopher.jones@oracle.com>, Dave Chinner <david@fromorbit.com>, jack@suse.cz, tytso@mit.edu

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_vnodeops.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index ce9268a..4824eef 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -50,6 +50,8 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 
+#include <linux/quota_cgroup.h>
+
 /*
  * The maximum pathlen is 1024 bytes. Since the minimum file system
  * blocksize is 512 bytes, we can get a max of 2 extents back from
@@ -853,6 +855,10 @@ xfs_create(
 	else
 		prid = XFS_PROJID_DEFAULT;
 
+	error = quota_cgroup_validate_pquota(QUOTA_NEW_INODE, prid, 1);
+	if (error)
+		return error;
+
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
 	 */
@@ -983,6 +989,8 @@ xfs_create(
 	 */
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp);
 
+	quota_cgroup_charge_pquota(QUOTA_NEW_INODE, prid, 1);
+
 	error = xfs_bmap_finish(&tp, &free_list, &committed);
 	if (error)
 		goto out_bmap_cancel;
@@ -1354,6 +1362,8 @@ xfs_remove(
 	if (!is_dir && link_zero && xfs_inode_is_filestream(ip))
 		xfs_filestream_deassociate(ip);
 
+	quota_cgroup_charge_pquota(QUOTA_DROP_INODE, xfs_get_projid(ip), 1);
+
 	return 0;
 
  out_bmap_cancel:
-- 
1.7.9
