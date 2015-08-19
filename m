From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Wed, 19 Aug 2015 05:23:40 +0200
Message-ID: <1439954620.3479.30.camel@gmail.com>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
	 <1438641689-14655-4-git-send-email-tj@kernel.org>
	 <20150804090711.GL25159@twins.programming.kicks-ass.net>
	 <20150804151017.GD17598@mtj.duckdns.org>
	 <20150805091036.GT25159@twins.programming.kicks-ass.net>
	 <20150805143132.GK17598@mtj.duckdns.org>
	 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
	 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
	 <20150818203117.GC15739@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=VzkyTyJ4XSWE2Ez036A2s9lQYk1jb3Z3eaBCnbIWqvk=;
        b=ohh5v5irb10DyHvJa1Wth6I2tFwPQvQbfBAhH+k7MVjuPjjzLH2MRbELGSo7s2T65+
         h463PThTwjxCuGkuqoU+BF0coFmniog2xtvjj7Zp+XugN8us3bKiGa+EarQLoGGyJqO9
         iZqH7MOUkMA3Wa4BCk39symWamZ+1Cf+ZDod97Lgqxdjvybm1J+7A5Tj+DGRIOgNuRn7
         ydQAzwFrJ1esi7Hgca8O/p2SoWI4zc5rooamwGOlUh+SxvTeyWbC1vZZSC+G+dcmXeS+
         /SK35xM7ECrFppUOCyiaRj+dy0SH+5dA1twS/gVYz6sI/Zo/PDPCAood9c5BALk66cnw
         YTDw==
In-Reply-To: <20150818203117.GC15739-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, 2015-08-18 at 13:31 -0700, Tejun Heo wrote:

> So, this is a trade-off we're consciously making.  If there are
> common-enough use cases which require jumping across different cgroup
> domains, we'll try to figure out a way to accomodate those but by
> default migration is a very cold and expensive path.

Hm.  I know of a big data outfit to which attach/detach performance was
important enough for them to have plucked an old experimental overhead
reduction hack (mine) off lkml, and shipped it.  It must have mattered a
LOT for them (not suicidal crash test dummies) to have done that.

	-Mike
