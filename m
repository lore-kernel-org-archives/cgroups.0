Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6ED3F54C3
	for <cgroups@vger.kernel.org>; Thu,  9 Jul 2026 10:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783591733; cv=none; b=pXrwiv9Orelyz4ugmhArivLk9p6LC4LE4SwOmwsZsiPTnVE9rcyn3VFLS9KXKJwTE8u19PkXoNtg3RsPKaWf7GXPUO8c4l7vFUfGR3mNZLI+LIToiwnisSXP564CM8gL8SFJsWkoHdXOOpd9Bx4vhpy52EohrskEFx3BH23DI4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783591733; c=relaxed/simple;
	bh=8Y8a558XU+yeUr5q6e4HBxwJmZ5LZ+XgJZHBJowpPs8=;
	h=Mime-Version:Content-Type:To:Subject:Date:Message-Id:In-Reply-To:
	 From:Cc:References; b=oxfGMzwSduehlVP2VgXskbZspx4SS7kCuCsrImICm171jRIt5A6J/WiMfY6Bz0EAhLm0bnCJM715sDjNMVDj6nV1vQQpt2AlUga/k83YCi6Z2XwxLAgPmD10P5ysYkaINa+EqYjx/G2WoFtx6S4YlKM047A7gLkDHJdp/G5VAHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=lmEr59L6; arc=none smtp.client-ip=209.127.231.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="lmEr59L6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783591722;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=nzPK7Q3qm+3tUE8Y8KFwnXjquoOkl/kUWyXBpYXUuB8=;
 b=lmEr59L6hyNDPoexltHX9iycAL/45pk6YoF3XWWsg6Wvx0rwSLZKorXPyguGonelmtu3sE
 2SFPEcoysIMDs3YXsZXF9DIQ7mta8Ukm1vDmj0+cGVbZRE0mBZyjMYpnUpuYXmV7XjRnUC
 eONZHfJJ+Ns3mhhCK59zJJWgCu4Vyjod1zKrlUG/b4BQLAUvG7c8X0yc+qTy2Fp/FYWYh/
 3Myivt1FYf4L5l67F5beixXxczc9s07jswbBqs/CkDlav9ZhKGzZdZaeKWcKxneIdsk0Kf
 auVcM8LVokNBtyNphHUMxjAcQdvowFH8U55ZQUNtxWRmykiEhEAtk2JT4XGIeQ==
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Thu, 09 Jul 2026 10:08:41 +0000
Content-Type: text/plain; charset=UTF-8
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
Subject: Re: [RFC PATCH v1 00/17] blk-cgroup: protect blkgs with blkcg_mutex
Date: Thu, 9 Jul 2026 18:08:36 +0800
Message-Id: <75bc21b5-9cc5-4d39-8ba3-7cf69689e438@fygo.io>
In-Reply-To: <20260709060959.GA16504@lst.de>
From: "yu kuai" <yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
Cc: "Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>, 
	"Keith Busch" <kbusch@kernel.org>, "Sagi Grimberg" <sagi@grimberg.me>, 
	"Alasdair Kergon" <agk@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, 
	"Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Dongsheng Yang" <dongsheng.yang@linux.dev>, 
	"Zheng Gu" <cengku@gmail.com>, "Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Josef Bacik" <josef@toxicpanda.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, <linux-block@vger.kernel.org>, 
	<cgroups@vger.kernel.org>, <linux-nvme@lists.infradead.org>, 
	<dm-devel@lists.linux.dev>, <linux-bcache@vger.kernel.org>
References: <20260704195124.1375075-1-yukuai@kernel.org> <20260709060959.GA16504@lst.de>
X-Lms-Return-Path: <lba+26a4f7329+7afd3c+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/7/9 14:09, Christoph Hellwig =E5=86=99=E9=81=93:
> On Sun, Jul 05, 2026 at 03:51:07AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> This RFC moves queue-local blkg topology synchronization from
>> q->queue_lock to q->blkcg_mutex.
>>
>> q->queue_lock is a hot block-layer spinlock used by request queue runtim=
e
>> paths,
> I don't think it is hot any more.  If it is in one of your workloads
> we have a deep problem somewhere.  That being said, futher removing
> uses of his old catch-all lock is always good, hopefully we can
> eventually remove it entirely.
>
> So this series looks great to me conceptually, but I'm unfortunately
> not a very qualified reviewer for the blk-cgroup code.

Thanks a lot for taking a look at this RFC set, it's very helpful.

It's true that blk-cgroup review is not active for a long time. I'd like to
help but I really don't have time to check every block layer patches.

>
--=20
Thanks,
Kuai
