Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195FE3E867A
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 02:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791857831; cv=pass; b=tjin8Jl/lsPHqhHMu2Zoe3vrZncYal0IQPYO5fSae9c06NqM40WWdFupnB7EYALlVmFmRup9BHPwEWORL2tdBUMjifIEqD1KqlxlyMeGE/oscf4ml6TehF7V+hRrvWkwKc0DJvuVWiSLmnlaBuTQDg8hJ6/HPRhX6jOgcFaplWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791857831; c=relaxed/simple;
	bh=1e6icdFjU8+9G13mCMkJbMOIoeURTDtn24Q/J9qsd24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CGN7B+45AXOnuPDb8juVdr2Tc1Dp7A3ZimswvObxbvFiJ/cVH5AdP3zzPPXFkXt7TCt7GPsrDmHqD1tm0cXdJ6e1SkSU1dAjoC1UXSEE9mSxqi4J1ay495G3HHnuso7V/wh8GsGWqYbJtDrEPQHcZ56TQB8kiMF+sD51QpZJgR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cBl0jKAC; arc=pass smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBl0jKAC"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-675617e81f9so2455613d50.3
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 19:17:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791857829; cv=none;
        d=google.com; s=arc-20260327;
        b=IbiflxuOeS/JhHK7E9pRPq36rGniiJ1B+auzXE724WqvVWEBUuOLgTm1ivvA8ccDIH
         8ZCuVZwTqtlEPYgrAOQRv6FEG4QIoAUyGDeVduc5xKmrK34qwVgQqeAesL6CJLH65O71
         yXlwlyL7jpXF3fpuVDQ0mxMm5LgUFvTyB9lDYwqubssK4CzCMfKpI44H5357YhoE7cmI
         sPeKBmMd3yTcSnVCgH8/XePzlU8je9fCCN3zHrTTr/TFRCSI10rX9N0YiSREmXYZ2Np5
         ygh8xnMmo+YiaPIsEOkw1MLDmZtI70RfCQpR0AQGxanu4sFeprXGOZFRmiKuOUn+qxyI
         b+sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yIn2x59SlJfeG2aH0jkfT5zU4fOVP6oTpHe5FuJew3U=;
        fh=8jHTw/FbqMa1Fh2UOBQ9jXx8ba8s7FTXntQLGDIP3TA=;
        b=Tz3rJs8hOqNJhOW0+xx/PGGUfbOVvD4hFdDaCBcO24zjVl7sjE3zhmX7Hh+Z5xZhi+
         yrmmqZy82D7m6fRoBUNeID0w2j8xn0uZjTJo/OZUfJLFly/5x1bvFAWboykZuuWfIYAj
         ACCvg+BBBXePwIKU/L9adAe6GcC2GxCTIDv9U6S/PgB3+e3UBc27mZHTcS/e4VTp0GNV
         gWlhhO8rj1zQj29ixSvF+s9d1VarNULEM2aCWi/fW1ltUCVpL/zDjt1a8SJFpOBanbnH
         cotg+rMELd/T1IKwS3mFVH7A37fK/qMVBMxB9txDp25zP3VyBpkWCRH+GGXloBLP+XAe
         Bf4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791857829; x=1792462629; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yIn2x59SlJfeG2aH0jkfT5zU4fOVP6oTpHe5FuJew3U=;
        b=cBl0jKACTBpEhNhNf1f+qVqVSynQf2sZqtgWXf/qEjOzsMjBj512ETrV538exeXIBl
         qCm9/UpB9Stfx9Jvg37Cop4DDoi5zHoHhfECy1lsvQ2EThZ1H2/JtdI8gFpu57g1aKvB
         U9OS8ayivO+MKQuhfdTuXe9rdJ5F4o8P7PMhuVsO/Gq+KAWzaa1kiu4zlqPekPnn7ee0
         2K+EfHmXySJNZEz8OSDNSPvj8Xasm2kybS/Fnz0M50FWWrpSqwir37vlM//eB7vdn+lp
         mxD66mIjqkzq+YtNjhYF7t4N9fkfKWCFtUkgJYjJw/iv0dvxJ2sGrdBE1bwZlnadn8n9
         BCww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791857829; x=1792462629;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yIn2x59SlJfeG2aH0jkfT5zU4fOVP6oTpHe5FuJew3U=;
        b=s/aioMjJYGT0/wejs4YA5HtZW+8C6R1ysLyl6KzO0P5VC82WBw0shqiPZpb32GhIaZ
         7cPFuIA5OphjtSho1d0iCuK+eZ7KPcvoYtWpjk+OQDePEdBayGQvL1CEHdoo6tnX23nZ
         D9LGs+Rtp7/paBJlQ6jfqtxTbyyiv3V3Y+R5hcHpv4X9D6AhWssd84gGBdkwNMX+o+1X
         geACmjgSYf1KtmgVyGxko34NBtcnJumcJvOEQWrGZhsSBQ/M4dDwze2kGnIaDyLoY8pO
         rfPMSmB8ayNdyocOynvxhl2vrfNr1HhWgxVTQ8hm/BudBY3Bl93KqaJMUk4aSjEgXmuc
         ZX6g==
X-Forwarded-Encrypted: i=1; AKwUvBz9u++77mHrMtZ0UVJcAUOmrnf4HDJdncoL4MubIwQxYjxvzvusw6h/pKoGUEjWrKUY9px5ASDx@vger.kernel.org
X-Gm-Message-State: AFq9FYLfkVcoysroxjFFUcvXVcigL/fHOAaTsVfdQV6uhNFSkuv8/O+k
	PFi29dfYBiLICW3FQhFPOts3AT1d26kOtqfoAtQynMzBVythrkxMUGOfw1yuYWFwklj9iB0G8rg
	HTHFgzxgLnk1QO80Z/8DnkcpQhUZlpMI=
X-Gm-Gg: AYBFou1KD4whkHg1oybstZEWjsPM7Q86DNhxzd8lmvkmhLr42uq4Y6IH3z1ofgH9RqD
	tM0WSVMerhNITu5URSCvmI7kbNi1yeynI0D1WI7rnd92xOAvRi65Gi7D0doY4OyQdMmPa0CzpGQ
	l03GGtyo6QugxQrYfaf1XVK2KIkQ9iJrA0C9U9/NaCXSdk+GbWA5uhnDCBUOjaZ31pB48VIciM2
	Y+yUsUSydQRIuWanRvnKwSsRjyrpnllVxS2q4o9snmGc/JyOAVGf7ByNqguhueN//1CTkPtm6Wv
	ZLiBN4CxTNjv+900P8sbKk3MlLd0Ouy8KVmmBD8QW9jLLVaHzRBU0uleubXYf1A32j3wVojB1Q0
	Jb3NhULCT8A==
X-Received: by 2002:a05:690e:1383:b0:671:7e90:70f4 with SMTP id
 956f58d0204a3-6793678d44dmr3771206d50.10.1791857828879; Mon, 12 Oct 2026
 19:17:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012120438.52849-1-laoar.shao@gmail.com> <d9a3367a1852158f60cc2e89677fb12f@kernel.org>
In-Reply-To: <d9a3367a1852158f60cc2e89677fb12f@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 13 Oct 2026 10:16:32 +0800
X-Gm-Features: AclHuK-uH2UB1rAnuK0zhwCfF8NmZTYihTg9_NG0CYh1qo0sK-2XTafwZpGcmUQ
Message-ID: <CALOAHbBE_1ssK_26c-UY7N6WxhkVNpB6v9WACVGaOiWZ5zchCA@mail.gmail.com>
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

On Tue, Oct 13, 2026 at 1:51=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Mon, Oct 12, 2026 at 08:04:35PM +0800, Yafang Shao wrote:
> > This series adds a bpf_numab_ops struct_ops which attaches to a
> > cgroup. The kernel consults the policies of the matching cgroup and of
> > every ancestor and combines what they return.
>
> The op doesn't compute anything. It returns a fixed mode per cgroup and
> that's all the series uses it for. BPF is unnecessary here. This is a
> prctl() feature, not a struct_ops one.

Part of the consults are keyed on struct folio rather than struct
task_struct: the folio surface answers from the folio's memcg, the
owner's request, not the touching task's. I don't see how to key
these callsites to a per-task setting.  Please correct me if I'm
wrong.

prctl() is also a stable uAPI rather than a kernel-internal
interface: a new option is frozen the day it merges, which is a
poor fit for a feature whose semantics are still moving.  The
struct_ops/kfunc surface is explicitly exempt from the uAPI
stability rules, which is what lets us experiment with the kernel
feature rapidly.

--=20
Regards
Yafang
