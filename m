From: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH nf-next v3] netfilter: xtables: lightweight process control group matching
Date: Mon, 23 Dec 2013 18:41:18 +0100
Message-ID: <7d845623366ba0d435d5c82bf318455871929e90.1387815795.git.dborkman@redhat.com>
References: <cover.1387815795.git.dborkman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1387815795.git.dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org
Cc: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

It would be useful e.g. in a server or desktop environment to have
a facility in the notion of fine-grained "per application" or "per
application group" firewall policies. Probably, users in the mobile,
embedded area (e.g. Android based) with different security policy
requirements for application groups could have great benefit from
that as well. For example, with a little bit of configuration effort,
an admin could whitelist well-known applications, and thus block
otherwise unwanted "hard-to-track" applications like [1] from a
user's machine. Blocking is just one example, but it is not limited
to that, meaning we can have much different scenarios/policies that
netfilter allows us than just blocking, e.g. fine grained settings
where applications are allowed to connect/send traffic to, application
traffic marking/conntracking, application-specific packet mangling,
and so on.

Implementation of PID-based matching would not be appropriate
as they frequently change, and child tracking would make that
even more complex and ugly. Cgroups would be a perfect candidate
for accomplishing that as they associate a set of tasks with a
set of parameters for one or more subsystems, in our case the
netfilter subsystem, which, of course, can be combined with other
cgroup subsystems into something more complex if needed.

As mentioned, to overcome this constraint, such processes could
be placed into one or multiple cgroups where different fine-grained
rules can be defined depending on the application scenario, while
e.g. everything else that is not part of that could be dropped (or
vice versa), thus making life harder for unwanted processes to
communicate to the outside world. So, we make use of cgroups here
to track jobs and limit their resources in terms of iptables
policies; in other words, limiting, tracking, etc what they are
allowed to communicate.

In our case we're working on outgoing traffic based on which local
socket that originated from. Also, one doesn't even need to have
an a-prio knowledge of the application internals regarding their
particular use of ports or protocols. Matching is *extremly*
lightweight as we just test for the sk_classid marker of sockets,
originating from net_cls. net_cls and netfilter do not contradict
each other; in fact, each construct can live as standalone or they
can be used in combination with each other, which is perfectly fine,
plus it serves Tejun's requirement to not introduce a new cgroups
subsystem. Through this, we result in a very minimal and efficient
module, and don't add anything except netfilter code.

One possible, minimal usage example (many other iptables options
can be applied obviously):

 1) Configuring cgroups if not already done, e.g.:

  mkdir /sys/fs/cgroup/net_cls
  mount -t cgroup -o net_cls net_cls /sys/fs/cgroup/net_cls
  mkdir /sys/fs/cgroup/net_cls/0
  echo 1 > /sys/fs/cgroup/net_cls/0/net_cls.classid
  (resp. a real flow handle id for tc)

 2) Configuring netfilter (iptables-nftables), e.g.:

  iptables -A OUTPUT -m cgroup ! --cgroup 1 -j DROP

 3) Running applications, e.g.:

  ping 208.67.222.222  <pid:1799>
  echo 1799 > /sys/fs/cgroup/net_cls/0/tasks
  64 bytes from 208.67.222.222: icmp_seq=44 ttl=49 time=11.9 ms
  [...]
  ping 208.67.220.220  <pid:1804>
  ping: sendmsg: Operation not permitted
  [...]
  echo 1804 > /sys/fs/cgroup/net_cls/0/tasks
  64 bytes from 208.67.220.220: icmp_seq=89 ttl=56 time=19.0 ms
  [...]

Of course, real-world deployments would make use of cgroups user
space toolsuite, or own custom policy daemons dynamically moving
applications from/to various cgroups.

  [1] http://www.blackhat.com/presentations/bh-europe-06/bh-eu-06-biondi/bh-eu-06-biondi-up.pdf

Signed-off-by: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
  Previous discussions, design considerations etc can be found in:
   - v1: http://patchwork.ozlabs.org/patch/280687/
   - v1/alt: http://patchwork.ozlabs.org/patch/282477/
   - v2: http://patchwork.ozlabs.org/patch/284582/
  v1->v2:
   - Updated commit message, rebased
   - Applied Gao Feng's feedback
  v2->v3:
   - After discussions w/ Tejun, let's not add any cgroups code here,
     thus we _only_ add code in netfilter area, nowhere else, that's
     even more simple and cleaner than proposed.

 Documentation/cgroups/net_cls.txt        |  5 +++
 include/uapi/linux/netfilter/Kbuild      |  1 +
 include/uapi/linux/netfilter/xt_cgroup.h | 11 +++++
 net/netfilter/Kconfig                    | 10 +++++
 net/netfilter/Makefile                   |  1 +
 net/netfilter/xt_cgroup.c                | 71 ++++++++++++++++++++++++++++++++
 6 files changed, 99 insertions(+)
 create mode 100644 include/uapi/linux/netfilter/xt_cgroup.h
 create mode 100644 net/netfilter/xt_cgroup.c

diff --git a/Documentation/cgroups/net_cls.txt b/Documentation/cgroups/net_cls.txt
index 9face6b..ec18234 100644
--- a/Documentation/cgroups/net_cls.txt
+++ b/Documentation/cgroups/net_cls.txt
@@ -6,6 +6,8 @@ tag network packets with a class identifier (classid).
 
 The Traffic Controller (tc) can be used to assign
 different priorities to packets from different cgroups.
+Also, Netfilter (iptables) can use this tag to perform
+actions on such packets.
 
 Creating a net_cls cgroups instance creates a net_cls.classid file.
 This net_cls.classid value is initialized to 0.
@@ -32,3 +34,6 @@ tc class add dev eth0 parent 10: classid 10:1 htb rate 40mbit
  - creating traffic class 10:1
 
 tc filter add dev eth0 parent 10: protocol ip prio 10 handle 1: cgroup
+
+configuring iptables, basic example:
+iptables -A OUTPUT -m cgroup ! --cgroup 0x100001 -j DROP
diff --git a/include/uapi/linux/netfilter/Kbuild b/include/uapi/linux/netfilter/Kbuild
index 17c3af2..2e6b9e4 100644
--- a/include/uapi/linux/netfilter/Kbuild
+++ b/include/uapi/linux/netfilter/Kbuild
@@ -39,6 +39,7 @@ header-y += xt_TEE.h
 header-y += xt_TPROXY.h
 header-y += xt_addrtype.h
 header-y += xt_bpf.h
+header-y += xt_cgroup.h
 header-y += xt_cluster.h
 header-y += xt_comment.h
 header-y += xt_connbytes.h
diff --git a/include/uapi/linux/netfilter/xt_cgroup.h b/include/uapi/linux/netfilter/xt_cgroup.h
new file mode 100644
index 0000000..43acb7e
--- /dev/null
+++ b/include/uapi/linux/netfilter/xt_cgroup.h
@@ -0,0 +1,11 @@
+#ifndef _UAPI_XT_CGROUP_H
+#define _UAPI_XT_CGROUP_H
+
+#include <linux/types.h>
+
+struct xt_cgroup_info {
+	__u32 id;
+	__u32 invert;
+};
+
+#endif /* _UAPI_XT_CGROUP_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index c3398cd..bbdab88 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -858,6 +858,16 @@ config NETFILTER_XT_MATCH_BPF
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_CGROUP
+	tristate '"control group" match support'
+	depends on NETFILTER_ADVANCED
+	depends on CGROUPS
+	select NET_CLS_CGROUP
+	---help---
+	Socket/process control group matching allows you to match locally
+	generated packets based on which net_cls control group processes
+	belong to.
+
 config NETFILTER_XT_MATCH_CLUSTER
 	tristate '"cluster" match support'
 	depends on NF_CONNTRACK
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 394483b..9345365 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -142,6 +142,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_MULTIPORT) += xt_multiport.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_NFACCT) += xt_nfacct.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_OSF) += xt_osf.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_OWNER) += xt_owner.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_CGROUP) += xt_cgroup.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) += xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
new file mode 100644
index 0000000..66107a7
--- /dev/null
+++ b/net/netfilter/xt_cgroup.c
@@ -0,0 +1,71 @@
+/*
+ * Xtables module to match the process control group.
+ *
+ * Might be used to implement individual "per-application" firewall
+ * policies in contrast to global policies based on control groups.
+ * Matching is based upon processes tagged to net_cls' classid marker.
+ *
+ * (C) 2013 Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/skbuff.h>
+#include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_cgroup.h>
+#include <net/sock.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>");
+MODULE_DESCRIPTION("Xtables: process control group matching");
+MODULE_ALIAS("ipt_cgroup");
+MODULE_ALIAS("ip6t_cgroup");
+
+static int cgroup_mt_check(const struct xt_mtchk_param *par)
+{
+	struct xt_cgroup_info *info = par->matchinfo;
+
+	if (info->invert & ~1)
+		return -EINVAL;
+
+	return info->id ? 0 : -EINVAL;
+}
+
+static bool
+cgroup_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_cgroup_info *info = par->matchinfo;
+
+	if (skb->sk == NULL)
+		return false;
+
+	return (info->id == skb->sk->sk_classid) ^ info->invert;
+}
+
+static struct xt_match cgroup_mt_reg __read_mostly = {
+	.name       = "cgroup",
+	.revision   = 0,
+	.family     = NFPROTO_UNSPEC,
+	.checkentry = cgroup_mt_check,
+	.match      = cgroup_mt,
+	.matchsize  = sizeof(struct xt_cgroup_info),
+	.me         = THIS_MODULE,
+	.hooks      = (1 << NF_INET_LOCAL_OUT) |
+		      (1 << NF_INET_POST_ROUTING),
+};
+
+static int __init cgroup_mt_init(void)
+{
+	return xt_register_match(&cgroup_mt_reg);
+}
+
+static void __exit cgroup_mt_exit(void)
+{
+	xt_unregister_match(&cgroup_mt_reg);
+}
+
+module_init(cgroup_mt_init);
+module_exit(cgroup_mt_exit);
-- 
1.7.11.7
