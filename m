From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 0/4] cleanup for blk-wbt and blk-throttle
Date: Fri, 29 May 2020 16:31:24 -0600
Message-ID: <97c85845-e678-e9f3-87e3-7cd9d5b66d17@kernel.dk>
References: <20200508220015.11528-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qjRinKG47cv+WRJraubcFr3U+Lvq7r9h5cI3It3kttE=;
        b=UfpPyJERqsDe0JeKh9kSCBp1UTomNGawgMihS00FGfwEgSzyJ5mY48/zDioK7R+d15
         Ishc4RUMdsNXqZ49Vsh3SO4RypCg+aIGZEGAIkCehakLilDYiaghS0LnbRpBlkinlq4t
         ZoOYxy1+qkq2efTePIweOqdQVcHT9vZ6T0VHB7AaNEB/hir1hZEpAvQywakJyiK0ZfiG
         JbYT8CAfVcy3FMa4KSAKsvO8K9ZQqpMu9m/TABzjE7Dkk+cwLqVCRjbl6TPQCEtf6S20
         RGxElV0oXP9F6ZuvnT08yozs+NAl5Rjh4ZPylzE0ao5Kn27kLcZS6VhfeDkpH2fDpPdo
         Hdtw==
In-Reply-To: <20200508220015.11528-1-guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Guoqing Jiang <guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 5/8/20 4:00 PM, Guoqing Jiang wrote:
> Hi,
> 
> Find some functions can be removed since there is no caller of them when
> read the code.
> 
> Thanks,
> Guoqing   
> 
> Guoqing Jiang (4):
>   blk-throttle: remove blk_throtl_drain
>   blk-throttle: remove tg_drain_bios
>   blk-wbt: remove wbt_update_limits
>   blk-wbt: rename __wbt_update_limits to wbt_update_limits
> 
>  block/blk-throttle.c | 63 --------------------------------------------
>  block/blk-wbt.c      | 16 +++--------
>  block/blk-wbt.h      |  4 ---
>  block/blk.h          |  2 --
>  4 files changed, 4 insertions(+), 81 deletions(-)

Thanks applied, missed this originally. Nice diffstat!

-- 
Jens Axboe

