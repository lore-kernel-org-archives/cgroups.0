From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 2/2] memcg: do not sleep on OOM waitqueue with full charge
 context
Date: Thu, 13 Jun 2013 13:34:46 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1306131330170.8686@chino.kir.corp.google.com>
References: <20130606173355.GB27226@cmpxchg.org> <alpine.DEB.2.02.1306061308320.9493@chino.kir.corp.google.com> <20130606215425.GM15721@cmpxchg.org> <alpine.DEB.2.02.1306061507330.15503@chino.kir.corp.google.com> <20130607000222.GT15576@cmpxchg.org>
 <alpine.DEB.2.02.1306111454030.4803@chino.kir.corp.google.com> <20130612082817.GA6706@dhcp22.suse.cz> <alpine.DEB.2.02.1306121309500.23348@chino.kir.corp.google.com> <20130612203705.GB17282@dhcp22.suse.cz> <alpine.DEB.2.02.1306121343500.24902@chino.kir.corp.google.com>
 <20130613134826.GE23070@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=XcJXnXPLcse5ucWhuyB1Z3zRGCE1TUf79zFRG3xcI/c=;
        b=DBkN3DSKHff43KfggW5jppb3YGFxRomiBVeTplrn3neH1yvyGjRDlCcKLWNhzpiteb
         KmEnYQOsc5ZcsBgBHfL2a5q2wxb7mu1Aj1TtvM3Wa+duAu9Q/quygxe+4XGjVGhzGPzN
         LEquQTkGNw837aG2ClptZeODm3W6zFfpdZRk5z+a88lmCPzaiKQ6o2oyGrAS8NyJXL2D
         x0DhsTtTpHHc6BV+wIfd4kX7P2n7HKOAAGT2v3zwQXSeEOro3RaBeh/bLe6nkzSk0TnK
         ZyQIQjaI2OUAZ1GHZ6IP6YEXXKcnealFHwDbUP6cKx4nowIL28du6Lmyk9wk77IXLmp7
         ynLg==
In-Reply-To: <20130613134826.GE23070@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013, Michal Hocko wrote:

> > Right now it appears that that number of users is 0 and we're talking 
> > about a problem that was reported in 3.2 that was released a year and a 
> > half ago.  The rules of inclusion in stable also prohibit such a change 
> > from being backported, specifically "It must fix a real bug that bothers 
> > people (not a, "This could be a problem..." type thing)".
> 
> As you can see there is an user seeing this in 3.2. The bug is _real_ and
> I do not see what you are objecting against. Do you really think that
> sitting on a time bomb is preferred more?
> 

Nobody has reported the problem in seven months.  You're patching a kernel 
that's 18 months old.  Your "user" hasn't even bothered to respond to your 
backport.  This isn't a timebomb.

> > We have deployed memcg on a very large number of machines and I can run a 
> > query over all software watchdog timeouts that have occurred by 
> > deadlocking on i_mutex during memcg oom.  It returns 0 results.
> 
> Do you capture /prc/<pid>/stack for each of them to find that your
> deadlock (and you have reported that they happen) was in fact caused by
> a locking issue? These kind of deadlocks might got unnoticed especially
> when the oom is handled by userspace by increasing the limit (my mmecg
> is stuck and increasing the limit a bit always helped).
> 

We dump stack traces for every thread on the system to the kernel log for 
a software watchdog timeout and capture it over the network for searching 
later.  We have not experienced any deadlock that even remotely resembles 
the stack traces in the chnagelog.  We do not reproduce this issue.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
