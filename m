From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Sun, 25 Oct 2015 04:43:33 +0100
Message-ID: <1445744613.3180.60.camel@gmail.com>
References: <20150824221935.GN28944@mtj.duckdns.org>
	 <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
	 <20150825210234.GE26785@mtj.duckdns.org>
	 <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
	 <20150912144007.GA8942@htj.duckdns.org>
	 <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
	 <20151001184629.GB26498@mtj.duckdns.org>
	 <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
	 <20151023222110.GA4390@mtj.duckdns.org>
	 <1445661367.3218.62.camel@gmail.com>
	 <20151025021829.GA15471@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=KsD36yARXjzICIcbsfvwFYEdREk0GPVkYhFvmwWuJnY=;
        b=YBxPvyQa3s9CNK9DbUQTkxmIOmblPA902qLwovvPGqSXDCtvdJMzrhR1mnoMgscVK8
         hikY2pCiKBvwdUgxZ6ToFTxcInal4YTVSKUrtZXzIcG4rSsQOIR5nGEX4Hi8exVRwc66
         BreQaA5ryV0FhpS3xyuUpMt7JMJuG6mc/3525uN0MkMT12vW+u2mxJOt3kCtPG/NAhio
         mJMPxyhJnc06TBV/RJcznDteKm38zpLM/FlBupXVlv1E2yxZgBq9vZz7LVYgciGTgwF7
         VKjZ7WmaYWvcC7l4OGgGXcrDkN8atFkFsiUIWkfdKfxezWDYQxLDOMQGx9P7H5exV/M8
         xowg==
In-Reply-To: <20151025021829.GA15471-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sun, 2015-10-25 at 11:18 +0900, Tejun Heo wrote:
> Hello, Mike.
> 
> On Sat, Oct 24, 2015 at 06:36:07AM +0200, Mike Galbraith wrote:
> > On Sat, 2015-10-24 at 07:21 +0900, Tejun Heo wrote:
> > 
> > > It'd be a step back in usability only for users who have been using
> > > cgroups in fringing ways which can't be justified for ratification and
> > > we do want to actively filter those out.
> > 
> > Of all the cgroup signal currently in existence, seems the Google signal
> > has to have the most volume under the curve by a mile.  If you were to
> > filter that signal out, what remained would be a flat line of noise.
> 
> This is a weird direction to take the discussion, but let me provide a
> counter argument.

I don't think it's weird, it's just a thought wrt where pigeon holing
could lead:  If you filter out current users who do so in a manner you
consider to be in some way odd, when all the filtering is done, you may
find that you've filtered out the vast majority of current deployment.

> Google sure is an important user of the kernel and likely the most
> extensive user of cgroup.  At the same time, its kernel efforts are
> largely in service of a few very big internal customers which are in
> control of large part of the entire software stack.  The things that
> are important for general audience of the kernel in the long term
> don't necessarily coincide with what such efforts need or want.

I'm not at all sure of this, but I suspect that SUSE's gigabuck size
cgroup power user will land in the same "fringe" pigeon hole.  If so,
that would be another sizeable dent in volume.

My point is that these power users likely _are_ your general audience.
 
> I'd even venture to say as much as the inputs coming out of google are
> interesting and important, they're also a lot more prone to lock-in
> effects to short term solutions and status-quo given their priorities.
> This is not to denigrate google's kernel efforts but just to
> counter-balance "it's google" as a shortcut for proper technical
> discussions.
> 
> There are good reasons why cgroup is the design disaster as it is now
> and chasing each usage scenario and hack which provides the least
> immediate resistance without paying the effort to extract the actual
> requirements and common solutions is an important one.  It is critical
> to provide back-pressure for long-term thinking and solutions;
> otherwise, we're bound to repeat the errors and end up with something
> which everyone loves to hate.
> 
> We definitely need to weigh the inputs from heavy users but also need
> to discern the actual problems which need to be solved from the
> specific mechanisms chosen to solve them.  Let's please keep the
> discussions technical.

Sure, it was just a thought wrt "actively filter those out" and who all
"those" may end up being.

	-Mike
