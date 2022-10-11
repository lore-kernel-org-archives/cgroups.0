From: "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: optimize the account of nr_cgrps
Date: Tue, 11 Oct 2022 07:29:31 +0000
Message-ID: <20221011072931.10427-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FXnUgcfBLglB+lvDTe8YnwsjeZcf2ivVVRRbAc6DYPM=;
        b=AhpI5ZJs5TSxELMbtWgbOcElxajihDyGzt+F5Yx8f5DubQHaVQyzObtIYHtPqNyUbT
         al9/ZumeQ3/0VYHmSZH2V5McuE7ZPRgjHHT3BdrqIOnv1Jqzt/jKtFWGNGVTBMcPfyDc
         HejhKgfQYjHpfg0vmcACwWOVO9mh/X9McKfqvnBUWMNirevMt4620kpXz9hg2so3xcjv
         Dyc+TLH24p/pzJVeOMWM5nC45NQrbMu6pjjjOw1Pr+Wu0ajyPlIhyM+sxsxoForUAUQz
         aAD23T35kYqGY9lnWgJMZLx8Kc4aSyhWhu6914SXXdTptUtsnBEETA/wQX30GQJ8H3XH
         2vyg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "haifeng.xu" <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

When use 'lscgroup' to account the number of cgroups in hierarchy,
we find that it's much less than the number showed by '/proc/cgroups'.

The reason is that the cgroup isn't freed even though remove the
directory, unless the percpu_ref of cgroup.self reaches zero.
For example, there are many page/buffer cache which obtain
references on the specified css. So only these memory are relcaimed,
the cgroup could be freed.

The cgroup is invisible for users after the corresponding directory
is removed. Therefore decrease the number of cgroups when call
'cgroup_rmdir'.

Signed-off-by: haifeng.xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c37b8265c0a3..9443df5d86bb 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5222,7 +5222,6 @@ static void css_free_rwork_fn(struct work_struct *work)
 			css_put(parent);
 	} else {
 		/* cgroup free path */
-		atomic_dec(&cgrp->root->nr_cgrps);
 		cgroup1_pidlist_destroy_all(cgrp);
 		cancel_work_sync(&cgrp->release_agent_work);
 
@@ -5781,6 +5780,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	/* clear and remove @cgrp dir, @cgrp has an extra ref on its kn */
 	css_clear_dir(&cgrp->self);
 	kernfs_remove(cgrp->kn);
+	atomic_dec(&cgrp->root->nr_cgrps);
 
 	if (cgroup_is_threaded(cgrp))
 		parent->nr_threaded_children--;
-- 
2.25.1

