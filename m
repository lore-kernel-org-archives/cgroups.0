Received: from mta1.migadu.com (out-231.mta1.migadu.com [95.215.58.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956AE52BE22
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 13:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790689381; cv=none; b=QU6idYRdIAjvH7j70JBtHKGoziGVEHP6KC+MIufbTHU+JRcH6t93aW9QbgDv+16Y+jSBp+vchmqeRuYirXOeAZBYKcytr767cIHKQBI8PXyxHI4ZnxNRmKinRv7ggkHOPDtD8uk6J9l2EPfFZrUcil7d9qbtcQz+OWimYmbcwfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790689381; c=relaxed/simple;
	bh=dIhIDrTuoKmEwXEXxGZu674aq5WUlz1NX3TZo5VwawQ=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f8MZzWImeudX4zHlYn8qifgoougs+IGjsxkMzWT84XWdF/g1cCZdyhmtPxJBDWGTIgqIYwX8RIONmjAuJb8UnLp4sKUyjfrSXq6GU/poR7xKSEnfuAXG2gyF+ggGYWUT3AbgAQEOTQteUzpaXjjRDLxfGmG6eeiJSUOzersk5rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WmjF8+Tf; arc=none smtp.client-ip=95.215.58.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WmjF8+Tf"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dIhIDrTuoKmEwXEXxGZu674aq5WUlz1NX3TZo5VwawQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790689377; v=1; x=1791294177;
 b=WmjF8+Tfa8aYjDvUdcjT16l66sQHh7bI1kFT84ZwiG3+hKSLMtBVvRUVL7YvrcifKcXRP0b5
 EFEvHgFhhTiT5B2vAOWSbixKwgJBdl2UUgr9AnxkZUYNwGATy5OxCBxkYKKHO2wIHkiyR03lyl3
 UWcpqwkrGCPN5pZdcThDtGEk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 905fac591b66090f;
	Tue, 29 Sep 2026 13:42:57 +0000
X-Mizu-Trace-ID: 905fac591b66090f
X-Migadu-Flow: FLOW_OUT
Message-ID: <daf428f7-d666-447f-9b6e-a77da4194e91@linux.dev>
Date: Tue, 29 Sep 2026 21:42:51 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>,
 ameryhung@gmail.com, alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v7 1/4] blk-iocost: add BPF struct_ops cost model
 support
To: Tejun Heo <tj@kernel.org>
References: <20260924054549.2271705-1-cui.tao@linux.dev>
 <20260924054549.2271705-2-cui.tao@linux.dev>
 <4412563645504aa9a87d3cafd544c97c@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <4412563645504aa9a87d3cafd544c97c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Tejun.

在 2026/9/29 08:42, Tejun Heo 写道:
> Hello, Tao.
> 
> On Thu, 24 Sep 2026 13:45:46 +0800, Tao Cui wrote:
> 
>> -	/* if user is overriding anything, maintain what was there */
>> -	if (ioc->user_qos_params || ioc->user_cost_model)
>> +	/* if user is overriding anything, maintain what was there; the
>> +	 * same while a BPF model is attached: the builtin coefficients
>> +	 * are inert then, so stepping the profile is pointless
>> +	 */
>> +	if (ioc->user_qos_params || ioc->user_cost_model
>> +#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
>> +	    || rcu_dereference_protected(ioc->model,
>> +					 lockdep_is_held(&ioc->lock))
>> +#endif
>> +	   )
> 
> Can you add a helper which returns the model in use with a stub returning
> NULL for !CONFIG_BLK_CGROUP_IOCOST_BPF? That'd remove most of the #ifdefs
> including the one in this condition and the duplicated seq_printf() in
> ioc_cost_model_prfill().
Done.  ioc_model_in_use() and a locked variant return the model in
use, with NULL stubs for !CONFIG_BLK_CGROUP_IOCOST_BPF; the autop
condition, both calc paths, the pd callbacks and the prfill now call
the helpers, and the duplicated seq_printf() is unified.

> 
>> +		/* sub-page IO: nothing to transfer-price */
>> +		if (!pages)
>> +			return 0;
>> +		/* zero transfer cost is a legal model; guard the division */
>> +		if (!coeff)
>> +			return 0;
>> +		/* pages * coeff can wrap and dodge the clamp below */
>> +		if (coeff > VTIME_PER_SEC || pages > VTIME_PER_SEC / coeff)
>> +			return VTIME_PER_SEC;
>> +		return min(pages * coeff, VTIME_PER_SEC);
> 
> This can just be pages * coeff like the builtin. An overflow only skews
> the met/missed accounting, same as a user-set linear coefficient, and it
> also gets rid of the 64-bit division.
> 
Done; the guards and the division are gone and the completion-time
sizing is back to a plain pages * coeff, like the builtin.

>> +	bdevf = bdev_file_open_by_dev(new_decode_dev(ops->dev),
>> +				      BLK_OPEN_READ, NULL, NULL);
> 
> When the disk goes away, the model should be ejected completely.
> ioc_rqos_exit() unbinds it but the open bdev file keeps the dead disk and
> the driver module pinned until the link is destroyed. Can you drop all
> device references on removal like hid_bpf_destroy_device() does and look
> up the device like blkg_conf_open_bdev() does, with blkdev_get_no_open()
> and disk_live() checked under rq_qos_mutex? The two attach issues bpf-ci
> reported, the missing re-attach check in .reg and the missing disk_live()
> check, are real.
> 
Done.  The struct file is gone: the attach looks the device up with
blkdev_get_no_open() and checks disk_live() under rq_qos_mutex like
blkg_conf_open_bdev(), .reg rejects re-attach via ops->q, and
ioc_rqos_exit() ejects the model completely on removal, clearing the
queue pointer.

To keep the queue alive across detach, the attach now holds a
no_open bdev reference, similar to hid_bpf's per-ops device
reference but without a struct file or driver-module pin; the
reference is dropped by whichever path detaches the model first,
either ioc_rqos_exit() during removal or .unreg, and .unreg
re-checks ops->q under rq_qos_mutex.

That leaves one race: .unreg may observe a non-NULL ops->q before
ioc_rqos_exit() clears it, then block on rq_qos_mutex while the
ejection drops the last bdev reference.  This looks analogous to
hid_bpf's .unreg vs. destroy_device synchronization.

Does that seem acceptable here too, or would you rather have .unreg
own the final reference unconditionally?

Thanks.
Tao

> Thanks.
> 
> --
> tejun

