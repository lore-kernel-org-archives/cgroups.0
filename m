From: "T.J. Mercier" <tjmercier@google.com>
Subject: Re: [RFC v3 1/8] gpu: rfc: Proposal for a GPU cgroup controller
Date: Tue, 22 Mar 2022 08:41:55 -0700
Message-ID: <CABdmKX10jqubJr49JENaHpFnqHV88+Fb7iNZNH4T1Cy7n9y=ag@mail.gmail.com>
References: <20220309165222.2843651-1-tjmercier@google.com>
 <20220309165222.2843651-2-tjmercier@google.com> <20220321173726.GA9640@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nlDmFglz7whj/r0GBRKFJ24ATNTxPzzUgtpMW7485f4=;
        b=CND1Tv8y6h1wN3nXUQIKzu8LJkbk/862t1GsMuYd+VkdxovrTkb3al98dhDbupbe12
         QXuRoX6v14abx56NU7QF+9NGYzOFXPjIFilEb5iGh5vpslTno0fzKgvJfg5koKbmHz5d
         vYj7LoRwC6XkP+3DLboyZVHpk8OUGbhumdqo9fqMS2jco8PbB4d+WrP5GBaK+jgACVjc
         H3mKuCT2WW6HfHHoK5gzbP10+klCOPRsnAr11BVA7ZEnncpigY41CsoHDPS8S3Dlr0Ns
         iZHZ/WcuewTT+kVQ6KA2kKz4zO/JxPoHq3uYjMYs2gCqp960E+gWubc8R1ajqLYXIZYY
         OQZg==
In-Reply-To: <20220321173726.GA9640@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laur

On Mon, Mar 21, 2022 at 10:37 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrot=
e:
>
> Hello.
>
> On Wed, Mar 09, 2022 at 04:52:11PM +0000, "T.J. Mercier" <tjmercier@googl=
e.com> wrote:
> > +The new cgroup controller would:
> > +
> > +* Allow setting per-cgroup limits on the total size of buffers charged=
 to it.
>
> What is the meaning of the total? (I only have very na=C3=AFve
> understanding of the device buffers.)

So "total" is used twice here in two different contexts.
The first one is the global "GPU" cgroup context. As in any buffer
that any exporter claims is a GPU buffer, regardless of where/how it
is allocated. So this refers to the sum of all gpu buffers of any
type/source. An exporter contributes to this total by registering a
corresponding gpucg_device and making charges against that device when
it exports.
The second one is in a per device context. This allows us to make a
distinction between different types of GPU memory based on who
exported the buffer. A single process can make use of several
different types of dma buffers (for example cached and uncached
versions of the same type of memory), and it would be useful to have
different limits for each. These are distinguished by the device name
string chosen when the gpucg_device is first registered.

>
> Is it like a) there's global pool of memory that is partitioned among
> individual devices or b) each device has its own specific type of memory
> and adding across two devices is adding apples and oranges or c) there
> can be various devices both of a) and b) type?

So I guess the most correct answer to this question is c.


>
> (Apologies not replying to previous versions and possibly missing
> anything.)
>
> Thanks,
> Michal
>
