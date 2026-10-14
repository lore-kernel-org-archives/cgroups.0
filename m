Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1D239A803
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 03:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791947360; cv=pass; b=e8O8X66bbCd0Tg+QmuQ/nMp1OPw1jOqWlVdbrwsFjG8K4VrE3w5T8uhnvY/hZ6osxnt392Gp01uSfj9MqWfRUgKH9yTQMP1venR2R/sWYy1qLOcWv5B4jwUnTJFC2lLuOrcdPtBGDazjg2nGCapFS2c4CWsxVXYaJ4QlMYZVqtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791947360; c=relaxed/simple;
	bh=UNzD/AxLjGFxfGGazPPzQZUu4rGnvyDIVYkhQgQITf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oh+onR2zA1Dc4WZrRI8wG4e5xmV0vsTnf0+ot/DjXOZ/Zp9LjvbrIxA03LhsM9mV4N1NfCjLEfqm7xmyu1/fqV6QL1C+1uOG44kbg7wViTy7RnxFPzXWeDo5SS2mfErlAVHcLDWMWXLmDq/0FT1XDSUNzP2pUNZdCo9/d1vu/WU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qEZI13k7; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qEZI13k7"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-676858d42f8so2954716d50.2
        for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 20:09:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791947357; cv=none;
        d=google.com; s=arc-20260327;
        b=GDEMS6vRKsKyZ1QcsAHmf0HmLRTV/DZEDZH5xN72wKlXVmZnkipVb0PkGuAXOlUGZT
         3zX0F4o1Sm3Gdt//PuPCM+33JB6YU6tcJxcsajyU/hAp1+jlZcVaBP1TDWPOiycmzjfE
         7VpKqoXgdLWRf3hVlfzLTbkAiDlRWYVQ0FTXZdliVKsEtw7tU7/xd833X04KSHUjyizB
         XvmQYV5Xjgsj5CYOgrItbA/Nx6A+wBgJcY68KsGgpdjOQYNsqjVV8b3ehXx5y0Vqj0Fp
         wd42V57+KDcowx0OzbDpz7YadEiWvhm7YSx5Xv6vNtA1Q9hn9pMghErk69qa4HWd93ag
         1FTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DZxFoqnlOiUWhIXdGMf7+RiabdBM+98/BuYUZOMYxiQ=;
        fh=uP5JaPh+5NqlgFLQtrYBTW9ieWC490Ry3H04YSpPg7w=;
        b=eZQ72lAGnvo6ho1bZygeIGCbd/reO6RGhZkOVvDyE8Q7Iq/xHfy3VhmOWE7HnYf9Pj
         5+PIq5iA3JuW3JghmdXH1tXJV/rWZm5HiNuvCQZYZ85BFxwcJTdbXFj5BKkyyEkqXTa9
         9d0FWPSHQLH3pmDOqAgZFfVheFbl9o+TMHFI7rTN2D2DK7CNR+ROo9eDqKXUVH0IvZoK
         7gafr5H3g6ELON0EjBSCoFUOuhZpEHC2f98bCfPYX9vBf1gyPaVzTVa4leYxzOvE136l
         qSfZC62puiRLOQabsBYOm2a0iA5eSnCOKEpjsDIZAaG3qZlR3oxZmm9RhuaO2a3OFsxS
         /FnQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791947357; x=1792552157; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DZxFoqnlOiUWhIXdGMf7+RiabdBM+98/BuYUZOMYxiQ=;
        b=qEZI13k7NC9P70Fjm9WImmKHlfni6bFYESVq2eg0z0iPN0Y8YcqU3ahaxWrB2Ye6Kb
         d9a4m1Nt7frmFghIYkLLtVP9rkmvEiYnReZl7tJ68i6bmwlohcbGoJkCLqimvmiQQgcv
         khTUR5qEdvYzmckMVc/wg5HmF4y5jTYN/h/ZT3slr8DAxWxY8uC+e8ajQiFsZo5AJlaH
         5gvGdnG0vOo9A0ExiLUUuZ4sRJMDr34phw16Wo2yonDRZ+G+DgdOFEuAVcMlmDBnXDZM
         BgUdEpCqQucPtFNO83HhoyJpm30qjPnIhQ9ZYAyhESEg1sZW8nw02QdToOpIB8fEghnP
         5uZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791947357; x=1792552157;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DZxFoqnlOiUWhIXdGMf7+RiabdBM+98/BuYUZOMYxiQ=;
        b=RbqWIpJHidnX46BgrGcRBx+9KYIr6SfF8ar3f1s8oM6fCtYIVt+M0dQgElmcfEKggK
         PJgMWvcnftWKfhezzxR8PYUuznw5q8qsJm0vRgYjBNiT3Ka7hIvLkrfbqN31s4DxGJh5
         gzVfd6QE7+EVmtYfra0ed7ZdCOBbs8T/kgh7uAe1N6a2A11DAPOngSzmRm+06p9fvigd
         uLyBoDQZrfgBJD3sKwcFszeK/sKMCYae3rkApkBQuQD9AS51pMRthQXvrQR7vkXRdxpk
         LgqqJVSpwvUBOhqykBnLAVDPQ2j17PhKGnLczcZxAWbJztschD5Ie/s0C6uS7VcAIRVc
         N6WQ==
X-Forwarded-Encrypted: i=1; AKwUvByS635m31tfXz1+ZngEpNivabyfFlMJLPqyyKfotVPGhpRMS3+yDyW6hSruBAko9r6UvPIfq9bU@vger.kernel.org
X-Gm-Message-State: AFq9FYJ08ahctHTWEcvs193RH/ntg/ClCcaWXakQiTiftEbbopOniXX8
	K+7JXufd34ASmHWiWKVakMBv3bdSXcH9IvFF7mLs3KXd4RzPFdQQsDD+JqXxqNyGD3alT1m1HWp
	FdSHPgBJJRwD7go5Skh1eJ3SDS0i9FHg=
X-Gm-Gg: AYBFou2egsnEdM84cobHXDrspPlBGJikYpDfZJwF5b732hsAkbZ7pqcYd5ExqIPg1g5
	wNnldzklMcqsPbTNptplmFyeKQT1hGpxnOWPgDl4wd+6qAwWwF7spVitNezowwiEh3uR53i1QUa
	kxhqlmcgDisbLzNYXLgD21nVxTJxbbC+s3xqbUSB4YNodtV8azOGMu8JGfTRy0f5foZW2ktIH9p
	QyRE3emYLn2CXztJAZvPTttkCe3OM1TFxekskY/dFEkyY0F9jakHuMpJZmTbwG8Q5XZfTs7cprq
	dmlIOXL4eytc0iLw0cBVqQWvVQXFJvp55ufeXKvGCEqD5EnXv3J6+hy1AnPk8D8a0cvq0s/Z6rC
	P5cM/fQdVJQ==
X-Received: by 2002:a05:690e:1913:b0:676:e85e:5ec with SMTP id
 956f58d0204a3-67975b9e0fbmr1610555d50.139.1791947356910; Tue, 13 Oct 2026
 20:09:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012120438.52849-1-laoar.shao@gmail.com> <as5RFhW1Ch8ta5nZ@gourry-fedora-PF4VCD3F>
In-Reply-To: <as5RFhW1Ch8ta5nZ@gourry-fedora-PF4VCD3F>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 14 Oct 2026 11:08:40 +0800
X-Gm-Features: AclHuK-Cs4-tIw-JWscmzRL89aJpa2RhvKqogcNm_f37Lr6_J9191jM_ZK2WR2Y
Message-ID: <CALOAHbCOTSOPTzoSqKoBJZ56o0pfW_dGQ7ZM_e1jT9N16z3VPQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/3] BPF-based per-cgroup NUMA balancing mode selection
To: Gregory Price <gourry@gourry.net>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 11:49=E2=80=AFPM Gregory Price <gourry@gourry.net> =
wrote:
>
> On Mon, Oct 12, 2026 at 08:04:35PM +0800, Yafang Shao wrote:
> > The Problem
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > In our large fleet of Kubernetes-managed servers, NUMA balancing has
> > been historically disabled globally on each server. With the increasing
> > deployment of multi-socket AMD EPYC servers, cross-NUMA access has
> > become a critical performance issue, which made us reconsider.
> >
> > Enabling NUMA balancing globally is still not acceptable: it increases
> > the overall system overhead and can introduce latency spikes for
> > latency-sensitive workloads. What we need is to choose per workload
> > whether NUMA balancing runs at all, and which mode it runs in. A
> > latency-sensitive service may want the scheduler's NUMA statistics
> > without tiering's promotion machinery, while a batch service wants its
> > PMEM-resident memory promoted when hot without paying for
> > scheduler-driven migration. No single global switch serves both.
>
> Have you tested with recent fixes?  NUMA balancing has been broken for a
> few years now (starvation issues causing VMAs to never be scanned,
> east-west filters causing south->north promotions to be skipped, shmem
> being entirely exempt, others).
>
> https://lore.kernel.org/linux-mm/20260629163337.1264881-1-hannes@cmpxchg.=
org/
> https://lore.kernel.org/linux-mm/20260930112206.205083-1-gourry@gourry.ne=
t/

Thanks for sharing these.

These look different from the latency spikes we've seen on our
production servers =E2=80=94 ours occurred with NUMA balancing in normal mo=
de
=E2=80=94 though I haven't yet figured out whether ours is shmem-related.
Given its problematic history, it's hard for us to re-enable it in
production globally. That said, I'll try to backport the fixes above
to our internal kernel.

>
> I also concur with Tejun that ops seems like overkill for this feature,
> this seems like something that can already be managed.

Tejun also suggested starting with a smaller kfunc rather than the
heavyweight struct_ops, in a separate mailing list thread. I agree
that this would be a good starting point.

>
> For example, why not add a new numa balancing mode bit that says
> "enabled but only for explicitly opted in tasks" and then ignore the
> global default mempolicy, e.g.:
>
>   if (numab_mode & NUMA_BALANCING_OPT_IN &&
>       mpol !=3D default &&
>       mpol.flags & MPOL_F_NUMA_BALANCING)
>       /* do balancing */

Another option would be to add a cgroup::numab_mode field (without
exposing a cgroupfs interface file for now) to implement per-cgroup
numab mode. I will think it over, considering both your suggestion and
Tejun's.


--
Regards
Yafang
