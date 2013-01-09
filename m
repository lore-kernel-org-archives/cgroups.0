From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3.4 1/2] cgroup: Take css_set_lock when calling cgroup_css_sets_empty()
Date: Wed,  9 Jan 2013 16:03:41 +0100
Message-ID: <1357743822-21707-2-git-send-email-hdegoede@redhat.com>
References: <1357743822-21707-1-git-send-email-hdegoede@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357743822-21707-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

As indicated in the comment above cgroup_css_sets_empty the
css_set_lock must be hold when calling it.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c908354..59e711a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3980,7 +3980,10 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	/* the vfs holds both inode->i_mutex already */
 again:
 	mutex_lock(&cgroup_mutex);
-	if (!cgroup_css_sets_empty(cgrp)) {
+	read_lock(&css_set_lock);
+	ret = cgroup_css_sets_empty(cgrp);
+	read_unlock(&css_set_lock);
+	if (!ret) {
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
-- 
1.8.0.2
