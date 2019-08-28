From: Fam Zheng <zhengfeiran@bytedance.com>
Subject: [PATCH v3 1/3] bfq: Fix the missing barrier in __bfq_entity_update_weight_prio
Date: Wed, 28 Aug 2019 11:54:51 +0800
Message-ID: <20190828035453.18129-2-zhengfeiran@bytedance.com>
References: <20190828035453.18129-1-zhengfeiran@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mxNtarX9nX57XJxkArjO2AM3QUOz0wzt/JnfD0VPOK0=;
        b=F4caB0aZl1+ljrrlr2ZXzSJ64Udep2IJeA7lQGcAGXBMsyDN9JCNHMO6FT0Ar5vP0v
         UnJCBrHKqZHlbtTQE09XNLLGK9s6lXCj0RfiEUYHCKkZZT3DyfafbE7GpO6RUlwg+E8T
         EDITDAEd81fTvZLyUoEhaX1ib77eZxhg/UoEi81UsG9KE3s0ZgZqgkTAa8cMari6sOBz
         BiasbpjnO/EnhLafHhn/4W5YObrmcFzXPTkbANjmau0q6sNwnLh/HDhWRGDe0dfDU182
         lkes5Qnwe7Mcqt21kTvs3UN/UlyCzS3m/4xDlaMvoRd5eiDJFX2ROW2Xo/vuHPiT5E/i
         l6ZA==
In-Reply-To: <20190828035453.18129-1-zhengfeiran@bytedance.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, paolo.valente@linaro.org, fam@euphon.net, duanxiongchun@bytedance.com, cgroups@vger.kernel.org, zhangjiachen.jc@bytedance.com, tj@kernel.org, linux-block@vger.kernel.org

The comment of bfq_group_set_weight says the reading of prio_changed
should happen before the reading of weight, but a memory barrier is
missing here. Add it now, to match the smp_wmb() there.

Signed-off-by: Fam Zheng <zhengfeiran@bytedance.com>
Reviewed-by: Paolo Valente <paolo.valente@linaro.org>
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
2.22.1

