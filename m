From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 2/3] misc_cgroup: remove error log to avoid log flood
Date: Wed, 15 Sep 2021 10:18:50 +0800
Message-ID: <a960cd793f649bd944127fe5e5e3f4d8bb9040a4.1631671936.git.brookxu@tencent.com>
References: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=juTuMGYLDFSf15GDeZ/llKXGqDNMFhVIYFa8WUCbryw=;
        b=g1kBf6mxbwuBgKY0zeaBNmkhNUjyetF7qAcShuR/M1bj9IUcJPGG4ff9kVL7mtu4sZ
         /Y1D7tyCxPQlxFiiGRw7QxHtTCHvs2/jSJTL859u9OpZBnkRR7V+bJpVx71eYsuDKq3m
         NbUgbiD6ZVJFmEXZDUcfY8jMgMxjkgeWzpw8OQkr12gEP/uDoim14zIhrERhtfoCUO8H
         zpPJSy5wsw+u/k7G2yTS9Vb44IxYG8E/BC1yZASDariDtjGsc/1ZR388oNaN9DHNP3lw
         CO3iDZr3mQ1nM2F9/PGHKTV4xC6Rqg3FZjKY+oIjv0flrGfqn5RhOgLPlfgKkffP8qXT
         D0hw==
In-Reply-To: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

In scenarios where containers are frequently created and deleted,
a large number of error logs maybe generated. This log provides
less information, we can get more detailed info from misc.events.
From this, perhaps we can remove it.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/misc_cgroup.h | 1 -
 kernel/cgroup/misc.c        | 7 -------
 2 files changed, 8 deletions(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 091f2d2..c238207 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -37,7 +37,6 @@ struct misc_res {
 	unsigned long max;
 	atomic_long_t usage;
 	atomic_long_t events;
-	bool failed;
 };
 
 /**
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 4b2b492..fe3e8a0 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -157,13 +157,6 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
 		new_usage = atomic_long_add_return(amount, &res->usage);
 		if (new_usage > READ_ONCE(res->max) ||
 		    new_usage > READ_ONCE(misc_res_capacity[type])) {
-			if (!res->failed) {
-				pr_info("cgroup: charge rejected by the misc controller for %s resource in ",
-					misc_res_name[type]);
-				pr_cont_cgroup_path(i->css.cgroup);
-				pr_cont("\n");
-				res->failed = true;
-			}
 			ret = -EBUSY;
 			goto err_charge;
 		}
-- 
1.8.3.1

