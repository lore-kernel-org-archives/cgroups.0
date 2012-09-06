From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Thu, 6 Sep 2012 13:46:42 -0700
Message-ID: <20120906204642.GN29092@google.com>
References: <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <1346835993.2600.9.camel@twins>
 <20120905093204.GL3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <1346839487.2600.24.camel@twins>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=SnKDjsc57H+KEoGDIYH1vgCyPSzX4lqgS6GVZ5jddWs=;
        b=Jn8dvmmuBcClsHUISmyuY8ICvkv6EQq4y3xOZOcZhdz+cMkd4uS5AFgZa3b/qfKhCo
         SDfF0doEpFxQOD7hS/wHyDcQFXvTRnZfpISEkOmNuYYwOKbKwceV7PsgGlA8Re0ueaQ6
         t8hL3gyPNOQZ/QQNhTllLDH9YWX/8wZArqDx7hj17VTpp+M97FXbDIiqkwTXQLgTtskG
         C15QisuZv6Ijlf0TD+A3rNaEiPA641/eSN0jp8NJ7vYpP9orolsX9Iw5xGirUsSqT+Wy
         6dvUZy9RbJ+b9gsf1aMGtOSymu8RHArAJemzy9wlcQMKV8unn41cW5W9QW2AQxU7UJAe
         BHAg==
Content-Disposition: inline
In-Reply-To: <1346839487.2600.24.camel@twins>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com, ben@decadent.org.uk, pjt@google.com, lennart@poettering.net, kay.sievers@vrfy.org, Dhaval Giani <dhaval.giani@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>

Hello,

cc'ing Dhaval and Frederic.  They were interested in the subject
before and Dhaval was pretty vocal about cpuacct having a separate
hierarchy (or at least granularity).

On Wed, Sep 05, 2012 at 12:04:47PM +0200, Peter Zijlstra wrote:
> > cpuacct is rather unique tho.  I think it's gonna be silly whether the
> > hierarchy is unified or not.
> > 
> > 1. If they always can live on the exact same hierarchy, there's no
> >    point in having the two separate.  Just merge them.
> > 
> > 2. If they need differing levels of granularity, they either need to
> >    do it completely separately as they do now or have some form of
> >    dynamic optimization if absolutely necesary.
> > 
> > So, I think that choice is rather separate from other issues.  If
> > cpuacct is gonna be kept, I'd just keep it separate and warn that it
> > incurs extra overhead for the current users if for nothing else.
> > Otherwise, kill it or merge it into cpu.
> 
> Quite, hence my 'proposal' to remove cpuacct.
> 
> There was some whining last time Glauber proposed this, but the one
> whining never convinced and has gone away from Linux, so lets just do
> this.
> 
> Lets make cpuacct print a deprecated msg to dmesg for a few releases and
> make cpu do all this.

I like it.  Currently cpuacct is the only problematic one in this
regard (cpuset to a much lesser extent) and it would be great to make
it go away.

Dhaval, Frederic, Paul, if you guys object, please voice your
opinions.

> The co-mounting stuff would have been nice for cpusets as well, knowing
> all your tasks are affine to a subset of cpus allows for a few
> optimizations (smaller cpumask iterations), but I guess we'll have to do
> that dynamically, we'll just have to see how ugly that is.

Forced co-mounting sounds rather silly to me.  If the two are always
gonna be co-mounted, why not just merge them and switch the
functionality depending on configuration?  I'm fairly sure the code
would be simpler that way.

If cpuset and cpu being separate is important enough && the overhead
of doing things separately for cpuset isn't too high, I wouldn't
bother too much with dynamic optimization but that's your call.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
