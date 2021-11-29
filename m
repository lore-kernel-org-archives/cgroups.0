From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Relocate mod_objcg_mlstate(), get_obj_stock()
 and put_obj_stock()
Date: Mon, 29 Nov 2021 10:01:45 -0800
Message-ID: <YaUViaGjXgoLGjUq@carbon.dhcp.thefacebook.com>
References: <20211129161140.306488-1-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=E6EXu5NsV9SHRzKySPr0Q0eWkJIFIkz0BNpEbQ0vjvw=;
 b=oLAfzOgimeuOJx951nMpPaa2eBhew1nYU0eeCLpP+rIPijeVoRCduUfKBAyEqlbHTcSw
 vJEyvjkMsgddMKyMItztoH1JWpsRWKmauJVFq3HhNKCBVJUgARnNQug0UHM7gELl1knR
 HmwvOpvX1dj1s+jmW5MnaYBq9kkOjar84ns= 
Content-Disposition: inline
In-Reply-To: <20211129161140.306488-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Mon, Nov 29, 2021 at 11:11:40AM -0500, Waiman Long wrote:
> All the calls to mod_objcg_mlstate(), get_obj_stock() and put_obj_stock()
> are done by functions defined within the same "#ifdef CONFIG_MEMCG_KMEM"
> compilation block. When CONFIG_MEMCG_KMEM isn't defined, the following
> compilation warnings will be issued [1] and [2].
> 
>   mm/memcontrol.c:785:20: warning: unused function 'mod_objcg_mlstate'
>   mm/memcontrol.c:2113:33: warning: unused function 'get_obj_stock'
> 
> Fix these warning by moving those functions to under the same
> CONFIG_MEMCG_KMEM compilation block. There is no functional change.
> 
> [1] https://lore.kernel.org/lkml/202111272014.WOYNLUV6-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
> [2] https://lore.kernel.org/lkml/202111280551.LXsWYt1T-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
> 
> Fixes: 559271146efc ("mm/memcg: optimize user context object stock access")
> Fixes: 68ac5b3c8db2 ("mm/memcg: cache vmstat data in percpu memcg_stock_pcp")
> Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
