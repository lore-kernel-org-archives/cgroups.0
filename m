From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Thu, 19 May 2022 13:02:58 +0200
Message-ID: <YoYj4sLJfGke5IGT@dhcp22.suse.cz>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652958180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IzXgw0a74dIiLsfsgpX507bbTu4KgqdYCg8XDacIqHw=;
        b=p6eg7yMBMmZI2a2JOGfaZfOHUgEOzr0pYRni8ATdIoJyZhzflN3bAt8hpReN3HD8VnJ9qZ
        EOq6iF/jJF96GHnLG2V2n1ZpPZntJNxjElw0yW8Q29RCIQOzEe40LqFOlEuEEvCAxCHZz+
        iR5Y6RjT79txDZA425cVGDkX0PR58WM=
Content-Disposition: inline
In-Reply-To: <20220518223815.809858-1-vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vaibhav Jain <vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Aneesh Kumar K . V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu 19-05-22 04:08:15, Vaibhav Jain wrote:
> [1] Provides a way for user-space to trigger proactive reclaim by introducing
> a write-only memcg file 'memory.reclaim'. However reclaim stats like number
> of pages scanned and reclaimed is still not directly available to the
> user-space.
> 
> This patch proposes to extend [1] to make the memcg file 'memory.reclaim'
> readable which returns the number of pages scanned / reclaimed during the
> reclaim process from 'struct vmpressure' associated with each memcg. This should
> let user-space asses how successful proactive reclaim triggered from memcg
> 'memory.reclaim' was ?
> 
> With the patch following command flow is expected:
> 
>  # echo "1M" > memory.reclaim
> 
>  # cat memory.reclaim
>    scanned 76
>    reclaimed 32

Why cannot you use memory.stat? Sure it would require to iterate over
the reclaimed hierarchy but the information about scanned and reclaimed
pages as well as other potentially useful stats is there.
-- 
Michal Hocko
SUSE Labs
