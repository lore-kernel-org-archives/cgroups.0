From: Alban Crequy <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Subject: [PATCH] [RFC] cgroup: reject cgroup names with non-printing characters
Date: Mon, 21 Jul 2014 16:11:56 +0100
Message-ID: <1405955516-22016-1-git-send-email-alban.crequy@collabora.co.uk>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Alban Crequy <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>

/proc/<pid>/cgroup contains one cgroup path on each line. If cgroup names are
allowed to contain "\n", applications cannot parse /proc/<pid>/cgroup safely.

I use < 0x20 as seen in vfat_bad_char; is it safe to use isprint()?

Signed-off-by: Alban Crequy <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
---
 kernel/cgroup.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 70776ae..e2df5e7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4378,6 +4378,20 @@ err_free_css:
 	return err;
 }
 
+/* Inspired by vfat_bad_char: do not accept non-printing characters. In
+ * particular, reject '\n' to prevent making /proc/<pid>/cgroup unparsable.
+ */
+static inline int cgroup_is_used_badchars(const char *s)
+{
+	int i;
+
+	for (i = 0; s[i] != '\0'; i++)
+		if (s[i] < 0x20)
+			return -EINVAL;
+
+	return 0;
+}
+
 static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 			umode_t mode)
 {
@@ -4387,6 +4401,11 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	struct kernfs_node *kn;
 	int ssid, ret;
 
+	/* do not create cgroups with bad names */
+	ret = cgroup_is_used_badchars(name);
+	if (ret)
+		return ret;
+
 	parent = cgroup_kn_lock_live(parent_kn);
 	if (!parent)
 		return -ENODEV;
-- 
1.8.5.3
