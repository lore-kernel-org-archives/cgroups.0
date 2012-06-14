From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 4/4] make CFLGS_OFF_SLAB visible for all slabs
Date: Thu, 14 Jun 2012 20:01:31 +0400
Message-ID: <4FDA0ADB.2010508@parallels.com>
References: <1339676244-27967-1-git-send-email-glommer@parallels.com> <1339676244-27967-5-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206141019010.32075@router.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1206141019010.32075-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On 06/14/2012 07:19 PM, Christoph Lameter wrote:
> On Thu, 14 Jun 2012, Glauber Costa wrote:
>
>> Since we're now moving towards a unified slab allocator interface,
>> make CFLGS_OFF_SLAB visible to all allocators, even though SLAB keeps
>> being its only users. Also, make the name consistent with the other
>> flags, that start with SLAB_xx.
>
> What is the significance of knowledge about internal slab structures (such
> as the CFGLFS_OFF_SLAB) outside of the allocators?


I want to mask that out in kmem-specific slab creation. Since I am 
copying the original flags, and that flag is embedded in the slab saved 
flags, it will be carried to the new slab if I don't mask it out.

Alternatively to this, I can tweak slab.c to always mask out this at the 
beginning of cache creation, if you so prefer.
