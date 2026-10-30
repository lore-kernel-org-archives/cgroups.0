Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.86
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793324987;
	b=hrSw4Lo7AwC1qXM5InG+UE2BjgqYKmLGcXJBB+LUKnrvffsFI6AncFd9YdIVfiCZiDBC
	 1dzaUjIhjM/gQl6F6+e0sLghf7As4AA/ygWIDUxWQwCnVvhqPkkV2yIb0aWTfdE0fXFFS
	 gu0zU3p3Tt9L77d9sTXcPcrM9zUofQ35sYSWYwWjh5SPok1XWiqBC5QuLpuJOqljSo+FZ
	 S4ku4xpuYyTRaVwNmnPQ/Dskso4XpnTqAvqtkJ2KGEhuKlRCrD8rD47HwOf4EfGNy0ZcB
	 xGag+Ng77AgKXTDFlP/D1NA6bOR09BB69ao9sYoqFAEOPpkpk8wXD11Uxtf+fQSV6QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793324987;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Ks/als92P7W6dfkbUwU45ITyxrQRBrooZjsUBw6Ieik=;
	b=ZoLAwL+/hxgXJGJ0dvapDlLvO7xu0stlP/db5c2p1foanUSTW0OSmZDCkw5/qXFa8Ine
	 kbEtcIzHNj8K7Z9XTjzZrIw4Dxwmz6+joqW4mhaqagkMwKN6JLJ3sM+ssJNTPJGHLgZCP
	 EoE1fY/b6LzirhtGEcX5CuKeWpIQgmD2oZC3NGmBUfLCeIFyLKErY3KY57g7yPPF7uZzW
	 2HrtJJKT8lo+/k48X3bc04Y/nepXdrdwecT4dhRtFD+nvykPVF900LrLniTjflZOmOQNU
	 CvkE7re5WFc/13wTePyiZIjqEE/ufQ7SlBS2RJPNhlghv2gqh1MN9Iy5iPENh1HMboQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iD5IOsSI;
	arc=none smtp.remote-ip=95.215.58.86
Received: from mta1.migadu.com (out-86.mta1.migadu.com [95.215.58.86])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99372606A31A
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 01:49:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99372606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iD5IOsSI
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pbxzV7BQ52dy3p13iURJvjvoZreCLEfbqYQbK2sAiaE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793324979; v=1; x=1793929779;
 b=iD5IOsSIZVHtf3NUxmwGJnmDh6oWImrqcYxGWcyoDWrwBHgf1pQyRkU7H5gC/Ypfb7A2d76J
 TEGvdZk0yj3P/sTuOVNK31dedzPDAEsqP4hgxZdMkwUATqDp5AhsopEk42lJiotlUjj8rfl8a4b
 huG4aQLCY+tO7AwvKbeurjwI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id eb3448e0ccbbf1c7;
	Fri, 30 Oct 2026 01:49:39 +0000
X-Mizu-Trace-ID: eb3448e0ccbbf1c7
X-Migadu-Flow: FLOW_OUT
Message-ID: <8f8d1c9e-da88-45a9-bbe0-c1b1403e949c@linux.dev>
Date: Fri, 30 Oct 2026 09:49:32 +0800
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
Cc: cui.tao@linux.dev, cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] blk-iocost: account flush sequence latency only once
To: Zhe Liu <liuzhe1@kylinos.cn>, tj@kernel.org, josef@toxicpanda.com,
 axboe@kernel.dk
References: <20261029092424.764545-1-liuzhe1@kylinos.cn>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20261029092424.764545-1-liuzhe1@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi, Zhe

在 2026/10/29 17:24, Zhe Liu 写道:
> A flush sequence with a DATA phase can complete its original request
> twice. Both completions invoke ioc_rqos_done(), causing the request to
> contribute two latency samples and adding the same queue wait time
> twice. This gives such requests disproportionate weight compared to
> ordinary writes, distorting the device-wide latency and queue wait
> feedback used to adjust iocost's virtual time rate.
> 
> Skip requests marked RQF_FLUSH_SEQ in ioc_rqos_done(). The flag is set
> when the request enters the flush machinery and is still set when the
> data phase completes; blk_flush_restore_request() clears it before the
> final completion, so accounting happens only once, after the whole
> sequence finishes. The remaining sample covers the request's lifetime
> through any postflush, and its queue wait time is accumulated only
> once.
> 
> Fixes: 7caa47151ab2e ("blkcg: implement blk-iocost")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
> ---
>  block/blk-iocost.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 2ae40138e041..601029221e6f 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -2868,6 +2868,9 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
>  	if (!ioc->enabled || !rq->alloc_time_ns || !rq->start_time_ns)
>  		return;
>  
> +	if (rq->rq_flags & RQF_FLUSH_SEQ)
> +		return;
> +
>  	switch (req_op(rq)) {
>  	case REQ_OP_READ:
>  		pidx = QOS_RLAT;

Reviewed-by: Tao Cui <cuitao@kylinos.cn>


