Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792533815;
	b=a0A5FWQ8krmVTubUqXME/Hx1VmwbVtOEhwmgipA4oItzB9gAMZrneSSd+DeUuMttgy3L
	 xj8H/wR9ZHYJYmNpcmIXQKkb2NY8ju1BsFtDS0NCkTsvUj8v2v7XvwzbnUz6GbValA6Sa
	 YrJYnz5OQbj5WToOr+GMqi4N/OYlPa+kRsXZ4hvvXXQ2buKVgbh903xgRMGiY3Z4IhhSs
	 SRBApaQWRvVnsAaYZ/icnaPWXPexEGZJmQQLuCWLT5m95j0Apqx5VE0cG6Teo7df9He6R
	 D5f2oomyRP5IFMxStBugkVjc5Rd6XtLAXDWREhRrizvd8hkCHpQ0Ou+NVEAz3recabA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792533815;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+dby3oqMku+pe08nNb3SVcKfzQbLv8VO0Jweo3C76TU=;
	b=BHbkBkTkLaDaSpRg0xSN0NyqoueXVAhLGKAaiM+5iRFZvelOx8DR1YV0FE0OUj1qc4wh
	 4kyRYatY3CNw39uV80PCAPWLi7xhc1kGKGJHVsvhKuS2uOpTuDFoZCrlxWnfG+Z15PuQu
	 jvPZG1mXTl2NLzfdLh4SXX5qwqsK05C/k4w6o5xe/zcgYVPeLa3DDqohGccCrkgrxmf+d
	 7Z2MPXqzr3I+y2uXjPI9dF39VMCNRjUBlb486VhQFyyJSBo6wb3PHv+xFrfh49zkkaiww
	 t0MnuyZqXYIXRfevWI13+ThB+7jcMpcBpQh/8qmR4kCI1G+Yz9Y2rffyZrZ+2iOJJ3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bwMeU46D;
	arc=none smtp.remote-ip=209.85.128.178
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D100606A31A
	for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 22:03:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D100606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bwMeU46D
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8ab43af5e97so1347157b3.1
        for <cgroups@vger.kernel.org>; Tue, 20 Oct 2026 15:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792533814; x=1793138614; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+dby3oqMku+pe08nNb3SVcKfzQbLv8VO0Jweo3C76TU=;
        b=bwMeU46DSpMaL+E6BqdBfQM1X+nhJNew/stYea3NTaaDZpNMxczs2ExuZDRUYrYu1L
         HFvyQt95rXzkohmpRrgBFYSLBrre7BytFYppMXmWYY4vJGalc3WO2HiadaAADOgdSsAs
         EG5L+pa+8QAnWju4iXY3gwEJtbHx7yXnZVnPXQGrTi9KYo2ROFmpTpkOZJgI3KW4RV2q
         pESuZbnNwrmRpPTY2hmlfDTQe2YT1BILU8EGiWFUmU6U2BeQBsFxBYa4aJsVMReXsABt
         f0SGVSVvSNezeI3/4byB2xiyFvVhuBQN1+aTxdGJWA3w5JCimYVbEoXkS0JdMJXpN6Uw
         mMAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792533814; x=1793138614;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+dby3oqMku+pe08nNb3SVcKfzQbLv8VO0Jweo3C76TU=;
        b=v+hNT5BYEC2+47RC+tbRM3LwkEU/0d+Wr5GZFS+z7J5yrPsc8TsN1bJDzTZNZymxCm
         TXjKMfTkWk/I1ERIbKTz5cR5CQ1ETrA5wVAh2WxAco4pj2nK4PxqLHHw5UKvQx0RYawZ
         hsdJ0SnDjR6aco4bQSsyGHzYMA069q6eYceoH9QoxOs6PbA7LbVyCQ0KtK80Ej497JdC
         otNcsFZIACycsGrqrUKfvG/WvjCDKBWKMlBcVnZPrBOA/Ds88LPVwMeXNeMDlucXLhie
         ypVtPbDyBz/2RnzfTghnpVIAwPQYoeX2IWlOFfpMVncPPumxpjOk3bg65HadAkH4lU9W
         jF0A==
X-Forwarded-Encrypted: i=1; AKwUvBzrBUf4eSiqXqcPex/uMllvjL7DFiDb1Qh0I+ZeRWmnROAEpbZR986jjayCkRqts1ro6BOfcqRf@vger.kernel.org
X-Gm-Message-State: AFq9FYJ+xp9hSk6anZtKdAkfi2UsFpI0UrKdSiHyXL4xS0tEgC1+83SR
	pxfRk8p+KNVZYqr1l2NctsMrEflhsMGCrQj3cAsMduyM+hv1BQLzID/S3Yk4/Q==
X-Gm-Gg: AYBFou1zeG89KvgIqzgXdNdnmu8Ex2hTyzpUKDiO/Brgo6gIU2Q8z7Xno6kuGWG0IXR
	FiXJbbTqlVya+D8j791mKs9eTCdnF7T9x+9bzxm6YrpqSHo6Ue7wlg8XrPbJ7GHOxJn/BPeh7fh
	vFkUPq97RcwAY0e/P5ZrLjnGGCs63vuKGChgekcLaTL9PvFxb5dpgd8PXhHkseEj6UIJUG7DwiO
	srsiDNv6WUl2C+Tc63s1xv2eR3aMZ+rUy5r7Jr9n3BaGm4J4ZKtBQO3NaEDeSMsqba9h8ZazHGB
	Kit1B6PVyQXblCDDhbCM50btptaZ7VMxgAYHNCQ1Z+59lpaLkYQ7R/RuQi9vIdpmG7uHZWVWahU
	HltJ6Fbir8+Oy/Xiwcx0fySAf8wEbWVRNaDZUjPAiMxBQVN/SHYahOn37z50rLAYb6wghc/xS/i
	0XWxM1bnBUJfrHvHw8y32WtRk+I1iaPbbN38oBCRrR1RdbF9VW0hjUY745HDxY0UXtObt83aL6L
	eAyLIXWgM7MDwB26jwa0kuY1BRtPw==
X-Received: by 2002:a05:690c:a:b0:8b0:a30a:7f31 with SMTP id 00721157ae682-8b133dae495mr1678197b3.29.1792533814287;
        Tue, 20 Oct 2026 15:03:34 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5d::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300eb0ecsm3660387b3.26.2026.10.20.15.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:03:33 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: publish null pointer before dropping css reference
Date: Tue, 20 Oct 2026 15:03:27 -0700
Message-ID: <20261020220331.2641416-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atfMngq7nyZpt4u-@linux.dev>
References: 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 20 Oct 2026 14:21:22 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Tue, Oct 20, 2026 at 12:35:31PM -0700, Joshua Hahn wrote:
> > On Tue, 20 Oct 2026 12:03:38 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > 
> 
> [...]
> 
> > > 
> > > So for drain_local_memcg_stock I agree, since FLUSHING_CACHED_CHARGE
> > > is set, so you can't have it concurrent with drain_all_stock since it
> > > will skip that stock. But refill_stock also calls drain_stock when
> > > it evicts the slot but the flag isn't set, so is_memcg_drain_needed
> > > can read it at the same time.
> > > 
> > > What do you think I should do? I think reordering makes the intent more
> > > obvious and maybe it's just me but I did find it a bit misleading at
> > > first that we were dropping the reference and then publishing. 
> > 
> > Oh and just for clarification, my page_counter_stock series actually
> > gets rid of this codepath and switches the order when moving it anyways.
> 
> Yes but this patch has fixes and might get backported, so we need to be use it
> is fixing an issue which is real.
> Let's try to reason how the race can happen between is_memcg_drain_needed and
> drain_stock:
> 
> CPU 1						CPU 2
> 
> drain_stock
>   WRITE_ONCE(stock->nr_pages[i], 0);		is_memcg_drain_needed
>   css_put(&old->css);
>   /* assume full grace period */
>   						  rcu_read_lock()
>   						  memcg = READ_ONCE(stock->cached[i]);
>   						  if(READ_ONCE(stock->nr_pages[i])
>   							mem_cgroup_is_descendant(memcg);
> 
>   WRITE_ONCE(stock->cached[i], NULL);
> 
> 
> Do you think there is possible race condition in above? I couldn't see.
> 
> However I ran this through AI and it has convinced me that on PREEMPT_RT, this
> is indeed racy access.

Wow, thank you for going through and doing an analysis!

> AI reasoning:
> -------------
> 
> How it breaks on PREEMPT_RT
> 
> On RT, local_trylock() takes a per-CPU spinlock_t (an rtmutex). That is
> rcu_read_lock() plus migrate_disable(), but the task can still be preempted
> inside it.
> 
> 1. CPU A, refill_stock(X): there is no free slot, so it calls drain_stock(i) on
>    old. It sets nr_pages[i] = 0, then css_put(old) drops the last reference and
>    queues the release work on CPU A.
> 2. The refill task is preempted (by a tick or a threaded IRQ) before it clears
>    cached[i]. CPU A's kworker runs css_release_work_fn(), which calls call_rcu(),
>    and grace period G starts. G will wait for the refill task, because that task is
>    inside an RCU reader.
> 3. CPU B, drain_all_stock() → is_memcg_drain_needed(): B has already passed a
>    quiescent state for G. It enters rcu_read_lock() and loads cached[i] == old. G
>    does not wait for this reader, because it started after G did.
> 4. B is preempted right after that load (RT readers can be preempted).
> 5. A resumes. It clears cached[i], puts X in slot i with a non-zero nr_pages[i],
>    and unlocks. G ends, and old is freed.
> 6. B resumes. It reads X's non-zero count and calls
>    mem_cgroup_is_descendant(old, root). That reads old->css.cgroup from freed
>    memory.

Thanks for taking a look. I think this is the race condition that Sashiko
brought up in the original series that I had.

I will go ahead and send a v2 with a new commit message that explains
this PREEMPT_RT race condition so that it is more obvious where it can
actually race in a kernel. Thanks!

Joshua
