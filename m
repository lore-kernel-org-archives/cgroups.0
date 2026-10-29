Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.229
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268259;
	b=ZTdpQ4P7GHPfEjqtmOkyQlkogiDvySw5FKr1unDhHLEa+OLsl3AdGreEkWRwM5+OhaKR
	 fWHr+w8rrOAvwFkMzmMrXjgKBa/bwAqr6m8sINvfgSZ6epkkISceoYzATm/h1Oy+07IMw
	 +nWKBfI/UOjkWlL2SDRIp8eD4u35XLbI7lz35bWJ9T7yA73iYU272QXlr6SZQCEnVvYFV
	 4pUBtvoH0THYUZ68BOuiiDw6QvRyP04vj++dp6eITo9/CJG8L585YRICZoxQf83tS5JW3
	 2MTHIytKstaKAkOypg7WzvABdtwHmtPhwcmX+TWZtXckBxZykghzAM8EA6QHegXMaJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268259;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=LB/73nfCAHiY8ms6QFBHreSDwl9iYXEvUDaC3DV6Zu0=;
	b=0miQCi1/boUY/gk9hL16QMITNeI9pIava8ZRdcYHLgFnd1hZ937ubUoFNesVQF/pEcEt
	 EhiITRL1a8mVp9+W1pM57xSkh+4Ue9OSdqjsoQcm+zI1XyGY6hYS7/QQDBa7gfxy72HUb
	 2mE5rJ+cuSM8upq0ZSABP5YpoyMDyeF/WEKJZs6JwUhk5OalNgRWcsxZA5FpvrUeQfAzg
	 eW2yBXGTKIdnLv7wz8fN7FkaBQ4mxD2MGnx6NqU/s54oLFe2SsOm/3Nh0j3KI4T8Ayj2R
	 yDeCY1GTds8+uWxJLWE2zu5MZSuegRSGNSC0wOKbHMgYi3duiarlmRq4EouslcbTNzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iPwGQoE7;
	arc=none smtp.remote-ip=91.218.175.229
Received: from mta0.migadu.com (out-229.mta0.migadu.com [91.218.175.229])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FDB606A31D
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 10:04:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9FDB606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iPwGQoE7
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BAYzLGPgGf5837fXM6g/DklP8VVuXY5OJdBGwkWAxDk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793268255; v=1; x=1793873055;
 b=iPwGQoE7VILxHpot2og/jzQBP5gy0zacBVQBG7TQcAJeU91hRwwlXKJBWLArlz01il9yURMu
 ShNwI2kcP+iD7BXhmsurw27sSws3zEEvsAVUeNmySH6yZ3906cNfPiFO+eeYj/JXGdOYYsci9C+
 NnyMaRHvJDfEWvm1bC2IZptM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9324b428c442bf0e;
	Thu, 29 Oct 2026 10:04:15 +0000
X-Mizu-Trace-ID: 9324b428c442bf0e
X-Migadu-Flow: FLOW_OUT
Message-ID: <d06638d4-72fd-4b35-9d78-a2e45856d83b@linux.dev>
Date: Thu, 29 Oct 2026 18:04:07 +0800
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
Subject: Re: [PATCH 1/5] blk-iocost: move shared definitions to blk-iocost.h
To: Tejun Heo <tj@kernel.org>
References: <20261028143534.135968-1-cui.tao@linux.dev>
 <20261028143534.135968-2-cui.tao@linux.dev>
 <3f51067b3d4d549e8414bc19bb612cb5@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <3f51067b3d4d549e8414bc19bb612cb5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Tejun,

在 2026/10/29 04:09, Tejun Heo 写道:
> Hello, Tao.
> 
> On Wed, Oct 28, 2026 at 10:35:30PM +0800, Tao Cui wrote:
>> -static struct blkcg_policy blkcg_policy_iocost;
>> -
>> -/* accessors and helpers */
>> -static struct ioc *rqos_to_ioc(struct rq_qos *rqos)
> 
> This isn't a pure move. The comment is dropped here.
> 
>>  }
>>
>> -
>>  static int ioc_weight_show(struct seq_file *sf, void *v)
> 
> The blank line removal is unrelated to the move.
> 
>> +	bool				user_qos_params:1;
>> +	bool				user_cost_model:1;
>> +
>> +};
> 
> The blank line is new, and 2/5 then replaces it.
> 

Dropping patch 1 resolves all three: v12 folds the definitions back
into blk-iocost.c with the original comments and spacing intact, so
there is no move left to keep pure.

Sorry, I should have caught these before posting.

Thanks,
Tao

> Thanks.
> 
> --
> tejun

