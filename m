From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v4.20-rc1
Date: Thu, 25 Oct 2018 07:40:29 -0700
Message-ID: <20181025144029.GE4182586@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=3Pr3Agipq1HgsWB1/EX0mPKM0oZZs1CkGWymDB9IVU4=;
        b=USNy79lcPcl7+v8ZYz4OQc76n7FOmc68XM71rGMAzdrjLq5tQbpHDACzZga9Ug+ZgD
         C4kdAotKbyZz74nEcufCuQQuotpMqK6MZRejl0yRb72VSC5Ik037AxFemfsANWyvU8/3
         2CYOoZsZl7T0uWY99VhCyKbDimrlnR/zKsbRrTgT5ampRG4zX1/cOBGXeeIq1fgpmI1B
         zyBEz3iIWjjcLmeKCo+/zmWQrqoYQo3itEb2Y2rVE8gp7vZF2j0WSsxVtbJsAKNDNQxd
         bUDtDuqnEqQ9F36AEjFbk7qYx1iymRXubKGU/jOceDQs1CsAYWOQBaxntn/QEYMEDblX
         euGA==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>

Hello, Linus.

All trivial changes - simplification, typo fix and adding
cond_resched() in a netclassid update loop.

Thanks.

The following changes since commit 02214bfc89c71bcc5167f653994cfa5c57f10ff1:

  Merge tag 'media/v4.19-2' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2018-09-24 15:16:41 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.20

for you to fetch changes up to a90e90b7d55e789c71d85b946ffb5c1ab2f137ca:

  cgroup, netclassid: add a preemption point to write_classid (2018-10-23 12:58:17 -0700)

----------------------------------------------------------------
Andrey Ignatov (1):
      cgroup: Simplify cgroup_ancestor

Michal Hocko (1):
      cgroup, netclassid: add a preemption point to write_classid

Rami Rosen (1):
      rdmacg: fix a typo in rdmacg documentation

 Documentation/cgroup-v1/rdma.txt |  2 +-
 include/linux/cgroup.h           | 15 +++------------
 net/core/netclassid_cgroup.c     |  1 +
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/Documentation/cgroup-v1/rdma.txt b/Documentation/cgroup-v1/rdma.txt
index af618171e0eb..9bdb7fd03f83 100644
--- a/Documentation/cgroup-v1/rdma.txt
+++ b/Documentation/cgroup-v1/rdma.txt
@@ -27,7 +27,7 @@ cgroup.
 Currently user space applications can easily take away all the rdma verb
 specific resources such as AH, CQ, QP, MR etc. Due to which other applications
 in other cgroup or kernel space ULPs may not even get chance to allocate any
-rdma resources. This can leads to service unavailability.
+rdma resources. This can lead to service unavailability.
 
 Therefore RDMA controller is needed through which resource consumption
 of processes can be limited. Through this controller different rdma
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 32c553556bbd..e03a92430383 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -567,20 +567,11 @@ static inline bool cgroup_is_descendant(struct cgroup *cgrp,
 static inline struct cgroup *cgroup_ancestor(struct cgroup *cgrp,
 					     int ancestor_level)
 {
-	struct cgroup *ptr;
-
 	if (cgrp->level < ancestor_level)
 		return NULL;
-
-	for (ptr = cgrp;
-	     ptr && ptr->level > ancestor_level;
-	     ptr = cgroup_parent(ptr))
-		;
-
-	if (ptr && ptr->level == ancestor_level)
-		return ptr;
-
-	return NULL;
+	while (cgrp && cgrp->level > ancestor_level)
+		cgrp = cgroup_parent(cgrp);
+	return cgrp;
 }
 
 /**
diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
index 5e4f04004a49..7bf833598615 100644
--- a/net/core/netclassid_cgroup.c
+++ b/net/core/netclassid_cgroup.c
@@ -106,6 +106,7 @@ static int write_classid(struct cgroup_subsys_state *css, struct cftype *cft,
 		iterate_fd(p->files, 0, update_classid_sock,
 			   (void *)(unsigned long)cs->classid);
 		task_unlock(p);
+		cond_resched();
 	}
 	css_task_iter_end(&it);
 
