Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24F92D97BA;
	Sat,  4 Jul 2026 19:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783194721; cv=none; b=q6aaSAd1dFWZKXlz0m4Od0S/8iFsD+3zP9f8bC9CkBhYjyB2051Hr2Urze47AnDMino9U968lS68mgPZJgYRm1poUxwblbA9cj1LNMKJMfgSk620ae+Pohs1kqBh2UoqDN5EVZN3jrwxKOjM4x2ldIPsjxMoVMc7DNh59gEt8/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783194721; c=relaxed/simple;
	bh=t2XYCn+A/IkwNRi3feNJZ9WS7rhvQ7G/bufMSIyEsjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/9Db/hVsfyxTe+IcFdxr5N98ieeUj4jI975qtuNBH/ufBH+nYwHE+SR740dkwQ63zd2GeSUvRjxgCI3yoeuYJ4LOFiH6uoC/m7V6JLJuLO3vd1Dj+ajhmpw21Jv/K0w7b69vNt2NV2lV2FUan7UtlvOxYFlVHPbXdC01bu1iqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JINEA6c0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JINEA6c0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B1C1F00A3A;
	Sat,  4 Jul 2026 19:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783194720;
	bh=xEWzTgA1po1hX1rYhrIp/cwjprJ8MLHYL8f16lSvCk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JINEA6c00skJHu9zlRvNX+FA16QvP7mcotl6mJOt7XUfQUPb8mLSl4rveDf/wbkFL
	 4nh7WqNa958naDV0x1GUFSZpU6zpkrBfQDsv2ouWJnlBWybSE2CCAdQZ2wBxQ8h3h/
	 PqcPcvlyBNBE5/jEHcW9jTSpK4Nu3FIvEgfSMFxpR7cJ0kxWevK5Sdfcm68wJ077YG
	 AvPyANALTYuXgfvXMXMkObu2wQ07oTueOOHyRHfag3m2nuDW+6yCNQ1WXCBPQ3JOL0
	 6rRO33VnV/fSbeKB6guedZthyoZFZoTuFgu5hc166uSZJV0cT6B1ETHgNe6YnVX4fD
	 /N/5GmJxaAwvA==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alasdair Kergon <agk@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Josef Bacik <josef@toxicpanda.com>,
	Yu Kuai <yukuai@fygo.io>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	dm-devel@lists.linux.dev,
	linux-bcache@vger.kernel.org
Subject: [RFC PATCH v1 01/17] nvme-multipath: retarget failedover bios from requeue work
Date: Sun,  5 Jul 2026 03:51:08 +0800
Message-ID: <20260704195124.1375075-2-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260704195124.1375075-1-yukuai@kernel.org>
References: <20260704195124.1375075-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

bio_set_dev() is about to become explicitly sleepable because it can
associate the bio with a blkg for the destination queue.  NVMe failover
can run from request completion context, and nvme_failover_req() also holds
head->requeue_lock with interrupts disabled while it steals bios from the
failed request.  Calling bio_set_dev() there is not safe once the helper is
allowed to sleep.

The requeue lock only protects head->requeue_list.  Keep the list
manipulation under that lock, but defer retargeting to nvme_requeue_work(),
which already drains the list from process context before resubmitting each
bio.  The bios remain private to the requeue list until the worker pops
them, so moving the device switch there preserves the existing retry flow
while avoiding a sleepable helper in completion context.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/nvme/host/multipath.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 9b9a657fa330..76baa180ae1c 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -149,7 +149,6 @@ void nvme_failover_req(struct request *req)
 	struct nvme_ns *ns = req->q->queuedata;
 	u16 status = nvme_req(req)->status & NVME_SCT_SC_MASK;
 	unsigned long flags;
-	struct bio *bio;
 
 	nvme_mpath_clear_current_path(ns);
 	atomic_long_inc(&ns->failover);
@@ -165,8 +164,6 @@ void nvme_failover_req(struct request *req)
 	}
 
 	spin_lock_irqsave(&ns->head->requeue_lock, flags);
-	for (bio = req->bio; bio; bio = bio->bi_next)
-		bio_set_dev(bio, ns->head->disk->part0);
 	blk_steal_bios(&ns->head->requeue_list, req);
 	spin_unlock_irqrestore(&ns->head->requeue_lock, flags);
 
@@ -684,6 +681,7 @@ static void nvme_requeue_work(struct work_struct *work)
 		next = bio->bi_next;
 		bio->bi_next = NULL;
 
+		bio_set_dev(bio, head->disk->part0);
 		submit_bio_noacct(bio);
 	}
 }
-- 
2.51.0

