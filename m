From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH v2] mm: introduce memory.min
Date: Wed, 25 Apr 2018 13:52:55 +0300
Message-ID: <20180425105255.ixfuoanb6t4kr6l5@esperanza>
References: <20180423123610.27988-1-guro@fb.com>
 <20180424123002.utwbm54mu46q6aqs@esperanza>
 <20180424135409.GA28080@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kEVyLK87zAjO1axPFoMtlc+94eOEkQArXxasK63tgsA=;
        b=mLxMsexBabxDrqZv4Jyv+rsMYwYIntvQXvU7A97gi6+b6iEdtJy53+kHFu4v+2cC12
         3yTVdjroGDr/wIb2uXZVnNqeovwlXvc3Wc99R58u/gKkzhEYomnmIxFynKQGNrVF75LK
         L9Wh53e5P/SH0UE7gTsYEwbaHeuv07duIsxvijzn5abU4Eaaivvpc1ea2GqWgCPY30jE
         Ew5LC7h9D8yLhPKaAEMIo4ah5/q5McG6CpTlREUycoAKXca+u4mY5isodW6dH2xItB3r
         l8MskAfBUSglVp+hrJcGjaGyoOBzZOftWmiW1wh+EfovnUTiWntA+bArGVsngFcbaVU7
         j0QA==
Content-Disposition: inline
In-Reply-To: <20180424135409.GA28080@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>

On Tue, Apr 24, 2018 at 02:54:15PM +0100, Roman Gushchin wrote:
> > On Mon, Apr 23, 2018 at 01:36:10PM +0100, Roman Gushchin wrote:
> > > +  memory.min
> > > +	A read-write single value file which exists on non-root
> > > +	cgroups.  The default is "0".
> > > +
> > > +	Hard memory protection.  If the memory usage of a cgroup
> > > +	is within its effective min boundary, the cgroup's memory
> > > +	won't be reclaimed under any conditions. If there is no
> > > +	unprotected reclaimable memory available, OOM killer
> > > +	is invoked.
> > 
> > What will happen if all tasks attached to a cgroup are killed by OOM,
> > but its memory usage is still within memory.min? Will memory.min be
> > ignored then?
> 
> Not really.
> 
> I don't think it's a big problem as long as a user isn't doing
> something weird (e.g. moving processes with significant
> amount of charged memory to other cgroups).

The user doesn't have to do anything weird for this to happen - just
read a file. This will allocate and charge page cache pages that are
not mapped to any process and hence cannot be freed by OOM killer.

> 
> But what we can do here, is to ignore memory.min of empty cgroups
> (patch below), it will resolve some edge cases like this.

Makes sense to me.

Thanks,
Vladimir
