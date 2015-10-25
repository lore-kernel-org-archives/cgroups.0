From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Sun, 25 Oct 2015 11:18:29 +0900
Message-ID: <20151025021829.GA15471@mtj.duckdns.org>
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
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=N/gpJQDqYeeQjUYlzEYH7C6VxJzp2s+G06GIN+lx7Sg=;
        b=U+tWeENOzAeWGFhYdVD/z43k/goD4IDBieJnL25dnO7LQJLPcRG7flTfZfmIpIQ0fg
         ITpKBkYZefFZIvlYUn5vOsFIOZSeOxZLSYmAI/3xJr9MxW2yg6jrOouvppLnYQ5/Oq5S
         yV00fSQNCgs2AeC5IYBBywX5NE15oUr3wvK7+HfP3KWWYDr1T86EF+VaR7SVaRuvQeaE
         Y1rulQ9kprsKXtWPkh7QgsFLlITJcjLksP2DHLi/K/+C3ZsHIchmUSd3Iz8wMjxc5zjv
         iD6pSk0SMM5+UHNrd67fLuNyTHozrH0jUfJ5RQ0+47Qph8jxY3O3HiR2CkH25t+z10SQ
         pcww==
Content-Disposition: inline
In-Reply-To: <1445661367.3218.62.camel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

Hello, Mike.

On Sat, Oct 24, 2015 at 06:36:07AM +0200, Mike Galbraith wrote:
> On Sat, 2015-10-24 at 07:21 +0900, Tejun Heo wrote:
> 
> > It'd be a step back in usability only for users who have been using
> > cgroups in fringing ways which can't be justified for ratification and
> > we do want to actively filter those out.
> 
> Of all the cgroup signal currently in existence, seems the Google signal
> has to have the most volume under the curve by a mile.  If you were to
> filter that signal out, what remained would be a flat line of noise.

This is a weird direction to take the discussion, but let me provide a
counter argument.

Google sure is an important user of the kernel and likely the most
extensive user of cgroup.  At the same time, its kernel efforts are
largely in service of a few very big internal customers which are in
control of large part of the entire software stack.  The things that
are important for general audience of the kernel in the long term
don't necessarily coincide with what such efforts need or want.

I'd even venture to say as much as the inputs coming out of google are
interesting and important, they're also a lot more prone to lock-in
effects to short term solutions and status-quo given their priorities.
This is not to denigrate google's kernel efforts but just to
counter-balance "it's google" as a shortcut for proper technical
discussions.

There are good reasons why cgroup is the design disaster as it is now
and chasing each usage scenario and hack which provides the least
immediate resistance without paying the effort to extract the actual
requirements and common solutions is an important one.  It is critical
to provide back-pressure for long-term thinking and solutions;
otherwise, we're bound to repeat the errors and end up with something
which everyone loves to hate.

We definitely need to weigh the inputs from heavy users but also need
to discern the actual problems which need to be solved from the
specific mechanisms chosen to solve them.  Let's please keep the
discussions technical.  That's the best way to reach a viable
long-term solution which can benefit a lot wider audience in the long
term.  Even though that might not be the path of least immediate
resistance, I believe that google will be an eventual beneficiary too.

Thanks.

-- 
tejun
