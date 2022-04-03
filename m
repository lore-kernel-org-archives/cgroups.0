From: Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: Kill the parent controller when its last child is killed
Date: Sun,  3 Apr 2022 20:57:17 +0700
Message-ID: <20220403135717.8294-1-minhquangbui99@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J5mbcZTsiDy3mrNkZULEao/0esdA8VeRyfo3ZqOjIFQ=;
        b=GVcAdkoyMokXfTR2LLDHuHD1vCyTv/CL4Mr0zcmD71hYcQLNx4trRtToCqpmglZ6p2
         PfyrVY4bjMJXXryJlFSZQ/inrpyn7w0puiD1GGEY/XC92cwwNU1SxUYrW9IZcp7i+jIG
         rr5TENhHGiX+LNgYDXHa6AVCI/VsyUXghylGxj7jMkpLT2FqRqavlgYBDmPuRHB89kl8
         LftNF2g36cg6yha8KtSQVaDjIdftf5xi+Cxgar9wFbNJrCDeMY8KnnM9bq3P4Ey3m9Nh
         /DgblGo29ZvOgCxzDuGnjFXgYqF5WmFRf1nyTgxTlrFEjhoJR6cvszzuclZGerOi/1Vw
         FlQg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When umounting a cgroup controller, in case the controller has no children,
the initial ref will be dropped in cgroup_kill_sb. In cgroup_rmdir path,
the controller is deleted from the parent's children list in
css_release_work_fn, which is run on a kernel worker.

With this simple script

	#!/bin/sh

	mount -t cgroup -o none,name=test test ./tmp
	mkdir -p ./tmp/abc

	rmdir ./tmp/abc
	umount ./tmp

	sleep 5
	cat /proc/self/cgroup

The rmdir will remove the last child and umount is expected to kill the
parent controller. However, when running the above script, we may get

	1:name=test:/

This shows that the parent controller has not been killed. The reason is
after rmdir is completed, it is not guaranteed that the parent's children
list is empty as css_release_work_fn is deferred to run on a worker. In
case cgroup_kill_sb is run before that work, it does not drop the initial
ref. Later in the worker, it just removes the child from the list without
checking the list is empty to kill the parent controller. As a result, the
parent controller still has the initial ref but without any logical refs
(children ref, mount ref).

This commit adds a free parent controller path into the worker function to
free up the parent controller when the last child is killed.

Signed-off-by: Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a557eea7166f..220eb1742961 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5157,12 +5157,25 @@ static void css_release_work_fn(struct work_struct *work)
 		container_of(work, struct cgroup_subsys_state, destroy_work);
 	struct cgroup_subsys *ss = css->ss;
 	struct cgroup *cgrp = css->cgroup;
+	struct cgroup *parent = cgroup_parent(cgrp);
 
 	mutex_lock(&cgroup_mutex);
 
 	css->flags |= CSS_RELEASED;
 	list_del_rcu(&css->sibling);
 
+	/*
+	 * If parent doesn't have any children, start killing it.
+	 * And don't kill the default root.
+	 */
+	if (parent && list_empty(&parent->self.children) &&
+	    parent != &cgrp_dfl_root.cgrp &&
+	    !percpu_ref_is_dying(&parent->self.refcnt)) {
+		if (!percpu_ref_is_dying(&cgrp->bpf.refcnt))
+			cgroup_bpf_offline(parent);
+		percpu_ref_kill(&parent->self.refcnt);
+	}
+
 	if (ss) {
 		/* css release path */
 		if (!list_empty(&css->rstat_css_node)) {
-- 
2.25.1

