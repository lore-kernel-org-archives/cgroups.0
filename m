From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v4 2/8] cgroup: gpu: Add a cgroup controller for allocator
 attribution of GPU memory
Date: Wed, 30 Mar 2022 13:56:09 -0700
Message-ID: <CABdmKX2Gxg35k7QiL2Vn4zWhmQ4UnM-Z8cnOXR0fwBWyJnZ+Ng@mail.gmail.com>
References: <20220328035951.1817417-1-tjmercier@google.com>
 <20220328035951.1817417-3-tjmercier@google.com> <YkM6/57mVxoNfSvm@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nrCvj7Yq7SSib6FwgrmdzFU7UXWII5P9ju8EtUscCW0=;
        b=boNOk7s9MFWRe9Q5TIHyCBcLZAL3UIEBNmLOOWFhXw6emE+CwKKHdvhC0KffHeh0nF
         M6pQueP4aCRuJFI7dDzsd8w7oMHmH5zQ1LRTPvQqJiDWbX35wE19ft4HqpfvXL9C1Got
         NCX+Q7kxCou/I+IrAEJ9Str9SLE8Vpfu1F+nizveKZzqZBmp0ZbLt4163c8iNRc9oq8L
         +OvcysVAV7F4grrtlsY0RpODotiBIJhRyklfusZBaq0zNt0ADmOlhrzyjpVkba5kg+sN
         XtIoUFtjlMDxb5pCPzyxnwJLsJ9yaQfPKTqYXEV4ifVXSG43LsveuoFab9UFC5oCyEkr
         VAUA==
In-Reply-To: <YkM6/57mVxoNfSvm-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laura

On Tue, Mar 29, 2022 at 9:59 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,

I'm sorry for the delay Tejun, my test device stopped working and my
attention has been occupied with that.

>
> On Mon, Mar 28, 2022 at 03:59:41AM +0000, T.J. Mercier wrote:
> > The API/UAPI can be extended to set per-device/total allocation limits
> > in the future.
>
> This total thing kinda bothers me. Can you please provide some concrete
> examples of how this and per-device limits would be used?

The use case we have for accounting the total (separate from the
individual devices) is to include the value as part of bugreports, for
understanding the system-wide amount of dmabuf allocations. I'm not
aware of an existing need to limit the total. Admittedly this is just
the sum over the devices, but we currently maintain out of tree code
to do this sort of thing today. [1]

The per-device limits would be used to restrict the amount of each
type of allocation charged to an individual application to prevent
hogging or to completely prevent access. This limitation is not
something we have implemented today, but it is on our roadmap.

[1] https://android-review.googlesource.com/c/kernel/common/+/1566704/3/drivers/dma-buf/dma-heap.c

>
> Thanks.
>
> --
> tejun
