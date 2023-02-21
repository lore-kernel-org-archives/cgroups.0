From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Tue, 21 Feb 2023 15:57:54 -0400
Message-ID: <Y/UiQmuVwh2eqrfA@nvidia.com>
References: <Y+0tWZxMUx/NZ3Ne@nvidia.com>
 <Y+3jcw9vo4ml5p0M@dhcp22.suse.cz>
 <Y+4lcq4Fge27TQIn@nvidia.com>
 <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
 <Y/T+pw25oGmKqz1k@nvidia.com>
 <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
 <Y/UEkNn0O65Pfi4e@nvidia.com>
 <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com>
 <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSDreqvyRDCkzqkSyVdaBlUtbcDZ0NNpwoeKOF8yZhU=;
 b=TPECyFzz8YMTKfWSvm800qazbZpvdzhf2S4mOL4dyL6TNK+Yh0dprt0CbNvEzAGnWqC1g8gI24CNorlyE/hDpOdsh+kbCuvbYjZbE49AiWZjUjL9buzLbL3ItZYyQfifom4qtILvDK4UO6kb4gVad1Y+IWLdjGtqxAZwUijTw/H7CYC+1F8qdtiggmgVCmcobHLKY1vggxmztZlceKlgLvF0wUrJdGrphSJTw/YYQmHSfeAbNIy6H5bJJokcZIbsd+nGeI39HWXSeG3vFn+VMmrJjAfguc6ObKmw4mKboAd6QZEVUjnTTyf1ZePQ6zdiR+TR87gy3rRXSy8Jetpm8A==
Content-Disposition: inline
In-Reply-To: <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Yosry Ahmed <yosryahmed@google.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, "Daniel P . Berrange" <berrange@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>

On Tue, Feb 21, 2023 at 09:45:15AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Tue, Feb 21, 2023 at 03:26:33PM -0400, Jason Gunthorpe wrote:
> > On Tue, Feb 21, 2023 at 08:07:13AM -1000, Tejun Heo wrote:
> > > > AFAIK there are few real use cases to establish a pin on MAP_SHARED
> > > > mappings outside your cgroup. However, it is possible, the APIs allow
> > > > it, and for security sandbox purposes we can't allow a process inside
> > > > a cgroup to triger a charge on a different cgroup. That breaks the
> > > > sandbox goal.
> > > 
> > > It seems broken anyway. Please consider the following scenario:
> > 
> > Yes, this is broken like this already today - memcg doesn't work
> > entirely perfectly for MAP_SHARED scenarios, IMHO.
> 
> It is far from perfect but the existing behavior isn't that broken. e.g. in
> the same scenario, without pinning, even if the larger cgroup keeps using
> the same page, the smaller cgroup should be able to evict the pages as they
> are not pinned and the cgroup is under heavy reclaim pressure. The larger
> cgroup will refault them back in and end up owning those pages.
> 
> memcg can't capture the case of the same pages being actively shared by
> multiple cgroups concurrently (I think those cases should be handled by
> pushing them to the common parent as discussed elswhere but that's a
> separate topic) but it can converge when page usage transfers across cgroups
> if needed. Disassociating ownership and pinning will break that in an
> irreversible way.

It is already disassociated - memcg is broken as you describe today
with pin_user_pages().

If you want to fix that, then we need to redefine how memcg works with
pin_user_pages() and I'm open to ideas..

> the owner and pinner disagreeing with each other. At least
> conceptually, the solution is rather straight-forward - whoever pins
> a page should also claim the ownership of it.

If the answer is pinner is owner, then multi-pinners must mean
multi-owner too. We probably can't block multi-pinner without causing
uAPI problems.

You are not wrong on any of these remarks, but this looses sight of
the point - it is take the existing broken RLIMIT scheme and make it
incrementally better by being the same broken scheme just with
cgroups.

If we eventually fix everything so memcg can do multi-pinners/owners
then would it be reasonable to phase out the new pincg at that time?

Jason
