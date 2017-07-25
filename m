From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm, memcg: reset low limit during memcg offlining
Date: Tue, 25 Jul 2017 13:31:13 +0100
Message-ID: <20170725123113.GB12635@castle.DHCP.thefacebook.com>
References: <20170725114047.4073-1-guro@fb.com>
 <20170725120537.o4kgzjhcjcjmopzc@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=XvI/+FciB05AMUe1xSJptC59/0B/8I/dBFdGMr9QJbE=;
 b=gAvLKDN9F4xfmxuZydqYh+Et8I/aJ2YhMiSOFRAnqHJcttzjZ0mXZutKUVPZc/1tALbj
 dlEiIzRd7w2HRA533x2OHMvQOIIq59YAej64fGPIQQ/gIw3osmkQ0f4zNeAn0TXlqX18
 6yB0XsrUvfFJKOdD2fKESMxUfbkwGV2cCKc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XvI/+FciB05AMUe1xSJptC59/0B/8I/dBFdGMr9QJbE=;
 b=Gi2MAZFmKUFSoc7Mxge89/C+BtllClDnuASwUOK+dB2An+sWLKyJf14HA2vc+8lnAk7bLy9BPtP6iYM+BdhGswj7Uu57kKJyotugpQZLT6XcIeWscOzLGdzo6wa0T4AlSjC4qjI1PGiwp1gJ0gHPCxHWkHKyE97d0Fsey0mOIe8=
Content-Disposition: inline
In-Reply-To: <20170725120537.o4kgzjhcjcjmopzc@esperanza>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 25, 2017 at 03:05:37PM +0300, Vladimir Davydov wrote:
> On Tue, Jul 25, 2017 at 12:40:47PM +0100, Roman Gushchin wrote:
> > A removed memory cgroup with a defined low limit and some belonging
> > pagecache has very low chances to be freed.
> > 
> > If a cgroup has been removed, there is likely no memory pressure inside
> > the cgroup, and the pagecache is protected from the external pressure
> > by the defined low limit. The cgroup will be freed only after
> > the reclaim of all belonging pages. And it will not happen until
> > there are any reclaimable memory in the system. That means,
> > there is a good chance, that a cold pagecache will reside
> > in the memory for an undefined amount of time, wasting
> > system resources.
> > 
> > Fix this issue by zeroing memcg->low during memcg offlining.
> > 
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > Cc: kernel-team@fb.com
> > Cc: cgroups@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  mm/memcontrol.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index aed11b2d0251..2aa204b8f9fd 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4300,6 +4300,8 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
> >  	}
> >  	spin_unlock(&memcg->event_list_lock);
> >  
> > +	memcg->low = 0;
> > +
> >  	memcg_offline_kmem(memcg);
> >  	wb_memcg_offline(memcg);
> >  
> 
> We already have that - see mem_cgroup_css_reset().

Hm, I see...

But are you sure, that calling mem_cgroup_css_reset() from offlining path
is always a good idea?

As I understand, css_reset() callback is intended to _completely_ disable all
limits, as if there were no cgroup at all. And it's main purpose to be called
when controllers are detached from the hierarhy.

Offlining is different: some limits make perfect sence after offlining
(e.g. we want to limit the writeback speed), and other might be tweaked
(e.g. we can set soft limit to prioritize reclaiming of abandoned cgroups).

So, I'd prefer to move this code to the offlining callback,
and not to call css_reset.

But, anyway, thanks for pointing at the mem_cgroup_css_reset().

Roman
