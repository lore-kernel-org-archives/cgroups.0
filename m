Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404D341837C
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 20:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786481306; cv=none; b=qGaSqxUtvQphQUBznM96G7tQDTjjhnTaZiznmI6BxyaSOdpBvxLU6hR5g/iR5WqU8WFAi5EAsOY37IM4ZszmMTrjTwge4Zejj+r/t9wL4R7G8kin6opYPjueSj0pZHCKQZz6dxFHTlK5kQnan1ONLY84akhfA6Qst2MEodJ5trg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786481306; c=relaxed/simple;
	bh=r2c3+jU4lmDdIvRIGjJAf//rnst5NVtf9b/Vhmkr4E4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=jek7Mg6Euvtesl8Nl43dRmg/km8JcMahcad9qfYT3N3H1JUA5us0ewPG3oBei6tn69YZdM6a7eKFxG+o5wjXoxC3m9ec0ynehxn6LC32Npri85SYbgzcinoDIYQg6Wkip+RuxcFU8dNQ9EK1Bu+qMN+MGaw1xCRvnzTblAouBtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sudarsanm.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dc+QJFwE; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sudarsanm.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dc+QJFwE"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e11baa66eso331244a91.2
        for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 13:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786481304; x=1787086104; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JRMZT7Mqa3AuvQteyaNLXjW3SaaVbTDWA+KghRiAEJw=;
        b=dc+QJFwE8uLqxiB4VdhXdYKndQ0g+tVCb1NzvKac5LdZt0GyphneEfG1hVdG6Ua/7C
         529wsqDcnzrm39kT05HEmyV4Hu4Zr0G5xEc2hfCv0VwDMLNH2l4dkoCVdEJfPavyRRts
         VbnK9BXEG3IyX5R2upJ0eN1hC/bbHf7yuZSCBq3ByX/F0qTSvPse0FiPeZfTaaSuKKHy
         45JZOjHg+VwM7qcA4T84ugQu/mQc52wnQLpu3Rdpuw4la+K62dP2ouRTykqEK2+3Ij4K
         6BofWRuwE2uja7cXfL8trAVSav+C+J1xdM3uhj/dcwJgJ6DewyV+YADhzhTmEP7Yg+ft
         NMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786481304; x=1787086104;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JRMZT7Mqa3AuvQteyaNLXjW3SaaVbTDWA+KghRiAEJw=;
        b=ZVgHf2sT71vEbqWmfMe8cem1uzy+FHAIdtCYBYK99jIGhHIp8kBPdOXrIjePZHqNNX
         aAIWyIZEHOQIbqA07I0C67blXSzujBoH0hGTQEeGIoMfNLlhG6/jA7LA9kQKTWG81oPT
         0XHV6rjBbSZ3OwTdtcCv6mFqlVHHmphGGc4WMKIOdOR/88ado22rDSjb5hIa3bXZFPXR
         QiASN5Rq7IvF3nrgUocE+aHdhxKWd56DGjS22gowuIrU2on0YMY4lWklXNKY5Gc+U2Rn
         0ztk95L/gWmVM6cXUjm+7cTn7bPWlJ6EsTqfkLu9x2FR6BCb2qGguhqOH+YXjzzE1FQp
         ys5Q==
X-Gm-Message-State: AOJu0YyNpXnZYXpL3IQM9f9fBBbI3SQg6gYnFfwikdU5M/zaB7Shaujf
	39OxNE6vGwBQ1oTzHYjK18mADRelL4wkn0gSZYTA/vmFx71tvubHOAlGRuD8uVuXjMpvOBpZ+BV
	SW/ouGPWSHguH688wyQ==
X-Received: from dlbrl7.prod.google.com ([2002:a05:7022:f507:b0:13e:6c87:9564])
 (user=sudarsanm job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:280d:b0:38f:240d:b857 with SMTP id 98e67ed59e1d1-392ec393372mr7602326a91.2.1786481304070;
 Tue, 11 Aug 2026 13:48:24 -0700 (PDT)
Date: Tue, 11 Aug 2026 13:48:03 -0700
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260811204803.3770208-1-sudarsanm@google.com>
Subject: [PATCH] blk-cgroup: fix circular locking dependency in blkg_conf_prep
From: Sudarsan Mahendran <sudarsanm@google.com>
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Khazhy Kumykov <khazhy@google.com>, 
	Sudarsan Mahendran <sudarsanm@google.com>
Content-Type: text/plain; charset="UTF-8"

In blkg_conf_prep, we may do IO when allocating while
holding blkcg_mutex, however this presents a deadlock
scenario since we may grab sysfs_lock while IO is
suspended in elevator_exit, and an existing chain
exists from sysfs_mutex -> blkcg_mutex.

We can fix this by performing only GFP_NOIO allocations within
blkg_conf_prep when blkcg_mutex is held.
This patch fixes our reproducer.

Full lockdep splat:

[ 3795.003422] ======================================================
[ 3795.009595] WARNING: possible circular locking dependency detected
[ 3795.015773] 6.18.20-dbg-DEV #1 Tainted: G                 N
[ 3795.021432] ------------------------------------------------------
[ 3795.027604] kpython3/435194 is trying to acquire lock:
[ 3795.032744] ffffffffa36959b8 (fs_reclaim){+.+.}-{0:0}, at: kmem_cache_alloc_noprof+0x49/0x5c0
[ 3795.041260]
[ 3795.041260] but task is already holding lock:
[ 3795.047086] ffff98c8a06477b0 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkg_conf_prep+0x71/0x5e0
[ 3795.055257]
[ 3795.055257] which lock already depends on the new lock.
[ 3795.055257]
[ 3795.063422]
[ 3795.063422] the existing dependency chain (in reverse order) is:
[ 3795.070893]
[ 3795.070893] -> #4 (&q->blkcg_mutex){+.+.}-{4:4}:
[ 3795.076986]        __mutex_lock+0x92/0xb70
[ 3795.081085]        blkcg_deactivate_policy+0x7f/0x230
[ 3795.086137]        bfq_exit_queue+0xe1/0x110
[ 3795.090401]        blk_mq_exit_sched+0xd1/0x170
[ 3795.094935]        elevator_exit+0x50/0x70
(...)
[ 3795.135019]
[ 3795.135019] -> #3 (&eq->sysfs_lock){+.+.}-{4:4}:
[ 3795.141110]        __mutex_lock+0x92/0xb70
[ 3795.145211]        elevator_exit+0x45/0x70
[ 3795.149308]        elevator_switch+0x98/0x290
[ 3795.153660]        elevator_change+0x109/0x190
[ 3795.158106]        elv_iosched_store+0x198/0x240
(...)
[ 3795.185276]
[ 3795.185276] -> #2 (&q->elevator_lock){+.+.}-{4:4}:
[ 3795.191541]        __mutex_lock+0x92/0xb70
[ 3795.195642]        elevator_change+0xb6/0x190
[ 3795.200001]        elv_iosched_store+0x198/0x240
(...)
[ 3795.227179]
[ 3795.227179] -> #1 (&q->q_usage_counter(io)#19){++++}-{0:0}:
[ 3795.234224]        blk_alloc_queue+0x33e/0x370
(...)
[ 3795.266621]
[ 3795.266621] -> #0 (fs_reclaim){+.+.}-{0:0}:
[ 3795.272280]        __lock_acquire+0x157c/0x2980
[ 3795.276813]        lock_acquire+0xd3/0x2a0
[ 3795.280904]        fs_reclaim_acquire+0x55/0xc0
[ 3795.285435]        kmem_cache_alloc_noprof+0x49/0x5c0
[ 3795.290481]        __radix_tree_preload+0xef/0x250
[ 3795.295273]        blkg_conf_prep+0x2aa/0x5e0
[ 3795.299633]        tg_set_conf+0xa5/0x1a0
(...)
[ 3795.330808]
[ 3795.330808] other info that might help us debug this:
[ 3795.330808]
[ 3795.338806] Chain exists of:
[ 3795.338806]   fs_reclaim --> &eq->sysfs_lock --> &q->blkcg_mutex
[ 3795.338806]
[ 3795.349146]  Possible unsafe locking scenario:
[ 3795.349146]
[ 3795.355057]        CPU0                    CPU1
[ 3795.359590]        ----                    ----
[ 3795.364121]   lock(&q->blkcg_mutex);
[ 3795.367691]                                lock(&eq->sysfs_lock);
[ 3795.373776]                                lock(&q->blkcg_mutex);
[ 3795.379862]   lock(fs_reclaim);
[ 3795.383006]
[ 3795.383006]  *** DEADLOCK ***

Reviewed-by: Khazhy Kumykov <khazhy@google.com>
Signed-off-by: Sudarsan Mahendran <sudarsanm@google.com>
---
 block/blk-cgroup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d9676126c5b5..b981a80bbd94 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -867,7 +867,6 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			parent = blkcg_parent(parent);
 		}
 
-		/* Drop locks to do new blkg allocation with GFP_KERNEL. */
 		spin_unlock_irq(&q->queue_lock);
 
 		new_blkg = blkg_alloc(pos, disk, GFP_NOIO);
@@ -876,7 +875,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto fail_exit;
 		}
 
-		if (radix_tree_preload(GFP_KERNEL)) {
+		if (radix_tree_preload(GFP_NOIO)) {
 			blkg_free(new_blkg);
 			ret = -ENOMEM;
 			goto fail_exit;
-- 
2.55.0.679.g6767b8d81c-goog

