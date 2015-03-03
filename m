From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/1] cgroup: fix var may be used uninitialized warning
Date: Tue,  3 Mar 2015 09:59:47 +0100
Message-ID: <1425373187-7227-1-git-send-email-javier.martinez@collabora.co.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Javier Martinez Canillas <javier.martinez@collabora.co.uk>

When building cgroup, GCC warns that the root variable
may be used uninitialized in the cgroup_mount function.

kernel/cgroup.c: In function =E2=80=98cgroup_mount=E2=80=99:
kernel/cgroup.c:1886:13: warning: =E2=80=98root=E2=80=99 may be used un=
initialized in this function [-Wuninitialized]
kernel/cgroup.c:1742:22: note: =E2=80=98root=E2=80=99 was declared here

This can never happen because if the struct cgroup_root
can't be allocated, ret is set to -ENOMEM and the error
returned so the code using root is not reachable. But
set root to NULL just to silence the compiler warning.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.u=
k>
---

This patch is on top of today's linux-next (tag: next-20150303).

 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9a567836ee3a..bf1172d1c831 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1739,7 +1739,7 @@ static struct dentry *cgroup_mount(struct file_sy=
stem_type *fs_type,
 {
 	struct super_block *pinned_sb =3D NULL;
 	struct cgroup_subsys *ss;
-	struct cgroup_root *root;
+	struct cgroup_root *root =3D NULL;
 	struct cgroup_sb_opts opts;
 	struct dentry *dentry;
 	int ret;
--=20
2.1.3
