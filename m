From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 13/16] slab: slab-specific propagation changes.
Date: Wed, 19 Sep 2012 11:41:30 +0400
Message-ID: <5059772A.8020402@parallels.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-14-git-send-email-glommer@parallels.com> <00000139da52bc21-06113921-5cf5-42b6-94e3-fe9763e909bc-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00000139da52bc21-06113921-5cf5-42b6-94e3-fe9763e909bc-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 09/18/2012 09:00 PM, Christoph Lameter wrote:
> On Tue, 18 Sep 2012, Glauber Costa wrote:
> 
>> When a parent cache does tune_cpucache, we need to propagate that to the
>> children as well. For that, we unfortunately need to tap into the slab core.
> 
> One of the todo list items for the common stuff is to have actually a
> common kmem_cache structure. If we add a common callback then we could put
> that also into the core.
> 

At this point, I'd like to keep it this way if possible. I agree that it
would be a lot better living in a common location, and I commit to
helping you to move in that direction.

But I see no reason to have this commonization to happen first, as a
pre-requisite for this.
