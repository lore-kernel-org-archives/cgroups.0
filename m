From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] rdmacg: fix kernel-doc warnings in rdmacg
Date: Mon, 5 Jun 2023 09:45:47 -1000
Message-ID: <ZH47azG4Cc5fn1vg@slm.duckdns.org>
References: <20230602074456.333840-1-cuigaosheng1@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685994350; x=1688586350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CLJjoRijX39qGK5LPRbYndMR8lqM5lKT2Fd/Bv8D+Tc=;
        b=cXuyf6HNCJJfgVm6i5ADAOZHQYvhVQxixTCWYyskiViNPZlauTUS+ay7hbYMBpAptX
         34MGPT7SP1gW1P5Szb9wF8AhssJsXWaR5Mhsd+wDpZPLWncnpBaI6A2ujyKx1Z6QtizX
         L3RsQVnJQbWPQEv99HiHTDBfXJXRj1U+lfmczjHUPZLCL8NJKOD1CJMOKuvi5keGo2NL
         hUenxwQBPUFYRL562zIa7NBzqBMC7htAaUNZkBknNDyNh9Sfn6H/9tpliwTVrhmacC5m
         poM+xYOpS0VR64Tw7yUX9gzCDY9ErFK0zHOck9hYwTVaCAvvb6el6NmiBmF/Fj3Q0JgB
         pD6Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230602074456.333840-1-cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gaosheng Cui <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 02, 2023 at 03:44:56PM +0800, Gaosheng Cui wrote:
> Fix all kernel-doc warnings in rdmacg:
> 
> kernel/cgroup/rdma.c:209: warning: Function parameter or member 'cg'
> not described in 'rdmacg_uncharge_hierarchy'
> kernel/cgroup/rdma.c:230: warning: Function parameter or member 'cg'
> not described in 'rdmacg_uncharge'
> 
> Signed-off-by: Gaosheng Cui <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.5.

Thanks.

-- 
tejun
