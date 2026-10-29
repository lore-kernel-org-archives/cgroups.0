Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.23
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793267838;
	b=JQFV+t+mUj9Fg0/IrWMtNeJdkpwlHUI85uNYW6pHSxTmQrnAlIYW35pAmxrRdcQqeEaN
	 9q3FBIYCMzE6a/zGCUti/5No+H2UEa6c31S/d929AMD6CXRSJn0SSMDyG7XAwwDm+oMfG
	 LOBTTXKpBcDrS3x0SplRpstPvrhSC6CFL8gghoagIx+nlXcfFVQy6MouOF5q2uftefzmF
	 wRlJWIOa4DG5IpIcUnYgUE6sSTZ/rv8PkJ7y9nABIS1Gvxe4szZVFoYY5WsR3de9rH0Jr
	 Qx4E2X71Gq6QvSMpfTRJ4upZNfS2SxfMMwTmRPhj7r3bvxqhZGzzlWCDHp3r/zmzFrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267838;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=hWaXPrGDhyWCEUeKdoM63o7PKlFaYUkm9xCkqBAxeQ8=;
	b=DYBQMHkNgzsX3Sq5uhpu4oLHpcId8rjLEoZIwYFPoAfOKWIZG6FEYyn5CImc7fbxYwVR
	 rV6IS1o78Cl7j3ixfbUFQCOED/K1LbThfCIyYHP4PR2tPINslS0+LjtnR4VtJEGtidGNT
	 QG7FDi9/k+CaHUtJ8wd/r6qso2ldY6kYRZVIc4mTqPVksqXc3SboeaDN1KyuiA6EJ6bof
	 0J0uy3+r0AEo0X+lNRoJ0mTD9pbagcGI2Hyxqe65rzakA6h3hSzY8UvSeqn/09VfSX6Ur
	 zrid84qboDGxuL/n08du6/TflB6CRPoSap3rjv2uqe9c3jnSGapFwHpMpyYviSoqiWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W+8t3+4h;
	arc=none smtp.remote-ip=91.218.175.23
Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6CB606A326
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 09:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E6CB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W+8t3+4h
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Io8Za75LZDFiHR23Q0ReXlDPmUPWVZA1pjzJJhGltWs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793267835; v=1; x=1793872635;
 b=W+8t3+4hzBuvDinHlL4/EKDxfKXJ4cubc1EvEM0vXLoktC0n9sSWJmPduSJC7rgYYU5smwZQ
 cSW/Bh7BxQrBADVQivNj+JWahrOFiESZrj9Jr4N8UEwkwbshany87jIUJB9D8FfYbLD5aTZGoO+
 WzvPqaCenb7HrvGiHq/D6bi0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1cb8ab88aefdeb15;
	Thu, 29 Oct 2026 09:57:15 +0000
X-Mizu-Trace-ID: 1cb8ab88aefdeb15
X-Migadu-Flow: FLOW_OUT
Message-ID: <9145109e-0030-451b-9cca-d23eab30a826@linux.dev>
Date: Thu, 29 Oct 2026 17:57:05 +0800
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
Cc: cui.tao@linux.dev, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 eddyz87@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 linux-kselftest@vger.kernel.org, cuitao@kylinos.cn, ameryhung@gmail.com,
 alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v11 0/5] blk-iocost: BPF struct_ops cost model
To: Tejun Heo <tj@kernel.org>
References: <20261028143534.135968-1-cui.tao@linux.dev>
 <07deddf44be391f58d6c3f2e4843582b@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <07deddf44be391f58d6c3f2e4843582b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Tejun,

Thank you for the review.

在 2026/10/29 04:09, Tejun Heo 写道:
> Hello, Tao.
> 
> Besides the restructuring agreed in my reply to Alexei, dropping
> iocg_init()/iocg_free() and moving everything into blk-iocost.c, the
> series still has problems, which I replied to on the patches. 
I'll rework the series accordingly: drop iocg_init()/iocg_free(),
remove the detach freeze, fold everything back into blk-iocost.c and
drop patch 1, reducing the series to four patches.

The cover
> letter is still long and narrates mechanics, and it still carries the
> v9 and v10 changelogs.
> 
I'll shorten it, focus on the motivation, and drop the v9/v10
changelogs.

Thanks,
Tao

> Thanks.
> 
> --
> tejun

