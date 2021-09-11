From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH] ipc: remove memcg accounting for sops objects in
 do_semtimedop()
Date: Sat, 11 Sep 2021 10:40:08 +0300
Message-ID: <90e254df-0dfe-f080-011e-b7c53ee7fd20@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=Sj1B4dxxEgCYUObVr5tn3EBz2yvfW+//sFIcOOUDc5U=; b=SUiOHBCKVqMzFtBCHuo
        +yEezW7VXZzWxFfxvZosB5l1ohptlc/j68xDJ/3kIXPlYJhoBSeNVe4QD0JhinidYSrsN4t7/7h5P
        gb8CBcZz1ZoSDepWoa+IZWpsc2wLZd0Mj3DFK0TK2g3mhmgH48DiFhaiJVGWM9v6VZ4Nt1uMKUs=;
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Linus proposes to revert an accounting for sops objects in
do_semtimedop() because it's really just a temporary buffer
for a single semtimedop() system call.

This object can consume up to 2 pages, syscall is sleeping one,
size and duration can be controlled by user, and this allocation
can be repeated by many thread at the same time.

However Shakeel Butt pointed that there are much more popular objects
with the same life time and similar memory consumption, the accounting
of which was decided to be rejected for performance reasons.

In addition, any usual task consumes much more accounted memory,
so 2 pages of this temporal buffer can be safely ignored.

Link: https://patchwork.kernel.org/project/linux-fsdevel/patch/20171005222144.123797-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

Fixes: 18319498fdd4 ("memcg: enable accounting of ipc resources")
Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 ipc/sem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index f833238df1ce..6693daf4fe11 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -2238,7 +2238,7 @@ static long do_semtimedop(int semid, struct sembuf __user *tsops,
 		return -EINVAL;
 
 	if (nsops > SEMOPM_FAST) {
-		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL_ACCOUNT);
+		sops = kvmalloc_array(nsops, sizeof(*sops), GFP_KERNEL);
 		if (sops == NULL)
 			return -ENOMEM;
 	}
-- 
2.25.1

