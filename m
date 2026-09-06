Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C323793AA
	for <cgroups@vger.kernel.org>; Sun,  6 Sep 2026 09:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788685565; cv=none; b=sJ/6WqHR1owTYgW60nlcbA5Hga8EM7XmkiOWklozwvQ11sDn1BMQSa5nkfX0Q9NIZBLXNZe76qpZVvOIM0nvBA6AnzcorjtQRGV22jJE6Y1iFiS8Pxv4rsD0CiphyRnR57ZzIDTWPaSyZH0QF75tZt9B2C/4XlEke4mBvZuiOS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788685565; c=relaxed/simple;
	bh=qUfZiewqx6IXEXbPddEPeoSESNCFTDNQAzlFoaa3BfY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XZ6eSCXmjHWhXVlkvl59fyen/Xc1DiG7H+8joXoRl1/7KatOpFf3vTWHlwhvO4mTCFdtsT6xzuJ7S8jjrnoZuTSwU3UL6wsEbF+vvbkUhW05dfosu8eMfXvTTaEktl5VJZxcTgiMp5RGhAZItWXXE1bnEU4J7HTpd55ZJ88Vp9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMKenUXL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMKenUXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720D01F00A3E
	for <cgroups@vger.kernel.org>; Sun,  6 Sep 2026 09:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788685563;
	bh=2FAXP4V+Cd6xM7XhYzDHUaRzuyzX1knyfPgLVsqqcWw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CMKenUXLXCCIEOj89UCR8qWkedc1FLATT5XkTebFY7x97yI1BCCpQnxFxr6n5vFD5
	 nqSERMDQp6+Y+5eiC27oR9nwUWvYElADWto0F4FLVUOnS2T+6V9ipFTelkz5Y93Qjo
	 xV+xxBd4vmRUurJ6Z92V9xZKe8K2HIQ+J94xM71sNDR9Jbkg9qiG9ov0g7URwwSY6N
	 Kx3NC9CWigdBbtRPTztyCdmFpxgrefy2w2HrMINMFcSsS2Foz+dXVAwwk9WluCg1Py
	 BkZhvmFnnIYB/xFSENMC+sR0OnVPPE8nJuZG+cFgmY34MhnHjzLA8V8jeDX2tCZ0Ww
	 K3ZvvexuUq5CA==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c2637dd37c1so78939066b.0
        for <cgroups@vger.kernel.org>; Sun, 06 Sep 2026 02:06:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByEqaoELPD4pK7fhXHQMOlFcQLZWsxJv8mtHJr+DPji7Lbou7ky96eW1F2VxJ9I9B86IiQcGpd1@vger.kernel.org
X-Gm-Message-State: AFuF++md6HY21SPi5mBR1X2Vt0Z5To1sYHItSu55j3imMqDhC/oYUUCo
	yhiTT7doZig1bwmb8dCQhe+cKes/F6nkY5QE6Qfc85X9qb0hSeDasakGLCAzC5T/DSAMC0wiD7h
	AlQ5yMVNO8U4t5q4IRxVQLT/OTnR8oLE=
X-Received: by 2002:a17:907:da4:b0:c26:1649:47af with SMTP id
 a640c23a62f3a-c26164955fcmr552326166b.37.1788685562112; Sun, 06 Sep 2026
 02:06:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903215616.1456239-1-joannelkoong@gmail.com>
In-Reply-To: <20260903215616.1456239-1-joannelkoong@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Sun, 6 Sep 2026 02:05:50 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN7wAx6nin7m37hF-FfvwkLAH6UazfLNowKsqx+yCTjxg@mail.gmail.com>
X-Gm-Features: AcwNN1VVMxwmqoyjO_JhcvjsijdjCfwV_McCiPZvZqBjYTcCxh_B7OEp0XzlfiE
Message-ID: <CAO9r8zN7wAx6nin7m37hF-FfvwkLAH6UazfLNowKsqx+yCTjxg@mail.gmail.com>
Subject: Re: [PATCH v3] mm/memcontrol: skip non-hierarchical memcg-wide stats
 when v1 is unavailable
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 2:56=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
> and event alongside the hierarchical one. The only readers however are
> the legacy memory.stat and memory.numa_stat, and reparenting on offline.
> All of them live under CONFIG_MEMCG_V1, and their accessors
> (memcg_page_state_local() and memcg_events_local()) are already compiled
> out with it. This means on a CONFIG_MEMCG_V1=3Dn kernel, memcg_vmstats's
> non-hierarchical arrays are written to on every rstat flush, despite
> their values never being read / accessed.
>
> The same holds when the kernel does support v1 but the controller has
> been blocked from v1 hierarchies with the boot param
> cgroup_no_v1=3D{memory,all}. A v1 mount is refused in that case, so the
> legacy memory.stat can never exist and the arrays are just as unread /
> unaccessed.
>
> Compile out the non-hierarchical memcg-wide arrays if CONFIG_MEMCG_V1 is
> not set. If it is set but cgroup_no_v1=3D has blocked the controller, ski=
p
> updates on the arrays.
>
> This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
> read-modify-write of ac->local[i]. Nothing else accesses state_local or
> events_local, so those cachelines were getting pulled in solely for the
> writes and they are separate from the ones the loop is already walking.
>
> On an 80-cpu x86_64 machine with 500 cgroups each running a workload that
> dirties anon, file, dirty/writeback, slab, kmem, mlock, and reclaim
> counters, timing mem_cgroup_css_rstat_flush() in-kernel in TSC ticks per
> flush showed roughly
>
>                          before   after    delta
> memcg-wide aggregation   1231     1180     -4.1%
> overall flush function   2452     2397     -2.2%
>
> These numbers are from taking the median of 70 samples, one per 20s
> window on each kernel. The 95% intervals observed on the two deltas are
> [-5.41%, -1.76%] and [-4.53%, -0.14%]. The values above include the
> timing overhead itself, so only the delta is meaningful here.
>
> Counting the items that actually changed, a median of 1.5 of the 77
> memcg-wide items (57 state + 20 events) had a non-zero per-cpu delta at
> each flush, which means the benchmarks above are with one or two fewer
> cachelines pulled in per flush. The count is low because the benchmark
> reads memory.stat in a loop to keep the flush rate up. For cases where
> flushes are triggered only by the 2s periodic worker, more changes will
> have accumulated between flushes, so more cachelines are skipped and the
> per-flush saving should be larger.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Yosry Ahmed <yosry@kernel.org>
