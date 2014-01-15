From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Wed, 15 Jan 2014 13:23:10 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401151319580.10727@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com> <20131219144134.GH10855@dhcp22.suse.cz> <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org> <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com>
 <20140109144757.e95616b4280c049b22743a15@linux-foundation.org> <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com> <20140109161246.57ea590f00ea5b61fdbf5f11@linux-foundation.org> <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com>
 <20140110221432.GD6963@cmpxchg.org> <alpine.DEB.2.02.1401121404530.20999@chino.kir.corp.google.com> <20140115143449.GN8782@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=11Ygf2pTclHGUi3GvG7/IyuNG47EW7mpD7UijzVWN/w=;
        b=dm/EOPM4iNnZFil/UVaUx3igLiPp6o/Vgc8wlN/7NjuvHqyxhckG1cdeBzqo4SIXHf
         2IlwnM6d7p1nXVw1Jp5ws4j8qUpiDR2KMKpYosgKxkxPwMv+Ii35QHWGTDvYWaxhdWG+
         UT5YyRbRioZjluLX0TsjNSS2xFBJIwG/YkinZFNRtfZUz7yTvhWcg7VvCoMfgRxgPq6w
         yvKQHY+tiwUJRhY5rSx41Ktuw2rzJdS5FfGTaGpFPT6drxgJIm64oKhFqRxGQXQXoIhR
         Osjpwfp0ej1vVAWpTPtXLaQ4dCu2901zQzBsrX+OkY/LFsWcC37090aPvuFP4eFLoI/X
         sDfg==
In-Reply-To: <20140115143449.GN8782@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>

On Wed, 15 Jan 2014, Michal Hocko wrote:

> > > > > > It was acked-by Michal.
> > > 
> > > Michal acked it before we had most of the discussions and now he is
> > > proposing an alternate version of yours, a patch that you are even
> > > discussing with him concurrently in another thread.  To claim he is
> > > still backing your patch because of that initial ack is disingenuous.
> > > 
> > 
> > His patch depends on mine, Johannes.
> 
> Does it? Are we talking about the same patch here?
> https://lkml.org/lkml/2013/12/12/174
> 

I'm happy with either patch, I suggested doing the mem_cgroup_oom_notify() 
at the last minute only when actually killing a process because of your 
concern that the oom killer would still defer.  That was addressing your 
concern as an extension of my patch which avoids unconditionally giving 
current access to memory reserves without scanning or deferring anything.  
I would be happy with either approach, and so I don't see why removing my 
patch from -mm which yours is based on would be needed.

> Which depends on yours only to revert your part. I plan to repost it but
> that still doesn't mean it will get merged because Johannes still has
> some argumnets against. I would like to start the discussion again
> because now we are so deep in circles that it is hard to come up with a
> reasonable outcome. It is still hard to e.g. agree on an actual fix
> for a real problem https://lkml.org/lkml/2013/12/12/129.
> 

This is concerning because it's merged in -mm without being tested by Eric 
and is marked for stable while violating the stable kernel rules criteria.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
