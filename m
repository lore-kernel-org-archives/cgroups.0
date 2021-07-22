From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 3/3] misc_cgroup: delete failed logs to avoid log flooding
Date: Thu, 22 Jul 2021 17:38:40 +0800
Message-ID: <9561f990656620f8b39c83453a857c5c35e3ddd0.1626946231.git.brookxu@tencent.com>
References: <4775e8d187920399403b296f8bb11bd687688671.1626946231.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=rWoKywolpsLaO+fLwhS065JQ8TxoNqZcLux7FKVCf+E=;
        b=aUMFOQ62cj8KgNQfMrZak9npSfuiUFKVuex2Lz6KaoNppN0fl3yd3thHqPkpW5cBXa
         1WIAz8+th/+lcNkl9lPsgK/agEMTecj2c6vEseG9pCsOXOb63lWJOBEJrbwjPTkHBhxL
         aUcsJPf2Yy1prGmwlAFMnuC7k5mVfJZYM1N1GOzRx7FQJmpenyO7J6P7OjdRXkqMkW1G
         OwdFptYyCikK1O101OuJpaopl9Xwl/68BuAzLS3HwTWXad4UsP39DgcnT2VBawdODbot
         rDoSMiEfvXVDUx/92vxTFLfS4IoB+IjKv7D83agxVr5IdhRVLZ4apTAsepnYpMdq6T/q
         iWRQ==
In-Reply-To: <4775e8d187920399403b296f8bb11bd687688671.1626946231.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <4775e8d187920399403b296f8bb11bd687688671.1626946231.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <4775e8d187920399403b296f8bb11bd687688671.1626946231.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
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

