From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 27 Oct 2015 14:46:34 +0900
Message-ID: <20151027054634.GA16310@mtj.duckdns.org>
References: <20150912144007.GA8942@htj.duckdns.org>
 <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
 <20151001184629.GB26498@mtj.duckdns.org>
 <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
 <20151023222110.GA4390@mtj.duckdns.org>
 <1445661367.3218.62.camel@gmail.com>
 <20151025021829.GA15471@mtj.duckdns.org>
 <1445744613.3180.60.camel@gmail.com>
 <20151027031656.GA11962@mtj.duckdns.org>
 <1445924531.2909.79.camel@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=cGKBOr1iOQh9VsZdQ3nnIsterfAnu/Dl3H1iko+w7bI=;
        b=jQoNnueG9lyL1lM5jv6r2qmr3DKFW118k7J/gqp2ndRLu8zjPSKEE0k3cvCqKAVhdD
         NzOdawHgmqWp9Fo3OlmR4OlkT/taXi1DdUSQytUDeuUmt9kHAooMFdSGegwY7Y0CyF9y
         CAF4Wr2+HHlCKwtr2J1DbvxmxfoYBXMqCqHktFcvfSz6hQiACVPFtbNkqfjbikGbZnPH
         rRs0sqr6DTUIheb/wLYUvecKb9p6h0mUhmJL7viCxD2+/9s36U2r5juNITAEdFn/tsi7
         ogE7r33psTXM2heUpH3AuTODqy4XpvD8bGjtrax4QxsDeVF6tVCDZQlmh8JgxN+6yw//
         fBUA==
Content-Disposition: inline
In-Reply-To: <1445924531.2909.79.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Tue, Oct 27, 2015 at 06:42:11AM +0100, Mike Galbraith wrote:
> Sure, sounds fine, I just fervently hope that the below is foul swamp
> gas having nothing what so ever to do with your definition of "saner".

lol, idk, you keep taking things in weird directions.  Let's just stay
technical, okay?

> http://www.linuxfoundation.org/news-media/blogs/browse/2013/08/all-about-linux-kernel-cgroup%E2%80%99s-redesign
> 
> http://www.freedesktop.org/wiki/Software/systemd/ControlGroupInterface/
> 
> I'm not into begging.  I really don't want to have to ask anyone to
> pretty please do for me what I can currently do all by my little self
> without having to give a rats ass less whether what I want to do fits in
> the world view of this or that obnoxious little control freak.

Well, if you think certain things are being missed, please speak up.
Not in some media campaign way but with technical reasoning and
justifications.

Thanks.

-- 
tejun
