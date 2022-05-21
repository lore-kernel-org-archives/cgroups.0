From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next v3 2/2] blk-throttle: fix io hung due to
 configuration updates
Date: Sat, 21 May 2022 11:51:11 +0800
Message-ID: <97be6af0-ea94-f4ee-5ab2-02b6fc02cbff@huawei.com>
References: <20220519085811.879097-1-yukuai3@huawei.com>
 <20220519085811.879097-3-yukuai3@huawei.com>
 <20220519095857.GE16096@blackbody.suse.cz>
 <a8953189-af42-0225-3031-daf61347524a@huawei.com>
 <20220519161026.GG16096@blackbody.suse.cz>
 <73464ca6-9412-cc55-d9c0-f2e8a10f0607@huawei.com>
 <fe3c03f7-9b52-7948-075d-cbdf431363e1@huawei.com>
 <20220520160305.GA17335@blackbody.suse.cz> <Yoe/1BRYzSRI0JBd@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Yoe/1BRYzSRI0JBd@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: axboe@kernel.dk, ming.lei@redhat.com, geert@linux-m68k.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

在 2022/05/21 0:20, Tejun Heo 写道:
> Hello,
> 
> On Fri, May 20, 2022 at 06:03:05PM +0200, Michal Koutný wrote:
>>> Then io hung can be triggered by always submmiting new configuration
>>> before the throttled bio is dispatched.
>>
>> How big is this a problem actually? Is it only shooting oneself in the leg
>> or can there be a user who's privileged enough to modify throttling
>> configuration yet not privileged enough to justify the hung's
>> consequences (like some global FS locks).
> 
> So, the problem in itself is of the self-inflicted type and I'd prefer to
> ignore it. Unfortunately, the kernel doesn't have the kind of isolation
> where stalling out some aribtrary tasks is generally safe, especially not
> blk-throtl as it doesn't handle bio_issue_as_root() and thus can have a
> pretty severe priority inversions where IOs which can block system-wide
> operations (e.g. memory reclaim) get trapped in a random cgroup.
Hi, Tejun

It's right the problem is self-inflicted. However, I do think with
Michal's suggestion, how throttled bios are handled while new config is
submitted really make sense from the functional poinit of view.

Do you think the solution is OK?

Thnaks,
Kuai
> 
> Even ignoring that, the kernel in general assumes some forward progress from
> everybody and when a part stalls it's relatively easy to spread to the rest
> of the system, sometimes gradually, sometimes suddenly - e.g. if the stalled
> IO was being performed while holding the mmap_sem, which isn't rare, then
> anything which tries to read its proc cmdline will hang behind it.
> 
> So, we wanna avoid a situation where a non-priviledged user can cause
> indefinite UNINTERRUPTIBLE sleeps to prevent local DoS attacks. I mean,
> preventing local attacks is almost never fool proof but we don't want to
> make it too easy at least.
> 
> Thanks.
> 
