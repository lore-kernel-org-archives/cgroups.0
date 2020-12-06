From: Muchun Song <songmuchun@bytedance.com>
Subject: [RESEND PATCH v2 01/12] mm: memcontrol: fix NR_ANON_THPS account
Date: Sun,  6 Dec 2020 18:14:40 +0800
Message-ID: <20201206101451.14706-2-songmuchun@bytedance.com>
References: <20201206101451.14706-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JLGZC7sv5nAUpuhCShqzZAhxLbvYoPKLszNPrb+RhvY=;
        b=sDQL9F0PUFel7IRE81/3eSpUKyMdwDgTZi3UBN+42b+bU2PNE/t3ymmlZSkl6G0zUE
         NSCG35LdEVF++dP/WfDe2t2uqtwSFpsGuaN57CFdrOLHb4WjfZ3jys2v2GYv1slCoxpV
         lHGI0MzqMCRhrpIXGMhucScdPb77XwS1gVQ8DA3u+zB/gPDofVk7OR0MNcSQkNxlPfaJ
         1RyynIXs88y3N+8Tuq6M1bZWNQoh5e5Y9f2FauDg2E2dRqtshDAZubBtA0H7xFytfcsr
         bP6zs0AWlZzZkTE8tZ0EnxPaZLjkWuzOMlhnw7qO6H+KSceypFyZdtq4GtFb8oTd85Yc
         RNxQ==
In-Reply-To: <20201206101451.14706-1-songmuchun@bytedance.com>
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

