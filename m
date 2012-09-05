From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 5 Sep 2012 02:45:20 -0700
Message-ID: <20120905094520.GM3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <1346835993.2600.9.camel@twins>
 <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50471782.6060800@parallels.com>
 <1346837209.2600.14.camel@twins>
 <50471C0C.7050600@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=NOXQWR2ZAljSZJAUzeMtlvYH4JRMUDl8zfnylhDA+Sw=;
        b=pKc9Mdmr7YMDxXqao+VVHEqtjttcZ6sjijdCR1Kt/AmPLmXrwjbpT9KCbZVW7ZkQ+I
         42nBrUQ8/DAtezvJTfZ5X4KMIW226u6Jk3zDmHrCMWlA+X3AK9FcoYaWdHsy1J6gnNRU
         Owglc2FaRtlDYPyQ0hifAKnFgAcc1tQLAnCPkFfqY2KEJlTRkHgdZH6WYj+puGscuWkP
         DsfjQeGXSbx7PnCsbhLh2d562HGOBTFXvu2MaVep7ocfxUCbPuNgoL9fYO4g1jrMjTV8
         frI1ma0dSIzWHCYrXGbOioER1nOipj3PHlAYQDUPUZGYD1O5vOcutgUQ4InObWumDQQm
         kBQw==
Content-Disposition: inline
In-Reply-To: <50471C0C.7050600@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com, ben@decadent.org.uk, pjt@google.com, lennart@poettering.net, kay.sievers@vrfy.org

Hello,

On Wed, Sep 05, 2012 at 01:31:56PM +0400, Glauber Costa wrote:
> > I simply don't want to have to do two (or more) hierarchy walks for
> > accounting on every schedule event, all that pointer chasing is stupidly
> > expensive.
> 
> You wouldn't have to do more than one hierarchy walks for that. What
> Tejun seems to want, is the ability to not have a particular controller
> at some point in the tree. But if they exist, they are always together.

Nope, as I wrote in the other reply, for cpu and cpuacct, either just
merge them or kill cpuacct if you want to avoid silliness from walking
multiple times.  Does cpuset cause problem in this regard too?  Or can
it be handled similarly to other controllers?

I think the confusion here is that we're talking about two different
issues.  As for cpuacct, I can see why strict co-mounting can be
attractive but then again if that's gonna be required, there's no
point in having them separate, right?  If that's the way you want it,
just trigger WARN_ON() if cpu and cpuacct aren't co-mounted and later
on kill cpuacct.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
