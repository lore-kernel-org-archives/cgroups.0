From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next v3 2/2] blk-throttle: fix io hung due to
 configuration updates
Date: Fri, 20 May 2022 06:20:36 -1000
Message-ID: <Yoe/1BRYzSRI0JBd@slm.duckdns.org>
References: <20220519085811.879097-1-yukuai3@huawei.com>
 <20220519085811.879097-3-yukuai3@huawei.com>
 <20220519095857.GE16096@blackbody.suse.cz>
 <a8953189-af42-0225-3031-daf61347524a@huawei.com>
 <20220519161026.GG16096@blackbody.suse.cz>
 <73464ca6-9412-cc55-d9c0-f2e8a10f0607@huawei.com>
 <fe3c03f7-9b52-7948-075d-cbdf431363e1@huawei.com>
 <20220520160305.GA17335@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=MtVzH3UoF12u8L33efNjqLpTUDtaXmlgKBbTF3gWD9k=;
        b=Dsgg7TZ96W0GRuErppdSf6T4FUWmmZNPMnNO7I+8rmFZ9Wab7KpPZAoYQSzGSPzlhT
         mb0X1UQ+25OgdIChFrz6rVnxb9d+U0p/aU6V3lmCC6hn6/QqDqNfx/FpekIj9bjlmOA9
         PFlhK+DZQ8ibN3OaS6/ADJbQOEZiqGuikFY6jTpZYOIj4L9I/e6OWdc0LKeqEgAhkzMe
         SMiDElqSqUx15bpFQWKQWFSqe+RLP/2OfKdcecnWuwQhOtE/eTNHqm8spfzC1msqPQrZ
         98s9aR05kcj3vJPjsNqGYraDEGpKWwTldO41pcmFmGFbDG+wsboA+O9roKh5t/tN4SY5
         K2cA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220520160305.GA17335@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: "yukuai (C)" <yukuai3@huawei.com>, axboe@kernel.dk, ming.lei@redhat.com, geert@linux-m68k.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

Hello,

On Fri, May 20, 2022 at 06:03:05PM +0200, Michal Koutn=FD wrote:
> > Then io hung can be triggered by always submmiting new configuration
> > before the throttled bio is dispatched.
>=20
> How big is this a problem actually? Is it only shooting oneself in the leg
> or can there be a user who's privileged enough to modify throttling
> configuration yet not privileged enough to justify the hung's
> consequences (like some global FS locks).

So, the problem in itself is of the self-inflicted type and I'd prefer to
ignore it. Unfortunately, the kernel doesn't have the kind of isolation
where stalling out some aribtrary tasks is generally safe, especially not
blk-throtl as it doesn't handle bio_issue_as_root() and thus can have a
pretty severe priority inversions where IOs which can block system-wide
operations (e.g. memory reclaim) get trapped in a random cgroup.

Even ignoring that, the kernel in general assumes some forward progress from
everybody and when a part stalls it's relatively easy to spread to the rest
of the system, sometimes gradually, sometimes suddenly - e.g. if the stalled
IO was being performed while holding the mmap_sem, which isn't rare, then
anything which tries to read its proc cmdline will hang behind it.

So, we wanna avoid a situation where a non-priviledged user can cause
indefinite UNINTERRUPTIBLE sleeps to prevent local DoS attacks. I mean,
preventing local attacks is almost never fool proof but we don't want to
make it too easy at least.

Thanks.

--=20
tejun
