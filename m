From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Fri, 14 Feb 2020 10:40:57 -0500
Message-ID: <20200214154057.GM88887@mtj.thefacebook.com>
References: <20200212170826.GC180867@cmpxchg.org>
 <20200213074049.GA31689@dhcp22.suse.cz>
 <20200213135348.GF88887@mtj.thefacebook.com>
 <20200213154731.GE31689@dhcp22.suse.cz>
 <20200213155249.GI88887@mtj.thefacebook.com>
 <20200213163636.GH31689@dhcp22.suse.cz>
 <20200213165711.GJ88887@mtj.thefacebook.com>
 <20200214071537.GL31689@dhcp22.suse.cz>
 <20200214135728.GK88887@mtj.thefacebook.com>
 <20200214151318.GC31689@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PUP4np+G4VE7PuRhOk6undkvvxru+QNxEyvlFdHRy8M=;
        b=ZbT6gpBkKjiYBwLqeSqmGvHliwzu3GiTDD1TN6F1csmbHvQf5zew22ys7x8sByZCFB
         q48R1dqd6gb7760yQUKvX4ZNOKbkvtwgVXPFolXQrQXFKuoaSdlGKyGE+fp8z//c61Hd
         9aFr16nzHuax9MVICJO+adiLztmf99s8R7h4dW7aDkTdvIDlLGhEAskwkWWFDaMuKHh+
         EBqbHa95IoXx+rusv2pI09ldunnEOGJq3Ra9uXfWr3ii4cIPUeeLkQmcWl2DMBT4FrBk
         hTj1LXm+1GQmksx8ne1jW4r0o3tNzCKAJvVd/3eOw9vI5C/TQEWBf3N/WArbWsU/bI6K
         f3iA==
Content-Disposition: inline
In-Reply-To: <20200214151318.GC31689-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Fri, Feb 14, 2020 at 04:13:18PM +0100, Michal Hocko wrote:
> On Fri 14-02-20 08:57:28, Tejun Heo wrote:
> > But that doesn't work for other controllers at all. I'm having a
> > difficult time imagining how making this one control mechanism work
> > that way makes sense. Memory protection has to be configured together
> > with IO protection to be actually effective.
> 
> Please be more specific. If the protected workload is mostly in-memory,
> I do not really see how IO controller is relevant. See the example of
> the DB setup I've mentioned elsewhere.

Most applications, even the ones which don't use explicit IOs much,
don't have set memory footprint which is uniformly accessed and there
needs to be some level of reclaim activity for the working set to be
established and maintained. Without IO control, memory protection
isn't enough in protecting the workload.

Even if we narrow down the discussion to something like memcache which
has fixed memory footprint with almost uniform access pattern, real
world applications don't exist in vacuum - they compete on CPU, have
to do logging, pulls in metric ton of libraries which implicitly
accesses stuff and so on. If somebody else is pummeling the filesystem
and there's no IO isolation set up, it'll stall noticeably every once
in a while.

> > As for cgroup hierarchy being unrelated to how controllers behave, it
> > frankly reminds me of cgroup1 memcg flat hierarchy thing I'm not sure
> > how that would actually work in terms of resource isolation. Also, I'm
> > not sure how systemd forces such configurations and I'd think systemd
> > folks would be happy to fix them if there are such problems. Is the
> > point you're trying to make "because of systemd, we have to contort
> > how memory controller behaves"?
> 
> No, I am just saying and as explained in reply to Johannes, there are
> practical cases where the cgroup hierarchy reflects organizational
> structure as well.

Oh I see. If cgroup hierarchy isn't set up for resource control,
resource control not working well seems par for the course. I mean, no
other controllers would work anyway, so I'm having a hard time to see
what the point is. What we ultimately want is cgroup actually being
useful for its primary purpose of resource control while supporting
other organizational use cases and while the established usages aren't
there yet I haven't seen anything fundamentally blocking that.

Thanks.

-- 
tejun
