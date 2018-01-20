From: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 1/9] kernfs: Export kernfs_get_inode
Date: Fri, 19 Jan 2018 17:51:33 -0800
Message-ID: <20180120015141.10118-2-matthew.d.roper@intel.com>
References: <20180120015141.10118-1-matthew.d.roper@intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180120015141.10118-1-matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Drivers may wish to access a cgroup's inode to perform permission checks on
driver-specific operations.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Matt Roper <matthew.d.roper-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 fs/kernfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index a34303981deb..e1e8a0404c5b 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -272,6 +272,7 @@ struct inode *kernfs_get_inode(struct super_block *sb, struct kernfs_node *kn)
 
 	return inode;
 }
+EXPORT_SYMBOL(kernfs_get_inode);
 
 /*
  * The kernfs_node serves as both an inode and a directory entry for
-- 
2.14.3
