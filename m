From: brookxu <brookxu.cn@gmail.com>
Subject: [PATCH v2 2/3] misc_cgroup: remove error log to avoid log flood
Date: Mon, 13 Sep 2021 13:01:00 +0800
Message-ID: <b335a5d8241f837313cd20647647bf436385dd8d.1631504710.git.brookxu@tencent.com>
References: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu@tencent.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=sq2sVElL6LfrWUTgPoXcRO8q9sfpNwqgOJwmbj5VuD0=;
        b=W7gTxo1dbLBUb/zQ15G4oMV9hmfVEKB31vCWW8cUhxKnCCWD1E3k0PI/13ceSkzIkW
         hVytVb/b6W/kjpmc7X2LBh3vbmbQYuYsaZ54nNjLo8tfZ3eWSuTjyCqPhqmcN4v21Iva
         WsNTufzNiHNLY/l83N+Ply8xxG0ef7FnT58Y6wYTo3mxeGD6Aenz+vZVm89UHfKleEO2
         qmCv1FgUtIqXXPZJ8wajaeGVUyFFKdUygmHZsTLoWBQgCfDc/+iUzQwtcdK64EjdowsB
         Z5WxIgnvuSVqL9kJ31SNg4dRA8VlnA8ApGczoIoFNxoakayNSUEgpgcigv5DayoGxY/Y
         Ab9g==
In-Reply-To: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu@tencent.com>
In-Reply-To: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu@tencent.com>
References: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Cc: vipinsh@google.com, mkoutny@suse.com, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

In scenarios where containers are frequently created and deleted,
a large number of error logs maybe generated. This log provides
less information, we can get more detailed info from misc.events,
misc.events.local. From this, perhaps we can remove it.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 include/linux/misc_cgroup.h | 1 -
 kernel/cgroup/misc.c        | 7 -------
 2 files changed, 8 deletions(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 602fc11..89dcb62 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -43,7 +43,6 @@ struct misc_res {
 	atomic_long_t usage;
 	atomic_long_t events[MISC_CG_EVENT_TYPES];
 	atomic_long_t events_local[MISC_CG_EVENT_TYPES];
-	bool failed;
 };
 
 /**
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 5f06b2a..980ebaa 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -161,13 +161,6 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
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

