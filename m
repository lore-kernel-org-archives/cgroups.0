Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E673D9DDE
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 07:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789888143; cv=none; b=T3nWxMPXQr4eZlD9ilXKrYt8KpFVylbX0jL84WRrPBZNTYJ2cUAbEqZbGi3UQ6hk+T0MsEruVrNOdz1Eg2srRrKDpoIRlHrS/jCLvy41asBwSmkk/g/7fm7i4ogveMCWGtQ0Gh9xaqYuvDui5CD0+O0CS3J2y0OgTQDa6njCCB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789888143; c=relaxed/simple;
	bh=VgeBjtVfHDvoQqBuILT+p6c6cwhxbzBnIRRxf84zUQc=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ErVI7Crh0WOhNk5dE375BUHdCihFChDjZeaRDLV8HV6al3lN4eSrmDxQlplP+pLcSgWC2Tb2o0cSQ7utSpDveC9AFcXf1l/5iK27TXsAkqmSF5YKMkmW6BkpzWZFRuKCcYWOPkbe6cXfh3s02+3BjNV7dNlYnFvyIMgsoRp8+xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j19dSBIc; arc=none smtp.client-ip=95.215.58.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j19dSBIc"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VgeBjtVfHDvoQqBuILT+p6c6cwhxbzBnIRRxf84zUQc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789888139; v=1; x=1790492939;
 b=j19dSBIcYF/FfClW4UyntiOwbTP1RxAWh+hHdeXCSMEq8BjQcWVrnOnrHcZTT1trc71DPRVT
 haf/m9zbHJxcQoD5KCxwWr1O3bAZgvs/jLI6b5CAPdccqJW2zNXaNPSthYmgN6fScdGNrsjdPsj
 gdhFbMcYqNZwRAT1zoLev27E=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b40f69e8e1eff5f6;
	Sun, 20 Sep 2026 07:08:59 +0000
X-Mizu-Trace-ID: b40f69e8e1eff5f6
X-Migadu-Flow: FLOW_OUT
Message-ID: <ab72a564-108c-4b74-adf3-1eadbbf01084@linux.dev>
Date: Sun, 20 Sep 2026 15:08:54 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Josef Bacik <josef@toxicpanda.com>,
 josef@toxicopanda.com, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH v2 1/4] blk-iocost: charge flushes as pageless random
 writes
To: Tejun Heo <tj@kernel.org>
References: <20260916085304.1080271-1-cui.tao@linux.dev>
 <20260916085304.1080271-2-cui.tao@linux.dev>
 <9575357186118be214d6377dd80a21e8@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <9575357186118be214d6377dd80a21e8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Tejun,

在 2026/9/19 22:59, Tejun Heo 写道:
> Hello, Tao.
> 
> On Wed, Sep 16, 2026 at 04:53:01PM +0800, Tao Cui wrote:
>> Charge the flush component of any REQ_PREFLUSH bio on top of its data
>> cost, priced as a pageless random write (LCOEF_WRANDIO), which provides
>> an approximation of the device time consumed by a flush.  For profiles
>> where WRANDIO clamps to zero (ssd_dfl / ssd_fast), use a one-page floor
>> (LCOEF_WPAGE).
> 
> Pricing a flush as a random write, or as a page where that comes out to
> zero, is as arbitrary as pricing it at zero, and it changes what existing
> setups get charged. 013adcbef165 ("blk-iocost: skip empty flush bio in
> iocost") zeroed them because the flush machinery coalesces flushes and the
> write coefficients don't say anything about what a flush costs.
> 

Understood.  The write-coefficient pricing was only an approximation and
would change the accounting behavior for existing setups, so I'll drop it
and rework the series around a dedicated flush cost.

> Can you instead add the flushiops parameter you mentioned in the v1 thread
> to the linear model? A flush costs VTIME_PER_SEC / flushiops, and zero when
> the parameter isn't set, including in the builtin profiles, so nothing
> changes until it's configured or the profiles are regenerated with a flush
> measurement.
> 

Will do.  I'll add flushiops to the linear model using the same conversion
as the other iops coefficients:

- add a flushiops=%u token for io.cost.model and translate it to
  LCOEF_FLUSH = VTIME_PER_SEC / flushiops
- keep flushiops zero in builtin profiles, with no fallback, so existing
  profiles keep their current behavior
- account REQ_PREFLUSH and REQ_FUA consistently with the flush machinery:
  PREFLUSH charges one flush, and FUA adds another flush when the device
  does not support native FUA

The rest of the series (zone append charging, latency accounting, and the
comment fix) remains unchanged.

> The same charge should cover REQ_FUA the way the flush machinery does: one
> flush for PREFLUSH, and one for FUA on a device without FUA support, which
> is when a post-flush gets issued.
> 
> Please also drop the Fixes tag on this patch. With the parameter, this is
> an extension rather than a fix.
> 

Done.  v3 will position this as a cost model extension.

One remaining question is whether builtin profiles should eventually carry
measured flushiops values, or whether flushiops is expected to remain
user-configured.  This series leaves it at zero because I don't have
reliable measurements for the existing profiles.

Thanks,
Tao

> Thanks.
> 

