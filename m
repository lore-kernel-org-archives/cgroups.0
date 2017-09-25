From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.14] cgroup, sched: cgroup2 basic resource
 accounting
Date: Mon, 25 Sep 2017 09:27:18 +0200
Message-ID: <20170925072718.zajtw4fvubgqtp5r@hirez.programming.kicks-ass.net>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170922180530.GG828415@devbig577.frc2.facebook.com>
 <20170923133731.uq5qekjypndpjv2l@hirez.programming.kicks-ass.net>
 <20170923134402.GI828415@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rg5VoxpXcOparhPHK5jRMF6PL1BqqztSu75MbIGn7DY=; b=ZO9gFMg8gc+oU9UEPa69CrTod
        68ThCkdc0ZHbEktE6QnqVntBiddjQtqKVuRb1elIvi6k9/dj87s5gohBZZs0l+xQ2buKI0iRtie8W
        7FX4mrDsH6XpZaUSHY7qpLdoGbjWvXiH4icrrLVfwXw/u2u2X76SJeclPCpqLjXUNQuiI8HtrVaU1
        eVGdlZU6GPN96JRavRHN5SFN3GGxqn0Ti00S0NDtwE+aUu+nX10J+5JTFDRafYgowfdBSvjvggg7Y
        q9maL3SC+bZAbVjv0vqGcKEyTxwMFqreaOxB2pjAyNWp3shrASD78Xf5Id4ocv4D9maW+/T77cnNu
      
Content-Disposition: inline
In-Reply-To: <20170923134402.GI828415-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Sat, Sep 23, 2017 at 06:44:02AM -0700, Tejun Heo wrote:
> Hello, Peter.
> 
> On Sat, Sep 23, 2017 at 03:37:31PM +0200, Peter Zijlstra wrote:
> > On Fri, Sep 22, 2017 at 11:05:30AM -0700, Tejun Heo wrote:
> > > Peter, ping?
> > 
> > Humm,. So I think I was good, but I was under the impression you'd send
> > a new version better explaining the need/design of that iteration stuff.
> > Could be I lost the plot somehow.
> 
> The updated version was posted quite a while ago.
> 
>   http://lkml.kernel.org/r/20170829174325.GS491396-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org


Oh that's in the same thread, wasn't expecting that. Look ok I suppose.

Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
