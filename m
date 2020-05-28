From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 28 May 2020 16:11:17 -0400
Message-ID: <20200528201117.GD69521@cmpxchg.org>
References: <20200520165131.GB630613@cmpxchg.org>
 <20200520170430.GG6462@dhcp22.suse.cz>
 <20200520175135.GA793901@cmpxchg.org>
 <20200521073245.GI6462@dhcp22.suse.cz>
 <20200521135152.GA810429@cmpxchg.org>
 <20200521143515.GU6462@dhcp22.suse.cz>
 <20200521163833.GA813446@cmpxchg.org>
 <20200521173701.GX6462@dhcp22.suse.cz>
 <20200521184505.GA815980@cmpxchg.org>
 <20200528163101.GJ27484@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=83zLTVKdvpR2KxKh88qE1mTweOG1k93RYAEKbnweuYU=;
        b=OgFfHLjM0xzOmXUQpzcCAMMrfpbK7MxIECNfhMYFKDunkqaArhuEzxRhhBna2RhZWt
         dI5uXxPB91bBATybc4BO6D/IZ9XFYihdh4Ww2J/zjZAOcfJs0Ywxe5XpkYtsbPVHcnN+
         dQNWfQWnFUJqwapSBddU8wJ3Jf+P0hmGbx79Gxlz8Mz4JxS/hOUQnsrgbwoTF/C2J9CY
         +ldcrCBHzBD9/d/fM7E+irtE/rIfpQJ/awZqWcpJtHj+TuXt7Gelc9gpi1v4YwSvup+R
         R95gCm5EwJnymHuv8GMnue0qTo/SUO2lAO0OvH4i1mBJbpu5cvs8jyDX5m3VeVsb1HgI
         xeXg==
Content-Disposition: inline
In-Reply-To: <20200528163101.GJ27484-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, May 28, 2020 at 06:31:01PM +0200, Michal Hocko wrote:
> On Thu 21-05-20 14:45:05, Johannes Weiner wrote:
> > After analyzing this problem, it's clear that we had an oversight
> > here: all other reclaimers are already familiar with the fact that
> > reclaim may not be able to complete the reclaim target in one call, or
> > that page reclaim is inherently racy and reclaim work can be stolen.
> 
> There is no disagreement here.
> 
> > We send a simple bug fix: bring this instance of reclaim in line with
> > how everybody else is using the reclaim API, to meet the semantics as
> > they are intendend and documented.
> 
> Here is where we are not on the same page though. Once you have identified
> that the main problem is that the reclaim fails too early to meet the
> target then the fix would be to enforce that target. I have asked why
> this hasn't been done and haven't got any real answer for that.

Then I encourage you to re-read the thread.

I have explained that reclaim invocations can fail to meet the
requested target for a variety of reasons, including dirty state or
other states that make memory temporarily unreclaimable, race
conditions between reclaimers and so forth.

I have also pointed out that this is widely acknowledged by the fact
that all other reclaimers retry in the exact same manner. If you want
to question that VM-wide precedence, please do so in your own patches.

As to the question around fairness, I have explained that fairness is
a best effort and that if push comes to shove, preventing premature
OOM situations or failing cgroup containment and causing system-wide
OOMs is more important.

> Instead what you call "a simple bug fix" has larger consequences
> which are not really explained in the changelog and they are also
> not really trivial to see. If the changelog explicitly stated that
> the proportional memory reclaim is not sufficient because XYZ and
> the implementation has been changed to instead meet the high limit
> target then this would be a completely different story and I believe
> we could have saved some discussion.

The point of memory.high reclaim is to meet the memory.high memory
limit. That, too, has been addressed - although it's astounding that
it needed to be pointed out. The proportionality is an attempt at
fairness that doesn't override the primary purpose.

I appreciate your concerns, but your questions have been addressed.

And you're not contributing anything of value to the conversation
until you familiarize yourself with the purpose of the memory.high
interface.

Thanks
