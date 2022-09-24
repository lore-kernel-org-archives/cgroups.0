From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 00/20] Add Cgroup support for SGX EPC memory
Date: Fri, 23 Sep 2022 14:09:38 -1000
Message-ID: <Yy5KwnRTbFjmKE9X@slm.duckdns.org>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
 <YyyeSVSk/lWdo/W4@slm.duckdns.org>
 <4b8605533e5deade739249bfb341ab9c06d56a1e.camel@linux.intel.com>
 <YyyykUJQtYbPVctn@slm.duckdns.org>
 <7ff6d114-a6cc-e3c5-5edb-8ac0e527d8a9@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=Wy0ZAB6jF2RLgatMO2ipKaVR//CFOKWia2M42iS8znI=;
        b=W/98zSk0vPJr1V+ETrctpZlkYfX/A44q9wVPlqgd55ybOj8kIlIFNDYejFhI77ChF3
         O3Bbe91Wnb0tZqQMGQIPhd0Sa3s0DUL4r/5ZQPC+rXJjDO9Q5nqyYRSNcwiPQxzwFuEY
         Y2UuAYQ07iS94QLQT0m8YE2JMfgT9Ixf9svmaHi/BKPC3+amGR0ST/KP5QBXQ20tGhgg
         la5VjOzrJ9yhXwgUHmwFijNtjo8+kN7f+GbnlgbTjbutwchsa+aOSyOnhP/9eu5szQDr
         nI4TiX2A5FzM8+Q7Ayibh1GD/sldGc2vCqzYBeU8x53tQncGxvt9drOp6QBDAr9wVvnS
         rqtQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7ff6d114-a6cc-e3c5-5edb-8ac0e527d8a9-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Hello,

On Thu, Sep 22, 2022 at 02:03:52PM -0700, Dave Hansen wrote:
> On 9/22/22 12:08, Tejun Heo wrote:
> > Can you please give more concrete examples? I'd love to hear how the SGX EPC
> > memory is typically used in what amounts and what's the performance
> > implications when they get reclaimed and so on. ie. Please describe a
> > realistic usage scenario of contention with sufficient details on how the
> > system is set up, what the applications are using the SGX EPC memory for and
> > how much, how the contention on memory affects the users and so on.
> 
> One wrinkle is that the apps that use SGX EPC memory are *normal* apps.
>  There are frameworks that some folks are very excited about that allow
> you to run mostly unmodified app stacks inside SGX.  For example:
> 
> 	https://github.com/gramineproject/graphene
> 
> In fact, Gramine users are the troublesome ones for overcommit.  Most
> explicitly-written SGX applications are quite austere in their SGX
> memory use; they're probably never going to see overcommit.  These
> Gramine-wrapped apps are (relative) pigs.  They've been the ones finding
> bugs in the existing SGX overcommit code.
> 
> So, where does all the SGX memory go?  It's the usual suspects:
> memcached and redis. ;)

Hey, so, I'm a bit weary that this doesn't seem to have a strong demand at
this point. When there's clear shared demand, I usually hear from multiple
parties about their use cases and the practical problems they're trying to
solve and so on. This, at least to me, seems primarily driven by producers
than consumers.

There's nothing wrong with projecting future usages and jumping ahead the
curve but there's a balance to hit, and going full-on memcg-style controller
with three control knobs seems to be jumping the gun and may create
commitments which we end up looking back on with a bit of regret.

Given that, how about this? We can easily add the functionality of .max
through the misc controller. Add a new key there, trycharge when allocating
new memory, if fails, try reclaim and then fail allocation if reclaim fails
hard enough. I belive that should give at least a reasonable place to start
especially given that memcg only had limits with similar semantics for quite
a while at the beginning.

That way, we avoid creating a big interface commitments while providing a
feature which should be able to serve and test out the immediate usecases.
If, for some reason, many of us end up running hefty applications in SGX, we
can revisit the issue and build up something more complete with provisions
for backward compatibility.

Thanks.

-- 
tejun
