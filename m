From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] psi: dont alloc memory for psi by default
Date: Tue, 7 Jun 2022 07:12:22 -1000
Message-ID: <Yp+G9o2wuJNfLuLk@slm.duckdns.org>
References: <20220526122656.256274-1-chenwandun@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KLGsBB+R+Y7B7KHGHWSxqZCFvRmylkKZbWB3sA14MH0=;
        b=oLvveGNDVWzqyzP67UJA4WVF9pRh7nH3lgY7otES74HwEqlpsHB2KuZ73+XbuTnCG3
         NQ0W4JcSrDbByxyqCSz5HcmIxSIhE+/6k4jTxOnoHZrf5frvi3VWiE5cnv68GWllEDaE
         /JaT35fAp+rhmFa9SnKCYlXe4HyWRnYlwAoFSrPib4PZQidKpNLVZPjfdQTwbGOjPGyg
         U/4wWGgbim+Dw47QFdLJHfYaWe2OgndP8vp9NbX00eP+SEdbgFn94eB7wuARP8te7BEE
         ihq3Cw1VCttarncMGtOKyi9Uw7SONKrvAQegMoFP7XAopWPALVkixmmK2h9s/hzVkgsw
         AWpA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220526122656.256274-1-chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 26, 2022 at 08:26:56PM +0800, Chen Wandun wrote:
> Memory about struct psi_group is allocated by default for
> each cgroup even if psi_disabled is true, in this case, these
> allocated memory is waste, so alloc memory for struct psi_group
> only when psi_disabled is false.
> 
> Signed-off-by: Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.20.

Thanks.

-- 
tejun
