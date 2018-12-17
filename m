From: Dennis Zhou <dennis@kernel.org>
Subject: Re: [PATCH v3] block: fix blk-iolatency accounting underflow
Date: Mon, 17 Dec 2018 16:28:26 -0500
Message-ID: <20181217212826.GA71824@dennisz-mbp.dhcp.thefacebook.com>
References: <20181217160351.27903-1-dennis@kernel.org>
 <CANQeFDAO5PdMOrZnn0UgFHcHGvXEs7qS9Kqrk1KRCAwgfRzSOg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANQeFDAO5PdMOrZnn0UgFHcHGvXEs7qS9Kqrk1KRCAwgfRzSOg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Liu Bo <obuil.liubo@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Dec 17, 2018 at 11:42:28AM -0800, Liu Bo wrote:
> On Mon, Dec 17, 2018 at 8:04 AM Dennis Zhou <dennis@kernel.org> wrote:
> >
> > The blk-iolatency controller measures the time from rq_qos_throttle() to
> > rq_qos_done_bio() and attributes this time to the first bio that needs
> > to create the request. This means if a bio is plug-mergeable or
> > bio-mergeable, it gets to bypass the blk-iolatency controller.
> >
> 
> Hi,
> 
> I have a question about merging in plug list, since plug merges are
> done before rq_qos_throttle(), why would plug-mergeable bios bypass
> the controller?
> 
> thanks,
> liubo
> 

Hi Liubo,

BIO_TRACKED is tagging the bio that is responsible for allocating a new
request, so that rq_qos controllers can decide whether or not they want
to process the bio any part of the way. I should have phrased that a
little better in the commit message. It's not that the bio itself is
bypassing the blk-iolatency controller, but the blk-iolatency controller
deciding to not do anything based on the BIO_TRACKED flag. This doesn't
change any of the function calls made on a bio/request.

Thanks,
Dennis
