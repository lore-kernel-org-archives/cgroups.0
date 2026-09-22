Received: from mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1747A5519BA
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 13:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083136; cv=none; b=rPPwUf5WvriT0mW9Uri6ojF3SgMnI4Gzs168RMljaMbP6pKeqKnRNz1fbmBcDdyqako2FPYgYmkUgZiGXOudWT4LTtEFw10ihN9N5k//r4feP7tBBYW7xNkUCUh2cQoG+rIbgPxPBAF+KgGkoMd3Xk9t/PcwQVv8jBcIIJsAtZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083136; c=relaxed/simple;
	bh=fZKcC/8Lg3XIF8w9KFAgMwUllIiXTJWXvemejboeABo=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JXC2iXK/nezYks3bEzjfEoFOITVagDC5GRqQLdStAjTV5XgC11gNbJiUlqFUzIlOiU+0Y1StYhnJTEjQQGkNQKalfCZlEtuZ8BlgslUH9m9W2XFdqyNEjJuYiYzuS5eF+9t8fpNL0tVTieXgPWzdtkePJ+YELryZOUPlwAnzW4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ibhp0qyi; arc=none smtp.client-ip=91.218.175.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ibhp0qyi"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fZKcC/8Lg3XIF8w9KFAgMwUllIiXTJWXvemejboeABo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790083133; v=1; x=1790687933;
 b=ibhp0qyiB48q+PqedIf43LPyx9U7/sxQYgsiAGG3xmDk4vRnHVdmdVAkbZLj5+aJAr4DEXT2
 /3HdJ+Cdbfvf47/uuXCdOPP9B6hFpQI5AuFMVlPcaceXMurLs0I/Q6Kwfm7HIaLfhKIjo9LtS0H
 vCPSnqX4tgl87r+K3cw533+g=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 19a8fee23e81eb2e;
	Tue, 22 Sep 2026 13:18:52 +0000
X-Mizu-Trace-ID: 19a8fee23e81eb2e
X-Migadu-Flow: FLOW_OUT
Message-ID: <bc816cf7-825f-4576-a1ff-a37c18e7f17d@linux.dev>
Date: Tue, 22 Sep 2026 21:18:48 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, josef@toxicopanda.com, axboe@kernel.dk,
 ameryhung@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH v6 3/5] blk-iocost: add iocost_ioc_tick tracepoint for
 per-period device summary
To: Tejun Heo <tj@kernel.org>
References: <20260918055001.1273840-1-cui.tao@linux.dev>
 <20260918055001.1273840-4-cui.tao@linux.dev>
 <7203f0453d62336bb1ca712c8e7cf569@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <7203f0453d62336bb1ca712c8e7cf569@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Tejun.

在 2026/9/22 03:37, Tejun Heo 写道:
> Hello, Tao.
> 
> On Fri, 18 Sep 2026 13:49:59 +0800, Tao Cui wrote:
> 
>> +	/*
>> +	 * vrate and period_us change right below; snapshot the values
>> +	 * this period ran in so the tick below reports the period's own
>> +	 * parameters instead of the next period's.
>> +	 */
>> +	tick_period_us = ioc->period_us;
>> +	tick_vrate = ioc->vtime_base_rate;
> 
> Everything the tick reports is already final at this point. busy_level
> was just computed, running and cur_period haven't changed yet, and
> nr_active and usage_us_sum are complete. Can you emit the tracepoint here
> instead and drop the snapshots? The event can then read the fields
> directly and the only cost outside the static key is the nr_active
> increment.
> 

That's a cleaner placement.  The tracepoint is now emitted
before the period refresh, after busy_level is clamped, and the
temporary tick_* snapshots are removed; the event reads the ioc fields
directly.  nr_active remains the only cost outside the static key.

Thanks,
Tao

> Looks fine otherwise.
> 
> Thanks.
> 
> --
> tejun

