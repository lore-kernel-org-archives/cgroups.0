From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v2] mm: introduce memory.min
Date: Wed, 2 May 2018 13:52:39 +0100
Message-ID: <20180502125234.GA4025@castle.DHCP.thefacebook.com>
References: <20180423123610.27988-1-guro@fb.com>
 <20180502123040.GA16060@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=F+5eLG6AfmLirVptTAP9VODQZCxDJTmo33cnnDRU3B4=;
 b=bf9Wlr7umuPw36Zdxb011XUAWb54uUwlV1zPTMwddddfn/4nbFAccnAqgXDE7gh1XzJi
 +Zhzd4pmB5jOWtxr30crURUyS+GX5zJNRRe68kAl3jhSJdwQk4uaTVjT4ZGPt6GKOYta
 2Un9ahKyuu0CT0AZ6xLXr2gdP8lUsEJGlyM= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=F+5eLG6AfmLirVptTAP9VODQZCxDJTmo33cnnDRU3B4=;
 b=ZDgUIwMo9r9ctMlJ++jyQrhO5YpWaoq2irWoFzjCXX7dxxJ3dEt47k8K/WvIjWwR+2jVSgLp8GDSY4D3XIrF3xs/X58/kMjlDfBdHNhGI87+T3zu4+UXRDowMU61GuYWjypjxTXHaXld0txCS2dryK77OQFgkzF2UhBvyxRAYZA=
Content-Disposition: inline
In-Reply-To: <20180502123040.GA16060@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>

On Wed, May 02, 2018 at 08:30:40AM -0400, Johannes Weiner wrote:
> On Mon, Apr 23, 2018 at 01:36:10PM +0100, Roman Gushchin wrote:
> > @@ -59,6 +59,12 @@ enum memcg_memory_event {
> >  	MEMCG_NR_MEMORY_EVENTS,
> >  };
> >  
> > +enum mem_cgroup_protection {
> > +	MEMCG_PROT_NONE,
> > +	MEMCG_PROT_LOW,
> > +	MEMCG_PROT_HIGH,
> 
> Ha, HIGH doesn't make much sense, but I went back and it's indeed what
> I suggested. Must have been a brainfart. This should be
> 
> MEMCG_PROT_NONE,
> MEMCG_PROT_LOW,
> MEMCG_PROT_MIN
> 
> right? To indicate which type of protection is applying.

Hm, I wasn't actually sure if it was a typo or not :)

But I thought that MEMCG_PROT_HIGH means a higher level
of protection than MEMCG_PROT_LOW, which sounds reasonable.

So, I'm fine with either option.

> 
> The rest of the patch looks good:
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 

Thanks!

Can you, also, please, take a look at this one:
https://lkml.org/lkml/2018/4/24/703.

Thank you!
