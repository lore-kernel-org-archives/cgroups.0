From: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 06/11] cgroup: fix -Wzero-length-bounds warnings
Date: Mon, 22 Mar 2021 17:02:44 +0100
Message-ID: <20210322160253.4032422-7-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429077;
        bh=yAy/I3E6cDxsmlVnV0YJAH5ZEQIRtNmu4zak4TbdMtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UB5shkw7Yd4R5EAaTaJbKCgGMQHdzM6i80uoGxhNLAKr58/Z+hb/X02iDZFbFM5q7
         ohBr0mnuKE2zD2dZIPp5mGV/8upXxQjJIfPGJp9PdMs6uae5VNAC7zYBRMfKWnHX2T
         dVcWKQocYTTmbDcT2P/QpYMSgUNzpEBC5mOFpZCLPDNYvMuLPWfLzgAFpKC9vWx2UV
         WcW6Gm/cjDbzo+bVOJsKrlf8DWJ6XKsV5KO6yCyvx8yAazXnd03HJIpEKsAL1WBIyL
         rctKK7FEjfv0XP7F/8O3bxyOq6H75TM+jdZPPW1bjsoXOWVbf0YQRUVNLoyOj2UQzP
         uTGmECN+tjDoA==
In-Reply-To: <20210322160253.4032422-1-arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Sebor <msebor-/MQLu3FmUzdAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ning Sun <ning.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Simon Kelley <simon-xn1N/tgparsycpQjotevgVpr/1R2p/CL@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Anders Larsen <al-V9/YLgxv/GvR7s880joybQ@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Imre Deak <imre.deak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, ath11k-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Christian Brauner <christian.brauner>

From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

When cgroups are enabled, but every single subsystem is turned off,
CGROUP_SUBSYS_COUNT is zero, and the cgrp->subsys[] array has no
members.

gcc-11 points out that this leads to an invalid access in any function
that might access this array:

kernel/cgroup/cgroup.c: In function 'cgroup_addrm_files':
kernel/cgroup/cgroup.c:460:58: warning: array subscript '<unknown>' is outside the bounds of an interior zero-length array 'struct cgroup_subsys_state *[0]' [-Wzero-length-bounds]
kernel/cgroup/cgroup.c:460:24: note: in expansion of macro 'rcu_dereference_check'
  460 |                 return rcu_dereference_check(cgrp->subsys[ss->id],
      |                        ^~~~~~~~~~~~~~~~~~~~~
In file included from include/linux/cgroup.h:28,
                 from kernel/cgroup/cgroup-internal.h:5,
                 from kernel/cgroup/cgroup.c:31:
include/linux/cgroup-defs.h:422:43: note: while referencing 'subsys'
  422 |         struct cgroup_subsys_state __rcu *subsys[CGROUP_SUBSYS_COUNT];

I'm not sure what is expected to happen for such a configuration,
presumably these functions are never calls in that case. Adding a
sanity check in each function we get the warning for manages to shut
up the warnings and do nothing instead.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
I'm grouping this together with the -Wstringop-overread warnings,
since the underlying logic in gcc seems to be the same.
---
 kernel/cgroup/cgroup.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 9153b20e5cc6..3477f1dc7872 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -456,7 +456,7 @@ static u16 cgroup_ss_mask(struct cgroup *cgrp)
 static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
 					      struct cgroup_subsys *ss)
 {
-	if (ss)
+	if (ss && (CGROUP_SUBSYS_COUNT > 0))
 		return rcu_dereference_check(cgrp->subsys[ss->id],
 					lockdep_is_held(&cgroup_mutex));
 	else
@@ -534,6 +534,9 @@ struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 {
 	struct cgroup_subsys_state *css;
 
+	if (CGROUP_SUBSYS_COUNT == 0)
+		return NULL;
+
 	do {
 		css = cgroup_css(cgrp, ss);
 
@@ -561,6 +564,9 @@ struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgrp,
 {
 	struct cgroup_subsys_state *css;
 
+	if (CGROUP_SUBSYS_COUNT == 0)
+		return NULL;
+
 	rcu_read_lock();
 
 	do {
@@ -630,7 +636,7 @@ struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
 	 * the matching css from the cgroup's subsys table is guaranteed to
 	 * be and stay valid until the enclosing operation is complete.
 	 */
-	if (cft->ss)
+	if (cft->ss && CGROUP_SUBSYS_COUNT > 0)
 		return rcu_dereference_raw(cgrp->subsys[cft->ss->id]);
 	else
 		return &cgrp->self;
@@ -2343,6 +2349,9 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
 	struct css_set *cset = tset->cur_cset;
 	struct task_struct *task = tset->cur_task;
 
+	if (CGROUP_SUBSYS_COUNT == 0)
+		return NULL;
+
 	while (&cset->mg_node != tset->csets) {
 		if (!task)
 			task = list_first_entry(&cset->mg_tasks,
@@ -4523,7 +4532,7 @@ void css_task_iter_start(struct cgroup_subsys_state *css, unsigned int flags,
 	it->ss = css->ss;
 	it->flags = flags;
 
-	if (it->ss)
+	if (it->ss && CGROUP_SUBSYS_COUNT > 0)
 		it->cset_pos = &css->cgroup->e_csets[css->ss->id];
 	else
 		it->cset_pos = &css->cgroup->cset_links;
-- 
2.29.2

