From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 0/5] memcg, cgroup: kill css id
Date: Mon, 23 Sep 2013 09:08:16 -0400
Message-ID: <20130923130816.GH30946@htj.dyndns.org>
References: <524001F8.6070205@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=P41isi1CLeFbx3uoew1tC/k7hjZ+b0/8ZJ+x+r4MsJM=;
        b=YpLU3nWgoqw4OiYru6nLpgEBMprb+4v0vuFmYfqwgz6v58kZbRG3S+e4MzbmRKeXXh
         SENztX+GKk0VLY2Vb+IKqdriDyxWNg9kDvXt0RBLZoPbPX5YCvf4p+Yhqe7yrkW+Kpzk
         z+qMixoCcgWy1jZfkbHtn2SEKIEEDbpsTU+Kgh9hou4gIzHlIJarmHumyT+ktVBLRaTR
         x1DtGfVz+aauq7K17g6mEpqFUZ4akmtGuYMvvEzqHCfjPT/jx6YVKmYECAyEh2W4qpov
         DRrSMWXGpTW5NnKkaVIdbVAZxnQ/k1FXE3vRGW4eVvurSkeh1/7s2kPZiC4/xNU2n/7q
         IzdQ==
Content-Disposition: inline
In-Reply-To: <524001F8.6070205-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Hello,

On Mon, Sep 23, 2013 at 04:55:20PM +0800, Li Zefan wrote:
> The whole patchset has been acked and reviewed by Michal and Tejun.
> Could you merge it into mm tree?

Ah... I really hoped that this had been merged during -rc1 window.
Andrew, would it be okay to carry this series through cgroup tree?  It
doesn't really have much to do with mm proper and it's a PITA to have
to keep updating css_id code from cgroup side when it's scheduled to
go away.  If carried in -mm, it's likely to cause conflicts with
ongoing cgroup changes too.

Thanks.

-- 
tejun
