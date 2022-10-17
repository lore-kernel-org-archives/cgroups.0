From: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Subject: Re: [PATCH 2/3] block: Correct comment for scale_cookie_change
Date: Mon, 17 Oct 2022 14:20:55 -0400
Message-ID: <Y02dBx/nNwMLUxXm@localhost.localdomain>
References: <20220929074055.30080-1-shikemeng@huawei.com>
 <20220929074055.30080-3-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0ASJnvbXdmbENnmELYX21Km/XI3pCAL3HYWqBCGT72Y=;
        b=py5hnISP+vNcRCvrzlR6VM021OOidZOopS8YOp2I/MYSkjn/IXbXq0MP760tCiZIeq
         vhIF88sffbaI+QdDO9hXnsYiLNdQxr6FM26NE9RI9fTeivzUL6c9JzGZRWa9vsihF9Yw
         83YT6UGOE+sWnm+cGaWoaY+t4C1LG7cAhD89p0aMTwfru10b9bUWNUqzrvPIq2zfXtve
         1Rsu2RgKer9QZavQfj+9tBWtkiwI5XzORJ+z9ZIOrfb/KrVyuHUFmTpfqpw0i57nDRhl
         7xDiqRzZ1M9LmFgZltEn9XDDX/t8sJvwZ/9FS/cIXqw5nbJe4M4B8Zm55xIwBJ8wb1i3
         n4Sw==
Content-Disposition: inline
In-Reply-To: <20220929074055.30080-3-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 29, 2022 at 03:40:54PM +0800, Kemeng Shi wrote:
> Default queue depth of iolatency_grp is unlimited, so we scale down
> quickly(once by half) in scale_cookie_change. Remove the "subtract
> 1/16th" part which is not the truth.
>

Ok sure, but at least update the comment to indicate what we actually do when
scaling down.  Thanks,

Josef 
