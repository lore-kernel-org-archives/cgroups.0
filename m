From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2] memcg: Fix memcg_kmem_bypass() for remote memcg
 charging
Date: Wed, 13 May 2020 09:05:48 -0400
Message-ID: <20200513130548.GD488426@cmpxchg.org>
References: <e6927a82-949c-bdfd-d717-0a14743c6759@huawei.com>
 <20200513090502.GV29153@dhcp22.suse.cz>
 <76f71776-d049-7407-8574-86b6e9d80704@huawei.com>
 <20200513112905.GX29153@dhcp22.suse.cz>
 <3a721f62-5a66-8bc5-247b-5c8b7c51c555@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h765WvXxpy/Yg+afYA3tB6uLG1cyplu9hQ4hJS3lUyg=;
        b=ia/CbeLy2LUPItZTijdqb67Xr3yrC1V2Akofb2PmxGqinrWI+pOVsawEs0koo6v7Fa
         gCP6bgNNJEK8pRyTYOP+S2zHXdpnEQhx/xzNwQxKsaZBEZnkSIH7UdVoy2YQZri5EE1n
         1j7UD2W0xvkZvdBu3sYJvokZzNFyGc9uIRNg4CtQLgsMria1ifdj8m/cmCJW4rt5tZ6p
         4qDJhpVaz3noeluPwUkuQC4qisHe1BL6VfRkIdks8btyXCVbk4OrpI3Blz75jsmxju5N
         ko+IIc3A4yrdm5EUk5XlGvlfxdtzZWM+Rq7qzozf3HUdBfA4k3DbpgS3nHjRStqTAXeG
         piGw==
Content-Disposition: inline
In-Reply-To: <3a721f62-5a66-8bc5-247b-5c8b7c51c555-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, May 13, 2020 at 07:47:49PM +0800, Zefan Li wrote:
> While trying to use remote memcg charging in an out-of-tree kernel module
> I found it's not working, because the current thread is a workqueue thread.
> 
> As we will probably encounter this issue in the future as the users of
> memalloc_use_memcg() grow, it's better we fix it now.
> 
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
