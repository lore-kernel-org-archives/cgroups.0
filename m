Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.77
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343618;
	b=u8bndQJsH9KJcURiJ/jUqBw4NhvpCLSyu/1nNgZl57BPvM1XwL3AxlcUhx5DKogWGaD7
	 i5MFG3D/MwgE57QNviDh9GszB8P/81j689OhjlTYk3pYb6InVJa/4pKrJz6t+RwH82wyf
	 zRgOjScttLF0igT6AqRkJbrrMwpAFG/KtJk68dUTydY2/iVisDPH7Ge/cUrwmuJ6imsSd
	 +CMPvPVVshtXymldpHiScu1VBAXdUclVOwN0IW6zVJjCjYEW6svSw+j8awjwigLFmCrFG
	 yhDFaft1oGKLdyTnAeYi586Bds/KiZMnOntkz5uerj6yVhwb7vvumz5qR3e3CO0bWXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343618;
	h=DMARC-Filter:X-Alimail-AntiSpam:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=fgtgbqMxBK3o0mNT8b3UNZoB9xCVQE8JKhDZkyq/NkI=;
	b=39qAoy/5fFFrhrz5Sfjl9hAdIMNBbD6AttWlfiQyaSi4/LZRYZCqvghK41AGTaigqewl
	 ztbKLDj9efunuaTeCupm8kTMOLHBAX+iRrbnkrLfxy4sieTbRAxcyVTPMFWZtJH9KRLBE
	 7uwuOvzK+ciJ1RM6aFLCKy9feW+pgrO37RdBeUvV6nQcsherIGisJPe1G0QLtfODuVkCG
	 Qp3VRHWAqqH9uwAJ6J5HGgk7iXaPESR8XxpoIE0JJKZLjhiVWC1WkUv0uyFZH8fFeWE6F
	 hKWNnugpF25Lt7vkesE4LMy/8u6EwaS2sG3ZjQb9qKqubou0SwOM5ylkxpG91q5g9AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=open-hieco.net;
	spf=pass smtp.mailfrom=open-hieco.net;
	arc=none smtp.remote-ip=115.124.28.77
Received: from out28-77.mail.aliyun.com (out28-77.mail.aliyun.com [115.124.28.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2D1606A31E;
	Fri, 30 Oct 2026 07:00:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED2D1606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=open-hieco.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=open-hieco.net
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07960097|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00893295-0.000139809-0.990927;FP=9925747066805812598|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037034184;MF=likunyu@open-hieco.net;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.jstcwvx_1793343604;
Received: from localhost.localdomain(mailfrom:likunyu@open-hieco.net fp:SMTPD_---.jstcwvx_1793343604 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 30 Oct 2026 15:00:05 +0800
From: Li kunyu <likunyu@open-hieco.net>
To: axboe@kernel.dk,
	tj@kernel.org,
	josef@toxicpanda.com
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Li kunyu <likunyu@open-hieco.net>
Subject: [PATCH 0/2] block: Add done_split_bio() for chained bio post-processing
Date: Fri, 30 Oct 2026 14:59:43 +0800
Message-ID: <20261030065945.88742-1-likunyu@open-hieco.net>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[Problems encountered]

The split-out chained bio path has a QoS accounting issue. In a complete
chained bio composed of 10 bio headers and 1 sub-bio (produced by
repeatedly splitting a large block), only the first bio header among the
10 bio headers, the one that satisfies atomic_dec_and_test(&bio->
__bi_remaining) and the single sub-bio can execute rq_qos_done_bio(bio)
to update the QoS-related accounting.

This prevents other bio headers from updating QoS-related information
such as inflight counts. The inflight counts added in
rq_qos_throttle(rq->q, bio) are not subtracted, so the inflight count in
the bio's QoS area gradually increases. As a result, it can no longer be
used as a reference value.

Reproducible scenarios are detailed below(blk-iolatency):
1. fio is used to issue at least 1024 consecutive reads or writes, each 1MB
or larger, thereby exceeding the maximum single I/O size supported by the
hardware device.

2. The 'inflight' count described in the text is observed by printing
inflight = atomic_dec_return(&rqw->inflight); in blkcg_iolatency_done_bio.


[Implementation]

patch 1:  Introduce a new abstract function 'done_split_bio' and call it
from bio_remaining_done to resolve this issue.

patch 2: Implement the blkcg_iolatency_done_split_bio callback in
blk-iolatency to correctly decrement the inflight count when the other
bio headers, which have not called rq_qos_done_bio(bio), complete.


Li kunyu (2):
  block: Add done_split_bio() for chained bio post-processing
  block/blk-iolatency: Fix inflight decrement for chained bio sub-bios

 block/bio.c               |  2 ++
 block/blk-iolatency.c     | 42 +++++++++++++++++++++++++++++++++++++++
 block/blk-merge.c         |  4 +++-
 block/blk-rq-qos.c        |  9 +++++++++
 block/blk-rq-qos.h        | 23 +++++++++++++++++++++
 include/linux/blk_types.h |  6 ++++++
 6 files changed, 85 insertions(+), 1 deletion(-)

-- 
2.47.3

