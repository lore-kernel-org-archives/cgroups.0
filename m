From: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 05/11] qnx: avoid -Wstringop-overread warning
Date: Mon, 22 Mar 2021 17:02:43 +0100
Message-ID: <20210322160253.4032422-6-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429066;
        bh=nkpO3F9iV2LP9C5b1X1yN1ZVysmYmotRTLuBUWIaptM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MU4IL9JNNK+J8U+vvpLpwovR+/suU+W9R4RhhhMaub4p/qt1HSm7/5H/LxJjfRA1v
         f+dccndcC0t+6DndIOBCJbVJvgtAFbUO/Xj+Ad4PAK3HRVGVN0VmdJVzwNG2nWP60W
         yoMi7GzhcMMul2Me0RQEOrAkh9+ikItIp0T7LrmMn4UxhxHfYhCqAAaad++VD478Ly
         WRurbxWp7EoqaQbB5aDSFB4iZyCpOkFivtOdus8BKdINgwMELaIsTcoM1dTXGsBCvO
         NUlZI47cRIaTlBnQpp36y5LIoHJRasVTH3KqfKgtuhF/A3Vph299qnut15q3EDnfE2
         ATElHLu2Uchbw==
In-Reply-To: <20210322160253.4032422-1-arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, ath11k-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

gcc-11 warns that the size of the link name is longer than the di_fname
field:

fs/qnx4/dir.c: In function ‘qnx4_readdir’:
fs/qnx4/dir.c:51:32: error: ‘strnlen’ specified bound 48 exceeds source size 16 [-Werror=stringop-overread]
   51 |                         size = strnlen(de->di_fname, size);
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from fs/qnx4/qnx4.h:3,
                 from fs/qnx4/dir.c:16:
include/uapi/linux/qnx4_fs.h:45:25: note: source object declared here
   45 |         char            di_fname[QNX4_SHORT_NAME_MAX];

The problem here is that we access the same pointer using two different
structure layouts, but gcc determines the object size based on
whatever it encounters first.

Change the strnlen to use the correct field size in each case, and
change the first access to be on the longer field.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99578
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 fs/qnx4/dir.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/qnx4/dir.c b/fs/qnx4/dir.c
index a6ee23aadd28..68046450e543 100644
--- a/fs/qnx4/dir.c
+++ b/fs/qnx4/dir.c
@@ -39,21 +39,20 @@ static int qnx4_readdir(struct file *file, struct dir_context *ctx)
 		ix = (ctx->pos >> QNX4_DIR_ENTRY_SIZE_BITS) % QNX4_INODES_PER_BLOCK;
 		for (; ix < QNX4_INODES_PER_BLOCK; ix++, ctx->pos += QNX4_DIR_ENTRY_SIZE) {
 			offset = ix * QNX4_DIR_ENTRY_SIZE;
-			de = (struct qnx4_inode_entry *) (bh->b_data + offset);
-			if (!de->di_fname[0])
+			le = (struct qnx4_link_info *)(bh->b_data + offset);
+			de = (struct qnx4_inode_entry *)(bh->b_data + offset);
+			if (!le->dl_fname[0])
 				continue;
 			if (!(de->di_status & (QNX4_FILE_USED|QNX4_FILE_LINK)))
 				continue;
 			if (!(de->di_status & QNX4_FILE_LINK))
-				size = QNX4_SHORT_NAME_MAX;
+				size = strnlen(de->di_fname, sizeof(de->di_fname));
 			else
-				size = QNX4_NAME_MAX;
-			size = strnlen(de->di_fname, size);
+				size = strnlen(le->dl_fname, sizeof(le->dl_fname));
 			QNX4DEBUG((KERN_INFO "qnx4_readdir:%.*s\n", size, de->di_fname));
 			if (!(de->di_status & QNX4_FILE_LINK))
 				ino = blknum * QNX4_INODES_PER_BLOCK + ix - 1;
 			else {
-				le  = (struct qnx4_link_info*)de;
 				ino = ( le32_to_cpu(le->dl_inode_blk) - 1 ) *
 					QNX4_INODES_PER_BLOCK +
 					le->dl_inode_ndx;
-- 
2.29.2

