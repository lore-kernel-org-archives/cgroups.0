From: Chris Down <chris@chrisdown.name>
Subject: [PATCH] fixup: vmscan: Fix build on !CONFIG_MEMCG from nr_deactivate
 changes
Date: Fri, 22 Mar 2019 15:05:13 +0000
Message-ID: <20190322150513.GA22021@chrisdown.name>
References: <155290128498.31489.18250485448913338607.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=la79GVMa47gWOb0qD5kRoQk6VC6UfGHw4stP89HbwZw=;
        b=iyQnjGnG51BIfxJIICh18JKJdtzPSrWThifwALw2gWvK1/gNZEsTAKEvxsc3wzKXqK
         tQ08PhWRYD6ROgWHR8CED2SyxdwNUvt1+EpYx+TraC3D3f4BUhopjef2d0iHHuR+fvRW
         OK+Dxeh5EfJv5kyTXhWF0/qOB6NJxdNwXhYr8=
Content-Disposition: inline
In-Reply-To: <155290128498.31489.18250485448913338607.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

"mm: move nr_deactivate accounting to shrink_active_list()" uses the
non-irqsaved version of count_memcg_events (__count_memcg_events), but
we've only exported the irqsaving version of it to userspace, so the
build breaks:

    mm/vmscan.c: In function ‘shrink_active_list’:
    mm/vmscan.c:2101:2: error: implicit declaration of function ‘__count_memcg_events’; did you mean ‘count_memcg_events’? [-Werror=implicit-function-declaration]

This fixup makes it build with !CONFIG_MEMCG.

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: kernel-team@fb.com
---
 include/linux/memcontrol.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 534267947664..b226c4bafc93 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1147,6 +1147,12 @@ static inline void count_memcg_events(struct mem_cgroup *memcg,
 {
 }
 
+static inline void __count_memcg_events(struct mem_cgroup *memcg,
+					enum vm_event_item idx,
+					unsigned long count)
+{
+}
+
 static inline void count_memcg_page_event(struct page *page,
 					  int idx)
 {
-- 
2.21.0

