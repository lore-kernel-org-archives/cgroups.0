Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268697;
	b=AzHaQ9Ml5coWfGaKVFZYwig0LnU6NtIqhhEnXkMULAvwkqz0nqhHM+LKWFJIK78zPUR+
	 56jMLCuD9xlgivgfLL/c1fz9ZJeV0vWxHRq+GywyaI8BBE1D4ZysR61CFBRfHr4g8a8o6
	 1A1OgAFE0mWuW+4KKOxjI5HBNEGUT6rUpDEoKwaWrfX1VXsSnzKRXJv/p8RGK4gjIAZGH
	 GN5DCMBNRm5zwRy1t35jecg4OcMIwWmieUNBbVuBkXYouCvrUmXlYxD4wf2tzPKDJsmUo
	 7jA1u7KlYkk2OdujqFK1fptConPDk0y+tZHy5AcdYmah207Y7Mzz37jY99K8AKUcm1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268697;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FAoeFjOhHMIomvSZEyPcUceFOZEousEjiVEkUk7cB2Y=;
	b=XQ2u6Nf96uYvp7ZKR1v3iABenTLJEOfgDuGc6YxZorpd7Ion2JaU9ZHg9wM0V1Ofm31X
	 WoFrc8zfV+0ogGdSz9sEEq9CE+t9e/E4fVOa7fIkS3dmOw5QziS5MrHKuMs65ZnJUxBHk
	 qLxrJPajUSxujf+G3xYOHRFizuJVkYcWpCRtFt3c0TqHqbYEBDXWBluWi/0RuBjH+Qhrf
	 HO/YZ+t8O1Y+kF3oFqfTeiZLZGGbFbnrgJG6DT8gm0pVIPDMLulk35BX3FugrQaBk0vH5
	 5rj+sAfJ7PZO1KrMYJE8QD72uKV0u9zzXHwDUWvj5tQeMXm05qrfS+B5SHtGHrxS5Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZeoDW+IX;
	arc=none smtp.remote-ip=91.218.175.148
Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7ED606A31D
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 10:11:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF7ED606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZeoDW+IX
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=O6pECeJaIkk7IfSov1GVY8i4R6cQbSZNmIkkj1P7D6Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793268694; v=1; x=1793873494;
 b=ZeoDW+IX8pJ0xoQ4rjQaOdRjv3XntVFyg1mljQ462gjJ8QtHberIy8I3vN25HJSYU3X+jRU5
 riZGSX3aklA63YpJ1ez6SWmybO1uIcDLwx48LUChThpcH1hdcBGof0khT+0ucFuokpWFGrkkr9F
 pCQRBFS7YYyAih+hEKv4I2LQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 73988b42a70c48c5;
	Thu, 29 Oct 2026 10:11:34 +0000
X-Mizu-Trace-ID: 73988b42a70c48c5
X-Migadu-Flow: FLOW_OUT
Message-ID: <895cb52c-1542-4ff7-abaf-844a73126fa8@linux.dev>
Date: Thu, 29 Oct 2026 18:11:25 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [PATCH 2/5] blk-iocost: add BPF struct_ops cost model support
To: Tejun Heo <tj@kernel.org>
References: <20261028143534.135968-1-cui.tao@linux.dev>
 <20261028143534.135968-3-cui.tao@linux.dev>
 <0753eaa990c954aa56a0c5fa8ba302e2@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <0753eaa990c954aa56a0c5fa8ba302e2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Tejun,

在 2026/10/29 04:09, Tejun Heo 写道:
> Hello, Tao.
> 
> On Wed, Oct 28, 2026 at 10:35:31PM +0800, Tao Cui wrote:
>> +/*
>> +/*
>> + * Deliver iocg_init()/iocg_free() to the cgroups already online on the
> 
> The comment opens with "/*" twice. clang warns "'/*' within block comment
> [-Wcomment]" and CONFIG_WERROR builds break.
> 
A stray line was left over from an earlier edit. Sorry about that.
>> +			/*
>> +			 * A blkg which never went online never reached the
>> +			 * radix tree, so it must not receive an init either;
>> ...
>> +			if (!iocg || !iocg->pd.online)
>> +				continue;
> 
> blkg_create() adds a blkg to q->blkg_list only after radix_tree_insert()
> succeeds, so the blkgs skipped here are the ones blkg_destroy() already
> took offline, not ones that never reached the radix tree.
> 
You're right, the comment described the wrong blkgs. It goes away with
the walk, which I'll drop in v12 together with the callbacks.

>> +	if (!disk_live(disk)) {
>> +		mutex_unlock(&q->rq_qos_mutex);
>> +		blk_mq_unfreeze_queue(q, memflags);
>> +		blkdev_put_no_open(bdev);
>> +		return -ENODEV;
>> +	}
> 
> The guard() suggestion from v10 was only partly applied. This unlock,
> unfreeze and put sequence is repeated on three error paths.
> 
I'll fold the reg error path into a single out label. Detach no longer
needs the freeze after the v12 rework.

>> +	/*
>> +	 * Scope the mutex so the tail bdev put runs with blkcg_mutex
>> +	 * already released: dropping the last device reference can
>> +	 * reach disk_release() -> blkcg_exit_disk() ->
>> +	 * blkg_destroy_all(), which takes q->blkcg_mutex.
>> +	 */
>> +	{
>> +		guard(mutex)(&q->blkcg_mutex);
> 
> The bare { } block isn't necessary, and ioc_bpf_detach() has the same
> block with the same comment. Can you drop them?
> 
I'll drop both.
>> +	/*
>> +	 * The attachment is checked under rq_qos_mutex first, so an unmatched
>> +	 * detach exits without freezing.
>> +	 */
>> +	mutex_lock(&q->rq_qos_mutex);
>> +	spin_lock_irq(&q->queue_lock);
>> +	ioc = q_to_ioc(q);
>> +	if (ioc) {
>> +		spin_lock(&ioc->lock);
>> +		matched = ioc_attached_model_locked(ioc) == ops &&
>> +			  ioc->bpf_link == link;
>> ...
> 
> The same 11 lines check the attachment again after the freeze. The check
> under rq_qos_mutex after the freeze is the one that matters.
> 
This goes away with the freeze removal: detach becomes a single
mutex-critical section.
>> +/*
>> + * Pluggable cost model interface for blk-iocost.
>> + *
>> + * A BPF struct_ops implementation can take over the cost model of one device.
>> ...
>> + * offline and its free. Both callbacks are called with ioc->lock held and must
>> + * not sleep; the delivery points nest inside queue_lock except for iocg_free()
>> + * from ioc_pd_free() in blkg_free_workfn().
>> + */
> 
> This restates the attach mechanics and lists the call sites. The comments
> and descriptions in general are still long and narrate mechanics.
> 
v12 folds everything back into blk-iocost.c, so the private header and
the long interface comment both go away.

Thanks,
Tao

> Thanks.
> 
> --
> tejun

