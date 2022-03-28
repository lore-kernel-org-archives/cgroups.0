From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: remove unneeded nr_scanned
Date: Mon, 28 Mar 2022 11:36:54 -0700
Message-ID: <YkIARkqHjA2EOjTZ@carbon.dhcp.thefacebook.com>
References: <20220328114144.53389-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648492622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h9MsA+GclozGfTkyz42oHeJp6VqOMhntLWNp3G32vsA=;
        b=UJbaFFfOQmizKMVOaoqPioI2HGGuGtUMezMSWJbhRnuH1/3nZZnfcB29o8OE+4UDzrn3Gl
        JsLwZZdLt4ZDZ49HMbnXHrHNVXh9xHJf/PH759+MEmoofsgzw16STYBz9FT8RUNZOkf7cK
        KGDBEBSa3xTF2jqt4u+RmzC64sP3uRw=
Content-Disposition: inline
In-Reply-To: <20220328114144.53389-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 28, 2022 at 07:41:44PM +0800, Miaohe Lin wrote:
> The local variable nr_scanned is unneeded as mem_cgroup_soft_reclaim always
> does *total_scanned += nr_scanned. So we can pass total_scanned directly to
> the mem_cgroup_soft_reclaim to simplify the code and save some cpu cycles
> of adding nr_scanned to total_scanned.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks!
