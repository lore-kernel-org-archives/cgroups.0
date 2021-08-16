From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 1/2] blk-cgroup: refactor blkcg_print_stat
Date: Mon, 16 Aug 2021 10:53:22 -0600
Message-ID: <e090f6f4-6f15-f917-79fd-b516c6cca656@kernel.dk>
References: <20210810152623.1796144-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g7L5+WzsIvTLUERtXFkH56DdEnmU2g0oMI370Ugvcmg=;
        b=vTis+s4hlAm+FTr++090MtQwF0P5/lh0FBWDSi8RTA1wUVCr0BpRfK/us9pFVxUpog
         uu6jEUL2BHfveOB48loIkRaHp5bz5albTobFZvpvuwPRAEzMEGIuPI5kuvuubBK+AOQ0
         E55mGtikm7jUclvHQ2OBlF2FM0V2wuXIbbWCANJa4VATG6XRRBq0jlpJJliUp0uUwgwB
         oVjeRBwvP53F5AFe9UvDWGAGJK354/coFul8xwoLl0TFA4DBRK1WEWtza51fjJyL/6hp
         2ENq6H7kNagObY44cbihm3AMlndCLLsjuoR24ZxXM6HUn4PiQF9lftOMb/v4/GrY6jra
         QGww==
In-Reply-To: <20210810152623.1796144-1-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 8/10/21 9:26 AM, Christoph Hellwig wrote:
> Factor out a helper to deal with a single blkcg_gq to make the code a
> little bit easier to follow.

Applied 1-2, thanks.

-- 
Jens Axboe

