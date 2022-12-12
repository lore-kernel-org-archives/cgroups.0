From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH-block v2 1/3] bdi, blk-cgroup: Fix potential UAF of blkcg
Date: Mon, 12 Dec 2022 12:13:47 -1000
Message-ID: <Y5enmzQM7BIiEv9n@slm.duckdns.org>
References: <20221211222058.2946830-1-longman@redhat.com>
 <20221211222058.2946830-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n2XZBEP0JR3u42vjkud6u2pf7wcC2jLfekfdtsMKR2o=;
        b=CFHCFDtE98y5A8aGdBtghjU5l9CphTqaYy8+bNqMg2oj+xvRkpTz+CiNOXnOGa+xmH
         aFRyuXYMB56A8Qaj2sKuwGcPdNQ8AoKGDqpSvvk1nupxWCQ6HeVJMNeCoCndqgy4KHMa
         gtTajfL2mnJdmGIF83EGfF+l6DuCgA8QoD2TcFhwAK1WOdR4yW8jtgwKhOVlWo2htGf2
         5VbW7laZOO8WJeDhfUU061bT5bwJcSuhhe/E7n8AUutbCBMyf/ER4mfE68WrEqJxoo3a
         6h3bRzsp+lesOssSJTDJcFigURcJGHNh6iZ62bkwx4gVc0a+Cg6S4v/6y1LTDsSJtivC
         4Slg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221211222058.2946830-2-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Yi Zhang <yi.zhang@redhat.com>

On Sun, Dec 11, 2022 at 05:20:56PM -0500, Waiman Long wrote:
>  static void blkcg_destroy_blkgs(struct blkcg *blkcg)
>  {
> +	/*
> +	 * blkcg_destroy_blkgs() shouldn't be called with all the blkcg
> +	 * references gone.
> +	 */
> +	if (WARN_ON_ONCE(!css_tryget(&blkcg->css)))
> +		return;

Wouldn't it make more sense to use percpu_ref_is_zero()? It's not like the
obtained extra reference does anything, right?

Thanks.

-- 
tejun
