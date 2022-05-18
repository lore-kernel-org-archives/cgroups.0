From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH -next v2] blk-throttle: Set BIO_THROTTLED when bio has been throttled
Date: Tue, 17 May 2022 19:32:15 -0600
Message-ID: <165283753506.124778.6326413719734024023.b4-ty@kernel.dk>
References: <20220301123919.2381579-1-qiulaibin@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=xNnxAHcC3RUWM23wBpMAK8Y3L4EOTebAASEZluO85cE=;
        b=k2hnY/uiyT6WSSX6lxbaW0qn5bcT12bgoL8VXXked6tMGBGzLgQJs7Oe7Ys2h5K7Xf
         YEszS+nJLBhHDEwuXYcLnFJzch8DPZjWPY9KpBzu6Koq7N/fI8jXZQ79Qn8byopnFSmF
         1n2nhjhBwPqGgZjKgZYdpYRz1zPMlZwSvDmrXFXrhnDDPUQKtieYV2cOV7bGifIpJEez
         +pENNh/hdzYuWIFMlS/432DXZoE+hoqz+NKM2fEFmmAvZ6e98hrtoQYalbDp5llI91p1
         aOt8wgtCo/kWgg6DOOSx6Yw7WdvNHHC9bPkFPK9qa4B6H4POMyPPmkgIEuNtxlrisPLQ
         fAqQ==
In-Reply-To: <20220301123919.2381579-1-qiulaibin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, qiulaibin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 1 Mar 2022 20:39:19 +0800, Laibin Qiu wrote:
> 1.In current process, all bio will set the BIO_THROTTLED flag
> after __blk_throtl_bio().
> 
> 2.If bio needs to be throttled, it will start the timer and
> stop submit bio directly. Bio will submit in
> blk_throtl_dispatch_work_fn() when the timer expires.But in
> the current process, if bio is throttled. The BIO_THROTTLED
> will be set to bio after timer start. If the bio has been
> completed, it may cause use-after-free blow.
> 
> [...]

Applied, thanks!

[1/1] blk-throttle: Set BIO_THROTTLED when bio has been throttled
      commit: 5a011f889b4832aa80c2a872a5aade5c48d2756f

Best regards,
-- 
Jens Axboe


