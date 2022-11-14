From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v10 3/3] blk-cgroup: Flush stats at blkgs destruction path
Date: Mon, 14 Nov 2022 12:43:57 -1000
Message-ID: <Y3LErVJiFL9wSGGl@slm.duckdns.org>
References: <20221105005902.407297-1-longman@redhat.com>
 <20221105005902.407297-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0RkJm12EG/9E1zu6+WxpU+WvUvpr5g7TNGosiBHQiqs=;
        b=jYAlB6T2TOHN4HHkErKWne7mc4i/zPhe9R0lfnOngKXiyPq+Thno7P922IY0g2Drfo
         zvMAURArSuTKAOkCVgvtw8DdpP+waWCjdJVBV2MPvJy0U5fEMxvbv9oJU1Yvqvi7ZwI3
         MdCzo2QiIy6QfCkY9NXyfO4WARTbk2aCPgkra7SKKT7OVnq7mo/yQ3s47NIWmF0M3SaV
         C4SM8YaSmL44dmp3qy76n+uT0BGCC8pfD9cjtdrWJ3byNruYi7ZjKZuPsdpRO+DRhhrW
         YjkTPG+8ov3sd+PIIwOneVmRl54qzgpz4b1UL6k4R+WAm4RtjtG//UAJlWK7/IlY0iGU
         xAtw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221105005902.407297-4-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>

On Fri, Nov 04, 2022 at 08:59:02PM -0400, Waiman Long wrote:
> As noted by Michal, the blkg_iostat_set's in the lockless list
> hold reference to blkg's to protect against their removal. Those
> blkg's hold reference to blkcg. When a cgroup is being destroyed,
> cgroup_rstat_flush() is only called at css_release_work_fn() which is
> called when the blkcg reference count reaches 0. This circular dependency
> will prevent blkcg from being freed until some other events cause
> cgroup_rstat_flush() to be called to flush out the pending blkcg stats.
> 
> To prevent this delayed blkcg removal, add a new cgroup_rstat_css_flush()
> function to flush stats for a given css and cpu and call it at the blkgs
> destruction path, blkcg_destroy_blkgs(), whenever there are still some
> pending stats to be flushed. This will ensure that blkcg reference
> count can reach 0 ASAP.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
