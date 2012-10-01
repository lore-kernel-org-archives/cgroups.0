From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 09/13] memcg: kmem accounting lifecycle management
Date: Mon, 1 Oct 2012 16:43:05 +0400
Message-ID: <50698FD9.2040808@parallels.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-10-git-send-email-glommer@parallels.com> <20121001121553.GG8622@dhcp22.suse.cz> <50698C97.70703@parallels.com> <20121001123654.GJ8622@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121001123654.GJ8622-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 10/01/2012 04:36 PM, Michal Hocko wrote:
> On Mon 01-10-12 16:29:11, Glauber Costa wrote:
>> On 10/01/2012 04:15 PM, Michal Hocko wrote:
>>> Based on the previous discussions I guess this one will get reworked,
>>> right?
>>>
>>
>> Yes, but most of it stayed. The hierarchy part is gone, but because we
>> will still have kmem pages floating around (potentially), I am still
>> using the mark_dead() trick with the corresponding get when kmem_accounted.
> 
> Is it OK if I hold on with the review of this one until the next
> version?
> 
Of course.

I haven't sent it yet because I also received a lot more feedback for
the slab part (which is expected), and I want to get a least part of
that going before I send it again.
