From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [RFC 4/4] fslist netlink interface
Date: Mon, 23 Jan 2012 20:56:12 +0400
Message-ID: <1327337772-1972-5-git-send-email-glommer@parallels.com>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327337772-1972-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

This patch provides a netlink interaface for the namespace filesystem list.
It is quite simple, and I need at least one more operation (query).

Also, keep in mind that although I wrote it believing it is a nice
interface to manipulate the list, I don't feel strongly about the
interface per-se. So feel free to suggest something better.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 fs/Kconfig                     |    9 +++
 fs/Makefile                    |    1 +
 fs/fsnetlink.c                 |  145 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fslist_netlink.h |   35 ++++++++++
 4 files changed, 190 insertions(+), 0 deletions(-)
 create mode 100644 fs/fsnetlink.c
 create mode 100644 include/linux/fslist_netlink.h

diff --git a/fs/Kconfig b/fs/Kconfig
index 440d189..842dcc4 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -78,6 +78,15 @@ config GENERIC_ACL
 	bool
 	select FS_POSIX_ACL
 
+config FSLIST_NETLINK
+	bool "Filesystem Lists Netlink"
+	help
+	  This option allows userspace to select a sublist of the available
+	  filesystems that are mountable by a particular namespace. It provides
+	  a netlink interface through which one can manage such a set.
+
+
+
 menu "Caches"
 
 source "fs/fscache/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index 57d446d..675f613 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_FS_MBCACHE)	+= mbcache.o
 obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o xattr_acl.o
 obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
+obj-$(CONFIG_FSLIST_NETLINK)	+= fsnetlink.o
 
 obj-$(CONFIG_FHANDLE)		+= fhandle.o
 
diff --git a/fs/fsnetlink.c b/fs/fsnetlink.c
new file mode 100644
index 0000000..619fad1
--- /dev/null
+++ b/fs/fsnetlink.c
@@ -0,0 +1,145 @@
+#include <net/genetlink.h>
+#include <linux/fslist_netlink.h>
+#include <linux/gfp.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/nsproxy.h>
+#include <linux/mnt_namespace.h>
+#include <linux/fs_struct.h>
+#include <linux/dcache.h>
+
+static struct nla_policy fslist_genl_policy[FSLIST_A_MAX + 1] = {
+	[FSLIST_A_OP] = { .type = NLA_U32 },
+	[FSLIST_A_OP_ARG] = { .type = NLA_STRING, .len = 200 },
+};
+
+static struct genl_family fslist_gnl_family = {
+	.id		= GENL_ID_GENERATE,
+	.name		= FSLIST_GENL_NAME,
+	.version	= FSLIST_GENL_VERSION,
+	.maxattr	= FSLIST_A_MAX,
+};
+
+static int msg_reply(int ret, struct genl_info *info)
+{
+        struct sk_buff *skb;
+        void *reply;
+	size_t size;
+	struct genlmsghdr *genlhdr;
+	void *data;
+
+	size =  nla_total_size(1) +
+		nla_total_size(0);
+
+	skb = genlmsg_new(size, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	reply = genlmsg_put_reply(skb, info, &fslist_gnl_family, 0, FSLIST_CMD_REPLY);
+	if (reply == NULL) {
+		nlmsg_free(skb);
+		return -EINVAL;
+	}
+
+	nla_put_u32(skb, FSLIST_A_OP, ret);
+
+	genlhdr = nlmsg_data((struct nlmsghdr *)skb->data);
+	data = genlmsg_data(genlhdr);
+
+	ret = genlmsg_end(skb, data);
+	if (ret < 0) {
+		nlmsg_free(skb);
+		return ret;
+	}
+
+	return genlmsg_reply(skb, info);
+}
+
+
+static int cmd_ask(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *na;
+	int op = 0;
+	char *data = NULL;
+	int ret = 0;
+	struct mnt_namespace *mnt = current->nsproxy->mnt_ns;
+	struct dentry *curr_root;
+	int msg_ret = 0;
+
+	/*
+	 * Once a process is contained by a chroot environment,
+	 * we don't allow the list to grow further, or be by
+	 * any means modified. 
+	 *
+	 * It should still work after pivot_root, though.
+	 */
+	curr_root = current->fs->root.dentry;
+	if (curr_root->d_parent != curr_root)
+		return -EINVAL;
+
+	na = info->attrs[FSLIST_A_OP];
+	if (na) 
+		op = nla_get_u32(na);
+
+	na = info->attrs[FSLIST_A_OP_ARG];
+	if (na) {
+		int len = nla_len(na);
+
+		data = kmalloc(len, GFP_KERNEL);
+		if (!data)
+			return -ENOMEM;
+
+		nla_strlcpy(data, na, len);
+	}
+
+	switch (op) {
+	case FSLIST_OP_RESET:
+		enable_filesystems_list(mnt);
+		break;
+	case FSLIST_OP_ADD:
+		if (!data) {
+			ret = -EINVAL;
+			break;
+		}
+		msg_ret = add_filesystem_list(data, mnt);
+		break;
+	case FSLIST_OP_QUERY:
+		ret = -ENOSYS;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	
+	kfree(data);
+	if (!ret)
+		msg_reply(msg_ret, info);
+	return ret;
+}
+
+static struct genl_ops fslist_nl_ops = {
+	.cmd		= FSLIST_CMD_ASK,
+	.doit		= cmd_ask,
+	.policy 	= fslist_genl_policy,
+};
+
+int __init fslist_netlink_init(void)
+{
+	int ret;
+	ret = genl_register_family(&fslist_gnl_family);
+	if (ret) 
+		return ret;
+	
+	ret = genl_register_ops(&fslist_gnl_family, &fslist_nl_ops);
+	if (ret)
+		goto fail_unregister;
+
+	return 0;
+
+fail_unregister:
+	genl_unregister_family(&fslist_gnl_family);
+	return ret;
+}
+
+fs_initcall(fslist_netlink_init);
+
diff --git a/include/linux/fslist_netlink.h b/include/linux/fslist_netlink.h
new file mode 100644
index 0000000..926760d
--- /dev/null
+++ b/include/linux/fslist_netlink.h
@@ -0,0 +1,35 @@
+#ifndef _FSLIST_NETLINK_H
+#define _FSLIST_NETLINK_H
+
+#ifdef __KERNEL__
+#include <linux/types.h>
+#endif
+
+enum {
+	FSLIST_A_UNSPEC,
+	FSLIST_A_OP,
+	FSLIST_A_OP_ARG,
+	__FSLIST_A_MAX,
+};
+
+#define FSLIST_A_MAX (__FSLIST_A_MAX - 1)
+
+enum {
+	FSLIST_CMD_UNSPEC = 0,
+	FSLIST_CMD_ASK,		/* user->kernel */
+	FSLIST_CMD_REPLY,	/* kernel->user */
+	__FSLIST_CMD_MAX,
+};
+
+#define FSLIST_CMD_MAX (__FSLIST_CMD_MAX - 1)
+
+#define FSLIST_GENL_VERSION 0x1
+#define FSLIST_GENL_NAME "FSLIST"
+
+enum {
+	FSLIST_OP_RESET = 1,
+	FSLIST_OP_ADD,
+	FSLIST_OP_QUERY,
+};
+
+#endif /* _FSLIST_NETLINK_H */
-- 
1.7.7.4
