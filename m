From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH-cgroup 5/6] cgroup: Skip dying css in cgroup_apply_control_{enable,disable}
Date: Wed, 14 Jun 2017 11:05:36 -0400
Message-ID: <1497452737-11125-6-git-send-email-longman@redhat.com>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 79A01723CD
In-Reply-To: <1497452737-11125-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Waiman Long <longman@redhat.com>

While constantly turning on and off controllers, it is possible to
trigger the dying CSS warnings in cgroup_apply_control_enable() and
cgroup_apply_control_disable(). The current code, however, proceeds
after the warning leading to other secondary warnings and maybe even
data corruption, like

  cgroup: cgroup_addrm_files: failed to add current, err=-17

To avoid the secondary errors, the dying CSS is now ignored or skipped
so as not to cause other problem.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cgroup.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f0bea32..2a5bd49 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2846,12 +2846,24 @@ static int cgroup_apply_control_enable(struct cgroup *cgrp)
 		for_each_subsys(ss, ssid) {
 			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
 
-			WARN_ON_ONCE(css && percpu_ref_is_dying(&css->refcnt));
-
 			if (!(cgroup_ss_mask(dsct, false) & (1 << ss->id)) ||
 			    (dsct->bypass_ss_mask & (1 << ss->id)))
 				continue;
 
+			/*
+			 * If the css is dying, we will just skip it after
+			 * warning.
+			 */
+			if (css && (css->flags & CSS_DYING)) {
+				char name[NAME_MAX+1];
+
+				cgroup_name(cgrp, name, NAME_MAX);
+				pr_warn("%s: %s css of cgroup %s is dying!\n",
+					__func__, ss->name, name);
+				WARN_ON_ONCE(1);
+				continue;
+			}
+
 			if (!css) {
 				css = css_create(dsct, ss);
 				if (IS_ERR(css))
@@ -2893,9 +2905,7 @@ static void cgroup_apply_control_disable(struct cgroup *cgrp)
 		for_each_subsys(ss, ssid) {
 			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
 
-			WARN_ON_ONCE(css && percpu_ref_is_dying(&css->refcnt));
-
-			if (!css)
+			if (!css || (css->flags & CSS_DYING))
 				continue;
 
 			if (css->parent &&
-- 
1.8.3.1

