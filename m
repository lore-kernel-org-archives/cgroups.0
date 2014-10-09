From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Date: Thu, 9 Oct 2014 09:06:11 -0400
Message-ID: <20141009130611.GA14387@htj.dyndns.org>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
 <20141008101828.GG10832@worktop.programming.kicks-ass.net>
 <54364564.3090305@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pAbBKIRkqtm/NctTxF/z2vrCDauM6OISMo/DWzKSS4A=;
        b=IGO7lqt+3/0yq5ukbMJjBdTB0cL5d6KBbd2H7pvzqItzRljVQuigg3E02mL3cI2ReC
         xpYNSe/YFvqtDKA5dSduUmOwippm59RmyZi2hS7r64mJMrUmpuFBffc9c0ZtzzLKcd4F
         KFaaZihg3UlwjEYPLQgcFoC5l6LBVMNrjPokbvFSrtlJkY4K6/NAZazL7kpeJ24QqLRJ
         eQj4+V479fUEMVT7b/FlgWIeE7YJKqrXEeOTRu/F+TLkY5iAQltvlO33gXTMUiJec4wK
         WRc+fckA93/fbDPB3M9pcBNuZ+EAdas6waBKCZ4HmwRfFqqLq50KWM+st+0AFBitwWxB
         O99Q==
Content-Disposition: inline
In-Reply-To: <54364564.3090305-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Oct 09, 2014 at 01:50:52PM +0530, Preeti U Murthy wrote:
> However what remains to be answered is that the V2 of cgroup design -
> the default hierarchy, tracks hotplug operations for children cgroups as
> well. Tejun, Li, will not the concerns that Peter raised above hold for
> the default hierarchy as well?

I don't think the legacy one is a good design.  Kernel shouldn't lose
configurations in an irreversible way and the legacy one is also
making random cpuset flips by migrating tasks upwards anyway.  In
terms of hotunplug behavior, the legacy and unified ones behave the
same.  The only difference is that the configuration is independent of
the current state and the configured behavior is restored when the
cpus come back.  The other side is that the legacy hierarchy behavior
simply can't be allowed when the hierarchy is shared among multiple
controllers as in the unified hierarchy.  It affects all other
controllers attached to the hierarchy.

That said, we can't change the behavior on the legacy one.  It's a
very userland visible behavior.  We simply can't change it, so
unfortunately you're stuck with it at least on the legacy hierarchy.

Thanks.

-- 
tejun
