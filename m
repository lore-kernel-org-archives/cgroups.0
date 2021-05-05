From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v3 2/2] mm: memcg/slab: Create a new set of
 kmalloc-cg-<n> caches
Date: Wed, 5 May 2021 11:32:54 -0700
Message-ID: <YJLk1tmDeGed58yr@carbon.dhcp.thefacebook.com>
References: <20210505154613.17214-1-longman@redhat.com>
 <20210505154613.17214-3-longman@redhat.com>
 <YJLWN6bNBYyKRPEN@carbon.DHCP.thefacebook.com>
 <235f45b4-2d99-f32d-ac2b-18b59fea5a25@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=c9/kI84saANNmtSvVMDkjOfEMUQKQ6R+xzsfRWOt7mw=;
 b=ibj5NT1WAXdStd2dxB9xC8k9GXecsw5i4kF0lGRSYeSG1I2QJ07caRYjmQuzADhEQqhS
 VX1tP3fhz647O6c4Rti7b5WgSWj6iIVXmCI5XPdad6e4b6ZL15sa+EKc4SUx8+/YDFaX
 O4lIYxbld0XmoaD7QFdx/HXZleWG/CGlHck= 
Content-Disposition: inline
In-Reply-To: <235f45b4-2d99-f32d-ac2b-18b59fea5a25-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, May 05, 2021 at 08:02:06PM +0200, Vlastimil Babka wrote:
> On 5/5/21 7:30 PM, Roman Gushchin wrote:
> > On Wed, May 05, 2021 at 11:46:13AM -0400, Waiman Long wrote:
> >> 
> >> With this change, all the objcg pointer array objects will come from
> >> KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
> >> both the recursive kfree() problem and non-freeable slab problem are
> >> gone. Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no longer
> >> have mixed accounted and unaccounted objects, this will slightly reduce
> >> the number of objcg pointer arrays that need to be allocated and save
> >> a bit of memory.
> > 
> > Unfortunately the positive effect of this change will be likely
> > reversed by a lower utilization due to a larger number of caches.
> > 
> > Btw, I wonder if we also need a change in the slab caches merging procedure?
> > KMALLOC_NORMAL caches should not be merged with caches which can potentially
> > include accounted objects.
> 
> Good point. But looks like kmalloc* caches are extempt from all merging in
> create_boot_cache() via
> 
> 	s->refcount = -1;       /* Exempt from merging for now */

Wait, s->refcount is adjusted to 1 in create_kmalloc_cache() after calling
into create_boot_cache?

It means they are not exempt actually.
