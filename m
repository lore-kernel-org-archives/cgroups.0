From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v5 1/7] mm: memcontrol: fix NR_ANON_THPS accounting in charge moving
Date: Thu, 17 Dec 2020 11:43:50 +0800
Message-ID: <20201217034356.4708-2-songmuchun@bytedance.com>
References: <20201217034356.4708-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I8JqAljVYtmaPaBvHCRChrR0oheI9SrolUe2et8YFn8=;
        b=LFRZS+7DcgILx1b9ou9M96wmw6taZL3I+iRan+cCcipo6HVZ24/ujb+bZ41PZXuLCZ
         1ReDBz6W6bu3NpG+2xk3pKfOFqrr9g2Qrb+uxz9T03e6UIzD/fN/FfVR0NBGQ5XLo0iW
         92K9qsyjSKNMYvLIcXdcn4DmKQ6yGUXvZ65QwyV7KMh0r+dZcCC79wnl9nGlvvWbYfOn
         RsEhQDpDm1uB7/ugs30Y6r4YkQ5eTOqbqec+OmXWgHo8olU4a4utfAysCogecVHdUejg
         SBw8Ad8KH0AGA1ChhpBwqy5mYnB+rBtL8Da74sdNyCe6Hm4IgtSSQ7doCiueJfa1paez
         mfkg==
In-Reply-To: <20201217034356.4708-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, shakeelb@google.com, guro@fb.com, samitolvanen@google.com, feng.tang@intel.com, neilb@suse.de, iamjoonsoo.kim@lge.com, rdunlap@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, Michal Hocko <mhocko@suse.com>, Pankaj Gupta <pankaj.gupta@cloud.ionos.com>

The unit of NR_ANON_THPS is HPAGE_PMD_NR already. So it should inc/dec
by one rather than nr_pages.

Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
---
 mm/memcontrol.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b80328f52fb4..8818bf64d6fe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5653,10 +5653,8 @@ static int mem_cgroup_move_account(struct page *page,
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

