From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.4] cgroup: fix too early usage of
 static_branch_disable()
Date: Fri, 25 Sep 2015 16:24:27 -0400
Message-ID: <20150925202427.GJ4449@mtj.duckdns.org>
References: <CANaxB-yFuS4SA2znSvcKrO9L_CbHciHYW+o9bN8sZJ8eR9FxYA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6IBOhmJnq4stlKwmrIcnux6XyIajaPl2SIHNo56lSYE=;
        b=eMAFglSBwVOMybanAHTj1Rm7BHGFYCTTwdllu321EIiTK7ATV6dHKhE5qx24eHCiHQ
         SO9IQiM2uuVC3c0IgJO0ACLhgEP6psS6JbsM6eaZH3+GGG9JzRuHCCmY4Q7TTBKQ4tUA
         jEXyP7sdAmMTVlgKBZtYsdvJXDuxn3rVYZ4J975h1zSFCT84tIgZp0GM4nBZfgGVXM9V
         rfQZ6htaYrd7ad/tYF3K0LJJTxrCMPFurr6/x38E+MAel9HJ80SZsYcWr/PCxORLO96X
         fU1/KmhzPeU6BKzyp7eL9xc+Uia4Yltx3wUMcnwooumFANKQlb/X9QUL/MJTVvt6Lc29
         RB2w==
Content-Disposition: inline
In-Reply-To: <CANaxB-yFuS4SA2znSvcKrO9L_CbHciHYW+o9bN8sZJ8eR9FxYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

49d1dc4b8179 ("cgroup: implement static_key based
cgroup_subsys_enabled() and cgroup_subsys_on_dfl()") converted cgroup
enabled test to use static_key; however, cgroup_disable() is called
before static_key subsystem itself is initialized and thus leads to
the following warning when "cgroup_disable=" parameter is specified.

 WARNING: CPU: 0 PID: 0 at kernel/jump_label.c:99 static_key_slow_dec+0x44/0x60()
 static_key_slow_dec used before call to jump_label_init
 ...
 Call Trace:
  [<ffffffff813b18c2>] dump_stack+0x44/0x62
  [<ffffffff8108dd52>] warn_slowpath_common+0x82/0xc0
  [<ffffffff8108ddec>] warn_slowpath_fmt+0x5c/0x80
  [<ffffffff8119c054>] static_key_slow_dec+0x44/0x60
  [<ffffffff81d826b6>] cgroup_disable+0xaf/0xd6
  [<ffffffff81d5f9de>] unknown_bootoption+0x8c/0x194
  [<ffffffff810b0c03>] parse_args+0x273/0x4a0
  [<ffffffff81d5fd67>] start_kernel+0x205/0x4b8
 ...

Fix it by making cgroup_disable() to record the subsystems to disable
in cgroup_disable_mask and moving the actual application to
cgroup_init() which is late enough and where the enabled state is
first used.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Link: http://lkml.kernel.org/g/CANaxB-yFuS4SA2znSvcKrO9L_CbHciHYW+o9bN8sZJ8eR9FxYA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
Fixes: 49d1dc4b81797f88270832b11e9f73809e7e7209
---
 kernel/cgroup.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f924158..ae23814 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5124,6 +5124,8 @@ int __init cgroup_init_early(void)
 	return 0;
 }
 
+static unsigned long cgroup_disable_mask __initdata;
+
 /**
  * cgroup_init - cgroup initialization
  *
@@ -5170,8 +5172,12 @@ int __init cgroup_init(void)
 		 * disabled flag and cftype registration needs kmalloc,
 		 * both of which aren't available during early_init.
 		 */
-		if (!cgroup_ssid_enabled(ssid))
+		if (cgroup_disable_mask & (1 << ssid)) {
+			static_branch_disable(cgroup_subsys_enabled_key[ssid]);
+			printk(KERN_INFO "Disabling %s control group subsystem\n",
+			       ss->name);
 			continue;
+		}
 
 		cgrp_dfl_root.subsys_mask |= 1 << ss->id;
 
@@ -5595,11 +5601,7 @@ static int __init cgroup_disable(char *str)
 			if (strcmp(token, ss->name) &&
 			    strcmp(token, ss->legacy_name))
 				continue;
-
-			static_branch_disable(cgroup_subsys_enabled_key[i]);
-			printk(KERN_INFO "Disabling %s control group subsystem\n",
-			       ss->name);
-			break;
+			cgroup_disable_mask |= 1 << i;
 		}
 	}
 	return 1;
