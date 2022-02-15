From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-cgroup: set blkg iostat after percpu stat aggregation
Date: Tue, 15 Feb 2022 14:14:16 -0700
Message-ID: <164495965641.2684.16928611518978800084.b4-ty@kernel.dk>
References: <20220213085902.88884-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=XXedcp2yhbUzo3O92znwEibtv2eEO56xS91b3yWI2ys=;
        b=0ZBGtyXpprvtwB02Ug9plwdlXTZcNgMbVrrfq+GoCMWZsFy4kMhFPR7Ik6GYKsdWWm
         8apaMiJqABQECCkZYmE9EiOcpwvPr/is8h0+UHwGOiQP+w2GavCXrykeRgJ3xVqO+tha
         /A+W/eXYZmW49+PRRnIzK0IUMHotFOGZHJv1EOQT749nDlTZyVsROay0wxzG5KdxVcni
         lCifbH5uZtwvXmI9r1oCfmotaVmTwcLQniKLwKT2Lz11TZ/G9p4iUjmeAewQJoAwU7b4
         wz60283Of2U+JnK2Hh6lvdOPr36mjlvJe6PwKH3+NbchhhoCL3VoaCJBt3PA7t/EjDlB
         bYoA==
In-Reply-To: <20220213085902.88884-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, Chengming Zhou <zhouchengming@bytedance.com>, boris@bur.io
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 13 Feb 2022 16:59:02 +0800, Chengming Zhou wrote:
> Don't need to do blkg_iostat_set for top blkg iostat on each CPU,
> so move it after percpu stat aggregation.
> 
> 

Applied, thanks!

[1/1] blk-cgroup: set blkg iostat after percpu stat aggregation
      commit: f122d103b564e5fb7c82de902c6f8f6cbdf50ec9

Best regards,
-- 
Jens Axboe


