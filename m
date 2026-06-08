Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCEF34CFB9;
	Mon,  8 Jun 2026 03:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780890200; cv=none; b=SZfpzUkp0P2HcWzZQnRvv1zErk6jkx4Y+3mxQ69LfzxUEkfNh1rGnA7YPFAYz2G+ZrrRbu12vt/0jro0pHRtPlxq8vMNn81gX0TwSUKdmXJeNgnfqhuNo2VD1MeJEGSFfsJwbSS/muwS8QKvp4x12X//tOdg06cVcmMJUyF4QKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780890200; c=relaxed/simple;
	bh=2bKznF2L7/t93XD7mtU61mUwsS+L2fk2ZnHKf23/UCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IomJUc080P8yyRZwVYTzBz5KqEHBFfEvIDcrpwCw8rWcdYzCtPSQR0Q9ke+gPftEB5KB3bugiAZHbDUU66diOGQphK3wGiejaGM0HGtvhVmMz+PIlNYMcAToZ32uzRjk3n/7JR8vSG5XphxETkSS8wvunR7hluxhvi2wRjGmGrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDGPIPI3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDGPIPI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746AB1F00893;
	Mon,  8 Jun 2026 03:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890199;
	bh=XwgOL7yvpTj5e2kxLuLeC19oCe8j+WMlaRhCcir6U04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDGPIPI3GjdPwnLL9bjwz5Ut16DAKbzD0MWWoYlfOPr1iX4p0iex98B6R8tY6cYXZ
	 sm/xc0jjukwVKIcd44R0eZa64PXHKlgMy/jGZKCxdA8bQsTgASJ5205uziCMyWd8dQ
	 Fkr8CfyyACcK0F5z451FQy26fZMS9IwoFs8VoEh0kuxoMslVc9r4NWtgSpFIcI87q7
	 brG88enB38rlb18Y92U/kTeZfBA3UJuhjS9Vw3l8qWa0JbZjqAdBEPNRP8XRMaHkBL
	 t8ss7c4DgHIjI93/bX8Yo4gkCt4qpuwdk5r18Y3CwR0bqVPIbYNRfNjcEo/zU0wUDK
	 K26gkMCakAKuA==
From: Yu Kuai <yukuai@kernel.org>
To: nilay@linux.ibm.com,
	tom.leiming@gmail.com,
	bvanassche@acm.org,
	tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	yukuai@fygo.io
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] blk-cgroup: don't nest queue_lock under rcu in bio_associate_blkg()
Date: Mon,  8 Jun 2026 11:42:46 +0800
Message-ID: <8496fa234b21d4b31b7f068766906d0bffcac8e6.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

If a bio is already associated with a blkg, the blkcg is already pinned
until the bio is done, so there is no need for RCU protection. Otherwise,
protect blkcg_css() with RCU independently. Prepare to protect blkcg with
blkcg_mutex instead of queue_lock.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index e2896d582235..8c9ca52a54f4 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2186,20 +2186,24 @@ void bio_associate_blkg(struct bio *bio)
 	struct cgroup_subsys_state *css;
 
 	if (blk_op_is_passthrough(bio->bi_opf))
 		return;
 
-	rcu_read_lock();
-
-	if (bio->bi_blkg)
+	if (bio->bi_blkg) {
 		css = bio_blkcg_css(bio);
-	else
+		bio_associate_blkg_from_css(bio, css);
+	} else {
+		rcu_read_lock();
 		css = blkcg_css();
+		if (!css_tryget_online(css))
+			css = NULL;
+		rcu_read_unlock();
 
-	bio_associate_blkg_from_css(bio, css);
-
-	rcu_read_unlock();
+		bio_associate_blkg_from_css(bio, css);
+		if (css)
+			css_put(css);
+	}
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg);
 
 /**
  * bio_clone_blkg_association - clone blkg association from src to dst bio
-- 
2.51.0
