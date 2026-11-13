Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794554423;
	b=B1xKSnTipA1/RhzF/84e7kw/Rj2uhqWcWIFz8VT6fJG9TQqPP2lpAhJVReRv7I8BHGfb
	 1i6rMyS6DBEPBzCgh/Z+UR1jpqXzF/f/aTi2PC6R2Kpl9F7sL350XSbJZtJ94eAXuNm4c
	 1nxy8VG6ow7X5JqQvPmzBWlHI20W8rQe5LhXpwqG/lqdlvFm5hIotmZ9UeJOrotRsmkRL
	 RpTfJ2l/KxIM75xtsVWPUyn1fichT3DSgpoaweIcHnHfeY3Y7f4eiStVsnnKpKV9c5WbA
	 DYFshutnwL9Fr3cvc0Creuq3ldc+kogstVUi25BwHp4OdEI8XgiMgFnHLGW/oBrfllA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794554423;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=4ukC9+RmyKpMCoo2Ej2X50ZCe3RffRo8JS7sjMrz5b4=;
	b=npCuBgqNWEAbz7LvGo5gZJ2YM8IUKFGx2SCfLR+JNiE8V4TXgXmY7pDrzgrxLm6ydkCU
	 HYGLkg5wVAc3oeNL0ULr5lBGudda2I6R3N1y7FFrwS3EEMACw+N3udNDarsipMdxSXmob
	 lnIFvYDbRr+4RzTWtU4clIGWRwHRO9uH4AGikGyBU6xdCuUzuL8VNQNjcMlMz7LM3R+oq
	 uZ0roeiIRlroRyBE6s4nIqalgH1DODpxojxi4ElYfwDPhlqfaLDA5lT96oQLVtRAVST1y
	 rX9D0IRvVNAKDbqHKN3uQo7ttcCAv41vOcAUY2E/UgPVdIEg9+pJLfQZOm6xaop6fBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=UI+4bgJh;
	arc=none smtp.remote-ip=209.85.219.41
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE39F606A32A
	for <cgroups@vger.kernel.org>; Fri, 13 Nov 2026 07:20:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE39F606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=UI+4bgJh
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91c1f548f87so14498866d6.2
        for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 23:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794554421; x=1795159221; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4ukC9+RmyKpMCoo2Ej2X50ZCe3RffRo8JS7sjMrz5b4=;
        b=UI+4bgJhJNbQhv7pU4fivQjQTQX/aGehNq+O6Ule9LAPUv/kSn+3YzDkzwyt4xo/KE
         FpX9HfqzRh+tmlh2VTaVA3asUfXtHtlE0JM9aPwNIMPqxB8GcjZm7uyxxGGajyQ6+1jW
         Q7ie2diUq1P+2uyPtd41hNiWtCIgs9VWfCpBZyoQm/Y75/mhzlg5SEz4NbRTLVZNYMA8
         ZVN8drMKsYzx5jyJv6iYsc5aw/JIYvGPg1xCesOhxeSz87YUpVgMXl9dAYzqwbX0Jp7w
         R8E1X5RG+MSEQaNiTQDkjzrQeoswpV3AO66T2E+dCiN1dcN8HlW+CaFQJoMvaGU7fxYT
         PVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794554421; x=1795159221;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4ukC9+RmyKpMCoo2Ej2X50ZCe3RffRo8JS7sjMrz5b4=;
        b=gSF7splas450jK/QfLdKjWTBQfNnrO1VDz3LGMs9QhW8NQApC7Y5uSGZKkuMdLJaSi
         eCcWRRjvkeRgHPHN1Q6sTY2qi3Y/Eo5tTbTWfxEe8+XmpV7qIW8wqtgmfWzqHUldxuTw
         YeEXwKkfdYQ35ScQOw/u0dl8XIsX9IOrmjmjdqy3FMFCStEr4li97GcbgJjg85wr6zmW
         Rfh1X9xGwYZr6BIIFIZvDa7ggxAtZ8Q9XC+3IpXEBesycdP5pRXOa28QS4rrk6LEuVLX
         FuuODOLJw7kr92P9betVXkHJ2ZO5NQLFAjc5hmL2oaABQsFWwCFJMibFbKUzRDqLsqNW
         P8VQ==
X-Forwarded-Encrypted: i=1; AL+hErGxuM/tPz4gVpdIDRoQb8gCcL4ceWsoE1xQBqVgjslUDbD5JfYOHolVujxfwgLRYHL8LXMRcVXn@vger.kernel.org
X-Gm-Message-State: APuU4Z9rQwBfc1HnFzsz4M4s017D6OSC3J8Ysq0a/dmZLfxO1X/D/HgY
	DBEY4EG3Z4d+Xs2w/r+aOwW5dX/R9o8mTZdM7IkVq8yfcXBav47bmeMkZybOWIoCU/A=
X-Gm-Gg: AYBFou3E+DKZUmP3jE0vI/au7rqV61hNQFqvj52sqPVEukz8vWcAhU2iHNWwSxD/q2Q
	ExmO38InEQNv8ONehz39aZm2jUDoJ19dDHuqWl9AFim4bgUz2APmpB0Za6OEgL/lhw1/V4oocHL
	yEwYAUmC+yYMYyBbMcd1ttHWzWqxAe8mW7VP598oWxkrsQm1zLI82tlGjXx14crju5oDpmM0Plp
	6QKtJDmUCrhglJ0vulGQUPLAd3LY+wlKlDwIv9M9LyE/um7bf/jDtH0CIOusZpzEU2EZuVZfy1Q
	kH7csYKalmhplnT32cMCD7hgSFgd835tgyaRRMR+O/L427RZz8442y3Fn0yTr+v1Hli/58T5B2N
	QZW79Vpv8uyCXm7WXeXUttZlka5CKLDWkYiirD8bGytOHTtrKyl6eFSYHp1wqa8xLGyXrUjReSo
	MaPrGtcuT55r6Q8wD4JCDs8PcJgcnhFvURkmQrbXwMlXdE9uhcUBlDrtuLcQJg5n568Kpv5kJOt
	2U1/K4I4KI84Y/YnZPsyJPNAbH1uoHTZX0EmOxF5B7I7P+/mCuzvv33DaL401b45RcSrhNJtjYJ
	KwvAiaH/NGvFcQHXx3z0mgaTATOIj2NNys7o0Ys3q2P+KJgKx/zsIwpOBCbX8fcDrRGdzUcXfQs
	dnfjYz1k3JrF0ZYwBfc8QZsXkjFYgUQ==
X-Received: by 2002:a05:6214:c46:b0:917:a1a7:6369 with SMTP id 6a1803df08f44-91f24198eaemr24969396d6.22.1794554421464;
        Thu, 12 Nov 2026 23:20:21 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d614b4sm14297636d6.18.2026.11.12.23.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 23:20:20 -0800 (PST)
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
Subject: Re: [RFC v2 1/1] mm: add source selector to memory.reclaim
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, 
 joshua.hahnjy@gmail.com, ljs@kernel.org, mhocko@suse.com, 
 muchun.song@linux.dev, rakie.kim@sk.com, roman.gushchin@linux.dev, 
 shakeel.butt@linux.dev, weixugc@google.com, ying.huang@linux.alibaba.com, 
 ziy@nvidia.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261102070440.16262-2-lizhe.67@bytedance.com>
References: <20261102070440.16262-1-lizhe.67@bytedance.com>
 <20261102070440.16262-2-lizhe.67@bytedance.com>
Date: Fri, 13 Nov 2026 02:20:20 -0500
Message-Id: <179455442014.482102.4069329165987986914.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-11-02 15:04 +0800, Li Zhe wrote:
> +	Specifying a source value constrains where proactive reclaim applies
> +	pressure. Currently only source=nodes:<nodelist> is supported. For
> +	example::
> +
> +	  echo "1G source=nodes:0-1" > memory.reclaim
> +
> +	This reclaims memory of the target cgroup resident on nodes 0-1.

you buried the fact that you want to allow source=zswap in your cover
letter. I was confused by nodes: was needed here until i re-read.

As Joshua mentioned, i don't think you need the separate cover letter,
and I agree this is far too long for the proposed change.

---

When I asked for testing, I wasn't concerned with the functionality,
I was asking what problem this actually solves. performance? fairness?

Shaping the distribution of memory is neat and clearly works, but why
does userspace want this?

The interface "lacking flexibility" is not a problem in and of itself.

I CAN see why you might want to proactively shape what data is swapped.
Let me give you an example:

---
The global node reclaim interfaces allow us to put pressure on distinct
nodes - which lets us shape which node is swapped from first.

Example: node0-1=DRAM, node2-3:CXL

  echo 1G > node2/reclaim   # swap from CXL
  echo 1G > node3/reclaim   # swap from CXL
  echo 1G > node0/reclaim   # demote to CXL
  echo 1G > node1/reclaim   # demote to CXL

But the memcg.reclaim interface only allows us to pressure the complete
set of cpuset.mems nodes for that memcg

  cat cpuset.mems           # 0-3
  echo 1G > memory.reclaim  # makes progress from any of 0-3

Presently, proactive reclaim iterates nodes in node or fallback order,
meaning it attempts to make progress from the fastest node possible
first - which attempts to demote by default.  If the lower nodes are
full, this demotion will fail and we'll swap directly from the top tier,
which is (presumably) warmer than the bottom tiers.

Enable source-bound reclaim in the memory.reclaim interface so that user
space can have the same control over memcg memory tiers that global
proactive reclaim has.

  echo 2G source=nodes:2-3 > memory.reclaim  # [z]swap from CXL
  echo 2G source=nodes:0-1 > memory.reclaim  # demote to CXL

This lets user proactive reclaim to target the coldest memory first
rather than preferring to reclaim from node0 first and potentially
swap out memory warmer than what is present on a CXL tier.
---

With this, you might be able to demonstrate fewer refaults and less
DRAM (node0) memory consumed by zswap. These are clear benefits.

I would argue that memory.reclaim should operate this way anyway,
and that would could make proactive reclaim do this by default, but
I could see the policy bits in userland being useful as well

Performance may not be the only reason you want this, but you need to
help me understand what you're trying to accomplish.

-- 
~Gregory

