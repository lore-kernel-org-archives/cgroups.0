From: "T.J. Mercier" <tjmercier@google.com>
Subject: Re: [PATCH v6 1/6] gpu: rfc: Proposal for a GPU cgroup controller
Date: Thu, 5 May 2022 16:56:30 -0700
Message-ID: <CABdmKX26mY3xYL0drv51t5_3tmUTbExZtjN73KU8bpP8ZJ5CgA@mail.gmail.com>
References: <20220502231944.3891435-1-tjmercier@google.com>
 <20220502231944.3891435-2-tjmercier@google.com> <20220504121052.GA24172@blackbody.suse.cz>
 <CABdmKX2nbXLrngK8XRFCBCP=Zz-AMgKviiUdpWvEiYc-jOqang@mail.gmail.com> <20220505112908.GC10890@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uWiEhWmhMDzG0ZpwCc+KvFHmta+dLhGoAJnxSBDiro8=;
        b=CaBQ1UXw8e392aHxUqO7YzvZNbVO299KOlkxDA3WGrY9BWShRdfHWTf0i0Tdsc0Z4x
         Zgp4Gq8IkAZ61hhLujTNwr7ZXt3+q6wrr7TWIsSa3R0i/tELL2+yAzMh5esa0TCqwJjl
         F/5g78AXRbrvZs5gyHBEnx6Uj/Y4QIjKYxUmn38VJVxgSqmyUH1by4gck/j5PJ+AjqT+
         BCOGzPJ0WCkgbOLhtqewqTMnmy5zyvK3ubf+kCmfpaL0Fm6d4f06nN2nMq53FagcwD13
         1/6oImedxy6bVsDtMqoGLQAS79JNnWcFY/mAdKcBZe7DOuOn/8sY8HI2NP6NDwRdgjvN
         Jsrg==
In-Reply-To: <20220505112908.GC10890@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Daniel Vetter <daniel@ffwll.ch>, Hridya Valsaraju <hridya@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, John Stultz <jstultz@google.com>, Todd Kjos <tkjos@android.com>, Carlos Llamas <cmllamas@google.com>, Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, Kenny.Ho@amd.com, Shuah Khan <skhan@linuxfoundation.org>, kernel-team@android.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, May 5, 2022 at 4:29 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> On Wed, May 04, 2022 at 10:16:50AM -0700, "T.J. Mercier" <tjmercier@googl=
e.com> wrote:
> > However the only names that would result from this series are the
> > names of the dma-buf heaps, with "-heap" appended. So they are
> > predictable from the /dev/dma_heap/* names, and only the system and
> > cma heaps currently exist upstream.
>
> It's not so important with the read-only stats currently posted (a
> crafted sysfs file with these names would be an overlikill)...
>
> >
> > For other future uses of this controller I thought we were headed in
> > the direction of "standardized" names which would be
> > predefined/hardcoded and documented, so these names wouldn't really
> > need to be made available to a user at runtime.
> > https://lore.kernel.org/lkml/CABdmKX3gTAohaOwkNccGrQyXN9tzT-oEVibO5ZPF+=
eP+Vq=3DAOg@mail.gmail.com/
>
> (Ah, I see.)
>
> ...but if writers (limits) are envisioned, the keys should represent
> something that the user can derive/construct from available info -- e.g.
> the documentation.
>
> OK, so I understand current form just presents some statistics.
>
Yup, thanks for taking a look.

> Michal
