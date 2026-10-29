Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793305583;
	b=BBvv93DsKQXjgctBuTX63PPkVYaEN1BcOCMW2yf7v7NFQ3c3I8Ogi5y0ALg4nYYMDdaz
	 IsfymAqqtAjif0XMMWbnlJi5MHeiW/OXeWpiMexS4Ceu5Ey2WvW2gH4m4xevDtHTSAKu5
	 Is3mQcZxMiIAweg4kkU+o1YMukcZZnPp56LPVCRyJTThd4aUbhdKuhlsPq6jNoDFUWlK0
	 qqj8ztwQMZj3YGdvWL3t3XzcrepFDYAAA6mYrE7L+a2YD+vfHQUgpMINsg6JDI9stHq6m
	 cG1hl545oSmBgrtxG468CYtu6P1VSi9SnFczUyu2Vnr5EKwE/W/wd8OmuslzCZI1Smw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793305583;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=+Zf7vPuAui7AiGHPzQyxnXwHIH3exNXs4Kg6yy+enNY=;
	b=Wo6gjKb43HvHn3ZCZ+CCigtVcpppErnHuxwNik8KP4XvY9xt9HgDyeV2kp0iKlnMS5bg
	 1aDrT+W3ya6gNZ+X0xzSpmnH35r30OR/cTi9Gb6jIOEe6BJc4y+vNk2+RXFWOEgoFoTd6
	 fLz4E0Es9WABpdSllfwfRMM+UsZnBeL7TrC5vUuv6LH+a+lrgncviDtW7Yt9kC17E+MKs
	 EPVrAJdLmRRYatPdgdNS8nh6SjfXv3FVcmV3vDZv+EFXbRjthFowgq207j8ga3/4YdelY
	 XxKguPhsYpxaS7Z9p9hodZst7wkJEigKmqJPqMJBFNGWtvzhntRAH85MeWDZyzJCmXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ej4U7WWN;
	arc=none smtp.remote-ip=209.85.215.197
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FE4606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 20:26:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28FE4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ej4U7WWN
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd67466211bso1445470a12.1
        for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 13:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793305582; x=1793910382; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Zf7vPuAui7AiGHPzQyxnXwHIH3exNXs4Kg6yy+enNY=;
        b=ej4U7WWNppvWDCGavjnZ4+M6E6/Jn48wsgNKkkls8+h25IF+LDm197G6K5vHN30er/
         n+gRK1z413vVd5IUdYPKKAfsWoqOSnSz1Or6hLuFPlvZ8BXGVDODHjrLm7rX3vWewZOz
         1C9AI/ZGZIHTyWF3EOMdjYfeIokVyY9u3caIfgxIzJHapi+XOCBRRB2lK3XahbiLFD7t
         Rj7Q0UwxSqGnA02hcO6YJRBi4xGlCcLjC2nLpuP7t/S5Hy76Jdca2Md20ki2n003Rs9t
         2hfPDPYXKDD20N63xsMeZDIjNyMVHA6m9iRsHk6wwwWBiHzj4Tr45Dt+b3/bWXDV1OmF
         vY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793305582; x=1793910382;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Zf7vPuAui7AiGHPzQyxnXwHIH3exNXs4Kg6yy+enNY=;
        b=mFwYT0ynnIRsPVGDgbDnOZvZOdpIZcqi8zBimpsuu/aGBBLQpGbCVOg5JV6dqlzJV3
         Q5ff9tUY9jpMAenSENLWLVHPd0ItTyEC8B2MdqFDZK7YPeVJeCcc4Aa3URN3pYH9GeIO
         SYpniJixlJoKZglUDDOG156mW1/InF6hlsbXwsXa9kEeh3X24t8ZY3zVpRJhhlzZXPac
         LTXs1o59BctQpCISXvKqfy45dkfnoL07Uof5gqqOSmUPTsMzcR56VRlzZoAMvfxRdRds
         yQZYn8WC6VqrqzdR8LNhRFFBqiLiK6xET9yLLabhH5gogudJFceCMQMLetioH9PvHMzF
         0YTg==
X-Forwarded-Encrypted: i=1; AKwUvBxDc3hrgEl/L95Y3dDERPG7TlKSnJSD8X4la4ZH9957dn9GfIAYIatq4Pb/WsJk8imUp+cYworg@vger.kernel.org
X-Gm-Message-State: AFq9FYLDi26X4FRIBHEti4N8Wol3gEF5SYPSSXipMQYSEDPSPKvYgDJ9
	co+fAPCplYa7AON4fbaFsWtj1OmKvHa7Bk3nM+NpMK2ktfkplTH6vrX8QADGNbVgX5Ap92ua1S7
	FUBREYw==
X-Received: from pjblj14.prod.google.com ([2002:a17:90b:344e:b0:3ac:2cdc:a8ca])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b51:b0:3a0:cbe2:9e0c
 with SMTP id 98e67ed59e1d1-3ae897c8800mr87140a91.63.1793305582207; Thu, 29
 Oct 2026 13:26:22 -0700 (PDT)
Date: Thu, 29 Oct 2026 20:26:21 +0000
In-Reply-To: <auOlmxtQ5-EZTj62@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com> <auKSeCFvsWzP-XYy@linux.dev>
 <auKYs_ucslI-tdar@linux.dev> <auKcNvAizn-B92xB@google.com> <auOlmxtQ5-EZTj62@linux.dev>
Message-ID: <auOqQJQUKitt86XJ@google.com>
Subject: Re: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, yosry@kernel.org, joannelkoong@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Thu, 29 Oct 2026 13:02:08 -0700, Shakeel Butt wrote:
> On Thu, Oct 29, 2026 at 01:35:18AM +0000, Kuniyuki Iwashima wrote:
> > On Wed, 28 Oct 2026 17:52:32 -0700, Shakeel Butt wrote:
> [...]
> > > > 
> > > > For the 4th patch, I would prefer we first try to move the network sockets
> > > > from memcg to objcg path.
> > 
> > sk_forward_alloc is already batched per page, and I think
> > migrating to objcg would just add an indirect layer and some
> > costs for css_tryget() / css_put(), and still inlining
> > __consume_stock() or batching in memcg_stock would be crucial.
> > 
> 
> We are over time moving kernel objects holding direct reference to memcg to the
> objcg infra and the reason is such objects can become source of zombie memcgs.
> There is no urgency for the network sockets but eventually it will happen. We
> will see if indirection is really measurable at that time.

I tried it yesterday and saw ~5% regression w/ tcp_rr 10k/20k flows,
https://github.com/q2ven/linux/commit/7407580c37784bf594fede4d6da6b266d8c7a11d

but optimising stats limited it to ~2%.
https://github.com/q2ven/linux/commit/1ffc01395156b278c3d1c9c5fff7b9484f632be8

Given the perf gain by this series, I guess it's acceptable
and I can post it to net-next once merge window opens.
(rstats patch will be a follow-up after v3)

