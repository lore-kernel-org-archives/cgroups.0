From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: remove unneeded header files
Date: Sat, 20 May 2023 16:22:23 -1000
Message-ID: <ZGmAX4SAuIFSMb0E@slm.duckdns.org>
References: <20230520160634.3015106-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684635746; x=1687227746;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SxsO1jnQeNMQfCVBdM+fj9bC1LT6bB0z3BxgK7/4va8=;
        b=fUhUfYRZGUyoGyQnt3YjFerhU+FzVoMUvPBA2IELHYeDNc9kfNactpJzG1rHO9aKQG
         TUNhFbs0WhWSJelvzbooKt+Sg/CpuhUp40KFYTmTse67veeSuzpRTmGqZFa1XZ83wEKD
         hxtIWMYZRk6yVhnvhO107uiawOwM8BONcF0UrpdI+3MpZmhAJ8BqIVtxhlew/QV40NZD
         jSy53c5iYG/Q6V8PHGXG1OQPk7t6ZicYKEQ7vrKEA39sonplqQoyFY9QnbtGLotzACVo
         Yg5179/0v1ti9Ghzdbg2WKjGkZVAdZUI2XloYFAoMvV07sI3bVeHeK6Rii1N3h+ZdlP2
         sABw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230520160634.3015106-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, May 21, 2023 at 12:06:34AM +0800, Miaohe Lin wrote:
> Remove some unnecessary header files. No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.5.

Thanks.

-- 
tejun
