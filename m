From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH v1 3/3] cgroup: relax common ancestor restriction for direct descendants
Date: Tue, 19 Jul 2016 02:18:16 +1000
Message-ID: <20160718161816.13040-4-asarai@suse.de>
References: <20160718161816.13040-1-asarai@suse.de>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160718161816.13040-1-asarai-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

If we're moving from a parent to a direct descendant, the only end
result (on cgroupv2 hierarchies) is that the process experiences more
restrictive resource limits. Thus, there's no reason to restrict
processes from moving to direct descendants based on whether or not they
have cgroup.procs write access to their current cgroup.

This is important for unprivileged subtree management, as it allows
unprivileged processes to move to their newly create subtrees.

Cc: dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org
Signed-off-by: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
---
 kernel/cgroup.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4559baa7eabd..fa403357ba91 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2859,14 +2859,22 @@ static int cgroup_procs_write_permission(struct task_struct *task,
 		cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
 		spin_unlock_irq(&css_set_lock);
 
-		while (!cgroup_is_descendant(dst_cgrp, cgrp))
-			cgrp = cgroup_parent(cgrp);
-
-		ret = -ENOMEM;
-		inode = kernfs_get_inode(sb, cgrp->procs_file.kn);
-		if (inode) {
-			ret = inode_permission(inode, MAY_WRITE);
-			iput(inode);
+		/*
+		 * If we are moving to a descendant of our current cgroup, we
+		 * can only further restrict the cgroup limits we must follow.
+		 * Thus, it doesn't make sense to restrict the cgroup.procs
+		 * write.
+		 */
+		if (!cgroup_is_descendant(dst_cgrp, cgrp)) {
+			while (!cgroup_is_descendant(dst_cgrp, cgrp))
+				cgrp = cgroup_parent(cgrp);
+
+			ret = -ENOMEM;
+			inode = kernfs_get_inode(sb, cgrp->procs_file.kn);
+			if (inode) {
+				ret = inode_permission(inode, MAY_WRITE);
+				iput(inode);
+			}
 		}
 	}
 
-- 
2.9.0
