From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.11] cgroup: misc cleanups
Date: Fri, 20 Jan 2017 12:06:08 -0500
Message-ID: <20170120170608.GB5093@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Gw/+U8Z7v2NljuQCX0V8xbM7lPAk6Snv/aJ6UtpzFcM=;
        b=Nhp99riHqMDDBUkUIFoXfjnWiTJ585DW9zoeeodVAeRPzHmylR936aC5lB7vcFlEU9
         UM+Hjyf1t5hl4gPhZZtinYNZlxwwuOlXSjVgkuGs7ASmFJCh5S+uGSLBDuh2gfarVhDz
         dMiBiMQBMiUVTi4VB++gztyT+d+d6FsGb+LLUgJUnN3mvy8X0C4OQciNruodMLJg0bb7
         +OkpewyWp/acVC/Z/+sAcDtG9zc7GpppNuIkiPFEREX1CzFOu7gsP3PMh3Cx0J/kyqQv
         GTT+SOLAGXL9lnk05EyDJ1fx3CY4yZIJ3LWDz3EbG1bxey0Dn2Ibb0xiVZSi+5lDGpXa
         6sHQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

* cgrp_dfl_implicit_ss_mask is ulong instead of u16 unlike other
  ss_masks.  Make it a u16.

* Move have_canfork_callback together with other callback ss_masks.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -159,7 +159,7 @@ static bool cgrp_dfl_visible;
 static u16 cgrp_dfl_inhibit_ss_mask;
 
 /* some controllers are implicitly enabled on the default hierarchy */
-static unsigned long cgrp_dfl_implicit_ss_mask;
+static u16 cgrp_dfl_implicit_ss_mask;
 
 /* The list of hierarchy roots */
 LIST_HEAD(cgroup_roots);
@@ -178,13 +178,13 @@ static DEFINE_IDR(cgroup_hierarchy_idr);
 static u64 css_serial_nr_next = 1;
 
 /*
- * These bitmask flags indicate whether tasks in the fork and exit paths have
- * fork/exit handlers to call. This avoids us having to do extra work in the
- * fork/exit path to check which subsystems have fork/exit callbacks.
+ * These bitmasks identify subsystems with specific features to avoid
+ * having to do iterative checks repeatedly.
  */
 static u16 have_fork_callback __read_mostly;
 static u16 have_exit_callback __read_mostly;
 static u16 have_free_callback __read_mostly;
+static u16 have_canfork_callback __read_mostly;
 
 /* cgroup namespace for init task */
 struct cgroup_namespace init_cgroup_ns = {
@@ -195,9 +195,6 @@ struct cgroup_namespace init_cgroup_ns =
 	.root_cset	= &init_css_set,
 };
 
-/* Ditto for the can_fork callback. */
-static u16 have_canfork_callback __read_mostly;
-
 static struct file_system_type cgroup2_fs_type;
 static struct cftype cgroup_base_files[];
 
