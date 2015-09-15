From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] memcg: punt high overage reclaim to
 return-to-userland path
Date: Tue, 15 Sep 2015 09:47:24 +0200
Message-ID: <20150915074724.GE2858@cmpxchg.org>
References: <20150913185940.GA25369@htj.duckdns.org>
 <20150913190008.GB25369@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150913190008.GB25369-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sun, Sep 13, 2015 at 03:00:08PM -0400, Tejun Heo wrote:
> Currently, try_charge() tries to reclaim memory synchronously when the
> high limit is breached; however, if the allocation doesn't have
> __GFP_WAIT, synchronous reclaim is skipped.  If a process performs
> only speculative allocations, it can blow way past the high limit.
> This is actually easily reproducible by simply doing "find /".
> slab/slub allocator tries speculative allocations first, so as long as
> there's memory which can be consumed without blocking, it can keep
> allocating memory regardless of the high limit.
> 
> This patch makes try_charge() always punt the over-high reclaim to the
> return-to-userland path.  If try_charge() detects that high limit is
> breached, it adds the overage to current->memcg_nr_pages_over_high and
> schedules execution of mem_cgroup_handle_over_high() which performs
> synchronous reclaim from the return-to-userland path.

Why can't we simply fail NOWAIT allocations when the high limit is
breached? We do the same for the max limit.

As I see it, NOWAIT allocations are speculative attempts on available
memory. We should be able to just fail them and have somebody that is
allowed to reclaim try again, just like with the max limit.
