From: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] cgroup: Add blank lines after declarations.
Date: Tue, 15 Dec 2015 13:20:43 +0100
Message-ID: <1450182045-27480-4-git-send-email-kuba.kunert@gmail.com>
References: <1450182045-27480-1-git-send-email-kuba.kunert@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S5B08Ow8faxi8HrF4J9yejZCWsu//0WPibdcXFnHLxI=;
        b=Cx78GooXJMySE57WCZjjUY40t+Z6dyYkaD+S9zBbcCc59GyWQm3j+yNv3QFN4kYYc0
         /e1h9Xb1ZOvwajDR9/KBaJQ8+jZ1mFWu0HaG/btghUL00oFi5L4MNSHcXHPskvINWpSl
         XdqmAyYyetGonRZaVWxWnZLOzEWnNNgHtULrZLWLSNYzhW6Ew0SXiiIcF1mXywAnqueK
         WBA5GCkzdNbEhuiEdKXybc+wKSHlNdmI4U5vXAVL+dwb5DrxmIGi2MX7kgs4Uezv3khp
         gU7zJm/lKldB/YiSHERC0gxBFXBuNeTWDiB/b7PMIBdU32ooTNY6ygWQjuvUxFFRJD8k
         mb2Q==
In-Reply-To: <1450182045-27480-1-git-send-email-kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Fix checkpatch.pl warnings:

WARNING: Missing a blank line after declarations

Signed-off-by: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3e1e112..9e248bc 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1688,6 +1688,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			/* Must match [\w.-]+ */
 			for (i = 0; i < strlen(name); i++) {
 				char c = name[i];
+
 				if (isalnum(c))
 					continue;
 				if ((c == '.') || (c == '-') || (c == '_'))
@@ -3228,11 +3229,13 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 
 	if (cft->write_u64) {
 		unsigned long long v;
+
 		ret = kstrtoull(buf, 0, &v);
 		if (!ret)
 			ret = cft->write_u64(css, cft, v);
 	} else if (cft->write_s64) {
 		long long v;
+
 		ret = kstrtoll(buf, 0, &v);
 		if (!ret)
 			ret = cft->write_s64(css, cft, v);
@@ -4493,6 +4496,7 @@ static void *cgroup_pidlist_start(struct seq_file *s, loff_t *pos)
 
 		while (index < end) {
 			int mid = (index + end) / 2;
+
 			if (cgroup_pid_fry(cgrp, l->list[mid]) == pid) {
 				index = mid;
 				break;
@@ -5520,6 +5524,7 @@ static void **subsys_canfork_priv_p(void *ss_priv[CGROUP_CANFORK_COUNT], int i)
 static void *subsys_canfork_priv(void *ss_priv[CGROUP_CANFORK_COUNT], int i)
 {
 	void **private = subsys_canfork_priv_p(ss_priv, i);
+
 	return private ? *private : NULL;
 }
 
-- 
2.6.2
