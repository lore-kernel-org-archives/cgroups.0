From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 00/12] unify the interface of the proportional-share
 policy in blkio/io
Date: Mon, 12 Nov 2018 10:54:08 -0500
Message-ID: <20181112155406.rtx7ze2l3gadmiyx@MacBook-Pro-91.local>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <9e8adb3271680165d85994a225713391@natalenko.name>
 <E8A20452-A73C-4A31-B5EC-48EFB9937832@linaro.org>
 <e85cfae0-7743-8c51-c2c9-0855c26f868e@kernel.dk>
 <F0F86365-D4EC-43F0-AE13-CC8FA6CC3D97@linaro.org>
 <c665a05b-66fc-6b8a-fa73-1c76885053db@kernel.dk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r5C+dKXcwSZAzQOUrX1AKmtEGGonS4ljAod+QzwhprQ=;
        b=wS0jPtctkINZdfYY8Yn8YnjPZB9RMnRo+2qQAHSwB4RI5JMXGA5aQunWXZoC2wAKpO
         95dw/8cc4FIcQBfg4LfKJZUd7K/RRlAsMiEVfZfa12Q3HmfTbaqZWjWF61M9jCJIw9b+
         Dk61ET4VQwPqugp8Cr6Cj6j3BoSgPfIX45eyNQMZBe7ACyZVU34fTBlPqzoGuDcVdoFQ
         FbjQBj35p+LwjkFshVqkr4DtqMo8NuHJh++sPr74H52Y0EohT/XpTclKcsbXK4duEqam
         XrmQAQiiPOGK9JZg66GXTXrIWthTVejhYLBhxU+JwcqEHdbaX3O5fKLeKBYRqUOYh9uH
         exHQ==
Content-Disposition: inline
In-Reply-To: <c665a05b-66fc-6b8a-fa73-1c76885053db@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>, 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet>

On Mon, Nov 12, 2018 at 08:48:35AM -0700, Jens Axboe wrote:
> On 11/12/18 8:45 AM, Paolo Valente wrote:
> > BTW, since this patch series is probably even more useful for older
> > than for future kernels, might it make sense to also propose it for
> > stable/longterm kernels (provided that such a possibility exists)?
> 
> That just not how things work, we don't put different things in
> older/stable kernels, it's strictly backports of what we have in
> current/newer kernels. Hence it appears to be a dead end right now.
> 

It may not be useful currently, but my plans are to do a scheduler agnostic
proportional io controller next, so having these interfaces unified would be
nice so I don't have to do a rqos.io.weight or something similar.  Thanks,

Josef
