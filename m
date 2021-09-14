From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] blk-cgroup: fix UAF by grabbing blkcg lock before
 destroying blkg pd
Date: Tue, 14 Sep 2021 06:20:07 -1000
Message-ID: <YUDLt9uBNLhWL6Gt@slm.duckdns.org>
References: <20210914042605.3260596-1-lijinlin3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1FvZRHk3SBPfHYet08WVNMbl9U9iubGfahKVS5kswgA=;
        b=jc4VIL8AuuvPriT9n13HDBh5j6ZGD7KA06UejblD3JhzLbO5fAnpivCvtJQ2E37qHo
         jUQwIYB23+YszX35Yk3eoM8QSBlZUFfpdQgPflf528djjT7wwouIiSERkL78Chl1UXcN
         g+QqwKq2pRC+SGgCbnl/HwPF7q5FScmOqEhIBLgtiBm/rspHX2g3SKI/FAMPooYMfoTb
         0lgosZAGSu2CrpN93F4J+d5UqiABgG6FE0dwOIg2dFhmlOxW2krtwQ0Vd/Uoio3dbx3W
         zYD8MsBZwc0rp9/FetxAIjvq0xbr5Jc2xuDyNDlplDip0VgzIySG2AGYfmqhVUNx8hs5
         UhgQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210914042605.3260596-1-lijinlin3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Jinlin <lijinlin3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linfeilong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, louhongxiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue, Sep 14, 2021 at 12:26:05PM +0800, Li Jinlin wrote:
...
> Fix by garbbing the matching blkcg lock before trying to
> destroy blkg policy data.
> 
> Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Li Jinlin <lijinlin3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
