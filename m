From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 1/6] gpu: rfc: Proposal for a GPU cgroup controller
Date: Wed, 4 May 2022 10:16:50 -0700
Message-ID: <CABdmKX2nbXLrngK8XRFCBCP=Zz-AMgKviiUdpWvEiYc-jOqang@mail.gmail.com>
References: <20220502231944.3891435-1-tjmercier@google.com>
 <20220502231944.3891435-2-tjmercier@google.com> <20220504121052.GA24172@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FnWaMtJ2reMZ0hSCzzXuNRbvuXwq8gpuYV5+BFONKAE=;
        b=ebMRE72btSfbTu94JZ+XbYWhvE/t1czQ57kEXj7uZgqVNjU0RU05kt542IcNMw286P
         mZ6xpaFHpoeprnPd/kWTrSQM1G1BlgktJBr4xG6RhrWbvNpjLFl0+ecdobJz9KuMfktV
         UlJP10pRifyYNtb3y8yF7fYoE45nmhJGPuHRr8itCnr4dcm9iT/w1jRlWmB9PS7QeasX
         MBbnOipnG539gw+r56zTNE0rnzgfv4xUxVI+yvcMCj1GqXyXDIgz3lhz/guXrQx5FvT8
         2GLVwiFONxmqgCymujrhnutcpLdrZszCr9yLOce9QDwfXfAXYsJDEcTv/UtDWzRMX6T4
         WUAQ==
In-Reply-To: <20220504121052.GA24172-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, John Stultz <jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Carlos Llamas <cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Shuah Khan <skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 4, 2022 at 5:10 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote:
>
> Hello.
>
> On Mon, May 02, 2022 at 11:19:35PM +0000, "T.J. Mercier" <tjmercier@googl=
e.com> wrote:
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > [...]
> > +     The device name string is set by a device driver when it register=
s with the
> > +     GPU cgroup controller to participate in resource accounting.
>
> Are these names available anywhere else for the user? (I.e. would
> drivers add respective sysfs attributes or similar?)
>
Hi, this sounds like it could be a good idea but it'd probably be best
to do this inside gpucg_register_bucket instead of requiring drivers
to perform this externally, possibly in a non-uniform way. Maybe a
sysfs file that prints each name of the gpucg_buckets elements?
However the only names that would result from this series are the
names of the dma-buf heaps, with "-heap" appended. So they are
predictable from the /dev/dma_heap/* names, and only the system and
cma heaps currently exist upstream.

For other future uses of this controller I thought we were headed in
the direction of "standardized" names which would be
predefined/hardcoded and documented, so these names wouldn't really
need to be made available to a user at runtime.
https://lore.kernel.org/lkml/CABdmKX3gTAohaOwkNccGrQyXN9tzT-oEVibO5ZPF+eP+V=
q=3DAOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
>
> > +     Non-unique names will be rejected at the point of registration.
>
> This doesn't seem relevant to the cgroupfs user, does it?
> I think it should be mentioned at the respective API.
>
Yeah you're right. Thank you.

> HTH,
> Michal
>
