From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/7] mm: memcontrol: fix cpuhotplug statistics flushing
Date: Thu, 4 Feb 2021 14:29:57 -0500
Message-ID: <YBxLNZJ/83P7H8+H@cmpxchg.org>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-2-hannes@cmpxchg.org>
 <20210202230747.GA1812008@carbon.dhcp.thefacebook.com>
 <20210203022853.GG1812008@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pxEH3lPVvNUUdUP05ZPOl2OQ8LUijQb0MCrSWBXGG1I=;
        b=avFnTqyzD1lpktS9bgh7ccT5o3JRmPhvL3P/+Rzvtn4OvxFpTV7zxaoJO0kCJ4iVHb
         xUqJgv/Re97obtqWTQQsdPQ//rV2bSEcTqkAbkpGABW2h2z02WGuBRIRJ8nfipeBbK6L
         hRybH6mwFcUaSkUpiAu4YDDK/fmqYz2oVMwmXgwexb0x6+YoIf/h5gabNV3X50431Md8
         QGBrSXWq/n3Xz8F5Q+XF+Sg32MgsX3EXrGPMUX6RUOv/t9InDPlr/qvtfobNspqKEDqj
         hPf4NcugQRHsrEnIQXjVacillW1TmexsR9w1vUrPbVszAlHh+1zvegmvVQuGMVrJeOX9
         gxJQ==
Content-Disposition: inline
In-Reply-To: <20210203022853.GG1812008-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Feb 02, 2021 at 06:28:53PM -0800, Roman Gushchin wrote:
> On Tue, Feb 02, 2021 at 03:07:47PM -0800, Roman Gushchin wrote:
> > On Tue, Feb 02, 2021 at 01:47:40PM -0500, Johannes Weiner wrote:
> > > The memcg hotunplug callback erroneously flushes counts on the local
> > > CPU, not the counts of the CPU going away; those counts will be lost.
> > > 
> > > Flush the CPU that is actually going away.
> > > 
> > > Also simplify the code a bit by using mod_memcg_state() and
> > > count_memcg_events() instead of open-coding the upward flush - this is
> > > comparable to how vmstat.c handles hotunplug flushing.
> > 
> > To the whole series: it's really nice to have an accurate stats at
> > non-leaf levels. Just as an illustration: if there are 32 CPUs and
> > 1000 sub-cgroups (which is an absolutely realistic number, because
> > often there are many dying generations of each cgroup), the error
> > margin is 3.9GB. It makes all numbers pretty much random and all
> > possible tests extremely flaky.
> 
> Btw, I was just looking into kmem kselftests failures/flakiness,
> which is caused by exactly this problem: without waiting for the
> finish of dying cgroups reclaim, we can't make any reliable assumptions
> about what to expect from memcg stats.

Good point about the selftests. I gave them a shot, and indeed this
series makes test_kmem work again:

vanilla:
ok 1 test_kmem_basic
memory.current = 8810496
slab + anon + file + kernel_stack = 17074568
slab = 6101384
anon = 946176
file = 0
kernel_stack = 10027008
not ok 2 test_kmem_memcg_deletion
ok 3 test_kmem_proc_kpagecgroup
ok 4 test_kmem_kernel_stacks
ok 5 test_kmem_dead_cgroups
ok 6 test_percpu_basic

patched:
ok 1 test_kmem_basic
ok 2 test_kmem_memcg_deletion
ok 3 test_kmem_proc_kpagecgroup
ok 4 test_kmem_kernel_stacks
ok 5 test_kmem_dead_cgroups
ok 6 test_percpu_basic

It even passes with a reduced margin in the patched kernel, since the
percpu drift - which this test already tried to account for - is now
only on the page_counter side (whereas memory.stat is always precise).

I'm going to include that data in the v2 changelog, as well as a patch
to update test_kmem.c to the more stringent error tolerances.

> So looking forward to have this patchset merged!

Thanks
