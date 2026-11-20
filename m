Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795200818;
	b=HUAYLQJ/YUYjWbOTOMoxOqYzruo+XuO5ptPqpawiB3ep0W/wjPzqYH3Gk36n9yDRNbxY
	 6X7hiYbuvCGU9FJ5T+05ozk244qC1CQrXEJSDnwZV1V9fOlOPdx6UgrruPg1PsEyRgtVR
	 gcoBSqKAku4QvHLsulcyO/tNgrQ2EA+eP/Vlmuw4Y7EIX60GyGekoDARGHNlR/YKjcgR7
	 xSNQa+JvEbmc2xnHhBez/ilAswtB3J8NjBx36esN5B3nKuyMx+CMivdpNFt1A2jSpUt6t
	 tvWJZ5nM1rxdinXqqgzIM3SrC75NTzOqcIHuWc8PCfVi5/SanLAGtvxkje0DaTAOTsg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795200818;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9sT5pKOPeQasJwUhxA6x5muNzyWLPJdu9Xt2Zxrlxh4=;
	b=K2Vc4n6jJEMHTxwID0WvpqcLrHkTcUpf3MHQ4rId4WRamqsBO61xwjt9yc25ON12ULol
	 X6LrgI/VBgbovCDJhC66IRoMOQVa6IzHOomy7jdh/eGqG7BljLopn8CkpQdjKzn3PHHdw
	 p+1bWfIdcFnKxqUf33LG62VzMiSCUcDkmINedn8MrgCIN0pMCDae1x9+MOsnQPqa5TrnU
	 Jl0X6/Qf0HObBvQVVMDEBTuWkRZaBT36GdW74YwqsnMQ3G3acj1mSJHfYE/BDOIIjqL2A
	 1/xiLux/F12bU9leW+5jd5NKEXD9I+Z2vV7kqPx1fYCoE+CyHGB0AumZuhbpX5qdNDA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rw5csPJs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43430606A33B
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 18:53:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43430606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rw5csPJs
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4a9be758734so812503f8f.1
        for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 10:53:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795200817; cv=none;
        d=google.com; s=arc-20260327;
        b=DV11swfnWzwl+9LrgyrUJfV3+lwv+n5YcKKA6a/OtZSVvU3v8ZMldRSTS21xEa+V5q
         7i3YoXqoaznHSlQM01hYEyQtr2JZCR+310wSNRrxEcJZhOBxL4JhDct3YgouPfssv9Yt
         CBQgkgFVYeE2J2BuktOrMh4oc2pgX8BAD1EgO5EnlCvnH2PgRS0z6Ogpit/bmx+PxkSE
         wp/DgIOb+o97+Kx3vrPhHNo/lom24/Wf9V3HKFIafT7N7v8HkD5oiiYVIxn0FgDwEHUd
         Dl2BH3lfTGq3HcMl/JpLz2EUWka5C0RayTqwo42fMdQivH1rHcdjh/02XIzsPgCYh4Pb
         5MZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9sT5pKOPeQasJwUhxA6x5muNzyWLPJdu9Xt2Zxrlxh4=;
        fh=Wd/U7gHJodHPJOZpGrDbFLHEzMva1wff8jlLucsQf84=;
        b=SYLb3VTerh+Xqrc7sxEnSs9vcUFRxba8R3v3sHoTDwpRElqsVV9MbrqLm4oT9DS/2p
         4uxcSQwM1VgNcAPSDB4f5fdUj69ZF1jdPld6SsIXUoZg9M6wcLub9RQPEBRA2OpcUNE6
         zAiLV9ig0oa6+8Y65myTq+mXNnn/jvWb2cBL/UHgleUGTLOsTpYOU3/JBq/yUwBNrbt8
         5/b9oo5jP1+vqpyAmc+V3OYbClNILHFKWVvy1gHlySpNsi0nD0NxizdR5WEaBRZ8Pqwr
         p/eXLSzgb0sri8VoBL0BJt/bnj7/64PziyDxID+FwJ9U4KEDiPfViL8enHT1Xw3KMIi4
         0e9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795200817; x=1795805617; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9sT5pKOPeQasJwUhxA6x5muNzyWLPJdu9Xt2Zxrlxh4=;
        b=rw5csPJsy9Grjv/kuDIkQSXttCNYOg6+rxmUPkkASaR7hWAbzckAvDPMREyWl41Jpv
         6Wm4HIb37WTD7f4yTaQh+u4hRgprD96xHlk/B2phHMxFlPNy08tezRtQWluJzIaEjUUT
         PPuzW4vTJq86XyFDNlVSKVe5AIRdRzYZW/eO0yRqe8COET/d48wXeOwyg94GVNqvy748
         FWFVvoQmBR+tm46nKnmocK2A8XvnLiQch6HurDhEHcRra4Q3yN8jMhVDEiN8bCaymXly
         uXLs9MHrnh3ERbakZWvGtw9nV3LjfdNqtxGygeVv5OkZh3/K8meJgem6swkzw1Yaiaki
         tePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795200817; x=1795805617;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9sT5pKOPeQasJwUhxA6x5muNzyWLPJdu9Xt2Zxrlxh4=;
        b=lPuFPd94Ukk6+4CkvgyHyXr1whTVwwxiLRT5JvS041BRHSmHqhSF9K5nWzryxeea2W
         isK5W2OP7xgEUXAO1eQ75gwLjj0r3gCigLhTSCtvBghbUDiuKPVMkExAuWTpXSsbNjzo
         zBYVlBtTljeLngnPDdU9BTPZhDfto37q6ul992s3wy+8OIcAChDbxWqdzbhL4sbkh+Wk
         InJHm0df/ds8ywUk+UdxKvoZEcuJnC+Ryj7DVjjs5LKjZvkxFLHXw3MsLN6OCCGvnWu9
         LMp3Z07Id0U3B4jCnjT6IB+5Cok/Yn7T6xDAzqWekmMZ8+DWw1GBU9gvqEotvhjowynQ
         2n6w==
X-Forwarded-Encrypted: i=1; AL+hErFw9J7V308uYZkWr7JbM0pxGTt1CTtfzM2nS5pJCEJibHx7a2tfn9Scn5drk1WLUwCdIOikX22N@vger.kernel.org
X-Gm-Message-State: APuU4Z8yLcCMzbas8xU4wiHY/Bxb+bpluIRDa38JEN1c9N1ZaWe8Xrmu
	/Rsb57WQIHFzSoHZvRuw+LuZnGeOqX8eAJqpsqdbVq4pviNY163q15MGpJEDR9JWIfyYGcpXJ8M
	ACa7m8a3qOaff5KqDDm2PB9WjK1L8Jog=
X-Gm-Gg: AZFdTZdenwdnAQJctDX0i+xHLWhjpDqyfT5DOyMWmvFlTcTvz5qJ6lUkgw4/w4xIuqq
	2eDltjVjvsYHWnI3Lq6YNsz0PSsOGtMG4NZZ1H2fbQpR1CVS180GfXJSCJyZOTnhHT337qvKGb+
	7SaTTjWfvwhs1x0eIbAo56Q2RdmOWVN2PpQ3gMRqok/Yzmb0dyqvfi3KKtRfqk7AicDia0/XvTH
	qw8a+vSj0hxbq8EqleLYoL5zTy/O9HO0WhbsNqh+MvzauWdvhU/S2GlHFG31Mf4luUTTIWSHVap
	qu0kapQXxIBCsrIzCE1tIcbYvY/1OQqzfz95r4ySdmuOJQBOKw5sB1rIh0Bnkkcml0HEY0JOO7D
	zDmK6cUDKOa+LVnarvJYu8bXRRvIO7eRh00yw2KM4JJis318XoPTm70SCgP7buBozhfVCZU3YNw
	oMT2cY/l8C4WuKJxiTmLU=
X-Received: by 2002:a05:6000:2883:b0:4a4:39bb:970d with SMTP id
 ffacd0b85a97d-4abab02c469mr8089761f8f.2.1795200816511; Fri, 20 Nov 2026
 10:53:36 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <CAO9r8zPqJncFKQbF3tGe1d4sg-4dLQ3dQRGze_vab26wWrXTqA@mail.gmail.com>
 <179438454803.6.16655549133383619919.zswap-rstat-counters@gmail.com>
 <CAJnrk1YzYswBKv5F3=FF_o_4Pywgw0ifLq0tXYSWO7TARnFRJQ@mail.gmail.com> <CANGjgdnTjbou-XFqip7B_cGjrfZzZpan3dFuAk1-rU3bJOu8NA@mail.gmail.com>
In-Reply-To: <CANGjgdnTjbou-XFqip7B_cGjrfZzZpan3dFuAk1-rU3bJOu8NA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 20 Nov 2026 10:53:24 -0800
X-Gm-Features: Aa3M54oX3M667iXU9--_PVn5exl7P5ruO3wAPnPpv8aIQlT07cgivJguladt78o
Message-ID: <CAJnrk1YRBkoMppbn-GitdTXaNmpCf8kM2WHWvSfNPzNygoqw+g@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Chengfeng Lin <lin2530632123@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Song Hu <husong@kylinos.cn>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 5:38=E2=80=AFAM Chengfeng Lin <lin2530632123@gmail.=
com> wrote:
>
> Hi Joanne,
>
> I tested the non-forced flush in our setup. It delivered PAGEOUT CPU
> savings similar to those of the hierarchical per-CPU counter variant.
>
> The only change in the non-forced variant was:
>
>     __mem_cgroup_flush_stats(memcg, true);
>     -> mem_cgroup_flush_stats(memcg);
>
> Both variants used the same MM base, 2967f3ccdb5f, and the unchanged
> reproducers attached to my previous mail: 32 MiB with one worker, and
> 256 MiB with eight workers. The finite memory.zswap.max remained 64 MiB;
> compressed occupancy was about 18.75 MiB in the larger test, below the ca=
p.
> The hardware was the same i7-12700KF with microcode 0x3e.
>
> I ran five separate boots: baseline, non-forced, baseline, counters,
> baseline. Each boot had two warmups and nine measured program runs per
> condition, including an unlimited control. Reductions below are relative
> to the mean of each variant's two adjacent baselines:
>
> Finite-limit PAGEOUT CPU   Non-forced             Counter variant
> 1 worker / 32 MiB          12.640 ms (-45.72%)     13.276 ms (-43.04%)
> 8 workers / 256 MiB       202.784 ms (-84.03%)    207.455 ms (-83.55%)
>
> These are summed worker CPU times, not elapsed times. Whole-program CPU
> reductions (non-forced / counters) were 22.57% / 20.97% with one worker
> and 61.82% / 59.97% with eight.
> The counter variant is the same hierarchical per-CPU adaptation tested in
> my previous mail; it retains the existing rstat updates.
>
> PAGEOUT CVs (non-forced / counters) were 4.65% / 4.33% with one worker
> and 2.91% / 9.26% with eight. The maximum absolute PAGEOUT baseline drift
> in these finite-limit comparisons was 1.69%. The small mean differences
> do not establish that one variant is faster.
>
> Separate instrumented admission runs also confirmed that non-forced does
> not mean no flush: the limit check performed 53 / 818 actual rstat flushe=
s
> for one / eight workers, versus 8192 / 65536 with forced flushing and zer=
o
> with counters, while successful stores remained 8192 / 65536.
>
> So the simpler change appears sufficient for the main benefit in this
> below-cap workload.
>

Thank you for your work with testing this, Chengfeng. When I come back
from vacation in three weeks, I will submit this change as part of a
larger series and I'll make sure your email is cc'ed on that.

Thanks,
Joanne
