From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove unused task_cgroup_path()
Date: Mon, 12 Jun 2023 07:06:19 -1000
Message-ID: <ZIdQi6snJNTNg_rH@slm.duckdns.org>
References: <20230610035737.1046651-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686589577; x=1689181577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yr6tGeFntRbSjgBy1Um8qOzjPQOuwFfu/EshJIcUU8E=;
        b=b63VmQfE/KSYmhiH3znSXphnujmx/FetpxWQ880wowk0pLOcAljxR2MwjuPliuX9yK
         cKjUoVhn1+/rsc/pCyavqU15Lhc4Xvctc6323U2scK8Ryaqsc/xQXtBmW6RPyluSTMvT
         sZ+W6EKMDmf7g12ABUoL8G5rYrd0oUlGDo5/GDaNX+XOUK61b9BSDahb61M4wIpmdc3C
         xbrKii+DbbcBtjBDHqnAS6drcRUBs1znPq/Gi/E9pfwkFd2Ltmz7rst7vo/9rVPGD4fP
         02XxGLXQPgBljEjUoDT1jUCYCrkBqkifRHstNqBy4/4lEjCL/bQx78Vlrs4fmODI+rB8
         82gg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230610035737.1046651-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 10, 2023 at 11:57:37AM +0800, Miaohe Lin wrote:
> task_cgroup_path() is not used anymore. So remove it.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.5.

Thanks.

-- 
tejun
