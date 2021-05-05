From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v4 2/3] mm: memcg/slab: Create a new set of
 kmalloc-cg-<n> caches
Date: Wed, 5 May 2021 13:37:27 -0700
Message-ID: <YJMCB/g8YctqQmlE@carbon.dhcp.thefacebook.com>
References: <20210505200610.13943-1-longman@redhat.com>
 <20210505200610.13943-3-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=v4HyhTw3kOjEOWG+Aw2IiVPkSLyT0I9UxIaA9q26JTM=;
 b=hVnQM25+DkFLSperfoPzBm5IbfUWxgY+j3QmY32cQskiyHWNQYF+eH/4WGCUPylCD4dI
 zV5wN1XFAW6/rxB8RHhX5JpI4EVltyCXWFiCPQvO9LpOu9Xexg0vqQPEnjg7mmZhe6P0
 FXthoXqRsGTj4YD8ovkllEJxywBPRmlPvJM= 
Content-Disposition: inline
In-Reply-To: <20210505200610.13943-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Wed, May 05, 2021 at 04:06:09PM -0400, Waiman Long wrote:
> There are currently two problems in the way the objcg pointer array
> (memcg_data) in the page structure is being allocated and freed.
> 
> On its allocation, it is possible that the allocated objcg pointer
> array comes from the same slab that requires memory accounting. If this
> happens, the slab will never become empty again as there is at least
> one object left (the obj_cgroup array) in the slab.
> 
> When it is freed, the objcg pointer array object may be the last one
> in its slab and hence causes kfree() to be called again. With the
> right workload, the slab cache may be set up in a way that allows the
> recursive kfree() calling loop to nest deep enough to cause a kernel
> stack overflow and panic the system.
> 
> One way to solve this problem is to split the kmalloc-<n> caches
> (KMALLOC_NORMAL) into two separate sets - a new set of kmalloc-<n>
> (KMALLOC_NORMAL) caches for unaccounted objects only and a new set of
> kmalloc-cg-<n> (KMALLOC_CGROUP) caches for accounted objects only. All
> the other caches can still allow a mix of accounted and unaccounted
> objects.
> 
> With this change, all the objcg pointer array objects will come from
> KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
> both the recursive kfree() problem and non-freeable slab problem are
> gone.
> 
> Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no longer have
> mixed accounted and unaccounted objects, this will slightly reduce the
> number of objcg pointer arrays that need to be allocated and save a bit
> of memory. On the other hand, creating a new set of kmalloc caches does
> have the effect of reducing cache utilization. So it is properly a wash.
> 
> The new KMALLOC_CGROUP is added between KMALLOC_NORMAL and
> KMALLOC_RECLAIM so that the first for loop in create_kmalloc_caches()
> will include the newly added caches without change.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Waiman Long <longman@redhat.com>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>

Acked-by: Roman Gushchin <guro@fb.com>
