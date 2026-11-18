Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794973128;
	b=Jt6zwI6wByccTHrzI26lM/inhjyz8ILl0LGnlfBfgMPTFxk0IXRu8jYr0Igd8YzUWlAe
	 cBe62uBCLtpsK4xU9eqUepymWyfLP6WRgywimosMyFtMScJVgzn6fOR4DuGdr4Vf3UI3c
	 2Y3y6x4ydAhYW3FFsjT993ky069qmfu2MKuAjxarr7vtc1Km4DANrjTtTIxSPFbD7n+Ky
	 iBeSwioEtbRhV543ywXC+XgXiF1P4luNs7MlARzkopu5Qba23FTh5EuKz1XbzsScvv164
	 MtDpUgE0IDAi5DXPwXFjBXTwqKlrmuTXZLAugnnfMmVNTetFQCPxPb0A02hZVJnVUcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794973128;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=Kvmn+xw8fMzfurQj4tJUer/fYr30jKP4x1tcbpp4Ht4=;
	b=z9w2cSIrNIUbU3zdMuHvq6vP/pobT9ZFn0flRuc98XFCZJYxgaGbsl0dei7/OhHaNWDe
	 fyK1QUbE+P0HpoLIuyPLlMXO8b2xG8sSeIPZJB0lYb4STP0JIjQzk8FeXgw1V8FYO7G7p
	 V4f1t+JJfIWIOrQFjoYFZAAhJPDQusOeKyMtZyUF1zQmF1TsMM9yL7Ame22GrFE6SeyWo
	 4miaZClx9YeHBXckkg/z51Gg8rdzP2MwtDAFlUWk/rLgxyhcEdKP99nd7oy2v+5iAiL6d
	 ofsobUGTYtJuJpOvtX1SvRbdBh9rAC6RirjAT6WWrMdlkgNUKsqpncM9P8DiSnNUJ6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=IfmRfcsh;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF3C606A32C
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 03:38:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAF3C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=IfmRfcsh
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-380b40319bdso950173eec.1
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 19:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794973127; x=1795577927; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kvmn+xw8fMzfurQj4tJUer/fYr30jKP4x1tcbpp4Ht4=;
        b=IfmRfcshEf8CC2x8ZQabjNmG5gsCHR8OAyUtXOaUA4Luli9y7mZZBExDxK8bPLb6Zd
         rac2EJ4N6fEvhpBJDmWkpYnWbeIl08HM+7laGQT5cBlru06kB4cFZA9zPjBO34lNREZV
         78QFlxDIg5xGljN2NBs0N5kiQMWyWvSEK4+Dc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794973127; x=1795577927;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kvmn+xw8fMzfurQj4tJUer/fYr30jKP4x1tcbpp4Ht4=;
        b=225syS4wK/hvondvobh6z9vFnWOQPbODD1+buPZlKWl3pI5i5l06knGDZ6Mxc4WO70
         Z+nvu1iqDNsaFS0X5SwTY42UzpPgnJnAzNnmSx2d4j3qIT97O26ay6UVkavo3kYom1ZQ
         CW+p8aFaiyD05fz23DY+8qb78BRujfP5ea4o42S5XXzdhQ9WxB/VPCH3Vc5C9/X6DjqE
         8h9A5dFNQcjtc1z7IIhTfozplpZ1Dspjewqbio/UZtioivICnoQNUmfyQX6+7LZRq6+D
         cpZRdqwhBW0rhQ85gV9ICMLJ0Y0Opepo0kwQboiZ0COFqJKPemry/7R1xRFjFBWxjsjg
         hyOw==
X-Forwarded-Encrypted: i=1; AL+hErHqn0wlp8MxtknQkcuKXxYpv9/k75WpRy6SIjATSffNApFn/4BDh9QcVm9M5irDrlgKLUzS88xp@vger.kernel.org
X-Gm-Message-State: APuU4Z8sy2tvQ/ifniRRA5nVPLF8IoGJ9PofBz+sXM9DkHfHvlHk4sWb
	HsSesM7Gbaq/oSNbFUA2G79PRgBkkgl0PYHGiENpo5o1l1ooEhCQirQYoEGJjuiac9w=
X-Gm-Gg: AYBFou22hw6XfIjM0IGFxpiEYkdnheDKLuIl/CHR8WVPfvAsIbiaWqjnCTF6idsTT53
	hAIRpISPdlEBD99qythgOEWOL9Ms8BVgs0En4xCZqeCwxNXJGh4ksdcg47pNHsy4R7+WY9EKk20
	aeMcAn+6goTssKwqUxeP98Wb9nIcAjI91pLfPJBG3hLf+9JIDnDqSaarIDGXpv0zdyjH01T1EKO
	LMs5FPJhhSMAEDz+L8A+pwcGPLfLCYLeyATICBBUjeOUOtGKikWidrCEAVyTdbD67vYQjbiowp0
	mEyV/mPQxVHCGYmOACq8nIwPy3d3dr56FQ4nnkAd88+sx/AblZ5KGRdrsp3GJB32xdeeXfWGgly
	uOUfU2TNISRzVuAPEPK4PdRQbsO3/2n1ilvqoH/xIarncM5rTSWf1MpMZ0G4Ri+KC4CgkwSQuWA
	BoIbtAChbiwmp6LXGSSEKDxEHJ2nFsO7PaEjk8zdwzRb6bCuOrjlvetk/9hLjLLuOX7tTXwgc53
	8iOqJoFfgbkFa0LyM2zs+Upkir3wIKzWbJxLGO0dhhac0bGGY+MSVdJXz1EtDQsIBGmXYIO0GWl
	Qj19tGP0Kg/p0RddgobG9F5l7NLhGG0ahUZFsPYZNG6lppn9cT8hV9ob6LVD/seW7/HhwichDSb
	+N+GJY3owjcPkzfZTL2JPy9WpKORUI1Ki/+KWZxnV/MB4+Nl/dVhIvJ4bZiSRthSDP30O7ebvQp
	a4YyJmVZ5dFnfp1A4SzWpkp2usyBRFql/qTWJ36qOXP9afc98myCUgqLbe4CuXkco7
X-Received: by 2002:a05:7022:fc01:b0:1b5:1a6c:af64 with SMTP id a92af1059eb24-1b543bcd4b2mr1258863c88.17.1794973126774;
        Tue, 17 Nov 2026 19:38:46 -0800 (PST)
Received: from [172.20.0.2] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a63059f8sm4907822eec.9.2026.11.17.19.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 19:38:46 -0800 (PST)
Date: Tue, 17 Nov 2026 19:38:43 -0800
From: Chris Down <chris@chrisdown.name>
To: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Cc: netfilter-devel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>,
	Zhang Jiao <zhangjiao2@cmss.chinamobile.com>, Song Hu <husong@kylinos.cn>,
	cgroups@vger.kernel.org, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Alireza Asgari <alireza@asgari.net>
Subject: Re: [PATCH RFC nf-next 0/9] netfilter: nfqueue: account queued memory
	and reserve capacity
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <av0dwzvTBXXLqWCa@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Alireza,

Alireza Asgari via B4 Relay writes:
>3. Whether the proposed bulk reservation interface is an appropriate MM
>   interface for this use, including the explicit restriction of charged
>   growth to 64-bit kernels. Is this compatibility tradeoff acceptable for
>   the initial interface?

Hmm, I don't think this needs a new interface. obj_cgroup_charge() and
obj_cgroup_uncharge() on the objcg you take at BIND already deal with root
ownership, reparenting and the kmem statistics, which is most of what patch
4 reimplements. They would just need exporting.

>4. Whether non-reclaiming reservation growth is the desired failure policy.

I don't think so. A long-running cgroup usually sits at memory.max, mostly
with page cache, so resizing the queue would fail with ENOMEM even though
most of that memory could be reclaimed.

>Increasing capacity obtains the additional reservation before publishing
>the new limit. Failure leaves the existing configuration intact. Shrinking
>preserves queued packets and retains page-rounded backing for the greater
>of the configured allowance and outstanding saved charges. Excess capacity
>is refunded as entries drain, with refund work serialized against resizing
>and coordinated with queue destruction. Refunds settle the actual memory

Keeping the charge at the larger of the limit and the bytes still queued
makes sense. Otherwise one could shrink a full queue, charge the refund to
another queue, and leave the old packets uncharged. But, unless I'm
mistaken, the excess doesn't have to come back as the queue drains.
Configuration already runs under the nfnl subsystem mutex, so if the excess
is released at the next configuration change or when the queue is
destroyed, it looks like mem_work, mem_mutex and mem_stopping can all go.

Thanks!

Chris
