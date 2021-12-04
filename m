From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v4 2/2] block: cancel all throttled bios in del_gendisk()
Date: Sat, 4 Dec 2021 16:03:53 +0800
Message-ID: <c8a16fe9-4ad2-682d-0d34-1049dc217d62@huawei.com>
References: <20211202130440.1943847-1-yukuai3@huawei.com>
 <20211202130440.1943847-3-yukuai3@huawei.com>
 <20211202144818.GB16798@blackbody.suse.cz>
 <95825098-a532-a0e4-9ed0-0b5f2a0e5f04@huawei.com>
 <20211203102739.GB64349@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20211203102739.GB64349@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: hch@infradead.org, tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

在 2021/12/03 18:27, Michal Koutný 写道:
> On Fri, Dec 03, 2021 at 03:50:01PM +0800, "yukuai (C)" <yukuai3@huawei.com> wrote:
>> blkg_destroy() is protected by the queue_lock，so I think queue_lock can
>> protect such concurrent scenario.
> 
> blkg_destroy() is not as destroying :-) as actual free, you should
> synchronize against (the queue_lock ensures this for
> pd_free_fn=throtl_pd_free but you may still trip on blkcg after
> blkcg_css_free()).

Hi, Michal

I was thinking that if there are active blkgs, holding queue_lock will 
ensure blkcg won't be freed. However, if there are no active blkgs in
the first place, it seems right rcu_read_lock() can prevent this
iteration concurrent with css_release->css_release_work_fn->
css_free_rwork_fn.

By the way, does spin_lock can guarantee this since it disables preempt
like what rcu_read_lock() does?

Thanks,
Kuai

> 
> [Actually, I think you should see a warning in your situation if you
> enable CONFIG_PROVE_RCU.]
> 
> HTH,
> Michal
> 
