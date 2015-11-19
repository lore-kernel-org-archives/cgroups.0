From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 6/6] Account certain kmem allocations to memcg
Date: Thu, 19 Nov 2015 14:12:29 -0500
Message-ID: <20151119191229.GF3941@cmpxchg.org>
References: <cover.1447172835.git.vdavydov@virtuozzo.com>
 <3af491b9661b97708ec38e9f9a4f0cccb69ade5c.1447172835.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3af491b9661b97708ec38e9f9a4f0cccb69ade5c.1447172835.git.vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 10, 2015 at 09:34:07PM +0300, Vladimir Davydov wrote:
> This patch marks those kmem allocations that are known to be easily
> triggered from userspace as __GFP_ACCOUNT/SLAB_ACCOUNT, which makes them
> accounted to memcg. For the list, see below:
> 
>  - threadinfo
>  - task_struct
>  - task_delay_info
>  - pid
>  - cred
>  - mm_struct
>  - vm_area_struct and vm_region (nommu)
>  - anon_vma and anon_vma_chain
>  - signal_struct
>  - sighand_struct
>  - fs_struct
>  - files_struct
>  - fdtable and fdtable->full_fds_bits
>  - dentry and external_name
>  - inode for all filesystems. This is the most tedious part, because
>    most filesystems overwrite the alloc_inode method.
> 
> The list is by far not complete, so feel free to add more objects.
> Nevertheless, it should be close to "account everything" approach and
> keep most workloads within bounds. Malevolent users will be able to
> breach the limit, but this was possible even with the former "account
> everything" approach (simply because it did not account everything in
> fact).
> 
> Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Thanks for doing that work, Vladimir. It looks reasonable to me.

We can update the list as we go along and testing reveals more things
that need to be considered. As far as malicious users go, I agree that
we can not make this bullet proof, and so we shouldn't aim for that.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
