From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/5] cgroup: fix broken css_has_online_children()
Date: Tue, 17 Jun 2014 15:26:21 -0400
Message-ID: <20140617192621.GO31819@htj.dyndns.org>
References: <53994943.60703@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=KiqizsuaM+sH2YKSOY0SZx3qjmhhQegGmzzxfKVWEIw=;
        b=q7gBGclKVliTTvPLQglUv34iKq8dvHhThkPMq0gLnpN1OONEwutTZTPMeKBSDhxg1a
         AKEEj0rvEt+6SGqBdpCgWUtn+Erl9/22B4llQ5tkWhHiJHu+HzVnJL14Hxklda/yIpnd
         uEh6P8gi4FA1ADsxIAmk6RMIrt0q3KZ8H5iYMPoxskyBKQHYjCZ0SMVIW7RC8vcCzsW5
         P7xm058vUeiJufUmFO8kaBcpC7LJcpNj5h01qzVZfsToI9cISs3xp6Ua8LT6h8JWzv+L
         Y9GXb9oRv5gohB1xXHp3ng+gGHZgw3RL+HpkFLCoKpUUKLFGFZs38l3TWOpirFLboIhC
         7hbQ==
Content-Disposition: inline
In-Reply-To: <53994943.60703-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jun 12, 2014 at 02:31:31PM +0800, Li Zefan wrote:
> After running:
> 
>   # mount -t cgroup cpu xxx /cgroup && mkdir /cgroup/sub && \
>     rmdir /cgroup/sub && umount /cgroup
> 
> I found the cgroup root still existed:
> 
>   # cat /proc/cgroups
>   #subsys_name    hierarchy       num_cgroups     enabled
>   cpuset  0       1       1
>   cpu     1       1       1
>   ...
> 
> It turned out css_has_online_children() is broken.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.16-fixes.

Thanks.

-- 
tejun
