From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 27 Oct 2015 12:16:56 +0900
Message-ID: <20151027031656.GA11962@mtj.duckdns.org>
References: <20150825210234.GE26785@mtj.duckdns.org>
 <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
 <20150912144007.GA8942@htj.duckdns.org>
 <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
 <20151001184629.GB26498@mtj.duckdns.org>
 <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
 <20151023222110.GA4390@mtj.duckdns.org>
 <1445661367.3218.62.camel@gmail.com>
 <20151025021829.GA15471@mtj.duckdns.org>
 <1445744613.3180.60.camel@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pBFk2kgxE64pFElyUPsEG1ugrf04tQ/ZHBcJPzS3Ru0=;
        b=L6f4feqe8kirtGxGXPB0RwZ3g7Rd2L7eZ0c06Rck2R2ZiraNibbl4uq6lqz1UCfx3A
         MFwoFqNPYCwZtLY9FYeecNGf6QvBQox6lJzD4TKCw0udDVrPUjXExOktyPjrjH7AwjNF
         VMYDEN+IiYR0hENDKziRkwPbdiEJdqzTuIQA/tH+JJ62VorQPw+sbaJJJaj9X0e2wc+G
         T7AQNJFPZyrtIXNMn7PojXMZzMD/GXTecTSCGgzfdudqMOiUo43DashNBKPVVrrKsOSB
         E3ts2RAOiiVCA57IWpeovCGQfl68UJdlRVatg9j0r0tMnXxvqhrfTcOT6GTfR4ojnHUA
         5BLQ==
Content-Disposition: inline
In-Reply-To: <1445744613.3180.60.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Mike.

On Sun, Oct 25, 2015 at 04:43:33AM +0100, Mike Galbraith wrote:
> I don't think it's weird, it's just a thought wrt where pigeon holing
> could lead:  If you filter out current users who do so in a manner you
> consider to be in some way odd, when all the filtering is done, you may
> find that you've filtered out the vast majority of current deployment.

I think you misunderstood what I wrote.  It's not about excluding
existing odd use cases.  It's about examining the usages and
extracting the required capabilities and building an interface which
is well defined and blends well with the rest of programming interface
provided by the kernel so that those can be achieved in a saner way.

If doing acrobatics with the current interface is necessary to acheive
certain capabilities, we need to come up with a better interface for
those.  If fringe usages can be satisfied using better constructs, we
should implement that and encourage transition to a better mechanism.

> I'm not at all sure of this, but I suspect that SUSE's gigabuck size
> cgroup power user will land in the same "fringe" pigeon hole.  If so,
> that would be another sizeable dent in volume.
> 
> My point is that these power users likely _are_ your general audience.

Sure, that doesn't mean we shouldn't scrutinize the interface we
implement to support those users.  Also, cgroup also definitely had
some negative spiral effect where eccentric mechanisms and interfaces
discouraged general wider usages fortifying the argument that "we're
the main users" which in turn fed back to even weirder things being
added.  Everybody including the "heavy" users suffers from such
failures in the long term.

We sure want to support all the valid use cases from heavy users in a
reasonable way but that doesn't mean we say yes to everything.

> Sure, it was just a thought wrt "actively filter those out" and who all
> "those" may end up being.

I hope what I meant is clearer now.

Thanks.

-- 
tejun
