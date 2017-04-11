From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: avoid attaching a cgroup root to two different
 superblocks
Date: Tue, 11 Apr 2017 09:01:23 +0900
Message-ID: <20170411000123.GC28603@wtj.duckdns.org>
References: <58E7532B.4030505@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WCtaESlswu0AjC1TdRgW5yFTcw0l2dQ8s0gq9C+NRjA=;
        b=Yu8WlkHYEItUY5iGPcCgnCo8y0oWTZRTIOv74U5WrJWTpO7bRI/uADA1xqfqGJEnS/
         RKWL6P3pWaj8r9QMuF6KRxYm2Kzhs/k8h6QOmavNQnHWQncbf+RtVcJxNQgzEfpA4HWj
         zSO2JioXub81AZE90FQwlrQsItm3iwee/97BzY5074JgNG6vbPrWZbtZSp+weQSSC9Hy
         PqBnV4F4hAJNfkD078/2gPnnqxrIwHNldj9PBjckrUqlSKoJhpheA2qNl1H6t8BcvIbd
         d+0HLVMZmU7KASVX8XUl29Amim4e/+GHvGajLxuYvGLdm35PTysM+GR5UCOb4TSZ1wMe
         +d3Q==
Content-Disposition: inline
In-Reply-To: <58E7532B.4030505-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Apr 07, 2017 at 04:51:55PM +0800, Zefan Li wrote:
> We end up using the same cgroup root for two different superblocks,
> so percpu_ref_kill() will be called twice on the same root when the
> two superblocks are destroyed.
> 
> We should fix to make sure the superblock pinning is really successful.
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.16+
> Reported-by: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.11-fixes.

Thanks.

-- 
tejun
