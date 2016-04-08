From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHSET RFC cgroup/for-4.6] cgroup, sched: implement resource
 group and PRIO_RGRP
Date: Fri, 08 Apr 2016 05:13:56 +0200
Message-ID: <1460085236.4026.15.camel@gmail.com>
References: <1457710888-31182-1-git-send-email-tj@kernel.org>
	 <20160314113013.GM6344@twins.programming.kicks-ass.net>
	 <20160406155830.GI24661@htj.duckdns.org>
	 <20160407064549.GH3430@twins.programming.kicks-ass.net>
	 <20160407073547.GA12560@cmpxchg.org>
	 <20160407082810.GN3430@twins.programming.kicks-ass.net>
	 <20160407190424.GA20407@cmpxchg.org>
	 <20160407193127.GB3448@twins.programming.kicks-ass.net>
	 <20160407202344.GA22509@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EbYgQ23nQmfTw92fj/4oP886Z6THDH/5suxzd+l3E1c=;
        b=y7WPikw6DHeKykKQrxPAtsNSsoiIRoFdHHBp94AbLR7dBFiuy7j2EyywJTrZeIttMj
         d3itqmcWQIT5sDI8ptXdXE1woGixHuH6X2utWVuM2skB2zfCjVTbCMCF9WJKcdFJBa/a
         lUahUZLHfcanmlo67fvbzZJB40uToUm55Gibz59YgXGSViHLWPIPmn+HIs7Pp5P0+0oY
         UYEvVMnq6gZ8csLflnGnyVPUwizUft2FLLK9wpIUoQAZoRcd/dxkqedGF7qqWHtxSze0
         C6bb8nNS/gqw3PXtcw2j3UQ7Y6kKxNvNNzMf4Lfwc0BZ8+LcsMECVvsNhsrtcKm4I6Le
         HkVg==
In-Reply-To: <20160407202344.GA22509-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, 2016-04-07 at 16:23 -0400, Johannes Weiner wrote:

> Mike, is that the one you referred to with one group per customer
> account? If so, would you have a pointer to where you outline it?

The usage I loosely outlined, I did in this thread.  All of the gory
details I do not have, do not want, and could not provide if I did.

	-Mike
