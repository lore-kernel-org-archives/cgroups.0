From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/3] A few cleanup patches for blk-iolatency.c
Date: Tue, 01 Nov 2022 08:17:56 -0600
Message-ID: <166731227683.256723.3065138031958824780.b4-ty@kernel.dk>
References: <20221018111240.22612-1-shikemeng@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aVsPtY3gVVM6m0QHBZpxv+Y/aCVxmoQdB7+i7F7TWCQ=;
        b=MM8TAdVEAPrMP4gB+CoMrgeFjUrfg/XOHPXB2QECZc6ixysal1mRzAx+qI0QpzX0Mz
         gYelXhLGuCHbx9ajsVOu/DG5uzVHmmbVYwGqNyzDvfg12PMKOxP4kxnfb4vP56g+Pr8Z
         8yqbNT4j14QXmo3RjpT+SElJHRyc97dv/wNR56e6EFusM7TcGLNlos+dmkne+7mjcV7O
         o87MC8/TvQ5OQdvXlNCmOiL9TuRQI8mMpOzB9gEmbzoNGY4WHkcgN3KaJse/OxNSWd0R
         WFoxseVM9ZtvF/DbweUs9EuL2pE47WQVZDUE9Q3uWWLnU2fzYjE8zObULHZJPlpSKBKp
         3fQA==
In-Reply-To: <20221018111240.22612-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kemeng Shi <shikemeng@huawei.com>, josef@toxicpanda.com, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org

On Tue, 18 Oct 2022 19:12:37 +0800, Kemeng Shi wrote:
> This series contains three cleanup patches to remove redundant check,
> correct comment and simplify struct iolatency_grp in blk-iolatency.c.
> 

Applied, thanks!

[1/3] block: Remove redundant parent blkcg_gp check in check_scale_change
      commit: b6e03072a91ecc815c9f62037871d621b09df2b3
[2/3] block: Correct comment for scale_cookie_change
      commit: 77445572e643538019d9919669ddf36efb6a353a
[3/3] block: Replace struct rq_depth with unsigned int in struct iolatency_grp
      commit: 718ac0e343f8fd81ab042aa4936d25fe10f6b318

Best regards,
-- 
Jens Axboe


