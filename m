From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] cgroup: implement cftype->write()
Date: Tue,  6 May 2014 08:44:22 -0400
Message-ID: <1399380266-3324-2-git-send-email-tj@kernel.org>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kr1afwzRbmDv1FNYHtA39usy3EdSCA/omitjKEf1Hic=;
        b=pjZMpUYfeDwrvgWqllUkcmxKdrB/Mda9IhxujgAJrpYVzfvXOzWa3v3OMr0kAHkqbb
         DDSUo8ZHBLaN9j+hClmzT9mm+L3jZPcu9u45PIhBrvtGq4I9UoCEL7/1Or9HZbKPMAMk
         AYryL91uciq93B/lMZpfYg4xxku/4M0Q71S7mUHu7hmeHNebdQSPUABSQ0G8sKX1UDjt
         SGxRm7Lzsmq/2L6sFZHigb8ZjnTEiFmwUnYoaTJ3Xy5LnCUf1cbZjxqF1P7m/NvUDvvc
         b7vlxRFAroLU1NB2hVaRApevz3FS3QQsRjNdK2CjX/BHrYFTn83nxXG4ItytRTPssxXz
         Hfzg==
In-Reply-To: <1399380266-3324-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com, axboe@kernel.dk, hannes@cmpxchg.org, mhocko@suse.cz, arozansk@redhat.com, Tejun Heo <tj@kernel.org>

During the recent conversion to kernfs, cftype's seq_file operations
are updated so that they are directly mapped to kernfs operations and
thus can fully access the associated kernfs and cgroup contexts;
however, write path hasn't seen similar updates and none of the
existing write operations has access to, for example, the associated
kernfs_open_file.

Let's introduce a new operation cftype->write() which maps directly to
the kernfs write operation and has access to all the arguments and
contexts.  This will replace ->write_string() and ->trigger() and ease
manipulation of kernfs active protection from cgroup file operations.

Two accessors - of_cft() and of_css() - are introduced to enable
accessing the associated cgroup context from cftype->write() which
only takes kernfs_open_file for the context information.  The
accessors for seq_file operations - seq_cft() and seq_css() - are
rewritten to wrap the of_ accessors.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 27 +++++++++++++++++++++++----
 kernel/cgroup.c        | 14 ++++++++------
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2dfabb3..da7a0ca 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -517,6 +517,15 @@ struct cftype {
 	 */
 	int (*trigger)(struct cgroup_subsys_state *css, unsigned int event);
 
+	/*
+	 * write() is the generic write callback which maps directly to
+	 * kernfs write operation and overrides all other operations.
+	 * Maximum write size is determined by ->max_write_len.  Use
+	 * of_css/cft() to access the associated css and cft.
+	 */
+	ssize_t (*write)(struct kernfs_open_file *of,
+			 char *buf, size_t nbytes, loff_t off);
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lock_class_key	lockdep_key;
 #endif
@@ -553,14 +562,24 @@ static inline ino_t cgroup_ino(struct cgroup *cgrp)
 		return 0;
 }
 
-static inline struct cftype *seq_cft(struct seq_file *seq)
+/* cft/css accessors for cftype->write() operation */
+static inline struct cftype *of_cft(struct kernfs_open_file *of)
 {
-	struct kernfs_open_file *of = seq->private;
-
 	return of->kn->priv;
 }
 
-struct cgroup_subsys_state *seq_css(struct seq_file *seq);
+struct cgroup_subsys_state *of_css(struct kernfs_open_file *of);
+
+/* cft/css accessors for cftype->seq_*() operations */
+static inline struct cftype *seq_cft(struct seq_file *seq)
+{
+	return of_cft(seq->private);
+}
+
+static inline struct cgroup_subsys_state *seq_css(struct seq_file *seq)
+{
+	return of_css(seq->private);
+}
 
 /*
  * Name / path handling functions.  All are thin wrappers around the kernfs
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 57c2021..32d1624 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -283,11 +283,10 @@ static inline bool cgroup_is_dead(const struct cgroup *cgrp)
 	return test_bit(CGRP_DEAD, &cgrp->flags);
 }
 
-struct cgroup_subsys_state *seq_css(struct seq_file *seq)
+struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
 {
-	struct kernfs_open_file *of = seq->private;
 	struct cgroup *cgrp = of->kn->parent->priv;
-	struct cftype *cft = seq_cft(seq);
+	struct cftype *cft = of_cft(of);
 
 	/*
 	 * This is open and unprotected implementation of cgroup_css().
@@ -302,7 +301,7 @@ struct cgroup_subsys_state *seq_css(struct seq_file *seq)
 	else
 		return &cgrp->dummy_css;
 }
-EXPORT_SYMBOL_GPL(seq_css);
+EXPORT_SYMBOL_GPL(of_css);
 
 /**
  * cgroup_is_descendant - test ancestry
@@ -1035,8 +1034,8 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 	if (cft->read_u64 || cft->read_s64 || cft->seq_show)
 		mode |= S_IRUGO;
 
-	if (cft->write_u64 || cft->write_s64 || cft->write_string ||
-	    cft->trigger)
+	if (cft->write_u64 || cft->write_s64 || cft->write ||
+	    cft->write_string || cft->trigger)
 		mode |= S_IWUSR;
 
 	return mode;
@@ -2724,6 +2723,9 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 	struct cgroup_subsys_state *css;
 	int ret;
 
+	if (cft->write)
+		return cft->write(of, buf, nbytes, off);
+
 	/*
 	 * kernfs guarantees that a file isn't deleted with operations in
 	 * flight, which means that the matching css is and stays alive and
-- 
1.9.0
