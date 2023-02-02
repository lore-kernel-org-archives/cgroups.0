From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 05/15] blk-cgroup: store a gendisk to throttle in struct
 task_struct
Date: Thu, 2 Feb 2023 07:57:46 -1000
Message-ID: <Y9v5mqqd8tVy67KJ@slm.duckdns.org>
References: <20230124065716.152286-1-hch@lst.de>
 <20230124065716.152286-6-hch@lst.de>
 <Y9Rg0GuNAmJPlDri@slm.duckdns.org>
 <20230201080635.GA8112@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J868v/GWsw/sdOuEih4FZi6MVpQ5U6Xfy4+ZzeGKSSY=;
        b=WnuM3wG3BnaRK/PHa4g1RIcgwiErDE8gggba3If8Q8GnilHU08DD31ANGbVa8Q6KCs
         vbb6XzZNI9axv+/+M7kiweOTOm6aY901RBHzczpV0ay+u0bh/1uqFOqwhZALoT66eDWG
         YrA138bUs+3/EjIQjIogajqW5bzCGHwfqLHtTSZvjTAWoklFC919icaurVy9VVRgYg+L
         AcgkxPk9d23q3MbUyEkY0qQDegJobtaT46ivyBih+y0Kcj/z7mZi6fsMUigzgSrosMlW
         coCAfkX5CSUEdJUafUnEioT3kNqhN6X1exwcHtKqyQUd+dQBVjizzSkIEAY9cFxmPAXN
         B0PQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230201080635.GA8112@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Andreas Herrmann <aherrmann@suse.de>

Sorry about late reply.

On Wed, Feb 01, 2023 at 09:06:35AM +0100, Christoph Hellwig wrote:
> On Fri, Jan 27, 2023 at 01:40:00PM -1000, Tejun Heo wrote:
> > So, we're shifting the dead test from schedule to the actual throttle path,
> > which makes sense but I think this should at least be mentioned in the
> > description if not put in its own patch.
> 
> That's what I tried to say with:
> 
> "Move the check for the dead disk to the latest place now that is is
>  unbundled from the reference grab."
> 
> what else would you want me to write?

It'd be better if the paragraph actually said where that change is being
made along with why and whether it causes any behavior difference.

This seems safe to me but I can't tell why it's being moved. Maybe it's
better because that's "latest" but that's a lot hanging on that single word.
If this is better because we're testing it later instead of to accomodate
other changes being made, this should be a separate patch, right? It's a
subtle behavior change which is buried with a bunch of other mechanical
changes.

Thanks.

-- 
tejun
