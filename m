Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6963947B8;
	Sun,  2 Aug 2026 11:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785671126; cv=none; b=ESZ6iNLjACMsFeDuFA8y0Qt7xXD0IbJqzC1GzE5OEJpnD28gAT3PU1SZT27lXnPIF+dn21gL+9VvuluKlFdcmTx60q2TutUqBVxqlvFgvTjOXmAGuIUhIfdHdOAQlO9XJX4/SbS/OmriHAj4T20o6ivi9vZUK9mEmy5eVOeuihg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785671126; c=relaxed/simple;
	bh=39A3E7wJo16khZLOY2hMQifeGyc+3LA8sx4hDyNyyrg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Q+58dT8A+Tu+10UEIP/OSw8Pvx2PmDDUPnF1ZT/cVFTXSJHbl9LdcTvOIgL0jPhwcn0NWEW77Ygp+Ng11r5GZxMgKSCA1Udz7EfP1hbZpvyBLTCQdgNDBKjku/fDmW9jHx5w+LHU/lK1so8OWx/+3MPwNDxXEAxDkaVtHvFQ19E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lFNPmjkM; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lFNPmjkM"
Date: Sun, 02 Aug 2026 19:45:10 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785671119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+mDW7WpHG3ulNmaHGNLiaJxDMfEUyA2HyZwUhZmNgAs=;
	b=lFNPmjkM8RufZnPTS9BrXnGW612+kF/ugKUnbVDMKxfcSFHIxgDtwBZom4T6OrtQGF81Z9
	gAz7RNM8zTGJInVpKRIrnPHymB0jLqUaSdmJiaUxyuKA/chB5g0TEwZGNc450mGCyV5Xo7
	kOQBibp/6mneUiQY+s4E5cHzvfFrcSk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
To: Yu Kuai <yukuai@kernel.org>, tj@kernel.org, axboe@kernel.dk
CC: cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhengqixing@huawei.com, hch@lst.de,
 yizhou.tang@shopee.com, yukuai@fygo.io, nilay@linux.ibm.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_1/4=5D_blk-cg?=
 =?US-ASCII?Q?roup=3A_protect_q-=3Eblkg=5Flis?=
 =?US-ASCII?Q?t_iteration_in_blkg=5Fdestroy=5Fall=28=29_with_blkcg=5Fmutex?=
In-Reply-To: <20260802112525.3933753-2-yukuai@kernel.org>
References: <20260802112525.3933753-1-yukuai@kernel.org> <20260802112525.3933753-2-yukuai@kernel.org>
Message-ID: <CAE3254D-EDFA-4465-B215-34C4B61D427C@linux.dev>
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



=E4=BA=8E 2026=E5=B9=B48=E6=9C=882=E6=97=A5 GMT+08:00 19:25:17=EF=BC=8CYu =
Kuai <yukuai@kernel=2Eorg> =E5=86=99=E9=81=93=EF=BC=9A
>From: Yu Kuai <yukuai@fygo=2Eio>
>
>blkg_destroy_all() iterates q->blkg_list without holding blkcg_mutex,
>which can race with blkg_free_workfn() that removes blkgs from the list
>while holding blkcg_mutex=2E
>
>Add blkcg_mutex protection around the q->blkg_list iteration to prevent
>potential list corruption or use-after-free issues=2E
>
>Reviewed-by: Tang Yizhou <yizhou=2Etang@shopee=2Ecom>
>Signed-off-by: Yu Kuai <yukuai@fygo=2Eio>
>---
> block/blk-cgroup=2Ec | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/block/blk-cgroup=2Ec b/block/blk-cgroup=2Ec
>index d9676126c5b5=2E=2Eeb0cfb10b859 100644
>--- a/block/blk-cgroup=2Ec
>+++ b/block/blk-cgroup=2Ec
>@@ -569,6 +569,7 @@ static void blkg_destroy_all(struct gendisk *disk)
> 	int i;
>=20
> restart:
>+	mutex_lock(&q->blkcg_mutex);
> 	spin_lock_irq(&q->queue_lock);
> 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
> 		struct blkcg *blkcg =3D blkg->blkcg;
>@@ -587,6 +588,7 @@ static void blkg_destroy_all(struct gendisk *disk)
> 		if (!(--count)) {
> 			count =3D BLKG_DESTROY_BATCH_SIZE;
> 			spin_unlock_irq(&q->queue_lock);
>+			mutex_unlock(&q->blkcg_mutex);
> 			cond_resched();
> 			goto restart;
> 		}
>@@ -606,6 +608,7 @@ static void blkg_destroy_all(struct gendisk *disk)
>=20
> 	q->root_blkg =3D NULL;
> 	spin_unlock_irq(&q->queue_lock);
>+	mutex_unlock(&q->blkcg_mutex);
>=20
> 	wake_up_var(&q->root_blkg);
> }
Reviewed-by: Tao Cui <cuitao@kylinos=2Ecn>
