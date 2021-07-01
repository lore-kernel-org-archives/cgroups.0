From: Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH] cgroup1: fix leaked context root causing sporadic NULL
 deref in LTP
Date: Thu, 01 Jul 2021 13:43:19 +0100
Message-ID: <8f20f2edd60fbff426b086599ae943ff09195b9c.camel@linuxfoundation.org>
References: <20210616125157.438837-1-paul.gortmaker@windriver.com>
         <YMoXdljfOFjoVO93@slm.duckdns.org> <20210630161036.GA43693@sirena.org.uk>
         <696dc58209707ce364616430673998d0124a9a31.camel@linuxfoundation.org>
         <20210701121133.GA4641@sirena.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=mo6oA/XnbDUGfk8NTnLtsX2Oxt2DjcL5ZEyjcIbXJxE=;
        b=ZoT209PloXnbOEhL1QU7auZZ8wiKaoDhkCY5o/ymMMMc54wtJgZRSBBst/6uWhboWC
         HJUkHBzw6bANDxSgtGj3yL1oQE4Q6Lxw9ITAw68rg6FgsGIcy5ANlDp5PbqojKIES3/e
         ZlmYBBAluT51L1CqtjRWPvBnwPN/vR35iWVlA=
In-Reply-To: <20210701121133.GA4641@sirena.org.uk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mark Brown <broonie@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, stable@vger.kernel.org

On Thu, 2021-07-01 at 13:11 +0100, Mark Brown wrote:
> On Wed, Jun 30, 2021 at 11:31:06PM +0100, Richard Purdie wrote:
> 
> > Out of interest are you also seeing the proc01 test hang on a non-blocking
> > read of /proc/kmsg periodically?
> 
> > https://bugzilla.yoctoproject.org/show_bug.cgi?id=14460
> 
> > I've not figured out a way to reproduce it at will yet and it seems strace
> 
> I've been talking to Ross, he mentioned it but no, rings no bells.
> 
> > was enough to unblock it. It seems arm specific.
> 
> If it's 32 bit I'm not really doing anything that looks at it.

Its aarch64 in qemu running on aarch64 hardware with KVM.

If you do happen to see anything let us know!

Cheers,

Richard


