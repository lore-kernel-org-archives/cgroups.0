Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794496865;
	b=PO2o9I9wk8EJMcgj87B29+yjaUat07qDnUfdF0sIZ3q8PzbKK4IJEHh2BbsAC9KH03Tl
	 gmxbmZ86ofnt5RI68/PEdLbpQRQKrvODRQvigZFpeslvuXUSwXnvTZ1FNFV6bGr2+OFRL
	 xLH7kC6vyh260BOmDAZQuZTEWgaHSOn0YgBor2tiIPsFcSCyr3vQDl8uMy4KC9ome7okZ
	 XbeVQ14SRVyaRCI278JZCp/q1NBp/NrGryAG+A/hKsw94DjjcaYnHCbtdEKpYzvSxL2ux
	 bcxAUWhL8lM8eWlscyce43yOTUtQ/K5eTcL0kkIhtco8o8l1vuZ8VwZOW212rUyxZ+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794496865;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=GrQWj8i0KMpWLvGJmSZCRH/S1lTxVViz3a0mVq2HUbU=;
	b=Kn6saQwbqDU28UqaakdC7WqQFPb/ROTem6BhNdYitra67Jw5VHOSTB5bFe3wDHtC6cjS
	 2FJIPyw0zKrm59alCPcxrtz2nlxJF3DanYxwL+Ow60mqNo567JOVY/wBjtNz+LDF1lbtP
	 b/7zKqfrN1MEYXHhES9kAJ/CaDyBBjZHQZpLhPIy9qbrNjHarZPdfQFuy6gagSFY1kq0X
	 Hqxa0mi2SiBERW4+hkGT2gtDO8Ppip96zeE27zOTE1LwkQLTFS+KsibrYbXe/L4BSwO/q
	 3GY1y2c01Id287LHUGfSWhUR1z3QXIcYjmfNIsW/dI+xy2qrkYCCp2brNpVURjARJEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmpxchg.org;
	spf=pass smtp.mailfrom=cmpxchg.org;
	dkim=pass header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=ggQnnAzW;
	arc=none smtp.remote-ip=209.85.128.179
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF5260A2607
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 15:21:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BF5260A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=ggQnnAzW
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b32bbd39d5so36223507b3.3
        for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 07:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794496864; x=1795101664; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GrQWj8i0KMpWLvGJmSZCRH/S1lTxVViz3a0mVq2HUbU=;
        b=ggQnnAzW2tUrxbYZukvFoa7FkGVSd83TsnR33Ct8XFJkRpgtyATThxwMCXzgWaKWZS
         HmRCgD8kzAtgX1W6cJMMs8MR90/vUe65QcJtX+qH/LH76cLleMocQfmYch+ouc7RR3Ir
         dVbMMW03JOMSXfjL4VmbLNN7t6+fKrpaoTnxJwND0GtPqGvj7KU5xWgUyeRH4pP5+1Yu
         X+uGZEeUfEnqHOGeJEro3ajanho9vv3hMijzffpOEMrnkr9ECw7DAlsDKrPSy2y4yg1/
         vWPwjJ8wID0yWPJIclgjKldW8bd/XmmAbnoOoYIFfX3/YWW5dyB2POUQZvs9Zl1zgKBM
         DgqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794496864; x=1795101664;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GrQWj8i0KMpWLvGJmSZCRH/S1lTxVViz3a0mVq2HUbU=;
        b=a2oj6FYg4joh/8mdWt4PaOSB2DUyvG255mg5p+OS9sH4mzQ8nyivuRBzAXgnx9welw
         wL3g1AOHkudda3O9dXVOqqVZZZaPaOSgt+n/zbFLyjgtMmpGuOCqmTlsUMZ0RROToEj/
         8wOJRo+QHz7fKABFB6Dcz+6GkM6MEjV7BglfE8VOk4l2BnksQPICnMj6pr46+gIfAPn1
         nIupySa70nQFXQstLjh69gQn3myVio734t11/e8bHiMECewW3tF1eXOwL6YKnmMrwGyl
         UzYpjX6/ns/9dRDxmvxL5/VHiUVeRbLJNaozgdPq162bHTjwcfm9KdvJDc80KOPOh7WC
         B2ww==
X-Forwarded-Encrypted: i=1; AL+hErHu1Oeb4rRMDEhxDGFudk+sWVfe+gnpXYfYLMdR9yqzO8hBARhrah/EJg04iiDgva8VAZZjWygl@vger.kernel.org
X-Gm-Message-State: APuU4Z90e9IPBlD/sqW8syDkr3OH8IhE2vPhRCehrBUOkKM2mIh1eQkx
	HQgs9qm36eOknFUxgHgBmvFqPmeahVLutkUtkw+T4kmSyy4FcSzqFohJzUBromuD8rg=
X-Gm-Gg: AYBFou3Kc27idKFFpNDIHtVfoeJKl/FkeQGJ+D0Wk5WZ0qieunGM3OYTo1aP3TUfqWH
	Vaz1Hvwirvvg1Wzt0V7hR1Qthc2nDSyJ0Tdp4lriQdIRtlMnE/l8D5yQsz7tmkx29L5puYcKbT+
	yThoJYE7ZtHmVcAgwzW3OjjXCokTx2udwDifv9QOJdhrGQ5M5fXVMF+3ByIDakelWAnSvrQI7CL
	Kfi0nUXtPn7p+mX791FrYG9XcSJ8phC0yZDHhmAcDsj1rF6kCNB9iVmLTFcD8U8ZEHoPy5Anc2f
	45MfA8s35bTFWEmB0bTgeGceZwxaLjLLYM1Vr6mJkrFteHKYnGGcNYxssnAhU07lOPGmiiEJIGC
	WE+B27k9Ybg9Owv7e8S1Slm5/vOuB9g3iVzmpd+0IjClOFuBIE2L+SfD6rPWRVMVvG1bONS27a4
	0AHizg2mkEDgSNhXog8Z3z+5wyazqIMHHKMK7reca+2eLZYrle6O4+g/Ruggz9fljrutxzwl0/+
	l/RWpwJdyu5rG1VUlQztUEn5sGVFU6MwcgFT0IG7x+vsVZzfJx6tGJsx0f9uoSp8GUFH1ZIodaL
	AVIChuLBhuyo/mtTmslB0Xkdrh5X
X-Received: by 2002:a05:690e:1519:b0:67c:23f2:41e4 with SMTP id 956f58d0204a3-67c67ee5aecmr3870192d50.27.1794496862680;
        Thu, 12 Nov 2026 07:21:02 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67c58a0f312sm7504466d50.19.2026.11.12.07.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 07:21:00 -0800 (PST)
Date: Thu, 12 Nov 2026 10:21:00 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: flush nr_charged_bytes when the obj stock trylock
 fails
Message-ID: <avXZXMp_r5VVXS-W@cmpxchg.org>
References: <20261112013220.4064478-1-shakeel.butt@linux.dev>
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
In-Reply-To: <20261112013220.4064478-1-shakeel.butt@linux.dev>

On Wed, Nov 11, 2026 at 05:32:20PM -0800, Shakeel Butt wrote:
> When interrupt code, such as an RCU callback in softirq, runs on top of
> a task that holds the obj stock lock, its trylock fails and the bytes go
> to objcg->nr_charged_bytes. Nothing empties that counter while every CPU
> using the objcg keeps it in its stock, so it can grow without limit.
> 
> Users see memory.current and the "kernel" field of memory.stat keep
> growing while the cgroup's real usage does not. With memory.high or
> memory.max set, the cgroup is reclaimed, throttled or even OOM-killed
> for memory it does not use. The counter is 32-bit, so after 4 GiB it
> wraps, and those 4 GiB stay charged to the cgroup and its ancestors
> until reboot, even after the cgroup is removed.
> 
> Fix it by uncharging the whole pages in nr_charged_bytes whenever the
> trylock fails.
> 
> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: stable@vger.kernel.org

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
