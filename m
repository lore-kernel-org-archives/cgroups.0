From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/5] cgroup add cftype->open/release() callbacks
Date: Tue, 20 Dec 2016 11:12:20 -0500
Message-ID: <20161220161222.15234-4-tj@kernel.org>
References: <20161220161222.15234-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=acdhV+QEyUAQAsXt4u9/5iK5vipmwEWhvbFbwW/Nd/0=;
        b=WoUBJsuwS7DTk8Kb/lnqbPqBXZRmxOmfwmJYo2XWn5xb1SfswfU/wF6/afjsimVrtV
         9OaRNn7O+JZetX+ONXut7EE0IuUZWv6dSz0QbPGcUQuows3OZqgqCE0noKz1q9fU4w2K
         38e7QJJeP4gXs0hBfExqpTN1Y7Ko8dazNkUWGgpZasPh+n4tZDQ38nl4E7ardaYMqGjz
         2GqtCwks58sT/OxLDhR8COUyrtIj1R3Mt6tX8fu7Oa/exXMKDKlHqFnxq5tCpVhZUoBz
         +DS6DYY3aeb3AHvPdQ9fSZabkvbYkpDpSmzvz5WRBJvgnRYHhGWIOfauClvW/u524gQ4
         caww==
In-Reply-To: <20161220161222.15234-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Pipe the newly added kernfs->open/release() callbacks through cftype.
While at it, as cleanup operations now can be performed from
->release() instead of ->seq_stop(), make the latter optional.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup-defs.h |  3 +++
 kernel/cgroup.c             | 24 +++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 861b467..8a916dc 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -388,6 +388,9 @@ struct cftype {
 	struct list_head node;		/* anchored at ss->cfts */
 	struct kernfs_ops *kf_ops;
 
+	int (*open)(struct kernfs_open_file *of);
+	void (*release)(struct kernfs_open_file *of);
+
 	/*
 	 * read_u64() is a shortcut for the common case of returning a
 	 * single integer. Use it in place of read()
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2ee9ec3..87167e4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3503,6 +3503,23 @@ static int cgroup_events_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
+static int cgroup_file_open(struct kernfs_open_file *of)
+{
+	struct cftype *cft = of->kn->priv;
+
+	if (cft->open)
+		return cft->open(of);
+	return 0;
+}
+
+static void cgroup_file_release(struct kernfs_open_file *of)
+{
+	struct cftype *cft = of->kn->priv;
+
+	if (cft->release)
+		cft->release(of);
+}
+
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 				 size_t nbytes, loff_t off)
 {
@@ -3553,7 +3570,8 @@ static void *cgroup_seqfile_next(struct seq_file *seq, void *v, loff_t *ppos)
 
 static void cgroup_seqfile_stop(struct seq_file *seq, void *v)
 {
-	seq_cft(seq)->seq_stop(seq, v);
+	if (seq_cft(seq)->seq_stop)
+		seq_cft(seq)->seq_stop(seq, v);
 }
 
 static int cgroup_seqfile_show(struct seq_file *m, void *arg)
@@ -3575,12 +3593,16 @@ static int cgroup_seqfile_show(struct seq_file *m, void *arg)
 
 static struct kernfs_ops cgroup_kf_single_ops = {
 	.atomic_write_len	= PAGE_SIZE,
+	.open			= cgroup_file_open,
+	.release		= cgroup_file_release,
 	.write			= cgroup_file_write,
 	.seq_show		= cgroup_seqfile_show,
 };
 
 static struct kernfs_ops cgroup_kf_ops = {
 	.atomic_write_len	= PAGE_SIZE,
+	.open			= cgroup_file_open,
+	.release		= cgroup_file_release,
 	.write			= cgroup_file_write,
 	.seq_start		= cgroup_seqfile_start,
 	.seq_next		= cgroup_seqfile_next,
-- 
2.9.3
