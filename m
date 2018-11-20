From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH V2 00/10] unify the interface of the proportional-share
 policy in blkio/io
Date: Tue, 20 Nov 2018 08:28:16 -0800
Message-ID: <20181120162816.GV2509588@devbig004.ftw2.facebook.com>
References: <20181119103424.3853-1-paolo.valente@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6pLLM1p+5cDN52i8L+l5I/RKjfgAuOq/8xc6t5eHQeA=;
        b=Q1dmlJaqef4PhMUe8KijF7vIIIQS/5OPUDZ76zqN9VTRe3/eXoy3K4ifcH/33T68vy
         ydDsdzCnml+hVBgexIcWmYgG5c19ZDDCoW+8WPcss4AhjWlpuO4AZDw5CDgrQ9vinafm
         QYyzS2Ddi8K9t4Uqk4ZMZmMBRhaxeGJQDBiZtlo+9xDem/jc5cFPoyRQKMUlHGGvQmeW
         0is3bdkuDj/ZhDl/9jTEOdjhwbfCrZ9LG5iZjounIfuwVo3XqGWSf6w9KG5BSOJfUxFo
         04pPI4WxX0FmPvvEcltUAJtrmcvXDpJAlWx9juT3oINlVeRaIbVnoF6PGQm4cAdiQbQB
         tbcQ==
Content-Disposition: inline
In-Reply-To: <20181119103424.3853-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>

Hello, Paolo.

On Mon, Nov 19, 2018 at 11:34:14AM +0100, Paolo Valente wrote:
> - if all entities produce the same output, the this common output is
>  shown only once;
> - if the outputs differ, then every per-entity output is shown,
>  followed by the name of the entity that produced that output.

So, this doesn't make sense to me.  One set of numbers is meaningful,
the other not and the user doesn't have a way to tell which one is.
It makes no sense to present both numbers.

Thanks.

-- 
tejun
