Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.65
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792487790;
	b=xk9vDYvzVsYJVnh0Z8cH4upHLRNa2G3+5cSzGT+aIJAe1KZ4Pjyk6mmhgEXboYpjK/z1
	 q4PG9HxnQaUqYJAuegcGbbmgerkTvAq49TaDJ7XS8+p348z8IeaBPBE3KCZpp28fai7jG
	 7XP0NnxSQzXtI5q9c65bjhRZgilZD8A0+IQqrvV8QNp8qMKYhY0p3XBzcorPVFlLnaNQ7
	 KTUuNWnH+dDt0LfoqSyvyqXILOYDGKPW5mgWyPzBrEd8soac1/f46tIxlHJIxNPJ+2wH3
	 zlu/mD6AOVQrAEvcvbEeK73TiOI8PkrrTCUsK4ukPtX9NYN5lE4p4y3t04aLPafa1dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792487790;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=fgVCjXg66MfmXK1DhMhAdx0UFOlMxpw0/DgjoCbhR4g=;
	b=o+9qGqdN0+hodQsuIrzBmYWcuSj1zcW6x9tWfPyhXYgwv6v/9imfD0TjPFPymwb3vud8
	 RW4Hi+vmYX2p54DgTqsDQ5emVfMSV9xrVNzFtKhSt6fUgv2Y36NJgvGcOJoDXrMgJ4l2U
	 sgVxWDoVx/pPsiRcbfCdRV0a2ebGOnpsCYT/nq8X/x2gcaJEVSuGNopEhK5UTgNHw1rQM
	 MaXNVvE0qwQxBkwLxW3yBihSid+QxR0m/B/nsCcYTu4Nt6/RmhzhJmWNWTpTgD3hXB0L9
	 ZbgUj/tJ+7M/4+A0SQ07d3XBtj3wUmPeT+KoDzLfIeWH2xHg3o4/SHpfrCFZcLyMNhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VXWXviUg;
	arc=none smtp.remote-ip=91.218.175.65
Received: from mta0.migadu.com (out-65.mta0.migadu.com [91.218.175.65])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E7C606A325
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 09:16:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76E7C606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VXWXviUg
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9eP3qjgVUbFfqUcF5YGr57onnQc45ct6s0INEa2Ebw8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792487786; v=1; x=1793092586;
 b=VXWXviUgLFBknZK+dXQMJD2opDdEMVE/cZ/3qSzssNRpsItYDpeGBg7DYwuILh0VryDri6KL
 oG1btPXLvLKGSJNsy4M1Hh1+41q+UVyMjWpK1vApTOqPMdpAMLmlKwQ4+RqbNC4cyZApJtfS7Nd
 7ExI8i53YCSA+BxNDFWxvjQs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8edb85ba72c7628e;
	Tue, 20 Oct 2026 09:16:26 +0000
X-Mizu-Trace-ID: 8edb85ba72c7628e
X-Migadu-Flow: FLOW_OUT
Message-ID: <6e7d6232-d422-47f3-bc85-a52508cb172f@linux.dev>
Date: Tue, 20 Oct 2026 17:16:20 +0800
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
Cc: cui.tao@linux.dev, axboe@kernel.dk, josef@toxicpanda.com, yukuai@fygo.io,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] blk-iocost: fix hweight cache publication and
 donation fail-safe
To: Kunhai Dai <daikunhai@didiglobal.com>, tj@kernel.org
References: <20261019125412.3123895-1-daikunhai@didiglobal.com>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20261019125412.3123895-1-daikunhai@didiglobal.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Kunhai,

在 2026/10/19 20:54, Kunhai Dai 写道:
> This series fixes the blk-iocost hweight cache publication race and adds a
> fail-safe for invalid donation weights.
> 
> Previous version:
>   https://lists.openwall.net/linux-kernel/2026/10/15/1954
> Replies:
>   https://lists.openwall.net/linux-kernel/2026/10/16/1431
>   https://lists.openwall.net/linux-kernel/2026/10/16/2798

I re-ran the injection tests on my side (linux-next 20261019):
two runs with a 30ms kprobe
hold on every refresh of current_hweight() and one with the hold on every
50th refresh, same rt/s1..C topology and 1 <-> 10000 weight alternation
load as before. No WARN or oops, and the tracepoint hweight fields decoded
within [1, 65536] in every run.

For the series:

Tested-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>

Thanks,
Tao
