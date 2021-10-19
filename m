From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v2] block, bfq: fix UAF problem in bfqg_stats_init()
Date: Tue, 19 Oct 2021 15:18:38 -0600
Message-ID: <163467831594.699544.8918304401816350071.b4-ty@kernel.dk>
References: <20211018024225.1493938-1-zhengliang6@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0GzA7XiYabDpwlwEkodpA4g2HW2PvdLTHL9by9i3zr0=;
        b=am9XbdWtSLAePsczf6sAyeuwlXGvpSs5OQQIudZxRB/oqzI0RbsoMVyASyiVYTCgfD
         XH28hBa/DiNO8YZxs6ZykFLeuLUBcnJDvlRLydt3YzQF6MTBw7ulb0eIne/AuoF4SiAD
         KwO6uvfqoin/Ez4BBQQHPODPByn9J5+y2qWtaFU9/T7k3lBpecrEXCXAW8asuyp67Zgx
         o6fY7qN36vKduaYKy6tN9E/0Kq5XHepbFSNCW8zW4h4SERn9niStfgTQYfgwhlCnM+EC
         orv/RSIadrJ0iFMYNmdXTRHXBuicW6m6YcGUsItcajeVbHrgjhs3YljdWV912FEjXDxO
         PWvQ==
In-Reply-To: <20211018024225.1493938-1-zhengliang6-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zheng Liang <zhengliang6-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 18 Oct 2021 10:42:25 +0800, Zheng Liang wrote:
> In bfq_pd_alloc(), the function bfqg_stats_init() init bfqg. If
> blkg_rwstat_init() init bfqg_stats->bytes successful and init
> bfqg_stats->ios failed, bfqg_stats_init() return failed, bfqg will
> be freed. But blkg_rwstat->cpu_cnt is not deleted from the list of
> percpu_counters. If we traverse the list of percpu_counters, It will
> have UAF problem.
> 
> [...]

Applied, thanks!

[1/1] block, bfq: fix UAF problem in bfqg_stats_init()
      commit: 2fc428f6b7ca80794cb9928c90d4de524366659f

Best regards,
-- 
Jens Axboe


