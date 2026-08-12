Received: from va-2-19.ptr.blmpb.com (va-2-19.ptr.blmpb.com [209.127.231.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E211E2C027C
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 01:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786498124; cv=none; b=e5RQxBxthnpTX3tQ26y1jLBGyJy9A99g+mzA+NlFW262oOXJ035TgA24isEGOEY5aZQvZPszJi3nMHmr5I5Qdjek6QK6TwJ8o6nZBG5+Ar4vyUfUhG/RvgXvBNivFP82JVd6KAVefyQMYVUWs+Zt3uFPlovpXe1jWAh4AEtZazo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786498124; c=relaxed/simple;
	bh=pI8NWKivLdNs4T9TIQzGfYzUHRLKNpkxaCgnJkaWReA=;
	h=Cc:From:Subject:Mime-Version:In-Reply-To:To:Message-Id:References:
	 Date:Content-Type; b=LYhbuOvJQnVI9PAih1XVJeiXvZKoLOVA722LiPB/KrbHF6qGs914lXvxsM81Vl4SH32cDpvvdxXa7gkK2V2V+84oUhjsaSP4pDVz055BsftEv/w/J7BOs2k2OT6ZmVQjDa+1QoaDyxiCCp75EfMaz5TTVlRTQxDPOwoha3HwRnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=GZ5+3e/N; arc=none smtp.client-ip=209.127.231.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="GZ5+3e/N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1786498112;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=js62KYIi4WGyt09W67v/lmLZ+mgT/5ejgsww9hjGIM4=;
 b=GZ5+3e/NKLTejFZQQHJkEUX4lAzoEm9vfHuUWo6HaAkVIHvgc+mlnFIQ60UD+rj1M6zEV+
 EuUsuvOq2rbjmyQELI71hMBu+jNKk9Ab6MxpTCK8LBUtWC6sCJWlEuSnKNfKWE9MUEGB67
 c68pP3cKnxAk+ddqktZuX6lp0xxv3++eFkg+gAqLyuSWvCLBVwWupbX0usuET0NvFIWcB7
 wbHYt25jG7YM/JHGOZV8ZVxOVKVVVDsq0ir/V5HeUlRuCP1kiOSe7gZzPChrilGvDdMMwc
 CRJpWRZigJJvNZsimFvk2z6a3urFDJokMTf6X+1QK/y/yXS1VNLl3tlLENg7LQ==
X-Lms-Return-Path: <lba+26a7bcc3f+f4b44d+vger.kernel.org+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.170]) by smtp.larksuite.com with ESMTPS; Wed, 12 Aug 2026 01:28:30 +0000
Cc: <cgroups@vger.kernel.org>, <linux-block@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, "Khazhy Kumykov" <khazhy@google.com>
From: "yu kuai" <yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Subject: Re: [PATCH] blk-cgroup: fix circular locking dependency in blkg_conf_prep
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260811204803.3770208-1-sudarsanm@google.com>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
To: "Sudarsan Mahendran" <sudarsanm@google.com>, "Tejun Heo" <tj@kernel.org>, 
	"Josef Bacik" <josef@toxicpanda.com>, "Jens Axboe" <axboe@kernel.dk>, 
	"yu kuai" <yukuai@fygo.io>
Message-Id: <8929741f-9d8d-471d-9519-d97a9b878b1f@fygo.io>
References: <20260811204803.3770208-1-sudarsanm@google.com>
Reply-To: yukuai@fygo.io
Date: Wed, 12 Aug 2026 09:28:26 +0800
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/8/12 4:48, Sudarsan Mahendran =E5=86=99=E9=81=93:
> In blkg_conf_prep, we may do IO when allocating while
> holding blkcg_mutex, however this presents a deadlock
> scenario since we may grab sysfs_lock while IO is
> suspended in elevator_exit, and an existing chain
> exists from sysfs_mutex -> blkcg_mutex.
>
> We can fix this by performing only GFP_NOIO allocations within
> blkg_conf_prep when blkcg_mutex is held.
> This patch fixes our reproducer.
>
> Full lockdep splat:
>
> [ 3795.003422] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [ 3795.009595] WARNING: possible circular locking dependency detected
> [ 3795.015773] 6.18.20-dbg-DEV #1 Tainted: G                 N
> [ 3795.021432] ------------------------------------------------------
> [ 3795.027604] kpython3/435194 is trying to acquire lock:
> [ 3795.032744] ffffffffa36959b8 (fs_reclaim){+.+.}-{0:0}, at: kmem_cache_=
alloc_noprof+0x49/0x5c0
> [ 3795.041260]
> [ 3795.041260] but task is already holding lock:
> [ 3795.047086] ffff98c8a06477b0 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkg_c=
onf_prep+0x71/0x5e0
> [ 3795.055257]
> [ 3795.055257] which lock already depends on the new lock.
> [ 3795.055257]
> [ 3795.063422]
> [ 3795.063422] the existing dependency chain (in reverse order) is:
> [ 3795.070893]
> [ 3795.070893] -> #4 (&q->blkcg_mutex){+.+.}-{4:4}:
> [ 3795.076986]        __mutex_lock+0x92/0xb70
> [ 3795.081085]        blkcg_deactivate_policy+0x7f/0x230
> [ 3795.086137]        bfq_exit_queue+0xe1/0x110
> [ 3795.090401]        blk_mq_exit_sched+0xd1/0x170
> [ 3795.094935]        elevator_exit+0x50/0x70
> (...)
> [ 3795.135019]
> [ 3795.135019] -> #3 (&eq->sysfs_lock){+.+.}-{4:4}:
> [ 3795.141110]        __mutex_lock+0x92/0xb70
> [ 3795.145211]        elevator_exit+0x45/0x70
> [ 3795.149308]        elevator_switch+0x98/0x290
> [ 3795.153660]        elevator_change+0x109/0x190
> [ 3795.158106]        elv_iosched_store+0x198/0x240
> (...)
> [ 3795.185276]
> [ 3795.185276] -> #2 (&q->elevator_lock){+.+.}-{4:4}:
> [ 3795.191541]        __mutex_lock+0x92/0xb70
> [ 3795.195642]        elevator_change+0xb6/0x190
> [ 3795.200001]        elv_iosched_store+0x198/0x240
> (...)
> [ 3795.227179]
> [ 3795.227179] -> #1 (&q->q_usage_counter(io)#19){++++}-{0:0}:
> [ 3795.234224]        blk_alloc_queue+0x33e/0x370
> (...)
> [ 3795.266621]
> [ 3795.266621] -> #0 (fs_reclaim){+.+.}-{0:0}:
> [ 3795.272280]        __lock_acquire+0x157c/0x2980
> [ 3795.276813]        lock_acquire+0xd3/0x2a0
> [ 3795.280904]        fs_reclaim_acquire+0x55/0xc0
> [ 3795.285435]        kmem_cache_alloc_noprof+0x49/0x5c0
> [ 3795.290481]        __radix_tree_preload+0xef/0x250
> [ 3795.295273]        blkg_conf_prep+0x2aa/0x5e0
> [ 3795.299633]        tg_set_conf+0xa5/0x1a0
> (...)
> [ 3795.330808]
> [ 3795.330808] other info that might help us debug this:
> [ 3795.330808]
> [ 3795.338806] Chain exists of:
> [ 3795.338806]   fs_reclaim --> &eq->sysfs_lock --> &q->blkcg_mutex
> [ 3795.338806]
> [ 3795.349146]  Possible unsafe locking scenario:
> [ 3795.349146]
> [ 3795.355057]        CPU0                    CPU1
> [ 3795.359590]        ----                    ----
> [ 3795.364121]   lock(&q->blkcg_mutex);
> [ 3795.367691]                                lock(&eq->sysfs_lock);
> [ 3795.373776]                                lock(&q->blkcg_mutex);
> [ 3795.379862]   lock(fs_reclaim);
> [ 3795.383006]
> [ 3795.383006]  *** DEADLOCK ***
>
> Reviewed-by: Khazhy Kumykov <khazhy@google.com>
> Signed-off-by: Sudarsan Mahendran <sudarsanm@google.com>
> ---
>   block/blk-cgroup.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index d9676126c5b5..b981a80bbd94 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -867,7 +867,6 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct =
blkcg_policy *pol,
>   			parent =3D blkcg_parent(parent);
>   		}
>  =20
> -		/* Drop locks to do new blkg allocation with GFP_KERNEL. */
>   		spin_unlock_irq(&q->queue_lock);
>  =20
>   		new_blkg =3D blkg_alloc(pos, disk, GFP_NOIO);
> @@ -876,7 +875,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct =
blkcg_policy *pol,
>   			goto fail_exit;
>   		}
>  =20
> -		if (radix_tree_preload(GFP_KERNEL)) {
> +		if (radix_tree_preload(GFP_NOIO)) {

Thanks for the patch, however, there is a pending patchset that this radix_=
tree_preload will be removed,
I think which is a better solution:

[RFC PATCH v2 2/4] blk-cgroup: use a request_queue rhashtable for blkg=20
lookup - Yu Kuai <https://lore.kernel.org/all/20260811064744.1139446-3-yuku=
ai@kernel.org/>

>   			blkg_free(new_blkg);
>   			ret =3D -ENOMEM;
>   			goto fail_exit;

--=20
Thanks,
Kuai
