From: Jules Irenge <jbi.octave@gmail.com>
Subject: [PATCH 03/30] mm/memcontrol: Add missing annotation for unlock_page_lru()
Date: Fri, 14 Feb 2020 20:47:14 +0000
Message-ID: <20200214204741.94112-4-jbi.octave@gmail.com>
References: <0/30>
 <20200214204741.94112-1-jbi.octave@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MxFia235IPfyDDQlAzkqDLsg9ubjwppF/aCVODUQpIw=;
        b=LQmAqdXsML9wsGoHcSXgEQKuW22UvhWB3+YmPOoYpcyRKxaOGFw0sRsTP9S1LqiUJs
         bdsMK4EoopXxGlZUwb5tH6yhMXvxDXEvIQq0P3OJ7pJ+VUOCLL6h8qqNmWZkkHV8jd2B
         1PhOxvOSceedwzfZhc1p6KFkG61AKHWLd7YlXmPxB3eui8YNbKH7ZKysXnA3grvN2DPr
         5xiZKGTjCF8BDVemAY801rVDRcQYRMPd0VTq94+/OgqF6v/MMx6sDmijersbj2IOL24G
         jX75Cehb1X7k4z/9fQm2tRVySdwmPUX3i1ViH0YaL7oGqVOinBrh+hxbU8SAhgKB/BSK
         EQng==
In-Reply-To: <20200214204741.94112-1-jbi.octave@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: boqun.feng@gmail.com, Jules Irenge <jbi.octave@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <linux-mm@kvack.org>

Sparse reports warning at unlock_page_lry()

warning: context imbalance in unlock_page_lru() - unexpected unlock

The root cause is the missing annotation at unlock_page_lru()
Add the missing __releases(&pgdat->lru_lock)

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6f6dc8712e39..22ddd557a69b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2587,6 +2587,7 @@ static void lock_page_lru(struct page *page, int *isolated)
 }
 
 static void unlock_page_lru(struct page *page, int isolated)
+	__releases(&pgdat->lru_lock)
 {
 	pg_data_t *pgdat = page_pgdat(page);
 
-- 
2.24.1

