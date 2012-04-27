From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 4/7 v2] memcg: use res_counter_uncharge_until in
 move_parent
Date: Fri, 27 Apr 2012 11:20:18 -0700
Message-ID: <20120427182018.GI26595@google.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
 <4F9A34B2.8080103@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=tlGsMB1MPTG4HI0mAklvv8+iWQ6ZMj5nUBVPPk2U1Ds=;
        b=gsi0nMAXXa6V68p5zMP+uFFZpRF+/zJfB+gD54390BzcThRb0jZ4Gh8ZIwqK2ePXlW
         mkuHFoZpb/F5ynCnIQfY3SP/JCeuXNZDu0B1taGC1oSzN4VChWnH3CESvw+1xYLXOtYI
         Ro692E3vyzdhUmKE6aMd7t+DuYmCLrorezbmrgp80lTlHt/AMYbKXAYi40H8sn3B7Wc8
         YDCRi4w2ld6yzWsJnTXD51eP/E15tkIyYjVh+zwj9QIv7qOxabbRQepH3aeGLFOAok98
         Nz9jQigX4Y3Q1u3AUD7/NR4TPsChJ4PStkNZh/P+wUH3k/HjM9Ief8ZAX8cTiPq2qXcB
         kySg==
Content-Disposition: inline
In-Reply-To: <4F9A34B2.8080103-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, Apr 27, 2012 at 02:54:58PM +0900, KAMEZAWA Hiroyuki wrote:
> By using res_counter_uncharge_until(), we can avoid 
> unnecessary charging.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
>  mm/memcontrol.c |   63 ++++++++++++++++++++++++++++++++++++------------------
>  1 files changed, 42 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 613bb15..ed53d64 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2420,6 +2420,24 @@ static void __mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
>  }
>  
>  /*
> + * Cancel chages in this cgroup....doesn't propagates to parent cgroup.

             ^typo                                     ^ unnecessary s

-- 
tejun
