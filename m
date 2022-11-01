From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [patch v11 0/6] support concurrent sync io for bfq on a specail occasion
Date: Tue, 01 Nov 2022 07:10:07 -0600
Message-ID: <166730820758.252147.11493585744578710855.b4-ty@kernel.dk>
References: <20220916071942.214222-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HodXEuYzqCTG15c9CAh+5cByd+S8fmEjuYPaH6ghzhM=;
        b=knk5c/ux/y+eglyyWWu4j84v8Ixq48CJt4i6w1OYiGXLO7ZbsDuN1LZ9K8gjNEXT5/
         hbIWLRqA0lkXtkUwHfcsuW6QYxCGdKl4w/kXLoRohhz0aTjbuaZBnVK7wqeCOUWdxd+9
         6tKG/0IlXKVbwFh5KlXOe+TNLH/3M75z2O8Pzk/QRl1hHGe3YIdoGxMdNr8cW7DzKs7n
         1zthSjGfeet4uE2cKkMEoucbJKxS23TnfcQu62MBMB0DcvbqhYkIIdcTHSKzZGxWMNok
         +kXWDnlzy7os746o9KBcVFg0NpEbqyOLCxLYpInlga+0m8H2YbadRiCDV1SWVAGjiwvs
         JI7A==
In-Reply-To: <20220916071942.214222-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org
Cc: yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 16 Sep 2022 15:19:36 +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Changes in v11:
>  - keep the comments in bfq_weights_tree_remove() and move it to the
>  caller where bfqq can be freed.
>  - add two followed up cleanup patches.
> 
> [...]

Applied, thanks!

[1/6] block, bfq: support to track if bfqq has pending requests
      commit: 3d89bd12d352e20f4f7c8f11a0f1a712b95a5295
[2/6] block, bfq: record how many queues have pending requests
      commit: 60a6e10c537a7459dd53882186bd16fff257fb03
[3/6] block, bfq: refactor the counting of 'num_groups_with_pending_reqs'
      commit: 71f8ca77cb8764d46f656b725999e8b8b1aec215
[4/6] block, bfq: do not idle if only one group is activated
      commit: eed3ecc991c90a4a0ce32ea2b35378dc351f012b
[5/6] block, bfq: cleanup bfq_weights_tree add/remove apis
      commit: afdba14612622ec75896e5646950b3562a9aadd3
[6/6] block, bfq: cleanup __bfq_weights_tree_remove()
      commit: eb5bca73655cb6aa3bb608253e1e47283240c933

Best regards,
-- 
Jens Axboe


