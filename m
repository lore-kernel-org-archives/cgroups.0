Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D38D352027
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 07:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789803306; cv=none; b=MhI2WIG8VxQXx34ZcfntcQR4PFSLpQyMRVi3KWzHbvlVKvnyRpY+2RyBzZHRWxfZMEQ4e+nneJNUn2cChiHqqLbbg/n6G8ie/yskGPxHXVJmIlIMgA+2B8tz4VkXQQu2aNKMUnk8kCZKnDLocQwhyD1cVpfPYt8tN8FiiT7WSWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789803306; c=relaxed/simple;
	bh=bwTHF6NnPL2Nf6L0KvSVWduTuK3JmVHwj2sjNly6dPo=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=e9SCtOGpM5EssfPLlXT432aIASxPPrk11my9ZrzGn2R5HRTc0XyJU6UyRNBn9hyA0uldqD0OVDtJfrvY3tYQsC6PlAQWIP34G6KFf40/c/b9vXG0cRTkKQnCI4O1PYnsNxBTE3RpFfQcdbyIZGnO8GoXn2N/idsLmXDnGLBd1rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jrkY5f59; arc=none smtp.client-ip=91.218.175.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jrkY5f59"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bwTHF6NnPL2Nf6L0KvSVWduTuK3JmVHwj2sjNly6dPo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789803301; v=1; x=1790408101;
 b=jrkY5f59AO1rrkbeDGnUAJiQsf+UARwOfR38Ih2pV3qCG2BVedCN66sS6Xh0Jrj/JMBRBcvS
 eHgCAPTBrTtqIzGAGLootoakKC2dk4qpdIGe79VYB5ro4Dc2C7AaFKdiQP/QKyj2gbstDh8/Jt7
 juo3vlu9A57wjuDarjhlfKMA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 95f1a4aad28e81c8;
	Sat, 19 Sep 2026 07:35:01 +0000
X-Mizu-Trace-ID: 95f1a4aad28e81c8
X-Migadu-Flow: FLOW_OUT
Message-ID: <748ca00e-61af-4698-86a9-cb28a41c7471@linux.dev>
Date: Sat, 19 Sep 2026 15:34:52 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 cuitao@kylinos.cn
Subject: Re: [RFC PATCH v5 1/5] blk-iocost: add BPF struct_ops cost model
 support
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, tj@kernel.org,
 josef@toxicopanda.com, axboe@kernel.dk, ameryhung@gmail.com
References: <20260918031751.1255420-1-cui.tao@linux.dev>
 <20260918031751.1255420-2-cui.tao@linux.dev>
 <DLIK37JYD35X.3NZ4ZHTHDKAFX@gmail.com>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <DLIK37JYD35X.3NZ4ZHTHDKAFX@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Alexei,

在 2026/9/18 23:43, Alexei Starovoitov 写道:
> On Fri, Sep 18, 2026 at 11:17 AM Tao Cui <cui.tao@linux.dev> wrote:
>> The registration and binding model follows the TCP congestion
>> model registration pattern: registering a struct_ops makes the model
>> available by its name (char name[IOCOST_MODEL_NAME_LEN], validated at
>> init_member), while
>> io.cost.model binds one registered model to a device with
>> "model=<name>" and unbinds with "model=linear" or "ctrl=auto/user".
>> Unregistering a model removes it from the registry, but its name
> 
> I don't think it's what Tejun asked for in v1. He asked for a per-device
> struct_ops instance where attaching switches the device to bpf and
> detaching switches it back. Instead there is a global name registry,
> a lifecycle list, an "unregistered but still bound" state and a
> refcount_t on top of bpf_struct_ops_get(), and every version since v3
> had a lifetime bug in exactly that code.
> Do it like hid_bpf_ops does with hid_id: device in the struct_ops,
> bind in .reg, unbind in .unreg, and le
> t struct_ops own the lifetime.
> 

Thanks for pointing this out.

You are right. I misunderstood Tejun's comment from v1. I took
"per-device" as selecting a registered model by name for each device,
which led to the current registry/lifecycle design.

My original implementation followed the tcp-cc style named model
approach, but that was not what Tejun was suggesting. The intended
model should be a per-device struct_ops instance, with attach/detach
controlling the switch between the BPF model and the builtin model,
and the struct_ops core owning the lifetime.

> pls wait for Tejun's feedback before respinning.
> 

I'll rework the design in that direction and wait for Tejun's feedback
before sending another revision.

Thanks,
Tao

> pw-bot: cr

