From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm: per-cgroup memory reclaim stats
Date: Wed, 17 May 2017 16:50:42 +0100
Message-ID: <20170517155042.GA4133@castle>
References: <1494530183-30808-1-git-send-email-guro@fb.com>
 <1494555922.21563.1.camel@gmail.com>
 <20170512164206.GA22367@cmpxchg.org>
 <CAKTCnz=vj9-C2-XPcijB=fZOVVdxvqZvLEA93xXtRZmF+y3-Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=z1doGtAMvh20bGpjKPD0QqgsWEeYoRCDUaFLBrxeB7c=;
 b=pLC17+GvyjD6flq4QmjcV5vg2YV8J3eP0gR/xbMrXZ5UYshiSuZwZxejh3N0vG2TnE15
 OMMUpsv68QYu31/A3tH6GzdrFlNqa8lHTEP0u1PzwFyBYVQVF5LP2opd5S5XjR8Z0+XX
 i7A7xUvzSRHVdQ8GFiIxM+olXp59PtYbM1k= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=z1doGtAMvh20bGpjKPD0QqgsWEeYoRCDUaFLBrxeB7c=;
 b=FNP797el9aNYGRLonCRWMLvUAy8uAOfVPREbaPmcn0gf2pvzE2bUa2Eog/ATOQjbomWkEZtqbjMKhXWbwfdAAC+AiaRvdNAQ6ggnBrkxSVkr+x3VcYXClaMumoZ3v+/lqNj8YFxKw+TPKafdIPWNIft6PEvhwlsTPMWFEYOCLVE=
Content-Disposition: inline
In-Reply-To: <CAKTCnz=vj9-C2-XPcijB=fZOVVdxvqZvLEA93xXtRZmF+y3-Lg@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Balbir Singh <bsingharora@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>

On Wed, May 17, 2017 at 08:03:03AM +1000, Balbir Singh wrote:
> On Sat, May 13, 2017 at 2:42 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > On Fri, May 12, 2017 at 12:25:22PM +1000, Balbir Singh wrote:
> >>
> >> It sounds like memcg accumlates both global and memcg reclaim driver
> >> counts -- is this what we want?
> >
> > Yes.
> >
> > Consider a fully containerized system that is using only memory.low
> > and thus exclusively global reclaim to enforce the partitioning, NOT
> > artificial limits and limit reclaim. In this case, we still want to
> > know how much reclaim activity each group is experiencing.
> 
> But its also confusing to see memcg.stat's value being greater
> than the global value? At-least for me. For example PGSTEAL_DIRECT
> inside a memcg > global value of PGSTEAL_DIRECT. Do we make
> memcg.stat values sum of all impact on memcg or local to memcg?

Yes, I think that global counters should include both results of
global and per-cgroup reclaim. I will prepare a separate patch for this.

Thank you!

Roman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
