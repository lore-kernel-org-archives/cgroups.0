From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v2 3/3] mm: automatically penalize tasks with high
 swap use
Date: Tue, 12 May 2020 10:55:36 -0700
Message-ID: <20200512105536.748da94e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200511225516.2431921-1-kuba@kernel.org>
        <20200511225516.2431921-4-kuba@kernel.org>
        <20200512072634.GP29153@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589306138;
        bh=xdOV4sVw/QH3W5l5kTFnjtP5Xn7D0F1rZuTijRqPjeA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=whE0WE770+VHaMbfnYuPaiR3YTLVRI2bm6dCBiAjZO8iCWSULQm9XueRSDg27tl/e
         xqTLM3PvalH3TpK8APtJHmd69y0BT7kubpKq9WhkBe8iFqy9B20swAuxAdcwEnf6Rz
         lFtQWXAqkZCrbJ7H4+d3wLM5A+dn32IvGgCQWhOw=
In-Reply-To: <20200512072634.GP29153-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Tue, 12 May 2020 09:26:34 +0200 Michal Hocko wrote:
> On Mon 11-05-20 15:55:16, Jakub Kicinski wrote:
> > Use swap.high when deciding if swap is full.  
> 
> Please be more specific why.

How about:

    Use swap.high when deciding if swap is full to influence ongoing
    swap reclaim in a best effort manner.

> > Perform reclaim and count memory over high events.  
> 
> Please expand on this and explain how this is working and why the
> semantic is subtly different from MEMCG_HIGH. I suspect the reason
> is that there is no reclaim for the swap so you are only emitting an
> event on the memcg which is actually throttled. This is in line with
> memory.high but the difference is that we do reclaim each memcg subtree
> in the high limit excess. That means that the counter tells us how many
> times the specific memcg was in excess which would be impossible with
> your implementation.

Right, with memory all cgroups over high get penalized with the extra
reclaim work. For swap we just have the delay, so the event is
associated with the worst offender, anything lower didn't really matter.

But it's easy enough to change if you prefer. Otherwise I'll just add
this to the commit message:

  Count swap over high events. Note that unlike memory over high events
  we only count them for the worst offender. This is because the
  delay penalties for both swap and memory over high are not cumulative,
  i.e. we use the max delay.

> I would also suggest to explain or ideally even separate the swap
> penalty scaling logic to a seprate patch. What kind of data it is based
> on?

It's a hard thing to get production data for since, as we mentioned we
don't expect the limit to be hit. It was more of a process of
experimentation and finding a gradual slope that "felt right"...

Is there a more scientific process we can follow here? We want the
delay to be small at first for a first few pages and then grow to make
sure we stop the task from going too much over high. The square
function works pretty well IMHO.
