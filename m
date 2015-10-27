From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 27 Oct 2015 06:42:11 +0100
Message-ID: <1445924531.2909.79.camel@gmail.com>
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
	 <20151027031656.GA11962@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=3c146DVxIbhTM8oY3yH7md0PkffmSDgGqkZxig1bWYw=;
        b=y2w6f6oh+a6U0qtZJDBtiQu4sECCUJWmkb20IOD1Q51qESKVXKzLXwz/J4QVEfNF/S
         gXjfrCIx+HqzMmkdZRYGr2UmKbh/UhHCnq9ROQoOrpveH0x+rsUzYD3OmHmW8c6pFjtc
         xhWtRWMF/0QQZfdphyqCfv7IU5lBYb9B5FFFue5hz4V+UxyDXZ3Py9EAr473buY5N0Hu
         SOy6WqZz/S4MauJM2JhSPizm7kO0m40EF0lWzTuYt8lwhdAoatnOIZRfrKU264992F4X
         avRNXLPlzqm2pwizq3VAQJmkO8Hk7ee06owj8npW5pFQERUz+dj3uwH3gY5Bw0WmySvx
         76fA==
In-Reply-To: <20151027031656.GA11962-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, 2015-10-27 at 12:16 +0900, Tejun Heo wrote:
> Hello, Mike.
> 
> On Sun, Oct 25, 2015 at 04:43:33AM +0100, Mike Galbraith wrote:
> > I don't think it's weird, it's just a thought wrt where pigeon holing
> > could lead:  If you filter out current users who do so in a manner you
> > consider to be in some way odd, when all the filtering is done, you may
> > find that you've filtered out the vast majority of current deployment.
> 
> I think you misunderstood what I wrote.  It's not about excluding
> existing odd use cases.  It's about examining the usages and
> extracting the required capabilities and building an interface which
> is well defined and blends well with the rest of programming interface
> provided by the kernel so that those can be achieved in a saner way.

Sure, sounds fine, I just fervently hope that the below is foul swamp
gas having nothing what so ever to do with your definition of "saner".

http://www.linuxfoundation.org/news-media/blogs/browse/2013/08/all-about-linux-kernel-cgroup%E2%80%99s-redesign

http://www.freedesktop.org/wiki/Software/systemd/ControlGroupInterface/

I'm not into begging.  I really don't want to have to ask anyone to
pretty please do for me what I can currently do all by my little self
without having to give a rats ass less whether what I want to do fits in
the world view of this or that obnoxious little control freak.

	-Mike
