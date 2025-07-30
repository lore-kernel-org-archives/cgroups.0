Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051392E2EEA;
	Wed, 30 Jul 2025 18:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753898402; cv=none; b=vBxos8DJpMv920FniMQleYafsnAuJq3LXRxib/VdSM5BDMR8y3s8jJSeZi7fd/7xkoLk3J5ISKNze7HY3oxzSJgxcr5hVL6ObJ5lU69xi9j7Y9idVr8hMzWQOefeAVPN8gUsL1FPCeHTfWIzTjYQYEoNvcjMQJboF8Ofv4CZjCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753898402; c=relaxed/simple;
	bh=79boMvE4EVEuoqpAs/iFjHAo1FmCavA4+Qfb1+BR5cw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qe2RaOgZAPae6BYOKLpxGdarN5pfuYQx2GIY+oT17XmDdk3eYi2kZwafifF4RSpn55ZwvMjTTHGnfwDDa9vmPcjme0RG77aFusENwsuHBKFrPw1HIwmitArwHwhc2dgBmBV/DTrSXPzIPlShlK/vFxk41guXLEGVTi5uHscYsoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gkgdewgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gkgdewgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C3BC4CEE7;
	Wed, 30 Jul 2025 17:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753898401;
	bh=79boMvE4EVEuoqpAs/iFjHAo1FmCavA4+Qfb1+BR5cw=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gkgdewgublHHMl/bE97Df+OIBt49oMaLUW5AoVor0m7cKIiuLb1tZaunSGGxhBCXR
	 RdDxkwW/D7NL2K4PF6Krh3yxBANxT2nCc0/hFhlaja4UBl02VRo9ByoOkyP4AiRHDW
	 caVVuUKWVWzMrm8SaPLZQ5+Jo8QojWN68H4BTsHaqCJbzpvbONj0GCcgSuN3CGinxQ
	 zeOxFR+AjDc4S7jYB7Gg1wbyzDt/Ti3CmjmB+lATRLoM5kx1t9SC/5G0k3ec7dGFL4
	 jKgfzi1x4NKDzk+pZ2tGLq0kwHiiaA/biBOowN19wTr2o3DZdtG4QWAgF/5RiJbKWh
	 smKYiZsN1rdTg==
Message-ID: <7ea0b6ad-c64b-4816-9d91-9d97abb02f89@kernel.org>
Date: Thu, 31 Jul 2025 01:59:54 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH v2 1/5] blk-mq-sched: introduce high level elevator lock
To: Bart Van Assche <bvanassche@acm.org>, Yu Kuai <yukuai1@huaweicloud.com>,
 dlemoal@kernel.org, hare@suse.de, jack@suse.cz, tj@kernel.org,
 josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250730082207.4031744-1-yukuai1@huaweicloud.com>
 <20250730082207.4031744-2-yukuai1@huaweicloud.com>
 <e07ce691-c298-4cb4-8ac3-35c8a8beaea4@acm.org>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <e07ce691-c298-4cb4-8ac3-35c8a8beaea4@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi

在 2025/7/31 1:19, Bart Van Assche 写道:
> On 7/30/25 1:22 AM, Yu Kuai wrote:
>> +        if (sq_sched)
>> +            spin_lock(&e->lock);
>>           rq = e->type->ops.dispatch_request(hctx);
>> +        if (sq_sched)
>> +            spin_unlock(&e->lock);
>
> The above will confuse static analyzers. Please change it into something
> like the following:
>
> if (blk_queue_sq_sched(q)) {
>     spin_lock(&e->lock);
>     rq = e->type->ops.dispatch_request(hctx);
>     spin_unlock(&e->lock);
> } else {
>     rq = e->type->ops.dispatch_request(hctx);
> }
>
> Otherwise this patch looks good to me.
Ok, thanks for the review, will change in the next version.
Kuai

>
> Thanks,
>
> Bart.
>

