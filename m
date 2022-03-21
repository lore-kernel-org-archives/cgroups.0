From: "T.J. Mercier" <tjmercier@google.com>
Subject: Re: [RFC v3 5/8] dmabuf: Add gpu cgroup charge transfer function
Date: Mon, 21 Mar 2022 16:54:26 -0700
Message-ID: <CABdmKX3+mTjxWzgrv44SKWT7mdGnQKMrv6c26d=iWdNPG7f1VQ@mail.gmail.com>
References: <20220309165222.2843651-1-tjmercier@google.com>
 <20220309165222.2843651-6-tjmercier@google.com> <20220321174530.GB9640@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-media-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qiaO27WzdyEkhPCgtVcKJYNpZr9WKp2+zwnsf/1VvSc=;
        b=Ri8yuR7/Vfc3fPL9gQLx7nlC2w5WarFCPritcrnsHpSsxuLwI5G3Voo8JeXcgyszLb
         +2uoYc1aMEeZckMfuvJ2tS1RQ4sV4x2bEw3/t6bZI8mymUrBIyCvE8fdVOZNpVekttmd
         gL3/aF9rUmS8p0UDTQfskhyx+I2egHowIc+sQ/N03tFWDWkkas9yz9J6z6/pRbfJotOJ
         Hya7yMo0Sw59opqFkSYTZhc7F9NiPgJ8uwx1p8C0nJ00wLf8jKvLHqjCFphRAZgfpYi+
         VVSQCs5iHmIrTMa+g/VlfDJHcUV27McnejGmfZoaaKiH2IvdAJP5kg+Lda21FYCK3UME
         MrGg==
In-Reply-To: <20220321174530.GB9640@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, Hridya Valsaraju <hridya@google.com>, Suren Baghdasaryan <surenb@google.com>, Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, Liam Mark <lmark@codeaurora.org>, Laur

On Mon, Mar 21, 2022 at 10:45 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrot=
e:
>
> Hello.
>
> On Wed, Mar 09, 2022 at 04:52:15PM +0000, "T.J. Mercier" <tjmercier@googl=
e.com> wrote:
> > +int dma_buf_charge_transfer(struct dma_buf *dmabuf, struct gpucg *gpuc=
g)
> > +{
> > +#ifdef CONFIG_CGROUP_GPU
> > +     struct gpucg *current_gpucg;
> > +     int ret =3D 0;
> > +
> > +     /*
> > +      * Verify that the cgroup of the process requesting the transfer =
is the
> > +      * same as the one the buffer is currently charged to.
> > +      */
> > +     current_gpucg =3D gpucg_get(current);
> > +     mutex_lock(&dmabuf->lock);
> > +     if (current_gpucg !=3D dmabuf->gpucg) {
> > +             ret =3D -EPERM;
> > +             goto err;
> > +     }
>
> Add a shortcut for gpucg =3D=3D current_gpucg?

Good idea, thank you!

>
> > +
> > +     ret =3D gpucg_try_charge(gpucg, dmabuf->gpucg_dev, dmabuf->size);
> > +     if (ret)
> > +             goto err;
> > +
> > +     dmabuf->gpucg =3D gpucg;
> > +
> > +     /* uncharge the buffer from the cgroup it's currently charged to.=
 */
> > +     gpucg_uncharge(current_gpucg, dmabuf->gpucg_dev, dmabuf->size);
>
> I think gpucg_* API would need to cater for such transfers too since
> possibly transitional breach of a limit during the transfer may
> unnecessarily fail the operation.

Since the charge is duplicated in two cgroups for a short period
before it is uncharged from the source cgroup I guess the situation
you're thinking about is a global (or common ancestor) limit? I can
see how that would be a problem for transfers done this way and an
alternative would be to swap the order of the charge operations: first
uncharge, then try_charge. To be certain the uncharge is reversible if
the try_charge fails, I think I'd need either a mutex used at all
gpucg_*charge call sites or access to the gpucg_mutex, which implies
adding transfer support to gpu.c as part of the gpucg_* API itself and
calling it here. Am I following correctly here?

This series doesn't actually add limit support just accounting, but
I'd like to get it right here.

>
> My 0.02=E2=82=AC,
> Michal

Thanks!
