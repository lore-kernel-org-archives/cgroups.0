From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/6] blkcg: add blkg_[rw]stat->aux_cnt and replace
 cfq_group->dead_stats with it
Date: Fri, 26 Jun 2015 09:55:44 -0400
Message-ID: <20150626135544.GC15805@mtj.duckdns.org>
References: <1435268337-1738-1-git-send-email-tj@kernel.org>
 <1435268337-1738-3-git-send-email-tj@kernel.org>
 <20150626132702.GA14803@redhat.com>
 <20150626133540.GA15805@mtj.duckdns.org>
 <20150626134525.GB14803@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rs8mMLCY6XxBJ8jYeGVnZPZ1+lhcnoPE/F2BzIsbmEE=;
        b=Yd4TwzPjiRbK81RS2QVsc5/FONgNjlQKKI4gjI9Wj8zOHaIvlmbHEE72+X2IPsBb1c
         TtpP1ybF1lFLF8nKxCEm83EbFlNe/BM4vElYwjJxlXO3/gHn2kr5uePP2alZclutqero
         9BCZ5HFOMPAtVOXkbObibPzppzbCfivIdrr6tDQSVEbkUtHPpBrj9Fy2x+K1vclBR09t
         O7hh+KFPZcocT7Db0vouIJkjQyl1246+mPGlNJNtaTZfZklruUVHOaURfboMw2Y/caXX
         Wl2hrI53vLUzdzPpwfth4YQY8Drsk98eXN5qVRzNcQR/JkI7EUBi4HWR3H5tKngKxhew
         fJUA==
Content-Disposition: inline
In-Reply-To: <20150626134525.GB14803-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Jun 26, 2015 at 09:45:25AM -0400, Vivek Goyal wrote:
> I was just curious that why aux_cnt is different from rest of the stats.
> (It is atomic64_t while others are not).

Ooh because otherwise we'd have to protect it with sth - a spinlock,
u64 stat sync thing or whatever.  It's just a lot simpler and more
robust to use atomics.

Thanks.

-- 
tejun
