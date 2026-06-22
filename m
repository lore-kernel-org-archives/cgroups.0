Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE5F363082;
	Mon, 22 Jun 2026 07:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782112457; cv=none; b=BLYXWfAwEJc9uI1EWkNLUhtYIXhr6zeebIV/qHnFx8dLa55FS+Z3YhKVJdC1OX+ugc+C0+mawCvYDa2uYUwYqFHx93Dq9FHKuiFdBCBUrPUiZXicg7C7nx67x17Ityw4ymMn0ATaT+sntkxHVhKi1k6RE/9h5qwot32nBGIwbkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782112457; c=relaxed/simple;
	bh=zc0mHaIb8J20hS18SLRxnEzEwY5WvhCW+hUuzn9Yaro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sd87W0SKDi0nhxxKqup2M8nND2ZumPKn3Q0KuOmNVe1UIms1IifjO2odE35cVXzRd1JyEXxorIY7GtlHSYGrWA33gC+RlqB7gxIHJkaNhYZ2VQor6aysaq7UTYJQfCf1IZrqc5c1fPMqCCCmdbmHbpD+M1FA+sSEBK8zQ4zumIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gkKD64VRTzKHMRc;
	Mon, 22 Jun 2026 15:13:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id B037C4057D;
	Mon, 22 Jun 2026 15:14:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with SMTP id cCh0CgB3eT694DhqGkK7Cg--.42632S5;
	Mon, 22 Jun 2026 15:14:06 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: axboe@kernel.dk,
	tj@kernel.org,
	josef@toxicpanda.com,
	linux-block@vger.kernel.org
Cc: cgroups@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	houtao1@huawei.com,
	yukuai@fygo.io,
	wozizhi@huaweicloud.com
Subject: [PATCH 1/2] blk-cgroup: fix blkg leak in blkg_create() error path
Date: Mon, 22 Jun 2026 15:07:12 +0800
Message-ID: <20260622070714.1158886-2-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260622070714.1158886-1-wozizhi@huaweicloud.com>
References: <20260622070714.1158886-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgB3eT694DhqGkK7Cg--.42632S5
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr47Xr13JrWkCrWrAFyDGFg_yoW8XF4xp3
	y3JrW5tryrKFnrCay3JF1UW34FyF4rJryrJ393Gw4akry7WF1SvF18Cr4UJFW7Ca9rJw15
	ZryYvFy0ka48C3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQv14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF54CYxVCY1x0262kKe7AK
	xVWUtVW8ZwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I
	0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAI
	cVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcV
	CF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUqkskUUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

When radix_tree_insert() fails in blkg_create(), the error path calls
blkg_put() to release the blkg. This was correct when blkg->refcnt was an
atomic_t: blkg_put() dropped it to 0 and triggered the release path.

But commit 7fcf2b033b84 ("blkcg: change blkg reference counting to use
percpu_ref") switched refcnt to a percpu_ref. In percpu mode
percpu_ref_put() never checks for zero, so the release callback is never
invoked. This blkg is on neither blkcg->blkg_list nor queue->blkg_list, so
blkg_destroy_all() / blkcg_destroy_blkgs() can never reach it to call
blkg_destroy()->percpu_ref_kill() either, cause the leak.

Fix it by killing the percpu_ref instead, which switches it to atomic mode
and drops the initial ref.

Fixes: 7fcf2b033b84 ("blkcg: change blkg reference counting to use percpu_ref")
Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bc63bd220865..6386fe413994 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -437,11 +437,11 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 
 	if (!ret)
 		return blkg;
 
 	/* @blkg failed fully initialized, use the usual release path */
-	blkg_put(blkg);
+	percpu_ref_kill(&blkg->refcnt);
 	return ERR_PTR(ret);
 
 err_put_css:
 	css_put(&blkcg->css);
 err_free_blkg:
-- 
2.52.0

