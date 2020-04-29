From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Wed, 29 Apr 2020 10:19:45 -0400
Message-ID: <20200429141945.GB5054@cmpxchg.org>
References: <cover.1588092152.git.chris@chrisdown.name>
 <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
 <20200429101510.GA28637@dhcp22.suse.cz>
 <CALOAHbAosoU=+iPgD+TeU_iDXTV7W_WcFdKCi2fdwwyvutG2zQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WY+s1xElLyYapOX+xyVfCwGq2ouDJfw9qAn8e1SedMM=;
        b=sM10OsRR0LNY4pcjhbdJnhoISXS/L4LnoeViGpuwZ2v+5WA8cDi0zGpia6vF/Lnywe
         9yDC5Ysp9d3GxBOYO/Jy5r525crsR9ZR6Pel0O38S0Xl0kMiRfmh7zpL/aA3BBu81rMm
         tmR84XZpKOhWYZyP9PUd9L+TFewI/8EMjEjYSUpVDVJ6+3CAapKUaVFTXct61QYcva81
         gvSR+ox35ebLokYCKn2R0DeTO0+BRyx56hxhXWqLfCHar8ss9urE1ne3VXSINkkEOwdA
         5+q38c+uJC7z15wq2a3UQbl+6dVrM4vvJ4ZWX9Y2UXi2JxONkL/tF3icTij/9A/Vqv9y
         GtaQ==
Content-Disposition: inline
In-Reply-To: <CALOAHbAosoU=+iPgD+TeU_iDXTV7W_WcFdKCi2fdwwyvutG2zQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Apr 29, 2020 at 06:53:03PM +0800, Yafang Shao wrote:
> On Wed, Apr 29, 2020 at 6:15 PM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Tue 28-04-20 19:26:47, Chris Down wrote:
> > > From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >
> > > A cgroup can have both memory protection and a memory limit to isolate
> > > it from its siblings in both directions - for example, to prevent it
> > > from being shrunk below 2G under high pressure from outside, but also
> > > from growing beyond 4G under low pressure.
> > >
> > > Commit 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > > implemented proportional scan pressure so that multiple siblings in
> > > excess of their protection settings don't get reclaimed equally but
> > > instead in accordance to their unprotected portion.
> > >
> > > During limit reclaim, this proportionality shouldn't apply of course:
> > > there is no competition, all pressure is from within the cgroup and
> > > should be applied as such. Reclaim should operate at full efficiency.
> > >
> > > However, mem_cgroup_protected() never expected anybody to look at the
> > > effective protection values when it indicated that the cgroup is above
> > > its protection. As a result, a query during limit reclaim may return
> > > stale protection values that were calculated by a previous reclaim cycle
> > > in which the cgroup did have siblings.
> > >
> > > When this happens, reclaim is unnecessarily hesitant and potentially
> > > slow to meet the desired limit. In theory this could lead to premature
> > > OOM kills, although it's not obvious this has occurred in practice.
> >
> > Thanks this describes the underlying problem. I would be also explicit
> > that the issue should be visible only on tail memcgs which have both
> > max/high and protection configured and the effect depends on the
> > difference between the two (the smaller it is the largrger the effect).
> >
> > There is no mention about the fix. The patch resets effective values for
> > the reclaim root and I've had some concerns about that
> > http://lkml.kernel.org/r/20200424162103.GK11591-2MMpYkNvuYA6bu5BqYkRsg@public.gmane.org
> > Johannes has argued that other races are possible and I didn't get to
> > think about it thoroughly. But this patch is introducing a new
> > possibility of breaking protection.
> 
> Agreed with Michal that more writes will cause more bugs.
> We should operate the volatile emin and elow as less as possible.

That's not a technical argument.

If races are a problem, it doesn't matter that they're rare. If
they're not a problem, it doesn't matter that they're frequent.

> >  If we want to have a quick and
> > simple fix that would be easier to backport to older kernels then I
> > would feel much better if we simply workedaround the problem as
> > suggested earlier http://lkml.kernel.org/r/20200423061629.24185-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> 
> +1
> 
> This should be the right workaround to fix the current issue and it is
> worth to be backported to the stable kernel.

From Documentation/process/stable-kernel-rules.rst:

 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).

There hasn't been a mention of this affecting real workloads in the
submission history of this patch, so it doesn't qualify for -stable.
