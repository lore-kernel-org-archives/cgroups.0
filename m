Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B0D37A833
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 22:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787093081; cv=none; b=tOZXxRLC/1ZOulik+76OH1fUR+ZG94/x+RQYctyE9Y6zFxp860LEgvJfvvVgcxvVKXZIyWnmTa3eiC120FN7yVhYu0lpOI2cYIbOR7JfqnKfRna9+IRWarw3dI0nuFwKfHjlmLDOvM+EKCllmKDt8T8QhsqBCYH8o2NeIyOj0U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787093081; c=relaxed/simple;
	bh=h0lKE86vamg5l2QE7rks9oOFKc3rsdKjudbu/CLCImg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h3d8cqm63gBjFMXe9KsiNy9cNmdW2qbXyBKK4q5sGt9YrH0C+uMpSzIXTeswldDpXSsrAhF1hf+ZS31mqvEb9m7cecG6NpUa/u0yMkDVXptbkdX6ItVsnfTossTN8BJmn6bn70kRtGdkbvLJiwBk2PbxN22pbDXo74fqfijTXn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NQ3rZSlm; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NQ3rZSlm"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso597725a91.2
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 15:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787093079; x=1787697879; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wKl32eYwuQc+ijyeGlAXus14S3y7YMOIliN5aaJMCDU=;
        b=NQ3rZSlmLdNhzoaRNjzqsPUxTijHDIDtNnZk1fqsWuhJj4CbjaZ5H+zLrRA9bKpz40
         deYUu8X8Mdy6Wrfauf4W33l0qkOFtR1Lnrwz+HhU4mAOe14j9yptbtC2c5GBXkrvfIXE
         05jdD/30+Jck1PUyf1Jgl329DKDuGPt2kp/KQ7fRmR0ig3XqFiJbvm0BVStJjHAmVuBa
         abveA5KZ3yH+yV1n0yhhhhMTgDTTVmHtoTLjkyuRR61a2HpEGs4xDXDzUMfZcuobOHOM
         3+P3to2ZGNfyhprZUJUjLiefH/Gyp0BylsoaNoUJpIXlY9DPukfYYd98zJnOSed21d1j
         bMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787093079; x=1787697879;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wKl32eYwuQc+ijyeGlAXus14S3y7YMOIliN5aaJMCDU=;
        b=WyQrlHyqE0ugdmdBwcNXg/rVmu+Vqh6ohJ1KxPP5QpM4nZqe8lHGjC2wRimah9BA2p
         ax39h5NtwnVSeUsMieKv9jwXKlWV4/5gIjg83kQyf8Bbtw/dVDJbu8X0rwXn1JqW/37K
         p9jUJZ8A0Ges1g1viBO0ye2+Opxl/+FCO/aGO7Ks07vldf/qAmpVO5jEzuicyOjN/3Ru
         6hAKYwV9Mk6Ghxf+FcMSv3HHlhvFEMu8siWzHULuVA1mL2fkiMj6MRyPi7HHchnkBRsQ
         wC33lAexaXVSZb7ai2SdXcw1pUIWHl2g+xhaOpmUXyMtSGb7lzaTSvmc4npe9EuypiIN
         vGMA==
X-Forwarded-Encrypted: i=1; AHgh+RpoMOo1HGK5No/HvwtC6949E+En87lofNCMdDQXQQcG6gdv+t/KfLhNr+L+qgamyTVwy1Fh/1dp@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5T9YouXwwbmgkeqz0qZp6fcoUs5IHc0f8UQmnc91TppEcuvfH
	1UGqLtfUBafR+ZXcHHzPfWXT9y4HGAWz4ocecuvC45i2nHwM768Lzksg
X-Gm-Gg: AR+sD10W+glQQaPSqbasgCeQHSsSpzsYGmFFcHSmavboneR3JHfKXYPzPeJxuMX8YlO
	FNj+sOQYmJkgqmbPcd6in402FT/g2eHYxOfusSQ99UGNsuO1kJSrVXYCZu16iwYviSLASdV60L7
	fWkPxmpGvBbeRM7dk5gpA9CHg1Qfl4ArqEtRTtftF3E3am6Y1Hcu/d+jvibEQ/IfJcPAkuzyHbq
	AoXSGVLyBsar8R26rVda5Qx3WnKYCZE5ep2S3i7RRslug5vW5HFfDRIzj63OsMT7Gk7LGbJATsl
	cptX2jf9WOvOpIf5NMTZpF7sQXjrZIVOgygE8x2D0Geq++J5eUudgLCVGS+wfnN3l/USK1/wxpG
	AX6oVjyjyDRaLEvJB5H9cHJpg1zvXiSVJeWpV5Pali7/OSPd61CkSd3oNaSnFItjjYHoXCWOs7J
	uVRv4zcBrrUS/zpmCVn5X67EjwyM02SmUZJo0TdCcKez2FO0Yw+LWdaxPkh4bNvGTKHTUHzPkZ7
	GrD0gxr
X-Received: by 2002:a17:90b:1804:b0:38f:dec8:f7e9 with SMTP id 98e67ed59e1d1-395810b5a15mr370692a91.12.1787093079418;
        Tue, 18 Aug 2026 15:44:39 -0700 (PDT)
Received: from devvm16600.scu0.facebook.com ([2a03:2880:9ff:6b::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416aea2429sm448334c88.15.2026.08.18.15.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 15:44:38 -0700 (PDT)
Date: Tue, 18 Aug 2026 15:44:36 -0700
From: Ziyang Men <ziyang.meme@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Shuah Khan <shuah@kernel.org>, kernel-team@meta.com,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, bpf@vger.kernel.org,
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] cgroup: add BPF kfuncs to read a cpu cgroup's
 stats
Message-ID: <aoTgVOTxsEbFXTp2@devvm16600.scu0.facebook.com>
References: <20260818002450.3071325-1-ziyang.meme@gmail.com>
 <20260818002450.3071325-2-ziyang.meme@gmail.com>
 <aoSTaFwsVEoNW01D@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aoSTaFwsVEoNW01D@slm.duckdns.org>

Hi Tejun,

On Tue, Aug 18, 2026 at 07:16:24AM -1000, Tejun Heo wrote:
>On Mon, Aug 17, 2026 at 05:24:49PM -0700, Ziyang Men wrote:
>> +++ b/kernel/cgroup/bpf_cpu.c
>
>Probably not the best file name. bpf_cgroup.c or maybe just put it in
>cgroup.c?
>

bpf_cgroup.c sounds good, I will rename to it.

>> +/**
>> + * bpf_css_to_task_group - Cast a CPU controller css to its task group
>> + * @css: CPU controller css
>> + *
>> + * Must be called under RCU.
>> + * A C cast does not give the verifier a task_group pointer. This kfunc
>> + * preserves the task_group and per-CPU types needed to read cfs_rq.
>
>The fact that this is used for per-CPU types now probably won't age well if
>this grows more usages in the future.
>

Yes the major usage of this function is to enable the bpf side to compute the
throttled_time meanwhile not touch the codes in scheduler.

>> + *
>> + * Return: The task group, or NULL if @css belongs to another controller.
>> + */
>> +__bpf_kfunc struct task_group *
>> +bpf_css_to_task_group(struct cgroup_subsys_state *css)
>> +{
>> +	if (css->ss != &cpu_cgrp_subsys)
>
>unlikely()?
>

Ok. Added.

>> +		return NULL;
>> +
>> +	/* task_group embeds css at offset zero. */
>> +	return (struct task_group *)css;
>
>container_of()?
>

Ok. Added.

>> +/**
>> + * bpf_css_flush_rstat - Flush a cgroup subsystem's rstat data
>> + * @css: cgroup subsystem state to flush
>> + */
>> +__bpf_kfunc void bpf_css_flush_rstat(struct cgroup_subsys_state *css)
>> +{
>> +	css_rstat_flush(css);
>> +}
>
>Why is this necessary? Isn't css_rstat_flush() already exposed as a kfunc?
>

Ok. Will remove it.

>> +/**
>> + * bpf_cgroup_base_stat - Read a cgroup's base statistics
>> + * @cgrp: cgroup to read from
>> + * @out: zero-initialized output in nanoseconds
>> + *
>> + * CPU time is adjusted as for cpu.stat.
>> + */
>> +__bpf_kfunc void bpf_cgroup_base_stat(struct cgroup *cgrp,
>> +				      struct cgroup_base_stat *out)
>> +{
>> +	if (cgroup_parent(cgrp)) {
>> +		__css_rstat_lock(&cgrp->self, -1);
>> +		*out = cgrp->bstat;
>> +		cputime_adjust(&cgrp->bstat.cputime, &cgrp->prev_cputime,
>> +			       &out->cputime.utime, &out->cputime.stime);
>> +		__css_rstat_unlock(&cgrp->self, -1);
>> +	} else {
>> +		root_cgroup_cputime(out);
>> +	}
>> +}
>> +
>> +__bpf_kfunc_end_defs();
>> +
>> +BTF_KFUNCS_START(bpf_rstat_common_kfunc_ids)
>> +BTF_ID_FLAGS(func, bpf_css_flush_rstat, KF_SLEEPABLE)
>> +BTF_ID_FLAGS(func, bpf_cgroup_base_stat, KF_SLEEPABLE)
>
>Why are these SLEEPABLE?
>

The css_rstat_flush() calls might_sleep() and cond_resched().
The bpf_cgroup_base_stat() takes an rstat spinlock_t, which can sleep on
PREEMPT_RT.
So both marked as SLEEPABLE.

>Thanks.
>
>-- 
>tejun

Please let me know your concerns. Thanks!

Best,
Ziyang
