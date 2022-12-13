From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH-block v3 2/2] blk-cgroup: Flush stats at blkgs
 destruction path
Date: Tue, 13 Dec 2022 09:30:59 -1000
Message-ID: <Y5jS825K7ej0jEV+@slm.duckdns.org>
References: <20221213184446.50181-1-longman@redhat.com>
 <20221213184446.50181-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sXb/rEJk2v1xayTt6fq4DLeZdX5JWv1TpuzsNKAsI7M=;
        b=G7J7io0xWPaTvvK6zYRTl01FHKEjCE7q/Jaq0JD7R1g3OdahdIZtirguReRInIrPRH
         lZsfSIG+8+OSKwrxDm0SlrqyJmOeSXBDZrO8SkfI4g6JjRukQH28HHKsxVX/gSYqaybD
         hxxQOSwBU4s3Sc7AvEyaQxh8DY45WGklrYMAn2GHRlP8xHqIqTs1JTT5nO6YSg9E9p2w
         fic1D5sGqkASXcthzYQanLnBIebq2BxRY4h0k/r/Sbgjb+opKe973QztrDdQbHiBgwbJ
         Yg/P5MaegIvmBAoR2/1zusmab90D83KH1vTve3IBK1wCcxqZ9z0CYdq5ekniAUS5kP7n
         q8wA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221213184446.50181-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

On Tue, Dec 13, 2022 at 01:44:46PM -0500, Waiman Long wrote:
> +	/*
> +	 * Flush all the non-empty percpu lockless lists so as to release
> +	 * the blkg references held by those lists which, in turn, may
> +	 * allow the blkgs to be freed and release their references to
> +	 * blkcg speeding up its freeing.
> +	 */

Can you mention the possible deadlock explicitly? This sounds more like an
optimization.

Thanks.

-- 
tejun
