From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix idr_preload usage
Date: Mon, 3 Aug 2015 10:48:18 -0400
Message-ID: <20150803144818.GD32599@mtj.duckdns.org>
References: <1438605146-23962-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jXUEu98PXfeFAEPaLy47s+S9Mid/C/KYBdObupVmwGM=;
        b=DC1OizWzz/LogFyhY8v6pG3JxYvp8dZ8qVqFpeAFPnJVqLWbnfpl7RqrPijyP+msXD
         T1pPCzhaV7FuzKMBTuIRTYRGfVU/xykCDQ3Dmnfsvp3mUYZctQhavrVryJpFb6YqJcBO
         i781Ri+99biOqE9TI2sXkKK/g71Pc+6TPqOcP9wHldydSfnn8bz3XEHe2uKBIKOhXEOH
         LQTVb7AVMIJNqHVYt2bDw+ddaEXD1miPaAei4qzmOYIGIWkGM1pMkbO6t+0KysscZWJB
         DOTGrbJwnk3yduT2XINPs4CR1eQx3Q0uBjhd5k1PI3/kfqXP2meBZsX/FlUlYYX5gxtO
         e34w==
Content-Disposition: inline
In-Reply-To: <1438605146-23962-1-git-send-email-vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 03, 2015 at 03:32:26PM +0300, Vladimir Davydov wrote:
> It does not make much sense to call idr_preload with the same gfp mask
> as the following idr_alloc, but this is what we do in cgroup_idr_alloc.
> This patch fixes the idr_preload usage by making cgroup_idr_alloc call
> idr_alloc w/o __GFP_WAIT. Since it is now safe to call cgroup_idr_alloc
> with GFP_KERNEL, the patch also fixes all its callers appropriately.

Applied to cgroup/for-4.3.

Thanks.

-- 
tejun
