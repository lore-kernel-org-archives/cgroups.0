From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
Date: Thu, 18 Oct 2012 15:46:06 -0700
Message-ID: <20121018224606.GS13370@google.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-5-git-send-email-mhocko@suse.cz>
 <20121018224148.GR13370@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wj4ZITQnRGYI2tMHIu6BCScsfPAt61viaDgHspKtLYg=;
        b=nkF2qHMnwQgYuKtMIgkg5cDW51IlF5y/C3fvPyXdDev1WPFxxwohmCu1551qqIVIhw
         Cf6Rue/bMnncxkcJw9hxmBjGTK4YMmfnIV/JX0fvD4pDYTx8PbCJ4unrh/1zx3AMOSql
         Ar1j+oWGkRQnKy0a7M9RyuGRP9BPs1o7HYGlJgJuHCtXZgiwB/ZkgncejKmn23k0vLiV
         7ocsoDgB7flaPEg/atm4XQnr8cL5kVAkPM2noBka5ja4pdS0LZAU1G6gNEIIOXyAR/r3
         mJ68d1Ap8HTS71FHpMzLu/7kS/Vn4/ZUPsFQXGkJPskSCN5oDbCDRbChFfmELyLoa7s5
         JhCw==
Content-Disposition: inline
In-Reply-To: <20121018224148.GR13370-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Oct 18, 2012 at 03:41:48PM -0700, Tejun Heo wrote:
> Note that the patch is broken in a couple places but it does show the
> general direction.  I'd prefer if patch #3 simply makes pre_destroy()
> return 0 and drop __DEPRECATED_clear_css_refs from mem_cgroup_subsys.
> Then, I can pull the branch in and drop all the unnecessary cruft.

But you need the locking change for further memcg cleanup.  To avoid
interlocked pulls from both sides, I think it's okay to push this one
with the rest of memcg changes.  I can do the cleanup on top of this
whole series, but please do drop .__DEPRECATED_clear_css_refs from
memcg.

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
