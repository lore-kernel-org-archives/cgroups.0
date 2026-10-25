Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792899398;
	b=TEWdu7TNBKj4+vQiyypjY6vqiAK5M/G1/iDc1vrT4HNSzcYpAD7Vp/JdbkUoryeGCNGF
	 oNL9pNSR9HLjYy4l+AVCF8Nn+38h8HisLG1jm/dR8RGuhPKUkhj1W34eRpPqldNwPCav4
	 orh5EJCsNOzmEjwIzgXbbJ4u27abQSQnwSYdYpyaqE4ci1hK3zroI+tschbtrLy3auaOI
	 mwx36riqKeX388UIM9GzUletdd5H61akqA0UuMvyRFEhywWl+M9ujO1oHnmOcZmml2T15
	 lUDo/t4nagGCVPYMt2hnZGfa4lg3crs+KRmFUgihxE9ltMPgHFw8tzYC9twbjvs99zw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792899398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=DjKh57N4UF4L0vPTEmwKkugiAf2AMgqPZ3+VipYde0U=;
	b=MfOfds1Ai1V5qDXRkeURHq58POk/6LmGiqnxYr9MpKAegWGy/vzmhutX/tWOgI9Qx/cw
	 ZDbEBC/azM8s0cjqcfYw5bZuz2qJ2IJ6dS6MwDMPolqLHZnoEM1tpQ4Cnzia9aBp5/8zC
	 PpIzLk+0GiQFxVfkrk2SWigGDA2w/8uAMJn+X7/Gvd8Xo6N9Dbr1lVKXQfocBHnthqCn7
	 11o4sw3rzBVyhwDKI9/6MO0237RXQnnRro9tX1qR8c4pM2tRetnxOo8aVKvMqQnmGBBO1
	 8SMskw/D9I+fLeUDRwADs6ipLhHgdNR0tMNK65MLDf60HJBo4cVswUC09dYpRg19Z5A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.42
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B03606A31D
	for <cgroups@vger.kernel.org>; Sun, 25 Oct 2026 03:36:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4B03606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-677bc4704cbso1859803d50.0
        for <cgroups@vger.kernel.org>; Sat, 24 Oct 2026 20:36:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792899392; cv=none;
        d=google.com; s=arc-20260327;
        b=h5OUsnWm1fp8y3/jFz2exoTx9D2YQKtCgwkPgGqM/nvgvNPUGW2sdATbgIn9xRIqXi
         QVz0m9kXnKVinY4UghFxVMHaRPwW4BXKedpSY9W597xEPcruEHMHztHl6V2AYch3R6+/
         nJ4iDPwS41/sNhYJgAas3AIk2eGK8dphbUuW2jcT8ysVjVoWQ1CHjqsW3iHzuiE0dJIF
         viNsZiHYdz+IiuPAL5J3WMBeV2u0VTpaPrhs++5ghPololAWbVjil7SCPmOfrXLcPeJD
         E91Jayh3b8/gq/mqShMIf8yZmf5Kk5tuvqbhcpYuTuXNeoH2yuzJ5vmqr5P6CxywLjZf
         jegQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DjKh57N4UF4L0vPTEmwKkugiAf2AMgqPZ3+VipYde0U=;
        fh=HbJIBnhqKaxO1fGCJIRVnudT53kBUwdrZMzXJQRJTSo=;
        b=GBQHCSr96VqkF64lwRBIRsLpmzJ5MtF11rbCXTnzWrKJlxN2/nkqStTiEAX7kdRFo/
         nheYQIm9xMES9HKhc9LvToll9bWx6Jg5Gsvods/E5ZvutsCNiKLVQu2MvZHt709atSx2
         6/zeVAV+MYOm+pyFLn0Hgq9mWIZ2KFMbJs17VULnKmomFPSNJrFU8Qadf19tpJ8O8HX+
         R5LXNpSYdwDwt2/TZXI/zMM24VEMYEU10f1mJQNsHfXffJtS55PwOg50f4u+cInivBsJ
         uFblMIH9WENKR/tMge8IYiQquOJaDUGTiP3M2lD/2jt3tcXZYw1Q9IttY4dPbCxR++Hd
         iOrg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792899392; x=1793504192; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DjKh57N4UF4L0vPTEmwKkugiAf2AMgqPZ3+VipYde0U=;
        b=LeZq6DBIc6AySagJ4h20GcT7Y5Ym0FgUVily4RFMHswaMVmTf3cY2VMsfzdZWu5zXX
         BMZ54TNQQDoRY1tcf1OiP+fqN3rVaR6wmL4DHf0MG8QKopQ9m7zCJeQ60e4w3mfIQI55
         0PtatJeBVWpbrPngvRuEXN8B1lUohAK6psht7aAVAtvTr6/IbAhko0bK7Y3Uz/dJV4oA
         iVx5HcZylhHvvqaEdAZkz2EJyvd08hcZbpvXzoZg+L5Bh7DXf/pCz7pCkYPdfnK1I78T
         2XBdvo6GSyaPrk3LL+iGGNpUEBtFYQhyZ0omidOMAQqD9p1i1Cs0SSrzPxFnIe9EY33S
         5SNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792899392; x=1793504192;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DjKh57N4UF4L0vPTEmwKkugiAf2AMgqPZ3+VipYde0U=;
        b=mb06kH16ipzv8zJAj7lejar7HejwmMJijExc3QWqyMRvtfJp+dGQa8Se6/upA3TaSS
         B19os9/+fI8Ol6hO5kVkQSMyaxNF6oYaVDVcO485os+ZhemxhneowZB6Ap9Z1WB6VnC4
         3Q9vfz5rs8gpR0iRb15Lju/4mJUWli7cxV/iFTMZ1RNvHVVFlX9qv2Wq3DolCL9hSO3K
         IfQ5hNDugM18NVdpHRtoGkL1xCAdti6cdq/o2Xc4cKEcCHO/DQZeJKjon/vnxHjtihYZ
         z6ziO6TCxaMKiZBWeRydR7uAZ+9DWCFg5bVVdkfG5PyRUOEzlKAwe8DmkOjSYwZ57sAF
         E5pQ==
X-Forwarded-Encrypted: i=1; AKwUvBy81vQcg88vdqk6yS6zq1cnJhf/qLrd94srgtKgmSgEN7xcTCDiK/kqGqiweAKZT6p81iyims4U@vger.kernel.org
X-Gm-Message-State: AFq9FYIwowJUmkqCMNtsgkiY/IQ/A5lWaiKfKeZSDVsEjAd7Gm0qeXAT
	nxR5VexEzATHDksYGXWC9PdmsBmDwjKXMEK50+AAaqHPxbCEJ5BZUTXhuzjJVMynMp+WAS+i0/u
	KTiHDmATwIOk0o5tBtSqn8Y3ZzdlfMzY=
X-Gm-Gg: AYBFou1LG5E59mZlRWM7rDy9P6MTNrYX7ECPCjkDVywWrHGFpN2ZjsL5mVU5+1c9czw
	yDt6uRzlaXbKxCd687tpfRZhQ0xw4mbYOVBH9eMYsV/FClM0qHyVQ6YP8qfqQUtDdSRqNZIWBDB
	1UwxLmyLrG6RNC7ZABl28KMMSRmFkXf7fzkI8m89my4++rya8vAmF6Yfxee6Qnh1OH8hiVg0sa2
	O1+ZrJyCDOLRaHSHBPb1VQV2cPPn/7B8t2Kpm9FnAuLv71pn5tscINk/kVYVJ3UcQd2Mp3Jip6T
	6uWShWvSWRS7nLkul909+M2rICQjRcG8EClgrmBxAoR3+/c20xQa5DvtAuEWb2+bD25FXFE9f9V
	nHHLrMu5LvmlydBpsbsdOCEvlgkmCtQ2KasHzrOdfli63bnoWK6JcDIE3JTrSaODipXc=
X-Received: by 2002:a05:690e:1a27:b0:679:95cd:1aed with SMTP id
 956f58d0204a3-67a454bdfc5mr1270836d50.60.1792899391596; Sat, 24 Oct 2026
 20:36:31 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019064157.29885-1-laoar.shao@gmail.com> <f68e7f9e-6037-4087-b7cd-a17ea4dba279@bytedance.com>
In-Reply-To: <f68e7f9e-6037-4087-b7cd-a17ea4dba279@bytedance.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 25 Oct 2026 11:35:55 +0800
X-Gm-Features: AclHuK-Ie5-cJruVMuWsByPpF2E5memGw2rPj5uhPsydhaudr0vHLSJ1wQm8wZE
Message-ID: <CALOAHbBP3n1uyC6qE-678ZNvh+12HSQ-H24xg4RqGtaZXKbL1A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 bpf-next 0/5] BPF-based per-cgroup NUMA balancing
 mode selection
To: Li Zhe <lizhe.67@bytedance.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, gourry@gourry.net, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, 
	yu.c.chen@intel.com, zhao1.liu@intel.com, tim.c.chen@linux.intel.com, 
	bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 2:32=E2=80=AFPM Li Zhe <lizhe.67@bytedance.com> wro=
te:
>
> On 10/19/26 2:41 PM, Yafang Shao wrote:
> > The Problem
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > In our large fleet of Kubernetes-managed servers, NUMA balancing has
> > been historically disabled globally on each server. With the increasing
> > deployment of multi-socket AMD EPYC servers, cross-NUMA access has
> > become a critical performance issue, which made us reconsider enabling =
NUMA
> > balancing to address it.
> >
> > Enabling NUMA balancing globally is still not acceptable since it can
> > introduce latency spikes for latency-sensitive workloads. What we need =
is
> > to choose per workload whether NUMA balancing runs at all, and which mo=
de
> > it runs in. A latency-sensitive service wants NUMA balancing disabled,
> > while a batch service wants its PMEM-resident memory promoted when hot
> > without paying for scheduler-driven migration. No single global setting
> > serves both.
> >
> > The Design
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > This series introduces the fine-grained per-cgroup NUMA balancing
> > control. It grows out of Tejun's suggestion to store the existing
> > NUMA_BALANCING_* bitmask per cgroup and expose it through BPF kfuncs.
> > cgroup::numab_mode holds the request: NUMAB_FOLLOW_SYSTEM (-1) defers
> > to the global sysctl state, anything else is a bitmask.
> > bpf_numab_set_mode() writes a request, bpf_numab_get_mode() reads the
> > combined request of the cgroup and of every ancestor back. The hot
> > paths walk the same chain at read time behind a static key, so while no
> > cgroup makes a request the overhead is one patched-out branch.
> >
> > An opt-out wins and binds the subtree: a DISABLED request anywhere in
> > the chain opts the cgroup's tasks out entirely. Otherwise the requested
> > bits OR together and the kernel reads them independently, the way
> > kernel.numa_balancing reads them, so a combined NORMAL|TIERING engages
> > both modes. A DISABLED request only speaks for the cgroup's tasks,
> > never for its memory, which follows the remaining requests of its
> > ancestors.
> >
> > The cost of the additive combination is that an ancestor cannot cap
> > tiering short of a full opt-out: a descendant's TIERING request
> > re-engages promotion for its own memory, and promotion is the mode that
> > consumes the shared fast tier.
>
>
> I am not sure that this matches the usual cgroup hierarchy semantics.

I think the usual cgroup hierarchy semantics being invoked here is
the semantics of resource limits: an ancestor's limit binds every
descendant.  That is the right semantics for limits: a limit
partitions a shared, finite resource, and what a descendant
consumes comes out of its ancestors' pool, so an ancestor's limit
must bind every level below it.

A policy request is a different kind of knob: it is a preference
about how the kernel should treat the workload, not a quantity
drawn from a parent's pool.  Nothing is consumed by expressing it,
so the limit semantics does not carry over; the question is only
how the preferences of several levels should combine.

We chose the additive answer: a descendant may ask for more on top
of what its ancestors asked for, while an opt-out at any level
still wins - DISABLED anywhere in the tree caps the whole
subtree.

This also matches our operational experience with policy-type
knobs in our Kubernetes fleet: letting a child refine the result
has worked better than having the parent's choice bind the child.

So with
                      Pod     (NORMAL)
                  /              \
  cgroup-A (none)  cgroup-B (TIERING)

the effective modes are

                           Pod     (NORMAL)
                  /                      \
  cgroup-A (NORMAL)  cgroup-B (TIERING|NORMAL)

> If promotion consumes the shared fast tier, why is a descendant allowed
> to re-enable TIERING when an ancestor cannot cap it short of a full
> opt-out?

Promotion can't make a cgroup consume more memory than it may
already consume: it moves the cgroup's own folios, within its own
memory limit, from the slow tier into the fast tier.  The cost to
the rest of the system is placement contention on the fast tier,
which each contributor's own limit bounds.

What an ancestor can't do now is cap only tiering while leaving
normal balancing available below.  If that targeted cap is wanted,
the natural extension is a negative request: NO_TIERING would
propagate down the tree like the positive requests and mask
TIERING out of the effective mode.  With

                  Pod (NORMAL | NO_TIERING)
                     /            \
            cgroup-A (none)   cgroup-B (TIERING)

the effective modes would be

                      Pod (NORMAL)
                     /            \
            cgroup-A (NORMAL)  cgroup-B (NORMAL)

For the RFC I would keep the modes minimal and add NO_TIERING
as a follow-up once there is a real user for it.  If you think the
targeted cap should be there from the start, it is a small
addition.  What do you think?

--
Regards
Yafang
