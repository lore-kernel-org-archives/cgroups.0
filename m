From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [RFC v4 5/8] dmabuf: Add gpu cgroup charge transfer function
Date: Tue, 5 Apr 2022 14:12:45 +0200
Message-ID: <20220405121245.GA30368@blackbody.suse.cz>
References: <20220328035951.1817417-1-tjmercier@google.com>
 <20220328035951.1817417-6-tjmercier@google.com>
 <20220329152142.GA15794@blackbody.suse.cz>
 <CABdmKX2874NdYCBzpKLnqWhZQDkC2wKz4ZL_aFNqrec6iAutpQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-media-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649160767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YGolTQlWegdqsJgfgfOCgFdotBM/n5qIvgfFfvEjxd0=;
        b=BK6a6qL8o7p/MJgbNqqctnSF5bmv5BGKuuqBTv2USITbTpPoKI1f15ogW871KoTo/RdheN
        2ofE8y9/q59bmAhdL1seIYTAGQd263xP4FVoKwCcc/FYdRc3tUwqP3pmlISrihOeY4NF+U
        B5AcViJAx3CYaDGctEIJbO7LJzMoxwU=
Content-Disposition: inline
In-Reply-To: <CABdmKX2874NdYCBzpKLnqWhZQDkC2wKz4ZL_aFNqrec6iAutpQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier@google.com>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laura

On Fri, Apr 01, 2022 at 11:41:36AM -0700, "T.J. Mercier" <tjmercier@google.com> wrote:
> This link doesn't work for me, but I think you're referring to the
> discussion about your "RAM_backed_buffers" comment from March 23rd.

(Oops, it's a non-public message. But yes, you guessed it right ;-))

> Anyway the test I did goes like this: enable memcg and gpu cgoups
> tracking and run a process that allocates 100MiB of dmabufs. Observe
> memcg and gpu accounting values before and after the allocation.

Thanks for this measurement/dem/demoo.

> Before
> # cat memory.current gpu.memory.current
> 14909440
> system 0
> 
> <Test program does the allocation of 100MiB of dmabufs>
> 
> After
> # cat memory.current gpu.memory.current
> 48025600
> system 104857600
> 
> So the memcg value increases by about 30 MiB while the gpu values
> increases by 100 MiB.

> This is with kmem enabled, and the /proc/maps
> file for this process indicates that the majority of that 30 MiB is
> kernel memory.

> I think this result shows that neither the kernel nor process memory
> overlap with the gpu cgroup tracking of these allocations.

It depends how the semantics of the 'system' entry is defined, no?
As I grasped from other thread, the 'total' is going to be removed, so
'system' represents exclusively device memory?


> So despite the fact that these buffers are in main memory, they are
> allocated in a way that does not result in memcg attribution. (It
> looks to me like __GFP_ACCOUNT is not set for these.)

(I thought you knew what dmabufs your program used :-p)

So, the goal is to do the tracking and migrations only via the gpu cg
layer, regardless how memcg charges it (or not).

(I have no opinion on that, I'm just summing it so that we're on the
same page.)

Michal
