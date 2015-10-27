From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 27 Oct 2015 07:08:41 +0100
Message-ID: <1445926121.2909.93.camel@gmail.com>
References: <20151001184629.GB26498@mtj.duckdns.org>
	 <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
	 <20151023222110.GA4390@mtj.duckdns.org>
	 <1445661367.3218.62.camel@gmail.com>
	 <20151025021829.GA15471@mtj.duckdns.org>
	 <1445744613.3180.60.camel@gmail.com>
	 <20151027031656.GA11962@mtj.duckdns.org>
	 <1445924531.2909.79.camel@gmail.com>
	 <20151027054634.GA16310@mtj.duckdns.org>
	 <1445925402.2909.86.camel@gmail.com>
	 <20151027060027.GA2888@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=SfgJlp5UScmiuKLK9CqR9vj+YpuUFvMwuYkvZkVggz8=;
        b=Z6Pox8Mj1+FnmxtcG3g32oFd+jq6d41NX+qauLw1re4ONEYqhvbCIfv5AoZlQmgO4v
         hiNE4FJKsAVvkfCZklKXjxbodvWyJiqaVKt+lS7bSTNYA7faZY1GNUBFDz7ybBY+mirs
         41ovbADq9RHB5CGXbcgYO+WP1qlxt5cYUH1sS5SAnEn7dbNFRnTtMcDiG9cnd5CTO2Cw
         EsS2wiKWh5C2GtVca1F5V0oBTYnHuV7t3F++A9kjt4sOu0DJbJVDl6f1s7Vc145rrKI4
         eCLKeDd9KrIwHZQ2dHF98Gy+hqmBlk7V4ipkIEchHlcSl0/buddzja2IMFtl8G1+s7jn
         0+sA==
In-Reply-To: <20151027060027.GA2888-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, 2015-10-27 at 15:00 +0900, Tejun Heo wrote:
> On Tue, Oct 27, 2015 at 06:56:42AM +0100, Mike Galbraith wrote:
> > > Well, if you think certain things are being missed, please speak up.
> > > Not in some media campaign way but with technical reasoning and
> > > justifications.
> > 
> > Inserting a middle-man is extremely unlikely to improve performance.
> 
> I'm not following you at all.  Technical reasoning and justifications
> is a middle-man?

No, user <-> systemd or whatever <-> kernel
             ^^^^^^^^^^^^^^^^^^^

> I don't think anything productive is likely to come out of this
> conversation.  Let's just end this sub-thread.

Agreed.

	-Mike
