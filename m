From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Thu, 20 Aug 2015 10:47:26 +0200
Message-ID: <1440060446.3515.117.camel@gmail.com>
References: <20150804090711.GL25159@twins.programming.kicks-ass.net>
	 <20150804151017.GD17598@mtj.duckdns.org>
	 <20150805091036.GT25159@twins.programming.kicks-ass.net>
	 <20150805143132.GK17598@mtj.duckdns.org>
	 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
	 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
	 <20150818203117.GC15739@mtj.duckdns.org>
	 <1439954620.3479.30.camel@gmail.com>
	 <20150819164113.GB20716@mtj.duckdns.org>
	 <1440043259.3515.84.camel@gmail.com>
	 <20150820075232.GA27917@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=/vllEpGW9lav3Fat2s3Q6lQuDTULz51/H50y7rpb64A=;
        b=LGGUsFbcsUV65SLORLrdhgFMThMq6bgg31Am3WJqYU/DJ031BiQPb+PyKi4IzdSgQk
         ZLGNLbNBWPLpgO+WWExFEhPDaPZCJOIiZZkn2Dapf1AWT5QJmkLm5j/Rxex37c47M9je
         2fIFniWXNDqH4OtC/BwV74G5lln50jc6IV0mIXUtxhtDB2zkQO7qdVHOJa7YuiWCSncZ
         PccWNy02oe53SY6swWeQM+z2RwSKmYL67L+rfqnCZ3b0Z1/tnGoCYrsZLe3FDE1amNLF
         WgmSvS5Y06rXev/YyqaPEm3g2RKyrJX3LOl2ZD8aOrKwDuv4mAkkPBBFg4fTTaqTsHPV
         H53w==
In-Reply-To: <20150820075232.GA27917-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, 2015-08-20 at 00:52 -0700, Tejun Heo wrote:

> Hmmm... I think this discussion got pretty badly derailed at this
> point.  If I'm not mistaken, you're talking about tens or a few
> hundred millisecs of latency per migration which no longer exists and
> won't ever come back and the discussion originally was about something
> like migrating thread for issuing several IO requests versus bouncing
> that to a dedicated issuer thread in that domain.

Yes, ms latencies ever coming back is the concern, whether that be due
to something akin to the old synchronize_rcu() horror.. or some handoff
of whatever to whomever.

	-Mike
