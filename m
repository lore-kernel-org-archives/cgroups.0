From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 5/7] cgroup: remove struct cgroup_seqfile_state
Date: Wed, 31 Jul 2013 16:17:45 +0800
Message-ID: <51F8C829.3040708@huawei.com>
References: <51F8C7C5.9040608@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51F8C7C5.9040608@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

We can use struct struct cfent instead.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0d378b1..ac77d87 100644
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
@@ -2375,22 +2370,22 @@ static int cgroup_map_add(struct cgroup_map_cb *cb, const char *key, u64 value)
 
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
+	return cft->read_seq_string(cgrp, cft, m);
 }
 
 static int cgroup_seqfile_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq = file->private_data;
-	kfree(seq->private);
 	return single_release(inode, file);
 }
 
@@ -2404,30 +2399,21 @@ static const struct file_operations cgroup_seqfile_operations = {
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
