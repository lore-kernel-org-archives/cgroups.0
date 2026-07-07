Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA7E357D10
	for <cgroups@vger.kernel.org>; Tue,  7 Jul 2026 12:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783429111; cv=none; b=iHldq9RP2syMsKXA0uiXuPMsG76owhQ0Jm874VGTgbZi6qGCt24lKi+H+u2GP5KXupp9LVExMJsBQye5pZgKxQgk7KUfwhn9WbRqWa6rZ+6LmcRk4RuLPRkkFfRXb2U2IyFe+Kgdk4GW8gSm39xgnVZk6mjyMUXtDEMAWMWn7b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783429111; c=relaxed/simple;
	bh=Avdmm5bCKj4UrKHrWWvOcEkT2IML9FcHGFEcZB+YUh8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q/w+Nx55QMC44/RsAxxQ7+QbeDV5JzX878qik93DyjdtLI81oBLsmpNJPtghe0HrkB2Giv0gPv8qeYWnDMw+1XcjbguVQHSvaLMNTHsYBIz+2VlIblWBmJU9+kS8cTYXgPhoe6IdvcK1rUyR8oFqGmCpBJUdLg6s4pDAzFYIZy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lyO+g6PR; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lyO+g6PR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783429107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HNN6uJyAAz0ItIHp6/ioUA/ZbJe1X+Q07YJqCR6OCdE=;
	b=lyO+g6PRlQDxDzStF6SI1LeCwufkepLhNzsYi90Ke0ATEp75EvURWSE1O4AFUnFBvPKzd8
	WLicb2oYfnxscuOoic04D17IgWwfquk+j24TRXa3p9XNTUPP1Uql3oAu97aQbkzQ/hP9a8
	ubuka1tQB1SHSzFFV+tv58tJdur2s38=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Yu Kuai <yukuai@fygo.io>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] blk-cgroup: clear blkg->pd[] with WRITE_ONCE() in blkcg_deactivate_policy()
Date: Tue,  7 Jul 2026 20:58:14 +0800
Message-ID: <20260707125814.1978139-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

blkcg_activate_policy() installs blkg->pd[] entries with WRITE_ONCE()
and also uses WRITE_ONCE() when clearing them on its error path.
blkg_to_pd() is used by RCU readers and reads the same array with
READ_ONCE().

blkcg_deactivate_policy() clears the entry with a plain store. Use
WRITE_ONCE() there as well.

Fixes: 56cc24f59c14 ("blk-cgroup: don't nest queue_lock under rcu in blkcg_print_blkgs()")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d2a1f5903f24..a1dd69f99f5c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1691,7 +1691,7 @@ void blkcg_deactivate_policy(struct gendisk *disk,
 			if (blkg->pd[pol->plid]->online && pol->pd_offline_fn)
 				pol->pd_offline_fn(blkg->pd[pol->plid]);
 			pol->pd_free_fn(blkg->pd[pol->plid]);
-			blkg->pd[pol->plid] = NULL;
+			WRITE_ONCE(blkg->pd[pol->plid], NULL);
 		}
 		spin_unlock(&blkcg->lock);
 	}
-- 
2.43.0

