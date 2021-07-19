From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v5 14/16] memcg: enable accounting for posix_timers_cache slab
Date: Mon, 19 Jul 2021 13:45:51 +0300
Message-ID: <3f829919-41ad-e979-8f05-cbd495396761@virtuozzo.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=bJzD/4dookOedoazAyDMd9sbQFHTEV2nMBxfajFsEmQ=; b=NXifXHsSlltvlgdSjAb
        6Yho3ZL1I3ED/e75k5XOJAyTgEgD1SRXWrl/U3E7IQNzuQwAV9f4sgdd5c+RR5YA9X+FTzPBGUw8Y
        tc61NUvC+FG0+fksmRoO1Xn4k5Ny2hmG9R4yL1UYaC3M1wqsKIvY65o29V07z2Lzre8f5I/Ysio=;
In-Reply-To: <cover.1626688654.git.vvs@virtuozzo.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org

A program may create multiple interval timers using timer_create().
For each timer the kernel preallocates a "queued real-time signal",
Consequently, the number of timers is limited by the RLIMIT_SIGPENDING
resource limit. The allocated object is quite small, ~250 bytes,
but even the default signal limits allow to consume up to 100 megabytes
per user.

It makes sense to account for them to limit the host's memory consumption
from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
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

