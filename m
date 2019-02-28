From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 3/6] mm: memcontrol: replace node summing with memcg_page_state()
Date: Thu, 28 Feb 2019 11:30:17 -0500
Message-ID: <20190228163020.24100-4-hannes@cmpxchg.org>
References: <20190228163020.24100-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q68vDKJoy4wkBVCCNbeXOOo5XkzY9NuLFWEJjvpu9MI=;
        b=0WT5rtTI1WKxMYjRHLUdNtdc8IsHgN6ifmKk4VfIC2ys+4BaRMElBPNWBkf1sY9V2U
         DBgNNGgwSI8YyW0YqocogXheOlD1uDjEimiRXYZJFO7GLlIfOGc7HZOuSUQbFN0Wgl1d
         eJLi29oGq6b4efRD83YQPz5IeBD+wxIvU7zwz00xHyxcAQHlzkPJtLGBmEugCfx+CAo/
         t9J/UmkKoI48HsTy46tNW8AazNXmo6bE09T4Z3Do/iURkSM9AcI7iW/B04LO2pfr8aNp
         KuY3Qr8xk08bXRBFWC7Pt7v78/5OFVDijamJDggw/hKAruJeHvrhKmbmi12rUfPQd8zW
         1FFg==
In-Reply-To: <20190228163020.24100-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Instead of adding up the node counters, use memcg_page_state() to get
the memcg state directly. This is a bit cheaper and more stream-lined.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d85a41cfee60..e702b67cde41 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -746,10 +746,13 @@ static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
 			unsigned int lru_mask)
 {
 	unsigned long nr = 0;
-	int nid;
+	enum lru_list lru;
 
-	for_each_node_state(nid, N_MEMORY)
-		nr += mem_cgroup_node_nr_lru_pages(memcg, nid, lru_mask);
+	for_each_lru(lru) {
+		if (!(BIT(lru) & lru_mask))
+			continue;
+		nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
+	}
 	return nr;
 }
 
-- 
2.20.1

