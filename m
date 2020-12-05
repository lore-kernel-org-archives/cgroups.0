From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 2/9] mm: memcontrol: fix NR_ANON_THPS account
Date: Sat,  5 Dec 2020 21:02:17 +0800
Message-ID: <20201205130224.81607-3-songmuchun@bytedance.com>
References: <20201205130224.81607-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JLGZC7sv5nAUpuhCShqzZAhxLbvYoPKLszNPrb+RhvY=;
        b=iXNSJ08wIZGakHjgbIcjXIwKHGYw6UmpSfo0Eb6nim+XGWMNO6A9YVj0zeZ0dYSQFb
         VCVr64gPtj6hVu4sogDtwUSNROzxv6XvOqYT+pBJFDMLmdj3FCafR6WDEUGrUGpa/Gry
         XXAUfe11y0QLCmPB2oAJqeUXRXxHhQFQISCUJ2uu0NDV/c2iML7Jx2DS5LxoZdVrz+Dt
         JWQKZovT5QiiunDzry2OtZZ0K6Qd39WLeMyA2wk/HngpFlpKfv9fU/7JTGbFE+lpi8zb
         9xP0mmYdGoGIHA3F9+ShWXuADJv7UxVumiQ3BAl7ffDiAPAwAgcfHt+lMzY/FNoFgLKl
         JnvQ==
In-Reply-To: <20201205130224.81607-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, will@kernel.org, guro@fb.com, rppt@kernel.org, tglx@linutronix.de, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, surenb@google.com, avagin@openvz.org, elver@google.com, rdunlap@infradead.org, iamjoonsoo.kim@lge.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>

The unit of NR_ANON_THPS is HPAGE_PMD_NR already. So it should inc/dec
by one rather than nr_pages.

Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memcontrol.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 22d9bd688d6d..695dedf8687a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5634,10 +5634,8 @@ static int mem_cgroup_move_account(struct page *page,
 			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
 			if (PageTransHuge(page)) {
-				__mod_lruvec_state(from_vec, NR_ANON_THPS,
-						   -nr_pages);
-				__mod_lruvec_state(to_vec, NR_ANON_THPS,
-						   nr_pages);
+				__dec_lruvec_state(from_vec, NR_ANON_THPS);
+				__inc_lruvec_state(to_vec, NR_ANON_THPS);
 			}
 
 		}
-- 
2.11.0

