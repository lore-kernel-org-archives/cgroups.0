From: Nina Schiff <ninasc@fb.com>
Subject: [PATCH] cgroups: Allow dynamically changing net_classid
Date: Fri, 20 Nov 2015 12:16:10 -0800
Message-ID: <1448050570-1849936-1-git-send-email-ninasc@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=from : to : cc : subject :
 date : message-id : mime-version : content-type; s=facebook;
 bh=cnU3QJWA+qkXcfi8SbDgTdJ4U+OEO3jmrvvSn39m+AA=;
 b=Wc9X+wnpXSUbVJmhHIH0umpNvqBwrFxI4HSDokVbNhNog81A0KsFtwGodXZQo2ImrsJ7
 Jv4uSW/odq7OB3lPfkj2npKOhm9al17Z6APn8IeFHAVU+wCg23c8ToteLHs/Z27tpQ9E
 LEIu+fa2WhZ4uWiIqGWh+puzeV04JM8+7EQ= 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, daniel.wagner@bmw-carit.de, "nhorman@tuxdriver.comnetdev"@vger.kernel.org
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, tj@kernel.org, Nina Schiff <ninasc@fb.com>

The classid of a process is changed either when a process is moved to
or from a cgroup or when the net_cls.classid file is updated.
Previously net_cls only supported propogating these changes to the
cgroup's related sockets when a process was added or removed from the
cgroup. This means it was neccessary to remove and re-add all processes
to a cgroup in order to update its classid. This change introduces
support for doing this dynamically - i.e. when the value is changed in
the net_cls_classid file, this will also trigger an update to the
classid associated with all sockets controlled by the cgroup.
This mimics the behaviour of other cgroup subsystems.
net_prio circumvents this issue by storing an index into a table with
each socket (and so any updates to the table, don't require updating
the value associated with the socket). net_cls, however, passes the
socket the classid directly, and so this additional step is needed.

Signed-off-by: Nina Schiff <ninasc@fb.com>
---
 net/core/netclassid_cgroup.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
index 6441f47..952a42d 100644
--- a/net/core/netclassid_cgroup.c
+++ b/net/core/netclassid_cgroup.c
@@ -16,7 +16,8 @@
 #include <net/cls_cgroup.h>
 #include <net/sock.h>
 
-static inline struct cgroup_cls_state *css_cls_state(struct cgroup_subsys_state *css)
+static inline struct cgroup_cls_state *css_cls_state(
+		struct cgroup_subsys_state *css)
 {
 	return css ? container_of(css, struct cgroup_cls_state, css) : NULL;
 }
@@ -56,7 +57,7 @@ static void cgrp_css_free(struct cgroup_subsys_state *css)
 	kfree(css_cls_state(css));
 }
 
-static int update_classid(const void *v, struct file *file, unsigned n)
+static int update_classid_sock(const void *v, struct file *file, unsigned n)
 {
 	int err;
 	struct socket *sock = sock_from_file(file, &err);
@@ -67,18 +68,25 @@ static int update_classid(const void *v, struct file *file, unsigned n)
 	return 0;
 }
 
-static void cgrp_attach(struct cgroup_subsys_state *css,
-			struct cgroup_taskset *tset)
+static void update_classid(struct cgroup_subsys_state *css, void *v)
 {
-	struct cgroup_cls_state *cs = css_cls_state(css);
-	void *v = (void *)(unsigned long)cs->classid;
+	struct css_task_iter it;
 	struct task_struct *p;
 
-	cgroup_taskset_for_each(p, tset) {
+	css_task_iter_start(css, &it);
+	while ((p = css_task_iter_next(&it))) {
 		task_lock(p);
-		iterate_fd(p->files, 0, update_classid, v);
+		iterate_fd(p->files, 0, update_classid_sock, v);
 		task_unlock(p);
 	}
+	css_task_iter_end(&it);
+}
+
+static void cgrp_attach(struct cgroup_subsys_state *css,
+			struct cgroup_taskset *tset)
+{
+	update_classid(css,
+		       (void *)(unsigned long)css_cls_state(css)->classid);
 }
 
 static u64 read_classid(struct cgroup_subsys_state *css, struct cftype *cft)
@@ -89,8 +97,11 @@ static u64 read_classid(struct cgroup_subsys_state *css, struct cftype *cft)
 static int write_classid(struct cgroup_subsys_state *css, struct cftype *cft,
 			 u64 value)
 {
-	css_cls_state(css)->classid = (u32) value;
+	struct cgroup_cls_state *cs = css_cls_state(css);
+
+	cs->classid = (u32)value;
 
+	update_classid(css, (void *)(unsigned long)cs->classid);
 	return 0;
 }
 
-- 
2.4.6
