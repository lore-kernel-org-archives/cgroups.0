From: "T.J. Mercier" <tjmercier@google.com>
Subject: Re: [PATCH v7 0/6] Proposal for a GPU cgroup controller
Date: Tue, 17 May 2022 16:30:29 -0700
Message-ID: <CABdmKX1xvm87WMEDkMc9Aye46E4zv1-scenwgaRxHesrOCsaYg@mail.gmail.com>
References: <20220510235653.933868-1-tjmercier@google.com> <3365cd1d750e84fedc8e75d646a77ffd85619d35.camel@ndufresne.ca>
 <CABdmKX3ZV6-u-oLvW_wWavAMBfrsZ=C_rCgK_Uz4VjxcRvRFew@mail.gmail.com>
 <81026ef07c1ce20f8673b75b17bab79a2b39c548.camel@ndufresne.ca>
 <CABdmKX2LxZ6zZR=fhXfnuWCB2BR+gzDd1-t1DD2A2XP24wvuGQ@mail.gmail.com> <Yn6DpUsoSz1/15Kc@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-media-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kje1fxePklyTYdwuahnUd7jrh3kjOYPr65ooSYjVE44=;
        b=BZgE0jkbkeLVvFmb8ruOV8av8A5Vi/cJesgkFUe7yW3/UIFp5JuLCAIksYmq6dxaPC
         UTmFxH4fn4hS3/gzRePwOA9Zgz2QoeR/e7KsL6wHOQMvCBYOzvoW2yP96YAu1wlsdo/W
         OYW4HOnAUXA1JVGJiazKgXoK/bUipg6BPRZaPd0iU4I6XDCU9CWewInibc8sy+vWJYxb
         GbGtI+anWZDqWuOTylV0pzWc9p1n+hpH4zF0jqzCG43N/eDSdV5LLd69UT0bGeoGyGse
         0mKYTvfzrYVwqtPqL3gqbyjVL7SFmO6Pfdv96YRbeDf3urkh47YcrQa2GcXbFgbNtfr9
         LXxQ==
In-Reply-To: <Yn6DpUsoSz1/15Kc@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, Liam Mark <lmark@codeaurora.org>, Laura Abbott <labbott@redhat.com>, Brian Starkey <Brian.Starkey@arm.com>, John

On Fri, May 13, 2022 at 9:13 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Thu, May 12, 2022 at 08:43:52PM -0700, T.J. Mercier wrote:
> > > I'm actually happy I've asked this question, wasn't silly after all. I think the
> > > problem here is a naming issue. What you really are monitor is "video memory",
> > > which consist of a memory segment allocated to store data used to render images
> > > (its not always images of course, GPU an VPU have specialized buffers for their
> > > purpose).
> > >
> > > Whether this should be split between what is used specifically by the GPU
> > > drivers, the display drivers, the VPU (CODEC and pre/post-processor) or camera
> > > drivers is something that should be discussed. But in the current approach, you
> > > really meant Video memory as a superset of the above. Personally, I think
> > > generically (to de-Andronized your work), en-globing all video memory is
> > > sufficient. What I fail to understand is how you will manage to distinguished
> > > DMABuf Heap allocation (which are used outside of Android btw), from Video
> > > allocation or other type of usage. I'm sure non-video usage will exist in the
> > > future (think of machine learning, compute, other high bandwidth streaming
> > > thingy ...)
> > >
> > Ok thank you for pointing out the naming issue. The naming is a
> > consequence of the initial use case, but I guess it's too specific.
> > What I want out of this change is that android can track dmabufs that
> > come out of heaps, and drm can track gpu memory. But other drivers
> > could track different resources under different names. Imagine this
> > were called a buffer cgroup controller instead of a GPU cgroup
> > controller. Then the use component ("video memory") isn't tied up with
> > the name of the controller, but it's up to the name of the bucket the
> > resource is tracked under. I think this meets the needs of the two use
> > cases I'm aware of now, while leaving the door open to other future
> > needs. Really the controller is just enabling abstract named buckets
> > for tracking and eventually limiting a type of resource.
>
> So, there hasn't been whole lot of discussion w/ other GPU folks and what
> comes up still seems to indicate that we're still long way away from having
> a meaningful gpu controller.
>
Yes, and I would still be happy to collaborate.

> For your use case, would it make sense to just
> add dmabuf as a key to the misc controller?
>
Thanks for your suggestion. This almost works. "dmabuf" as a key could
work, but I'd actually like to account for each heap. Since heaps can
be dynamically added, I can't accommodate every potential heap name by
hardcoding registrations in the misc controller.

> I'm not sure it makes sense to
> push "gpu controller" forward if there's no conceptual consensus around what
> resources are.
>
> Thanks.
>
> --
> tejun
