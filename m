Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B93E3ABD91
	for <cgroups@vger.kernel.org>; Sun,  2 Aug 2026 11:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785671180; cv=none; b=Y36BaeRgASGVonSIAdgcjVBRaxi+Gs/x/3VY52c6LhYUdNAY8W7yWdnY9bQStvwTXZcY+mMRimDr/bW+6W69QjRat/8zwAJBQrDVn19qHIIAj1I6iyEmZHlobOAgf/srMqrwxDGiRQMrAI1jcHnMp0vHc0CoKSDxsWwPY1X+jyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785671180; c=relaxed/simple;
	bh=t38wVuoiGtgbn59TMohwxvhoYW7zK9wU8UZjIQJC+rM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=m35HXAMOyofG0YX8M5cy36Z2yh05AIruGcEUxhy7oKQCj5G2ptukjRGKD27H+PbV0B72YYDj0gjIJWJEB3j2m5S2V5qE4oNGwOlD0ndPlvGkVtkXvwUZOvAd9eqbfA2Ypzhv3DZNkWX0MC+t96lMOGaBTKe1YHABFiuyh5KxqQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kDVyxAH1; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kDVyxAH1"
Date: Sun, 02 Aug 2026 19:46:06 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785671173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zwYvsQ012YjhuP5+ODRBGrHe+6B4W/7aaK9lF2YwRcg=;
	b=kDVyxAH1oXxC0fZqcmXZegcg3XQenc0XUTfNFFGBDUWLMYQX/erYiqVlXzjJl3N/T7ML70
	3eGaF3mlqaU4OvdIKRbvmrgz6I1SB4hwAEtBvqEinZ3MPG3tAJT0CnPQXHOaJQJulGjQYx
	J4Puu7qowwQWqCHP4WYn6RMwl9fadco=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
To: Yu Kuai <yukuai@kernel.org>, tj@kernel.org, axboe@kernel.dk
CC: cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhengqixing@huawei.com, hch@lst.de,
 yizhou.tang@shopee.com, yukuai@fygo.io, nilay@linux.ibm.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_2/4=5D_blk-cgroup=3A_fix_race_bet?=
 =?US-ASCII?Q?ween_policy_activation_and_blkg_destruction?=
In-Reply-To: <20260802112525.3933753-3-yukuai@kernel.org>
References: <20260802112525.3933753-1-yukuai@kernel.org> <20260802112525.3933753-3-yukuai@kernel.org>
Message-ID: <491DAFBA-ADD6-4CA4-B0E4-87402A0BC64B@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

=E4=BA=8E 2026=E5=B9=B48=E6=9C=882=E6=97=A5 GMT+08:00 19:25:18=EF=BC=8CYu K=
uai <yukuai@kernel=2Eorg> =E5=86=99=E9=81=93=EF=BC=9A
>From: Zheng Qixing <zhengqixing@huawei=2Ecom>
>
>When switching an IO scheduler on a block device, blkcg_activate_policy()
>allocates blkg_policy_data (pd) for all blkgs attached to the queue=2E
>However, blkcg_activate_policy() may race with concurrent blkcg deletion,
>leading to use-after-free and memory leak issues=2E
>
>The use-after-free occurs in the following race:
>
>T1 (blkcg_activate_policy):
>  - Successfully allocates pd for blkg1 (loop0->queue, blkcgA)
>  - Fails to allocate pd for blkg2 (loop0->queue, blkcgB)
>  - Enters the enomem rollback path to release blkg1 resources
>
>T2 (blkcg deletion):
>  - blkcgA is deleted concurrently
>  - blkg1 is freed via blkg_free_workfn()
>  - blkg1->pd is freed
>
>T1 (continued):
>  - Rollback path accesses blkg1->pd->online after pd is freed
>  - Triggers use-after-free
>
>In addition, blkg_free_workfn() frees pd before removing the blkg from
>q->blkg_list=2E This allows blkcg_activate_policy() to allocate a new pd
>for a blkg that is being destroyed, leaving the newly allocated pd
>unreachable when the blkg is finally freed=2E
>
>Fix these races by extending blkcg_mutex coverage to serialize
>blkcg_activate_policy() rollback and blkg destruction, ensuring pd
>lifecycle is synchronized with blkg list visibility=2E
>
>Fixes: f1c006f1c685 ("blk-cgroup: synchronize pd_free_fn() from blkg_free=
_workfn() and blkcg_deactivate_policy()")
>Signed-off-by: Zheng Qixing <zhengqixing@huawei=2Ecom>
>Reviewed-by: Tang Yizhou <yizhou=2Etang@shopee=2Ecom>
>Signed-off-by: Yu Kuai <yukuai@fygo=2Eio>
>---
> block/blk-cgroup=2Ec | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/block/blk-cgroup=2Ec b/block/blk-cgroup=2Ec
>index eb0cfb10b859=2E=2E047bb42c282b 100644
>--- a/block/blk-cgroup=2Ec
>+++ b/block/blk-cgroup=2Ec
>@@ -1566,6 +1566,8 @@ int blkcg_activate_policy(struct gendisk *disk, con=
st struct blkcg_policy *pol)
>=20
> 	if (queue_is_mq(q))
> 		memflags =3D blk_mq_freeze_queue(q);
>+
>+	mutex_lock(&q->blkcg_mutex);
> retry:
> 	spin_lock_irq(&q->queue_lock);
>=20
>@@ -1628,6 +1630,7 @@ int blkcg_activate_policy(struct gendisk *disk, con=
st struct blkcg_policy *pol)
>=20
> 	spin_unlock_irq(&q->queue_lock);
> out:
>+	mutex_unlock(&q->blkcg_mutex);
> 	if (queue_is_mq(q))
> 		blk_mq_unfreeze_queue(q, memflags);
> 	if (pinned_blkg)
Reviewed-by: Tao Cui <cuitao@kylinos=2Ecn>

