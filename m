From: "T.J. Mercier" <tjmercier@google.com>
Subject: Re: [RFC v4 5/8] dmabuf: Add gpu cgroup charge transfer function
Date: Tue, 5 Apr 2022 10:48:58 -0700
Message-ID: <CABdmKX0aF5zXozbb7npcEq3PgaeDE=gaGLf+jYY4oRKW9N+46g@mail.gmail.com>
References: <20220328035951.1817417-1-tjmercier@google.com>
 <20220328035951.1817417-6-tjmercier@google.com> <20220329152142.GA15794@blackbody.suse.cz>
 <CABdmKX2874NdYCBzpKLnqWhZQDkC2wKz4ZL_aFNqrec6iAutpQ@mail.gmail.com> <20220405121245.GA30368@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RXCW1evSnb4oJ88sHTAFEYTq0HTuOW2ocRpwnA3InQ4=;
        b=DFediYf4lKdcEGd6wHnf3P2A1rH9d97LcubT3QP6yRNY6vUA82uDkOevPceh0sN/Wl
         AzNDVgFuK6V76WaqpSYAiG2hRF9Re4Ov3xlC/Ms7hpW9uCTQ7y898MEv8Ijbqhc6SxXo
         QvfpY4jywVuV6j8Ii/P3vkQXreEU44Hlqin6E5RTxZAap0ziUpyUXuD83coag22gB7nJ
         kP94eXAsBC1cr7hK8pVNGZaStSW21SliZd84A/wTh+8QK9KZdm23HHaRa8zC2IVlp4fq
         sk905jrtMt/I2FOoTaeCu/ArrkOR8UVb6SsiWhRhquLKZ90pI6vt79FBY7MRBMWLMUZ2
         L8SQ==
In-Reply-To: <20220405121245.GA30368@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laura

On Tue, Apr 5, 2022 at 5:12 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> On Fri, Apr 01, 2022 at 11:41:36AM -0700, "T.J. Mercier" <tjmercier@googl=
e.com> wrote:
> > This link doesn't work for me, but I think you're referring to the
> > discussion about your "RAM_backed_buffers" comment from March 23rd.
>
> (Oops, it's a non-public message. But yes, you guessed it right ;-))
>
> > Anyway the test I did goes like this: enable memcg and gpu cgoups
> > tracking and run a process that allocates 100MiB of dmabufs. Observe
> > memcg and gpu accounting values before and after the allocation.
>
> Thanks for this measurement/dem/demoo.
>
> > Before
> > # cat memory.current gpu.memory.current
> > 14909440
> > system 0
> >
> > <Test program does the allocation of 100MiB of dmabufs>
> >
> > After
> > # cat memory.current gpu.memory.current
> > 48025600
> > system 104857600
> >
> > So the memcg value increases by about 30 MiB while the gpu values
> > increases by 100 MiB.
>
> > This is with kmem enabled, and the /proc/maps
> > file for this process indicates that the majority of that 30 MiB is
> > kernel memory.
>
> > I think this result shows that neither the kernel nor process memory
> > overlap with the gpu cgroup tracking of these allocations.
>
> It depends how the semantics of the 'system' entry is defined, no?
> As I grasped from other thread, the 'total' is going to be removed, so
> 'system' represents exclusively device memory?
>
That's right. The system charges (soon to be renamed "system-heap")
result only from an allocator (in this case the system heap) deciding
to call gpucg_try_charge for the buffer which is entirely device
memory.
>
> > So despite the fact that these buffers are in main memory, they are
> > allocated in a way that does not result in memcg attribution. (It
> > looks to me like __GFP_ACCOUNT is not set for these.)
>
> (I thought you knew what dmabufs your program used :-p)
>
I'm coming up to speed on a lot of new-to-me code here. :)
Just for completeness, these buffers were allocated with
libdmabufheap's AllocSystem.

> So, the goal is to do the tracking and migrations only via the gpu cg
> layer, regardless how memcg charges it (or not).
>
> (I have no opinion on that, I'm just summing it so that we're on the
> same page.)
>
Yes, this reflects my intention and current state of the code in this serie=
s.

> Michal

Thanks,
T.J.
