Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0233C3C3C14
	for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 16:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789921220; cv=none; b=QKChedYpEM6s21lLR8p28TDGeV3ylHlJ/bsLKk/pQCN1Vk6vRawljbbJeV2Zz7TIDAcza8g79pp2jszvI+CW3n8PuXOFlgODm4ESr1prVwc6xkDg7BP/MXql7b2dVdTYC0yJbN1laaEAhCE3IRMbQOTCYMss5Fk8X/feH3KA//g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789921220; c=relaxed/simple;
	bh=vy+mJB3Db1v2pbkJ/M2R+/MB10DPkK/0qsLGoEZF3PY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8mIb/aRwqIPB0kR0fQT3I439cQUCR4jmUKa3c6mg60aP3hWDTH5/9hK11/uMciv0tnwK+fxsg6V6qAle5OWCmK7IBHV3rStGhK/Jv6hNO+QfPMtNxVEx11UvU9dcqU61dyzWa+prjLfrIbUvB91Oa96qq6G16nV9/aZ7EmzMP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lXAyp8Wl; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lXAyp8Wl"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469d249c4so2006577b3a.2
        for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 09:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789921218; x=1790526018; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ua2PeUg5BEcfgC5FSR37S5o47FCdmEaQbiS+1Z8zlCM=;
        b=lXAyp8WltKlGTIsJAv1F3x1AL7PZnHFlSXPh99tXia+Lu0HzLjJUCr7c4P+Fy1161k
         Lyb9GwK3Lee3/ExKc3lXuS4QOPxxnOHD6LDhASyXRQXFZllUl9hcgomU6yDBcVV8Bzku
         5EVP/8IkdoIuZcqdfTVr1OdDzz5PQPf1ToNuyf4ec0QwKhb9MMpm+8DO3Pfn71shbeMn
         fXfKgPrirXCxtBCB17LoKDpLuS8RnWfPlqe1jOAtK7m3f9F3eqzsFZevtTnlsU2BXsOu
         X3sMCdvOWG71TX9wPX4wmx3I+d3nPmPdmboDuN6urAfB5+AriVHkcTq1GFIO7rnjXzmm
         zXkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789921218; x=1790526018;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ua2PeUg5BEcfgC5FSR37S5o47FCdmEaQbiS+1Z8zlCM=;
        b=X9fl9crRU1/D/6jjs5t8GAKRF0KCtfd4IBRNBcdjKSP1BYIfxEq/neRrF1FnhOXGJM
         bMZDvrCsN3ZP5km4DHiWybYgDrsqxIMwguCmlznHd8YGcw9GDw074WtZHe0XiSqcqItE
         xPnucAkmZXF5j4R8I7U0eXcATTqXQ0ILDjONYZ+a90hefJKa+fMmqtjuGFPnD/SxUFyr
         hVd2QvOhscxvwKIfDc9IVKcRAu6+pKrq+0YN4AKGnF0Gc0eo6RfUeroM5j0mUB+8OgRW
         cSL81Xl1tx6hAeUdf7vdae6YRQGgjuzNTLFCZ+o+27t4GxFC7KxkHj7+oc3odbrEzvtw
         YI2g==
X-Forwarded-Encrypted: i=1; AKwUvBwO+YAE1H0AhALeepOuTisfqamGfGt98OJNhoaiYfa1ulThf54vSPZLDIoRJPN30xkt5jmVkKnE@vger.kernel.org
X-Gm-Message-State: AFuF++kA63EVZXI73zGaowA/aDtrSLa0JMvNClnTfU6r4sHcMWMEqxtY
	CVMVhMm01xk3bil33nL1zhrQUaJykSvmYZ+bm7zwtwsLyUneDw/VNUif
X-Gm-Gg: AYBFou2tflhq97sCG1GOc2QAPP5fzl7d1N5zArnnRfXd/wB2LYi1IpyoQX4hfYcwaUR
	XtetcloBQWmDzusa1o76V9TjrY4L1Xkclxih6Eyk95PrWGlVusgNLURHzkNcCavATzko9IES0CZ
	cH0vRQAmmcu7AV8mOMeMorJH+YWjY54c3gBoF25J/Tceacc5YE82yFGGNzttKoVbBdct8AuIqOf
	AfnpdKPmd4u6K0T2oDtDaFTGkHFOv6xLN3b4UfA5RF7vREyY2KhQ6cihrMwrw+c+CalzeHe4XAC
	x7+3c5iKcRL/Vh0JEvkRlszVvglNafmb4UaFcHLmmhiCL8ZlP2Ncvu4rh6gAYRls8mZ4sON7MH0
	9uJoGXVVLRDJzBO8lOtNdQQQI2d7GrN+IS0eoHc18g81ozwRkII74hcQABczFygSykwlz6W/lF2
	2FOLmcRUamUafTCYwyn1fcRJaT7MU5KS8RIhhMw78f+Ox8qbukRH4Ha5x1YK7WNCDBSUcnMJ9Ro
	kcfEGS4ncBZh6g1mg4EjTNxADeXXviiAFZfL5Kx58Q=
X-Received: by 2002:a05:6a00:ad89:b0:857:726d:2e99 with SMTP id d2e1a72fcca58-874dd7f8d8cmr12002193b3a.22.1789921218131;
        Sun, 20 Sep 2026 09:20:18 -0700 (PDT)
Received: from gmail.com ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877aa1099e5sm2093196b3a.49.2026.09.20.09.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 09:20:17 -0700 (PDT)
Date: Mon, 21 Sep 2026 01:20:11 +0900
From: Youngjun Park <her0gyugyu@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org,
	chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, yosry@kernel.org,
	joshua.hahnjy@gmail.com, taejoon.song@lge.com, lianux.mm@gmail.com
Subject: Re: [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with
 per-cgroup selection
Message-ID: <arAHu_BD5oqpZJER@gmail.com>
References: <20260916183437.2946306-1-youngjun.park@lge.com>
 <20260916200434.GA5784@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916200434.GA5784@cmpxchg.org>

On 2026-09-16 16:04, Johannes Weiner wrote:
> On Thu, Sep 17, 2026 at 03:34:33AM +0900, Youngjun Park wrote:
> > Per-cgroup swap in debugfs
> > ==========================
> > 
> > Patches 3 and 4 let a memory cgroup choose its tiers through debugfs.
> > 
> >   # swapon -p 100 /dev/nvme0n1p2
> >   # swapon -p 50 /dev/sdb2
> >   # cat /sys/kernel/debug/swap/tiers
> >   Idx   Prio
> >   0     100
> >   1     50
> >   # echo "/batch 0x2" > /sys/kernel/debug/swap/memcg_tiers
> > 
> > Bit i of the mask is tier i, so /batch swaps only to sdb2. A tier keeps
> > its index for its lifetime, so the mask keeps selecting the same tier
> > across swapon and swapoff.
>

Hello Johannes,

Sorry for the late reply on a good suggestion :)

> Can the cgroup be given a priority limit? That would have pretty
> obvious inheritance semantics:
> root
> `- batch (memory.swap.prio.max = 20)
>    `- task (memory.swap.prio.max = max)
>    `- logs (memory.swap.prio.max = 10)
> `- interactive (memory.swap.prio.max = max)
>    `- task (memory.swap.prio.max)

Right, the inheritance is clear and easy to understand, and with this I
can pre-define the limit without knowing the mask value.

But first, let me check the intent. Is the point that capping batch keeps
it from taking the faster tiers, so they are left for interactive?

If so, that matches our use case. Latency sensitive workloads get the
fast tiers, non-latency sensitive ones get the slow tiers. But...

Even then, the reverse cannot be expressed. A cap only cuts from the top,
so a latency sensitive workload given max can still fall back to the slow
tiers once the fast ones fill up. For example,

  tier0  tier1  tier2  tier3
    0     10     20     30

there is no way to say "use tier0 and tier1, but never fall back to tier2
or tier3". To cover that, the interface would also need a min value, or
some way to express a range.

And even a range is not enough. Excluding only tier2 leaves a hole in the
middle, which no min/max pair can express. That needs per-tier selection,
which is what the mask,  and what I'd carry over to the memcg
interface later (Currently memcg.swap.tiers.max).

How do you think?

Thanks!
Youngjun Park
