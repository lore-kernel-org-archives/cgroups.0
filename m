From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-cgroup: don't account iostat for root cgroup
Date: Mon, 1 Jun 2020 22:51:21 -0400
Message-ID: <20200602025121.GG31548@mtj.thefacebook.com>
References: <20200601231141.2218370-1-boris@bur.io>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=leA9A2lWOCRo5ss9zbN0lzkpnk/eM2vdFVHyb+2f+v0=;
        b=pRjoaZeGVVDZdZ5GWQw4vFjByobFIF0+lPxKdVstS+U0OM3oIN6NyH//pOnbbZeMY1
         VCfdRrevrdEjqgQchsrpsmwMs2K+HIcp5g3INLlzoN0VW1S+AVFwG7ejkWwzix7oVl+u
         aWsTSQ3AOgviNQA1/S8wds2jVzteuoGb5Rw+UcLCqg6OWP7DTGRUenCfhvM6/H5l0ciW
         Asj6qqIOK9rOUMHLeem5gBDmOcLlFmb8LX/7VxcDUdFHmrbMsrYK+tL4T2c9nNgzsGAh
         HXXMQey81V2PtOMRWigYxG/N9qPYwjSUgDOrz2YLLu06lvcA51JhEebaIdhPD+3aF5ia
         alyg==
Content-Disposition: inline
In-Reply-To: <20200601231141.2218370-1-boris@bur.io>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Boris Burkov <boris@bur.io>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Mon, Jun 01, 2020 at 04:11:41PM -0700, Boris Burkov wrote:
> This data is never flushed by rstat, so it is never used. We shouldn't
> bother collecting it. We can access global disk stats to compute io
> statistics for the root cgroup.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
