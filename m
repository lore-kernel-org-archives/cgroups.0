From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge
 infrastructure
Date: Wed, 30 May 2012 14:17:09 +0200
Message-ID: <20120530121706.GB25094@somewhere.redhat.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
 <1337951028-3427-17-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=SZfwRlUNN/nSRr10HN/7+ka8ee9/RcUUWKZ2gLWMLf0=;
        b=NROPiAy6X0BltXPhDLg3B5+UluDqWX7EB9dMdYlzAZ7q6ScupgFMD7kLKX/7k83F9U
         /975xUZ9+Bhx+SIrBLDA7/tE7PPpxGqOrmum+Ev7JqQz+oD4XR9LIGTOfUEJpsSE+ZTh
         6ajp00lyRMBHMDMnc5W9SiFD3lno6qiGbcyVfgXaXZ2okt7U1dcnrJunfnwjOx7Zk0to
         AauYwalfqwQiPKvpnBqfS0psPmXNBdirpqu21QE3oR6HKQOu4AkSOX35J+BoohrVUG8S
         lxjii2+gVX7wKAdl3OWRBnXH5jYDBwcK0NpjoF8p9ebhqnKyn/HHyffOhzkG3Q4xTrVJ
         Iggg==
Content-Disposition: inline
In-Reply-To: <1337951028-3427-17-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Fri, May 25, 2012 at 05:03:36PM +0400, Glauber Costa wrote:
>  #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
> +static __always_inline struct kmem_cache *
> +mem_cgroup_get_kmem_cache(struct kmem_cache *cachep, gfp_t gfp)
> +{
> +	if (!mem_cgroup_kmem_on)
> +		return cachep;
> +	if (!current->mm)
> +		return cachep;
> +	if (in_interrupt())
> +		return cachep;

Does that mean interrupts are kept out of accounting?
