Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F3D3C1D48
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 20:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787256308; cv=none; b=llGtBuLREARrsks86O/aH2FQk/bxRsMaot7SKdiBuLCq742HEZWPI8/GOERJA8JUcGpQu1S093gdklvePceejqlTzS/ai0t6qkiM/8Z2cvrSE3KHDLp/TysZtCs7bpQriBQf5obg+dAQ5ejPYLiEc4yokjQAXSUlLgmuw1hhLVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787256308; c=relaxed/simple;
	bh=Aw/ofYSmMq/hCctkdEPZ9sneab2XTminwcfhlt6xz3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gWhu+qy2B24Q8mAgNSeHvuNbejAWlXsq5u3kqQ9V3CXrKo+i/zoAfv9v3S92+u6u1Zo5uhEGrcdrrcg1o45XKI6CO+aALzwlg1zIsOQs34Mj9uQcNtD0YVVm3kfbiY+Tq1h0xeJ87wSZOvcJDEYiBtW6cZ+k85LKXhFFrkbG4sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CspOK5+8; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CspOK5+8"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2caced6038eso1859615ad.0
        for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 13:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787256305; x=1787861105; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W+ttLV2jMb/uOUdRDGthE1WHXT4FvT3P7ffiAV7gUtI=;
        b=CspOK5+8rXyfrhCiSkiXDpyCsuBHQUUYtm7NREaRjf48p5mXd9uLLSVBLzWt8FhdhD
         BvnzmGQPVmFq306Hsl5npy8DBYOYjaDGv5QFOnbTLAfQ5SNcTr75xEbDurQBBN9pbd6W
         YQllygYUNyDq0gU3ia79PycvUh1QerCAbwF1JMM/h45ovXt8JMnacYRtJasKMV7CZX5A
         PjvDVoo0AyrQVRddbTO7t1cDHdtYx6eY8d8IEqQRB1nLbL4w6yNSbXl3LJGEV70t4EZ7
         b8UZGipq+Yu8zxh4/f+J7xwa5Ttrgq+wkiNocoCHGNbsIwnBFWz3uOL8B93MmQJMfb35
         Jycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787256305; x=1787861105;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W+ttLV2jMb/uOUdRDGthE1WHXT4FvT3P7ffiAV7gUtI=;
        b=CQ4SBh7GZqSaQo0MSGdtfAQ/CpTYnjNybAsNoDOGdaC24XKuQDsSw+lHrmGhuwSrMN
         /ebgUCufPTXZeOPWHV22USQZ6FuZBvk9hA6BpsScfQD32UNuAgmzV/ahSrQsnhpWTSxO
         /lGZgCjHAdAT4+VN1qarW41DR+Wfo4v0hHJ5bVjmRumNPEp+j4v9tY7+tF0zKVdolJXG
         tTzjSjmSbjI08vJI35wOEt8wf9VV9IigLNLbEd/Bc4dwsmDRcT6lYmSUErMmgupN/dLb
         DDIkctwf+DHpLi7XftkhNtyMrHbhI44P8RgwKTwhF4/hnc0kpseGHykLEtXSXJHhCDT6
         x8mw==
X-Forwarded-Encrypted: i=1; AHgh+RqM6vwigTlwg0a5UjalDj5tz1ZzikMomST4wewUeGaG9vzxtBnqjY78znCDY2L5Zkaf34TZE376@vger.kernel.org
X-Gm-Message-State: AFuF++nhrO4nYVa21fN+ZkMMRm67JpF0W/H2auweE3K16KsmQLmYeX63
	s4XsgsF8Bb+vXHy89fLlE418oCfuAnNW0DlWiuW1W3EkFpFz6bOoUS2K
X-Gm-Gg: AR+sD12MMK0k69RaX91A8PQKeBwh4ClAZ9izVV7va7jmWyLfdIFXRQLzRaGCkz0gZOf
	eh3xTvIkA012GV+4EXimV4rAbRuEEH5Ea81jA05iZ652MjJ8yHIQz0vaRhKsLyYnvG6fU/Kq2Cx
	fs35U+rVdhcDLdDDKWOQElU+vMRqDKAT6bHZ2mPrJAH4xsjeJ2Z0RxlKRvRGfrwbVyfSeg30A6G
	+a1XvnQ6Tma4QMIqf2/oeIM2qGg+W253m+s1dcmhyXp4UrxIK/i+k79/J9U1JOob6VaH/kgiPsp
	84F21BlP1cAXJmfFpJI6aG3jYmBhh/YqtAeLNwz+GbXdKwtTHB5IY67IycgqszNIoihGSzAM1+9
	riYtm/vWDNRPC4P8/ga2CXjZtDAPVNEKKsdBDRmSlESWyNPp+b3XJ9Mw675yiJGKDqvEw+tDTTv
	ms7NdOOjb5iEtr7jiApxIdjVFCE/3f5vtzNotJ28FP1FGmPUVfm2dMGBSNTRZSBoa7gdc6qo9mL
	BjlfoKW
X-Received: by 2002:a17:902:fc48:b0:2cf:7ea3:7cf1 with SMTP id d9443c01a7336-2d61a078e1amr118047715ad.5.1787256305116;
        Thu, 20 Aug 2026 13:05:05 -0700 (PDT)
Received: from devvm16600.scu0.facebook.com ([2a03:2880:9ff:6b::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bf191821sm18740151eec.28.2026.08.20.13.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 13:05:04 -0700 (PDT)
Date: Thu, 20 Aug 2026 13:05:01 -0700
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
Message-ID: <aodd7S4Broor2oHt@devvm16600.scu0.facebook.com>
References: <20260818002450.3071325-1-ziyang.meme@gmail.com>
 <20260818002450.3071325-2-ziyang.meme@gmail.com>
 <aoSTaFwsVEoNW01D@slm.duckdns.org>
 <aoTgVOTxsEbFXTp2@devvm16600.scu0.facebook.com>
 <aoTg7ybddqzoZbz7@slm.duckdns.org>
 <aoTx1eaNNJ+xrUq1@devvm16600.scu0.facebook.com>
 <aoYYX60TCD6cd601@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aoYYX60TCD6cd601@slm.duckdns.org>

Hi Tejun,

On Wed, Aug 19, 2026 at 10:55:59AM -1000, Tejun Heo wrote:
>Hello,
>
>On Tue, Aug 18, 2026 at 04:59:17PM -0700, Ziyang Men wrote:
>> > > The bpf_cgroup_base_stat() takes an rstat spinlock_t, which can sleep on
>> > > PREEMPT_RT.
>> >
>> > Is this actually required? This doesn't really make sense to me. Shouldn't
>> > what SLEEPABLE mean change on RT kernels instead?
>>
>> Oh sorry, I didn't notice that.
>>
>> I might be wrong: this function calls the cputime_adjust(), which in turn
>> acquires raw_spin_lock_irqsave(), so there would be NMI deadlock in the
>> perf_event program. The __css_rstat_lock() take the spin_lock_irq() as well. So
>> maybe a SLEEPABLE tag is still necessary?
>
>I think this is for BPF folks to answer. I don't think SLEEPABLE is needed
>because of RT but yeah it wouldn't be safe to be called from nmi context.

Ok I see, let's remove the SLEEPABLE for now. 

Thanks,
Ziyang

>
>Thanks.
>
>-- 
>tejun
