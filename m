From: Qais Yousef <qyousef@layalina.io>
Subject: Re: [PATCH 0/6] Backport rework of deadline bandwidth restoration
 for 6.4.y
Date: Mon, 28 Aug 2023 00:35:24 +0100
Message-ID: <20230827233524.7anzxffj4v7srxzd@airbuntu>
References: <20230821221956.698117-1-qyousef@layalina.io>
 <2023082742-dad-henna-cb35@gregkh>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1693179326; x=1693784126;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v5y6/ZTjfXJEZbiKUq7WiVLqlVma4fac9mBsqpVtToc=;
        b=Y+xN6CskKFlhmnznfmJANIYNZI/rBGg0IytL+b7I6Prqr2/PZa9zDAeilCxz5UEzhC
         uKpkDYhdrtEzqLfGSZevY+E2VbxaQ3wraLYdFmGP7peBfJYA6jRXniMSUheCvixmXF4m
         XwKUtu6Nm4PxjGHpu03M2e5C+ZO+30RwBDmnVJPBrQLz+Z9jj2jEhlmuIdQ6QhiXBGvh
         Z2tnwLaYO1SupFQGAqQLgieByrPF9QyKHtG9zkv+UwwX0TNwYDmZTpc8PiLqRhisVkew
         e729/B2D9V/fUPjsEcZUNFqJ49LI6svji101PpBPMv7ytDmxQZhBOEcADJmjZLP/Bd8w
         lgfQ==
Content-Disposition: inline
In-Reply-To: <2023082742-dad-henna-cb35@gregkh>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Peter Zijlstra <peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, Ingo Molnar <mingo@kernel.org>, Hao Luo <haoluo@google.com>, John Stultz <jstultz@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 08/27/23 10:34, Greg KH wrote:
> On Mon, Aug 21, 2023 at 11:19:50PM +0100, Qais Yousef wrote:
> > This is a backport of the series that fixes the way deadline bandwidth
> > restoration is done which is causing noticeable delay on resume path. It also
> > converts the cpuset lock back into a mutex which some users on Android too.
> > I lack the details but AFAIU the read/write semaphore was slower on high
> > contention.
> > 
> > Compile tested against some randconfig for different archs. Only boot tested on
> > x86 qemu.
> > 
> > Based on v6.4.11
> > 
> > Original series:
> > 
> > 	https://lore.kernel.org/lkml/20230508075854.17215-1-juri.lelli@redhat.com/
> > 
> > Thanks!
> 
> All backports now queued up, thanks for doing this work!

And thanks for your patience!
