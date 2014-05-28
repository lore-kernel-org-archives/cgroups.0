From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC RESEND 01/14] block: kconfig update and build bits
 for BFQ
Date: Wed, 28 May 2014 18:19:29 -0400
Message-ID: <20140528221929.GG1419@htj.dyndns.org>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
 <1401194558-5283-2-git-send-email-paolo.valente@unimore.it>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pH9MwDyaU6ZEbMh5/KwQqihR7J5QijVq1hZGiMe3Ihw=;
        b=0MBadUz0JDVi2Yo3gZAL+BchjKhB2I2xar7bCyK2eoIJJnFMvHtD53r8dZQsUz8jRc
         bnxlnUUiEtVV3iCqX1lF4w/0n8FPblfye+7dopzlyDJmlsG8sRelKyvweudyBm282qHa
         F1YEqSELcjYZQO0vT8Wv+VQe4VnQMjSvJUg9HUyiH3dz1KMpAl4EJ5uLmQZmCmWWSdlQ
         4T7ZqNDghraviYxoRFGrMuH4FD4sztFFa2O96lWCm+rvGMygrfNWaJvQKWQgb9lwBStr
         G1G+GE/ZoahnBujCM6cHNUghuF+DKmfVqlAOX9eukiZrdizjeT0+fCW3W2yjHw+3y65G
         CzzA==
Content-Disposition: inline
In-Reply-To: <1401194558-5283-2-git-send-email-paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paolo Valente <posta_paolo-whZMOeQn8C0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 27, 2014 at 02:42:25PM +0200, paolo wrote:
> diff --git a/block/Makefile b/block/Makefile
> index 20645e8..cbd83fb 100644
> --- a/block/Makefile
> +++ b/block/Makefile
> @@ -16,6 +16,7 @@ obj-$(CONFIG_BLK_DEV_THROTTLING)	+= blk-throttle.o
>  obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
>  obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
>  obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
> +obj-$(CONFIG_IOSCHED_BFQ)	+= bfq-iosched.o

Doesn't this break builds where BFQ is enabled including all-y/m?
Please make the config / makefile changes with the actual
implementation.

Thanks.

-- 
tejun
