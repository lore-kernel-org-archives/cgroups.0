From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: fix a hd_struct leak in
 blkcg_fill_root_iostats
Date: Sat, 14 Nov 2020 11:17:45 -0700
Message-ID: <3dd068d9-8dd6-ea2f-e600-f8007516cd1d@kernel.dk>
References: <20201114181246.107007-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i0e3E64zBwid1kl9TRb62r7Kg+IomqRl8tjiUk7Bh9c=;
        b=ar5yYtE92kZ+9hKIQlmSdM6HKuoBgt3Lu8f0HxdrUrOiHZqm2UzBum26yliHtmn1+r
         mxSVE6PlJr/itb28rrNlbHsB2BZInkJuTLUUzDMap0sizj7IZ88LVD7xHv3929rOBD/0
         FRV1WZgZotmwOyHRXExpS4gz3qif6if5xK3amwypNu/hNKL98W4eW+y9hFqTcW/N345X
         lsYxw9QiHSiMZWUepK03fL8kbrAor/JLE5zyGABb127CO8UI19U9Rs/QqII7w4fvc10N
         gM4AA85DRqKlvHu06SMj9QPliMHjIS/LH13uqlsK4shI9951+5EKiIPpx2HSVWr1FxCv
         65Ww==
In-Reply-To: <20201114181246.107007-1-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: boris-UrQYPotlwNs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/14/20 11:12 AM, Christoph Hellwig wrote:
> disk_get_part needs to be paired with a disk_put_part.

Applied, thanks.

-- 
Jens Axboe

