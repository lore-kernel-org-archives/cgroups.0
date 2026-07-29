Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B75A442B0C
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 08:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785313716; cv=none; b=X0EaaClFOs489AbwWlIk6TNhmeQFlYBFbVJkZBASvIcvfMoaBd3YQJNLGwFMzRLAiNhgTQNYW6jNP+soz6vr3aKq1ZGvjM2ogH2pLwSd/ghPvPNepNowVnHI7waHGo/9IilX9zZnYxJNSudIKWrJ6Ksc3XjHZ7EuJYyZ1XkG0YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785313716; c=relaxed/simple;
	bh=8DaMrQkwSOLSYeVcgfkY+Hx0LSQoJH+0MZz/vGq60yo=;
	h=Content-Type:To:Cc:Subject:Date:Mime-Version:In-Reply-To:
	 Message-Id:References:From; b=lKSPi+7G4rZxYO4s07y4g8u8iwZKtz1x17cDLIuVDGUhOxTnP5r930VJtfCL9/ZjMUlg4V8GO1uQeGtXeRRqY8BLr8UZOgPAnPURogFDOoimQuhi7xe/5e0q8V3xjBUtwcVvk/plb8mNudbPphskeUcvx2vkBW5U2axtV5LR+yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=UKmrvVHf; arc=none smtp.client-ip=209.127.231.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="UKmrvVHf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785313695;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Ghe50mnkLmufIA92uEj2+BeiwIEyCvYnepEvsaqXqN0=;
 b=UKmrvVHfp0l0XvvMQNeEaztZ93Y5UMIwO4QXx/YxCRNGxoeULOCCjxW6PHDevdqyhdme2U
 IJSG7MFRQ0dWCyDN7AOeHRamqhNojIOUE5XJn7Eq2tX7X3lHWhFUO+vG87Xy7WWhxhvF8t
 YU+GgTZN7cZ0bToV2k6NTcXuU0DX3U4ERqnZMcAD73m37zxFDjAE1aQa5eMdp+WvZ9I4ql
 b2xzlbb5a6x67GBPvf1/DZ+Tud5X8RgwQH0QsTK+RnDckiE4oXN8BURJQlYuhUZf0V5fqN
 C0lAl/Cji+T83n8THM34/yMN7xK5lVtfaI3nPjOlhTbq4uDPL8T6ui18hXgnBg==
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
Cc: <axboe@kernel.dk>, <tj@kernel.org>, <dongsheng.yang@linux.dev>, 
	<cengku@gmail.com>, <josef@toxicpanda.com>, <nilay@linux.ibm.com>, 
	<ming.lei@redhat.com>, <linux-block@vger.kernel.org>, 
	<cgroups@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/8] block: associate blkg in submit_bio instead of bio_set_dev
Date: Wed, 29 Jul 2026 16:28:10 +0800
X-Lms-Return-Path: <lba+26a69b99e+696691+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.167]) by smtp.larksuite.com with ESMTPS; Wed, 29 Jul 2026 08:28:13 +0000
In-Reply-To: <20260728042313.GA19817@lst.de>
X-Original-From: yu kuai <yukuai@fygo.io>
Message-Id: <169a04be-2af6-4df3-9308-e2c0d5d4334a@fygo.io>
References: <20260724123037.3004560-1-yukuai@kernel.org> <20260724123037.3004560-2-yukuai@kernel.org> <933b4285-1c85-4076-831a-0501d5c38e16@fygo.io> <20260728042313.GA19817@lst.de>
From: "yu kuai" <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/7/28 12:23, Christoph Hellwig =E5=86=99=E9=81=93:
> On Mon, Jul 27, 2026 at 04:16:29PM +0800, yu kuai wrote:
>>> open-coded blkg_put().
>> Turns out bio will be submitted by kworker for some drivers and for
>> blkcg_punt_bio_submit(). Is it possible to record blkcg during bio initi=
alization,
>> as blkcg must exist, and then covert it to blkg during submission? I can=
 use union
>> for blkcg and blkg to avoid new field in struct bio.
> Mixing the two up sounds like a receipt for a lot of problems
> unfortunately.  I wonder if we could switch to only store the blkcg in
> the bio and look up the blkg as needed.  This assumes we can get away
> with a relatively small numbers of lookups for typical setups.  I'm not
> really sure how much the different users are combined - if not much this
> might actually be a big net benefit, if on the other hand we'd have to
> do a lot of separate lookups it might not work very well.

This sounds interesting, take a quick look, some places are using bi_blkg t=
o get blkcg and
this can be optimized, while other places are all related to blkcg policies=
. And I think
the blkg slow path radix tree lookup should be fine, because when we enable=
 blkcg policies,
it's expected performance should already be affected.

On the other hand, if no policies are enabled, looks like no blkg will be c=
reated, and this
will be beneficial as there should be many environments that blkcg policies=
 are not enabled.

The only problem I see is rq_qos_merge(), where bi_blkg is deference with e=
levator spinlock
held. However, I think this can be avoided as well, we can only do fast pat=
h blkg lookup, and
skip merge if blkg do not exist, as we only require same blkcg bio merge, t=
here is no IO to merge
if this bio is the first blkcg bio.

If you agree, I'll start to cook a new pre-set to convert bi_blkg to bi_blk=
cg, and then convert
queuelock to blkcg_mutex.

>
> This could be combined with a way to do more efficient blkg lookups
> using e.g. a rhashtable.
>
--=20
Thanks,
Kuai
