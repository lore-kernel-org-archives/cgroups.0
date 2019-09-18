From: Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 2/2] block, bfq: delete "bfq" prefix from cgroup filenames
Date: Wed, 18 Sep 2019 08:09:42 +0200
Message-ID: <CAPDyKFrHeEb77F-U3W1HdSj3_rrMyi66XCt73By3OoLOVa65bQ@mail.gmail.com>
References: <20190917165148.19146-1-paolo.valente@linaro.org>
 <20190917165148.19146-3-paolo.valente@linaro.org> <20190917213209.GK3084169@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xTBwbLii9b70VDIiu2pkAKMCAWF61Wo+h6WzPYHryB4=;
        b=T+rtTKk5TFAHOQsUgV/It9GsfiXKaB+bhfa5dN/sLkCoY4OmhkyktixzO9f+8YwHkk
         cEwMurZ/Mg+6d/IyWE/VoTFh6ibwd0Mwl6dha6HSGU+9F+3oa3E4SG8ssP4tJD2gAj2Z
         CgfhsGf+P+xpNd67ACMjlLHF9Vo5pLWNL+0rS9zkvOMFSZdZhpHuEdLXnjGXRBDdZa05
         gMHUHQCZdMtNI95/7aMMVk9PajYLgBwdgoxrI69ssFUOuabdzO4bzrjNDV04fRzwiUtG
         OU6mo3S5DUmnJ0GDQ58haSoMZ17PjkKDKF6Z+zaNrgrM1JI3wMct87apJQWCU/YgECc4
         x8Ew==
In-Reply-To: <20190917213209.GK3084169@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, 'Paolo Valente' via bfq-iosched <bfq-iosched@googlegroups.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, cgroups@vger.kernel.org, Angelo Ruocco <angeloruocco90@gmail.com>

Tejun, Paolo,

On Tue, 17 Sep 2019 at 23:32, Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Tue, Sep 17, 2019 at 06:51:48PM +0200, Paolo Valente wrote:
> > When bfq was merged into mainline, there were two I/O schedulers that
> > implemented the proportional-share policy: bfq for blk-mq and cfq for
> > legacy blk. bfq's interface files in the blkio/io controller have the
> > same names as cfq. But the cgroups interface doesn't allow two
> > entities to use the same name for their files, so for bfq we had to
> > prepend the "bfq" prefix to each of its files. However no legacy code
> > uses these modified file names. This naming also causes confusion, as,
> > e.g., in [1].
> >
> > Now cfq has gone with legacy blk, so there is no need any longer for
> > these prefixes in (the never used) bfq names. In view of this fact, this
> > commit removes these prefixes, thereby enabling legacy code to truly
> > use the proportional share policy in blk-mq.
>
> So, I wrote the iocost switching patch and don't have a strong
> interest in whether bfq prefix should get dropped or not.  However, I
> gotta point out that flipping interface this way is way out of the
> norm.
>
> In the previous release cycle, the right thing to do was dropping the
> bfq prefix but that wasn't possible because bfq's interface wasn't
> compatible at that point and didn't made to be compatible in time.

Sounds like we really should send those relevant patches for stable,
to set the correct ground. Then using a symlink, to make sure we don't
brake current ABI, right?

[...]

Kind regards
Uffe
