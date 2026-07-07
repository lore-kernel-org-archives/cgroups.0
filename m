Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2FC4252C0
	for <cgroups@vger.kernel.org>; Tue,  7 Jul 2026 21:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783460199; cv=none; b=IFPaQvJwiCfZSjNjsobMZB6OwlM/LJGE28wWvwRUR22VOfhvJ0jd5BF+GYC6nkfAWZLqOwkjKoIkcGAqEp5euwMTHNtDSJBhmvz71SeFri9rl5RpZCIVnOlMPLFByBI91XVj+DF7xTqC28+n00080aaYXzBI01n7KqEHJjDM8MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783460199; c=relaxed/simple;
	bh=mfvgbak40ISEAt+FEvvSkwOEo6xkg00TCiXxZ1jMDFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DiQHtr6r9WyiUB51ArlNoa7zWMbYaRE8XRPBZmhYCwj8aNZ//OXNa1JNLH0sg6rWeRaNyaFMWfMhqclDoxMtX66vT7OtpuAOw9NqHFldDPjkZH6GydUQPVttvJUDLH1+SRE5FnyyDR3twDfwviA6Q8/3yW77+J2d5P/TWBISk0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mJsOeSIE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJsOeSIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7921F000E9
	for <cgroups@vger.kernel.org>; Tue,  7 Jul 2026 21:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783460198;
	bh=mfvgbak40ISEAt+FEvvSkwOEo6xkg00TCiXxZ1jMDFI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mJsOeSIEeV2UmBonPeaqEf7COTUt8n6mdPtwegRTmR9V2CL8iymV36hqlrv6mNFwV
	 DjFSroarFd/XqCvyDJtZih2xiXGOPgvmgcSfadydp96b6gvyMEXxGG0qTYdlgJNnsj
	 DdctrHdmyO2thFrusKyz3daNq38RorUr7vPlYVA6NcBPo7b9ehUDZrTps/KzYb/BnL
	 4zyc+9xsXk1ZSHdbhON+t/oOjEkpQoAJs8n9WNOkWb3s5ccjyM6dwaUL1jtqgkF9gR
	 4LhvOxSkw2qomni5RTLX5BJJ/XkBRsVdQpaoHuynohTlfqq4QOGuAvk/uqEq+98j2N
	 LQEqBwDx6TT5Q==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15b75c9e48so128658366b.1
        for <cgroups@vger.kernel.org>; Tue, 07 Jul 2026 14:36:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpKxCrT8vu59zCZICe5jq2fy4+czcsQ/RXOnlGBCx1bFicHT1Xe470TPDYcUI5BmuBg6ji2FpsC@vger.kernel.org
X-Gm-Message-State: AOJu0Yy49YtVJsvCAiB8jRrzoBVKvLMnJWY8Iv8R0d0FzkSvDXhqaR+T
	xrkV/yrhFoEDKArh8WuWYgkP+ZalU6FjxiLkJiyXELqw9s6GZSf6C01YYKCn5ocZG9BeOYQIVxy
	clU80ttxHDV9Y4P8LyTDMtlaGPFvkK00=
X-Received: by 2002:a17:907:bf06:b0:c12:36ff:6ebb with SMTP id
 a640c23a62f3a-c15a692b12dmr348765966b.44.1783460197298; Tue, 07 Jul 2026
 14:36:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com> <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
In-Reply-To: <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 7 Jul 2026 14:36:25 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
X-Gm-Features: AVVi8Cda2GhPqDSknVsY53Q6TlEfuCwJntD2kTQUNKYn1iwv3Wq_3XPV_UqjD2Q
Message-ID: <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: Nhat Pham <nphamcs@gmail.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, tj@kernel.org, mkoutny@suse.com, 
	Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 7, 2026 at 2:35=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Tue, Jul 7, 2026 at 11:25=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Tue, Jul 7, 2026 at 2:38=E2=80=AFAM Zenghui Yu <zenghui.yu@linux.dev=
> wrote:
> >
> > We were discussing a way for userspace to explicitly trigger a flush
> > before, which would come in handy for testing. However, we decided not
> > to expose flushing as a concept to userspace.
> >
> > Unfortunately I think the only way to "fix" the test is to allocate
> > more memory, enough to trigger a flush on most interesting setups.
> > Perhaps we should scale the amount of memory with the number of CPUs
> > so that we don't have to keep playing whack-a-mole.
>
> I don't have a good idea for writeback, but for zswap out, would
> MADV_PAGEOUT work here?

I don't think the reclaim mechanism is the problem, but the fact that
we don't have enough pending updates to flush the stats. Am I missing
something?
