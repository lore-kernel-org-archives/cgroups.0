From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 0/2] eventfd: simplify signal helpers
Date: Fri, 14 Jul 2023 09:05:21 +0200
Message-ID: <20230714-gauner-unsolidarisch-fc51f96c61e8@brauner>
References: <20230630155936.3015595-1-jaz@semihalf.com>
Mime-Version: 1.0
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689318339;
        bh=jyWvUrZcUvjNBBSZOzXCNGPPxcxV/q9OYHwe4H3B3Lw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ukDx1eRh8ZivXqHNYBn5Q0ezu7jPxA8DBkgLn6Yr4ieEasOnILafdrjyXNGEm446B
         vdoY8r4oSZIdNajc3UECepRL8sXl8WF1aY3nsBTYeT1jETstZ0f8AhW7bTRQc/52Qq
         P+stCjuut9rZUb/FtZq2RC8GkYNcmH18gWUjcC/YVZwiCNSkJoOeVjb4/L8KcmM6xP
         IeKh3hfbNuWYqjO1NcV70XYwdDRmrE9otI0QO8uXvZ2x+z2rjsCQR5r+pIi8kHOFqH
         yUig3DyDnWCSEK1kxr9YLeu9ZSrBGXd6ZPFhVoSKNhVLjgUv6X+4bGRfk/gzLXxZ3w
         K4WbhoY8kPy2A==
Content-Disposition: inline
In-Reply-To: <20230630155936.3015595-1-jaz@semihalf.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-usb@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>, Paul Durrant <paul@xen.org>, Tom Rix <trix@redhat.com>, Jason Wang <jasowang@redhat.com>, dri-devel@lists.freedesktop.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Kirti Wankhede <kwankhede@nvidia.com>, Paolo Bonzini <pbonzini@redhat.com>, Jens Axboe <axboe@kernel.dk>, Vineeth Vijayan <vneethv@linux.ibm.com>, Diana Craciun <diana.craciun@oss.nxp.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shakeel Butt <shakeelb@google.com>, Vasily Gorbik <gor@linux.ibm.com>, Leon Romanovsky <leon@kernel.org>, Harald Freudenberger <freude@linux.ibm.com>, Fei Li <fei1.li@intel.com>, x86@kernel.org

On Thu, Jul 13, 2023 at 11:10:54AM -0600, Alex Williamson wrote:
> On Thu, 13 Jul 2023 12:05:36 +0200
> Christian Brauner <brauner@kernel.org> wrote:
> 
> > Hey everyone,
> > 
> > This simplifies the eventfd_signal() and eventfd_signal_mask() helpers
> > by removing the count argument which is effectively unused.
> 
> We have a patch under review which does in fact make use of the
> signaling value:
> 
> https://lore.kernel.org/all/20230630155936.3015595-1-jaz@semihalf.com/

Huh, thanks for the link.

Quoting from
https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-jaz@semihalf.com/#25266856

> Reading an eventfd returns an 8-byte value, we generally only use it
> as a counter, but it's been discussed previously and IIRC, it's possible
> to use that value as a notification value.

So the goal is to pipe a specific value through eventfd? But it is
explicitly a counter. The whole thing is written around a counter and
each write and signal adds to the counter.

The consequences are pretty well described in the cover letter of
v6 https://lore.kernel.org/all/20230630155936.3015595-1-jaz@semihalf.com/

> Since the eventfd counter is used as ACPI notification value
> placeholder, the eventfd signaling needs to be serialized in order to
> not end up with notification values being coalesced. Therefore ACPI
> notification values are buffered and signalized one by one, when the
> previous notification value has been consumed.

But isn't this a good indication that you really don't want an eventfd
but something that's explicitly designed to associate specific data with
a notification? Using eventfd in that manner requires serialization,
buffering, and enforces ordering.

I have no skin in the game aside from having to drop this conversion
which I'm fine to do if there are actually users for this btu really,
that looks a lot like abusing an api that really wasn't designed for
this.
