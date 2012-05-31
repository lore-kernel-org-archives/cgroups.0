From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V7 10/14] hugetlbfs: Add new HugeTLB cgroup
Date: Thu, 31 May 2012 16:01:46 +0200
Message-ID: <20120531140146.GC12809@tiehlicka.suse.cz>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1338388739-22919-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1338388739-22919-11-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 30-05-12 20:08:55, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> This patch implements a new controller that allows us to control HugeTLB
> allocations. The extension allows to limit the HugeTLB usage per control
> group and enforces the controller limit during page fault.  Since HugeTLB
> doesn't support page reclaim, enforcing the limit at page fault time implies
> that, the application will get SIGBUS signal if it tries to access HugeTLB
> pages beyond its limit. This requires the application to know beforehand
> how much HugeTLB pages it would require for its use.

You forgot to mention that the tracking is based on page_cgroup which
is essential IMO. This also means that shadow pages are allocated for
_every_ single page in the system even though only a preallocated huge
pages (their heads to be precise) use them. Please mention that in the
Kconfig help text as well. Users should be aware of that.
The overhead is huge but this might change in future because there is
tendency to merge page_cgroup with struct page.

I would also appreciate if you describe the motivation why is this a
separate controller here in the description.

You are also changing behavior of cgroup_disable slightly. Many users of
distribution kernels are used to disable memory controller (which is
compiled in by default) because of its memory footprint primarily so
they use cgroup_disable=memory boot parameter. Things changed with
this patch because this won't be enough and they have to learn about
hugetlb controller which has to be disabled as well (distributions will
have to compile it in as well).

As I already mentioned earlier I do not see any of these as a show
stopper. If people feel strong that this should be separate because
they need only hugetlb pages tracking without memcg then why not.
It is definitely much better than range tracking proposed at the
beginning.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
