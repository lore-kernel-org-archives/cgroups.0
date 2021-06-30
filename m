From: Richard Purdie <richard.purdie-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] cgroup1: fix leaked context root causing sporadic NULL
 deref in LTP
Date: Wed, 30 Jun 2021 23:31:06 +0100
Message-ID: <696dc58209707ce364616430673998d0124a9a31.camel@linuxfoundation.org>
References: <20210616125157.438837-1-paul.gortmaker@windriver.com>
         <YMoXdljfOFjoVO93@slm.duckdns.org> <20210630161036.GA43693@sirena.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=GMyVPuFMxYNbLMHQBfZilBl/NBmnN5vmlOEDJDVgikA=;
        b=H6lxDxqfFalvZBt10BgprhpbLvdq+DLerLRsXowgxYS2LE3FLuoCBt5dBBadg0Xghf
         KNDj9akhByJUB+imIU+sZmgZhWGTlhLfIXeCi6ADK574Zg1+4THNfr254tFvYlWUE2m7
         g3kxUdJVWLcLarbekZcB5Ay6FOh7hXYRuMJZU=
In-Reply-To: <20210630161036.GA43693-GFdadSzt00ze9xe1eoZjHA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2021-06-30 at 17:10 +0100, Mark Brown wrote:
> On Wed, Jun 16, 2021 at 11:23:34AM -0400, Tejun Heo wrote:
> > On Wed, Jun 16, 2021 at 08:51:57AM -0400, Paul Gortmaker wrote:
> 
> > > A fix would be to not leave the stale reference in fc->root as follows:
> 
> > >    --------------
> > >                   dput(fc->root);
> > >   +               fc->root = NULL;
> > >                   deactivate_locked_super(sb);
> > >    --------------
> 
> > > ...but then we are just open-coding a duplicate of fc_drop_locked() so we
> > > simply use that instead.
> 
> > As this is unlikely to be a real-world problem both in probability and
> > circumstances, I'm applying this to cgroup/for-5.14 instead of
> > cgroup/for-5.13-fixes.
> 
> FWIW at Arm we've started seeing what appears to be this issue blow up
> very frequently in some of our internal LTP CI runs against -next, seems
> to be mostly on lower end platforms.  We seem to have started finding it
> at roughly the same time that the Yocto people did, I guess some other
> change made it more likely to trigger.  Not exactly real world usage
> obviously but it's creating quite a bit of noise in testing which is
> disruptive so it'd be good to get it into -next as a fix.

It is a horrible bug to debug as you end up with "random" failures on the 
systems which are hard to pin down. Along with the RCU stall hangs it
was all a bit of a nightmare.

Out of interest are you also seeing the proc01 test hang on a non-blocking
read of /proc/kmsg periodically?

https://bugzilla.yoctoproject.org/show_bug.cgi?id=14460

I've not figured out a way to reproduce it at will yet and it seems strace
was enough to unblock it. It seems arm specific.

Cheers,

Richard



