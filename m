Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792678313;
	b=SXHULFXu0uMH6VE12EAFGqSD0puHH1I2/7QLZd2Iog+kj5TB5cQvAK4bWJ7DVSBwufC/
	 Pl99Orms1yzkPiYUL5IbCaWqiYwAHyQyOLoztfqpKLd/ZSSRxMdtVhcggxTEjH36Kt4Xv
	 wmm21nqf+vPcxlqEpcvNjRD5XjUjoW6e9YxO1iRNG80srVhPSo9H/H+pzkrtDCIJWGqyA
	 P9uRLbwewhnz6/EIFe+03U0arDBS5nOx2kAuWPm8UffKxWDwZgGP5sEtOikaPmKgEQ3ye
	 mDYrdnZGkmGXJ5WEIxXSnMu5VTzNx43ejU4PclMhcqFiieTQts6sRB1ZOsCfTqjml0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792678313;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=J0ObRZqURp05kcBQ0Zv+pu1j99ivc4QOppayGe5sXtU=;
	b=RosTVMSeiJcYfnxOHVepUCRfXy87mc0QOm2vK2a7DikUnAWMvG823hsmS0laMe0u7hPM
	 ofDi+hmFbbFElTsLoSGFaVw53KDTh4om5OUEmU0K/0F56IjHTK+ykFgbVBA/OMchpf52q
	 ljpof6B/ap/Ssgxhwe+7UCk+ZNMNFA7IaqOF2xu/uh7lF/R9pI1AtX+42HWjhXXqpRZjj
	 3DYSfPVIeVFD+c1heGWmhy8t+4Hk1ByWp8UCBY6OwsE/dZHshJ/Dw276VF0wG6tGnQQwQ
	 kURs0jQ6stxQ7GBr6QEhanoAltXu7Gz5hJ3VGcLuhIlXRDVMdzsYzJBxXh0+GDWTejg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=hspHbGix;
	arc=none smtp.remote-ip=209.85.219.43
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DE6606A321
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 14:11:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0DE6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=hspHbGix
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91b9e758c50so14597226d6.1
        for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 07:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792678312; x=1793283112; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J0ObRZqURp05kcBQ0Zv+pu1j99ivc4QOppayGe5sXtU=;
        b=hspHbGixeltXLiUWFKLsGHAgMKVn7rvek1mOKEilJTb8bqmvEgcqQyqX4UGFtDg0pK
         QQUrekoQdgImuSvigHwv42IcxDuOq2ghijqvNxgvS0lHBE6gcsdD8/JToNc8NHgkPGM/
         arEC5Ve8URC/4X3t4fGtPrWhiZiZ80aBMkXCwBKodF6s9uE/XC13TdyLK4U9DIoROqsn
         CWPCMQBu0Yd6Q8tqnH5rbDQHxGF6r9+MCJsMFTcqG+vtzsOIHNLFTHEE+kug9BdMuLy7
         G1d33p5icriK711BGr98viLfaK0ljpYlV9bAAaDA4rQIvyxHY0shQj9W8sKEFT+eLi0J
         tzaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792678312; x=1793283112;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J0ObRZqURp05kcBQ0Zv+pu1j99ivc4QOppayGe5sXtU=;
        b=OG/TEPf7zpTBGZ2SDFufgw9fc8Bj2/hKTSNAs1ulNnC+Jvx9ttlyk3ImNHbf/qfPi6
         Kd8X0xnux/+TS0fF7hh/9I2CPEvxcuwLpPj/xmZ3U2wf3wpeWWKVw71OGH0cW6C/h0b6
         uuTbUGNo4EhFg/TYWqyUZ983sGpe04HdahPvwDovnAipi6L8CXYZKmlfSaGwqGguX+IH
         EnVoXEn4z6/LsQeVdXza8HYPVK4zrvSYhqCb2HNykcYjnkPDI+EUfnEfdmOa+65UrCy1
         v1mqZeqbOebxqRdhPe/SOj6ze0u7qdiMoYMtB3QtGKA3cYMghmYq4ack2AGesLDQVEd2
         xEvw==
X-Forwarded-Encrypted: i=1; AKwUvBwtkvnL9SLgHOk4hDblwMKjJFZZ74izJ8hnyRA9RdKk/R5x7oNxdeM0n/oTHwIugYKs53iy/qXt@vger.kernel.org
X-Gm-Message-State: AFq9FYLG7sODXaA+PC9MNCw3kJcvudbtQMJLMbXq67IxvbuTT9hd6EUw
	7GLFQwPij8ZSSgDNNRPmM7BzsoI/+aUPfGv0uXrMwYtBuec+PL/37b++yZtY6iZy0qE=
X-Gm-Gg: AYBFou2yix2zWbyf3O3jxkNxQyyyw2xmOXpLm2v2U0yJc+jXCpwAH8dde9+PjEHVNh/
	0y/J4Y0H3kOe4imYtDV1bU9tLFIJp8bR1VaeafBVx5pxE2CMbNYCUYbK0U6QyrAmPI2KjsNYjjl
	6TV35I5KEtFpZPdMBeo3pwdUC9TTTYF8RnUsOszcWyT8lWgy/i0Gt1WrcM9tqDrJIot6Snjnscm
	1B+xwB75QeYByLYFtGVZccTPiLLzocPIyN61AKantZtWiVOZPSwHvVWKSQqq0wxA0MQcS4tSS5J
	sSXRO1TmXy4r/nwQGEhnCx9vebqQpNVPfIjOD2FgGrILnn7L54+v06+pfn+dun1KcwGOwSpE9kF
	s/Vu1OjYI+3KQRAK/Ymt56PaCXbyRHOppJfq+4tJRehWWUHd8c69SJEEknthoC0t0rvm/d962rb
	WKxSt79S/ZJrbgdmY8nuxQhk/9GxaE/X5K2fEuSo6egwFrh3XGGXzA2KCMA4AHMO4xCR57DAwkv
	Hgvqb/J+FjHL8sIWxFK1EEdChdrVrjY9sSEw7KOD3Z/u7GmFVp/UW28axm/1TRgRz1uYzuhIILt
	uEM5v3cB/7A1dgu+jsK5+Y42IC4HIOZuaws3qQ==
X-Received: by 2002:a05:6214:29ed:b0:919:57a8:7537 with SMTP id 6a1803df08f44-91c232e5013mr44009236d6.18.1792678311640;
        Thu, 22 Oct 2026 07:11:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10c0bd4csm51371086d6.30.2026.10.22.07.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:11:51 -0700 (PDT)
Date: Thu, 22 Oct 2026 10:11:49 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	ying.huang@linux.alibaba.com, ljs@kernel.org, mhocko@suse.com,
	muchun.song@linux.dev, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, weixugc@google.com, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
Message-ID: <atoZpXaCRc7etPW8@gourry-fedora-PF4VCD3F>
References: <20261019141401.11927-1-lizhe.67@bytedance.com>
 <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F>
 <30457046-a662-4ff7-a6a8-100398d7a806@bytedance.com>
 <179264138036.2549665.17429111144570830454.b4-reply@b4>
 <9b715272-3ed9-42da-a6ae-467e8ae00c0b@bytedance.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b715272-3ed9-42da-a6ae-467e8ae00c0b@bytedance.com>

On Thu, Oct 22, 2026 at 05:43:49PM +0800, Li Zhe wrote:
> On 10/22/26 11:56 AM, Gregory Price (Meta) wrote:
> 
> So userspace cannot rely on one write to memory.reclaim to produce a
> final per-node distribution. The intended usage is a feedback loop: the
> controller observes the memcg's resident distribution, chooses the source
> nodes it wants to relieve, applies source-scoped reclaim pressure,
> observes the new distribution, and iterates.
>

I think the critical question is what CAN userspace rely on?

We can make a bunch of feedback loop interfaces, but there's no
guarantee they'll actually be useful.

> >
> > At the very least i think you need to add details in your cover that
> > demonstrates the process of doing something like per-node resident
> > ratios, and show that it works as you intend.
>
> Agreed. I will update the cover letter to make this model clearer. I
> will also make clear that source=nodes is not a final net per-node
> footprint guarantee and does not change memory.reclaim completion
> accounting.
> 

To be clear, I think not just making it clearer, but if you can show
some tests that demonstrate the reliable behavior of the interface
extension under different scenarios - that would be compelling.

~Gregory
