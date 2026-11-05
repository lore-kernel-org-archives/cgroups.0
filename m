Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793899757;
	b=Z2xeaF+Cm866H/9fLYI8eWR3QaR5brT+G5J/zue+ZIFjxtYkFWXPZX45M3wKIfCN9U8a
	 O4oAMRBKNXa1h9Uht9T5fkwya0bYOquqgy26stMyEdVbTBZAu19pEpAYk2+JsTA3xEVU+
	 OSOjjPWF4ZHkCqz+ExVABd7e16yEb0TLquJAzwOPyLCYzAZU/7ZYaWtnVoT1AUcQ7ohn6
	 eBmDO0VySxIkvJom+907hNio1y+/nuQbE/IILWhuKKkXZ1GlOEvs7yoRp8eNtXD3vxnIF
	 1KR4D59Ih75hVwbo+8oqZxiMF9FlakXvkXeziGOlEI5MZi3JQwOANRY+l3x9WONRziQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899757;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1OnqzRsvitQ4MyI4f27p0X1rJF88pgVycPeFzHfgJT8=;
	b=KK293pGfo9GvkqLj0vdszUCG8XtR9axEUBaHx2M7zGKhpHviSc6uFKA27cKRLLlUirOf
	 kTVngZIHO7RMJltBcY1165lp1/i3daoF63mRANLsnvM+692MsJJNvZLdwC/Z6CnUluUJd
	 gPblqjGMxckwGcMv6AXU4Tg1LoKitzAt6lm88GyCm+l2fXTSftm4SpeUYxKKyYXMKcbiI
	 oRO625TR0qUKhNJsJUmFXG0qZDinIhYevoY6nE2SYuYb6dSuKJyLaOx/PrskK6xFTrWfr
	 RN/pMi5TKlWHUDG+Hr6dwMS5AGwEbnFVpvFa2ohnX3c0MremdcVFBN0BDLTUr5eH1zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AiicqOKo;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6C3606A33F
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 17:29:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF6C3606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AiicqOKo
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so20097055e9.3
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 09:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793899755; x=1794504555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1OnqzRsvitQ4MyI4f27p0X1rJF88pgVycPeFzHfgJT8=;
        b=AiicqOKoHaR/wnplxh7tZic5GCFf0bJjuSByayhefFdUTwR3Y4+QtRcQt6KpCMS/4F
         li9JeUxeq92jDKHOKaByhLGOHb1g+x6GxI7jIE3Ld6cTNtguk41MNsSf9O6sXIe2b4j8
         pzeMdtVlRx2lZK3VoCHpgOHelRygmREIl4RVFF2aitFAf9dTDgTNgbZK3cTW8y2L9O89
         X2/eeBAyFe06+RK/MH+eSrAx/z2TBiYpsRZ7WaEbsK2RcG+gJqwmdK5TPPwaiosgYniL
         3ignaZsdRrO8jGFuqekY57xrHNTp6XvHtyWUO18DnsVw1ArJf29ytn121FYVbbwtOPHS
         tJLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793899755; x=1794504555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1OnqzRsvitQ4MyI4f27p0X1rJF88pgVycPeFzHfgJT8=;
        b=lWr6OUFvMlLou8d6IJwlW/vpjpd0Dm9J9hLwSMCeaAcQ9AawkMaDamYBAJh8DREnth
         tLR51IxX080/zajuOdCxlv7wcBOKuGKD9qY5FTHm2vxHtjvI1exCluc/hrD9RKv8ySTX
         Jm9nN4AA5Vmr3aRX7mTQm2q1qdvIkmmk5ToSe1/EYhTCHg72hbWGh33gUe5X4XQ1b915
         1BKmmoYIWpuP856vs2GHZ/L9KjzskcOXtxzfrq4qu9474pqug63QGXzvl8wZQWjB4O9F
         Reg1Pp6tpMzcq4h/O7oVq/K2AczLQeK96dihtn6/WsQt7FotsGoZaI8AuCz7RzrCQ/yR
         g6JQ==
X-Forwarded-Encrypted: i=1; AKwUvByZf5T0cSazpnhSXLR77Ui9vtzj4rp5cVh/GmfNW12BbpDsAhzVGZNUhg1pptN75BCirxSsbLjV@vger.kernel.org
X-Gm-Message-State: APuU4Z+JBiaWIPSI22uo22iR/haJ+FHYhvNI2OyPxxH7iptFFplGGqOY
	ejohjmgjhWCEngzYs57/25FteXIdtz+nO9HA7tmdKRWXGzyJAdX7TyL5
X-Gm-Gg: AYBFou1hkwjbrUr9Pl0UUEzHL5xx8Yf0ubcoEGEb6yZ1KXgZz3bUJHfjQKfCbhU3KtL
	p2cy6Xe+e1ZIWrea9LlHCXnPvtgu9bCCI5gmmnbyAU3m9iAOMnFyvgrD94D+4f5a7KP2XzdGyMi
	4IJRRdVE4N5MhimEbUHUE3MAMn08aI+aZZVk5QdjP5yK6cj/VH1NMMed72GCUmZ2FfupgpFVFkN
	FaAarGxlsoxfOLBouW0UChtBrgA6je2YZW4Bl3KXV+3GgZ9gARgwIxuglz0YMbcpUumzVPq74Nu
	1n+0eioGsEj77tEzN697bX7ZPP6xyxu+SrcSzlSsEJAepRU4dDZgvbF75Xtax9Xrp+9ZBbXWsnC
	x5Anz70CrONao+g17X/3Hs3ssljXxaAFkgx3HsCD9PF/uOPTzXd6+imYKvD1JmR2j5mJZAcudFc
	rLyDmsGPT9T+ONc26mfOsh0YrwNnFwj0en937mKPZrNgHRv8EFEd94g6GnbKcETWKlchqWHqujl
	ZiIRz81WvwK3JL0rfjw87WLCb4HOHUekFHmQjC879iKdCRwELsUipHoD24Ka+y7ir1p5gIAR+OU
	/5C4cDGez+9Azi4XQlQRq+moIcs9YIJIFz7OLE/tLH1U44eRz8wLKXKrlRfzSIU1u9ZKVprzEhH
	ThbHKvww=
X-Received: by 2002:a05:600c:3b29:b0:4a2:167a:c939 with SMTP id 5b1f17b1804b1-4ac17d19aeamr401115205e9.21.1793899755121;
        Thu, 05 Nov 2026 09:29:15 -0800 (PST)
Received: from andreayoga.localdomain ([151.43.242.194])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56e2ae72dsm131080675e9.3.2026.11.05.09.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 09:29:14 -0800 (PST)
From: Andrea Parri <parri.andrea@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	linux-kernel@vger.kernel.org,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Kayra Cizmeci <kayracizmeci@gmail.com>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2 19/21] sched: Clear cpuset_locked where the policy check retries
Date: Thu,  5 Nov 2026 18:28:58 +0100
Message-ID: <20261105172900.38029-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <a63396b0-9b0c-4d4b-9754-f503cdb84098@efficios.com>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com> <20261104211207.1392343-20-mathieu.desnoyers@efficios.com> <20261105164356.28913-1-parri.andrea@gmail.com> <a63396b0-9b0c-4d4b-9754-f503cdb84098@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Nov 05, 2026 at 12:08:50PM -0500, Mathieu Desnoyers wrote:

[...]

> Thanks for pointing this out! I'll pick the preexisting patch into my
> series instead for v3 if that's OK. Then maintainers can feel free to
> pick it up from whatever route they prefer.

Fine with me, thanks.  Please keep it unchanged, with its tags, and
ahead of dl_accounting_unlock() if you can, so it still backports
cleanly.

Thanks,
  Andrea
