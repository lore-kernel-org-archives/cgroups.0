Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7FB318EC9
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 23:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787097563; cv=none; b=LVuu6xC3ELdicNTzdp9jufJ99th9O4bmVZoVxQEQqMH+GaoKOew8NZCrwBVdcykHaa5ClakJSbtX025KDRhVkaqM9HJceWYlYOADSwQMSCrvmTlPoRsuiuuIWyoyqhG5TTm2/7bMKOJszZLeUakFXPtFQ8TYKccxDglL0jAxHI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787097563; c=relaxed/simple;
	bh=3/FC3+rTB7zenyYUb/SAoT6ao55r7Msw4PLNzKlY1/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJu24S5aGjjTnzmAwKOotPdHRaopVdEN6EYQYn0+Pxy3RxXOHyNzjMBNR/JqnMz6nJC68lujHKmv/+zMaRxYgaT/MM6fCuVo09lIqHtK9APUOAWs3szBLxAYHRxJtEcZhnfD2OBXaxWHSg9rbjEUo1RnKQzB4+zwKPfsgZuL3bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AvGalExL; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AvGalExL"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso4473835ad.2
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 16:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787097561; x=1787702361; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9UA11QdsDBQZZwlQ8Rx/R/X7VYyb6gM0uXTt1nPuef8=;
        b=AvGalExL57zB9dAd6e/zsohPJQ4EjxjlxdyXQ35qSFnq6v+xVESozfqfHbSWZc+UQc
         rILD5x1YHKhM+izDD8POVAwJ40uIjHA2uDwYoBYagrxtS6UIdY6bjBeE1Nht4vOIAxWt
         3ILnmro/pldKVNBIggkZtXV+Xxar1l17naq99FSE+dJc9gmg+YnyB37c5NEKO/VMWKb5
         qmauLF2iC4LlJPCNWpXAPgEf0poz8gROp3vXR2IBir//40deagwXupiw2EZbKkRCx/9j
         T1XmMABCtiZGzL7Dau7QC5h/Yuqgjbu41rCMSpm68ohfwcDzhDevediqrO5T4/LKplUa
         zTAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787097561; x=1787702361;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9UA11QdsDBQZZwlQ8Rx/R/X7VYyb6gM0uXTt1nPuef8=;
        b=JdLmU7iNjD3t7DSd+jO/Xid0W88ehOofAVVQptgTMmTzbxBtLHavptaqtbSiqfrvSG
         DLL5QH4IP/yxdMWaHcY6CxFoXu0fagEx9W40G8W0MotOGpb32Vw+vgU5KvYm/9Fun1DL
         0KhrObrkwj681hXlxhXL4woVupsiqGHXu/JHCDaNHAhCNutfcFPexbA3K6M0X3ispoHH
         Oc+XcqBSzuFyA6LuDq+8siQHIj1lxTIh7Hu7VsTzunt2gkmM8Auda3LD5z49rQQWe90X
         G9jgicDOHIKl8pRJ2EcbHS7vfHWOS8D4j+HXj6Q34OdW7OFbK6LNXGQrFp5ahVJcfYJD
         6MjA==
X-Forwarded-Encrypted: i=1; AHgh+RqaSdm9ceBN22ylPqtl9svHLScNewzz82zE97rfogrmf7IP35pjH1mR1F5CYqksfZCxxJOjH3ir@vger.kernel.org
X-Gm-Message-State: AOJu0YzJhrygIE2Sz5O1YR36EM1FGGe7L91eBdM4V09TtentiTlb4hqP
	zLK9TuuTIFAIWihVNF0QWCFV8ydQrFBT5fNsUVz9R9cP7uDbs1eUpnl6
X-Gm-Gg: AR+sD10icUJD8OWoOzkf8SxlISo26DZr8iGrSGEPEl94qTTL/i6Na9EswFO/8DT9EOZ
	q+XDcSMub7f0tMTEIrIcpP4CQ5FOKM+ecYSA+INxsKeNeXrmo6frauEN9lkbPEmiUBRjnLhaa7K
	l7p++62LWQ8bkIyZ4Cu/nkU4/s8/sN3Mf1t7/u4TAtJtnnd+8G30j/5chr+GgDq6p0uMVAi+1ZU
	VJF5pzUsqISoGToenR+OtHqr/M2hUX2qAo0iFiQeHsySq+6U2heDKWsxxxwzLbxSytdwDr3gCm4
	hfVYFXFO/wMOv8b+cZIgzU1cicm7LUJhrB6ct1QbZzczYUua4L4Ms3a4NcpqoBcXVTsr3ahxFX3
	xR3KyHhmSoBRaknRfnlrlXvQxRglU55RXGCAsUVhCaPKFi/DJTkpRfJRe7GPO56fTS6smaDYOjw
	345/LcFKTknoUn5WUz7vChZYG46bUablkILBZe0Dv9Y0yvoM2BJ8241c0n78559olkyE7J+yn//
	B+oHJ109cLRz4EewcY=
X-Received: by 2002:a17:90b:4a4b:b0:38f:240d:b857 with SMTP id 98e67ed59e1d1-39580a4d03cmr971369a91.2.1787097561159;
        Tue, 18 Aug 2026 16:59:21 -0700 (PDT)
Received: from devvm16600.scu0.facebook.com ([2a03:2880:9ff:73::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ae5f1ffsm1121775c88.13.2026.08.18.16.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 16:59:20 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:59:17 -0700
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
Message-ID: <aoTx1eaNNJ+xrUq1@devvm16600.scu0.facebook.com>
References: <20260818002450.3071325-1-ziyang.meme@gmail.com>
 <20260818002450.3071325-2-ziyang.meme@gmail.com>
 <aoSTaFwsVEoNW01D@slm.duckdns.org>
 <aoTgVOTxsEbFXTp2@devvm16600.scu0.facebook.com>
 <aoTg7ybddqzoZbz7@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aoTg7ybddqzoZbz7@slm.duckdns.org>

Hi Tejun,

On Tue, Aug 18, 2026 at 12:47:11PM -1000, Tejun Heo wrote:
>On Tue, Aug 18, 2026 at 03:44:36PM -0700, Ziyang Men wrote:
>> > > +BTF_KFUNCS_START(bpf_rstat_common_kfunc_ids)
>> > > +BTF_ID_FLAGS(func, bpf_css_flush_rstat, KF_SLEEPABLE)
>> > > +BTF_ID_FLAGS(func, bpf_cgroup_base_stat, KF_SLEEPABLE)
>> >
>> > Why are these SLEEPABLE?
>> >
>>
>> The css_rstat_flush() calls might_sleep() and cond_resched().
>
>I see.
>
>> The bpf_cgroup_base_stat() takes an rstat spinlock_t, which can sleep on
>> PREEMPT_RT.
>
>Is this actually required? This doesn't really make sense to me. Shouldn't
>what SLEEPABLE mean change on RT kernels instead?

Oh sorry, I didn't notice that.

I might be wrong: this function calls the cputime_adjust(), which in turn
acquires raw_spin_lock_irqsave(), so there would be NMI deadlock in the
perf_event program. The __css_rstat_lock() take the spin_lock_irq() as well. So
maybe a SLEEPABLE tag is still necessary?

Please let me know your concerns. Thanks!

Best,
Ziyang

>
>Thanks.
>
>-- 
>tejun
