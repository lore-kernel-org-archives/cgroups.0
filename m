From: "T.J. Mercier" <tjmercier@google.com>
Subject: Re: [PATCH v7 0/6] Proposal for a GPU cgroup controller
Date: Fri, 20 May 2022 09:25:38 -0700
Message-ID: <CABdmKX2Ok023rN1drQgXVZLKUO_DVYrzmEamCgMMu6BPO67yhQ@mail.gmail.com>
References: <20220510235653.933868-1-tjmercier@google.com> <3365cd1d750e84fedc8e75d646a77ffd85619d35.camel@ndufresne.ca>
 <CABdmKX3ZV6-u-oLvW_wWavAMBfrsZ=C_rCgK_Uz4VjxcRvRFew@mail.gmail.com>
 <81026ef07c1ce20f8673b75b17bab79a2b39c548.camel@ndufresne.ca>
 <CABdmKX2LxZ6zZR=fhXfnuWCB2BR+gzDd1-t1DD2A2XP24wvuGQ@mail.gmail.com>
 <Yn6DpUsoSz1/15Kc@slm.duckdns.org> <CABdmKX1xvm87WMEDkMc9Aye46E4zv1-scenwgaRxHesrOCsaYg@mail.gmail.com>
 <YodHjYlMx1XGtM2+@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FUaa/CsIoXFhGcqQomBYha0KA+E1xpoSdaSoOErgusY=;
        b=sCdCdZqIB2fM6C3/IMxJnyMHv4TxKGmIAEibbdWMh6FRbyWFI9mTEtryWRZ/NF+hj8
         +Hx7jY6REjkdGsBVNwZIlsBAmuMkblQlokQialFoP0r3E+mVoJ7qGv/cmH27SzZH0S3E
         6LoxOjAbQe+XtYP+GErjofpGVizVrpa3tPrxVs+yqbwCv/s6FVcSIgxyZOKq/Unt6sfK
         WQdH0KeBkcXcGDUDuTf8vX6Et8/Yi9aMTfXHIESge8rquWo4PxOSekV4zJTp0tvovfMW
         u6nTEG2KKtXD08jklErYVdrtfiimeio1bUddW1+xIx6fvJXFqqsrZgzOoeJe1LhQ/lrW
         jHfA==
In-Reply-To: <YodHjYlMx1XGtM2+@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, Liam Mark <lmark@codeaurora.org>, Laura Abbott <labbott@redhat.com>, Brian Starkey <Brian.Starkey@arm.com>, John

On Fri, May 20, 2022 at 12:47 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Tue, May 17, 2022 at 04:30:29PM -0700, T.J. Mercier wrote:
> > Thanks for your suggestion. This almost works. "dmabuf" as a key could
> > work, but I'd actually like to account for each heap. Since heaps can
> > be dynamically added, I can't accommodate every potential heap name by
> > hardcoding registrations in the misc controller.
>
> On its own, that's a pretty weak reason to be adding a separate gpu
> controller especially given that it doesn't really seem to be one with
> proper abstractions for gpu resources. We don't want to keep adding random
> keys to misc controller but can definitely add limited flexibility. What
> kind of keys do you need?
>
Well the dmabuf-from-heaps component of this is the initial use case.
I was envisioning we'd have additional keys as discussed here:
https://lore.kernel.org/lkml/20220328035951.1817417-1-tjmercier@google.com/T/#m82e5fe9d8674bb60160701e52dae4356fea2ddfa
So we'd end up with a well-defined core set of keys like "system", and
then drivers would be free to use their own keys for their own unique
purposes which could be complementary or orthogonal to the core set.
Yesterday I was talking with someone who is interested in limiting gpu
cores and bus IDs in addition to gpu memory. How to define core keys
is the part where it looks like there's trouble.

For my use case it would be sufficient to have current and maximum
values for an arbitrary number of keys - one per heap. So the only
part missing from the misc controller (for my use case) is the ability
to register a new key at runtime as heaps are added. Instead of
keeping track of resources with enum misc_res_type, requesting a
resource handle/ID from the misc controller at runtime is what I think
would be required instead.

> Thanks.
>
> --
> tejun
