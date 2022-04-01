From: "T.J. Mercier" <tjmercier@google.com>
Subject: Re: [RFC v4 5/8] dmabuf: Add gpu cgroup charge transfer function
Date: Fri, 1 Apr 2022 11:41:36 -0700
Message-ID: <CABdmKX2874NdYCBzpKLnqWhZQDkC2wKz4ZL_aFNqrec6iAutpQ@mail.gmail.com>
References: <20220328035951.1817417-1-tjmercier@google.com>
 <20220328035951.1817417-6-tjmercier@google.com> <20220329152142.GA15794@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DLtOWenxXCw5vQfabcGIJp+Je2gVQjc6VzKW0XdhyiQ=;
        b=h+rLLWbMQ/iHnS5/pj19fhLvsaEM9Wtdy1qxj2U1tvLPMxqJCjQosFe2F24w4FuEik
         zSrjnDN8RVUqsGTehE0RLFU9iAnAgsZLy6+HaVFpgiQgyaH0bi2nNoUnW/PN++7erDWp
         RX2laVeByhssITiwvlf5JqxR9o7iIybqO73rq6iDBg0II0FI27oeey/L41eoch8FqdX9
         HSLjysJJ9QsP1Keic9p/q3hcmxjndegS2Td9/sQ/qsgWCFS7CVf9el3ursRzkfzAihRs
         Haf70E3SoFpNKPytMrE2H1AsOY13tYTorkjDKu54Gzzinf56UPzglOwHHVZBMjHJCiR4
         t3yQ==
In-Reply-To: <20220329152142.GA15794@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laura

On Tue, Mar 29, 2022 at 8:21 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote=
:
>
> Hi.
>
> On Mon, Mar 28, 2022 at 03:59:44AM +0000, "T.J. Mercier" <tjmercier@googl=
e.com> wrote:
> > From: Hridya Valsaraju <hridya@google.com>
> >
> > The dma_buf_charge_transfer function provides a way for processes to
>
> (s/dma_bug_charge_transfer/dma_bug_transfer_charge/)
>
Doh! Thanks.

> > transfer charge of a buffer to a different process. This is essential
> > for the cases where a central allocator process does allocations for
> > various subsystems, hands over the fd to the client who requested the
> > memory and drops all references to the allocated memory.
>
> I understood from [1] some buffers are backed by regular RAM. How are
> these charges going to be transferred (if so)?
>
This link doesn't work for me, but I think you're referring to the
discussion about your "RAM_backed_buffers" comment from March 23rd. I
wanted to do a simple test to confirm my own understanding here, but
that got delayed due to some problems on my end. Anyway the test I did
goes like this: enable memcg and gpu cgoups tracking and run a process
that allocates 100MiB of dmabufs. Observe memcg and gpu accounting
values before and after the allocation.

Before
# cat memory.current gpu.memory.current
14909440
system 0

<Test program does the allocation of 100MiB of dmabufs>

After
# cat memory.current gpu.memory.current
48025600
system 104857600

So the memcg value increases by about 30 MiB while the gpu values
increases by 100 MiB. This is with kmem enabled, and the /proc/maps
file for this process indicates that the majority of that 30 MiB is
kernel memory. I think this result shows that neither the kernel nor
process memory overlap with the gpu cgroup tracking of these
allocations. So despite the fact that these buffers are in main
memory, they are allocated in a way that does not result in memcg
attribution. (It looks to me like __GFP_ACCOUNT is not set for these.)

>
> Thanks,
> Michal
>
> [1]
> https://lore.kernel.org/r/CABdmKX2NSAKMC6rReMYfo2SSVNxEXcS466hk3qF6YFt-j-=
+_NQ@mail.gmail.com
