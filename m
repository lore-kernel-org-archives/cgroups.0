From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: fix: Uninitialized variable ret.
Date: Tue, 5 Jan 2021 12:03:18 +0100
Message-ID: <1d9b6d7c-097d-d6c3-82e5-a46077f3ce44@redhat.com>
References: <1609311551-97108-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609844606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2AWR0WkhRJ4TUcyCLZNXdv1ehusPcAteLrZxeB8wrTE=;
        b=EBAkIHu842/nTr2LUrnMZNzip7KWhG2f+BaA4p3ag4AN92iRz9BHml2IG9qHSQcjx7LyG9
        dmSPSXY5MaYmtKPVslIn/99lKc/8NeYXgtwX1cRG8ZJ3IRXqJSaVq40gxmiaa2mMDXHPWk
        2NwVtsK17JlapChpuQUcV1fRAjyMu9M=
In-Reply-To: <1609311551-97108-1-git-send-email-abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: YANG LI <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 30.12.20 07:59, YANG LI wrote:
> The ret is being used but it isn't being initialized,
> need to assign a value to it, like 0.
> 
> Signed-off-by: YANG LI <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Reported-by: Abaci <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 605f671..15ba17d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3366,7 +3366,7 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
>  {
>  	bool enlarge = false;
>  	bool drained = false;
> -	int ret;
> +	int ret = 0;
>  	bool limits_invariant;
>  	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
>  
> 

Before every "break" in the loop, we have a "ret = ". The loop runs at
least once.

Either I am missing something important, or that patch claims something
that does not hold - at least upstream.

-- 
Thanks,

David / dhildenb

