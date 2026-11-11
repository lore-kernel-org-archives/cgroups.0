Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794419821;
	b=EZazVY5vwvxnqNjRM4o3FUzwQfQC00IR17URZDhWTlQmC0F0Tplj0gErv00DT1Xd0v7F
	 fQKpsgsMHiqG4WOzn/2LFgCCB/owTn35MHhquoAHw222Xu9PgGtGq+ridVOr2JScNDUnf
	 WXb35PAoQUPD1VH/Itm6IZFk7Gj+9OfW7JmdLm5uP50VdPqC0armn6Bs3R5hMpfYwoe1w
	 KUHDe2c5gVRbHeqG+vIhdmTrmZbeq4AOTbm35MIZmfT6BKoo8PGBqrUq+Kct0gWdGxjJP
	 YdRP9ENFvhiuoGps4xmGnkylaUzbBYlEIX7bh2jLaEypGFqHhsleBcl6lDO1DuDhBRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794419821;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q6s/xV2lHPq5GEMGWwRYYdRwrT5Ecmz5ksS9o79wQoo=;
	b=MKyOLf1ASdmHrGpdaVkMbKLYAfAnKe1Lc6bvENFzcIsWcV/Ujojj6FLVtm8zbLwsAEZO
	 zlHm8oeAWCBNxiF2jp1wkqNAtWqYJMKLwmqo6BmEBdu7Jejw1XpTBqSAqLbcsGiN2AoGe
	 8jaFBA4rMPuwSaiYZDO4ue1+kwEcgIPCeCzslTfrxhRgAW8UIeN41Mb5/k1uWc7CBPFYx
	 4ajWUVttzeuwyz00nIHPi00DfZzdMh5a2n3zoQKWKYml7mpaWXporXnvMsZn3qDRaOkCV
	 JFzCrHkqtnqsfvrfbJs7yhMqESXpyjGnbGJdvd/i8ol35xjUAQyjXuyM3Ld2CcfjYmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CK5GSXWO;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4868606A335
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 17:57:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4868606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CK5GSXWO
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so916535e9.1
        for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 09:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794419819; x=1795024619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q6s/xV2lHPq5GEMGWwRYYdRwrT5Ecmz5ksS9o79wQoo=;
        b=CK5GSXWOn1oYayqCNqvVbeqP3J4g0n6PDbu7/b+cMsYfwBRIcQdYmArPTVXYfzEwUG
         QJQtkVr4B3J1HHP1KQAbfqm5jlLenZ5YhhZc4DhiKQ971Fa84gGks7hRysI82OlLepCw
         0LAfjbJC44/AiTfm6Ex0KGQkvPUT32MFPG5YF2Bx9P//yCa4BYTKBd8Sr4BcDqKNGEly
         a4j2gE1xNefgrVYZ0pDY54/QC0HLNfo9YEuN1TxZ9r8KeQxb4U7/Yt9bjVnz3GLsv9Rl
         ipynvkuzMS+FgAuov42upxWQuYWqChJm6iII36nWsnxV1EEWqESj811TMHY76UR+xNXd
         cMWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419819; x=1795024619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q6s/xV2lHPq5GEMGWwRYYdRwrT5Ecmz5ksS9o79wQoo=;
        b=FRHLsBel5cXbU75P69SC4mrFahIy65v7LBBW/T2hUCy1dhCbubWQXv8cl6MUeWgydN
         5aMPjlXq3ntV91ReZsWzVJki3/laWU5cZKik42n/jq71Rly9ZrkjhhVVyXI5e1rJFE2c
         vHoiYmmnp/o6rR5CQT5OoNM0sK5NU7JVXy1DaA0c939fmpEhmi3nOGlRggm7sP493JnL
         HqFCyS9l7R6pKmJs0pmW7h0s50s6ZClSLah9f0qvtpVVTPJhLE8Q1h3OHwWKRkImYouN
         /Y2adQShNYWvZhiPVvv4E+FK3RxcUFgzOK4/0XUwrQTZWroQqcmwR9KHwPPksuBHjn1Q
         ot9A==
X-Forwarded-Encrypted: i=1; AL+hErERMZwafF1ofAUK4m0SE97Dbxp3IZZzdYC7+ainjY7mwc2qHcg6Cf/larUVjW3RQyLdN4JyL0rV@vger.kernel.org
X-Gm-Message-State: APuU4Z9+qYzGEWh9CJIAERDZC2OlYt2wBEno0CnMzAzr9r+WIKrsfQRA
	SRvPM8gwiSBAvEsNLyIM1fcMJU4vO3kE8GzSfDX+Jfk6eym7O6MNCvbe
X-Gm-Gg: AYBFou2118/0kEUT3qbZUGr296lQVCye16wOan8yJPLwsPKy5nudXWV21PaqgA6DUCa
	zf7I1OB36hvdHLkQ1osNFOeyqvODQAS9TlpSOdQx5nlUxE+ttKrqm90G2hFPFyht2xFygHoYSBb
	cAk0bVEqqDczS00gPtNAhye+KVR2fcwkvTX3MqlVNKsae4VfLkQaL/4D5e3+4GS9srDE7YyETQV
	Rw657JrAMJiN9Bex0tW1wWnIXDv+Ywfdxeryel5e2sSjFz5JirVmtNVi2dAMmGXBqTN2zYVGY0v
	PwmCWja7kMXIULIXmrVU6T1iMUXrXbDTygkVdztEs1P3HwdjubUOQMwaG2jjCmkS9cFJOSmHt3E
	LqCvW6GqaA29JVjtxhfPKzEntYYEdagJNUE39Gvkdns0wtKhEcN1TLJziuX+A9KjkPbivUilBY0
	mQNUeZXalzMD3lxOYvix/koydOqv0wIa6wzJKSVjFaPjPkRaR+ukrNRbk6WN23hbHH8MCANGvyE
	p7WjXzZ+V/stA4rmb5QKQL0mVPiKGR4GSrkdksiAeICgRqTSPrNm0MOC4etURaDMGizjleiKme8
	maiyJzr7K2kTJyYmKPiScu7zfg==
X-Received: by 2002:a05:600c:4850:b0:4b7:76b8:348f with SMTP id 5b1f17b1804b1-4bb4e3076b4mr2214315e9.19.1794419819018;
        Wed, 11 Nov 2026 09:56:59 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49836c83432sm11271749f8f.58.2026.11.11.09.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:56:58 -0800 (PST)
From: Yuri Andriaccio <yurand2000@gmail.com>
To: tj@kernel.org
Cc: bsegall@google.com,
	cgroups@vger.kernel.org,
	dietmar.eggemann@arm.com,
	hannes@cmpxchg.org,
	juri.lelli@redhat.com,
	kprateek.nayak@amd.com,
	linux-kernel@vger.kernel.org,
	luca.abeni@santannapisa.it,
	mgorman@suse.de,
	mingo@redhat.com,
	mkoutny@suse.com,
	peterz@infradead.org,
	rostedt@goodmis.org,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Date: Wed, 11 Nov 2026 18:56:57 +0100
Message-ID: <20261111175657.250354-1-yurand2000@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <212c244d534ee1fdb0538a980789e16c@kernel.org>
References: <212c244d534ee1fdb0538a980789e16c@kernel.org>
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

Hello Tejun,

Thanks for taking a look. I'm answering some of your comments first and at the
end I'm proposing a summary of changes that will appear in the next RFC to
then "stabilize" the user interface.



> The new name still doesn't follow the cgroup2 naming convention.

Thanks for pointing this out, it was a mistake on my end. This will be fixed
in the next RFC.

> The file prints a "CPU runtime=R period=P" line for each possible CPU.

We will condense the displaying for same runtime/period CPUs and omit zeroed
ones.



> Switching between "max" and a budget is refused while the cgroup or its
> "max" descendants have RT tasks. That's okay as a restriction for now.
> Ideally, the switch wouldn't be restricted as long as the budget is
> sufficient, but that can be left for the future.

The restriction is in place to simplify the initial implementation: switching
between "max" and non-"max" requires to migrate all tasks from one cgroup's
runqueues to another cgroup ones, and could potentially be an expensive
operation if there are lots of tasks. If you think the restriction is
acceptable (for now), we will keep this unchanged in hte next RFC, and fix it
later.



> Can we separate cpu.rt.max from cpuset?

Maybe we misunderstood, but in some previous discussion it was asked us to
integrate the `cpuset` and `cpu` controllers somehow. Your proposal of having
the `cpu` and `cpuset` controllers orthogonal simplifies things, but it is
similar to the previous (cgroup-v1-based) implementation, or before the
integration patch itself (i.e. just allow the per-CPU overrides but remove the
tighter coupling). What is the final verdict on this?



> On the per-CPU budgets themselves, they don't match cpu.max, and giving
> a budget per CPU is a bit odd when the consumption isn't per CPU. The
> threads move around. Maybe it can't be avoided, but I'd like to see a
> discussion of the rationale behind the design choice and some
> exploration of alternatives.

I'm not sure if I'm understanding correctly here, but the budget for
`cpu.rt.max`, differently from `cpu.max`, is meant to be per-CPU and not
global. Sure the initial patches have a single setting that is the same on all
CPUs, but it was meant to be a per-CPU limit that is the same across all cores.
Notice that threads move around, but we prevent migrating them to cores with
zero runtime (hence, there is some overlap of functionality between cpusets
and rt-cgroups).

The rationale behind this is that, from a real-time theoretical pov, it is
necessary to know how much budget and how it is distributed on the CPUs, as
changing the number of CPUs or the budget distribution radically changes the
schedulability outputs. The most complete and flexible interface is therefore
having per-CPU budgets.

This is also necessary to prevent over-provisioning and allowing partitioning
of the total bandwidth:

- If implementing solution 1, a request of 10% of budget reserves 10% of
  runtime on all cores, regardless of `cpuset` settings. Of course a `cpuset`
  mask that is smaller than the total allows limiting the tasks on a subset
  of CPUs, yet the budget on the unused cores is still allocated, and therefore
  wasted. This is a case of over-provisioning.
- On the other hand, allowing per-CPU controls allows to potentially partition
  the total bandwidth in the CPU hierarchy, for example reserving some 10%
  runtime on some cores, while still allowing other cgroups to make use of the
  unused 10% bandwidth on the other cores.

From this limited discussion it appears to us that solution 2, which is
similar to what we already had but without the "default" case, is the most
suitable. Solutions 1 and 3 are more or less what already exists before
the `cpuset` integration patches.



> AFAICS, disabling the cpuset controller above a budgeted cgroup moves it to
> the ancestor's cpuset and changes its effective CPUs without going through
> the lockout at all.

You are right, we tried to prevent changes in the `cpuset` when an active
rt-cgroup was involved but this was clearly missed out.

The lockout is in place because, in the current integration, it is necessary
to rerun the bandwdith admission test on every `cpuset` change, which greatly
complicates the code. Nonetheless, a more permissive integration still needs
to couple updates in both controllers and run some admission tests.



> Skipping the boost when the target has no runtime is fine as long
> as nothing stalls.

For PI and zero-budget cgroups, if this is an acceptable solution, it seems
the most straightforward one: disallow switching to RT for zeroed cgroups and
disable zeroing the budget of any parent which has active RT tasks.

- - -

As mentioned at the beginning, here is a summary of what the interface
would be after the discussed points:

- `cpu.rt.max` and `cpu.rt.max.effective.local` files. When displaying the
  per-CPU settings, zero runtimes are skipped and same runtime/period cpus
  are condensed in the same cpuset.

- `cpu.rt.max` only accepts per-CPU settings, so the global "default" is
  removed. Removing all overrides means the cgroup is a "max" cgroup, while
  just a single override means that the cgroup has its own budget.
  + This new interface disallows zero-runtime overrides, as a zero override
    is equal to an empty override when there is at least one non-zero override.
    As an example: [<CPU0 10ms 100ms>, <CPU1 0ms 100ms>] is equal to just
    having [<CPU0 10ms 100ms>]. This seems a bit odd, how to make this better?

- Switching between `max` and non-`max` is still disallowed for active
  real-time cgroups (to be left for the future).

- `cpu` and `cpuset` controllers are decoupled, as it was before the `cpuset`
  integration patch. The user/admin is responsible for inconsistencies between
  the two controllers (i.e. empty intersection between active server in the
  rt-cgroup and the allowed cpuset just disallows executing RT tasks entirely).

- zero "internal" runtime cgroups will disallow RT tasks and prevent
  priority boosting. Admission controls will disallow zeroing the "internal"
  budget of a parent which has active tasks running.

Hopefully we can agree on the ideas posted here. If you have any doubts or
better suggestions let us know.

Thanks,
Yuri
