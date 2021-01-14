From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup: Remove unnecessary call to strstrip()
Date: Thu, 14 Jan 2021 13:44:27 +0100
Message-ID: <YAA8qyBUAurgCeEz@blackbook>
References: <20210103024846.GA15337@haolee.github.io>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610628275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DQyI62Ts2y3vpFgTZP2ClEtzkdY49hYrxY8Mhozx6ZM=;
        b=XAL1/7+PnbWKJjPsHK2l1e7zdnCyCA6cNoVLhsOcIv/DDJm4AK7WHj9S2Arzd5PCFYJSn+
        xxO+/a0tZw/Lteq0FAH8cR6bcfPpiajZOAief4od7tLB3lar/3SgZRX/3zADC460uN+jAy
        lA4NzgX15rJriC50h7F2Ix71Z1UCkGs=
Content-Disposition: inline
In-Reply-To: <20210103024846.GA15337-aLGwGs2JoHKXlosIQRE7iA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

On Sun, Jan 03, 2021 at 02:50:01AM +0000, Hao Lee <haolee.swjtu-Re5JQEeQqe8=
AvxtiuMwx3w@public.gmane.org> wrote:
> The string buf will be stripped in cgroup_procs_write_start() before it
> is converted to int, so remove this unnecessary call to strstrip().
Good catch, Hao.

Perhaps the code be then simplified a bit

-- >8 --
From: =3D?UTF-8?q?Michal=3D20Koutn=3DC3=3DBD?=3D <mkoutny-IBi9RG/b67k@publi=
c.gmane.org>
Date: Thu, 14 Jan 2021 13:23:39 +0100
Subject: [PATCH] cgroup: cgroup.{procs,threads} factor out common parts
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

The functions cgroup_threads_start and cgroup_procs_start are almost
identical. In order to reduce duplication, factor out the common code in
similar fashion we already do for other threadgroup/task functions. No
functional changes are intended.

Suggested-by: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 55 +++++++++++-------------------------------
 1 file changed, 14 insertions(+), 41 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 613845769103c..f6279df507f4b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4726,8 +4726,8 @@ static int cgroup_attach_permissions(struct cgroup *s=
rc_cgrp,
 	return ret;
 }
=20
-static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
-				  char *buf, size_t nbytes, loff_t off)
+static ssize_t __cgroup_procs_write(struct kernfs_open_file *of, char *buf,
+				    bool threadgroup)
 {
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
@@ -4738,7 +4738,7 @@ static ssize_t cgroup_procs_write(struct kernfs_open_=
file *of,
 	if (!dst_cgrp)
 		return -ENODEV;
=20
-	task =3D cgroup_procs_write_start(buf, true, &locked);
+	task =3D cgroup_procs_write_start(buf, threadgroup, &locked);
 	ret =3D PTR_ERR_OR_ZERO(task);
 	if (ret)
 		goto out_unlock;
@@ -4748,19 +4748,26 @@ static ssize_t cgroup_procs_write(struct kernfs_ope=
n_file *of,
 	src_cgrp =3D task_cgroup_from_root(task, &cgrp_dfl_root);
 	spin_unlock_irq(&css_set_lock);
=20
+	/* process and thread migrations follow same delegation rule */
 	ret =3D cgroup_attach_permissions(src_cgrp, dst_cgrp,
-					of->file->f_path.dentry->d_sb, true);
+					of->file->f_path.dentry->d_sb, threadgroup);
 	if (ret)
 		goto out_finish;
=20
-	ret =3D cgroup_attach_task(dst_cgrp, task, true);
+	ret =3D cgroup_attach_task(dst_cgrp, task, threadgroup);
=20
 out_finish:
 	cgroup_procs_write_finish(task, locked);
 out_unlock:
 	cgroup_kn_unlock(of->kn);
=20
-	return ret ?: nbytes;
+	return ret;
+}
+
+static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
+				  char *buf, size_t nbytes, loff_t off)
+{
+	return __cgroup_procs_write(of, buf, true) ?: nbytes;
 }
=20
 static void *cgroup_threads_start(struct seq_file *s, loff_t *pos)
@@ -4771,41 +4778,7 @@ static void *cgroup_threads_start(struct seq_file *s=
, loff_t *pos)
 static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 				    char *buf, size_t nbytes, loff_t off)
 {
-	struct cgroup *src_cgrp, *dst_cgrp;
-	struct task_struct *task;
-	ssize_t ret;
-	bool locked;
-
-	buf =3D strstrip(buf);
-
-	dst_cgrp =3D cgroup_kn_lock_live(of->kn, false);
-	if (!dst_cgrp)
-		return -ENODEV;
-
-	task =3D cgroup_procs_write_start(buf, false, &locked);
-	ret =3D PTR_ERR_OR_ZERO(task);
-	if (ret)
-		goto out_unlock;
-
-	/* find the source cgroup */
-	spin_lock_irq(&css_set_lock);
-	src_cgrp =3D task_cgroup_from_root(task, &cgrp_dfl_root);
-	spin_unlock_irq(&css_set_lock);
-
-	/* thread migrations follow the cgroup.procs delegation rule */
-	ret =3D cgroup_attach_permissions(src_cgrp, dst_cgrp,
-					of->file->f_path.dentry->d_sb, false);
-	if (ret)
-		goto out_finish;
-
-	ret =3D cgroup_attach_task(dst_cgrp, task, false);
-
-out_finish:
-	cgroup_procs_write_finish(task, locked);
-out_unlock:
-	cgroup_kn_unlock(of->kn);
-
-	return ret ?: nbytes;
+	return __cgroup_procs_write(of, buf, false) ?: nbytes;
 }
=20
 /* cgroup core interface files for the default hierarchy */
--=20
2.29.2

