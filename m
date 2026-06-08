Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CE4337107
	for <cgroups@vger.kernel.org>; Mon,  8 Jun 2026 02:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780886917; cv=none; b=W2E2tq7UffRDEsahiYGxKKtKBpORaeWSSuN2q3fhhvom31bey2VZlpVOaYkJDOD3L0aa0tUTNUnNOodGtjDHzRFls+3h3wjtG+ITUodeIqeBYBqQAGLuvNakPBrO4h9VpIuC0ohkaCTruX2fVeIMUTgch/8cCqzQbWsnzGcrqfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780886917; c=relaxed/simple;
	bh=1ynSFMKb9ZvgL5PeJlWf1M/tDiJ1S5VVOIiJ2ag7HEs=;
	h=To:In-Reply-To:Message-Id:Mime-Version:References:Cc:From:Subject:
	 Date:Content-Type; b=TzUmjcIP38CIFuS1tiVp3pwkiax93LM6ClvFPBvogDGh/nijcK3XDBH5/SH9TeHkx8zBFn8nfzzDQz4DIsGS+6fd+rW8vVzpRHU2VZrXQNBYliqN7EVOdzNqjN2FeQsz0wA5/XP3FZhUq2i8rvhBrNeTJu+pS3NHzmqKX2kjY9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=G3eONcA3; arc=none smtp.client-ip=209.127.231.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="G3eONcA3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1780886899;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1ynSFMKb9ZvgL5PeJlWf1M/tDiJ1S5VVOIiJ2ag7HEs=;
 b=G3eONcA3Az/cEoTzYNOiNoGApr8XH479yvGxe/hY7rcwNRtRtRrhdMBb304iCbbRr2iOT8
 2eauYdSi7AItvlAlHBaTq0V8dcM64rdKJVaPB80RxggBOUeMYECrDMm8AYtCkScWdrcVFS
 8y2ODc0Ynf0kVP6P/gnor4Chb4M+PKqkODjm3pgRF8GYYduH6D5MCDBlrIgVeHb50p250s
 eKTzXQbaqFO8U0Iahp4L1NgmOqC32iJE1EPso+uQ5ndiursTz3xqGNiBefwj1ILDppaEV5
 8C9qAtIYoR6X5/npTnjnpcKjPxjYF5qOcxLUS1PETE5ZKbvpi7M39oP6zXcquw==
To: "Nilay Shroff" <nilay@linux.ibm.com>, "Jens Axboe" <axboe@kernel.dk>
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a262d73+b555d0+vger.kernel.org+yukuai@fygo.io>
In-Reply-To: <a532857a-16d5-4bef-bbd1-3bc080363182@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
Message-Id: <47c29e00-3781-4056-8874-e913ea28dd2a@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.146]) by smtp.larksuite.com with ESMTPS; Mon, 08 Jun 2026 02:48:18 +0000
References: <cover.1780492756.git.yukuai@fygo.io> <89f9448c5d703e6123e1be6c8e0550c803e9c057.1780492756.git.yukuai@fygo.io> <a532857a-16d5-4bef-bbd1-3bc080363182@linux.ibm.com>
Cc: "Tejun Heo" <tj@kernel.org>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Ming Lei" <tom.leiming@gmail.com>, 
	"Bart Van Assche" <bvanassche@acm.org>, <linux-block@vger.kernel.org>, 
	<cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH 2/5] bfq: protect q->blkg_list iteration in bfq_end_wr_async() with blkcg_mutex
Date: Mon, 8 Jun 2026 10:48:14 +0800
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/6/5 1:31, Nilay Shroff =E5=86=99=E9=81=93:
> On 6/3/26 6:57 PM, Yu Kuai wrote:
>> bfq_end_wr_async() iterates q->blkg_list while only holding bfqd->lock,
>> but not blkcg_mutex. This can race with blkg_free_workfn() that removes
>> blkgs from the list while holding blkcg_mutex.
>>
>> Add blkcg_mutex protection in bfq_end_wr() before taking bfqd->lock to
>> ensure proper synchronization when iterating q->blkg_list.
>>
>> Signed-off-by: Yu Kuai <yukuai@fygo.io>
>> ---
>> =C2=A0 block/bfq-cgroup.c=C2=A0 | 3 ++-
>> =C2=A0 block/bfq-iosched.c | 6 ++++++
>> =C2=A0 2 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
>> index 37ab70930c8d..f765e767d36a 100644
>> --- a/block/bfq-cgroup.c
>> +++ b/block/bfq-cgroup.c
>> @@ -939,11 +939,12 @@ void bfq_end_wr_async(struct bfq_data *bfqd)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct blkcg_gq *blkg;
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_for_each_entry(blkg, &bfqd->q=
ueue->blkg_list, q_node) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct bfq_group =
*bfqg =3D blkg_to_bfqg(blkg);
>> =C2=A0 -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bfq_end_wr_async_queu=
es(bfqd, bfqg);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (bfqg)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bfq_=
end_wr_async_queues(bfqd, bfqg);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bfq_end_wr_async_queues(bfqd, bfqd->root_=
group);
>> =C2=A0 }
>> =C2=A0 =C2=A0 static int bfq_io_show_weight_legacy(struct seq_file *sf, =
void *v)
>> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
>> index 141c602d5e85..42ccfd0c6140 100644
>> --- a/block/bfq-iosched.c
>> +++ b/block/bfq-iosched.c
>> @@ -2643,10 +2643,13 @@ void bfq_end_wr_async_queues(struct bfq_data=20
>> *bfqd,
>> =C2=A0 static void bfq_end_wr(struct bfq_data *bfqd)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct bfq_queue *bfqq;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int i;
>> =C2=A0 +#ifdef CONFIG_BFQ_GROUP_IOSCHED
>> +=C2=A0=C2=A0=C2=A0 mutex_lock(&bfqd->queue->blkcg_mutex);
>> +#endif
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irq(&bfqd->lock);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i =3D 0; i < bfqd->num_actuat=
ors; i++) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_for_each_ent=
ry(bfqq, &bfqd->active_list[i], bfqq_list)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 bfq_bfqq_end_wr(bfqq);
>> @@ -2654,10 +2657,13 @@ static void bfq_end_wr(struct bfq_data *bfqd)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 list_for_each_entry(bfqq, &bfqd->idle_lis=
t, bfqq_list)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bfq_bfqq_end_wr(b=
fqq);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bfq_end_wr_async(bfqd);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irq(&bfqd->lock);
>> +#ifdef CONFIG_BFQ_GROUP_IOSCHED
>> +=C2=A0=C2=A0=C2=A0 mutex_unlock(&bfqd->queue->blkcg_mutex);
>> +#endif
>> =C2=A0 }
>
> The above change protects the q->blkg_list iteration in=20
> bfq_end_wr_async()
> against list removal in blkg_free_workfn(). However the blkg insertion in
> blkg_create() still doesn't use q->blkcg_mutex and so list traversal in
> bfq_end_wr_async() may still race with blkg_create().
>
> So I think we may also need to protect blkg insert in blkg_create() using
> q->blkcg_mutex.

Yes, this is done in another huge patchset, because currently blkg_create()
is protected by queue_lock and can be called under rcu, code refactor will
be required.

I'll send the first set soon.

>
> Thanks,
> --Nilay

--=20
Thanks,
Kuai
