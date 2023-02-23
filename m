From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Wed, 22 Feb 2023 21:53:56 -0400
Message-ID: <Y/bHNO7A8T3QQ5T+@nvidia.com>
References: <Y/T+pw25oGmKqz1k@nvidia.com>
 <Y/T/bkcYc9Krw4rE@slm.duckdns.org>
 <Y/UEkNn0O65Pfi4e@nvidia.com>
 <Y/UIURDjR9pv+gzx@slm.duckdns.org>
 <Y/Ua6VcNe/DFh7X4@nvidia.com>
 <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
 <Y/UiQmuVwh2eqrfA@nvidia.com>
 <87o7pmnd0p.fsf@nvidia.com>
 <Y/YRJNwwvqp7nKKt@nvidia.com>
 <87k009nvnr.fsf@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VSvVJDLYm3I4TVhgPviimt37DwUtMl1cULco1UlQLk=;
 b=bOpQo3Od3xaxzT3jCmjSOW/RN+6DFEuTM3Ci9nqjb1X/7uqP5NZ5Hk3wJqWoFefnFXgzPl1VaK5ywKXgi74Org5nDJctbCjKAT2ZEMV0ohWoPYHSHP2HA76wKJevWlrbwLprTkoX/4vkukRnGfmq1Z0cOH+ciYdwNSweQ1Fb9YZfsYiAgug4cocqZESYjt6pRzaid3w6/ETaSg8vWeMFW9HNf5MuXSLVQ9PZCHa4a3rG26s1QNlbbbr7n2cRvKQlP8azVXzJatOJqO4Uh3Wg6+CP4zCncGi4svAWH7Uo5XZULbu3c/SelWXoitcsLYaww056uk170umjF9b9cM+1lQ==
Content-Disposition: inline
In-Reply-To: <87k009nvnr.fsf-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Feb 23, 2023 at 09:59:35AM +1100, Alistair Popple wrote:
> 
> Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> writes:
> 
> > On Wed, Feb 22, 2023 at 10:38:25PM +1100, Alistair Popple wrote:
> >> When a driver unpins a page we scan the pinners list and assign
> >> ownership to the next driver pinning the page by updating memcg_data and
> >> removing the vm_account from the list.
> >
> > I don't see how this works with just the data structure you outlined??
> > Every unique page needs its own list_head in the vm_account, it is
> > doable just incredibly costly.
> 
> The idea was every driver already needs to allocate a pages array to
> pass to pin_user_pages(), and by necessity drivers have to keep a
> reference to the contents of that in one form or another. So
> conceptually the equivalent of:
> 
> struct vm_account {
>        struct list_head possible_pinners;
>        struct mem_cgroup *memcg;
>        struct pages **pages;
>        [...]
> };
> 
> Unpinnig involves finding a new owner by traversing the list of
> page->memcg_data->possible_pinners and iterating over *pages[] to figure
> out if that vm_account actually has this page pinned or not and could
> own it.

Oh, you are focusing on Tejun's DOS scenario. 

The DOS problem is to prevent a pin users in cgroup A from keeping
memory charged to cgroup B that it isn't using any more.

cgroup B doesn't need to be pinning the memory, it could just be
normal VMAs and "isn't using anymore" means it has unmapped all the
VMAs.

Solving that problem means figuring out when every cgroup stops using
the memory - pinning or not. That seems to be very costly.

AFAIK this problem also already exists today as the memcg of a page
doesn't change while it is pinned. So maybe we don't need to address
it.

Arguably the pins are not the problem. If we want to treat the pin
like allocation then we simply charge the non-owning memcg's for the
pin as though it was an allocation. Eg go over every page and if the
owning memcg is not the current memcg then charge the current memcg
for an allocation of the MAP_SHARED memory. Undoing this is trivial
enoug.

This doesn't fix the DOS problem but it does sort of harmonize the pin
accounting with the memcg by multi-accounting every pin of a
MAP_SHARED page.

The other drawback is that this isn't the same thing as the current
rlimit. The rlimit is largely restricting the creation of unmovable
memory.

Though, AFAICT memcg seems to bundle unmovable memory (eg GFP_KERNEL)
along with movable user pages so it would be self-consistent.

I'm unclear if this is OK for libvirt..

> Agree this is costly though. And I don't think all drivers keep the
> array around so "iterating over *pages[]" may need to be a callback.

I think searching lists of pages is not reasonable. Things like VFIO &
KVM use cases effectively pin 90% of all system memory, that is
potentially TB of page lists that might need linear searching!

Jason
