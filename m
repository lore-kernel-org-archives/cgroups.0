From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 3/3] misc_cgroup: delete failed logs to avoid log flooding
Date: Thu, 22 Jul 2021 23:20:19 +0800
Message-ID: <e2b0dd55908750bfb0a97efae4f4e2dff2ab6a4a.1626966339.git.brookxu@tencent.com>
References: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=rWoKywolpsLaO+fLwhS065JQ8TxoNqZcLux7FKVCf+E=;
        b=FNAmnyHz9OF8cO1mwm6/P6LMeRdqR/kMONKBrzlhaASHy8MgXpZDGIsxAo+CwZFedV
         OIcWvC/gE/9qAxQTRHnvXPQowGT2zM0Y5E8BgTAc/CW53WD6k0HafIjpvoUv97k7l0ZC
         /4EhjxgP5rFsNx5oE1i0SYMNZ+j74e1BnwNeOnwEaDO66drHOkY74qyTbi7520LNmW7x
         LhT/5RBZT3BBMtj2mRIbTd4/VQEJpLSVNlht/A7N7jpk+03VDqjctGWtE8nwiduHWmDx
         DFPK+0Ps65ovBu9sMq21h1r+ydRiOxuQVgHoXUms6d5imMVhyfJSsstqF3fonCdBoD7s
         FRug==
In-Reply-To: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Since the upper-level logic will constantly retry when it fails, in
high-stress scenarios, a large number of failure logs may affect
performance. Therefore, we can replace it with the failcnt counter.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 kernel/cgroup/misc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 7c568b619f82..b7de0fafa48a 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -159,8 +159,6 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
 		if (new_usage > READ_ONCE(res->max) ||
 		    new_usage > READ_ONCE(misc_res_capacity[type])) {
 			if (!res->failed) {
-				pr_info("cgroup: charge rejected by the misc controller for %s resource in ",
-					misc_res_name[type]);
 				pr_cont_cgroup_path(i->css.cgroup);
 				pr_cont("\n");
 				res->failed = true;
-- 
2.30.0

