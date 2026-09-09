Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E8D3BD241
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 13:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788959584; cv=none; b=PDr2bZD9qfONhDUcCxmgD9gCL2W2ZwJxvz/wiuI8xTvrTAOsbr6fGtxdXQUiVtNFMTHm37Vec/TH6YmPAmlcoAEWNKNNfl3Jan7sCJiDIwrGQjbZbMkiUALoxa3sSZTfamrHKIvTT7H4YinJJzt62EMHXfcajtycmfZ4SOQga74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788959584; c=relaxed/simple;
	bh=pTDfVRoX1U+RIjfQuPegFcGKswGHWQIt1UsGbzs5f/E=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FxzERb6w/nQghso58efIFBLmXrymFRMLrLOnVZePpOPnc3j+PiP5l6mXdsLGhLoVnyt5uH682V927+xHnHHQSvatQUPDcw06oqBmIl6vA5xeilI4lt+/0/m9AGncyoUqhOyvhb2c+DsunJNWjDmuiR5SkH2+X5QyIaC2w3d+u10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OtdeloKO; arc=none smtp.client-ip=91.218.175.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OtdeloKO"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pTDfVRoX1U+RIjfQuPegFcGKswGHWQIt1UsGbzs5f/E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788959580; v=1; x=1789564380;
 b=OtdeloKOIruM9qO0qJpX2b+U/7i6FL3ax2sVvxjwMZamfzLli6o5HmujIYltuTKW9+kB0Pcd
 UvVXIgft599AT40Lw210drnTEfY9StLpnk2hBqZudqP/TFjSOnOgBQ09jtX35FBs+icNyiLXqHD
 qnPP6Cty/9atR4fdA0g8K/tA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b52656f567ea3328;
	Wed, 09 Sep 2026 13:13:00 +0000
X-Mizu-Trace-ID: b52656f567ea3328
X-Migadu-Flow: FLOW_OUT
Message-ID: <7ff19114-de0c-4118-a000-b236d8d30127@linux.dev>
Date: Wed, 9 Sep 2026 21:12:54 +0800
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
 ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/8] blk-iocost: BPF struct_ops cost model
To: Tejun Heo <tj@kernel.org>
References: <20260908100143.47598-1-cui.tao@linux.dev>
 <178889947167.2.14514677804554939704@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <178889947167.2.14514677804554939704@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Tejun

在 2026/9/9 04:31, Tejun Heo 写道:
> Hello, Tao.
> 
> On Tue, 08 Sep 2026 18:01:35 +0800, Tao Cui wrote:
> 
>>  4. One model system-wide vs named models selectable per device (as
>>     tcp-cc names are per-socket)?
> 
> The struct_ops instance should be per-device. Loading a model for a device
> should switch it to BPF automatically. Switching back to the builtin model
> should detach the struct_ops.
> 
>>  2. Per-cgroup state lifetime: iocg_id is the css id and is recycled
>>     once the cgroup is removed, so models must treat it as a
>>     transient key.  Does the interface need a release(iocg_id)
>>     callback so models can clean up per-cgroup state instead of
>>     detecting reuse, or is per-cgroup bpf local storage, which
>>     carries its own lifetime, the better home for model state?
> 
> I'd pass blkcg as a kptr and add online/offline callbacks so the model can
> manage its per-cgroup state.
> 
>> return value of 0 delegates the IO back to the builtin formula, so a
>> model which only handles some IO types cannot make the rest free.
> 
> I don't think mixing BPF and builtin pricing makes sense, either per IO or
> between charging and request sizing. It seems convoluted and error-prone.
> Implementing the linear model in BPF is straightforward.
> 
> Please combine the interface, registration, dispatch and configuration
> changes into one patch. These patches are small and implement one feature.
> 

Thanks for the detailed review across the series.

All the comments make sense. I'm reworking the interface for v2
along those lines: the attachment model will be reworked, the
mixed builtin/BPF pricing path will go away so a model fully owns
pricing on a device it's attached to (including flushes), the
per-cgroup state handling is being reworked, operation flags will
be preserved, and sleepable models will be rejected during
verification.

The Kconfig dependency, the example model issues, the selftest
problems, and the patch organization will all be addressed as well.

I'll post v2 once it's ready.

Thanks,
Tao

> Thanks.
> 

