From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v2 9/9] memcg: do not modify rstat tree for zero updates
Date: Tue, 28 Mar 2023 22:16:44 +0000
Message-ID: <20230328221644.803272-10-yosryahmed@google.com>
References: <20230328221644.803272-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680041827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3EqK7sQZOfVTLBQ7dVPZO4hRmfVfAzm1laH3BYvfeCs=;
        b=Jh0ANfJdLtvcj14Ycx8o0NJ4r9qhZa68Pa0uc2IX0QIjCZKetrfT/Nq/ZDVr5AllWU
         XClT4UcNh1sPOxMcsh6sWOQo9/2lETExd/HKLVBB2M4wtgPvzRmNcVBtdBrQWB7ALdhZ
         R5a35ECD7K8gif2eOzvhZ1FDX+1AdzcBxQSZ/AU6EUVqL3HECb2nu5rbm6oZEkaJmqE+
         JiSGi5TQPR/5oszlj+b2yUkvaRVAqFo8Ka4HGQ6Ui7wSkXSWPGkTPTug5dc09uPeC/es
         /a05azr2/gL04QjqP7TTdBynMB9W71leZpwkNhiYtT2r27tRHGjbrwcjlQFLDRhwcOoU
         qhHA==
In-Reply-To: <20230328221644.803272-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

In some situations, we may end up calling memcg_rstat_updated() with a
value of 0, which means the stat was not actually updated. An example is
if we fail to reclaim any pages in shrink_folio_list().

Do not add the cgroup to the rstat updated tree in this case, to avoid
unnecessarily flushing it.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 361c0bbf7283..a63ee2efa780 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -618,6 +618,9 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
 	unsigned int x;
 
+	if (!val)
+		return;
+
 	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
 
 	x = __this_cpu_add_return(stats_updates, abs(val));
-- 
2.40.0.348.gf938b09366-goog

