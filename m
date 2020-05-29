From: Guoqing Jiang <guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>
Subject: Re: [PATCH 0/4] cleanup for blk-wbt and blk-throttle
Date: Fri, 29 May 2020 23:55:34 +0200
Message-ID: <f308bc7f-083a-d0f3-aad2-b353c241dbde@cloud.ionos.com>
References: <20200508220015.11528-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=y+7fPyOVJN5kEZ9dPieR6MlsnghgeDslNqLeQyzk6T0=;
        b=WZeC7eO7/F1ZaHD2HPukUdjFIz2gU316B+8AUCkZ3RKsm7iLEROxDs+nbuAmSb/M1D
         oto7q3ImBObrsf7Z8ZjIa2xJvNFfpmhYKUXEMNdbGPul2Odv8xHsR0jxFRbs75pFsx8s
         tEBmiGdLzbVZNYQ5xTX0vEWNkGPpXNroUaoy77ja1l5tGYab04onKEOIRN3Mi46GrMtQ
         SetD/TtpId/Ilf7VGL1u8VPwxrB29EEl3tywWnAl0i+PVtPjDP3lxNZ07IpbuOUE4a55
         fiblyxy3HtslcCuCq66nOo+R7FDVhxyx46HZvQ+KZjC/3rkGtvP+LfVqOmpJFfg5Znu7
         Qzgg==
In-Reply-To: <20200508220015.11528-1-guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Gently ping.

On 5/9/20 12:00 AM, Guoqing Jiang wrote:
> Hi,
>
> Find some functions can be removed since there is no caller of them when
> read the code.
>
> Thanks,
> Guoqing
>
> Guoqing Jiang (4):
>    blk-throttle: remove blk_throtl_drain
>    blk-throttle: remove tg_drain_bios
>    blk-wbt: remove wbt_update_limits
>    blk-wbt: rename __wbt_update_limits to wbt_update_limits
>
>   block/blk-throttle.c | 63 --------------------------------------------
>   block/blk-wbt.c      | 16 +++--------
>   block/blk-wbt.h      |  4 ---
>   block/blk.h          |  2 --
>   4 files changed, 4 insertions(+), 81 deletions(-)
>

