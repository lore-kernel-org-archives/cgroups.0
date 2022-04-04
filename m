From: Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] cgroup: Kill the parent controller when its last child is killed
Date: Mon,  4 Apr 2022 21:25:34 +0700
Message-ID: <20220404142535.145975-1-minhquangbui99@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vmv5bxS5EWoc91g75Vzau8g0vSoXhGCuFE3qsoGJOPg=;
        b=iLoswEs+5gduzsNqGbxzYOyUkRa1X0c3WNYv/u/uht/PCXO/BiXTGor+UATG1GTo6y
         OGELiV1powqWayUslDrEskMHNAl8PdUCe3zrYMGuEpjb0SG651wSIW5wM/UIDfb1PZgG
         2rCDyu3AADU/NXP0STTiWOZLLWHV7uRWxj+y4sOtv8PjerEPhadRF4w7GqVI3QXUtwqF
         bT+ra2vKQE0gYitrlGR5MiR6O1XfsTD3MI/2xGVGgnZj5a6qadtKTICBPaJnRhNLfB6/
         KUa4yk9AVOzRKckxcSezhAXhgEsJxuzfcI//tqd5HH0z8FsYQsPKw3YQbEIvpxmwDwOP
         JVeA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
v2: Fix compilation error when CONFIG_CGROUP_BPF is not set

 kernel/cgroup/cgroup.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f01ff231a484..1916070f0d59 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5152,12 +5152,27 @@ static void css_release_work_fn(struct work_struct *work)
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
+#ifdef CONFIG_CGROUP_BPF
+		if (!percpu_ref_is_dying(&cgrp->bpf.refcnt))
+			cgroup_bpf_offline(parent);
+#endif
+		percpu_ref_kill(&parent->self.refcnt);
+	}
+
 	if (ss) {
 		/* css release path */
 		if (!list_empty(&css->rstat_css_node)) {

base-commit: 1be9b7206b7dbff54b223eee7ef3bc91b80433aa
-- 
2.25.1

