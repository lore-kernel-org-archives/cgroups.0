From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] blk-ioprio: Introduce promote-to-rt policy
Date: Tue, 21 Feb 2023 06:37:36 -1000
Message-ID: <Y/TzUKbsa6D7+Ui1@slm.duckdns.org>
References: <20230220135428.2632906-1-houtao@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PqDVJNwWIwNFunXvEtWTSAzOUCVvEWbOZPflEYS3dBY=;
        b=V7Wqb5Q5j7csLQ+YeuJvsKd+kFbhRRHjX+GPXEP0Wc0CpmU2vK4TCu6jCTMzg9fjxn
         Uj+/7bqoyR2OMrFjmxMpoZA+KbnY8u9Hy9hItNDI/EVMOABnsHYqSlMzf3nJX0/rIwzB
         FhOYPASmRQFqT9cS91YklOMDNf/LGwsp/+fTP6Hn0K/Dh1M+ILAzNaOPXmiW9W6UUueR
         sYMa/ZBBXn2uviNq8bUZKDD7owk5NQYzbiFB5OWHbLp4FUKs+o8ifNy9qt472KE+mTuc
         0XHE2zo5sRqGNHL1KueXlH2hgb8L5Td7CjJjRnTNklbmcPwh+hbXh8PXTe1dxO7vLj0C
         km7w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230220135428.2632906-1-houtao@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hou Tao <houtao@huaweicloud.com>
Cc: linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Jan Kara <jack@suse.cz>, Bagas Sanjaya <bagasdotme@gmail.com>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, houtao1@huawei.com

On Mon, Feb 20, 2023 at 09:54:28PM +0800, Hou Tao wrote:
> From: Hou Tao <houtao1@huawei.com>
> 
> Since commit a78418e6a04c ("block: Always initialize bio IO priority on
> submit"), bio->bi_ioprio will never be IOPRIO_CLASS_NONE when calling
> blkcg_set_ioprio(), so there will be no way to promote the io-priority
> of one cgroup to IOPRIO_CLASS_RT, because bi_ioprio will always be
> greater than or equals to IOPRIO_CLASS_RT.
> 
> It seems possible to call blkcg_set_ioprio() first then try to
> initialize bi_ioprio later in bio_set_ioprio(), but this doesn't work
> for bio in which bi_ioprio is already initialized (e.g., direct-io), so
> introduce a new ioprio policy to promote the iopriority of bio to
> IOPRIO_CLASS_RT if the ioprio is not already RT.
> 
> So introduce a new promote-to-rt policy to achieve this. For none-to-rt
> policy, although it doesn't work now, but considering that its purpose
> was also to override the io-priority to RT and allow for a smoother
> transition, just keep it and treat it as an alias of the promote-to-rt
> policy.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
