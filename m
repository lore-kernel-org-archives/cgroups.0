From: Fam Zheng <zhengfeiran@bytedance.com>
Subject: [PATCH v2 1/3] bfq: Fix the missing barrier in __bfq_entity_update_weight_prio
Date: Mon,  5 Aug 2019 14:38:05 +0800
Message-ID: <20190805063807.9494-2-zhengfeiran@bytedance.com>
References: <20190805063807.9494-1-zhengfeiran@bytedance.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H0yUp64wfUQz7/P14zeAkDAdPbazrBmBRzsKkTj102k=;
        b=HkqdS5JfAzU5BEi1rePzJYVVta7pmYY9kcs8THIOz9I9OoWyVYFoS8yIydBOR4khk5
         NeMe6c/hV8JE8DIvkkaEz8yze8KZ1gP7tzk+8ey9ETPzgPATG5RgLbFTQ2SSaIEtF9ww
         6ZFeXT8qCQpIRrKSxqf1DLd7BnjBrA5abZ3VxSqjTOBPBP18qoUm5LLlvjyrM+cfIHfV
         e0l9CmNfliF9bLK/71XhHxS26xy1KnswmuImQ04lHQJerW1dB/mMVqRBjda0RZ116I6g
         pTFy2Wo6QOPDj2YsB8/flAFkdF3Hi2A7F/xY5Wzj9oBxQdd5g1vbsMV2JkgpPKSUMnfn
         iV3A==
In-Reply-To: <20190805063807.9494-1-zhengfeiran@bytedance.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, fam@euphon.net, paolo.valente@linaro.org, duanxiongchun@bytedance.com, linux-block@vger.kernel.org, tj@kernel.org, cgroups@vger.kernel.org, zhangjiachen.jc@bytedance.com

The comment of bfq_group_set_weight says the reading of prio_changed
should happen before the reading of weight, but a memory barrier is
missing here. Add it now, to match the smp_wmb() there.

Signed-off-by: Fam Zheng <zhengfeiran@bytedance.com>
---
 block/bfq-wf2q.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index c9ba225081ce..05f0bf4a1144 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -744,6 +744,8 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
 		}
 #endif
 
+		/* Matches the smp_wmb() in bfq_group_set_weight. */
+		smp_rmb();
 		old_st->wsum -= entity->weight;
 
 		if (entity->new_weight != entity->orig_weight) {
-- 
2.11.0

