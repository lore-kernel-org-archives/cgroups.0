From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 8/8] cgroup: implement the PIDs subsystem
Date: Thu, 28 May 2015 16:33:12 -0400
Message-ID: <20150528203312.GA27479@htj.duckdns.org>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
 <1431960667-26593-9-git-send-email-cyphar@cyphar.com>
 <20150519080055.GA3644@twins.programming.kicks-ass.net>
 <CAOviyaij2bays4aYQ_5HcopcBOfj4M_gKE7oQ_FsV38skK6vWA@mail.gmail.com>
 <20150519105631.GH19282@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XD8/OACCsJJdCaO+WAfH/iz3gJIaoQjvTJZEgkYLQ38=;
        b=js9WPKWnmHsb0k+hNdDEbB2xR7mXDxG2+uFUsEm/gOrWD8B4ar3wX/ZZj6IGchr1uU
         biyGOXU/KHW6sSD/IMqBCiL6wqG2MWobXKiLAG0UCoW3YlRy5BJDNvHKgui4yJ56tyky
         QgPIcGzcE8MkTDRangosGO/0ELRemDwXTj7qHMLJ9IRBHD4A0x8v86VsbWxPIZq1T1kk
         JxnSEn+/27pCWhA3B1Ubtq94+AP+t8SNXG7nkthIno/U6AaYFJQyU/MivwY41hXsPVkN
         Wc6xS/d8A0GWsaYMOyRJQP+LdaFUMtB2g7nqzMm9dHAMIgTcvstCCBn+6W8cAZ5Y8oxg
         QCbw==
Content-Disposition: inline
In-Reply-To: <20150519105631.GH19282-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Hello, sorry about the delay.

On Tue, May 19, 2015 at 12:56:31PM +0200, Peter Zijlstra wrote:
> > This has been discussed before. Organisational operations (i.e.
> > attaching to a cgroup) are not to be blocked by a cgroup controller in
> > the unified hierarchy. 
> 
> That's utterly insane. As argued at length in threads like:
> 
>   lkml.kernel.org/r/alpine.DEB.2.11.1505061100040.4225@nanos
> 
> This breaks fundamental control rules and makes life for a number of
> controllers impossible.

I didn't chase that dicussion because it was rather off-topic for
scheduler.

There are several classes of distribution schemes that cgroups deal
with.

A. Ratio-based.  Usually used to distributed resources which are
   replenished over time.  IO time, CPU cycles and so on.  This
   primarily doesn't deal with persistent state.

B. Limiting over-committable resources.  This applies to persistent
   resources like memory but also to transient ones like IO bandwidth
   and iops.  These all operate by limiting how much resources are
   newly given out and thus their neutral state is the overcommitted
   no-limit state.

C. Non-over-committable "hard" resources.  Currently, scheduler RT
   slices are the only one.  These actually should be distributed by
   carving out a finite whole and thus its limits can't be
   over-committed.  They have to behave as allocators rather than
   limiters.

Most persistent resources fall in the B category and we have a very
clear precedences in dealing with configurations of these limits.
Just think about the NPROC ulimit or quota.  They all operate by
suppressing distribution of new resources and allow new limit
configuration to be lower than the current consumption.

There's a clear reason for this.  it allows closing the race window
between configuration change and increasing resource consumption in a
very simple way - lowering the limit and checking the existing usage.

While what Thomas suggested - building a whole new transaction model
on top - can also close the race window.  This breaks from the
convention for no good reason.  It doesn't provide anything beyond
what's what's possible with the established model and it's outright
silly to have NPROC controller to behave so differently from the
existing mechanism which controls exactly the same resource.

> Also, I'll NAK each and every patch that will attempt to remove failing
> can_attach from the cgroup core as it will fundamentally break some
> scheduler controllers.

I was struggling with C above because it was just a single resource
type which belongs to that category but given that cgroups have to
support it ->can_attach() will have to be able to fail for those
resource types, but only for that resource type.

> So please use it, it doesn't make any bloody sense to 'control' the
> number of PIDs but then allow it to overrun the set point.

Again, it's not about ->can_attach() can fail or not in terms of
implementation at all.  It's about following consistent resource
distribution model.  Please don't conflate different resource types.

Thanks.

-- 
tejun
