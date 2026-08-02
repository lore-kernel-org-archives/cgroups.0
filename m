Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6B43644DE
	for <cgroups@vger.kernel.org>; Sun,  2 Aug 2026 11:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785671285; cv=none; b=eWHj+Dd9DEgnt5ZK+z5/2UKgh5Vx9dMNlexMPDGVGqzje7+KC8ML93Bnp3jPVio3oLeniKoAP8wnr4/hpS6qT87IeJcLGAZf0hr6xmR01zOHlkuuzmPzo4+rKUlH4lfWh7O055PPomwg2P0sO05VK7NTI8QmuwoxJFECpf9hwyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785671285; c=relaxed/simple;
	bh=lamWeViFHayGgbBOmssKq3rBTxlc1L0NT0QtTQpQ8E4=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=IzzHVYL4PhBsmcl9DEtH5ZecZFbBIuVjqdMQtn8pgqVOuZL7XcejECvEiN/XDLoMbcILG1rGy+gJmnOZqeVmHgTkXtShR/1l2v+YrlexqEbw3AUdWwgmU0iMcqlccWkhJmfM4qofj1IDzCiinoyM3UcRKb/YA9v74PPpqwIS51o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YlW/qsZR; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YlW/qsZR"
Date: Sun, 02 Aug 2026 19:47:45 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785671273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h6AVqGf5a94spcOyJ9dEXCY0YzvZOaYH5szAroQdsLw=;
	b=YlW/qsZRyrWSofJqrHb0nvADieHdIcpyfE3xGdDGj1ArEHM5DQkqvzb1ThvC21sLthlf75
	Lefe1AIYnSa4XGC8pAGNh/0+Aqsn88etbZUw/MHBxkOmxyBV4OYf66gkHvEgfbrBztlpux
	KlDjTAKf9fViIZ04eIpI2b0Hji0Omdo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
To: Yu Kuai <yukuai@kernel.org>, tj@kernel.org, axboe@kernel.dk
CC: cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhengqixing@huawei.com, hch@lst.de,
 yizhou.tang@shopee.com, yukuai@fygo.io, nilay@linux.ibm.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_3/4=5D_blk-cgroup=3A_skip_?=
 =?US-ASCII?Q?dying_blkg_in_blkcg=5Factivate=5Fpolicy=28=29?=
In-Reply-To: <20260802112525.3933753-4-yukuai@kernel.org>
References: <20260802112525.3933753-1-yukuai@kernel.org> <20260802112525.3933753-4-yukuai@kernel.org>
Message-ID: <BC1AFBE0-B768-4D54-B6F0-94D4263878B8@linux.dev>
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

=E4=BA=8E 2026=E5=B9=B48=E6=9C=882=E6=97=A5 GMT+08:00 19:25:19=EF=BC=8CYu K=
uai <yukuai@kernel=2Eorg> =E5=86=99=E9=81=93=EF=BC=9A
>From: Zheng Qixing <zhengqixing@huawei=2Ecom>
>
>When switching IO schedulers on a block device, blkcg_activate_policy()
>can race with concurrent blkcg deletion, leading to a use-after-free in
>rcu_accelerate_cbs=2E
>
>T1:                               T2:
>                                  blkg_destroy
>                                  kill(&blkg->refcnt) // blkg->refcnt=3D1=
->0
>                                  blkg_release // call_rcu(__blkg_release=
)
>                                  =2E=2E=2E
>                                  blkg_free_workfn
>                                  ->pd_free_fn(pd)
>elv_iosched_store
>elevator_switch
>=2E=2E=2E
>iterate blkg list
>blkg_get(blkg) // blkg->refcnt=3D0->1
>                                  list_del_init(&blkg->q_node)
>blkg_put(pinned_blkg) // blkg->refcnt=3D1->0
>blkg_release // call_rcu again
>rcu_accelerate_cbs // uaf
>
>Fix this by checking hlist_unhashed(&blkg->blkcg_node) before getting
>a reference to the blkg=2E This is the same check used in blkg_destroy()
>to detect if a blkg has already been destroyed=2E If the blkg is already
>unhashed, skip processing it since it's being destroyed=2E
>
>Fixes: f1c006f1c685 ("blk-cgroup: synchronize pd_free_fn() from blkg_free=
_workfn() and blkcg_deactivate_policy()")
>Signed-off-by: Zheng Qixing <zhengqixing@huawei=2Ecom>
>Reviewed-by: Tang Yizhou <yizhou=2Etang@shopee=2Ecom>
>Signed-off-by: Yu Kuai <yukuai@fygo=2Eio>
>---
> block/blk-cgroup=2Ec | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/block/blk-cgroup=2Ec b/block/blk-cgroup=2Ec
>index 047bb42c282b=2E=2Ed1895bc60fcf 100644
>--- a/block/blk-cgroup=2Ec
>+++ b/block/blk-cgroup=2Ec
>@@ -1577,6 +1577,8 @@ int blkcg_activate_policy(struct gendisk *disk, con=
st struct blkcg_policy *pol)
>=20
> 		if (blkg->pd[pol->plid])
> 			continue;
>+		if (hlist_unhashed(&blkg->blkcg_node))
>+			continue;
>=20
> 		/* If prealloc matches, use it; otherwise try GFP_NOWAIT */
> 		if (blkg =3D=3D pinned_blkg) {
Reviewed-by: Tao Cui <cuitao@kylinos=2Ecn>

