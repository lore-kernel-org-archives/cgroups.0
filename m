From: Chris Down <chris@chrisdown.name>
Subject: [PATCH] mm, memcg: Handle cgroup_disable=memory when getting memcg
 protection
Date: Thu, 31 Jan 2019 23:57:11 -0500
Message-ID: <20190201045711.GA18302@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ZyfqNSgV7sbHHKf6GgHwEJjj9JK6z7ZkNg8CfEE8r3I=;
        b=qj05xz3WgtljNNSNzrUl/+5aWQIJ56oIIBdLbo95C8lC3RoRbf1Dnk3pKF0YWZakDA
         U/gkYIWajbXocX3JIHknN2rYGqm35i1QhIVy2mnOP59QLd/OPPqeM9LKfdNK4xRxKt8l
         X1J4VfVTn5CAdOjcS7mNBXVokP4Cb0Y2eyi8Y=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

memcg is NULL if we have CONFIG_MEMCG set, but cgroup_disable=memory on
the kernel command line.

Fixes: 8a907cdf0177ab40 ("mm, memcg: proportional memory.{low,min} reclaim")
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/memcontrol.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 290cfbfd60cd..49742489aa56 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -335,6 +335,9 @@ static inline bool mem_cgroup_disabled(void)
 
 static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg)
 {
+	if (mem_cgroup_disabled())
+		return 0;
+
 	return max(READ_ONCE(memcg->memory.emin), READ_ONCE(memcg->memory.elow));
 }
 
-- 
2.20.1

