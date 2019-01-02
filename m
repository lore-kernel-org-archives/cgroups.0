From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH V2 00/10] unify the interface of the proportional-share
 policy in blkio/io
Date: Wed, 2 Jan 2019 08:03:28 -0800
Message-ID: <20190102160328.GR2509588@devbig004.ftw2.facebook.com>
References: <7D7FAB43-5F62-4402-A9B3-E7C2E30AE680@linaro.org>
 <20181130184256.GI2509588@devbig004.ftw2.facebook.com>
 <5534B7D4-A5D9-4F44-9620-970A7F9EC140@linaro.org>
 <CADiTV-29TmkB5-k=TtQfoJqjP2Qv7GSsGLXAPBaTB6DoQ+6yyw@mail.gmail.com>
 <874A0232-2103-4364-BD88-F33B85D6A764@linaro.org>
 <20181218164126.GX2509588@devbig004.ftw2.facebook.com>
 <EC4F9B54-2352-4D85-B56C-5800CFEBCCB8@linaro.org>
 <A360EBDC-B297-4754-AF5C-0A6C30D725B4@linaro.org>
 <20181227234144.GE2509588@devbig004.ftw2.facebook.com>
 <F2A4E669-8C79-46D7-8A97-2C561FF5346B@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u1Y5F5QyWMT81pPdUhO/4L6FwI8LQOLlKRkMDxzGx2w=;
        b=UJ0p0Wz7uxup9TAief0MdXe76Ow8aRiZXnQIibAx+cZyy+mDwHhPQpKVxkEDi5zJin
         ggIW/pbu/86h7LHHdU3hnO7kkKzvtFTP2XI6y4tEy1kvI/t8tMh2ZBiFsg3eD3oKV7bf
         Kk7OTZb0jVEv7dDlylaPcaFKhgQ8mh9G9Ct2BzpcUqQuyJU2O9qMFk5IkuuwL0i0VGI+
         kI9PMD8A1WU7/sTzmeCjtSfZWHziSTehGV1uUMsjYNtfOVDpt3X+s9lP4jVLVULmTQEX
         4E/KVcv0vXDmy7ve643oSX65v35qFiSm5Q+UOXFfS2rO5f365LVjnCEpE5+zMEqjbX7+
         bucw==
Content-Disposition: inline
In-Reply-To: <F2A4E669-8C79-46D7-8A97-2C561FF5346B@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, Angelo Ruocco <angelo.ruocco.90@gmail.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, broonie@kernel.org, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>

Hello, Paolo.

On Sun, Dec 30, 2018 at 11:25:25AM +0100, Paolo Valente wrote:
> What's the benefit of throwing away months of work, on which we agreed
> before starting it, and that solves a problem already acknowledged by
> interested parties?

Showing multiple conflicting numbers definitely isn't anything which
is agreed upon.

Thanks.

-- 
tejun
