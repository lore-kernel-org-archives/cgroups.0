From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 27 Oct 2015 15:00:27 +0900
Message-ID: <20151027060027.GA2888@mtj.duckdns.org>
References: <20151001184629.GB26498@mtj.duckdns.org>
 <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
 <20151023222110.GA4390@mtj.duckdns.org>
 <1445661367.3218.62.camel@gmail.com>
 <20151025021829.GA15471@mtj.duckdns.org>
 <1445744613.3180.60.camel@gmail.com>
 <20151027031656.GA11962@mtj.duckdns.org>
 <1445924531.2909.79.camel@gmail.com>
 <20151027054634.GA16310@mtj.duckdns.org>
 <1445925402.2909.86.camel@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GsQZgsUPdtoGK5zBfInyY+sP1uOP4/QP1gP9nXlOawk=;
        b=0oni5iGqRF3o8RjdBXy8XXziU4E6NgU3jRozBM2NjzNNkMfEMpZFPQ8ROCqrlLe2ei
         JtODcBxvuJePCzJU8WYZTvp5AwG54WOKJAN4U2mi4A7vgX4upfVN1zdOg8oxhG98gdYE
         D8wYa82L5IvrCYg5M/mP9dAoTarDQ2ke7RGjxKGkAUdALL/ULZ3YbUnf7UOUMX7W70Po
         mdfTHy/8q5he+11CMrsn6yw5m9UrbC4MHk0SxFc2RIsdpfLWWYjIBpE0xd/kEoMDewO6
         Y/5LahvRTEsx+4tEfY2/vDk8KpxORGatgqdyHdUJlQMPyeysSg9V9fvRRmB89cDP9PEg
         DRKw==
Content-Disposition: inline
In-Reply-To: <1445925402.2909.86.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Oct 27, 2015 at 06:56:42AM +0100, Mike Galbraith wrote:
> > Well, if you think certain things are being missed, please speak up.
> > Not in some media campaign way but with technical reasoning and
> > justifications.
> 
> Inserting a middle-man is extremely unlikely to improve performance.

I'm not following you at all.  Technical reasoning and justifications
is a middle-man?

I don't think anything productive is likely to come out of this
conversation.  Let's just end this sub-thread.

Thanks.

-- 
tejun
