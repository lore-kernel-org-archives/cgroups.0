Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DE942BE93
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 11:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786447006; cv=none; b=P9E8WgQf8DFaJjrLHV/nCrrOr6B4bfVArsFCERfRvuLgVGDhdVIkWELl13ixkx/HMRZ5E3Xw0gQU7Ev9LWHthX/LqeCdYGnrnA6ZptNJ/ecC7rqJSXFhIfBeQSO0czAskM5qRbzABM46No/j0PRBFjQBmPp5t0HXoWN66Iwl2a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786447006; c=relaxed/simple;
	bh=vvGtubF+LHzhsPrhCzpSkyEkBg0wKIJwF5S46WmPDa8=;
	h=Cc:Date:Mime-Version:Content-Type:References:From:Subject:
	 Message-Id:In-Reply-To:To; b=DT4sIj6guPFFCLaDZhjDS56hC9itnBkuj2YpHHRGYtQQw6yBXXvtQFJDGckSzgYYRASLNW+5stmGPZvDOn0Y96mRfvuDXToydlx9KOPmcXqpNB3istwvyF+ELpLIDwovJTfUUuObOEdmBpSeUIYh2HxGjraRi2moLTe0c5uRLx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=nW7pG0Tr; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="nW7pG0Tr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1786446882;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=4wQVN/c3V/3ItnNofRy0nhlREIYYvh6hcQ0qbtXwUO0=;
 b=nW7pG0Trn1vodSzur+vxayHyEW+H0EEldfDBwJnSUauEFdsLp6Hxp99FokFyhDSc7JcTqr
 tKTIw8pJAsyajDPRGao4dnar7WLj1pwdFQpGggftXxkpYMGs8863Nli6UzU/BWZtyldkKe
 rT11PV/z6Vl8oGtY8FFHkkKJYHPVfNoI7zrJVqOqb1IHoxbicIb+1yq4JbeSQvBrAQg6Ir
 CegPDEtwBB0wguVoPG15yQnVJZPAV1c+zeVSAurCLuUG6NCcRJei4LtlqLHbePNYrMYsR3
 et5zC92KEM3Rour3JnuxeVf9h6fMSSjIDeRH3fhWIzlaKkWjTwjw2ahhsZCSsg==
Received: from [192.168.1.104] ([39.182.0.170]) by smtp.feishu.cn with ESMTPS; Tue, 11 Aug 2026 19:14:40 +0800
Cc: "Ming Lei" <ming.lei@redhat.com>, "Christoph Hellwig" <hch@lst.de>, 
	"Yi Zhang" <yi.zhang@redhat.com>, <cgroups@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>
Date: Tue, 11 Aug 2026 19:14:37 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <20260811110421.50747-1-kmehltretter@gmail.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH] blk-cgroup: fix lost wakeup in blkg_destroy_all()
Message-Id: <0898e560-73a8-4f1e-af13-65042cec0c7d@fnnas.com>
X-Lms-Return-Path: <lba+26a7b0420+419c9e+vger.kernel.org+yukuai@fnnas.com>
In-Reply-To: <20260811110421.50747-1-kmehltretter@gmail.com>
Reply-To: yukuai@fygo.io
To: "Karl Mehltretter" <kmehltretter@gmail.com>, "Tejun Heo" <tj@kernel.org>, 
	"Josef Bacik" <josef@toxicpanda.com>, "Jens Axboe" <axboe@kernel.dk>, 
	"yu kuai" <yukuai@fygo.io>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/8/11 19:04, Karl Mehltretter =E5=86=99=E9=81=93:
> wake_up_var() requires a full barrier between making the wait condition
> true and its lockless waitqueue check. spin_unlock_irq() has only
> release semantics, so it does not order q->root_blkg =3D NULL against
> that check.
>
> During disk rebind, blkcg_init_disk() can therefore miss the wakeup and
> sleep indefinitely. Add the required smp_mb(). Also mark the store with
> WRITE_ONCE() since the waiter reads root_blkg locklessly with
> READ_ONCE(). An LKMM model permits the missed-wakeup outcome without
> the barrier and forbids it with the barrier.
>
> Fixes: 3dbaacf6ab68 ("blk-cgroup: wait for blkcg cleanup before initializ=
ing new disk")

Looks like this will be fixed by following patch as well:

[RFC PATCH v2 1/4] blk-cgroup: wait for old blkgs to leave queue before=20
disk rebind - Yu Kuai=20
<https://lore.kernel.org/all/20260811064744.1139446-2-yukuai@kernel.org/>

> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
> LKMM (herdtools7 7.58), with the store modeled by WRITE_ONCE(). flag
> is q->root_blkg (1 =3D set), lk the queue_lock, wq the var waitqueue
> occupancy. To model the fixed code, insert smp_mb() in P0 between
> smp_store_release(lk, 0) and READ_ONCE(*wq):
>
>    C blkcg-rebind-buggy
>    { flag=3D1; }
>    P0(int *flag, int *lk, int *wq)
>    {
>    	int r0;
>    	WRITE_ONCE(*flag, 0);
>    	smp_store_release(lk, 0);
>    	r0 =3D READ_ONCE(*wq);
>    }
>    P1(int *flag, int *lk, int *wq)
>    {
>    	int r1;
>    	WRITE_ONCE(*wq, 1);
>    	smp_mb();
>    	r1 =3D READ_ONCE(*flag);
>    }
>    exists (0:r0=3D0 /\ 1:r1=3D1)
>
>    herd7 -conf linux-kernel.cfg blkcg-rebind-buggy.litmus
>
>    without smp_mb(): Sometimes
>    with smp_mb():    Never
>
>   block/blk-cgroup.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index d9676126c5b5d..2b3cf9caeaa31 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -604,9 +604,11 @@ static void blkg_destroy_all(struct gendisk *disk)
>   			__clear_bit(pol->plid, q->blkcg_pols);
>   	}
>
> -	q->root_blkg =3D NULL;
> +	WRITE_ONCE(q->root_blkg, NULL);
>   	spin_unlock_irq(&q->queue_lock);
>
> +	/* Order q->root_blkg store before wake_up_var()'s waitqueue check */
> +	smp_mb();
>   	wake_up_var(&q->root_blkg);
>   }
>
> --
> 2.53.0
>
--=20
Thanks,
Kuai
