From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC - TAKE TWO - 02/12] block, bfq: add full hierarchical
 scheduling and cgroups support
Date: Fri, 30 May 2014 11:37:18 -0400
Message-ID: <20140530153718.GB24871@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <1401354343-5527-3-git-send-email-paolo.valente@unimore.it>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=w/7VffUtFrOvuMJDXPP041dPex1yZg7/YiUDn6ZCy6g=;
        b=Rg6LhMF04vB1gTv2b+i7AEfbHFsOQIajo+NAFHsVrYzlhzjVpDCLR924r4Jgr+Qiut
         mSkwYotaZAENl3ynJmQDkw24kPgrgxTO2sGLefFirE4xXj1RaXyySSsnp9W6jUbOt187
         zDGIs1uMoTNrqRfGDpYa8KHnMh7OSTawAy2W7yjUN7Ybw54TwGRfOnQJn9OKX8kQq7YC
         /l1doW9iJhn0Frb4l/5irUdHW2S13yZsjnzBGsBztB4SLWHEA090SgaPy6l5i4CQbLF0
         N2L5oYvQHhpUIH4wAwkEcZmGmkwEExlMomGOVX7UW/PJD/XtzjxjeTZnuntOqwAtwprG
         IXPg==
Content-Disposition: inline
In-Reply-To: <1401354343-5527-3-git-send-email-paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paolo Valente <posta_paolo-whZMOeQn8C0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 29, 2014 at 11:05:33AM +0200, Paolo Valente wrote:
> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> index 768fe44..cdd2528 100644
> --- a/include/linux/cgroup_subsys.h
> +++ b/include/linux/cgroup_subsys.h
> @@ -39,6 +39,10 @@ SUBSYS(net_cls)
>  SUBSYS(blkio)
>  #endif
>  
> +#if IS_ENABLED(CONFIG_CGROUP_BFQIO)
> +SUBSYS(bfqio)
> +#endif

So, ummm, I don't think this is a good idea.  Why aren't you plugging
into the blkcg infrastructure as cfq does?  Why does it need to be a
separate controller?

Thanks.

-- 
tejun
