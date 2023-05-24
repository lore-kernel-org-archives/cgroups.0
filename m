From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2] cgroup: Update out-of-date comment in
 cgroup_migrate()
Date: Wed, 24 May 2023 12:23:13 -1000
Message-ID: <ZG6OURkhj4uQUTCo@slm.duckdns.org>
References: <20230524065431.145434-1-xiujianfeng@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684966995; x=1687558995;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Ps4++BD4n2hLwrgjdjqi8hVhoVdzFMxyoqft8e+OG8=;
        b=BxSoVxn1ynWjBrokKf8e2fM0dA5n50KyomGLR6Vb0G9LzB6NAEHYiFrT4g5TK2m6UL
         oedNlWCgSX62iIQofjo1qmkaElTaq6b5I6kq6gGdjZXZ6K/+36AhJJbdkGXJD7iQffAh
         McYJRjGRXeot0dRQzR3QWFJChJTGtNL0cCeLIM2ZM8Llf8ZlWQ3zIIi4hAAbHYtusfHE
         qlumgkbFb1g3kUL/n1jwjxgRG+iyDv0MUW7EU7Kpq/QGyKc0U7Y+1x5IejkhicHrp3Md
         TJLsGeLA+SCSNzpsj6GBh7jTyV4qBGQxUAh1gIJWUMLhW6bFwEU6srNqAr0MaVT9FIJr
         e5pA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230524065431.145434-1-xiujianfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiu Jianfeng <xiujianfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I further edited the comment and applied the patch to cgroup/for-6.5

Thanks.

From 659db0789c2e66c5d6a52d57008e3a7401a3ffff Mon Sep 17 00:00:00 2001
From: Xiu Jianfeng <xiujianfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Date: Wed, 24 May 2023 14:54:31 +0800
Subject: [PATCH] cgroup: Update out-of-date comment in cgroup_migrate()

Commit 674b745e22b3 ("cgroup: remove rcu_read_lock()/rcu_read_unlock()
in critical section of spin_lock_irq()") has removed the rcu_read_lock,
which makes the comment out-of-date, so update it.

tj: Updated the comment a bit.

Signed-off-by: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 9d809191a54f..f329f49529a2 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2872,9 +2872,9 @@ int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 	struct task_struct *task;
 
 	/*
-	 * Prevent freeing of tasks while we take a snapshot. Tasks that are
-	 * already PF_EXITING could be freed from underneath us unless we
-	 * take an rcu_read_lock.
+	 * The following thread iteration should be inside an RCU critical
+	 * section to prevent tasks from being freed while taking the snapshot.
+	 * spin_lock_irq() implies RCU critical section here.
 	 */
 	spin_lock_irq(&css_set_lock);
 	task = leader;
-- 
2.40.1

