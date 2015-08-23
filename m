From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cgroup: get a ref to source csses when migrating
Date: Sun, 23 Aug 2015 23:10:31 +1000
Message-ID: <1440335432-4202-2-git-send-email-cyphar@cyphar.com>
References: <CAOviyag1ZOgjtNWmnpfMm=fDgkhDn9UGKoJXy6HLWQMGb-tQAg@mail.gmail.com>
 <1440335432-4202-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440335432-4202-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Grab a ref to each source css being migrated from, otherwise it's
possible for the refcount to reach zero between ->can_attach() and
->cancel_attach(). This means that operations on the task's old css
(such as container_of(...)) become unsafe, as we may be operating on a
different css.

Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4ec1b7ee5de8..6cbfbe36284d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2305,6 +2305,17 @@ static int cgroup_migrate(struct cgroup *cgrp, struct task_struct *leader,
 	if (list_empty(&tset.src_csets))
 		return 0;
 
+	/*
+	 * Fetch a ref of each css, so that the old task's css doesn't get reaped
+	 * between ->can_attach() and ->cancel_attach().
+	 */
+	down_read(&css_set_rwsem);
+	list_for_each_entry(cset, &tset.src_csets, mg_node) {
+		for_each_e_css(css, i, cgrp)
+			css_get(cset->subsys[i]);
+	}
+	up_read(&css_set_rwsem);
+
 	/* check that we can legitimately attach to the cgroup */
 	for_each_e_css(css, i, cgrp) {
 		if (css->ss->can_attach) {
@@ -2341,7 +2352,7 @@ static int cgroup_migrate(struct cgroup *cgrp, struct task_struct *leader,
 			css->ss->attach(css, &tset);
 
 	ret = 0;
-	goto out_release_tset;
+	goto out_deref_src;
 
 out_cancel_attach:
 	for_each_e_css(css, i, cgrp) {
@@ -2350,7 +2361,13 @@ out_cancel_attach:
 		if (css->ss->cancel_attach)
 			css->ss->cancel_attach(css, &tset);
 	}
-out_release_tset:
+out_deref_src:
+	down_read(&css_set_rwsem);
+	list_for_each_entry(cset, &tset.src_csets, mg_node) {
+		for_each_e_css(css, i, cgrp)
+			css_put(cset->subsys[i]);
+	}
+	up_read(&css_set_rwsem);
 	down_write(&css_set_rwsem);
 	list_splice_init(&tset.dst_csets, &tset.src_csets);
 	list_for_each_entry_safe(cset, tmp_cset, &tset.src_csets, mg_node) {
-- 
2.5.0
