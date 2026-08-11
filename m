Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DB23F8EA1
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 11:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786446289; cv=none; b=kqWEo/wFop29mf77alWj0ff/Fw/03w7uxoPaRaplismsi6hgWrBMr44W6nB4oKf4Z0+nhq/xZOvXnND7uPaPUtDcFZTPmSWk+aMq2xGgsFw0ZVYf/0vTS0vQWNGaPfCK43ImCYpTDl/nt1h4r+r4nN86JhDvuqQYrx7zlGdMELc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786446289; c=relaxed/simple;
	bh=atCxkuYL4hRzLwzbyOunU2UxpM3YWWuI9Tod9XDOHxY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PYHxYj+u2pRQm6y5vDi5fmW68mDlL9qfEn56kAo9OCGlc4tqRbKErPS3Qrqrk+zqYa6yO+4PpbCA7OXXmGw3eC0NqSAJDg20zU8v/Cq3sI1bne4LOXTABR7kDtHJGI7SQnta6LD2Fw54EM6bmEGei8FRrbZHIJOsAdBAk+0IPVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nneAstkH; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nneAstkH"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47fecbb7000so1471885f8f.2
        for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 04:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786446286; x=1787051086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LEHATZupNKkhi1i84uPxQjWjLcsCZYtEP5bp/4g/DpQ=;
        b=nneAstkHsY22j6wQMmPAVcGZBGnv3EKFyomdG3I/1hYHJExFM3n0HsRWTwFqjINyij
         V2x3mEAfhkyBzTqDb23rLHmfFWpEFGAWkOzJEwbEPG47ZgN7B/GlazbbVJfDM0eO4zws
         2uen8h67cR8SHkRhTjpiebYX/I29mC1aNnZ5Pxj31JLynS6IPKLqwAapFM+7pkqXDWme
         2VDWCjC653f0pijo9xi2GQKib1UOZsbVzmUd8ATxKrvU6ces2dlcKnj8xuxXSDb6AL5H
         mpBZT4ADC6dTaWGh8w/L/bNkQNoQj6d+tMu9TqLgWOZlPdMaPJ9D1V9LFtHfH+8ddIx9
         nouw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786446286; x=1787051086;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LEHATZupNKkhi1i84uPxQjWjLcsCZYtEP5bp/4g/DpQ=;
        b=SInhiRujMMfy5fcc5yjdLOZpXB+2FaV3PLl8UKzn9wQiNHWqHVOKyy8+HL3zIzH+/N
         93tEvAFKfdB3L03c37BO1UEeSl7Ei5RNCeb59sFaWcdWGknMQNvB/CHqQuunPYtwVHB6
         fc3WKW9DSk3BiUIa9y10ETqqkQpw4XehzCRUVXU6qxJbIc5vI24wPhRHCgus5Oh4QDMo
         L00oNfsi7lYEIF35OjU3i3I8eUW4mq07Ciso6yVC5QbL7L9De6yQdny+Hvj71ESR/vuo
         t0TskNFuYv3bwEP30wzztPC/OSVpMphI2fXetNr50D0gAASi8POpZEx/R4OVcvmf3eke
         3mvw==
X-Forwarded-Encrypted: i=1; AHgh+RoY5SFxUw79M7m23O3XWgi4xNlM7oJKl3Sznl9gE9myKl9MibGPhHjBUn10qyr7s57zi+6BA73x@vger.kernel.org
X-Gm-Message-State: AOJu0YyuUrfujfNB38LM1sAcoIlX17Y8AD6PCFb1m9gCMU0q/knjI4yO
	BvOWAwQZus5onsMv7RiAhjXt2fvYeHoEzHo3NxLb6sYryvQLR6pJp2zG
X-Gm-Gg: AR+sD10gITH+fu10wH6wIX/hV79Fdmx6slbyq6Z4dDJpU0W5hLzyoIp7XNzL3oN1XdV
	g6RE7yg2cd5nXAaE38ZG8e639ZcJ+ClKc/JpDtKFCeqM+bqJlZrLfo1JjJF4Tb2KzHHe7iNVivX
	OcHYMHq46Hfy0/IrgKp6vhsEDMFrc/Faf6tnqWeEFSnTfQz1eLmrRPh6f1vq9cAbfyNAyKrZgMy
	sl9aFpnQ6s01Qmr8O4e7zucSbEBJ110HZFw9+C0kEK4hUQKXcXWFSDP/yW+qLtEPazDaPxD+WlZ
	l1ZkFwyq+Jj52IYfgVu4kWlZZcYtMcfocTz8PgyWnDT7AG9gA9IZ+cqXKTWXdxsXJqR8N7OpRm4
	8YnjuW93iScVHOCWcyHAlXsF4OJuKqDvN0dFTy5hWcoMk0qkAvmwjqP5QQ4N3Xv0bBd6yoDWNz2
	2Tkb4xI1+qlgeu2Z15z6/lBdC7mJnVzE+g3QpCtc407fV12HTLs0f8J48MeGjS7vnfbFkOdcjG0
	FUAvI+I63qbshyUn574ZuXoY8kz4yupIw4JG9/n4jdrvVHlKoU4Assv7nkgPhz/Ls33D3ynYHIc
	BxREaWuviTECoJJDnAHgRIuBVRYbTzQf8hT+Duu47leqy+Erk4Nvk0hacv/OpWcdGJhw
X-Received: by 2002:a05:6000:4008:b0:47f:f3d4:26da with SMTP id ffacd0b85a97d-4814ad8ed6amr4076784f8f.11.1786446281619;
        Tue, 11 Aug 2026 04:04:41 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a133-e401-bc8e-d36c-2d08-c5e0.310.pool.telefonica.de. [2a02:3100:a133:e401:bc8e:d36c:2d08:c5e0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a72cdb8sm3593881f8f.35.2026.08.11.04.04.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 11 Aug 2026 04:04:41 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Yi Zhang <yi.zhang@redhat.com>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] blk-cgroup: fix lost wakeup in blkg_destroy_all()
Date: Tue, 11 Aug 2026 13:04:21 +0200
Message-Id: <20260811110421.50747-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

wake_up_var() requires a full barrier between making the wait condition
true and its lockless waitqueue check. spin_unlock_irq() has only
release semantics, so it does not order q->root_blkg = NULL against
that check.

During disk rebind, blkcg_init_disk() can therefore miss the wakeup and
sleep indefinitely. Add the required smp_mb(). Also mark the store with
WRITE_ONCE() since the waiter reads root_blkg locklessly with
READ_ONCE(). An LKMM model permits the missed-wakeup outcome without
the barrier and forbids it with the barrier.

Fixes: 3dbaacf6ab68 ("blk-cgroup: wait for blkcg cleanup before initializing new disk")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
LKMM (herdtools7 7.58), with the store modeled by WRITE_ONCE(). flag
is q->root_blkg (1 = set), lk the queue_lock, wq the var waitqueue
occupancy. To model the fixed code, insert smp_mb() in P0 between
smp_store_release(lk, 0) and READ_ONCE(*wq):

  C blkcg-rebind-buggy
  { flag=1; }
  P0(int *flag, int *lk, int *wq)
  {
  	int r0;
  	WRITE_ONCE(*flag, 0);
  	smp_store_release(lk, 0);
  	r0 = READ_ONCE(*wq);
  }
  P1(int *flag, int *lk, int *wq)
  {
  	int r1;
  	WRITE_ONCE(*wq, 1);
  	smp_mb();
  	r1 = READ_ONCE(*flag);
  }
  exists (0:r0=0 /\ 1:r1=1)

  herd7 -conf linux-kernel.cfg blkcg-rebind-buggy.litmus

  without smp_mb(): Sometimes
  with smp_mb():    Never

 block/blk-cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d9676126c5b5d..2b3cf9caeaa31 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -604,9 +604,11 @@ static void blkg_destroy_all(struct gendisk *disk)
 			__clear_bit(pol->plid, q->blkcg_pols);
 	}

-	q->root_blkg = NULL;
+	WRITE_ONCE(q->root_blkg, NULL);
 	spin_unlock_irq(&q->queue_lock);

+	/* Order q->root_blkg store before wake_up_var()'s waitqueue check */
+	smp_mb();
 	wake_up_var(&q->root_blkg);
 }

--
2.53.0
