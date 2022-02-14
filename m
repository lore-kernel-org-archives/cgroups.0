From: Hridya Valsaraju <hridya@google.com>
Subject: Re: [RFC v2 6/6] android: binder: Add a buffer flag to relinquish
 ownership of fds
Date: Mon, 14 Feb 2022 13:14:51 -0800
Message-ID: <CA+wgaPM8AmQ4g6pDSwRABtc7hq11XMw+kH-rRkB8xNGJhM3OKA@mail.gmail.com>
References: <20220211161831.3493782-1-tjmercier@google.com>
 <20220211161831.3493782-7-tjmercier@google.com> <Ygdfe3XSvN8iFuUc@kroah.com>
 <CAHRSSEwoJ67Sr_=gtSaP91cbpjJjZdOo57cfAhv3r-ye0da7PA@mail.gmail.com>
 <CAJuCfpHf=Ewm0e9kguY3MEGVHU_cyviVXByi0oQtq7kTtOOD=A@mail.gmail.com>
 <CAHRSSEzsn-EVKXTRfmpbPR9u0wNpdvdZoX64Tm_mB1DQMRSUPQ@mail.gmail.com> <CALAqxLVeLsv9ESCL2EoZQ8-tRgp0V+tmdYbkyakFetf=ewTH+A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=koOwKzeH7/Gb78FEuOvCok9kPJwObv2S7DVJdDdOgNA=;
        b=Pb5dbCHSbOY7B3ORjcQJ4tOqYQjm9jFUDuW4A8Uw3ddfl/KioQspJ7vPApWeypuuyQ
         AbdlnFPPC52dg3yNb0beEJdpRbmFdEDeTuxJF39E+eg6ecEa/6ji0TduWQr0JYt33wqk
         F00WTtwEQGRE8fkzuYE19P4BzBBNjs+GOqaHl31cAznCEZMsRqDikQkTwDJclPuKCvxV
         kmxmrEI4FfjSSPAK5el+JyX7Hj1ZqafjYSIjdKPhGDhpAMZDyhpvvBv0wjDJRI2gXsaV
         ekGOhI3vLetimUVdXqmZTzeAxc7HUExrhEQoRc2Vs4Ips6kQQ/pBnxkN2I0ZLJPdeW+t
         EH2g==
In-Reply-To: <CALAqxLVeLsv9ESCL2EoZQ8-tRgp0V+tmdYbkyakFetf=ewTH+A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: John Stultz <john.stultz@linaro.org>
Cc: Todd Kjos <tkjos@google.com>, Suren Baghdasaryan <surenb@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "T.J. Mercier" <tjmercier@google.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jonathan Corbet <corbet@lwn.net>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam

On Mon, Feb 14, 2022 at 12:37 PM John Stultz <john.stultz@linaro.org> wrote:
>
> On Mon, Feb 14, 2022 at 12:19 PM Todd Kjos <tkjos@google.com> wrote:
> > On Mon, Feb 14, 2022 at 11:29 AM Suren Baghdasaryan <surenb@google.com> wrote:
> > > On Mon, Feb 14, 2022 at 10:33 AM Todd Kjos <tkjos@google.com> wrote:
> > > >
> > > > Since we are creating a new gpu cgroup abstraction, couldn't this
> > > > "transfer" be done in userspace by the target instead of in the kernel
> > > > driver? Then this patch would reduce to just a flag on the buffer
> > > > object.
> > >
> > > Are you suggesting to have a userspace accessible cgroup interface for
> > > transferring buffer charges and the target process to use that
> > > interface for requesting the buffer to be charged to its cgroup?
> >
> > Well, I'm asking why we need to do these cgroup-ish actions in the
> > kernel when it seems more natural to do it in userspace.

This was our plan originally i.e. to create a cgroup interface that
userspace could use for explicit charge transfer. However, in our
initial discussions with all interested parties and cgroup maintainers
we reached a conclusion that an explicit charge transfer UAPI for the
cgroup controller did not fit in with the current cgroup
charge/uncharge mechanisms. Like John mentioned, the charge transfer
during binder IPC was suggested by Daniel during LPC.

Regards,
Hridya

> >
>
> In case its useful, some additional context from some of the Linux
> Plumber's discussions last fall:
>
> Daniel Stone outlines some concerns with the cgroup userland handling
> for accounting:
>   https://youtu.be/3OqllZONTiQ?t=3430
>
> And the binder ownership transfer bit was suggested here by Daniel Vetter:
>   https://youtu.be/3OqllZONTiQ?t=3730
>
> thanks
> -john
