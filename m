From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] cgroup: Avoid compiler warnings with no subsystems
Date: Thu, 26 Aug 2021 20:47:41 -0700
Message-ID: <20210827034741.2214318-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3iDBnZHVbEreWWuomxF6GQM4vK4iHAWwR63HQF/eKNk=;
        b=Ztu+t6Jzw25jWNOhI/V3DOe8lvDY109i896qfsl54W3uGIWvCVdH53Euxq2HM6Tuk/
         Y+jdZbhhGlJm37zPL7iY+cEg2VI0KDz+0/a2D3gmDi7ywcCTU5bn7vdlWxHMo6YtQY1t
         rA5/Fmx3IUYQhpMhgYOQnrb070ajKlIE3vnRw=
X-Developer-Signature: v=1; a=openpgp-sha256; l=3707; h=from:subject; bh=W8mrDHl6epGwfALLfDZy6bZIPBPKmiqLtY/kJ0d40/A=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhKGBc5sJcW17N6yaoeIVynlA7aGik+aP71/c/fDv0 xr4JJdGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYShgXAAKCRCJcvTf3G3AJrc+D/ 9GISUvm+dHrhuWYcVAsCuC9AzNUkDwO8OJTJXICqteYG3BwwSvrG3Mh4Z9uc6qsgDjjyJk41wjZHAM 7yf4zprKt89GB47h9ijavum+/hDi5gXsuRJgWrJpRhsOm2HvDG3vMztKCWf8gVyLaVpWb8T4sb4YAI 3hdHs9DA8SHKzfmIGXlJ+YXSXFuMccQrZBRtP0yDG3wF8u7jsgy/nsq8CwI4h1RSARnn2EcH5gQEgB hgeseVGuNtSLugNVQAZlGiunuknJoR9lv1fptLJI3czdxeXU4ossMUZeuEere6n2Q+l2cp0bAfAjDV yKJavzHz6UGE4t7EplPrTou/M9hLuYzZD4ng9HaAX3TiyOmHNgDarS1swdUBS8YLw/vZlj7tq45nXZ RQBwcaqf2Cl3HBY0V9LMB8uEbGUtbMsZf7kjGEMENK8CiFkFxMEl8QRp6k301INBscWxuyR9Kyp40F NXRLzFsRtWOdBipI/Yqhi1yTvFekX6w3DVtGPa7vP7RXhN4Ef
 r9252LkeSPEJZMiBvXsMmYagotiqq lef/jTeqjkmpYx/AHoVlVbxJl8Y06orD0C1FrGQ11qwudw0P/SaK9PY4FBkzxGD98mnc 
X-Developer-Key: i=keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

As done before in commit cb4a31675270 ("cgroup: use bitmask to filter
for_each_subsys"), avoid compiler warnings for the pathological case of
having no subsystems (i.e. CGROUP_SUBSYS_COUNT == 0). This condition is
hit for the arm multi_v7_defconfig config under -Wzero-length-bounds:

In file included from ./arch/arm/include/generated/asm/rwonce.h:1,
                 from include/linux/compiler.h:264,
                 from include/uapi/linux/swab.h:6,
                 from include/linux/swab.h:5,
                 from arch/arm/include/asm/opcodes.h:86,
                 from arch/arm/include/asm/bug.h:7,
                 from include/linux/bug.h:5,
                 from include/linux/thread_info.h:13,
                 from include/asm-generic/current.h:5,
                 from ./arch/arm/include/generated/asm/current.h:1,
                 from include/linux/sched.h:12,
                 from include/linux/cgroup.h:12,
                 from kernel/cgroup/cgroup-internal.h:5,
                 from kernel/cgroup/cgroup.c:31:
kernel/cgroup/cgroup.c: In function 'of_css':
kernel/cgroup/cgroup.c:651:42: warning: array subscript '<unknown>' is outside the bounds of an
interior zero-length array 'struct cgroup_subsys_state *[0]' [-Wzero-length-bounds]
  651 |   return rcu_dereference_raw(cgrp->subsys[cft->ss->id]);

Reported-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d0725c1a8db5..d23100878002 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -472,7 +472,7 @@ static u16 cgroup_ss_mask(struct cgroup *cgrp)
 static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
 					      struct cgroup_subsys *ss)
 {
-	if (ss)
+	if (CGROUP_SUBSYS_COUNT && ss)
 		return rcu_dereference_check(cgrp->subsys[ss->id],
 					lockdep_is_held(&cgroup_mutex));
 	else
@@ -550,6 +550,9 @@ struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 {
 	struct cgroup_subsys_state *css;
 
+	if (!CGROUP_SUBSYS_COUNT)
+		return NULL;
+
 	do {
 		css = cgroup_css(cgrp, ss);
 
@@ -577,6 +580,9 @@ struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgrp,
 {
 	struct cgroup_subsys_state *css;
 
+	if (!CGROUP_SUBSYS_COUNT)
+		return NULL;
+
 	rcu_read_lock();
 
 	do {
@@ -647,7 +653,7 @@ struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
 	 * the matching css from the cgroup's subsys table is guaranteed to
 	 * be and stay valid until the enclosing operation is complete.
 	 */
-	if (cft->ss)
+	if (CGROUP_SUBSYS_COUNT && cft->ss)
 		return rcu_dereference_raw(cgrp->subsys[cft->ss->id]);
 	else
 		return &cgrp->self;
@@ -2372,7 +2378,7 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset,
 	struct css_set *cset = tset->cur_cset;
 	struct task_struct *task = tset->cur_task;
 
-	while (&cset->mg_node != tset->csets) {
+	while (CGROUP_SUBSYS_COUNT && &cset->mg_node != tset->csets) {
 		if (!task)
 			task = list_first_entry(&cset->mg_tasks,
 						struct task_struct, cg_list);
@@ -4643,7 +4649,7 @@ void css_task_iter_start(struct cgroup_subsys_state *css, unsigned int flags,
 	it->ss = css->ss;
 	it->flags = flags;
 
-	if (it->ss)
+	if (CGROUP_SUBSYS_COUNT && it->ss)
 		it->cset_pos = &css->cgroup->e_csets[css->ss->id];
 	else
 		it->cset_pos = &css->cgroup->cset_links;
-- 
2.30.2

