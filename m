From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3] block/blk-iocost (gcc13): keep large values in a new enum
Date: Wed, 14 Dec 2022 09:56:56 -0700
Message-ID: <167103701689.7871.5096840115794235278.b4-ty@kernel.dk>
References: <20221213120826.17446-1-jirislaby@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Ju0SN0CEVcplXYOw1X7EyarT02yn23kHgLqVSbDEE4=;
        b=QhWtChl13fEjzn+c7stogJNanm2k7IHx55x+oP67ZKqO6ImEwYdM+5fiS9G+uqiooE
         a1/ZHEP9J+4tgZZZNRYS2+lcbPgkq2Jfcdz0vFEDOM36QIQUIlzMj1qza+w6pOueO7n3
         tZZJeS227c7o6UQSCclnUN28FezhrZrlkv/Yj+TtnCSJfgWNZTjRKZbvTAIdi4/kHL84
         5oWKCJHAD34g81IWBxv7KeV1EE/JMQ0Lkk9R40PZIrUcx+b4TtXyuw5IU4wTgLw/1IHG
         gg5CCs44vTq7EwWicegB+poRTotw8JsjL13C/6+Sly36aZVJMT5gNJmRBpsYzYxeDF5l
         3pOQ==
In-Reply-To: <20221213120826.17446-1-jirislaby@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc: linux-kernel@vger.kernel.org, Martin Liska <mliska@suse.cz>, Josef Bacik <josef@toxicpanda.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org


On Tue, 13 Dec 2022 13:08:26 +0100, Jiri Slaby (SUSE) wrote:
> Since gcc13, each member of an enum has the same type as the enum [1]. And
> that is inherited from its members. Provided:
>   VTIME_PER_SEC_SHIFT     = 37,
>   VTIME_PER_SEC           = 1LLU << VTIME_PER_SEC_SHIFT,
>   ...
>   AUTOP_CYCLE_NSEC        = 10LLU * NSEC_PER_SEC,
> the named type is unsigned long.
> 
> [...]

Applied, thanks!

[1/1] block/blk-iocost (gcc13): keep large values in a new enum
      commit: ff1cc97b1f4c10db224f276d9615b22835b8c424

Best regards,
-- 
Jens Axboe


