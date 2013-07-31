From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 5/5] cgroup: remove struct cgroup_seqfile_state
Date: Wed, 31 Jul 2013 17:36:25 +0800
Message-ID: <51F8DA99.3010303@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

We can use struct cfent instead.

v2:
- remove cgroup_seqfile_release().

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 45 +++++++++++++--------------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0d378b1..c836dff 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2362,11 +2362,6 @@ static ssize_t cgroup_file_read(struct file *file, char __user *buf,
  * supports string->u64 maps, but can be extended in future.
  */
 
-struct cgroup_seqfile_state {
-	struct cftype *cft;
-	struct cgroup *cgroup;
-};
-
 static int cgroup_map_add(struct cgroup_map_cb *cb, const char *key, u64 value)
 {
 	struct seq_file *sf = cb->state;
@@ -2375,59 +2370,45 @@ static int cgroup_map_add(struct cgroup_map_cb *cb, const char *key, u64 value)
 
 static int cgroup_seqfile_show(struct seq_file *m, void *arg)
 {
-	struct cgroup_seqfile_state *state = m->private;
-	struct cftype *cft = state->cft;
+	struct cfent *cfe = m->private;
+	struct cftype *cft = cfe->type;
+	struct cgroup *cgrp = __d_cgrp(cfe->dentry->d_parent);
+
 	if (cft->read_map) {
 		struct cgroup_map_cb cb = {
 			.fill = cgroup_map_add,
 			.state = m,
 		};
-		return cft->read_map(state->cgroup, cft, &cb);
+		return cft->read_map(cgrp, cft, &cb);
 	}
-	return cft->read_seq_string(state->cgroup, cft, m);
-}
-
-static int cgroup_seqfile_release(struct inode *inode, struct file *file)
-{
-	struct seq_file *seq = file->private_data;
-	kfree(seq->private);
-	return single_release(inode, file);
+	return cft->read_seq_string(cgrp, cft, m);
 }
 
 static const struct file_operations cgroup_seqfile_operations = {
 	.read = seq_read,
 	.write = cgroup_file_write,
 	.llseek = seq_lseek,
-	.release = cgroup_seqfile_release,
+	.release = single_release,
 };
 
 static int cgroup_file_open(struct inode *inode, struct file *file)
 {
 	int err;
+	struct cfent *cfe;
 	struct cftype *cft;
 
 	err = generic_file_open(inode, file);
 	if (err)
 		return err;
-	cft = __d_cft(file->f_dentry);
+	cfe = __d_cfe(file->f_dentry);
+	cft = cfe->type;
 
 	if (cft->read_map || cft->read_seq_string) {
-		struct cgroup_seqfile_state *state;
-
-		state = kzalloc(sizeof(*state), GFP_USER);
-		if (!state)
-			return -ENOMEM;
-
-		state->cft = cft;
-		state->cgroup = __d_cgrp(file->f_dentry->d_parent);
 		file->f_op = &cgroup_seqfile_operations;
-		err = single_open(file, cgroup_seqfile_show, state);
-		if (err < 0)
-			kfree(state);
-	} else if (cft->open)
+		err = single_open(file, cgroup_seqfile_show, cfe);
+	} else if (cft->open) {
 		err = cft->open(inode, file);
-	else
-		err = 0;
+	}
 
 	return err;
 }
-- 
1.8.0.2
