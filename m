Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794749900;
	b=kKqLwAyiwQYrBxcOR8aWjL99GpnGYAyvovTVFswymYgzNt7zUREDag41VVB9mBg1/4m8
	 iWjz0+QaYcYUM/L36PWaeZ2Z3cRlpB5UjPUwnUW4GU1rXtnQ52MJ0dQt+AJjgj64gUmzq
	 ALKHjlw5R6g5akg/Z4rqJsJUhk0I64O467Psuw8WAClGHQALMuYh2M2NEiuYBlArI5N+D
	 ljGKpg0ck7R78lIjOsnQBIArxBOHJFfr14fA7yw17VHLyS0CcwxpPgIFYYKKdaczv+m6i
	 hphURoJV2gy3nCbbjWbFmEg6hgfZnHLV1DZ1vBTQxO02VYoekjIL4Zi7Q7MzkRVSadA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749900;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=wc0p1pQYXQO+NKwG/7057xQ5jQrT9EGibnAMu4kS01M=;
	b=cuW1NSfvxxU1/RdNMaqh6321lZrMptka2iBST5Qjx94STG7omQBcJWKcmTXsIvAArMy3
	 KWy3Pn3//lULzKvseaqwrKFkQT5bdPCU3VE3c0PGWj9YxE40cMobs8kOoT4sDUFhdCRL4
	 It+qxFQ37WnUMd5w6W00iY822O5lLNQfVnSYK33WB31efZLJVw+OvAhR6MXXR6qa0nXPC
	 yeeFEbBRLMzf6mTEc8ztdhZyp8ufq48wCTTujaInzkji1XsyeeRWXXFr6Uw7osjwm/l6L
	 r6lR/w6JXUK3CXduLHSiLrZ73ZvPcWYmisjKqAxynADOqJ30KpGZBqCrw+MA9mrkIjA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YYlr9kBY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8E3606A31E
	for <cgroups@vger.kernel.org>; Sun, 15 Nov 2026 13:38:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC8E3606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YYlr9kBY
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5c10dc41270so2799133e87.2
        for <cgroups@vger.kernel.org>; Sun, 15 Nov 2026 05:38:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794749898; cv=none;
        d=google.com; s=arc-20260327;
        b=XTX41vCDCgh/OmRez0/6jVqS4fjfDWJTNZLU0gpmsyG5sMt39zP8VcJhGqWrjdDXO4
         UMiTic/eRO+DVP1i/Rp4df3uGD+t0FA9dYqj5KCJeqhkT9oip1kYO1jjSL1RFlm+5Ghs
         YyCS97RB3llWQTaNPD3KJhKDDdcsLLjAhv+WyLCyMHdOp1QJEepdpA/rlJEwCrvOaLVv
         gJ5GuHnDWrQzXDEFkbOLc2W8iDSGV7IAvLw0tttIRCLgOd85WaTghwQ5vSAkg/ohQwCX
         bBaJCRLbSz+GMvBwzxikAxjkVA83Uug3Hov/u1U8tLv5kDRm2CIoUT5taGK0958oSdu8
         FVLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wc0p1pQYXQO+NKwG/7057xQ5jQrT9EGibnAMu4kS01M=;
        fh=pC3TOuUZbuimd0UvPMqwaFYgF6Tqyesh16BlcJ8Resw=;
        b=H8lp9Qrto2tjhl6RBe4wQsuueYfq0VuYI83i7d0CBCs0T+7iJlLYP7F2mJ29MUHy1e
         BF0olVqScEENww4SzxjKAI5kNd618/TyEhcNE83SSGoK60DhM6Hb7urcoV7NfVhukhiH
         RiUV5bJmNoeay2I4OHC5J9YumCH8mp7VZ9Kp5N1gRwBU9uC3Wgl4QNrA3yE5z7ipk2Ni
         Sbv6Da6r0vQp2Gwe5kUFz+JufiV8WbvuhKn27xu6RVXjyPPtgdd2K78WZuJxUqkWOjQR
         n2g95hsQrRl028rHW/Sv7siT+TuLIWRQudYqR/eUCg1qYRXyFEVTyXsUUoKdnjdyDNRK
         knNA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794749898; x=1795354698; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wc0p1pQYXQO+NKwG/7057xQ5jQrT9EGibnAMu4kS01M=;
        b=YYlr9kBYDtfwjplR1uCSL9Ig8aDVsSjFdt2UvTSvpSug+pkAjf4F4iOlt96GZVeUiW
         pNwMkqyXbNazITwly6K5Rf1BiSqSSl+yMGkISG10CDxHof9PXfZTCJNBIKzA8qM3GzJ5
         dde0lmUnWUahlEbkZvSTNRXZxSForITQqScaEsSKh2wJPlUFJh1BXB8w0aVbX45SUv92
         jPP7H70UEZtGAwGi20B7t+upQUn1T+qfsSF6nhgytEcyD+lfd9rgf9jhVQanzHe2iN0e
         8+C2kZem5UnAn72Z1yqMHAdV4YEIuK2CrwQKSJBPP3Q/pjuBoDA89sm0efRnb2p/IebJ
         tctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794749898; x=1795354698;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wc0p1pQYXQO+NKwG/7057xQ5jQrT9EGibnAMu4kS01M=;
        b=tj4BRSMCSM2LU6Bery+rQknM/4MJzyIYTjFHrHn3Jy5yVCNLfKPy3Ih8oN26pyT/t0
         TLCCUmbZGQdaunfGqYuhPZSOyopQ8iEjRLOnSBVtNKSIhp83GLbmqQemQ8b2KDvZz2E2
         u7PJpTLDpLbH3SLcYPOdSLmPOhY/K80BUAmMhjFzx4HMDg2Kma87kb6YTzlKaNIqFBj/
         3tP+SDXB00IYXFH+jpy2m7Xtf/FrEmvLKko8ykhm2ukn+Z2m6Aw/XEE/ZFxIp2lJgGVW
         e7hjTJiWNWn5f/1/Bi0JQLsyGK44U+RpsTS4ePkglxQRo7DJkgOy4CoN6w+42u31+TQd
         Xnig==
X-Forwarded-Encrypted: i=1; AL+hErGoyjbWBQ25EWA03Ahd9bV1Jueb6yxRkZLy0AZKIfp6VE/eaPCKYchFIDsKOBWPmCOoZivEA12l@vger.kernel.org
X-Gm-Message-State: APuU4Z/jpn9P4LQbOpFmoP2dr8KBKU3OtO3bjREn/ZtQ9t8HBfSwdPdC
	eLe1Uj43M3vs0KsJatL9VNVJPD+fLqsKmsTfQh4AZgSPMs5G2aKn2YrS1hiEFs37fY6gr36UurA
	Tpw8ZTZOn+eKULp6Tr5vVz6DyyOHEyqE=
X-Gm-Gg: AYBFou0YDXGSpdcCTknEAZQ3J3HDyVTwY/iM8FQmretNYz2vvchrwSTMFIzZuJ92gYL
	Obe8ViVVxPbopOCC4CqNU/3ThJLd+QHMeckiRXa8k+cqafSWvyerKwLXs+NKfC9hEUxZPfs9aw9
	2EpeT0wJ/H/0YlN3bWLvDU/EDtDEBbNDSLNldlQKHk/eoHPftI0ze+Nn/blV75QafsLlEespUt/
	BVXY1v/mM74IlcFpiJnRkSWjaBe9SNxr1fqaqFAEwA2KE9yfh7goJknnqC/o9UaeLMAJ6tYsNsG
	nH88XgcwU18UIxgZ1TURP0g8R4nmRI7tZ+jyFFm7sCgVH5v2YZWPAuHYnviNoSPpef/nOXPdQBS
	bSWDuW2YpQ35kXF3rnEejbalQ33Yl6IeZujMocbpbl0y+9QAsKUg87Lv9jlEOFfkCf3lqy1csdx
	HQ3OJQYL5Z1kSUS8+KaTGGsd47QL4z
X-Received: by 2002:a05:6512:3f27:b0:5c0:d9e2:f66 with SMTP id
 2adb3069b0e04-5c1709d6adfmr2815178e87.20.1794749897634; Sun, 15 Nov 2026
 05:38:17 -0800 (PST)
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
 <179438454803.6.16655549133383619919.zswap-rstat-counters@gmail.com> <CAJnrk1YzYswBKv5F3=FF_o_4Pywgw0ifLq0tXYSWO7TARnFRJQ@mail.gmail.com>
In-Reply-To: <CAJnrk1YzYswBKv5F3=FF_o_4Pywgw0ifLq0tXYSWO7TARnFRJQ@mail.gmail.com>
From: Chengfeng Lin <lin2530632123@gmail.com>
Date: Sun, 15 Nov 2026 21:38:06 +0800
X-Gm-Features: AclHuK-5ywgI9_mymL8VnEcpC74I2pRU7d5bhSxPyILgrbhzzhuo7cVYo0AazQ4
Message-ID: <CANGjgdnTjbou-XFqip7B_cGjrfZzZpan3dFuAk1-rU3bJOu8NA@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Song Hu <husong@kylinos.cn>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"

Hi Joanne,

I tested the non-forced flush in our setup. It delivered PAGEOUT CPU
savings similar to those of the hierarchical per-CPU counter variant.

The only change in the non-forced variant was:

    __mem_cgroup_flush_stats(memcg, true);
    -> mem_cgroup_flush_stats(memcg);

Both variants used the same MM base, 2967f3ccdb5f, and the unchanged
reproducers attached to my previous mail: 32 MiB with one worker, and
256 MiB with eight workers. The finite memory.zswap.max remained 64 MiB;
compressed occupancy was about 18.75 MiB in the larger test, below the cap.
The hardware was the same i7-12700KF with microcode 0x3e.

I ran five separate boots: baseline, non-forced, baseline, counters,
baseline. Each boot had two warmups and nine measured program runs per
condition, including an unlimited control. Reductions below are relative
to the mean of each variant's two adjacent baselines:

Finite-limit PAGEOUT CPU   Non-forced             Counter variant
1 worker / 32 MiB          12.640 ms (-45.72%)     13.276 ms (-43.04%)
8 workers / 256 MiB       202.784 ms (-84.03%)    207.455 ms (-83.55%)

These are summed worker CPU times, not elapsed times. Whole-program CPU
reductions (non-forced / counters) were 22.57% / 20.97% with one worker
and 61.82% / 59.97% with eight.
The counter variant is the same hierarchical per-CPU adaptation tested in
my previous mail; it retains the existing rstat updates.

PAGEOUT CVs (non-forced / counters) were 4.65% / 4.33% with one worker
and 2.91% / 9.26% with eight. The maximum absolute PAGEOUT baseline drift
in these finite-limit comparisons was 1.69%. The small mean differences
do not establish that one variant is faster.

Separate instrumented admission runs also confirmed that non-forced does
not mean no flush: the limit check performed 53 / 818 actual rstat flushes
for one / eight workers, versus 8192 / 65536 with forced flushing and zero
with counters, while successful stores remained 8192 / 65536.

So the simpler change appears sufficient for the main benefit in this
below-cap workload.

Thanks,
Chengfeng
