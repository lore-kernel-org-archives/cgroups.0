From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 1/9] mm: vmstat: fix stat_threshold for NR_KERNEL_STACK_KB
Date: Sat,  5 Dec 2020 21:02:16 +0800
Message-ID: <20201205130224.81607-2-songmuchun@bytedance.com>
References: <20201205130224.81607-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CowKSBe21ybUCNZpbXy3BdqlRA0xnHhkE4QdTXQDr3k=;
        b=1E/sfXgHaC4PaGNOQGTv5UbJpGKRfVFVfNwfoMAvioxro0OeUnyGU7+KbNrPOmzCJB
         Uc+HeD8TjLwjqb5MX1YfYNo3gGGM7+9qKPJNif8ipbHCrN6r7rYKmOi8fBHe67OyeSBy
         Y1P4LecS8PHQ1OnnbNTZD/cwAKl6OFG9NvKKfrPw4bK9RC4BPsZNj48E9G7vqAjSylgL
         5pvEUV3NYJodopVNMOcvf6Kls5MhenBu7FAvV7gfzrSFhzJ2wLUsvGk6BhmB+JtCXpVw
         obRyNkYZAykzB3ugmrBdd4T4Vi3xL+S4QOJd9QNRYELJOY2AWIKE8QOyBmaBnF3al2AA
         yeLA==
In-Reply-To: <20201205130224.81607-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, will@kernel.org, guro@fb.com, rppt@kernel.org, tglx@linutronix.de, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, surenb@google.com, avagin@openvz.org, elver@google.com, rdunlap@infradead.org, iamjoonsoo.kim@lge.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>

The kernel stack is being accounted in KiB not page, so the
stat_threshold should also adjust to byte.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/vmstat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 8d77ee426e22..f7857a7052e4 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -353,6 +353,8 @@ void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 	x = delta + __this_cpu_read(*p);
 
 	t = __this_cpu_read(pcp->stat_threshold);
+	if (unlikely(item == NR_KERNEL_STACK_KB))
+		t <<= PAGE_SHIFT;
 
 	if (unlikely(abs(x) > t)) {
 		node_page_state_add(x, pgdat, item);
@@ -573,6 +575,8 @@ static inline void mod_node_state(struct pglist_data *pgdat,
 		 * for all cpus in a node.
 		 */
 		t = this_cpu_read(pcp->stat_threshold);
+		if (unlikely(item == NR_KERNEL_STACK_KB))
+			t <<= PAGE_SHIFT;
 
 		o = this_cpu_read(*p);
 		n = delta + o;
-- 
2.11.0

