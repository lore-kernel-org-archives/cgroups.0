From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.12] cgroup: replace
 task_cgroup_path_from_hierarchy() with task_cgroup_path()
Date: Thu, 11 Jul 2013 16:34:48 -0700
Message-ID: <20130711233448.GA2359@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        bh=ghUblUBmWLk1WYzJPqGh61kPRPy141h1N2xjPchTvcw=;
        b=ca1SOS76tmlCImNeKZuWJP76iCpVV9cDs31OEhPNgNwU0w+PnI1nwggnk92Y8QZq9m
         vT19tGjPuRh3UQHKXXwvPEqZxd3AkIbkty67upUBeZcUZcTX5+M3g+IVe+n3RsEBxNyO
         ZTBtgMnkyf9WWrwMKecYPUeBppwsnFDxHu0schL2Tj6DZEOydZwWcFL8s/Zy76J92CcG
         ARQ7EMDdIVQZ+Mlg5iI79UTqNN+TsUg9hPH0SkPz9VxqsfzcGIBYqDvXnhNv9ny0l2sN
         gUTRwH1UAG+KBgiB2FJh+uCvQz4punWHL+SAf7QwWe1f3ml0f3Fr6YXb2bqUEjuzoi6d
         aBtQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Jan =?utf-8?Q?Kalu=C5=BEa?= <jkaluza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


task_cgroup_path_from_hierarchy() was added for the planned new users
and none of the currently planned users wants to know about multiple
hierarchies.  This patch drops the multiple hierarchy part and makes
it always return the path in the first non-dummy hierarchy.

As unified hierarchy will always have id 1, this is guaranteed to
return the path for the unified hierarchy if mounted; otherwise, it
will return the path from the hierarchy which happens to occupy the
lowest hierarchy id, which will usually be the first hierarchy mounted
after boot.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Cc: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Cc: Jan Kalu=C5=BEa <jkaluza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |    3 +--
 kernel/cgroup.c        |   31 +++++++++++++++++++------------
 2 files changed, 20 insertions(+), 14 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -533,8 +533,7 @@ int cgroup_rm_cftypes(struct cgroup_subs
 bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor=
);
=20
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
-int task_cgroup_path_from_hierarchy(struct task_struct *task, int hier=
archy_id,
-				    char *buf, size_t buflen);
+int task_cgroup_path(struct task_struct *task, char *buf, size_t bufle=
n);
=20
 int cgroup_task_count(const struct cgroup *cgrp);
=20
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1797,36 +1797,43 @@ out:
 EXPORT_SYMBOL_GPL(cgroup_path);
=20
 /**
- * task_cgroup_path_from_hierarchy - cgroup path of a task on a hierar=
chy
+ * task_cgroup_path - cgroup path of a task in the first cgroup hierar=
chy
  * @task: target task
- * @hierarchy_id: the hierarchy to look up @task's cgroup from
  * @buf: the buffer to write the path into
  * @buflen: the length of the buffer
  *
- * Determine @task's cgroup on the hierarchy specified by @hierarchy_i=
d and
- * copy its path into @buf.  This function grabs cgroup_mutex and shou=
ldn't
- * be used inside locks used by cgroup controller callbacks.
+ * Determine @task's cgroup on the first (the one with the lowest non-=
zero
+ * hierarchy_id) cgroup hierarchy and copy its path into @buf.  This
+ * function grabs cgroup_mutex and shouldn't be used inside locks used=
 by
+ * cgroup controller callbacks.
+ *
+ * Returns 0 on success, fails with -%ENAMETOOLONG if @buflen is too s=
hort.
  */
-int task_cgroup_path_from_hierarchy(struct task_struct *task, int hier=
archy_id,
-				    char *buf, size_t buflen)
+int task_cgroup_path(struct task_struct *task, char *buf, size_t bufle=
n)
 {
 	struct cgroupfs_root *root;
-	struct cgroup *cgrp =3D NULL;
-	int ret =3D -ENOENT;
+	struct cgroup *cgrp;
+	int hierarchy_id =3D 1, ret =3D 0;
+
+	if (buflen < 2)
+		return -ENAMETOOLONG;
=20
 	mutex_lock(&cgroup_mutex);
=20
-	root =3D idr_find(&cgroup_hierarchy_idr, hierarchy_id);
+	root =3D idr_get_next(&cgroup_hierarchy_idr, &hierarchy_id);
+
 	if (root) {
 		cgrp =3D task_cgroup_from_root(task, root);
 		ret =3D cgroup_path(cgrp, buf, buflen);
+	} else {
+		/* if no hierarchy exists, everyone is in "/" */
+		memcpy(buf, "/", 2);
 	}
=20
 	mutex_unlock(&cgroup_mutex);
-
 	return ret;
 }
-EXPORT_SYMBOL_GPL(task_cgroup_path_from_hierarchy);
+EXPORT_SYMBOL_GPL(task_cgroup_path);
=20
 /*
  * Control Group taskset
