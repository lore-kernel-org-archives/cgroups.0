From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v4 3/3] mm: memcg/slab: Disable cache merging for
 KMALLOC_NORMAL caches
Date: Wed, 5 May 2021 13:38:44 -0700
Message-ID: <YJMCVPIJyCFfcmiD@carbon.dhcp.thefacebook.com>
References: <20210505200610.13943-1-longman@redhat.com>
 <20210505200610.13943-4-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=RU75SMRO/mtB3tc7C0hCxRd/5hwa1TI5J2uZlWitDXY=;
 b=ZDeaAQ5cJcwjqg/TaH3c73IEx2g2Qnl2MKGjH6RECPbLT0QelamdgPbeNwk0CYQnFkXU
 eymDwbcGwQQwMrtq4V4rx//m6pHjGSpDxOHAF7Z0X2A2aknB8TzMxm4bOUZrLWQ/Dip4
 6qOiQMorutArGrp0/SZrL3D78o8IjeUqMIk= 
Content-Disposition: inline
In-Reply-To: <20210505200610.13943-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, May 05, 2021 at 04:06:10PM -0400, Waiman Long wrote:
> The KMALLOC_NORMAL (kmalloc-<n>) caches are for unaccounted objects only
> when CONFIG_MEMCG_KMEM is enabled. To make sure that this condition
> remains true, we will have to prevent KMALOC_NORMAL caches to merge
> with other kmem caches. This is now done by setting its refcount to -1
> right after its creation.
> 
> Suggested-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
