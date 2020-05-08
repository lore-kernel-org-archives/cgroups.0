From: Guoqing Jiang <guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>
Subject: [PATCH 0/4] cleanup for blk-wbt and blk-throttle
Date: Sat,  9 May 2020 00:00:11 +0200
Message-ID: <20200508220015.11528-1-guoqing.jiang@cloud.ionos.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HJaSGZ1p1+2gTGleg/polxs+Iy4GGrNGzSb8aVDGzrQ=;
        b=IaPO7e8heLcfhT9bkoaHzPo555GzJw1+LYpUUo0zXxp4egYkIo8uKH2hJ12Gf60np7
         6ThjNHhMdYtWeGtQ+yVnic8OSNXCdGjK1zQbTpFLQTCWUwFjUVW+F9PW+u3ohqNYIVDv
         4ryJk5yYm5OV9PVscfngBf44Qc+EJWGxjQI4lgGJ5f0Tf+UlZs3H+iK1ZX4x0ZO0ghfE
         dcmCNmAKY5bQs3/rA/aOm8iIOQ67grMUEvIYLLFIO2VnxdUs2VL7ERL+yM6M7YZo8KwA
         AuByX002gvPWVYrIud5jWNMQbrHgHcvgTMKrg0tvYmEfqaMjftdBCj11iZVHhw+zemO4
         +GIw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guoqing Jiang <guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>

Hi,

Find some functions can be removed since there is no caller of them when
read the code.

Thanks,
Guoqing   

Guoqing Jiang (4):
  blk-throttle: remove blk_throtl_drain
  blk-throttle: remove tg_drain_bios
  blk-wbt: remove wbt_update_limits
  blk-wbt: rename __wbt_update_limits to wbt_update_limits

 block/blk-throttle.c | 63 --------------------------------------------
 block/blk-wbt.c      | 16 +++--------
 block/blk-wbt.h      |  4 ---
 block/blk.h          |  2 --
 4 files changed, 4 insertions(+), 81 deletions(-)

-- 
2.17.1

