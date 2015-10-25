From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Sun, 25 Oct 2015 10:33:32 +0100
Message-ID: <20151025093331.GA4834@gmail.com>
References: <20150825210234.GE26785@mtj.duckdns.org>
 <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
 <20150912144007.GA8942@htj.duckdns.org>
 <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
 <20151001184629.GB26498@mtj.duckdns.org>
 <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
 <20151023222110.GA4390@mtj.duckdns.org>
 <1445661367.3218.62.camel@gmail.com>
 <20151025021829.GA15471@mtj.duckdns.org>
 <CA+55aFzMdG5VPA0ZvoFANj-H-7LHeu=JUvvqPykF_w5Nd0pnSA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=UGjqB1jt/w8Ob23x2KRAoOkputjRi14s7oNjRhQQNec=;
        b=xDreG/PDJKozJJLoYWL25IWJ7hDtQSyGbA/ltij11rge6bEgDDy66PYNU1i0t8sl3B
         V3rmoH1UlhTrED1UgCCMB8CI4rz/IVuvTmMAt/yGftgt8rhxoVdEf/FX1liGORXZwjDj
         GrSpTjMJ2Nr/rLKel7+kqI3reSoek4dgc4gFleaOUpgX0CZMSRZAWqD7YCBlijmAv9bT
         TLsQBUPlct2kLD655QHQGWT9Qov9np7pXU7DCPT7iTP8HZF5EZuLP9/LvYznXSURZ9/k
         X93YSEShBOBwCtG4QkfNYnTzTM8tSPXqzlZG4KT9m/fZTpiNMice5sxgKvPAzRyZaVhD
         6MOQ==
Content-Disposition: inline
In-Reply-To: <CA+55aFzMdG5VPA0ZvoFANj-H-7LHeu=JUvvqPykF_w5Nd0pnSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


* Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:

> On Sun, Oct 25, 2015 at 11:18 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > We definitely need to weigh the inputs from heavy users but also need to 
> > discern the actual problems which need to be solved from the specific 
> > mechanisms chosen to solve them.  Let's please keep the discussions technical.  
> > That's the best way to reach a viable long-term solution which can benefit a 
> > lot wider audience in the long term.  Even though that might not be the path 
> > of least immediate resistance, I believe that google will be an eventual 
> > beneficiary too.
> 
> So here's a somewhat odd request I got to hear very recently (at LinuxCon EU in 
> Ireland)..
> 
> A least some game engine writers apparently would like to be able to set 
> scheduling priorities for threads within a single process, because they may want 
> te game as a whole to have a certain priority, but then some of the threads are 
> critical for latency and may want certain guaranteed resources (eg audio or 
> actual gameplay) while others are very much background things (garbage 
> collection etc).
> 
> I suspect that's a very non-google use. We apparently don't really support that 
> kind of per-thread model right now at all.

Hm, that's weird - all our sched_*() system call APIs that set task scheduling 
priorities are fundamentally per thread, not per process. Same goes for the old 
sys_nice() interface. The scheduler has no real notion of 'process', and certainly 
not at the system call level.

This was always so and is expected to remain so in the future as well - and this 
is unrelated to cgroups.

> Do they want cgroups? Maybe not. You can apparently do something like this under 
> Windows and OS X, but not under Linux (and I'm reporting second-hand here, I 
> don't know the exact details). I'm just bringing it up as a somewhat unusual 
> non-server thing that is certainly very relevant despite being different.

So I'd realy like to hear about specifics, and they might be banging on open 
doors!

Thanks,

	Ingo
