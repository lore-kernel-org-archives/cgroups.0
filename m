From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 1/3] block: Remove redundant parent blkcg_gp check in
 check_scale_change
Date: Mon, 17 Oct 2022 14:23:24 -0400
Message-ID: <Y02dnHeLS+XFO1VH@localhost.localdomain>
References: <20220929074055.30080-1-shikemeng@huawei.com>
 <20220929074055.30080-2-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lq1ryJcl968Ik5HB0Yb2jD+Gw/+EidzY3ld4yzCYtK0=;
        b=f+VWY5jsCcdoOqgQcMcNiyPnoQ62YcwD9UWqprttX5m8USSofE9ikd46EItFEN6AOB
         sGj9EF9Zjar0N27Oj9JDUqU9xXAzIMLeMILtXdr4JQGbYCqeNjU008EMbUykXbMhem94
         foLhAEEt5i6FYyQ38Tu/rf7gVsuQoharx7sMB/650Tv7KJKe79HQenR9dClgWECShpDe
         StTmLSf3iQNSBb7jzViCrwnIyNdsD1BErmT/Q+0bWUeAW5TMOLc50OuFyvJUZTKstB5v
         GpKFZKWXhX4T3OchBhUUFFo3WR+IAEDZ7cuRE+5+lYMRNBnEIAOhkccA47cvSsqjRSDG
         4Few==
Content-Disposition: inline
In-Reply-To: <20220929074055.30080-2-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng@huawei.com>
Cc: tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Sep 29, 2022 at 03:40:53PM +0800, Kemeng Shi wrote:
> Function blkcg_iolatency_throttle will make sure blkg->parent is not
> NULL before calls check_scale_change. And function check_scale_change
> is only called in blkcg_iolatency_throttle.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huawei.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
