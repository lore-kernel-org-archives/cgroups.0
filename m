From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-throttle: avoid multiple counting for same bio
Date: Tue, 13 Feb 2018 06:43:14 -0800
Message-ID: <20180213144314.GP695913@devbig577.frc2.facebook.com>
References: <1518504350-139546-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NZZt9TpKXC9Zsm7JTTXUSUrlyBhXQ/tS84Qojfu7tWg=;
        b=eI2ivrEhBbfCh0VDdFAK60iJ0ox9+ELCkxW+L1p3i2HMmkQtAMYrhUYnP11X654adN
         DZbPCjLGR9lY6HQd7Qun3WqbeJpRwptpNFboOo1cwZKUCuSd5dguD8KsL6pSf1z4/Jj7
         A3/K+eLx4eQ8Sotd2O0FYF5qeQVXJATfQx8j/i0NJ0C7R9KJ+vinAZBmK5YRNTSPJSAK
         RoyCeikafTpLb1giUDkIcZXzqDhcydQ7jEi3pfUeAc5uy3eAbOi4H5Euoq3aFhWJAmm0
         2sReTwTcVJcVhuclv4vlY2KXL+IEFl98W8vW8D/ZPj9obOIJ9IYx9zSp38gev5WtvhFN
         RFdw==
Content-Disposition: inline
In-Reply-To: <1518504350-139546-1-git-send-email-cgxu519-mVuRI66OGLPQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengguang Xu <cgxu519-mVuRI66OGLPQT0dZR+AlfA@public.gmane.org>
Cc: axboe-b10kYP2dOMg@public.gmane.org, shli-b10kYP2dOMg@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 13, 2018 at 02:45:50PM +0800, Chengguang Xu wrote:
> In current throttling/upper limit policy of blkio cgroup
> blkio.throttle.io_service_bytes does not exactly represent
> the number of bytes issued to the disk by the group, sometimes
> this number could be counted multiple times of real bytes.
> This fix introduces BIO_COUNTED flag to avoid multiple counting
> for same bio.
> 
> Signed-off-by: Chengguang Xu <cgxu519-mVuRI66OGLPQT0dZR+AlfA@public.gmane.org>

We had a series of fixes / changes for this problem during the last
cycle.  Can you please see whether the current linus master has the
same problem.

Thanks.

-- 
tejun
