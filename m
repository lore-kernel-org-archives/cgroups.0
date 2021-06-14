From: Kirill Kolyshkin <kolyshkin@gmail.com>
Subject: Re: [PATCH 1/3] docs: block/bfq: describe per-device weight
Date: Mon, 14 Jun 2021 14:03:37 -0700
Message-ID: <CAGmPdrzudz1xS_NaQASbNMbV-uPOq=d9VfBfYNBafEaP8YesGw@mail.gmail.com>
References: <20210611030737.1984343-1-kolyshkin@gmail.com> <20210611030737.1984343-2-kolyshkin@gmail.com>
 <8735tlbbml.fsf@meer.lwn.net>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VJNQ58fPboxZ6jLtS5aQ6QCEiZ6o7j6B3BgLz2sHkSM=;
        b=jytBZoPzlATDFMDIFjt7KaYNYb/uYZCnhJ7EWRXHvrQL+Ii3byJsNKC6frIvaHdRXk
         oJwTaBTgUnuNRDmW3Up2IaEgEqWxBBHo9tYAofgt3D5l3qC+rvpwejcjd5D5PbZdBZC9
         6XcP6JxaC+mGGgPAplTn/Fejv/Pxv9qf0MZ9miinWTKxHo6VjPwZzTNj7y41YarKjvqU
         H0XF86RFYkZnNiDNWHOSWsPF6NT8LZIA7rEosPk9jIt2kRY7n7r4NvLoa91vqVLSNRsr
         JWEFzmz+clsUDhUk7IcyOsJX0sIzszmHUKUQPRg08bJGeGqghAiysXRWYuy33rBvlbp2
         l1kg==
In-Reply-To: <8735tlbbml.fsf@meer.lwn.net>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, cgroups@vger.kernel.org

On Sun, Jun 13, 2021 at 4:14 PM Jonathan Corbet <corbet@lwn.net> wrote:
>
> Kir Kolyshkin <kolyshkin@gmail.com> writes:
>
> This work looks generally good, but...
>
> > The functionality of setting per-device weight for BFQ was added
> > in v5.4 (commit 795fe54c2a828099), but the documentation was never
> > updated.
> >
> > While at it, improve formatting a bit.
> >
> > Signed-off-by: Kir Kolyshkin <kolyshkin@gmail.com>
> > ---
> >  Documentation/block/bfq-iosched.rst | 38 ++++++++++++++++++++---------
> >  1 file changed, 27 insertions(+), 11 deletions(-)
> >
> > diff --git a/Documentation/block/bfq-iosched.rst b/Documentation/block/bfq-iosched.rst
> > index 66c5a4e54130..7200152c461e 100644
> > --- a/Documentation/block/bfq-iosched.rst
> > +++ b/Documentation/block/bfq-iosched.rst
> > @@ -553,20 +553,36 @@ throughput sustainable with bfq, because updating the blkio.bfq.*
> >  stats is rather costly, especially for some of the stats enabled by
> >  CONFIG_BFQ_CGROUP_DEBUG.
> >
> > -Parameters to set
> > ------------------
> > +Parameters
> > +----------
> >
> > -For each group, there is only the following parameter to set.
> > +For each group, the following parameters cat be set:
>
> Could we please not introduce new typos while fixing other stuff?

Are you a dog person? :)

Thanks for catching this, corrected patch sent.
