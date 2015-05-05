From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 2/2] kernfs: do not account ino_ida allocations to memcg
Date: Tue, 5 May 2015 12:45:43 +0300
Message-ID: <0cf48f4219721952f182715a61910f626d7c4aca.1430819044.git.vdavydov@parallels.com>
References: <fdf631b3fa95567a830ea4f3e19d0b3b2fc99662.1430819044.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fdf631b3fa95567a830ea4f3e19d0b3b2fc99662.1430819044.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

root->ino_ida is used for kernfs inode number allocations. Since IDA has
a layered structure, different IDs can reside on the same layer, which
is currently accounted to some memory cgroup. The problem is that each
kmem cache of a memory cgroup has its own directory on sysfs (under
/sys/fs/kernel/<cache-name>/cgroup). If the inode number of such a
directory or any file in it gets allocated from a layer accounted to the
cgroup which the cache is created for, the cgroup will get pinned for
good, because one has to free all kmem allocations accounted to a cgroup
in order to release it and destroy all its kmem caches. That said we
must not account layers of ino_ida to any memory cgroup.

Since per net init operations may create new sysfs entries directly
(e.g. lo device) or indirectly (nf_conntrack creates a new kmem cache
per each namespace, which, in turn, creates new sysfs entries), an easy
way to reproduce this issue is by creating network namespace(s) from
inside a kmem-active memory cgroup.

Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 fs/kernfs/dir.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index f131fc23ffc4..fffca9517321 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -518,7 +518,14 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 	if (!kn)
 		goto err_out1;
 
-	ret = ida_simple_get(&root->ino_ida, 1, 0, GFP_KERNEL);
+	/*
+	 * If the ino of the sysfs entry created for a kmem cache gets
+	 * allocated from an ida layer, which is accounted to the memcg that
+	 * owns the cache, the memcg will get pinned forever. So do not account
+	 * ino ida allocations.
+	 */
+	ret = ida_simple_get(&root->ino_ida, 1, 0,
+			     GFP_KERNEL | __GFP_NOACCOUNT);
 	if (ret < 0)
 		goto err_out2;
 	kn->ino = ret;
-- 
1.7.10.4
