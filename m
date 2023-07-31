From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: minor cleanup for cgroup_local_stat_show()
Date: Mon, 31 Jul 2023 13:47:33 -1000
Message-ID: <ZMhIFUsxEtA_B781@slm.duckdns.org>
References: <20230723031932.3152951-1-linmiaohe@huawei.com>
 <ZMBERCXR27X_gRAt@slm.duckdns.org>
 <ec3df402-7681-3d0c-b9ce-d50eb7383b1e@huawei.com>
 <719a19c4-3be5-2260-7349-b3f1bb774f4f@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690847255; x=1691452055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pnW9AbWFmFt7g04hnCtQK/3q2HPpz4D58kd8qqlWGy8=;
        b=nHSUa38jLtoF754EZqXsmmeP3G802kC8NnsHwbOdi2rEqezUHvql9kuR+I6CLk7twK
         bQtsCWDngqUVkGbc+0oXF1lSSA+iYeIQFgfINagZahTQTXLQM7dCRTQgVYrRKc5acVK5
         8BPpIAGo7i7qLc+xPzAkWPz5plZcymfXE124fxLIB9zWXp1Xj6QK625x0h/uSt/pQcNv
         SZmeLEfafvDO0F7DNo5mIqqXtM+7Q4cbbIUlrxWaSspBs8a0hH3FgM8pPwTAna0yggSZ
         yhWF9YmBx/y6WZO+eXTcb11yFbLlt6zrf+fdxQiHUwVCNBFNOrPwy/CnbZkQJ05q0kNx
         rvPA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <719a19c4-3be5-2260-7349-b3f1bb774f4f-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 27, 2023 at 07:50:11PM +0800, Miaohe Lin wrote:
> On 2023/7/26 9:06, Miaohe Lin wrote:
> > On 2023/7/26 5:53, Tejun Heo wrote:
> >> On Sun, Jul 23, 2023 at 11:19:32AM +0800, Miaohe Lin wrote:
> >>> Make it under CONFIG_CGROUP_SCHED to rid of __maybe_unused annotation.
> >>> Also put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED as it's only
> >>> called when CONFIG_CGROUP_SCHED. No functional change intended.
> >>>
> >>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>
> >> Patch doesn't apply to cgroup/for-6.6. Can you please respin?
> > 
> > Sure. Will resend the patch based on cgroup/for-6.6.
> 
> The commit "sched: add throttled time stat for throttled children" is still in the linux-next tree. So I think I have
> to wait for it to be merged into cgroup tree first.

You can just send the patch against cgroup/for-6.6 branch. We can sort out
the merge conflicts later.

Thanks.

-- 
tejun
