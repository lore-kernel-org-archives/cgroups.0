From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v3 5/8] dmabuf: Add gpu cgroup charge transfer function
Date: Tue, 22 Mar 2022 09:47:59 -0700
Message-ID: <CABdmKX2hZChBO09xfhqB7EbH6RY9JdmDp7zh23DaGuwidn=v4w@mail.gmail.com>
References: <20220322095223.GG8477@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AGjZE0nexYYIrgZGc1/sQ9ebvM2IDXrU/8dxpFIfC6Q=;
        b=no3QyBMN97jJJhzD7cqUG00A6e2MB7KJHQvzy4ZBrorfKhZnY4KLpmH2ijl3hqJAEq
         w38SA1GGvBFZG7tP/8djpuj0BUbYdHZD9uy+WcRz+GY1qJugW+aRKiIkcr9+/i+/yCpl
         oDvJjvDBQlBi/23CI8I3sggW1bURzFDHhLeDItamtogT9SNEeMCBJHoKiJqhx70tbNX1
         Ju5tti5nJ1ezrJNTsClfOUV4Il9mdQ1cxiJnaMVkNSqyhptqkuN9M3Rj6KebwW+655E+
         EwOjKo25LrOTYBbCto5RaMfNuEZ99/RUyctw5hM2x3wHWiu5Zwfr1NE2y290i/E2Ow60
         0gfg==
In-Reply-To: <20220322095223.GG8477-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laur

On Tue, Mar 22, 2022 at 2:52 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> On Mon, Mar 21, 2022 at 04:54:26PM -0700, "T.J. Mercier"
> <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > Since the charge is duplicated in two cgroups for a short period
> > before it is uncharged from the source cgroup I guess the situation
> > you're thinking about is a global (or common ancestor) limit?
>
> The common ancestor was on my mind (after the self-shortcut).
>
> > I can see how that would be a problem for transfers done this way and
> > an alternative would be to swap the order of the charge operations:
> > first uncharge, then try_charge. To be certain the uncharge is
> > reversible if the try_charge fails, I think I'd need either a mutex
> > used at all gpucg_*charge call sites or access to the gpucg_mutex,
>
> Yes, that'd provide safe conditions for such operations, although I'm
> not sure these special types of memory can afford global lock on their
> fast paths.

I have a benchmark I think is suitable, so let me try this change to
the transfer implementation and see how it compares.

>
> > which implies adding transfer support to gpu.c as part of the gpucg_*
> > API itself and calling it here. Am I following correctly here?
>
> My idea was to provide a special API (apart from
> gpucp_{try_charge,uncharge}) to facilitate transfers...
>
> > This series doesn't actually add limit support just accounting, but
> > I'd like to get it right here.
>
> ...which could be implemented (or changed) depending on how the charging
> is realized internally.
>
>
> Michal
