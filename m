Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316305;
	b=mYa8KibgNV8zb3AR6MsOKtpPI2AhyfoB3br57N4KEp6RQCLmJsk99EzhL0qliT3jA5pK
	 qes/8doWNchMvgRVNP9ZuZSM0MzIuCPMUoJ9UQ5A7oKyinlDKgIcfM26a5yXPffXPSGrv
	 emxpRM3pwzBLc8tBrFJa7R/TSdnOqUfvn8EUY7TzqMXYAGK9xIjlYii5hyIsuX8xlZ45r
	 KlqWmstj+TqMl892MITns9jbDFcMUafzsRxK8ZjRWCRujr/xWGaIYnFr2OHozk04NlxLy
	 uKsPQV0KY98SbNWZOLZTNbKrtFY+a6OT+o8FU1Yb2O1J2YXYhuL2sal8yZ6LDPF2dmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316305;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=v/SgEZWrzJNE/7WZqBg/ymw5X2Lr4Ksekr/q2IUMa7k=;
	b=qJwf0tAVIZLAnrYCYeCFtSvvSZnng9gWs+KilJBXFcYbiB3qJNI2qBjp/9WOCXTv+Gew
	 lx8Ndfs1EpMntUBJL4Vs4owxjw8YpqyAaPm0kE5TgtKNotKsQPSGci789pAtTNn3wOxzU
	 5VFdP+1g2FuVR7HkKETXDO3R/4D0gI+oEv/i57tkbecmq+NBRG3abEZBLxXz2m7JH03xT
	 Qcb/RgQD3b0N2du5Gfjx1wFE9exBw4GtMMcOITLJL3oDWSwc9e9lUAwFuAeQIChMGSg68
	 zAms6YhLgFUlCzVwxSQFzFKlPog7oTQoLjGU8iqtTIF3sMyzNL0Snkx/QSz/HSIgBpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=r1B8XoXU;
	arc=none smtp.remote-ip=209.85.219.46
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1065606B2E8
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 13:11:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1065606B2E8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=r1B8XoXU
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91ef011e338so9905716d6.1
        for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 05:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794316303; x=1794921103; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=v/SgEZWrzJNE/7WZqBg/ymw5X2Lr4Ksekr/q2IUMa7k=;
        b=r1B8XoXUdorHTQi31T4QZzQwAdYf3h4O94kZGC3jv3T+Jx5SRjr7FGsuqI5cXgJbuy
         a4Xskj7A4wrzvSdZS9DExIDq+xyu5tsy3fACq1w3Utv6FY5LAMCxJeTfUYkugkcSURlU
         ZCsjXXPIL/Z4QaKPsiHzP2lVg8s+DaMURXSk3YAO5StGiFfPs8XaEn7HvQAQmDVOxF0K
         +4cgcOZ4ZUGxBpTRrk2YwTXg3RkeaX+BRNaRbxPTB+Kw+TPgMU3P08XiJN88xbwrIvpc
         FnRFR4osjUJ354D/5xgkmgEk6S9jGEccJMRKmxluZ4XdNRRCNAyQv4W0zz3bSKwk1CMz
         suvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794316303; x=1794921103;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v/SgEZWrzJNE/7WZqBg/ymw5X2Lr4Ksekr/q2IUMa7k=;
        b=hV5Cdv5t+TtMsvxi7FrU0muynpZvhzDSFJCFlXVuHgjCEd0dz/eheqbD2Hc/Z3gbEk
         o0oVJ4jai9kj2+5m2ZNSIB5OouNmK5xBzOV6LuAgEOAdOvedVe7XZ1PvgPETHDZF444O
         dthVfRpqgVeGm68FXDXG6lqQBC2fevOQqTw+JeZWnA57elGJKNcUKTilL2zVype0h5xU
         fSHP67B01kAxRVILrBjPz/6WLw87Yk1+NdXKaBH+kxDgPoFkXHz1CdUZHf47OdACHt5h
         zc3msLoHDjxzoIdeVYWoye39FAReRw6xzFuQgqrgukBIaCqvvOUxtSxfMPL4bgE89kow
         qsLw==
X-Forwarded-Encrypted: i=1; AL+hErGC97sc/e4hP8OROieredNsGa/MeIlX2uOZeKPOcMb8tmPQL1ALy3w007iHDhBJjQigy4YExbyP@vger.kernel.org
X-Gm-Message-State: APuU4Z9Yajlf0ujMY9hvTLmQZIHyTuy4uX6YcWGudadnNYKr6JFvNE4o
	cH9IFVqPsAgqIka6tn+QN85bjro8Qv2jbgEzvO2+07ZaXS0RRX6DiXhllCmOmBhAZT0=
X-Gm-Gg: AYBFou2nrdro/tLTkfGWCgQfbAUpAj5fsLh7saHhbnb+FEoAsNSmTca0gpt4UQUpGjZ
	Us+MKu6W17OxWoJ1IdvRKkklViG0a8wol2hYbtC0R3BS5gU2AK3CgpF/odKQpFtO60SSoMqUIvy
	sXfYlQF3e3gD9/DuayNw/xBYJtcBZAxshPIytG8OJGlTakbMinx1VN2EuW8NE03YQQCN+7QS2oB
	Kyoxpi2Rx4KcFODmqorhgVTI/Rfa3AzxeEkdhDcx8aDPZFXOc4n86SRMiMlcKV19ZGvf6Ify4j4
	IJrdVQjZAaZoK8CKgFPUvRi1f3bO+9707e0M21R+pLAewv6pvli9EemKQllxvcMWw2supI3q4Hd
	Wrl0r0UuuX0ZZVMdXZXMVk40iSb7LZPVRGv9GcxgzaEpgY/KRcF+PYQzr5IhU4m6/nKcJ+zFs1y
	4gp0Amb2B70tt/14bv2Nxx9+iu1eqhpO+uEFGd1v7qWtYrxcFyVFcYyqk7PgmcAzF6nuoY+BEB0
	NpR/aH8vSlpiteC5PdguDB7jxaIBqOEPCgm8F569C/OOaP9pVJ4z5FGR7Gz4kSwcbgKBcOQrWVI
	WUOewYi9WMyt/iZE39H2b2duFp+7BAsZagqpRC71vEdAL+mgS6d60qPeMNiJIJDjGxEXyhftJG1
	goidjWhI=
X-Received: by 2002:a05:6214:2266:b0:91c:7a0e:3385 with SMTP id 6a1803df08f44-91eef9b7adamr41656946d6.49.1794316303415;
        Tue, 10 Nov 2026 05:11:43 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef04ada03sm20492646d6.7.2026.11.10.05.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 05:11:42 -0800 (PST)
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
Subject: Re: [RFC PATCH bpf-next v4 1/4] sched: add helpers for numa
 balancing
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
 eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
 juri.lelli@redhat.com, vincent.guittot@linaro.org, 
 akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, 
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, 
 roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, 
 tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, ziy@nvidia.com, 
 mgorman@suse.de, bpf@vger.kernel.org, linux-mm@kvack.org, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261110032913.71974-2-laoar.shao@gmail.com>
References: <20261110032913.71974-1-laoar.shao@gmail.com>
 <20261110032913.71974-2-laoar.shao@gmail.com>
Date: Tue, 10 Nov 2026 08:11:41 -0500
Message-Id: <179431630193.789062.16833460142171738145.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-11-10 11:29 +0800, Yafang Shao wrote:
> Introduce task_numab_enabled(), numab_in_normal_mode() and
> numab_in_tiering_mode() to replace the direct accesses to the
> sched_numa_balancing static key and the sysctl_numa_balancing_mode
> bitmask.
> 
> No functional change.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: David Hildenbrand (Arm) <david@kernel.org>

Agreed with Zi this can be picked up separately.

Acked-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory

