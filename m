From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v4 05/25] memcg: Always free struct memcg through schedule_work()
Date: Wed, 20 Jun 2012 12:40:11 +0400
Message-ID: <4FE18C6B.1020503@parallels.com>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-6-git-send-email-glommer@parallels.com> <4FDF1A0D.6080204@jp.fujitsu.com> <4FDF1AAE.4080209@parallels.com> <alpine.LFD.2.02.1206201031150.2989@tux.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.02.1206201031150.2989-XMdqyYT0w3YmYvmMESoHnA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Cristoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

On 06/20/2012 11:32 AM, Pekka Enberg wrote:
>> >Maybe Pekka can merge the current -mm with his tree?
> I first want to have a stable base from Christoph's "common slab" series
> before I am comfortable with going forward with the memcg parts.
>
> Feel free to push forward any preparational patches to the slab
> allocators, though.
>
> 			Pekka

Kame and others:

If you are already comfortable with the general shape of the series, it 
would do me good to do the same with the memcg preparation patches, so 
we have less code to review and merge in the next window.

They are:

     memcg: Make it possible to use the stock for more than one page.
     memcg: Reclaim when more than one page needed.
     memcg: change defines to an enum

Do you see any value in merging them now ?

