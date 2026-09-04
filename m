Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E41150EBFA
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 16:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788540834; cv=none; b=nKNuQ33QO322PsW4bEMJfOOj1dsgAp39fB8oUzdhM5Cuk9qS5dNBWsdQvVydD88KAiJfDuuWww6eXq8AoVqhKHPjAnXFAzof/JXNLLGGz1IqdfysIMhA6Mi+lmbaUt/q92aOWmjVmxSCwvoc0Umb+qjyCMpEQ9bKeBn3wcZ2X4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788540834; c=relaxed/simple;
	bh=jrLA1hMmJiDiFTE6kwXFV+kgvwulbwMr/rieU6zsl18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qylau7mQ78uA/GWoqfHSiP7fD+JcI8/DzAv8tjssTaYE+4JGo18VtVi146upxKBHyXcx46ZfRL3j0P8g4wMiBjTe0haDD2u7xagrVNFSV4KQ/DiB7Wmesai7SO1L1Go7NJi7QKPCK3lkaGSaPS0KTIygyNDfisU5IUxSlRWb4eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mjcil/4j; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mjcil/4j"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-4b1fcd3b1a9so684360b6e.0
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 09:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788540832; x=1789145632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0Daql0pFyC4jJPjBVxDEnT2CRdATPbJ2eNQ+01EFAvg=;
        b=mjcil/4jAQVJNDg7eP6DpYj/ttGRFS6H1tXDTxOdE13Hf2mdMF1c0xtRIun+vwM+Jv
         1n18Yy6m4hVDLsucFdIfhEOEdAtFd2/9qZ3ow2w1fisjOhbze3HYeC8tZ+yNwjItFeNN
         qzKoqoAlYX724+/TcOCyObebbLt0/RpaUImsOmMBfyUJTNvbaJYE8mRws1V4klid6wYp
         w8mTRXTLkGS4AJI1in1PJqaHQgzmF8bGbCFcpjweompJjg4NnpwpML6u834CSPBMuQDq
         96qiECQrNkzsoNb0bsnLNyLg3P54yAuvFxX6HLLSI4WX3rgVn66EDSXsl1eRmfkDxRNa
         3xqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788540832; x=1789145632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0Daql0pFyC4jJPjBVxDEnT2CRdATPbJ2eNQ+01EFAvg=;
        b=MiFCk5wO09x9TsXsCk7TPhUd0OErLPPSJY+6sZnVBmOmzEdkKDdjb+vj5B68IFUOYH
         emR4+9VqGVSOIKyjY6ay+M2ocur8953EK+asG3UF1txvsP2s+ErHl6CA8+RTi7BCB2B1
         tpEk2h2kzG45fTw4yJM4MF0NOju0Y3GvSZYD/1dUv7w2UPZ+dLywX2QJ4IhZ87ovxPZu
         TAU/TmyfcLkUjwHnr++shfYSkxVPzf1bWd8LySqaw4t1bw3UwHJ7OHqOmjXZoMYdzrgY
         SpkbaJFDfx67ZuHHMdklq2K22DoxwFBKE48w5f8DhQvPqNR7pwdQ9UX7/gy7OW8FN8JJ
         43Jw==
X-Forwarded-Encrypted: i=1; AKwUvBy2DxWTpGy6OGIIZ3Da5l+FjqxOnYLBUUkKvZbnCg1ClL4ZmAcPBHKKSjJRENA6RL11xI8tan7m@vger.kernel.org
X-Gm-Message-State: AFuF++mwz3FGtClrOsXdB2RrIECahgEuXCd17sWIfLpgFj3BGrDM7spY
	mPU2QTBVQuRktVef81mcbMiZ74nGtb8Tw4AbR3wOeiUoPV25zS8d8GiV
X-Gm-Gg: AYBFou1msr1Ai3pMp6qKA2Mj45YFxWFqSKRNE+Dxkj7EQqOF8kwhdKR0281kVHsrfdT
	DlkiFyoG/Q8wwgFDCqZ+iFir1yEatCC/b+F405p2+f7ZpV1rWJ6KnGGFUs/glCOXE5J3InhdaDq
	arbjzBSVJ7VgLP2psnLwkaT2fUFOp/lCoKylNvqJtfHvSdjyvwjWjEf3Enr887BKvz646jWDQ1L
	6/9NMqI4l/N1fDg3wmr5SZ2XR7BQ49YzUmGv8SxLiQbABviKoQ0/8jAZIUFgHd6/r+BFvQwR1mN
	BzG9fP9v7e/3HV/qkTPz84mb4mHyqCerXbjOTRxZbUxH3EGky7vgar8vQqG3bSBOaB6WHHJBrMs
	HZo7Yxvcp/Ko0tmye/GCW6l3NqlTLHiS8ZkJF5Rm8yRhThG+R6vtHfbns9JpnryZawLYsCfaRJI
	6vbSDT4XH/Z8toAAW9uoPJngkdmCLHJCPSkQyknOcSJU/ArzRyz0i015cN7QmjsZxe4HV7BWnME
	Hu1+jO5UlYMoRVOvoI=
X-Received: by 2002:a05:6808:2222:b0:4b9:e5fa:8a1b with SMTP id 5614622812f47-4b9e5fa8e8cmr3156448b6e.32.1788540831911;
        Fri, 04 Sep 2026 09:53:51 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5a::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b97167bd69sm2864168b6e.13.2026.09.04.09.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 09:53:51 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 0/7] move stock from mem_cgroup to page_counter
Date: Fri,  4 Sep 2026 09:53:49 -0700
Message-ID: <20260904165349.4100321-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> v4 --> v5
> =========
> - The stock is now a raw_spinlock_t and an unsigned long to more closely
>   match the original semantics of the stock code.
> - Draining is asynchronous again, we add a work_struct per-page_counter
>   (not percpu) that walks every cpu. This eliminates the concerns
>   of doing a synchronous drain.
> - page_counter_try_charge transparently handles stock.
> - Addressed the netperf regression by reworking the refill path to match
>   the vanilla uncharge path more closely.
> - Correctness fixes for the percpu pointer access usage
> - More testing to demonstrate that this series achieves its goal.
> - Included Shakeel's stock watermarks from [1].
> - Wordsmithing
> 
> INTRO
> =====
> Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
> allocations, allowing small and frequent allocations to avoid walking
> the expensive mem_cgroup hierarchy traversal each time. This fastpath
> offers real improvements, but there is room for improvement:
> 1. Currently, each CPU tracks up to 7 (NR_MEMCG_STOCK) mem_cgroups. When
>    more than 7 mem_cgroups have stock present on a single CPU, a random
>    victim is evicted and its associated stock is drained.
> 2. When one cgroup runs out of memory and needs to drain stock across
>    all CPUs it has stock cached in, those CPUs will drain all other
>    memcgs' stock present in that CPU. This leads to inefficient stock
>    caching and cross-memcg interference under memory pressure.
> 3. Stock management is tightly coupled to struct mem_cgroup, which makes
>    it difficult to add a new page_counter to mem_cgroup and have
>    multiple sources of stock management.
> 
> This series moves the per-cpu stock down into page_counter, so that
> page_counter_try_charge() transparently serves a charge from the stock
> and refills it, and each counter owns and drains its own cache. This
> eliminates the 7 memcg-per-cpu slot limit, the random cross-memcg stock
> drains, and the slot traversal.
> 
> In turn, we can add independent stock management for additional
> page_counters in each memcg, which is used in my tiered memory limits
> series to add a new page_counter to track toptier usage [2]. Patch 7
> uses it to give memsw its own stock.
> 
> Because the stock is now a property of the counter rather than of the
> cpu, it is also reachable remotely, so draining no longer has to run on
> the cpu that owns the cache.
> 
> This series preserves as much of the old semantics as possible,
> including non-spinning safety by using trylocks for stock access.
> The old !allow_spinning semantics in try_charge_memcg are slightly
> different now though; outside NMI, page_counter_try_charge may perform
> a speculative batch charge and a refill.

Hello reviewers,

I just wanted to note that Sashiko seems to have raised no concerns [1]
with this series : -)

Thank you for your feedback and input!!
Joshua

[1] https://sashiko.dev/#/patchset/20260831163752.2193337-1-joshua.hahnjy%40gmail.com
