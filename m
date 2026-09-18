Received: from mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9054F96B1
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 13:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789738585; cv=none; b=c+WJ5nefDxuYXua2qUK/BgeqZRv30NxEwhm1du901CDTkbIGfzL4n3WkbNNPoNkZJPGMHnPPd83qMNmAB2dTjfC504i1azJy2ZOwyiDj4rKfPc+s2DYDpj4orKLbz71GxhnRhPnBJ3E15ghVEjyXslqLtKk8hJTobw55OD76Www=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789738585; c=relaxed/simple;
	bh=pvD3aJ8le/Im6vSiNfoFqTwGeUg+ivaLxFZnLjWT+cU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YTpDYkk/NxKBlK+Kj1xBEKQAojJTCDIDpSxdYgpFc92K6Bfm21IKnaqhRj6kJztMAvmssSxpR3/ag5BHYMPxHBCf/Fi4naODtRTHgim8miJ5DFs83MPmuY8kIeXJ7lbgf/rGl2XEhnC82XLTVzkWgxiETmp9jnbCQpHN5O2UthE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kapzy+CL; arc=none smtp.client-ip=91.218.175.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kapzy+CL"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pvD3aJ8le/Im6vSiNfoFqTwGeUg+ivaLxFZnLjWT+cU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789738581; v=1; x=1790343381;
 b=kapzy+CL8MxYpnUjnMi2eYTtP7h+6QUMWN/lJJHjsIb60SYxnQhEt6/Ufn81HRAlzfdVzPiN
 MWnn8Bi7JZ4/M9mEP2cbnX3cK0kAoqTh5I3tLrRnuD321s8U3AWcX3HGDuwBms9+UzR61gRJVj8
 fJlAKbgALNOnYrRKyJzC9faI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5c05e03064eca122;
	Fri, 18 Sep 2026 13:36:10 +0000
X-Mizu-Trace-ID: 5c05e03064eca122
X-Migadu-Flow: FLOW_OUT
Message-ID: <5db7d87e-8d1b-40e0-a69c-4dcebc173456@linux.dev>
Date: Fri, 18 Sep 2026 14:36:05 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tick/nohz: Avoid unused timekeeping_max_deferment() calls
To: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org
Cc: hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev,
 riel@surriel.com
References: <20260918133345.2823363-1-usama.arif@linux.dev>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260918133345.2823363-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 18/09/2026 14:33, Usama Arif wrote:
> tick_nohz_next_event() limits a CPU's sleep interval to the maximum
> deferment supported by the current clocksource when that CPU owns the
> do_timer() duty. If the duty is unassigned, the limit also applies when
> the CPU's TS_FLAG_DO_TIMER_LAST flag is set.
> 
> After the early timer checks, the function currently reads the maximum
> deferment unconditionally. It then replaces the result with KTIME_MAX
> unless one of the two conditions above applies.
> 
> timekeeping_max_deferment() performs a seqcount-protected read of the
> shared timekeeper and follows its clocksource pointer. Check the do_timer
> state first and avoid this work when the result would be discarded. This
> leaves the resulting expiry unchanged and reduces accesses to timekeeper
> data that is modified regularly.
> 
> On x86-64 this removes 18-20 dynamically executed instructions, including
> the call, from the common non-owner path when the seqcount does not retry.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
> v1 -> v2:
> - Remove the unnecessary comment and delta variable (Frederic Weisbecker).
> ---
>  kernel/time/tick-sched.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
Sorry about the noise, please ignore, copied the wrong list of people to send to.
The correct list is [1]

[1] https://lore.kernel.org/all/20260918133408.2834751-1-usama.arif@linux.dev/
