From: Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH] memcg: replace in_interrupt() by !in_task() in active_memcg()
Date: Mon, 26 Jul 2021 19:53:36 +0300
Message-ID: <ed4448b0-4970-616f-7368-ef9dd3cb628d@virtuozzo.com>
References: <CALvZod5-XtaeawPtEgnp9xwouy0KfuDbpykB6Z3b+8YJyCrLVA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=p/l/Qj5INqHXINcKY/nrenLT6M8MZaYS0obzKpoLW2A=; b=a8+z8C6hzM4rexpHmG6
        4BApTO6gkg2j2EmkhoqjO6W1Ih6f8q0ba4BjL2d5wigrNGI1y8wPDgijzGMZ0zqQa4+9yQHeU+1bM
        FMk4BtIrgEhv14RPa/EdrJbjZdm1udMqbhzHsqOOHVh0uc8u1DXTEBAw7IbpvzLw/YFM1i40ZI8=;
In-Reply-To: <CALvZod5-XtaeawPtEgnp9xwouy0KfuDbpykB6Z3b+8YJyCrLVA@mail.gmail.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

set_active_memcg() uses in_interrupt() check to select proper storage for
cgroup: pointer on task struct or per-cpu pointer.

It isn't fully correct: obsoleted in_interrupt() includes tasks with disabled BH.
It's better to use '!in_task()' instead.

Link: https://lkml.org/lkml/2021/7/26/487
Fixes: 37d5985c003d ("mm: kmem: prepare remote memcg charging infra for interrupt contexts")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 include/linux/sched/mm.h | 2 +-
 mm/memcontrol.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index e24b1fe348e3..9dd071f78dba 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -306,7 +306,7 @@ set_active_memcg(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *old;
 
-	if (in_interrupt()) {
+	if (!in_task()) {
 		old = this_cpu_read(int_active_memcg);
 		this_cpu_write(int_active_memcg, memcg);
 	} else {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ae1f5d0cb581..3ebf792ef2c0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -905,7 +905,7 @@ EXPORT_SYMBOL(mem_cgroup_from_task);
 
 static __always_inline struct mem_cgroup *active_memcg(void)
 {
-	if (in_interrupt())
+	if (!in_task())
 		return this_cpu_read(int_active_memcg);
 	else
 		return current->active_memcg;
-- 
2.25.1

