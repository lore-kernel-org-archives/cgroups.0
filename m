From: Liu Bo <obuil.liubo@gmail.com>
Subject: Re: [PATCH v3] block: fix blk-iolatency accounting underflow
Date: Mon, 17 Dec 2018 15:23:38 -0800
Message-ID: <CANQeFDCeRk0L2iHu=nTGXV8baP2bUc+JRba3TY6QkpKaQcY+qw@mail.gmail.com>
References: <20181217160351.27903-1-dennis@kernel.org> <CANQeFDAO5PdMOrZnn0UgFHcHGvXEs7qS9Kqrk1KRCAwgfRzSOg@mail.gmail.com>
 <20181217212826.GA71824@dennisz-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I1fVBVfy/g93s89oCYn5/KG5kzEYJN7gIMTDDrnaCuI=;
        b=U2TYM9RaEQXF1NRZzNKh2pzzubSjS0vC+FE18iPHz/dPbr1b+6LrcklIjSfCj+U+w2
         QLd1556fp3wX1qbWvwWE12PSa1977jcsBfZ+WkNkUQ03bUKIMGMvQKndUO8uKARH2mKE
         ruiY2kitRMmKIeJ5a9mD1SHx3GE78lhHyVW/hQSUSKjIZjGmIiCSwXIMXDv3Y2KZsUFA
         x6ORTRBQnJW3Y4TbJBmk1vnu/bwXkwtK2aZyRx8G0zKD2Jb6pmPhR7KmpKhAjy2NTZmn
         QKRELWIosJLoMH6eXgSpbij4c286+bulS3wj48+xk9e4bKoRAe9XsL8SIKvKKnUYOsVR
         1i4g==
In-Reply-To: <20181217212826.GA71824@dennisz-mbp.dhcp.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Dec 17, 2018 at 1:28 PM Dennis Zhou <dennis@kernel.org> wrote:
>
> On Mon, Dec 17, 2018 at 11:42:28AM -0800, Liu Bo wrote:
> > On Mon, Dec 17, 2018 at 8:04 AM Dennis Zhou <dennis@kernel.org> wrote:
> > >
> > > The blk-iolatency controller measures the time from rq_qos_throttle() to
> > > rq_qos_done_bio() and attributes this time to the first bio that needs
> > > to create the request. This means if a bio is plug-mergeable or
> > > bio-mergeable, it gets to bypass the blk-iolatency controller.
> > >
> >
> > Hi,
> >
> > I have a question about merging in plug list, since plug merges are
> > done before rq_qos_throttle(), why would plug-mergeable bios bypass
> > the controller?
> >
> > thanks,
> > liubo
> >
>
> Hi Liubo,
>
> BIO_TRACKED is tagging the bio that is responsible for allocating a new
> request, so that rq_qos controllers can decide whether or not they want
> to process the bio any part of the way. I should have phrased that a
> little better in the commit message. It's not that the bio itself is
> bypassing the blk-iolatency controller, but the blk-iolatency controller
> deciding to not do anything based on the BIO_TRACKED flag. This doesn't
> change any of the function calls made on a bio/request.
>

Thanks for the explanation.
I see it now, so the mentioned series had associated all bios with a
blkg if possible so that done_bio() bumps up inflight counter even in
case a bio has been merged in a previous request.

BIO_TRACKED seems to be too generic to use, but otherwise it makes sense to me,
Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
liubo

> Thanks,
> Dennis
