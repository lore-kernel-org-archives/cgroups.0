From: Jeff Liu <jeff.liu@oracle.com>
Subject: [RFC PATCH v1 3/4] cgroup quota: validate and charge  block quota
 for XFS
Date: Fri, 09 Mar 2012 19:21:17 +0800
Message-ID: <4F59E7AD.4080903@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org
Cc: lxc-devel@lists.sourceforge.net, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, tj@kernel.org, Li Zefan <lizf@cn.fujitsu.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, Christopher Jones <christopher.jones@oracle.com>, Dave Chinner <david@fromorbit.com>, jack@suse.cz, tytso@MIT.EDU

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_iomap.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 9afa282..c67525e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -44,6 +44,7 @@
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
 
+#include <linux/quota_cgroup.h>
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
 						<< mp->m_writeio_log)
@@ -140,6 +141,7 @@ xfs_iomap_write_direct(
 	uint		qblocks, resblks, resrtextents;
 	int		committed;
 	int		error;
+	prid_t		prid;
 
 	/*
 	 * Make sure that the dquots are there. This doesn't hold
@@ -152,6 +154,12 @@ xfs_iomap_write_direct(
 	rt = XFS_IS_REALTIME_INODE(ip);
 	extsz = xfs_get_extsz_hint(ip);
 
+	prid = xfs_get_projid(ip);
+	error = quota_cgroup_validate_pquota(QUOTA_NEW_BLOCK, prid,
+					     XFS_FSB_TO_B(mp, extsz));
+	if (error)
+		return error;
+
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
 	if ((offset + count) > ip->i_size) {
@@ -248,6 +256,9 @@ xfs_iomap_write_direct(
 		goto error_out;
 	}
 
+	quota_cgroup_charge_pquota(QUOTA_NEW_BLOCK, prid,
+				   XFS_FSB_TO_B(mp, extsz));
+
 	return 0;
 
 error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
@@ -384,6 +395,7 @@ xfs_iomap_write_delay(
 	xfs_bmbt_irec_t imap[XFS_WRITE_IMAPS];
 	int		prealloc, flushed = 0;
 	int		error;
+	prid_t		prid;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
@@ -398,6 +410,11 @@ xfs_iomap_write_delay(
 	extsz = xfs_get_extsz_hint(ip);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
+	prid = xfs_get_projid(ip);
+	error = quota_cgroup_validate_pquota(QUOTA_NEW_BLOCK, prid,
+					     XFS_FSB_TO_B(mp, extsz));
+	if (error)
+		return error;
 
 	error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
 				imap, XFS_WRITE_IMAPS, &prealloc);
@@ -456,6 +473,9 @@ retry:
 		goto retry;
 	}
 
+	quota_cgroup_charge_pquota(QUOTA_NEW_BLOCK, prid,
+				   XFS_FSB_TO_B(mp, extsz));
+
 	if (!(imap[0].br_startblock || XFS_IS_REALTIME_INODE(ip)))
 		return xfs_alert_fsblock_zero(ip, &imap[0]);
 
@@ -490,6 +510,7 @@ xfs_iomap_write_allocate(
 	int		nimaps, committed;
 	int		error = 0;
 	int		nres;
+	prid_t		prid;
 
 	/*
 	 * Make sure that the dquots are there.
@@ -498,6 +519,12 @@ xfs_iomap_write_allocate(
 	if (error)
 		return XFS_ERROR(error);
 
+	prid = xfs_get_projid(ip);
+	error = quota_cgroup_validate_pquota(QUOTA_NEW_BLOCK, prid,
+			XFS_FSB_TO_B(mp, imap->br_blockcount));
+	if (error)
+		return error;
+
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	count_fsb = imap->br_blockcount;
 	map_start_fsb = imap->br_startoff;
@@ -611,6 +638,9 @@ xfs_iomap_write_allocate(
 		    (offset_fsb < (imap->br_startoff +
 				   imap->br_blockcount))) {
 			XFS_STATS_INC(xs_xstrat_quick);
+
+			quota_cgroup_charge_pquota(QUOTA_NEW_BLOCK, prid,
+				XFS_FSB_TO_B(mp, imap->br_blockcount));
 			return 0;
 		}
 
-- 
1.7.9
