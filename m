From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Date: Thu, 9 Oct 2014 09:59:24 -0400
Message-ID: <20141009135924.GE14387@htj.dyndns.org>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
 <20141008101828.GG10832@worktop.programming.kicks-ass.net>
 <54364564.3090305@linux.vnet.ibm.com>
 <20141009130611.GA14387@htj.dyndns.org>
 <20141009134758.GU10832@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vXZMrxRXw2Qr8jlTKuYP0D5J2dGl6HQ75KgXKQCqvGw=;
        b=1EAw7U8OqMn75HsMAHXrP8ppadBXY+V/hx4cY+avmGe7wu1BW6EOthXb8SCm75oLMY
         JCxXLc5iZdiTW0EcCe5h8v4yj/mdLWp12nGblOfrLmCw+lUaHzlRZI6tPzFu18m9b7Rd
         DebxRB/r56KMfAnTo1apd5E8RWfoVNxM972w1I5f73tuqkVLqoiMgz9eBPqLuxO1+gDe
         ++3lwgtzYJsjq7ipZTW6CE4rwmflMY9HkX4Voug/SO20JuDWYVHjcShuHHABT8CB607u
         o92RsiPtgPyo+zID1EnBes7N4FFoiHR9TrXRhpNtT+HfYwuVkcEa0Tr6XpeCaZaONb9R
         z6Zg==
Content-Disposition: inline
In-Reply-To: <20141009134758.GU10832-IIpfhp3q70z/8w/KjCw3T+5/BudmfyzbbVWyRVo5IupeoWH0uzbU5w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Peter.

On Thu, Oct 09, 2014 at 03:47:58PM +0200, Peter Zijlstra wrote:
> You do know we disagree on this :-)

Yeap. :)

...
> And while you all can try and pretend hotplug is a 'normal' and 'sane'
> operation with cpusets, the same failure more very much still exists
> with the regular affinity controls. So you can pretend all you want, but
> its a clear and utter fail.
> 
> You cannot give the kernel contradictory instructions and then pretend
> all is well and dandy.

But even if you view it that way, the current legacy implementation is
deficient to say the least.  It puts way too much trust in the
userland while not giving it mechanisms to deal with the situation.
It's not like the userland is an all-knowing entity and short of the
printk there's no way to detect such automatic migrations or to know
the previous state.  If this actually was seen as a configuration
failure, it would have made a lot more sense to just not run those
tasks unless they're SIGKILL'd.

This is all moot tho.  We can't change the behavior for the legacy
hierarchies and we can't auto-migrate for the unified hierarchy, so
there isn't much left to decide.

Thanks.

-- 
tejun
