From: Yuwei Guan <ssawgyw@gmail.com>
Subject: [PATCH 3/5] block, bfq: remove redundant max_t() in bfq_bfqq_charge_time()
Date: Wed,  2 Nov 2022 19:43:52 +0800
Message-ID: <20221102114354.162-4-Yuwei.Guan@zeekrlife.com>
References: <20221102114354.162-1-Yuwei.Guan@zeekrlife.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0TO3AKUnGTYlpFDHE0inxQ4G6Kp5byNURiimvggoLdA=;
        b=Dfn45f8qMlZMxWk8SdtU4g1j/0dksy4HKNil57zO838ijzFZAvF94pr0JzkIJqBfCE
         xRyWpDyx0dwfOBqGQBnN4T1c1KjR16kBL0CPPaQccxbmDPbREWvCI+XI4fRhGvv7RusC
         F9j2/nqV0l/9FY/LuHNolayQKAOZtO9YGsBPBP5NjJaP7FcQyszh47B80tpIEdxJSqZ/
         sp5vKwNEjQ8ZmoNyX3LEfvcSAyfioYKKnp0aDtbdWjAL7s6Cw9Y7sK8Kx/Q9MPIjhmbM
         ofpi6YBJHwpGYdcd7pccfr1BaG1HjobH03lbzFrTutIYM0d7qUkML8/YrBM+7f5j7AIo
         iPnw==
In-Reply-To: <20221102114354.162-1-Yuwei.Guan@zeekrlife.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org, josef@toxicpanda.com
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yuwei.Guan@zeekrlife.com

The "tot_serv_to_charge" is great than or equal to "entity->service",
so no need to do max_t() again.

Signed-off-by: Yuwei Guan <Yuwei.Guan@zeekrlife.com>
---
 block/bfq-wf2q.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 8fc3da4c23bb..3da08f4be633 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -867,8 +867,7 @@ void bfq_bfqq_charge_time(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	if (tot_serv_to_charge > entity->budget)
 		entity->budget = tot_serv_to_charge;
 
-	bfq_bfqq_served(bfqq,
-			max_t(int, 0, tot_serv_to_charge - entity->service));
+	bfq_bfqq_served(bfqq, tot_serv_to_charge - entity->service);
 }
 
 static void bfq_update_fin_time_enqueue(struct bfq_entity *entity,
-- 
2.34.1

