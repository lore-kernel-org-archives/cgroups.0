Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2C137E2EB
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 03:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791948271; cv=pass; b=ipY5SCLzaGaE6VWHx+RNtyjZa+OTKw7Q3sdJaTsmTsv8af0TP1sjbBJBqpXAM4XjeZwaYYhXkCZ2XjdV6aYlFRHEvG7ybcOIfxRiZ6LANUPxq5tmxESDuDmpOVULyKke3c8tHWaFLRTwsGDRDvDK5RH82bvGkitMhI4QZkYPjGc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791948271; c=relaxed/simple;
	bh=7WV/PgD0jc90ZfW5o6KBecMjjiz2ATBD8Ix0KIOuLqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qtc/qnfs+H7mIXfDmR7DMuEod7bMwSsex92w0VDpgcEjFmaZ/HcG8K5i12r0ojheo9QgJaBwlaD8iPFgK0nwUyPKXpIHIZg8tuVEIQMFXIfrJ3SUCOo+KW1MzMGoW0hVyTLgKN1ayhSVvZwQ9BwD701W2C9+3Tp3FyR4kETcMEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oEri3Ohl; arc=pass smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oEri3Ohl"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-676858d42f8so2960899d50.2
        for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 20:24:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791948269; cv=none;
        d=google.com; s=arc-20260327;
        b=g8bPXOjW1WJ8uTCD3aq9/+eJm9Efc80EZRmOseBVcqV8zGB9Q6IASWW82i5cDZIFIG
         3E+0lUf90VmFRECh/MeS++D46mz4sQS5hSpQLuG0MZZsnARDTuGvGyFfQC2qAwP5G3xz
         /+S4O4gPrIlYbCWqHdHHY4LJF1b/wHhSNrR8GSY+E/dI6jkCyJ211cJnbNGYmMsbwZ2W
         JMwk0GQCdR5B18qhyaK6qWG8PxUkFycGkK6pU7twvSabCpz+ayOE38vRUDaC3Vgkzi1T
         uSo994y1d6c/DiFI2BRFthf7rdmFxuIgJhnacIvi/wFScIBi8HhgjZzKvnmxrDzpzoUn
         GaRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5W3Yp3oK6NosuISWrK7hbNW+ZeNBXIIyZITKoeVCL+k=;
        fh=L3IdCWKTwhLsqOsQb+f5vGNpzXWqJ8cDFYjb5K+YjzA=;
        b=ZyGgTa6gHoFAvG22vOgfBdNYRWYGvxSddyhbMisT7ut3oLkszrEDKfjAnHyPkXE3dv
         IQrLNmnjeNmXgLzeiq3l2qWGzoh0JDEGlp+ITKcOTTo+ZNqBH+Z+7A/ynQaFef4cTWUY
         dmhTtLMorDIwznHPZWKAf9sDOVrThiT4eV+zkk1a/7KmI44+32vs3mO4Caijlq1/8MOw
         7Nle8IQEz0S1xDJ+we4RPMFuOdn9i1rMH8xKBjyMYGJiPVApJRTmL9t9BMHcSbaa17TT
         sI2MJi21jVpZzIjxeLq3h6A0dXDCm9InRj8jSIxyTR+vGhBuosIrpFv+EjbLe5SfqyXP
         lORQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791948269; x=1792553069; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5W3Yp3oK6NosuISWrK7hbNW+ZeNBXIIyZITKoeVCL+k=;
        b=oEri3Ohl69azgqvvm+qtmq20bwVL9rDPFvQSroQ/unXcByBKp25wv8wHPbUB7o/E0P
         Xjgrg5/XhIbfTuAghG2FbNfdmOHuR5+1eyX63dAqh3kVdRanbtTyJMkCb8v/sExJkEKl
         HpaoGXUdnDEiK3QaZ6Zm11gMLVXH8uMr7IDqTIF8zCSTBKE1tm4HX7RJm72GL4i2pMMg
         Q1TtxhsbvYDtYEtUXQDlss0r86VHX7pgGRKMZ9w2WaP12e5ERUlwJjDV/smzrsJLkR3M
         dQu3i6MDGoAHPh4QRtkYvCWg7KoYJolCie6Y2P1Hzl31B5reEiBu07jiohnRwY/Ppe++
         THtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791948269; x=1792553069;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5W3Yp3oK6NosuISWrK7hbNW+ZeNBXIIyZITKoeVCL+k=;
        b=f2zldBmEjRFjNeDfbwIiQoXuX06NjgU6vISeD5jE40o3PBC3wYjsVMOyMp+FDhMfUZ
         kchlYItF1INtHt0piiNUfWMqpzrqszBPghLPtHnMXpNrbULLUQ1riG5kz6OgH2GFCGIo
         QoYf9HsQUHxepfjgCzcFTmbpw8XY9z+641wqQGWDQ4Um1eWwoAs9HTOHzps3eQJnNIv1
         FitKEe2DqiPSoGgd65oj2ceNqAKxxLrSpdMCBq6e9MnvEv7a3vmk4xCZdEZOY9Q6luJt
         j19GOxryep709Re9urH5jF8V7dJoKMhiMlsrhDgQ2t/u+9X3JUeK8J8C9aa+ujWdgu2C
         j//Q==
X-Forwarded-Encrypted: i=1; AKwUvBxDq+hO8N64zISWFlY6SRXMCH7OKSm4HCyubgIQVTA/QXtKm+8M1ywGydPUMK/SfjMie66WwkPC@vger.kernel.org
X-Gm-Message-State: AFq9FYJyZIi1X/0fCFomH3ewOVn9ErICwjB6ob9BieuFh0qbNiXWkJGx
	jM6WzRscFhbrTFbHMXx2Bbhkqog+zpFXfNN1ZOcsQW/laBrbeBZ5LDl9xSgNtT/77ByyJ1Ihnyw
	693jFHoZyL7NAg5RJE/d8/dpeRsw+ADk=
X-Gm-Gg: AYBFou2S/8YeNDthNr6/sdTNEhtTASSNM9MO+13Fx+O9JUjHKoy3ngPjwdpPlkTIFEk
	ZOWxPivwFiQSWcKMaF6lMar91Qf5tCi31VMHKYiMyfTyI7bqwWPEWNw0fAaAwcLP4RxEiWelImh
	F3PvBOXTGe0lYIShiWvcvHQAp+jCp1Rbx+3TPX3fxwSKp99kHDGgXzWCz1glfFXugdbgKX2FtIZ
	7qoMKNnexSkGTZytfhqZfORjLWIOXW7LmeCupD8sstf9opQXUcmVEptnCQdSebGjbqZ0Yj/od0J
	tdYLUngXybcj9Ws+P4zepEip7rJiJ3G4DCbVFE96UdtW4EtFFubLaiKZ3tl5fjuucl+nEn2VP8+
	wwVgG2tW0kg==
X-Received: by 2002:a53:d017:0:b0:675:74c6:79d with SMTP id
 956f58d0204a3-679362ac182mr3741120d50.122.1791948268949; Tue, 13 Oct 2026
 20:24:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012120438.52849-1-laoar.shao@gmail.com> <d9a3367a1852158f60cc2e89677fb12f@kernel.org>
 <CALOAHbBE_1ssK_26c-UY7N6WxhkVNpB6v9WACVGaOiWZ5zchCA@mail.gmail.com> <3eda489898ebf7c848ce61760af745d9@kernel.org>
In-Reply-To: <3eda489898ebf7c848ce61760af745d9@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 14 Oct 2026 11:23:45 +0800
X-Gm-Features: AclHuK8rh2AW6bZVG8ZqRjg04D-kUz_OaCPBeR9yqJbXuPX4vDKYFO4Wi9z6gLo
Message-ID: <CALOAHbB58xLBdBOZCwJ=4yeKyvGvSsX1wfeAXehD2SGHSmB1+A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/3] BPF-based per-cgroup NUMA balancing mode selection
To: Tejun Heo <tj@kernel.org>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 2:02=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Tue, Oct 13, 2026 at 10:16:32AM +0800, Yafang Shao wrote:
> > Part of the consults are keyed on struct folio rather than struct
> > task_struct: the folio surface answers from the folio's memcg, the
> > owner's request, not the touching task's.
>
> Right, and I take the prctl() point too. It's stable uAPI and too rigid
> a bar for this.
>
> My suggestion is to start smaller. The op doesn't compute anything
> from its inputs. It returns a fixed mode per cgroup, and you don't
> need struct_ops for that.
>
> A kfunc that takes a cgid and a value would do: -1 for the system
> setting, otherwise the existing NUMA_BALANCING_* bitmask stored per
> cgroup. Task callsites read it through the task's cgroup, folio
> callsites through folio_memcg(). Same capability for the use case in
> the cover letter, a per-cgroup field and minimal plumbing, and the
> kfunc can grow later if a real decision-time policy shows up.

That's a good suggestion.

I believe that will be a good start for other per-cgroup memory
management features as well, such as per-cgroup THP.  Also, it is
much easier to backport to older kernels and rapidly deploy them.

I will draft it soon.

--=20
Regards
Yafang
