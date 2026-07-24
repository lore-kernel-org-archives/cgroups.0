Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB903E49E0;
	Fri, 24 Jul 2026 12:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784896295; cv=none; b=gjGcrUn4ftQdJfhu0JQyzEzfFgL5lp3cL0nDySzAPzHvD4+Dv/mZKRMXQ+drIdR7JOb0aoLCYei9flj65zUGGUPd27xPbOklajLH6GKsrTumMFGjMqQcN2JhxxQCMNiLof1jXb8tCULwhGlEHwKYJsHaMDK6Y9GaPCK/q323VRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784896295; c=relaxed/simple;
	bh=BMW0QfzcRMmUjYrNtcl7WwKHP0F1JIkqZWAYN7YMDkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alCOn8v+22mrMAPo6OFuzVs1L0w1zeVkhKf4wYa7oCEFBXwAVlpLPcpSvmOBzGCBlicY6jNv64ATc9p22EaomeQXVRDHECuTt2xTLmQvsUKyJH7gq+ER6GHX5vgZhq78AthF2/zU71w838splzPyrFE18XrTLwpKXVEgK77FmF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SHyjU+cS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHyjU+cS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8045B1F00A3A;
	Fri, 24 Jul 2026 12:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784896294;
	bh=TeVxdp+dhP2ywFrM70Qpt0zHUXHUVp5H4bPOyercBz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHyjU+cShIbvx4fKibUSaT2bBS8q5pPUXPQ0B7UxQ1gQCqbtyNnk7Md1uqu8Q2W3W
	 rhmSoDcQjyRKT5A/gfHnTkNy8DLrzksjBT8qLGIAD1mAjd93aZucQ7E95rqXi5D/rV
	 gevys93wRfZFYHr5ZDs9lhAVTsergXWYWZnwQy78ftVA91Yc7lF2eK3bkuNFaPWbNA
	 jAvLdC1/FG9pGqcs4M+DaonYcWMlOJPwxEijLfelGj3gXhoXFMmemaeleB3uJPv2Lm
	 qyvkPh+zkHRyIppSmRbzFD6vnOTPDecWNEcVEw9+uv0H4B5e0/p59hYQIPvs/gh7hQ
	 baSNX9eQCLMoA==
From: Yu Kuai <yukuai@kernel.org>
To: axboe@kernel.dk,
	tj@kernel.org
Cc: hch@lst.de,
	dongsheng.yang@linux.dev,
	cengku@gmail.com,
	josef@toxicpanda.com,
	nilay@linux.ibm.com,
	ming.lei@redhat.com,
	yukuai@fygo.io,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 7/8] bfq: avoid blkg lookup from locked cgroup update
Date: Fri, 24 Jul 2026 20:30:36 +0800
Message-ID: <20260724123037.3004560-8-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260724123037.3004560-1-yukuai@kernel.org>
References: <20260724123037.3004560-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

bfq_bio_bfqg() is called while bfqd->lock is held from the merge and
request insertion paths.  It walks bio->bi_blkg and its parent chain to
find the closest online BFQ group, and re-associates the bio by looking
the chosen blkg up again through bio_associate_blkg_from_css().

Now that blkg creation runs under q->blkcg_mutex from the sleepable submit
path, bio_associate_blkg_from_css() can sleep on a lookup miss, which BFQ
must not do while holding bfqd->lock.  The blkg BFQ wants is already in
hand from the ancestry walk, so update bio->bi_blkg by swapping references
to that existing blkg directly instead of looking it up again by css.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/bfq-cgroup.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 42614aa78cd4..8a3ff9510386 100644
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
@@ -616,13 +626,13 @@ struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 		}
 		bfqg = blkg_to_bfqg(blkg);
 		if (bfqg->pd.online) {
-			bio_associate_blkg_from_css(bio, &blkg->blkcg->css);
+			bfq_bio_update_blkg(bio, blkg);
 			return bfqg;
 		}
 		blkg = blkg->parent;
 	}
-	bio_associate_blkg_from_css(bio,
-				&bfqg_to_blkg(bfqd->root_group)->blkcg->css);
+	blkg = bfqg_to_blkg(bfqd->root_group);
+	bfq_bio_update_blkg(bio, blkg);
 	return bfqd->root_group;
 }
 
-- 
2.51.0

