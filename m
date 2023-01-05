From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next 3/4] block/rq_qos: use a global mutex to protect
 rq_qos apis
Date: Wed, 4 Jan 2023 14:28:12 -1000
Message-ID: <Y7YZnM/nqb0gxOei@slm.duckdns.org>
References: <20230104085354.2343590-1-yukuai1@huaweicloud.com>
 <20230104085354.2343590-4-yukuai1@huaweicloud.com>
 <Y7XyIzGptuqO8EAt@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f4sAIIgxsgcM6zCelHdPEl6Pb++H0W0grrXecdKrLDE=;
        b=jpt0IjXHlEgXNsAkpNEBgOwddPdEdRQokPy72ekZwKiT9h1afZv3+0Y4oXUI/ls7Da
         M+lJJZOATHkcXS8p4V510taPyr9xXF7StKG/iLf/FyRk4QB5KkHnSty9uIoyvOkVEeZp
         BjWy7mnsoa+F5PzRBvplc7mgoYOJQneKp8y4lVh70aA2iDkRWv1Gk6jCaojSw4D9E2Bk
         3F2PBjQt2WR6/GrDvKG05PY2M2awwB5cviAxOW/rjtO1YHw+QghI+hb+CDctmysNGaIk
         hHcK1Qf9kK0iFdF3AGULMaOcqtu7EQUufxbz6ldBgJi+mvtPViLghN4F9jUJtZzyrGgO
         3kvA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <Y7XyIzGptuqO8EAt@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com

Hello, again.

On Wed, Jan 04, 2023 at 11:39:47AM -1000, Tejun Heo wrote:
> > 2) rq_qos_add() and blkcg_activate_policy() is not atomic, if
> >    rq_qos_exit() is done before blkcg_activate_policy(),
> >    null-ptr-deference can be triggered.
> 
> I'm not sure this part does. I think it'd be better to guarantee that device
> destruction is blocked while these configuration operations are in progress
> which can be built into blkg_conf helpers.

A bit more explanation:

Usually, this would be handled in the core - when a device goes away, its
sysfs files get shut down before stuff gets freed and the sysfs file removal
waits for in-flight operations to finish and prevents new ones from
starting, so we don't have to worry about in-flight config file operations
racing against device removal.

Here, the problem isn't solved by that because the config files live on
cgroupfs and their lifetimes are not coupled with the block devices'. So, we
need to synchronize manually. And, given that, the right place to do is the
blkg config helpers cuz they're the ones which establish the connection
between cgroup and block layer.

Can you please take a look at the following patchset I just posted:

  https://lkml.kernel.org/r/20230105002007.157497-1-tj@kernel.org

After that, all these configuration operations are wrapped between
blkg_conf_init() and blkg_conf_exit() which probably are the right place to
implement the synchronization.

Thanks.

-- 
tejun
