From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2 blk-cgroup/for-5.8] blk-cgroup: make iostat functions
 visible to stat printing
Date: Mon, 1 Jun 2020 16:41:37 -0400
Message-ID: <20200601204137.GE31548@mtj.thefacebook.com>
References: <20200601154351.GD31548@mtj.thefacebook.com>
 <20200601201143.1657414-1-boris@bur.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L+uLUR36iZwv1+/Dy3Hfm2UrEbVl2bjczRKyy90BPpE=;
        b=PWCHMPP/FMEx/I6GfNxXPPjzAYeuBQTx5FtXEpVtAugYbaMmDu89qqiS35elSTan33
         lit9wYr60A6K+ISfwBfB5Y2SKX23e1iD8DnwH7ORwmRE/5fhavh2x57MLYGpxZzZscRH
         Dnl9vnY4akko5HRMggp3kFPv9qN8xf3dpAfbmxQEQbzsSmnCiu4+966ndpGoY3PSbLZt
         ihXY0wjzgzPuj63KUraYWKx7EXymXdJSPVZ4UqNsvdDNVvTd2lzTEXoH/ZlGiZ5dRKnL
         TxaooD4sfamdU+TvyW9E/dFQ/zOdmI00zhe+d4mXfDeTPgm1TbqWSjPK9htLsKRCQPOn
         SXYA==
Content-Disposition: inline
In-Reply-To: <20200601201143.1657414-1-boris-UrQYPotlwNs@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Jun 01, 2020 at 01:11:43PM -0700, Boris Burkov wrote:
> Previously, the code which printed io.stat only needed access to the
> generic rstat flushing code, but since we plan to write some more
> specific code for preparing root cgroup stats, we need to manipulate
> iostat structs directly. Since declaring static functions ahead does not
> seem like common practice in this file, simply move the iostat functions
> up. We only plan to use blkg_iostat_set, but it seems better to keep them
> all together.
> 
> Signed-off-by: Boris Burkov <boris-UrQYPotlwNs@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
