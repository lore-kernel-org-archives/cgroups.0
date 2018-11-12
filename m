From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/12] unify the interface of the proportional-share
 policy in blkio/io
Date: Mon, 12 Nov 2018 09:05:50 -0700
Message-ID: <6b6ac3db-1f19-a290-4662-3c10b2b81ed8@kernel.dk>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <9e8adb3271680165d85994a225713391@natalenko.name>
 <E8A20452-A73C-4A31-B5EC-48EFB9937832@linaro.org>
 <e85cfae0-7743-8c51-c2c9-0855c26f868e@kernel.dk>
 <F0F86365-D4EC-43F0-AE13-CC8FA6CC3D97@linaro.org>
 <c665a05b-66fc-6b8a-fa73-1c76885053db@kernel.dk>
 <20181112155406.rtx7ze2l3gadmiyx@MacBook-Pro-91.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V+pp3RB3QPmZ7ONFN2yXCuP86/d7gL2nH4AJvH2SvNM=;
        b=p0l3Kd3gSKAcsdTo87PcDRvp95lkI8ngrS0tLM2My3J67debcJPz08Z+9XV/PuS9P9
         gAJrKc9ruPJ07XNgVexhdLUK0fvDDmrq1+184619JcmUmWwOH5SKXqmYHrIKhPMSIfTj
         E0ilRS15tCTtgVbSSJXnRizLtJMXYQ4qoilHIc5kGCqnUSBP4EZLaHD2Uh76ysmtTVGE
         ++PqA9ob6HtU5N6aq7GuLDY7eezF8YAldy4+gyN2xRAkJlSz6t3Bg8jS2VwlOsxb3kbg
         yXPyYcZSjaK4O+52wdVUIwIgnVS97T9UIYUFmNOB4iSFvH4Jo3jG1Z6mgpfoXmjXc8gL
         9E0w==
In-Reply-To: <20181112155406.rtx7ze2l3gadmiyx@MacBook-Pro-91.local>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Josef Bacik <josef@toxicpanda.com>
Cc: Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>, 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, lennart@poettering.net

On 11/12/18 8:54 AM, Josef Bacik wrote:
> On Mon, Nov 12, 2018 at 08:48:35AM -0700, Jens Axboe wrote:
>> On 11/12/18 8:45 AM, Paolo Valente wrote:
>>> BTW, since this patch series is probably even more useful for older
>>> than for future kernels, might it make sense to also propose it for
>>> stable/longterm kernels (provided that such a possibility exists)?
>>
>> That just not how things work, we don't put different things in
>> older/stable kernels, it's strictly backports of what we have in
>> current/newer kernels. Hence it appears to be a dead end right now.
>>
> 
> It may not be useful currently, but my plans are to do a scheduler agnostic
> proportional io controller next, so having these interfaces unified would be
> nice so I don't have to do a rqos.io.weight or something similar.  Thanks,

I'm not saying the work isn't useful, I'm saying that we can't go adding
different interfaces to stable kernels than what we currently have in
tip. I'm all for unified interfaces for this kind of thing, it's much
better than having something that's specific to any given
implementation.

-- 
Jens Axboe

