From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] fork, memcg: fix cached_stacks case
Date: Wed,  2 Jan 2019 10:01:45 -0800
Message-ID: <20190102180145.57406-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5dUXWnMYVxK4GhlE9mU3i7S+YQhp/yuwfcvNZh6pQ54=;
        b=qwipEX4wIkJkoVONyw3px8ydt+BiUWSb5U5RBPSsg7mhqCD+4qDp9Uj7JYhb/A9Wor
         HGqBh8MUbe7wxfjpQpqc+O8AenWmE4OjT/7XjR4dKHO72AkllbS6mYl+xwh2rAwMGRVy
         BeEtch55uq4z+z+HihCDU/thB4jlyVfn7Ax0WKYyWHtP4mvf1pkAT/gw9M1obguZFDwz
         VXYecv1XxqTFYnefuQotftd9giuHUU/3eX7wCghZm0IGTbQDkI4F3ArxMZGS8pKURKGH
         GWEb7bvAiTowOkeKfzxgaSbx7UHm1gD5UZrvAN4lhg6X5eSgig7+6g51ewHZVobYp4u5
         SpAg==
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rik van Riel <riel@surriel.com>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, stable@vger.kernel.org

Commit 5eed6f1dff87 ("fork,memcg: fix crash in free_thread_stack on
memcg charge fail") fixes a crash caused due to failed memcg charge of
the kernel stack. However the fix misses the cached_stacks case which
this patch fixes. So, the same crash can happen if the memcg charge of
a cached stack is failed.

Fixes: 5eed6f1dff87 ("fork,memcg: fix crash in free_thread_stack on memcg charge fail")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
---
 kernel/fork.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index e4a51124661a..593cd1577dff 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -216,6 +216,7 @@ static unsigned long *alloc_thread_stack_node(struct task_struct *tsk, int node)
 		memset(s->addr, 0, THREAD_SIZE);
 
 		tsk->stack_vm_area = s;
+		tsk->stack = s->addr;
 		return s->addr;
 	}
 
-- 
2.20.1.415.g653613c723-goog

