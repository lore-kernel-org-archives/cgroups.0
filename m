From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Sun, 25 Oct 2015 06:41:45 -0400
Message-ID: <20151025104145.GE27558@thunk.org>
References: <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
 <20150912144007.GA8942@htj.duckdns.org>
 <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
 <20151001184629.GB26498@mtj.duckdns.org>
 <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
 <20151023222110.GA4390@mtj.duckdns.org>
 <1445661367.3218.62.camel@gmail.com>
 <20151025021829.GA15471@mtj.duckdns.org>
 <CA+55aFzMdG5VPA0ZvoFANj-H-7LHeu=JUvvqPykF_w5Nd0pnSA@mail.gmail.com>
 <20151025093331.GA4834@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org; s=ef5046eb;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=9wFaYhlwqD2b4C+X68JmpvGyRcrWG/seJPvos0LLs8o=;
	b=uCooAznRB0iEIVM1gNB1aoiu8QBWo2vZy25hlKdGnqyE0DjCvQsQcLE+6nR9f95S6weMtHmHjdfdJSmYbTdIUjEPx1k7BQvGx9tiU+KQUPEu34bHxQ9D1rUujBxIOgRGsHW8daQacnaU3dSwD+fAZCkfIANtgsEn/uCKml3RJTI=;
Content-Disposition: inline
In-Reply-To: <20151025093331.GA4834-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sun, Oct 25, 2015 at 10:33:32AM +0100, Ingo Molnar wrote:
> 
> Hm, that's weird - all our sched_*() system call APIs that set task scheduling 
> priorities are fundamentally per thread, not per process. Same goes for the old 
> sys_nice() interface. The scheduler has no real notion of 'process', and certainly 
> not at the system call level.
>

I suspect the main issue is that the games programmers were trying to
access it via libc / pthreads, which hides a lot of the power
available at the raw syscall level.  This is probably more of a
"tutorial needed for userspace programmers" issue, at a guess.

	  	     	       		    	   - Ted
