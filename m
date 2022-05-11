From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Wed, 11 May 2022 09:21:53 +0200
Message-ID: <YntkEUKPquTbBjMu@dhcp22.suse.cz>
References: <YnUlntNFR4zeD+qa@dhcp22.suse.cz>
 <6275d3e7.1c69fb81.1d62.4504@mx.google.com>
 <YnjmPAToTR0C5o8x@dhcp22.suse.cz>
 <6278fa75.1c69fb81.9c598.f794@mx.google.com>
 <Ynj/l+pyFJxKfcbQ@dhcp22.suse.cz>
 <6279c354.1c69fb81.7f6c1.15e0@mx.google.com>
 <Yno3pNQOn1lAMPnu@dhcp22.suse.cz>
 <627a5214.1c69fb81.1b7fb.47be@mx.google.com>
 <YnpqYte2jLdcBiPg@dhcp22.suse.cz>
 <627b1899.1c69fb81.cd831.12d9@mx.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652253715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oPT7y3vtMr9hrPGl5KbXi6Udsxr9fQRC1iNa9w9V8TY=;
        b=cxU4a2s88K5U+Lf0tA0v8r+T4GnaUuAC/B1HkF4OQxBRySnalhHSOl+sexwH0SSsLMsyBe
        NDG/A+Le+GpX3XoULZqJJM4maXRrpUufl9aMyUGBKwFcKKuvCGC19Bn0LMIEBSOge1PgJM
        KEty8LVfXNuk0DhuHnGvY6VS15VD/Qs=
Content-Disposition: inline
In-Reply-To: <627b1899.1c69fb81.cd831.12d9-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: CGEL <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Wed 11-05-22 01:59:52, CGEL wrote:
> On Tue, May 10, 2022 at 03:36:34PM +0200, Michal Hocko wrote:
[...]
> > Can you come up with a sane hierarchical behavior?
> >
> 
> I think this new interface better be independent not hierarchical anyway. Especially
> when we treat container as lightweight virtual machine.

I suspect you are focusing too much on your usecase and do not realize
wider consequences of this being an user interface that still has to be
sensible for other usecases. Take a delagation of the control to
subgroups as an example. If this is a per memcg knob (like swappiness)
then children can override parent's THP policy. This might be a less of
the deal for swappiness because the anon/file reclaim balancing should
be mostly an internal thing. But THP policy is different because it has
other effects to workloads running outside of the said cgroup - higher
memory demand, higher contention for high-order memory etc.

I do not really see how this could be a sensible per-memcg policy
without being fully hierarchical.

> 
> > [...]
> > > > > For micro-service architecture, the application in one container is not a
> > > > > set of loosely tight processes, it's aim at provide one certain service,
> > > > > so different containers means different service, and different service
> > > > > has different QoS demand. 
> > > > 
> > > > OK, if they are tightly coupled you could apply the same THP policy by
> > > > an existing prctl interface. Why is that not feasible. As you are noting
> > > > below...
> > > > 
> > > > >     5.containers usually managed by compose software, which treats container as
> > > > > base management unit;
> > > > 
> > > > ..so the compose software can easily start up the workload by using prctl
> > > > to disable THP for whatever workloads it is not suitable for.
> > > 
> > > prctl(PR_SET_THP_DISABLE..) can not be elegance to support the semantic we
> > > need. If only some containers needs THP, other containers and host do not need
> > > THP. We must set host THP to always first, and call prctl() to close THP for
> > > host tasks and other containers one by one,
> > 
> > It might not be the most elegant solution but it should work.
> 
> So you agree it's reasonable to set THP policy for process in container, right?

Yes, like in any other processes.

> If so, IMHO, when there are thousands of processes launch and die on the machine,
> it will be horrible to do so by calling prctl(), I don't see the reasonability.

Could you be more specific? The usual prctl use would be normally
handled by the launcher and rely on the per-process policy to be
inherited down the road.

-- 
Michal Hocko
SUSE Labs
