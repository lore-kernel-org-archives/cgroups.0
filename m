From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v5 13/16] memcg: enable accounting for signals
Date: Mon, 19 Jul 2021 13:45:44 +0300
Message-ID: <b19f065e-f3c9-2b20-2798-b60f0fc6b05f@virtuozzo.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=97E+pWsg1fRqSD4/pNq55qMVP3zQsBJJmg0TKYUHtmA=; b=bnoy8snEG7YOPop/cLE
        SrCz+IbDfRt+DLvfyz7GmopfWE/LrVQkLivZnhkP95Xtv8pqb/21NR9hTAvAO6/7dJcYolEFF8sie
        PAdNZRg0HRjv90KRRiZAPD+/Dea0VaGeaqXcqSM2mZ9lBFWNhyZiLwNOItaKjBTRLgQ+X6FLnXs=;
In-Reply-To: <cover.1626688654.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When a user send a signal to any another processes it forces the kernel
to allocate memory for 'struct sigqueue' objects. The number of signals
is limited by RLIMIT_SIGPENDING resource limit, but even the default
settings allow each user to consume up to several megabytes of memory.
Moreover, an untrusted admin inside container can increase the limit or
create new fake users and force them to sent signals.

It makes sense to account for these allocations to restrict the host's
memory consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index a3229ad..8921c4a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -4663,7 +4663,7 @@ void __init signals_init(void)
 {
 	siginfo_buildtime_checks();
 
-	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
+	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC | SLAB_ACCOUNT);
 }
 
 #ifdef CONFIG_KGDB_KDB
-- 
1.8.3.1

