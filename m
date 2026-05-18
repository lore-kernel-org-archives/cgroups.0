Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15A53D47C8
	for <cgroups@vger.kernel.org>; Mon, 18 May 2026 13:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779110520; cv=none; b=NX7ZqGJEpZiq4Ce0HDfc767OVCD8aXngBcjIoicr/eJ1+BpXh5sFzTPM/TACWGVU7leNWuNQo6zh7AhzFr4zEUbEQjohHBZ2jMsejzsKMhrS+nytnd6j7OCRYwAVwLAn47ygI7Ttvd1Oav7a+x91v+aP76awiloKdD1UD7MSkpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779110520; c=relaxed/simple;
	bh=6UYKcNQm72GyMtIHNlGEBzktPmOrdk1rsDS7GHVaUkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SaLbLUxaKVwMIR102Y/ANl1iCbrNJid1QtBLVfTeVPxHZZFTHYyk1u+uBEhsLIzYMCCBh8VULVJgfUG7elmbJ/9CCMiwoxTSrMVoveujB670rg+0MnATgLMoMWiYk1zJj19on3oUmlFB00COzVrcmmil5HJpZ7UwDYbfdyjMj/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=jTuvA+kW; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="jTuvA+kW"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-911dfc86903so278375585a.3
        for <cgroups@vger.kernel.org>; Mon, 18 May 2026 06:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779110517; x=1779715317; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b8m8UOlb8bhby27tmt+X53ydiTiMfQFdaV5Cc51ilhA=;
        b=jTuvA+kWugyK6f9p5WvbDeFreke58EEHjGPORKXApuMoP6WCDSXpp3sT3u66mRGRKB
         XPdpi5FlOqClECih+QFbUaDRAUrJUgwxy2UH2tuee6ytRyW+ab626k+lZQDfzyaMWKv6
         6cwCWBg65Mn712RxQ/0yoi/t/iKQMaNpFusFQcQshRumKHWaqt+DSXszXTiFtdbDPx0J
         tNyBxetoL3sij2uze1FWKQPgLWpek9+htjriLRkuwcTv1/vdFWOiE4i3clxeiSR8XzrQ
         MVyDyM8/Ak57qw075Er8xmHQTmkauwQu5wg7vhUhlJH/0OBhW3xY3EdZjgnwpOBcIpZM
         Xj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779110517; x=1779715317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b8m8UOlb8bhby27tmt+X53ydiTiMfQFdaV5Cc51ilhA=;
        b=W9N8QGg2/xaqK+/z84M/M3rkLRp7cUkPNIEwwJamsVZQTDqtx369AX2uQnSN8g9Gxu
         jcCPmUDO8AIqujt7Po3ovdBpbvEvr48VyhXEMiaJrdedJrKgqylngQmJHbdObcoPyN7N
         rQcOVdxEptsPGupFLZAzCcDXPv/rnJbfKVdJ2Z8AuxPUzSOZS17fDuz2tV6ECK0StBfA
         ca14z3OhBtsZCMsRrHpt/hwwNPS53MQj0sowQ4uesZOnSpx0Ax4YuJJ7cpIPCCa42M3Q
         F78UzpCco05UpVAV/0pSXJlLENNO11IrXr2HT2p1b/q1VWxekExPCtT+IktPwsB9TUMW
         zImQ==
X-Forwarded-Encrypted: i=1; AFNElJ9PAMX62s0Hm4xbRabBHlBKUlI5uFp0guinH61hPOLy5HsDst1gVG4IhA7tmCDcevx+Qh6/ldfR@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz4fj7Re2MNVw5DHD7lkvLii8h+ehQugnuQ+VafQ4AUc9ySPgo
	/vvr3LkCs581xFj+HzHIzsPnAxWPuZK1whtV4oxWYLSMNrkQi8roKuQcRamVFRQeG4s=
X-Gm-Gg: Acq92OF+FHEec0f57gH65D1z0hzjcS7Ofo0zBGHMN9oO0hTfT+yb/YX8HfcYhynYxRf
	2YIa16y/dIKgFmvG0W5cbEUs5uMFHU4PWJpJAoxRfdg0kxgsCYbDsc+RPDgdGHXZLA6FOSkFBh0
	UzW78xSFeJueFOruF3wSzG+Oo7r1tQ21xJmLyNVGcJcuRF3z0fwdpYXDCi8BogkA/EbaXpmi29m
	oUOj8BLzpTp3CAwLFje2xN2Uym1CPAcIS5cTRkQjvI4FqWFh6HLPTmTWZO1BZEG1INDN694wIoS
	sWhyVD+YACX590OC4VPku90aduxdpDMa6kiDqzSRRdntPc3GwBhaeb1XZXxszRMkihtoyPEIHhE
	6ubUYCDbVD9GM/VTD+3IkB1a/uLjPQq076Xh45vHDS7pv0o7euBggP2rinpBr8/XYwxi1wLktfg
	9ovOnDz5VEvLtyKv8FJk3oSqYkM0J2wGPE
X-Received: by 2002:a05:620a:8413:b0:913:c647:fadd with SMTP id af79cd13be357-913c647fdb0mr681606085a.39.1779110517498;
        Mon, 18 May 2026 06:21:57 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf318e4sm1460238885a.32.2026.05.18.06.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 06:21:56 -0700 (PDT)
Date: Mon, 18 May 2026 09:21:56 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>, stable@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: propagate NMI slab stats to memcg vmstats
Message-ID: <agsSdPRDjFwqUdd7@cmpxchg.org>
References: <20260518082830.599102-1-alex@ghiti.fr>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518082830.599102-1-alex@ghiti.fr>

On Mon, May 18, 2026 at 10:28:19AM +0200, Alexandre Ghiti wrote:
> flush_nmi_stats() drains per-node NMI slab atomics into the per-node
> lruvec_stats, but does not propagate them to the memcg-level vmstats.
> 
> For non NMI case, account_slab_nmi_safe() calls mod_memcg_lruvec_state()
> which updates both per-node lruvec_stats and memcg-level vmstats, so
> flush_nmi_stats() needs to flush to per-node lruvec_stats as well as
> memcg-level vmstats.
> 
> So fix this by flushing to the memcg-level vmstats for NMI too.
> 
> Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> Cc: stable@vger.kernel.org
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
