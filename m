From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: move the bdi from the request_queue to the gendisk
Date: Mon, 9 Aug 2021 15:42:32 -0600
Message-ID: <1daf9ad7-1c6b-0e57-9645-7902feda712d@kernel.dk>
References: <20210809141744.1203023-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UbXAYdRHxKxxmC4KDWgyIc/4KEvYd5We70piQjbukJY=;
        b=WDUwHi84SGgUmjlZRgTAExBiEjnslPFUC2C2Dxwpq+qOoCOsVmUIxZX1z4hveShRZo
         DMRunpgURSW+VhFTInR12GfcpmPzwdCoOiP5ife3C6BhSHmCeP1EXeU6UVMZkbDhKCpj
         9otQQepxMn/+Ym4k/IANk6pd2WFjBgV+VL9Bto++lNPGAecSNO+WMUEKDU6sNEQOAX9l
         robaz3duHYqZ87F7j60GHqhFkpwveXll4TkaeJIiFp9iMDk5M2tTJTxoRdQtdS/MocKM
         DmGKWVZ9yxCvkW/75nvbPG1desNJyXre0ksMciWif2PnpJaIXwD5Cm0Q8xtrBDaYdOOw
         8+Rg==
In-Reply-To: <20210809141744.1203023-1-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 8/9/21 8:17 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series moves the pointer to the bdi from the request_queue
> to the bdi, better matching the life time rules of the different
> objects.

Applied for 5.15, thanks.

-- 
Jens Axboe

