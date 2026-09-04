Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6804E4A9D48
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 16:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538717; cv=none; b=IZUrwcDX10XSk+OAyG0IIvIVUsT5ZaGt4SDMfAtzltCTKlu+jOC0WlTaf9G5/0Y0b/LAGg9Tr7FBgz77cjoZzFqnbXVPy5eoX/V5a5T3fI+aeBNbledEFGcQ7z0qnjhlopbGBe6G4UIL3nEHXE/9g3prGi+dSvRU+IjiEBa2t8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538717; c=relaxed/simple;
	bh=1OY+VGgOdllrgAQ5HMn/khdis6bnRJVuLQtKWN1yu8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QT8HlWs20fHOM/xGi4GqB2L3rvNugGsquOjXoTiFcfm/pzzGu5IsG0q94HCTtrkrWun8oh5nQfpAE8lnOVuwILybIKkSsgAjDa5n7eXWTXQpAH0cnMTOQzy7GpfiGkO4vUaHOggoXEfutleQDUK75f4PpVQrpC3F02ic4s34RB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=Ngc7cdke; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="Ngc7cdke"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5218927884fso19351611cf.3
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 09:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788538713; x=1789143513; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LjUp3CV9yKEnetekUyHn3RayljW6XMUXGPpbgLl2ZBo=;
        b=Ngc7cdkeE7kJ/yftNLi+Udu+FRXxw3auLlgtnMoCxoSamho/pcgiddRWW5tAS5nSpv
         EXKilEYoO6W7DqW04Rs5YUyldRjmisdgW8uZs36C6oQys6f7k5+s/Sk4QWtYqc931PZ8
         XB5ndulqBlg8q7dt8G5N/DMOIqcFpcbNZbvSlNMErWaWLQ+brgFXoJQ/N1+P7kIZDIc7
         Ey8fa3nczXJgh1o9WwMqyjWv1sBqFisMPVeT9WjU0pYoRPB/uxhCGYrvGuOg5oM84+1c
         Sp3OVr52cicIhv4UVBeI3zyZ74IcIIQbbdiBkyBXqZ1Q7M145QFFldoWuGXgsn/m6HyW
         Xaxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788538713; x=1789143513;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LjUp3CV9yKEnetekUyHn3RayljW6XMUXGPpbgLl2ZBo=;
        b=IszB/vkQhjev0lCa0wlNrLevP7EXeYOeAOrsNIg4ED/GehFkCC0cich24n6A4t8Lsg
         n46lUffWRoxx6XU1k01r0B8cH5tCygXLoMp88f8Z5RZWsaZGhOpelRosqymQbiDoFCFs
         FSgtonkPPmPNcfZgFIY0blb/oTsl2YpPqA5REJtgK2NVQZVOe5gd5ee1Wwzb9i7un9Ly
         F1Ux3j+vbLKmolfd7uU7J0Ve8P6lJzv54Ed/TgUy77/4vINBdC3B6qrG0VaZsZOmYfHp
         F/9b/23M58ECssoQX3XVeZnWqmfABFRUlirZe4KtpCuQavcy7RKD8Rij6LyvZC3/vUGo
         PIBg==
X-Forwarded-Encrypted: i=1; AKwUvBxzAZjTyHoKTLWxEs3dWqFiHGxTL2vW0ZvUigmuX6cTyImnpZTw1JJuH/WesoSc21Sgn2kQxy6E@vger.kernel.org
X-Gm-Message-State: AFuF++neTDO/bKIaT7ibLgzB91hmyhtba6MmYlXPFb+Tf1LxtaCiflbJ
	j3bQNXbKjLnXIV5NPrgl6GPMNRYsx21iLh/j2kMKsPXKfW36DEOIn7Fm98sEy/n/47Q=
X-Gm-Gg: AYBFou1ufJ0y3g8Uev1zf5mjNNpG1EbJK/qjwu6qvGh/kuhyDmUbEdjJUbUu9HodZtw
	S+/efpnDoOnb1VHyf1aNF8NLBVYwTo4Zwk8qD9y2cZ4mrN52qyHwwcVYuV06j5If8tlVCkqEsXk
	hbVkycRJEaTu4pICYPqz8cJZHgqnlbIN99PDJnddD3E1yLq7NqBc3MPTPJAoQN4+Kw40kRZx423
	/i26bdia+PK1Sii+wBMtqwFU5+LT2Au2Lfk7+4EGh/CU4eHcGty8mFQ0Y2lgmb4bDH8+PeO9jof
	tAK1KLM53jfoWLMPliKUsswqx/4eWwh79yhPZN2xHQ/Vz7tmROk4Jqv8k78M3zvE4tS5qaZSywi
	f1hjpvtXZSaOCaytYmqXiV6lDms1KJxFw4dJTjgjAW+m5KfVpyqtrEgGBcmxD47TN+i67mjrklY
	/lqSvOMsm1+XMvEDBlUQIGyjbsXyn/HPCmqXyd
X-Received: by 2002:a05:622a:5814:b0:52d:6de2:906c with SMTP id d75a77b69052e-5305484e3b8mr66521431cf.14.1788538712939;
        Fri, 04 Sep 2026 09:18:32 -0700 (PDT)
Received: from localhost ([2603:7001:f100:501::2])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53054180ba7sm23626471cf.18.2026.09.04.09.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 09:18:32 -0700 (PDT)
Date: Fri, 4 Sep 2026 12:18:30 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, yosry@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3] mm/memcontrol: skip non-hierarchical memcg-wide stats
 when v1 is unavailable
Message-ID: <20260904161830.GD6641@cmpxchg.org>
References: <20260903215616.1456239-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903215616.1456239-1-joannelkoong@gmail.com>

On Thu, Sep 03, 2026 at 02:56:16PM -0700, Joanne Koong wrote:
> memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
> and event alongside the hierarchical one. The only readers however are
> the legacy memory.stat and memory.numa_stat, and reparenting on offline.
> All of them live under CONFIG_MEMCG_V1, and their accessors
> (memcg_page_state_local() and memcg_events_local()) are already compiled
> out with it. This means on a CONFIG_MEMCG_V1=n kernel, memcg_vmstats's
> non-hierarchical arrays are written to on every rstat flush, despite
> their values never being read / accessed.
> 
> The same holds when the kernel does support v1 but the controller has
> been blocked from v1 hierarchies with the boot param
> cgroup_no_v1={memory,all}. A v1 mount is refused in that case, so the
> legacy memory.stat can never exist and the arrays are just as unread /
> unaccessed.
> 
> Compile out the non-hierarchical memcg-wide arrays if CONFIG_MEMCG_V1 is
> not set. If it is set but cgroup_no_v1= has blocked the controller, skip
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

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
