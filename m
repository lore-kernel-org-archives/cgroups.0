From: CGEL <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: support control THP behaviour in cgroup
Date: Tue, 10 May 2022 11:52:51 +0000
Message-ID: <627a5214.1c69fb81.1b7fb.47be@mx.google.com>
References: <20220505033814.103256-1-xu.xin16@zte.com.cn>
 <YnUlntNFR4zeD+qa@dhcp22.suse.cz>
 <6275d3e7.1c69fb81.1d62.4504@mx.google.com>
 <YnjmPAToTR0C5o8x@dhcp22.suse.cz>
 <6278fa75.1c69fb81.9c598.f794@mx.google.com>
 <Ynj/l+pyFJxKfcbQ@dhcp22.suse.cz>
 <6279c354.1c69fb81.7f6c1.15e0@mx.google.com>
 <Yno3pNQOn1lAMPnu@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=A0FdGVbgNiT4qf9UfDKCilymbnIPA66uo0bOacpn5kc=;
        b=TrL7vgw9hX+FCcAXW++0XCOVJrf3QJUaGJVBqbSUUAypLKKmpB4cuOYtIBhwBMrido
         OqyotI4LcRe4dMJ+sEuBiPjcoy6u9Gm8LaTMLc4E7CDUGb0NEMsgjYvEUgg7m8U3u0eG
         uNqKuhwvdn/9hCqYeSgtXmc1eW1Sa1IgzmrTCEpa+QNwe72//BvLag9bFRowZv0amPW+
         K0zp2D7YNGKRETl1r4545b2dw6ApogYm0APyDJ6wyU5HizQF3DIMoqbhuBwQs7H9835o
         9Pk6qqzXIs+ZUWEJuKxUj0q5OpeKBpKG9AfN10aApJkGDNEWGTwjKMkXfgA78Uj/xo3I
         DvJQ==
Content-Disposition: inline
In-Reply-To: <Yno3pNQOn1lAMPnu-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, william.kucharski-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Tue, May 10, 2022 at 12:00:04PM +0200, Michal Hocko wrote:
> On Tue 10-05-22 01:43:38, CGEL wrote:
> > On Mon, May 09, 2022 at 01:48:39PM +0200, Michal Hocko wrote:
> > > On Mon 09-05-22 11:26:43, CGEL wrote:
> > > > On Mon, May 09, 2022 at 12:00:28PM +0200, Michal Hocko wrote:
> > > > > On Sat 07-05-22 02:05:25, CGEL wrote:
> > > > > [...]
> > > > > > If there are many containers to run on one host, and some of them have high
> > > > > > performance requirements, administrator could turn on thp for them:
> > > > > > # docker run -it --thp-enabled=always
> > > > > > Then all the processes in those containers will always use thp.
> > > > > > While other containers turn off thp by:
> > > > > > # docker run -it --thp-enabled=never
> > > > > 
> > > > > I do not know. The THP config space is already too confusing and complex
> > > > > and this just adds on top. E.g. is the behavior of the knob
> > > > > hierarchical? What is the policy if parent memcg says madivise while
> > > > > child says always? How does the per-application configuration aligns
> > > > > with all that (e.g. memcg policy madivise but application says never via
> > > > > prctl while still uses some madvised - e.g. via library).
> > > > >
> > > > 
> > > > The cgroup THP behavior is align to host and totally independent just likes
> > > > /sys/fs/cgroup/memory.swappiness. That means if one cgroup config 'always'
> > > > for thp, it has no matter with host or other cgroup. This make it simple for
> > > > user to understand or control.
> > > 
> > > All controls in cgroup v2 should be hierarchical. This is really
> > > required for a proper delegation semantic.
> > >
> > 
> > Could we align to the semantic of /sys/fs/cgroup/memory.swappiness?
> > Some distributions like Ubuntu is still using cgroup v1.
> 
> cgroup v1 interface is mostly frozen. All new features are added to the
> v2 interface.
>

So what about we add this interface to cgroup v2?

> > > > If memcg policy madivise but application says never, just like host, the result
> > > > is no THP for that application.
> > > > 
> > > > > > By doing this we could promote important containers's performance with less
> > > > > > footprint of thp.
> > > > > 
> > > > > Do we really want to provide something like THP based QoS? To me it
> > > > > sounds like a bad idea and if the justification is "it might be useful"
> > > > > then I would say no. So you really need to come with a very good usecase
> > > > > to promote this further.
> > > > 
> > > > At least on some 5G(communication technology) machine, it's useful to provide
> > > > THP based QoS. Those 5G machine use micro-service software architecture, in
> > > > other words one service application runs in one container.
> > > 
> > > I am not really sure I understand. If this is one application per
> > > container (cgroup) then why do you really need per-group setting?
> > > Does the application is a set of different processes which are only very
> > > loosely tight?
> > > 
> > For micro-service architecture, the application in one container is not a
> > set of loosely tight processes, it's aim at provide one certain service,
> > so different containers means different service, and different service
> > has different QoS demand. 
> 
> OK, if they are tightly coupled you could apply the same THP policy by
> an existing prctl interface. Why is that not feasible. As you are noting
> below...
> 
> >     5.containers usually managed by compose software, which treats container as
> > base management unit;
> 
> ..so the compose software can easily start up the workload by using prctl
> to disable THP for whatever workloads it is not suitable for.

prctl(PR_SET_THP_DISABLE..) can not be elegance to support the semantic we
need. If only some containers needs THP, other containers and host do not need
THP. We must set host THP to always first, and call prctl() to close THP for
host tasks and other containers one by one, in this process some tasks that
start before we call prctl() may already use THP with no need. 

And compose's semantic treats container as base unit to manage not tasks. See:
https://docs.docker.com/compose/

If we treat container as lightweight virtual machine things may become clearer:
this virtual machine has it's own THP policy being set just likes
/sys/kernel/mm/transparent_hugepage/enabled in host, it has nothing to do
with host or other virtual machine.

> -- 
> Michal Hocko
> SUSE Labs
