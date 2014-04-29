From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Protection against container fork bombs [WAS: Re: memcg with
 kmem limit doesn't recover after disk i/o causes limit to be hit]
Date: Tue, 29 Apr 2014 21:03:06 +0200
Message-ID: <20140429190306.GC25609@dhcp22.suse.cz>
References: <20140429130353.GA27354@ubuntumail>
 <20140429154345.GH15058@dhcp22.suse.cz>
 <CAO_RewYZDGLBAKit4CudTbqVk+zfDRX8kP0W6Zz90xJh7abM9Q@mail.gmail.com>
 <20140429165114.GE6129@localhost.localdomain>
 <CAO_Rewa20dneL8e3T4UPnu2Dkv28KTgFJR9_YSmRBKp-_yqewg@mail.gmail.com>
 <20140429170639.GA25609@dhcp22.suse.cz>
 <20140429133039.162d9dd7@oracle.com>
 <20140429180927.GB29606@alpha.arachsys.com>
 <20140429182742.GB25609@dhcp22.suse.cz>
 <20140429183928.GF29606@alpha.arachsys.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zpedHS9a9rX3VrTRhZdYPjvNcI24hdwexyYFNwihZGs=;
        b=b6LIFAC2EWwLE/sHrZrcuPAkQWbZLUxZu58Ds6xX+Uodr2tTjWJzlay9sq5NZdLEDo
         eqLbatVo10GScSpCM57Y9h57RICUgLs0rVDDG6rx9r4fjGr9XrW1bNFp4p2YAaw7G/ZL
         u6FS6yfqpPEsFSkL8yKlgzTC0JEIgHyQc5ECuPR6g4l4xnDakM6qG8LHMwkzVHDr3pSB
         eVf7R0IlAMW402a7wbl5s0tjfPnyqSfnFIndbivBUznIYji7KbJ00ePabLurYpWYJ5dm
         QgQtdurM+6tsuX+CwvwYXwfl39++uzcOR2vX/wTx03HJgLk3l58zx/kcLH9nmjZm5084
         4ufg==
Content-Disposition: inline
In-Reply-To: <20140429183928.GF29606@alpha.arachsys.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Richard Davies <richard@arachsys.com>
Cc: Dwight Engen <dwight.engen@oracle.com>, Tim Hockin <thockin@google.com>, Vladimir Davydov <vdavydov@parallels.com>, David Rientjes <rientjes@google.com>, Marian Marinov <mm@yuhu.biz>, Max Kellermann <mk@cm4all.com>, Tim Hockin <thockin@hockin.org>, Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.linux-foundation.org, Serge Hallyn <serge.hallyn@ubuntu.com>, Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org, William Dauchy <wdauchy@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Daniel Walsh <dwalsh@redhat.com>

On Tue 29-04-14 19:39:28, Richard Davies wrote:
> Michal Hocko wrote:
> > Richard Davies wrote:
> > > Dwight Engen wrote:
> > > > Is there a plan to separately account/limit stack pages vs kmem in
> > > > general? Richard would have to verify, but I suspect kmem is not
> > > > currently viable as a process limiter for him because
> > > > icache/dcache/stack is all accounted together.
> > >
> > > Certainly I would like to be able to limit container fork-bombs without
> > > limiting the amount of disk IO caching for processes in those containers.
> > >
> > > In my testing with of kmem limits, I needed a limit of 256MB or lower to
> > > catch fork bombs early enough. I would definitely like more than 256MB of
> > > disk caching.
> > >
> > > So if we go the "working kmem" route, I would like to be able to specify a
> > > limit excluding disk cache.
> >
> > Page cache (which is what you mean by disk cache probably) is a
> > userspace accounted memory with the memory cgroup controller. And you
> > do not have to limit that one.
> 
> OK, that's helpful - thanks.
> 
> As an aside, with the normal (non-kmem) cgroup controller, is there a way
> for me to exclude page cache and only limit the equivalent of the rss line
> in memory.stat?

No

> e.g. say I have a 256GB physical machine, running 200 containers, each with
> 1GB normal-mem limit (for running software) and 256MB kmem limit (to stop
> fork-bombs).
> 
> The physical disk IO bandwidth is a shared resource between all the
> containers, so ideally I would like the kernel to used the 56GB of RAM as
> shared page cache however it best reduces physical IOPs, rather than having
> a per-container limit.

Then do not use any memory.limit_in_bytes and if there is a memory
pressure then the global reclaim will shrink all the containers
proportionally and the page cache will be the #1 target for the
reclaim (but we are getting off-topic here I am afraid).
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
