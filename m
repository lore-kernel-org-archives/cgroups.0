From: Dmitry Yakunin <zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: [PATCH iproute2-next v2 3/3] ss: add checks for bc filter support
Date: Sat,  9 May 2020 19:52:02 +0300
Message-ID: <20200509165202.17959-3-zeil@yandex-team.ru>
References: <20200509165202.17959-1-zeil@yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1589043171; bh=8k209FJXinjPV43znfx17gvseR4z9Ra4J9eybSHcz/s=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=jJOJvZfRM/NeBG6xUQsKebwBdxzXs55cw2qCbS+Px8HIM4apTo+xLIzUjbBsqjsCJ
         g4mqVlXD4zzhL/URfDmpRaExHdhgkqdtCwflanMmw/w35k0IVv8/PzIIizsuavPp6l
         vryQpH9gx3WTe2yz/OSBHkYzS7ic7KRw//u70u4k=
In-Reply-To: <20200509165202.17959-1-zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

As noted by David Ahern, now if some bytecode filter is not supported
by running kernel printed error message is not clear. This patch is attempt to
detect such case and print correct message. This is done by providing checking
function for new filter types. As example check function for cgroup filter
is implemented. It sends correct lightweight request (idiag_states = 0)
with zero cgroup condition to the kernel and checks returned errno. If filter
is not supported EINVAL is returned. Result of checking is cached to
avoid extra checks if several same filters are specified.

Signed-off-by: Dmitry Yakunin <zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
---
 misc/Makefile         |   2 +-
 misc/ss.c             |  17 +--------
 misc/ss_util.h        |  22 +++++++++++
 misc/ssfilter.h       |  34 +++++++++--------
 misc/ssfilter.y       |   9 ++++-
 misc/ssfilter_check.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 154 insertions(+), 33 deletions(-)
 create mode 100644 misc/ss_util.h
 create mode 100644 misc/ssfilter_check.c

diff --git a/misc/Makefile b/misc/Makefile
index 1debfb1..50dae79 100644
--- a/misc/Makefile
+++ b/misc/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-SSOBJ=ss.o ssfilter.tab.o
+SSOBJ=ss.o ssfilter_check.o ssfilter.tab.o
 LNSTATOBJ=lnstat.o lnstat_util.o
 
 TARGETS=ss nstat ifstat rtacct lnstat
diff --git a/misc/ss.c b/misc/ss.c
index b9e6b15..1891e9c 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -29,6 +29,7 @@
 #include <limits.h>
 #include <stdarg.h>
 
+#include "ss_util.h"
 #include "utils.h"
 #include "rt_names.h"
 #include "ll_map.h"
@@ -39,8 +40,6 @@
 #include "cg_map.h"
 
 #include <linux/tcp.h>
-#include <linux/sock_diag.h>
-#include <linux/inet_diag.h>
 #include <linux/unix_diag.h>
 #include <linux/netdevice.h>	/* for MAX_ADDR_LEN */
 #include <linux/filter.h>
@@ -63,24 +62,10 @@
 #define AF_VSOCK PF_VSOCK
 #endif
 
-#define MAGIC_SEQ 123456
 #define BUF_CHUNK (1024 * 1024)	/* Buffer chunk allocation size */
 #define BUF_CHUNKS_MAX 5	/* Maximum number of allocated buffer chunks */
 #define LEN_ALIGN(x) (((x) + 1) & ~1)
 
-#define DIAG_REQUEST(_req, _r)						    \
-	struct {							    \
-		struct nlmsghdr nlh;					    \
-		_r;							    \
-	} _req = {							    \
-		.nlh = {						    \
-			.nlmsg_type = SOCK_DIAG_BY_FAMILY,		    \
-			.nlmsg_flags = NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST,\
-			.nlmsg_seq = MAGIC_SEQ,				    \
-			.nlmsg_len = sizeof(_req),			    \
-		},							    \
-	}
-
 #if HAVE_SELINUX
 #include <selinux/selinux.h>
 #else
diff --git a/misc/ss_util.h b/misc/ss_util.h
new file mode 100644
index 0000000..f7e40bb
--- /dev/null
+++ b/misc/ss_util.h
@@ -0,0 +1,22 @@
+#ifndef __SS_UTIL_H__
+#define __SS_UTIL_H__
+
+#include <linux/sock_diag.h>
+#include <linux/inet_diag.h>
+
+#define MAGIC_SEQ 123456
+
+#define DIAG_REQUEST(_req, _r)						    \
+	struct {							    \
+		struct nlmsghdr nlh;					    \
+		_r;							    \
+	} _req = {							    \
+		.nlh = {						    \
+			.nlmsg_type = SOCK_DIAG_BY_FAMILY,		    \
+			.nlmsg_flags = NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST,\
+			.nlmsg_seq = MAGIC_SEQ,				    \
+			.nlmsg_len = sizeof(_req),			    \
+		},							    \
+	}
+
+#endif /* __SS_UTIL_H__ */
diff --git a/misc/ssfilter.h b/misc/ssfilter.h
index d85c084..0be3b1e 100644
--- a/misc/ssfilter.h
+++ b/misc/ssfilter.h
@@ -1,20 +1,24 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#define SSF_DCOND 0
-#define SSF_SCOND 1
-#define SSF_OR	  2
-#define SSF_AND	  3
-#define SSF_NOT	  4
-#define SSF_D_GE  5
-#define SSF_D_LE  6
-#define SSF_S_GE  7
-#define SSF_S_LE  8
-#define SSF_S_AUTO  9
-#define SSF_DEVCOND 10
-#define SSF_MARKMASK 11
-#define SSF_CGROUPCOND 12
-
 #include <stdbool.h>
 
+enum {
+	SSF_DCOND,
+	SSF_SCOND,
+	SSF_OR,
+	SSF_AND,
+	SSF_NOT,
+	SSF_D_GE,
+	SSF_D_LE,
+	SSF_S_GE,
+	SSF_S_LE,
+	SSF_S_AUTO,
+	SSF_DEVCOND,
+	SSF_MARKMASK,
+	SSF_CGROUPCOND,
+	SSF__MAX
+};
+
+bool ssfilter_is_supported(int type);
+
 struct ssfilter
 {
 	int type;
diff --git a/misc/ssfilter.y b/misc/ssfilter.y
index b417579..8e16b44 100644
--- a/misc/ssfilter.y
+++ b/misc/ssfilter.y
@@ -12,7 +12,14 @@ typedef struct ssfilter * ssfilter_t;
 
 static struct ssfilter * alloc_node(int type, void *pred)
 {
-	struct ssfilter *n = malloc(sizeof(*n));
+	struct ssfilter *n;
+
+	if (!ssfilter_is_supported(type)) {
+		fprintf(stderr, "It looks like such filter is not supported! Too old kernel?\n");
+		exit(-1);
+	}
+
+	n = malloc(sizeof(*n));
 	if (n == NULL)
 		abort();
 	n->type = type;
diff --git a/misc/ssfilter_check.c b/misc/ssfilter_check.c
new file mode 100644
index 0000000..38c960c
--- /dev/null
+++ b/misc/ssfilter_check.c
@@ -0,0 +1,103 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+
+#include "libnetlink.h"
+#include "ssfilter.h"
+#include "ss_util.h"
+
+static int dummy_filter(struct nlmsghdr *n, void *arg)
+{
+	/* just stops rtnl_dump_filter() */
+	return -1;
+}
+
+static bool cgroup_filter_check(void)
+{
+	struct sockaddr_nl nladdr = { .nl_family = AF_NETLINK };
+	DIAG_REQUEST(req, struct inet_diag_req_v2 r);
+	struct instr {
+		struct inet_diag_bc_op op;
+		__u64 cgroup_id;
+	} __attribute__((packed));
+	int inslen = sizeof(struct instr);
+	struct instr instr = {
+		{ INET_DIAG_BC_CGROUP_COND, inslen, inslen + 4 },
+		0
+	};
+	struct rtnl_handle rth;
+	struct iovec iov[3];
+	struct msghdr msg;
+	struct rtattr rta;
+	int ret = false;
+	int iovlen = 3;
+
+	if (rtnl_open_byproto(&rth, 0, NETLINK_SOCK_DIAG))
+		return false;
+	rth.dump = MAGIC_SEQ;
+	rth.flags = RTNL_HANDLE_F_SUPPRESS_NLERR;
+
+	memset(&req.r, 0, sizeof(req.r));
+	req.r.sdiag_family = AF_INET;
+	req.r.sdiag_protocol = IPPROTO_TCP;
+	req.nlh.nlmsg_len += RTA_LENGTH(inslen);
+
+	rta.rta_type = INET_DIAG_REQ_BYTECODE;
+	rta.rta_len = RTA_LENGTH(inslen);
+
+	iov[0] = (struct iovec) { &req, sizeof(req) };
+	iov[1] = (struct iovec) { &rta, sizeof(rta) };
+	iov[2] = (struct iovec) { &instr, inslen };
+
+	msg = (struct msghdr) {
+		.msg_name = (void *)&nladdr,
+		.msg_namelen = sizeof(nladdr),
+		.msg_iov = iov,
+		.msg_iovlen = iovlen,
+	};
+
+	if (sendmsg(rth.fd, &msg, 0) < 0)
+		goto out;
+
+	if (rtnl_dump_filter(&rth, dummy_filter, NULL) < 0) {
+		ret = (errno != EINVAL);
+		goto out;
+	}
+
+	ret = true;
+
+out:
+	rtnl_close(&rth);
+
+	return ret;
+}
+
+
+struct filter_check_t {
+	bool (*check)(void);
+	int checked:1,
+	    supported:1;
+};
+
+static struct filter_check_t filter_checks[SSF__MAX] = {
+	[SSF_CGROUPCOND] = { cgroup_filter_check, 0 },
+};
+
+bool ssfilter_is_supported(int type)
+{
+	struct filter_check_t f;
+
+	if (type >= SSF__MAX)
+		return false;
+
+	f = filter_checks[type];
+	if (!f.check)
+		return true;
+
+	if (!f.checked) {
+		f.supported = f.check();
+		f.checked = 1;
+	}
+
+	return f.supported;
+}
-- 
2.7.4

