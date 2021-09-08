From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Wed,  8 Sep 2021 13:24:36 +0800
Message-ID: <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu@tencent.com>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=FQ5T0HqJNT9t39aOsQECaxpdxcnOU7H2Z1up+JT0ahA=;
        b=KSjeu4V7QQUimg8NL+XI827Mhtjv4Do5UNgas+FfP5NOXy4uByNlBeEkc6Q9IKqYwu
         ib9n6iQEA17insu7R6QsJ1F9gho8Q7vQf1jqBt1rnLS/kGv5HYDPpttcHLE7ZsEd3r3+
         QO789ukWZ/vxtrPy6/+w3ajKVx/LeDxahaKJHoH8qyVIBbJo8XMGTMZk/uWGTLyRTK/a
         uKk4dy64QSEkHtB55nMjI1gJH2dmAHHKjoC9GVneHicx5rnZVrJcW88kFs6aSUWAkqeR
         kRTnheqwrE+HpTMp2Py3QJWDqkXcz7X7pN8mAfPJzslHTckh/VRIkq/K//aQpOa+g14o
         RxBw==
In-Reply-To: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

In scenarios where containers are frequently created and deleted,
a large number of error logs maybe generated. This log provides
less information, we can get more detailed failure records through
misc.events, misc.events.local and misc.failcnt. From this, perhaps
we can remove it.

Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/misc_cgroup.h | 1 -
 kernel/cgroup/misc.c        | 7 -------
 2 files changed, 8 deletions(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index 4d630cd3e4bd..838e26149263 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -36,7 +36,6 @@ struct misc_cg;
 struct misc_res {
 	unsigned long max;
 	atomic_long_t usage;
-	bool failed;
 };
 
 /**
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index d8f99fd58981..b9c7e488413f 100644
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
2.30.0

