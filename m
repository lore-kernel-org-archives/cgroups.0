From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: Optionally disable memcg by default using
 Kconfig
Date: Tue, 19 May 2015 12:14:22 -0400
Message-ID: <20150519161422.GA10561@cmpxchg.org>
References: <20150519104057.GC2462@suse.de>
 <20150519141807.GA9788@cmpxchg.org>
 <20150519145340.GI6203@dhcp22.suse.cz>
 <20150519151302.GG2462@suse.de>
 <555B55F0.7030907@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <555B55F0.7030907-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 19, 2015 at 05:25:36PM +0200, Vlastimil Babka wrote:
> On 05/19/2015 05:13 PM, Mel Gorman wrote:
> >### MEL: Function entry, check for mem_cgroup_disabled()
> >
> >
> >                :ffffffff811c160f:       je     ffffffff811c1630 <mem_cgroup_try_charge+0x40>
> >                :ffffffff811c1611:       xor    %eax,%eax
> >                :ffffffff811c1613:       xor    %ebx,%ebx
> >      1 1.7e-05 :ffffffff811c1615:       mov    %rbx,(%r12)
> >      7 1.2e-04 :ffffffff811c1619:       add    $0x10,%rsp
> >   1211  0.0203 :ffffffff811c161d:       pop    %rbx
> >      5 8.4e-05 :ffffffff811c161e:       pop    %r12
> >      5 8.4e-05 :ffffffff811c1620:       pop    %r13
> >   1249  0.0210 :ffffffff811c1622:       pop    %r14
> >      7 1.2e-04 :ffffffff811c1624:       pop    %rbp
> >      5 8.4e-05 :ffffffff811c1625:       retq
> >                :ffffffff811c1626:       nopw   %cs:0x0(%rax,%rax,1)
> >    295  0.0050 :ffffffff811c1630:       mov    (%rdi),%rax
> >160703  2.6973 :ffffffff811c1633:       mov    %edx,%r13d
> >
> >#### MEL: I was surprised to see this atrocity. It's a PageSwapCache check
> 
> Looks like sampling is off by instruction, because why would a reg->reg mov
> took so long. So it's probably a cache miss on struct page, pointer to which
> is in rdi. Which is weird, I would expect memcg to be called on struct pages
> that are already hot.

Yeah, anonymous faults do __SetPageUptodate() right before passing the
page into mem_cgroup_try_charge().  page->flags should be hot.

> It would also mean that if you don't fetch the struct
> page from the memcg code, then the following code in the caller will most
> likely work on the struct page and get the cache miss anyway?

Which is why the runtime reduction doesn't match the profile
reduction.  The cost seems to get shifted somewhere else.
