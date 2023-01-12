From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 0/4] Track exported dma-buffers with memcg
Date: Thu, 12 Jan 2023 11:25:37 +0100
Message-ID: <Y7/gIRv9aJfPK7/f@dhcp22.suse.cz>
References: <20230109213809.418135-1-tjmercier@google.com>
 <CALvZod4ru7F38tAO-gM9ZFKaEhS0w3KqFbPwhwcTvgJs4xMUow@mail.gmail.com>
 <Y78+rfzXPq5XGs9O@phenom.ffwll.local>
 <20230112075631.wc6fd54ci55drhkp@google.com>
Mime-Version: 1.0
Return-path: <linux-media-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673519138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RFRkZ+Fj3t8T5BZaiHz5NCYqROwzY9AM/nVOyatEKtk=;
        b=kXlRU9udXbFgZotDjntGowEBuvchX+T2tPOQt4l2B/QItP41pyuGf09UekzD58fu0LIxRc
        w76yu+pkH0Ua7YBS6uJ2rwWDxCoFeyaVSAeCGGeNdqLbR3tAQh+xq9uDiO7GTSj2Wj7bNn
        HineNr8vyQXh2nAR99gNAKtfqxMYBuI=
Content-Disposition: inline
In-Reply-To: <20230112075631.wc6fd54ci55drhkp@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>

On Thu 12-01-23 07:56:31, Shakeel Butt wrote:
> On Wed, Jan 11, 2023 at 11:56:45PM +0100, Daniel Vetter wrote:
> > 
> [...]
> > I think eventually, at least for other "account gpu stuff in cgroups" use
> > case we do want to actually charge the memory.
> > 
> > The problem is a bit that with gpu allocations reclaim is essentially "we
> > pass the error to userspace and they get to sort the mess out". There are
> > some exceptions (some gpu drivers to have shrinkers) would we need to make
> > sure these shrinkers are tied into the cgroup stuff before we could enable
> > charging for them?
> > 
> 
> No, there is no requirement to have shrinkers or making such memory
> reclaimable before charging it. Though existing shrinkers and the
> possible future shrinkers would need to be converted into memcg aware
> shrinkers.
> 
> Though there will be a need to update user expectations that if they 
> use memcgs with hard limits, they may start seeing memcg OOMs after the
> charging of dmabuf.

Agreed. This wouldn't be the first in kernel memory charged memory that
is not directly reclaimable. With a dedicated counter an excessive
dmabuf usage would be visible in the oom report because we do print
memcg stats.

It is definitely preferable to have a shrinker mechanism but if that is
to be done in a follow up step then this is acceptable. But leaving out
charging from early on sounds like a bad choice to me.
-- 
Michal Hocko
SUSE Labs
