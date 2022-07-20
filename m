From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v4] block: don't allow the same type rq_qos add more than once
Date: Wed, 20 Jul 2022 06:46:46 -0600
Message-ID: <165832120656.248441.6551351074316660910.b4-ty@kernel.dk>
References: <20220719165313.51887-1-hanjinke.666@bytedance.com> <20220720093616.70584-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=sEGQ7L1KrUZZSjc5lTCBdg4P620qJO0ftLSgZHwILC8=;
        b=rwUDwbnnw3bPn47kNfg7ezqzV/LZChu0a3v2CN0AynDdb4B+/tvtYW8/uAOhGtObcZ
         jdMz1+jCJ13tg2VyNFIzZPhKJMc7Ob2J0tf6XGCs9xkgJA/nrmYYJUXRUHBi0tUDuQmj
         v79GFiy1F8xNZ7qkRqvQzBaOyUzpSCbt2HEHzsViyqik+g6/sisTG7KHot3xgK9bWkbA
         SJQ83R0YkKJ6jYgdD1HuOk/8/NmH1MmCioP9T8sQD3DJRieSUOW7MGmgP6Ej+rLEdg//
         DEOGINokGsTjCA7yDSww75D/W4A1AhfCxEmU4SbMXhlSs0PN5n/iF3nOL2lr+c/vdHve
         w/oQ==
In-Reply-To: <20220720093616.70584-1-hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 20 Jul 2022 17:36:16 +0800, Jinke Han wrote:
> From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> In our test of iocost, we encountered some list add/del corruptions of
> inner_walk list in ioc_timer_fn.
> 
> The reason can be described as follow:
> cpu 0						cpu 1
> ioc_qos_write					ioc_qos_write
> 
> [...]

Applied, thanks!

[1/1] block: don't allow the same type rq_qos add more than once
      commit: 14a6e2eb7df5c7897c15b109cba29ab0c4a791b6

Best regards,
-- 
Jens Axboe


