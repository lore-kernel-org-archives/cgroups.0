From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 02/10] cgroup: introduce cgroup_subsys->legacy_name
Date: Tue, 18 Aug 2015 14:01:45 -0700
Message-ID: <20150818210145.GE15739@mtj.duckdns.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
 <1437763434-28699-3-git-send-email-tj@kernel.org>
 <20150728175647.GH5322@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dzfOE7VVydomirB67YPGK8RYPx2Ro7aE/voRemkh/88=;
        b=h+qpP69FZCvMer4g/9aq8OfqUrkrGrbKWUnNUCTLronPHAfgDMT1wSpkjrPdn/z4/j
         +PUpcdfwpuEPnXiJNX+/Rf/1oHyuQsfC39FpJUoJtTcvuYICbkYDFBqHfyfsqM7KtOla
         PajHZFFUGNaym74CbXsD8gvmt3VsRfYCbM9+0fcb1lG/KNUciEZX3JJCvcgEXr7o4o7d
         GREVskTACfAN2yAPDJ2xSgNeMJW/aUoLgFrwgTX++QktXnwonMY5/SHS8Oio1yQZjjsF
         ZUj6iUAxhOwDZ4xrPQq2bW2ryx1loPnsQZVtq8P8UGJw/4GMoJW3+reTD3icoTVWe5mi
         tTiw==
Content-Disposition: inline
In-Reply-To: <20150728175647.GH5322@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, avanzini.arianna@gmail.com, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Tue, Jul 28, 2015 at 01:56:47PM -0400, Tejun Heo wrote:
> This allows cgroup subsystems to use a different name on the unified
> hierarchy.  cgroup_subsys->name is used on the unified hierarchy,
> ->legacy_name elsewhere.  If ->legacy_name is not explicitly set, it's
> automatically set to ->name and the userland visible behavior remains
> unchanged.
> 
> v2: Make parse_cgroupfs_options() only consider ->legacy_name as mount
>     options are used only on legacy hierarchies.  Suggested by Li
>     Zefan.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: cgroups@vger.kernel.org

Applied to cgroup/for-4.3-unified-base.

Thanks.

-- 
tejun
