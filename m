Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C906131AF07;
	Sat,  4 Jul 2026 19:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783194854; cv=none; b=oCmRQq+iB5FaGjPy13n8hR7LgYFBEuZ/OSytK3i3M7Uj6WYfPsBRt8pIWX3wRZH4Y0l9FDZef17IgOmC5Vbfzq+WQVEUwTBarN4sJjpVl37L33uC/w8OmnHpwG8gGWiD7SNtdPT5qBO52yFM1PWF+ByxGjrrBUwUm3mNtBNPUwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783194854; c=relaxed/simple;
	bh=CsEJb37XQC2vAwK9cmANwXh3CNhCa0hNgC22Npt5TAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvC+j8X+DW1oTe/5jfx/YCL21tIySHfQfN8GGsDEfVERkpKnpY+jnMd1BsN6twBOFucTMzgur88OFxTFl1GRDDWsVl9zK9aNiADpLiPqZ3B95rGl0LKYdln7CKaH0E1WgdtrdlOq/T+Fn9qC3XQUdggT51DlusMrocfIhYaVGpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/wBVWgw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/wBVWgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10431F000E9;
	Sat,  4 Jul 2026 19:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783194853;
	bh=0km6a0VXEo0Vmk+SqkA3SPojQd2Ywn1h/MoUubxrqCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/wBVWgwL19E+QcaB+mep9VaSMkiERMX5Ma/Hf1iIo+RKJkjFV/v2LhlMDowdrwXF
	 4n4EERyJ/LLBE2CDuL4vJ+hsorhRXmo1QT8vw6dXLjR+PU7eIxPRi/w56ugdtHB3or
	 HRVVNX2wORrOQMJBKuXTtdGJsfADpeZOAop6eHwNyqNHU3sXSEv9lyPZviRIk6A1Vx
	 lS9a+Dqq2oIwxCn27ZIpwW+++XpUfwmiLsawTpJWroR6Y16G2AvqxjFqd1EomThPZv
	 YfJ6Rg4/BBknq+oJYmbVTQGNUv6JCfNezd/ZXNx3o0svUuCTNpxpTbnj7da8NY8sZX
	 TYoTKaCMdCZIg==
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
Subject: [RFC PATCH v1 13/17] bfq: avoid blkg lookup from locked cgroup update
Date: Sun,  5 Jul 2026 03:51:20 +0800
Message-ID: <20260704195124.1375075-14-yukuai@kernel.org>
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

bfq_bio_bfqg() is called while bfqd->lock is held from the merge and
request insertion paths. It walks bio->bi_blkg and its parent chain to
find the closest online BFQ group, and also updates bio->bi_blkg when
the original association points at an offline or otherwise unusable
blkg.

After missing blkg creation is protected by q->blkcg_mutex,
bio_associate_blkg_from_css() can sleep on lookup misses. BFQ must not
call it while holding bfqd->lock. The blkg BFQ wants is already known
from the existing bio->bi_blkg ancestry walk, so update bio->bi_blkg by
swapping references to that existing blkg directly instead of looking it
up again by css.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/bfq-cgroup.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 5c2faf56c8ef..06c4ec6d5e35 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -604,6 +604,16 @@ static void bfq_link_bfqg(struct bfq_data *bfqd, struct bfq_group *bfqg)
 	}
 }
 
+static void bfq_bio_update_blkg(struct bio *bio, struct blkcg_gq *blkg)
+{
+	if (bio->bi_blkg == blkg)
+		return;
+
+	blkg_get(blkg);
+	blkg_put(bio->bi_blkg);
+	bio->bi_blkg = blkg;
+}
+
 struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 {
 	struct blkcg_gq *blkg = bio->bi_blkg;
@@ -616,14 +626,13 @@ struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 		}
 		bfqg = blkg_to_bfqg(blkg);
 		if (bfqg->pd.online) {
-			bio_associate_blkg_from_css(bio, &blkg->blkcg->css, false);
+			bfq_bio_update_blkg(bio, blkg);
 			return bfqg;
 		}
 		blkg = blkg->parent;
 	}
-	bio_associate_blkg_from_css(bio,
-				&bfqg_to_blkg(bfqd->root_group)->blkcg->css,
-				false);
+	blkg = bfqg_to_blkg(bfqd->root_group);
+	bfq_bio_update_blkg(bio, blkg);
 	return bfqd->root_group;
 }
 
-- 
2.51.0

