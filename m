From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/6] cgroup: gpu: Add a cgroup controller for allocator
 attribution of GPU memory
Date: Wed, 4 May 2022 10:19:20 -0700
Message-ID: <CABdmKX2DJy0i3XAP7xTduZ8KFVKtgto24w714YJNUb_=pfYiKw@mail.gmail.com>
References: <20220502231944.3891435-1-tjmercier@google.com>
 <20220502231944.3891435-3-tjmercier@google.com> <20220504122558.GB24172@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=53tRH3Jax00x2MRGmAnmpVFoogtTBVaQBwRaJB/MSqI=;
        b=ZpE/QIW7kna1o4IhzQQmp2637K1w9UcjrBWQkFmB3KeaXGJhRew5Qrrm4nVBxQuM5K
         WxvhUYOlh8rWIuTX2aM0865lrsFa3LgNJmonYVw5QJ5TWtJ8GDZTmeKTt6ABumWC0QC1
         ab5RGTAVBbqKEoK4b/TnHXAunRyIDb4UtS/WiYRpJvoKPoGFBe/xxsjE1LJ0+w1IU9lY
         PawaTzdNF1YTKYIh5MvHjBCSHId3sE7LkENrHud89JTEUmJh7bVKtkqT2eRSPldXBLZc
         Hy/1AeX5w6TUxiRTh+7aDA0ELWkG6xjnd2RXfENi04bsD7m5bd6YKUkx+vX1cIkHwdrw
         TrCA==
In-Reply-To: <20220504122558.GB24172-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, John Stultz <jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Carlos Llamas <cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kalesh Singh <kaleshsingh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, Shuah Khan <skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 4, 2022 at 5:26 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote:
>
> Hello.
>
> On Mon, May 02, 2022 at 11:19:36PM +0000, "T.J. Mercier" <tjmercier@googl=
e.com> wrote:
> > This patch adds APIs to:
> > -allow a device to register for memory accounting using the GPU cgroup
> > controller.
> > -charge and uncharge allocated memory to a cgroup.
>
> Is this API for separately built consumers?
> The respective functions should be exported (EXPORT_SYMBOL_GPL) if I
> haven't missed anything.
>
As the only users are dmabuf heaps and dmabuf, and those cannot be
built as modules I did not export the symbols here. However these
definitely would need to be exported to support use by modules, and I
have had to do that in one of my device test trees for this change.
Should I export these now for this series?

> > +#ifdef CONFIG_CGROUP_GPU
> > + /* The GPU cgroup controller data structure */
> > +struct gpucg {
> > +     struct cgroup_subsys_state css;
> > +
> > +     /* list of all resource pools that belong to this cgroup */
> > +     struct list_head rpools;
> > +};
> > +
> > +/* A named entity representing bucket of tracked memory. */
> > +struct gpucg_bucket {
> > +     /* list of various resource pools in various cgroups that the buc=
ket is part of */
> > +     struct list_head rpools;
> > +
> > +     /* list of all buckets registered for GPU cgroup accounting */
> > +     struct list_head bucket_node;
> > +
> > +     /* string to be used as identifier for accounting and limit setti=
ng */
> > +     const char *name;
> > +};
>
> Do these struct have to be defined "publicly"?
> I.e. the driver code could just work with gpucg and gpucg_bucket
> pointers.
>
> > +int gpucg_register_bucket(struct gpucg_bucket *bucket, const char *nam=
e)
>
> ...and the registration function would return a pointer to newly
> (internally) allocated gpucg_bucket.
>
No, except maybe the gpucg_bucket name which I can add an accessor
function for. Won't this mean depending on LTO for potential inlining
of the functions currently implemented in the header? I'm happy to
make this change, but I wonder why some parts of the kernel take this
approach and others do not.

> Regards,
> Michal
