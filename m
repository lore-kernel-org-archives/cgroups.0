From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.14] cgroup, sched: cgroup2 basic resource
 accounting
Date: Mon, 25 Sep 2017 08:07:45 -0700
Message-ID: <20170925150745.GJ828415@devbig577.frc2.facebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170922180530.GG828415@devbig577.frc2.facebook.com>
 <20170923133731.uq5qekjypndpjv2l@hirez.programming.kicks-ass.net>
 <20170923134402.GI828415@devbig577.frc2.facebook.com>
 <20170925072718.zajtw4fvubgqtp5r@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F/DyjgrCyY4Ne4MPz3MU1UYWfEbJSPSsyJnYeH7kQPE=;
        b=Nz8cVCDu6qwMUx9NPeQQNdZ+uLzr8N2Hk3H/llBsSOEQvcdh4GTAoKZyj6PUpD2epB
         4duDRg/3J4GyKuIESXlljCYNt5U928KNUmL07rX+IUCsnKSNIUPV91JnQolsM9BlSFxV
         rMzf+qwZBZIIrlJQ5y+4y+i5yLpApRDW6+J3mShanhUDgBx7zVeRUyqbCay05DWlObp7
         XWGGaeoJCiZHh881bPNGEtCak9x7WXjr2zqo0LCSfavH6u8q2C16EOpN8x+orftUg95Y
         MWDr9xfI0TCLEQcnFVdOrmpZdGNMQUGkfKUZt16hAQTnTtyn+NMCEOTj7nD44NNOY0Rh
         Hx7w==
Content-Disposition: inline
In-Reply-To: <20170925072718.zajtw4fvubgqtp5r-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Hello,

On Mon, Sep 25, 2017 at 09:27:18AM +0200, Peter Zijlstra wrote:
> On Sat, Sep 23, 2017 at 06:44:02AM -0700, Tejun Heo wrote:
> > Hello, Peter.
> > 
> > On Sat, Sep 23, 2017 at 03:37:31PM +0200, Peter Zijlstra wrote:
> > > On Fri, Sep 22, 2017 at 11:05:30AM -0700, Tejun Heo wrote:
> > > > Peter, ping?
> > > 
> > > Humm,. So I think I was good, but I was under the impression you'd send
> > > a new version better explaining the need/design of that iteration stuff.
> > > Could be I lost the plot somehow.
> > 
> > The updated version was posted quite a while ago.
> > 
> >   http://lkml.kernel.org/r/20170829174325.GS491396-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org
> 
> 
> Oh that's in the same thread, wasn't expecting that. Look ok I suppose.
>
> Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Applying to cgroup/for-4.15.

Thanks.

-- 
tejun
