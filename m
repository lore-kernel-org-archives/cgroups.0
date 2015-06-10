From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET block/for-4.2/writeback] block, cgroup: make cfq
 charge async IOs to the appropriate blkcgs
Date: Wed, 10 Jun 2015 11:49:05 +0900
Message-ID: <20150610024905.GE11955@mtj.duckdns.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
 <x491thmhtej.fsf@segfault.boston.devel.redhat.com>
 <20150609030327.GL21465@mtj.duckdns.org>
 <x49lhfssz05.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=OdvMY/oH30v3yAM5VpPAJrFR5fO8Eu31KHG66N7rS4Q=;
        b=SThSDQsPF9kgCq1/HFLyRtsO7TNhIGBLJOTcP/vONdEPycsprtvMVj4bw7DXh99O9V
         u1DhEsfHlXekyDMIleIhkKn8wmur6cJ21oZxzeDrB0Nn7Cbi8euP4L8a/1M7PzzyicWc
         7zJzKUl44npIQdCrLqibu7/7MGvySpD/8oFVuvTjOBzFViW2nvlEJyIL5yt8KSu800EM
         fL5fTsUMqFqSykjOhC+LdsNU+9ySQxXA1sXn/ib/M8cT4POUQqah4K8fA2OW0q23SNry
         R3cVe/fJOzfrNbOxgqDkHeJ/FdwtZjOxEsiUwWCU0noGZeY8V7RxE6ANa++nT2g+vTGd
         mUaQ==
Content-Disposition: inline
In-Reply-To: <x49lhfssz05.fsf-RRHT56Q3PSP4kTEheFKJxxDDeQx5vsVwAInAS/Ez/D0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello,

On Tue, Jun 09, 2015 at 11:05:46AM -0400, Jeff Moyer wrote:
> Yeah, I sent this email before realizing that GFP_NOWAIT would work out.
> I've reviewed the rest of the series.  Looks good to me!  You did a nice
> job splitting things up into easily reviewable pieces, so thanks for
> that.

Thanks a lot for reviewing the patches. :)

I think it's already too late for the v4.2 merge window.  I'll re-post
the patches w/ your reviewed-by's added once v4.2-rc1 drops.

-- 
tejun
