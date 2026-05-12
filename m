Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEA025B09A
	for <cgroups@vger.kernel.org>; Tue, 12 May 2026 18:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778610747; cv=pass; b=Oa4vt/LT3HOG3eg/cNY2s8NO9nDatiDo2kjCV9xb2rEC//h6EEVvFPa9JusW8LVwv1C3fbKPhyv3PaEph2+sG2rqH8rWHyKmRlTUH48xITC9V1pt2bxK6jitSf8Pj8lFsKRyUIZbDIxQg56wSSGxOZEptDMwkMb16tmZKQKos7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778610747; c=relaxed/simple;
	bh=9n3d3hi94ogrboscVEXWl3L2iXVLpLIU/7myijZUXos=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ulBfL10en0GrUysuzMPtBP5ni9tNOyZgL8b1dlSvhysTNkakFR1PCYf6lwVKKUCeUBobEj0WN1BNR5nFlTkHIZadZAoGgRj9FJcD8tIZo2RwpxfqXIIwseynja7lAlORYClbrlugVSzmCZ9D8Y9jivJv+zyYYpPJHNEDQeGDmf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WsGOWMWi; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WsGOWMWi"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-67c3cb1433cso10275263a12.0
        for <cgroups@vger.kernel.org>; Tue, 12 May 2026 11:32:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778610744; cv=none;
        d=google.com; s=arc-20240605;
        b=eOrQAb1xt3Ax3wES+wOxkS5bN7LvP7jKqSAyWy5i117PEOaWS2qIz5SSw0xrhcVYJB
         MG9Uz4miSb5EexvQzFIf8lqkzlO1eB0AjoOn2Y3AS7Co0pkok90FL4At+usf3DNushyA
         JVbFYuYBxcyhYcmNMJ/iRIlOdCqh6iZWKplewqEfF7hWBimxpq6OgYY81+jcoFD5eSLS
         NCbQdXPbsEje7N3Q46F+qm9I7EVqQY5dQSwEW2GsMSjTilg9HSVZKID/9OJyI058ZFZk
         Is1J7JTzsHFkSC2f4uOw1NNPy5napmKLN3PuQaLDjqAjG47Bayq0D0/H5gqiVLTRYZ3p
         M7HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ROZEPFmrqgFjE7kQWMCo6f+HZYqu72QGhxZ0QsiW/Ys=;
        fh=Fqoojka3ueQEwHSvRb9BXikCv4XGOorckiGXjW+wdQk=;
        b=FtiXKdNjNIjx5O9Z4RuV9l8mWfagaDejq0+07+dki1Y3x/KM+42ytuXfUCDgSlt9Z5
         sUMWIPr0Ohx5ujHM644RzpJv1BJ/5p5Nd7syfOPmTH/j2iyzXDFPIe01/mwSIwBT/nju
         Kuza08Y6PYPJrXxLOQ8qUB6MN4DfvJc6OO2FMxLg77QKmGhfFwROtIYfwtmW9vv+KFln
         KF7L7qJZMucjIy8hVSrqP16Pt/NdvklulIZoj6L3PU6ZEym8eh4YyEzOEH95DXMGbYb+
         jR/ToGGoAn/W6cwP+N3qzD6E62hwzGr3L02ohdyJZ1TcKO9u6Q11LPpwvmkEg+yczxnm
         7M/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1778610744; x=1779215544; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ROZEPFmrqgFjE7kQWMCo6f+HZYqu72QGhxZ0QsiW/Ys=;
        b=WsGOWMWiW0IK9kKPm80u/N+PbmGzBqrhWiGuNltSzYMN2IYExHcpBwhhGmC7TRnQTS
         mC46tU6kuxU40C6kiAxkliMiVVNmSRD3DnHFMqVZPpMyvKyJrXqEXkK65W0ed/3RZZl7
         o148Y+0hqYYleV0IV9pKd7Nh5tZJbmGtQ6vfElD8+rTkPffDTQv+Idx/FygETbPGBuxp
         aK4/63R2wkZcAOhF5+p877zmLoNeSlkA+ZhC/77GBV1IQ6mS8pycGBQ7402yctx6Yrqv
         nhiX/OHAYLiYxnmS1jxswJG9+21SAOMyZ8A47QYIM0o1NrGG6J6bvodZgPTeXicIS8uZ
         1bYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778610744; x=1779215544;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ROZEPFmrqgFjE7kQWMCo6f+HZYqu72QGhxZ0QsiW/Ys=;
        b=jmACsRuR/fp5ub6Uq3Lw1UVt9jle+fsgPAczUr7etwIm8RzLbjvxJnTr6u7MXfYYl1
         Vc0V0sI7XDO0L9YfemjlqPqqozSQi4x4iHKgQwgTQrgjOVEPqtCE3iF4QyYcda3SeecY
         zd5O+RM+b9aPwAlqKEA5U4qjFrF1TNJX0JEqWQRj0dox5NLUxObqyl7zmmT4JFx9iEdc
         UX0zmhnykJe+YDwIVTR/AxIOyYDGODlJCI4eYgQtQPyxHhtRFKrCbZEuBI/VeshGS9t+
         ydKTdVOLBsdAzwlz5JquWiwrLdVqGCfFTfH9xn7CpYwqxhFqsGIh23vh9ki7/mvo02KK
         S8Uw==
X-Forwarded-Encrypted: i=1; AFNElJ86hVlIfJi4i89dV9c4MZX+5JcPULrT6SHofChvJKWBxjWmtN96DHQZQAbz9rrvEeR1ADn3MMdK@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc6kYnwU7cUIwcgOdoloOBuAGfMSRvG6ylCEn0IHBvU7qchvJd
	omKlX4MGWbbtLIPuercE6vGrf/vDvfJWpatJ0oMJR+UATYvBwcIahdSB6FLd3bNzl5PdvlWnv08
	q+zyPLx+AvUX5uFpcf2MMASdzmxemtG1leK18fEDSUw==
X-Gm-Gg: Acq92OFd3SQIp1LNMx+Bb+Sxu1s4BfejeXVJulWb1M2rFQSpyt3FjhQCmWHzIqI9mMS
	KZjzg40srbTaP8ZTA6y9XL3YYFBPWpeQXp2y6IWYrPD1L16mPiNZSRKq+Wj3HvCs9qJTxFhBXEx
	UoftF50KFREbQJj6rBX31e0a7y3bnNELdMb3Zpz5igud0U9tQSYSgdL5tuE/ccgIM/Y0UiR7P74
	JluMDcZDCgdk23Ri4upBHzpoGxxJw2MOiQsO+MnsbIwgbdz9mBwaSbrWtGsQIeUfnxvtee4h7fd
	F3hWhcpBHEdyySaiiqmp0gvWnFkW6MGplPt4
X-Received: by 2002:a05:6402:278c:b0:67c:6836:7b0a with SMTP id
 4fb4d7f45d1cf-67d6489d6e9mr16675048a12.23.1778610744295; Tue, 12 May 2026
 11:32:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260511113104.563854162@infradead.org> <CAKfTPtA2aBtuBffVV02VgsRRi5mRK0G5ununzuvJ7h7buygNxg@mail.gmail.com>
 <20260512092040.GN3102624@noisy.programming.kicks-ass.net>
 <20260512182439.GA2855641@noisy.programming.kicks-ass.net> <20260512182530.GB2855641@noisy.programming.kicks-ass.net>
In-Reply-To: <20260512182530.GB2855641@noisy.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 12 May 2026 20:32:12 +0200
X-Gm-Features: AVHnY4K7CBKByhCk4U02GKWHFYCEbdc9FtkE-dgFzTQmnXhKF0jjYO5GR4siX7U
Message-ID: <CAKfTPtBq6QO6yjL9SHWfL+pSoe=4_cddzYtqWGXtpLJmi8hSig@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] sched: Flatten the pick
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, longman@redhat.com, chenridong@huaweicloud.com, 
	juri.lelli@redhat.com, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, 
	hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jstultz@google.com, kprateek.nayak@amd.com, 
	qyousef@layalina.io
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 May 2026 at 20:25, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, May 12, 2026 at 08:24:39PM +0200, Peter Zijlstra wrote:
> > On Tue, May 12, 2026 at 11:20:40AM +0200, Peter Zijlstra wrote:
> > > On Tue, May 12, 2026 at 10:42:33AM +0200, Vincent Guittot wrote:
> > >
> > > >
> > > > I haven't reviewed the patches yet but I ran some tests with it while
> > > > testing sched latency related changes for short slice wakeup
> > > > preemption. I have some large hackbench regressions with this series
> > > > on HMP system with and without EAS. those figures are unexpected
> > > > because the benchs run on root cfs
> > > >
> > > > One example with hackbench 8 groups thread pipe
> > > > tip/sched/core  tip/sched/core          +this patchset          +this patchset
> > > > slice 2.8ms     16ms                    2.8ms                   16ms
> > > > dragonboard rb5 with EAS
> > > > 0,748(+/-4,6%)  0,621(+/-3.6%) +17%     1,915(+/-7.9%) -156%
> > > > 0,689(+/- 9.1%) +8%
> > > >
> > > > radxa orion6 HMP without EAS
> > > > 0,588(+/-5.8%)  0,677(+/-5.9%) -15%     1,505(+/-10%) -156%
> > > > 1,071(+/-5.9%) -82%
> > > >
> > > > Increasing the slice partly removes regressions but tis is surprising
> > > > because the bench runs at root cfs and I thought that results will not
> > > > change in such a case
> > > >
> > > > I will review the patchset and try to get what is going wrong
> > >
> > > Yeah, that is unexpected. Let me go have another look too.
> >
> > So I can reproduce even without the last patch applied. I suspect it is
> > in the cgroup mode patches somewhere. My first suspect is that concur
> > mode thing doing bad things to track the 'global' nr_running thing.
>
> Argh, n/m PEBKAC. I'll try this again in the morning :/

Reverting the last patch is enough to recover performance
