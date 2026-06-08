Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6F334C9AF;
	Mon,  8 Jun 2026 03:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780890209; cv=none; b=QOj0ad4S7/Dg9Qodl5jQAmkyGh9qxeUiT1hJiBTvYPLLFu0ym38OdFiWOVI7oU6nSap+aC6mrLw/DCDVmiWPIndNhmVTZKwpKWNjl+P/nfiA+EV7a8tInwMktDykydDWYQi49AKff5D4iFDC2XIJRSy+0VdK8KR0wwJnEq7lL54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780890209; c=relaxed/simple;
	bh=9D5PJ3RqupKuJ6Bac8Auh17iIsRwMGcbxGQ2pVINhMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niHd2ceAXNcVE8lmWWmzWlSOoTrGx6LZyQrM/69gkEbQcUNB1/HFLBfdz/Wq0VnROlUnXY8TC6LrzrB2RRKAZ7TXtNZcMuljlgsMEfQ2ViX/oZOJTA31XNS2g75lLWSJPpQs5WD451BnKrCXD4lrjUTPIFjxkv0bfvdkBfL4f6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTPS5cu7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTPS5cu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27DE1F00893;
	Mon,  8 Jun 2026 03:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890208;
	bh=xbxrLUIuHStdHaKlhEhtpSuTr7xLq2M6g2rOrGI1zRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTPS5cu7VlzINgI3kKmHxHbbFQvryV9PycNA5wH3n8YHw1oTF6/2JHEKn3uCofyQy
	 waOb2600Hd8AYZFpZP/nPBIVZ2F0EkQ3P8HUWjb9Gm2iDAyCiZOE7Y+l2xyQt3ee34
	 CQUBignVLDwUjLOBcekxUuJxcBj7EsOTToYRg5hu1OJcnX7iW0IzFDBV/OfJHpAKMT
	 aY9ukY+NSF+yjMYDkMqrSL/FTHCIG3Hn2r0xGSrdNGU7isnnSDZKhGnYVhl7QNehKe
	 GdgIIW2RY7rk25dDZNXn4rUu3JGWYBKcKvc9tQ0ychxYj0msv769sHOtAeAJkQ+847
	 ViJzYOZgf0f3g==
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
Subject: [PATCH 7/8] mm/page_io: don't nest queue_lock under rcu in bio_associate_blkg_from_page()
Date: Mon,  8 Jun 2026 11:42:48 +0800
Message-ID: <c910d2c39d3ec97f67de68af636a52394342d55f.1780621988.git.yukuai@fygo.io>
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

Take a css reference under RCU, drop RCU, and then associate the bio with
the blkg. This avoids nesting queue_lock under RCU and prepares to protect
blkcg with blkcg_mutex instead of queue_lock.

Use css_tryget() instead of css_tryget_online() so swap writeback for
pages charged to a dying memcg still passes the dying css to
bio_associate_blkg_from_css(). That preserves the existing closest-live
ancestor fallback instead of charging those bios to the root blkg.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 mm/page_io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 70cea9e24d2f..3b54c60c278e 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -315,12 +315,17 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 		return;
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
 	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
-	bio_associate_blkg_from_css(bio, css);
+	if (!css || !css_tryget(css))
+		css = NULL;
 	rcu_read_unlock();
+
+	bio_associate_blkg_from_css(bio, css);
+	if (css)
+		css_put(css);
 }
 #else
 #define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
-- 
2.51.0
