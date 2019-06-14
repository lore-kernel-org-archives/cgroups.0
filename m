From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 10/10] blkcg: implement BPF_PROG_TYPE_IO_COST
Date: Fri, 14 Jun 2019 10:09:14 -0700
Message-ID: <20190614170914.GF538958@devbig004.ftw2.facebook.com>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614015620.1587672-11-tj@kernel.org>
 <e4d1df7b-66bb-061a-8ecb-ff1e5be3ab1d@netronome.com>
 <20190614145239.GA538958@devbig004.ftw2.facebook.com>
 <bed0a66a-7aa6-ac36-9182-31a4937257e5@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8wh55Cc5i2Lm0uKQU6Z1K0oTPrUc8lTykFYnyLF1hmI=;
        b=Xj7snfT/PvWl6aBQDyjdw33T+D2UjBfUv8RjbVPeLJPCahk+HvjxdswjSWDN7oIr3C
         VQqddC+9kvHVUKM8EGbrAmYUV0+0j4Bi4GJOz0KS7SWEutrJnQ9h6o629P1e7aXgz1hG
         jYAAyP+qXwhwdMKmCGbXYsK3ptud5FO8peYMj6VfZdpP0x3PEAqns/79Scv8oNPOyINZ
         IGwWr6UiFZcxLd9zcmVIEH+Ua+3+7Zs7hlkWipuAtIXd7S3PXrI7KzjnzaNiUNOkfiBK
         JNlEh8bt5d+0/rwI+49lysrhE8rhSD/DxFGxvmsO5e2415dRKMYoTgq0ebMlIrBZ5zt0
         HK3w==
Content-Disposition: inline
In-Reply-To: <bed0a66a-7aa6-ac36-9182-31a4937257e5@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@fb.com>
Cc: Quentin Monnet <quentin.monnet@netronome.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Andy Newell <newella@fb.com>, Chris Mason <clm@fb.com>, "josef@toxicpanda.com" <josef@toxicpanda.com>, Dennis Zhou <dennisz@fb.com>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>

Hello, Alexei.

On Fri, Jun 14, 2019 at 04:35:35PM +0000, Alexei Starovoitov wrote:
> the example bpf prog looks flexible enough to allow some degree
> of experiments. The question is what kind of new algorithms you envision
> it will do? what other inputs it would need to make a decision?
> I think it's ok to start with what it does now and extend further
> when need arises.

I'm not sure right now.  The linear model worked a lot better than I
originally expected and looks like it can cover most of the current
use cases.  It could easily be that we just haven't seen enough
different cases yet.

At one point, quadratic model was on the table in case the linear
model wasn't good enough.  Also, one area which may need improvements
could be factoring in r/w mixture into consideration.  Some SSDs'
performance nose-dive when r/w commands are mixed in certain
proportions.  Right now, we just deal with that by adjusting global
performance ratio (vrate) but I can imagine a model which considers
the issue history in the past X seconds of the cgroup and bumps the
overall cost according to r/w mixture.

> > * Is block ioctl the right mechanism to attach these programs?
> 
> imo ioctl is a bit weird, but since its only one program per block
> device it's probably ok? Unless you see it being cgroup scoped in
> the future? Then cgroup-bpf style hooks will be more suitable
> and allow a chain of programs.

As this is a device property, I think there should only be one program
per block device.

> > * Are there more parameters that need to be exposed to the programs?
> > 
> > * It'd be great to have efficient access to per-blockdev and
> >    per-blockdev-cgroup-pair storages available to these programs so
> >    that they can keep track of history.  What'd be the best of way of
> >    doing that considering the fact that these programs will be called
> >    per each IO and the overhead can add up quickly?
> 
> Martin's socket local storage solved that issue for sockets.
> Something very similar can work for per-blockdev-per-cgroup.

Cool, that sounds great in case we need to develop this further.  Andy
had this self-learning model which didn't need any external input and
could tune itself solely based on device saturation state.  If the
prog can remember states cheaply, it'd be pretty cool to experiment
with things like that in bpf.

Thanks.

-- 
tejun
