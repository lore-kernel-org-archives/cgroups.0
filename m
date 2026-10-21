Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792549417;
	b=bzTp9UfAlIVjWd6JkU27UBPY8XegqWZNiEd5tWQrDtV5aYeP1ouf1VW4YkAb1F5gx7Nx
	 Fth041+gkd/isKe0yVmki8Xo3piIVbQeJomHX0YYPDybx5t1bb0kJTa8dncZz476Ti3X6
	 rotMMb37KoC//qH48jNVaP1QiPf6/782+5cnzVSvmmwU+Thndyoyr3JVYJB6oLoIQLaiI
	 kodkCpCNwK3fRw9c3ZyTTLMrfFZoRqA6ITydFO4hao9csFHED2P0IzJQe1ITdV1sRaiuU
	 62bXbUyTHdB1Ownt929+PkzE6MhJbS/mmA3+QmaQV6P4AMplMCMSZfAX36weMOaEbbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792549417;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=ouuFtypaEJ9ckJXUmMEhOp8/mEcn0FyKt1h6MgNlrj4=;
	b=eH2lzpjLqdXeT5G01evc4Y2P/ouWSE2ljDd8YUKjfcoaWrSKXafMRyX0X1qsfoNce5bm
	 6p6/q8DIev8qd7I7sKxk6Ssqd4BpxNFeR4aKnRCX69sC4GIXwrmk8FgsNGekROXlGZ/wv
	 0HdZRKnhslSugdX4dwHBvs5Y/4SEGX7i1SQ7cMzzKM9wNpxr6DYDdrYFEuSEJSQ35gQIz
	 XjCsYqhXrbTuTgmLScyaSIXJgz4MO7jlEUILgRQpdkV1iKAlIr5hm+JSf3Ie5aXcNBXga
	 Wq08ZB/no4NL3kj7KBLvPF/qIzF2kSdZoYsX9Xwjhox7RNJS8VV3ZIiQLYLDNJERMcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=mvTRJBiN;
	arc=none smtp.remote-ip=209.85.222.175
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1A7606A31F
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 02:23:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD1A7606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=mvTRJBiN
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93cb9e9405fso10738885a.2
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 19:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792549415; x=1793154215; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ouuFtypaEJ9ckJXUmMEhOp8/mEcn0FyKt1h6MgNlrj4=;
        b=mvTRJBiNayBZ832CCECJySz+ba/5fJXFzuDem1u7b+ZYvUSUNCsDV9z9w1eSMNPqOh
         wQfrXPnvUwf73h8+wZr5mR4HHDf0uwB+bzUjRXnQDDjCeoHwhrRoMviHfsKae+xXqk68
         MACjf9bd2krFLykEoKwkred2e/6I32/5xwEw7sv3wpvdXlPtzBVy9CVCMXJzsQ0vKxJK
         iL8TXTsz+O5axi5LOdJi6hdyulbqG155qB0x0UUy9QRNdXmW1UBpBPCwxML/AKOMMqlD
         /tAD7DVi+Cs7D4C8Ru4uy75DOcwvkAWYE5oFwnxtSe4AFxne9eNB4s/9ck75elf/q9GT
         7JYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792549415; x=1793154215;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ouuFtypaEJ9ckJXUmMEhOp8/mEcn0FyKt1h6MgNlrj4=;
        b=z/XmUJwJoclX3VcvAMMOxdWyqsULdFohOHpsC4jcITxKPXwhQ0+9mzXCBp97htvfLr
         D02rpU2hxG0XnNNQ8kF8jQtq8S9Q5FWUPu6DfMPJduEjc+PR3m5eWQWHvkI3RJTgHsOX
         BlZdc3Vi89PDO/9Vnvb3Bz27l+JlX/15vgl5kWWmTsusLviIhRE9Bq6pYx0c8BNNyzPl
         AL8xyp3jIbNN72eMPLKaan1q6EDE9801NqaU3P1eTc+3eLbZVbNi1kdsYN9OswWKbXlr
         h2Ym5Sy22aTVPBmX+uP3ejTK/p6+dVQ+/oqdrizyQz4L560v3Pzl2JIEEkiqi8AmFZMJ
         yKQg==
X-Forwarded-Encrypted: i=1; AKwUvBzp3KVix1/OFvpUiiQ4Uek8z4LSYHqsEjiHhvALQDECIC/1u18I/QGB70yDRBFjWrTQwyaS3k3G@vger.kernel.org
X-Gm-Message-State: AFq9FYJlUwFNmgJVjp8LRzmjSAoKVvBwMD/Y2ZZz0ztyEiB2YiWB3exu
	ikK94QC1G/bFLVn4XfK8fGBPXE7EA4C+vSSoo3RnBItKqvVVdz7EQTFghSS1PRwXZ64=
X-Gm-Gg: AYBFou0bAca9kazWY3r+mDH3zsGdrghuphfJPvsPtQHSPw/LXzl+AMP45gTX+uxoMVV
	J9VGdDAEDHzR8p6D1rVXZi2aps8ZO59QeEqqGtWCqzioLqwtkGNhv8wTicOjNe1BUwRnIkce1+2
	CxtBVbuO5h1ZZBM2v2JNpBjGnvoYnbQN4HL+SdH05lXtaKHOW9RUd3cRHxhA9DhmC5k/IIYZ6IG
	ql+OVGmD8A3i3T5ZzJL77KMofyun0D6h4gbVzV34g13m4uJkbLgChnZc1bFS4S/YLg4EfEfEk1X
	t+YPlRp+zO+flXBT3ON3z/Phg34K3ye7+AN6K+8f8yBoRA/fmN34NYRBT+OK4gAUVMJs+24p/lp
	0xtfgMGjMV6Ko+jZLTe8D9aAdKuNc38Gu5YrrhNwBrtCz7Mq5W07/B4f6lcntjMbE89ZqEM8QkN
	qDyTgTrr/Si3L2PKQEYDnBu0hdKoY4/Ma3xd9oTuEMbd7Tx2v/mgrvyXMCd+xEn8YtwkgeOeEjy
	kIB/xAw0DH/ZX/zjq4XcA7JTGdMke4L7HRwU816C0TZvjJaJV7Lc9favTVHAIIBEvFMh69sfYMs
	OLZM6R2b1IptL85TcCVqsH6f0IHM
X-Received: by 2002:a05:620a:4621:b0:93f:a7e:e0f0 with SMTP id af79cd13be357-93f57fd3b6amr186072885a.82.1792549415263;
        Tue, 20 Oct 2026 19:23:35 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56de57e8sm135743885a.25.2026.10.20.19.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:23:34 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH v3 bpf-next 1/5] sched: fix stale get_pref_llc()
 stub for !CONFIG_SCHED_CACHE
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
 eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
 juri.lelli@redhat.com, vincent.guittot@linaro.org, 
 akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, 
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, 
 roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, 
 tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, bpf@vger.kernel.org, 
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261019064157.29885-2-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
 <20261019064157.29885-2-laoar.shao@gmail.com>
Date: Tue, 20 Oct 2026 22:23:29 -0400
Message-Id: <179254940965.1919196.7604748267690139512.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-19 14:41 +0800, Yafang Shao wrote:
> Commit b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp
> to fix UAF") switched get_pref_llc() from taking a struct mm_struct * to
> taking the task's struct sched_cache_group *, but only updated the
> CONFIG_SCHED_CACHE definition and its caller: the stub in the
> !CONFIG_SCHED_CACHE branch kept the old mm_struct parameter.
> 
> Fixes: b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_grp to fix UAF")
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Chen Yu <yu.c.chen@intel.com>


Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

Please submit fixes like these separate from your series.

-- 
Gregory Price (Meta) <gourry@gourry.net>
