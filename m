From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Wed, 27 Mar 2013 09:15:27 -0700
Message-ID: <20130327161527.GA7395@htj.dyndns.org>
References: <1364373399-17397-1-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=IFdjvTEUwfiUxMTFNIOjlerRaCzotB5y+0nlxzi+Fwc=;
        b=e2Vrhp6NE4+qpSsFe9Ov3ACoSDZyyXin364F7G87YGew7B0igMzevQVefZYXu2gnRg
         7Ej8VtLs5jQYx5716kKmxKDA/k1jXcZ9+lwAdOoUbCC9stwmi1GC3PhPQg6xhyh0UqKI
         SRrKQ/zG2UpAQ7E74x4qAcsVHgteZRGOXxuYfblVzt0r2iKEiV1uolLlc7J+A068b86s
         bve2csoi95zKFQJjWQcfeMRwXc0Gy9VgWM/e8VEanmsNHwLrfV+KDUCVkGpBx88TAUQd
         BAyGnnUUEShTpKtGZrAlxOnxq1yDmzo8qRNbuBw3Vqs8WjJuvjWdKRgefu6W+pRGk0FK
         2voQ==
Content-Disposition: inline
In-Reply-To: <1364373399-17397-1-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 27, 2013 at 09:36:39AM +0100, Michal Hocko wrote:
> +/*
> + * Called with memcg_cache_mutex held
> + */
>  static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
>  					 struct kmem_cache *s)

Maybe the name could signify it's part of memcg?

Thanks.

-- 
tejun
