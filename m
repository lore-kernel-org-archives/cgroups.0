Received: from mta1.migadu.com (out-91.mta1.migadu.com [95.215.58.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8636A4A385C
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 09:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792403451; cv=none; b=NXf+MmFvlRITtA9A7V8x7C5nJukfxBYyvFcbHhJTfhKuO9juFeEeDXjvuyBN4VolMVx/rnPW99O2wg5dXDV05zGVIBwgZZSOjHOUhQAqqFNnHbi8oRtxqUorl1BYox4l437yKfrDUU/uoRWs3Uhmg5KuQzZxHY9A+/x3V2DG6Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792403451; c=relaxed/simple;
	bh=5dg8NSvB9hFjoy54PLoUpMKB7gitIbpPU2h83kRMT2s=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=m0A/LfaUy1+b27sDYgtNkUg790hEY8pAd1VZ8n3CKE4XM0IjHcDBxFqlcS9G8BEUZaz8pdvXt3pCWdYJnB5lKSSSR4CwaytjnMlJGa2xr+sQPIedBOguEp/6tihclctx3H+3nJkHNIjkAEuvQ03PExQKhnCq5GLmv8vR9DHMnlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sovzfxe0; arc=none smtp.client-ip=95.215.58.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sovzfxe0"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5dg8NSvB9hFjoy54PLoUpMKB7gitIbpPU2h83kRMT2s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792403446; v=1; x=1793008246;
 b=Sovzfxe0zRfZXnJh2soMp8JNM+dkRvWsul3dh56BXn+bh1RMfHKiV7Lahy/mx9+lLjABlgMF
 drMjuPXJxB1EGsqMN3K+GdWu7k028eZRP46HppLCB/YeVzaFZnOiOlVc6Ajd3yWOuZDHg0uYtMv
 /M28WOWew/a2FNCW2e9z40/s=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 535a794b7b48e7a4;
	Mon, 19 Oct 2026 09:50:46 +0000
X-Mizu-Trace-ID: 535a794b7b48e7a4
X-Migadu-Flow: FLOW_OUT
Message-ID: <2352b824-7e36-453e-b3e9-151761a352c3@linux.dev>
Date: Mon, 19 Oct 2026 17:50:36 +0800
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
Subject: Re: [RFC PATCH v10 4/4] docs: cgroup-v2: document the iocost BPF cost
 model attachment
To: Tejun Heo <tj@kernel.org>
References: <20261003124045.1289305-1-cui.tao@linux.dev>
 <20261003124045.1289305-5-cui.tao@linux.dev>
 <eae39daec12cf6f121cc5010574a6c03@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <eae39daec12cf6f121cc5010574a6c03@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Tejun,

在 2026/10/17 01:49, Tejun Heo 写道:
> Hello, Tao.
> 
> On Sat, 03 Oct 2026 20:40:45 +0800, Tao Cui wrote:
>>  	  model		The cost model in use - "linear"
>> +			or "bpf" while the BPF model
>> +			is in use
> 
> "linear" or "bpf" is enough here.
> 
Shortened to "linear" or "bpf".

>> +	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, a BPF cost model
>> +	can be bound to a device by attaching an "iocost_model_ops"
>> +	struct_ops carrying the whole disk's major:minor in its "dev"
>> +	member (a partition's major:minor is rejected).  Attaching
>> +	creates the controller if needed, like an io.cost.model write
>> +	does, and
>> +	switches the device's pricing to the model; enabling and
> 
> Attaching now also populates the device's line, so the existing sentence
> saying the line is populated on the first write to "io.cost.qos" or
> "io.cost.model" needs updating. The paragraph also runs 21 lines with a
> leftover break after "does, and". Can it be split into three, attaching,
> model= selection and detaching, and removal and ctrl?
> 
Updated and split. The documentation now says the device's line
appears on the first io.cost.qos or io.cost.model write, or when a
model is attached. The same wording change also went into the
io.cost.qos section.

The paragraph is now split into three parts: attaching, model=
selection, and detaching/removal with ctrl. The stray line break after
"does, and" is gone too.

Thanks,
Tao

> Thanks.
> 

