From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 0/6] Proposal for a GPU cgroup controller
Date: Fri, 13 May 2022 06:13:25 -1000
Message-ID: <Yn6DpUsoSz1/15Kc@slm.duckdns.org>
References: <20220510235653.933868-1-tjmercier@google.com>
 <3365cd1d750e84fedc8e75d646a77ffd85619d35.camel@ndufresne.ca>
 <CABdmKX3ZV6-u-oLvW_wWavAMBfrsZ=C_rCgK_Uz4VjxcRvRFew@mail.gmail.com>
 <81026ef07c1ce20f8673b75b17bab79a2b39c548.camel@ndufresne.ca>
 <CABdmKX2LxZ6zZR=fhXfnuWCB2BR+gzDd1-t1DD2A2XP24wvuGQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n4Ua5qSAHgvrptVTXpgV4jY28Fp/1ApPJcGYkkazweE=;
        b=dh+CcTt4AjCORsqV1ZODlBqFq+OvMka9auOOZykOuG9GwHD05RDvn63lEcsItiN2eH
         nH+MkFBQ8v1tdeWUMN4BRvaW+7Q1uwmQiOctS5wPsQLKRk5Ykt9si+fUFSf6n/at1dmY
         4JOHexwRERxmPXQVd5EWv4mWhFA3BXiW4pCX0ZdVzHtYoUWHmurH8uIA0uBpYInyofFZ
         pNEuW8xEgDqjAmuzWH27jn+y85YMNek74F2xgDatREWDoXEvBkL4SnO/axBiM7vQgUS4
         gbWP9yrJI2fCACw+ngKTCewWFxR85tswkrdeT3TpOZ3UiGjOL9rgao5yscsrH/9y3/bl
         VBAw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CABdmKX2LxZ6zZR=fhXfnuWCB2BR+gzDd1-t1DD2A2XP24wvuGQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, Liam Mark <lmark@codeaurora.org>, Laura Abbott <labbott@redhat.com>, Brian Starkey <Brian.Starkey@arm.com>, John

Hello,

On Thu, May 12, 2022 at 08:43:52PM -0700, T.J. Mercier wrote:
> > I'm actually happy I've asked this question, wasn't silly after all. I think the
> > problem here is a naming issue. What you really are monitor is "video memory",
> > which consist of a memory segment allocated to store data used to render images
> > (its not always images of course, GPU an VPU have specialized buffers for their
> > purpose).
> >
> > Whether this should be split between what is used specifically by the GPU
> > drivers, the display drivers, the VPU (CODEC and pre/post-processor) or camera
> > drivers is something that should be discussed. But in the current approach, you
> > really meant Video memory as a superset of the above. Personally, I think
> > generically (to de-Andronized your work), en-globing all video memory is
> > sufficient. What I fail to understand is how you will manage to distinguished
> > DMABuf Heap allocation (which are used outside of Android btw), from Video
> > allocation or other type of usage. I'm sure non-video usage will exist in the
> > future (think of machine learning, compute, other high bandwidth streaming
> > thingy ...)
> >
> Ok thank you for pointing out the naming issue. The naming is a
> consequence of the initial use case, but I guess it's too specific.
> What I want out of this change is that android can track dmabufs that
> come out of heaps, and drm can track gpu memory. But other drivers
> could track different resources under different names. Imagine this
> were called a buffer cgroup controller instead of a GPU cgroup
> controller. Then the use component ("video memory") isn't tied up with
> the name of the controller, but it's up to the name of the bucket the
> resource is tracked under. I think this meets the needs of the two use
> cases I'm aware of now, while leaving the door open to other future
> needs. Really the controller is just enabling abstract named buckets
> for tracking and eventually limiting a type of resource.

So, there hasn't been whole lot of discussion w/ other GPU folks and what
comes up still seems to indicate that we're still long way away from having
a meaningful gpu controller. For your use case, would it make sense to just
add dmabuf as a key to the misc controller? I'm not sure it makes sense to
push "gpu controller" forward if there's no conceptual consensus around what
resources are.

Thanks.

-- 
tejun
