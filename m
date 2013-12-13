From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.14] cgroup: fix fail path in
 cgroup_load_subsys()
Date: Fri, 13 Dec 2013 15:47:57 -0500
Message-ID: <20131213204757.GF27070@htj.dyndns.org>
References: <1386875828-5075-1-git-send-email-vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eaNU2Em6HSKswE1OnpcExNL8lcqYdFJIucV57O9DQh8=;
        b=0hSG+7Ep3xuATJqQkRb2ZiudCQGfMhY1qoDJiPi9Sj840gY2el90bTUJYBzUh+Ghkk
         5jdQKG4jwytn/S/QzybsSrBWg5VnnXypRnOPNFaOAZnWepoKGbilNmT7MJ1hncEaOUUf
         QnXIe8vpY2yvSIWnuxnl8OPHMbSdQvt97OeH6UUCBLvHFCFrLN+o/7qzT1ojRdRdjTNe
         eWDC6VaHVxTIzQM38PTKk4RlwENpiEDTJr5kef3zYF62IOQFESmZpxbyD1NjSLupgw//
         mSiFLVWhRTrrxldtx1ulNTwbzk5yeavOGIVmNZuDG346ZNfXDkEL2Hw0/o63aIn9zVOZ
         gfqg==
Content-Disposition: inline
In-Reply-To: <1386875828-5075-1-git-send-email-vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Dec 12, 2013 at 11:17:08PM +0400, Vladimir Davydov wrote:
> Calling cgroup_unload_subsys() from cgroup_load_subsys() after
> online_css() failure will result in a NULL ptr dereference on attempt to
> offline_css(), because online_css() only assigns css to cgroup on
> success. Let's fix that by skipping calls to offline_css() and
> css_free() in cgroup_unload_subsys() if there is no css, and freeing css
> in cgroup_load_subsys() on online_css() failure.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.14.

Thanks!

-- 
tejun
