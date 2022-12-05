From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v3 0/9] A few bugfix and cleanup patches for blk-throttle
Date: Mon, 05 Dec 2022 13:46:07 -0700
Message-ID: <167027316733.161635.16505872806618790217.b4-ty@kernel.dk>
References: <20221205115709.251489-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXyrpJdo+UCHtqk4rvzCMrlf12yHI5XT5NQfrdPusNM=;
        b=hyvU997fHxXAg5pMw5Q7EANvosZU2uDUChKMrapmNJSBQaDVC6u3v7umlxStwBzbzs
         E0FHXqjNcKiwKBWUtDZLau0zGl+mmk39gdLUIK333XcKQxRdP9fkLqdqVFoOCzc5OLAi
         dvxI82cc54kdeoVo9wjn5+eKQmUb3E9QvxmvzSWdwT1xVskE2Y9/EGenbJogom6FZMMw
         dfqLiDjFrD2pWVQ/vS+3I9rw5Zi9zFZrHPyFwFZWsHtozrm8iTpsRPfrfrWm9wfnzdhG
         J2PM6ul1d2Mj2z9za7R3PCMZr5idEWkstHcALa9ucoqKRhwiFZnjyDu8rOLCZdjE3poG
         1g0g==
In-Reply-To: <20221205115709.251489-1-shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linfeilong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuzhiqiang26-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


On Mon, 05 Dec 2022 19:57:00 +0800, Kemeng Shi wrote:
> hierarchy, corret comment and so on. More details can be found in
> respective changelogs. Thanks.
> 

Applied, thanks!

[1/9] blk-throttle: correct stale comment in throtl_pd_init
      commit: f56019aef353576f43f945fdd065858145090582
[2/9] blk-throttle: Fix that bps of child could exceed bps limited in parent
      commit: 84aca0a7e039c8735abc0f89f3f48e9006c0dfc7
[3/9] blk-throttle: ignore cgroup without io queued in blk_throtl_cancel_bios
      commit: eb184791821409c37fef4f67638bb56bdaa82900
[4/9] blk-throttle: correct calculation of wait time in tg_may_dispatch
      commit: 183daeb11de871b073515d14ec1e3bc0da79e038
[5/9] blk-throttle: simpfy low limit reached check in throtl_tg_can_upgrade
      commit: a4d508e333829a8394e59efa06ce56e51f3e2b29
[6/9] blk-throttle: fix typo in comment of throtl_adjusted_limit
      commit: 009df341714c6c20a44dd9268681a8bff10bb050
[7/9] blk-throttle: remove incorrect comment for tg_last_low_overflow_time
      commit: e3031d4c7d2c5bff6b5944d61d4e31319739d216
[8/9] blk-throttle: remove repeat check of elapsed time from last upgrade in throtl_hierarchy_can_downgrade
      commit: 9c9f209d9d81ea67cd84f53f470a592c252d845d
[9/9] blk-throttle: Use more siutable time_after check for update of slice_start
      commit: eea3e8b74aa1648fc96b739458d067a6e498c302

Best regards,
-- 
Jens Axboe


