From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/5] cgroup: make cgroup_is_removed() static
Date: Tue, 21 May 2013 10:50:22 +0900
Message-ID: <1369101025-28335-3-git-send-email-tj@kernel.org>
References: <1369101025-28335-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=9Gt+jXu9QCFE5jt6M8t6/advadx2yj9HsycUXwRcQKw=;
        b=nXOnUSVxUOYgzRS84ARXzPBBlfo1Nf4Z75LBvdk3ekE8x5TVnSPrP7ut6SZmeCiuRU
         u3C57c0E/7mfuDnxQYKcAQhW5ClmSUIZGlnur6n+/9J4gJeShT8cq7ulgqg52Z2D6UJD
         dNLF//s7ZSHaDCQZ69xwIdjo4bVRxIrrYIs0TmdOvLagH3D794zVl2UPNtUOumk6ts7z
         BUoJyMa5X6KWCEx78TSJjedYIAcZ3wG2wIOOR8xtR2d2Go/efsazlS4/Apor8li6b67Y
         kKDelOdZZW6GkUl+1PXFVv5E+XAdBxRWM5AbLdh+RRERRiDPplZp5SMabAYtP2vDXCOk
         ZmvA==
In-Reply-To: <1369101025-28335-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cgroup_is_removed() no longer has external users and it shouldn't grow
any - controllers should deal with cgroup_subsys_state on/offline
state instead of cgroup removal state.  Make it static.

While at it, make it return bool.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h | 1 -
 kernel/cgroup.c        | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 1df5f69..8d9f3c9 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -538,7 +538,6 @@ static inline const char *cgroup_name(const struct cgroup *cgrp)
 int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_rm_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 
-int cgroup_is_removed(const struct cgroup *cgrp);
 bool cgroup_is_descendant(struct cgroup *cgrp, struct cgroup *ancestor);
 
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f20f80c..3222f93 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -226,7 +226,7 @@ static int css_refcnt(struct cgroup_subsys_state *css)
 }
 
 /* convenient tests for these bits */
-inline int cgroup_is_removed(const struct cgroup *cgrp)
+static inline bool cgroup_is_removed(const struct cgroup *cgrp)
 {
 	return test_bit(CGRP_REMOVED, &cgrp->flags);
 }
-- 
1.8.1.4
