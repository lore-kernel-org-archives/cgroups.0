From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: Fork bomb limitation in memcg WAS: Re: [PATCH 00/11] kmem controller
 for memcg: stripped down version
Date: Wed, 8 Aug 2012 18:15:42 +0400
Message-ID: <5022748E.5040809@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <20120625162745.eabe4f03.akpm@linux-foundation.org> <4FE9621D.2050002@parallels.com> <20120626145539.eeeab909.akpm@linux-foundation.org> <4FEAD260.4000603@parallels.com> <alpine.DEB.2.00.1206271233080.22162@chino.kir.corp.google.com> <4FEC1D63.6000903@parallels.com> <20120628152540.cc13a735.akpm@linux-foundation.org> <50211F3D.2000008@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50211F3D.2000008-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Kir Kolyshkin <kir-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On 08/07/2012 05:59 PM, Glauber Costa wrote:
> On 06/29/2012 02:25 AM, Andrew Morton wrote:
>> On Thu, 28 Jun 2012 13:01:23 +0400
>> Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>>
>>>
>>> ...
>>>
>>
>> OK, that all sounds convincing ;) Please summarise and capture this
>> discussion in the [patch 0/n] changelog so we (or others) don't have to
>> go through this all again.  And let's remember this in the next
>> patchset!
>>
>>> Last, but not least, note that it is totally within my interests to
>>> merge the slab tracking as fast as we can. it'll be a matter of going
>>> back to it, and agreeing in the final form.
>>
>> Yes, I'd very much like to have the whole slab implementation in a
>> reasonably mature state before proceeding too far with this base
>> patchset.
>>
> So, that was posted separately as well.
> 
> Although there is a thing to fix here and there - all of them I am
> working on already - I believe that to be mature enough.
> 
> Do you have any comments on that? Would you be willing to take this
> first part (modified with the comments on this thread itself) and let it
> start sitting in the tree?
> 

In the mean time, for any interested parties, I've set up a tree at:

git://github.com/glommer/linux.git

branches kmemcg-slab and kmemcg-stack

Intended to be a throw-away tree.



