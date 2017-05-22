From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/9] Provide /proc/containers
Date: Mon, 22 May 2017 17:22:50 +0100
Message-ID: <149547017022.10599.5306651307833246385.stgit@warthog.procyon.org.uk>
References: <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 95DF7665A
In-Reply-To: <149547014649.10599.12025037906646164347.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
Cc: mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org

Provide /proc/containers to view the current container and all the
containers created within it:

	# ./foo-container
	NAME                     USE FL OWNER GROUP
	<current>                141 01 0     0
	foo-test                   1 04 0     0

I'm not sure whether this is really desirable, though.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 kernel/container.c |  104 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/kernel/container.c b/kernel/container.c
index eef1566835eb..d5849c07a76b 100644
--- a/kernel/container.c
+++ b/kernel/container.c
@@ -22,6 +22,7 @@
 #include <linux/syscalls.h>
 #include <linux/printk.h>
 #include <linux/security.h>
+#include <linux/proc_fs.h>
 #include "namespaces.h"
 
 struct container init_container = {
@@ -70,6 +71,108 @@ void put_container(struct container *c)
 	}
 }
 
+static void *container_proc_start(struct seq_file *m, loff_t *_pos)
+{
+	struct container *c = m->private;
+	struct list_head *p;
+	loff_t pos = *_pos;
+
+	spin_lock(&c->lock);
+
+	if (pos <= 1) {
+		*_pos = 1;
+		return (void *)1UL; /* Banner on first line */
+	}
+
+	if (pos == 2)
+		return m->private; /* Current container on second line */
+
+	/* Subordinate containers thereafter */
+	p = c->children.next;
+	pos--;
+	for (pos--; pos > 0 && p != &c->children; pos--) {
+		p = p->next;
+	}
+
+	if (p == &c->children)
+		return NULL;
+	return container_of(p, struct container, child_link);
+}
+
+static void *container_proc_next(struct seq_file *m, void *v, loff_t *_pos)
+{
+	struct container *c = m->private, *vc = v;
+	struct list_head *p;
+	loff_t pos = *_pos;
+
+	pos++;
+	*_pos = pos;
+	if (pos == 2)
+		return c; /* Current container on second line */
+
+	if (pos == 3)
+		p = &c->children;
+	else
+		p = &vc->child_link;
+	p = p->next;
+	if (p == &c->children)
+		return NULL;
+	return container_of(p, struct container, child_link);
+}
+
+static void container_proc_stop(struct seq_file *m, void *v)
+{
+	struct container *c = m->private;
+
+	spin_unlock(&c->lock);
+}
+
+static int container_proc_show(struct seq_file *m, void *v)
+{
+	struct user_namespace *uns = current_user_ns();
+	struct container *c = v;
+	const char *name;
+
+	if (v == (void *)1UL) {
+		seq_puts(m, "NAME                     USE FL OWNER GROUP\n");
+		return 0;
+	}
+
+	name = (c == m->private) ? "<current>" : c->name;
+	seq_printf(m, "%-24s %3u %02lx %0d %5d\n",
+		   name, refcount_read(&c->usage), c->flags,
+		   from_kuid_munged(uns, c->cred->uid),
+		   from_kgid_munged(uns, c->cred->gid));
+
+	return 0;
+}
+
+static const struct seq_operations container_proc_ops = {
+	.start	= container_proc_start,
+	.next	= container_proc_next,
+	.stop	= container_proc_stop,
+	.show	= container_proc_show,
+};
+
+static int container_proc_open(struct inode *inode, struct file *file)
+{
+	struct seq_file *m;
+	int ret = seq_open(file, &container_proc_ops);
+
+	if (ret == 0) {
+		m = file->private_data;
+		m->private = current->container;
+	}
+	return ret;
+}
+
+static const struct file_operations container_proc_fops = {
+	.open		= container_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 /*
  * Allow the user to poll for the container dying.
  */
@@ -230,6 +333,7 @@ static int __init init_container_fs(void)
 		panic("Cannot mount containerfs: %ld\n",
 		      PTR_ERR(containerfs_mnt));
 
+	proc_create("containers", 0, NULL, &container_proc_fops);
 	return 0;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
