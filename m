From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v6 14/16] memcg: enable accounting for posix_timers_cache slab
Date: Mon, 26 Jul 2021 22:01:41 +0300
Message-ID: <55a29076-96a0-c19e-2932-c8a49d61bde1@virtuozzo.com>
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
 <cover.1627321321.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=bJzD/4dookOedoazAyDMd9sbQFHTEV2nMBxfajFsEmQ=; b=U8FCe/K+e1NUX3XwBF8
        D3xuQ39kF9ixkCs5J8uqlRtKmHoUhEfhmJZvLajoTzbfaoW7xO+0cmuQHIkPHXlzCRDD8gmubVcB3
        5edHMkVIFhI6CD8q3CVmYj6zDB+hRGreBSU43kJDMo3M/Y0VW1ot1dgQZ+nFOpww/kZ62kKqL+w=;
In-Reply-To: <cover.1627321321.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

A program may create multiple interval timers using timer_create().
For each timer the kernel preallocates a "queued real-time signal",
Consequently, the number of timers is limited by the RLIMIT_SIGPENDING
resource limit. The allocated object is quite small, ~250 bytes,
but even the default signal limits allow to consume up to 100 megabytes
per user.

It makes sense to account for them to limit the host's memory consumption
from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Reviewed-by: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 kernel/time/posix-timers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index dd5697d..7363f81 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -273,8 +273,8 @@ static int posix_get_hrtimer_res(clockid_t which_clock, struct timespec64 *tp)
 static __init int init_posix_timers(void)
 {
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
-					sizeof (struct k_itimer), 0, SLAB_PANIC,
-					NULL);
+					sizeof(struct k_itimer), 0,
+					SLAB_PANIC | SLAB_ACCOUNT, NULL);
 	return 0;
 }
 __initcall(init_posix_timers);
-- 
1.8.3.1

