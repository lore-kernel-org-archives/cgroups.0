From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v3 7/8] binder: use __kernel_pid_t and __kernel_uid_t for userspace
Date: Mon, 14 Mar 2022 16:45:28 -0700
Message-ID: <CABdmKX1G0Rwmz7=BP1ER+TmtrnkGiE0nROsPTHKxnj=6bHhY3Q@mail.gmail.com>
References: <20220309165222.2843651-1-tjmercier@google.com>
 <20220309165222.2843651-8-tjmercier@google.com> <CAHRSSEy5_h9LJB4q5_OJA7fSq=ROo68UaK+hdPz-Vj-wac1Qhg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mMcKlcLkl25csYGtmWB99GmowZ54MQeoPUbWxxcyFU0=;
        b=bp+YoIVGfFN/43D3vqHErY1NhIRJApUAhtw6o/hQeIyaDBqIfE66EIhFuNlzouKqsM
         ICMTNUqtiRAq88ITvYxr1uiF5OmdPGah32szvxsrVE8+TbWCoOGxOG6L25aPWaho7kdy
         3FU/jNh6QDkaRKObZiMMOkBlD8Aqv99swKSc8YZ9bFy6T0F/mbML6sVVYqbR6qCMVE6H
         bYhE/ZUbxEYhn6H6a+/VharXFDIBFPo45r3fdwvvEZ51SgbTUi25vilSjvica56rkM6I
         xTjLcOE3UXJzEYpLAj8t0ISFMLBTpHiYS87O0Yj4+2ZJb/rKhYVFzvJMGee+en585/rw
         GBaA==
In-Reply-To: <CAHRSSEy5_h9LJB4q5_OJA7fSq=ROo68UaK+hdPz-Vj-wac1Qhg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laur

On Thu, Mar 10, 2022 at 11:33 AM Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Mar 9, 2022 at 8:52 AM T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > The kernel interface should use types that the kernel defines instead o=
f
> > pid_t and uid_t, whose definiton is owned by libc. This fixes the heade=
r
> > so that it can be included without first including sys/types.h.
> >
> > Signed-off-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  include/uapi/linux/android/binder.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/android/binder.h b/include/uapi/linux/a=
ndroid/binder.h
> > index 169fd5069a1a..aa28454dbca3 100644
> > --- a/include/uapi/linux/android/binder.h
> > +++ b/include/uapi/linux/android/binder.h
> > @@ -289,8 +289,8 @@ struct binder_transaction_data {
> >
> >         /* General information about the transaction. */
> >         __u32           flags;
> > -       pid_t           sender_pid;
> > -       uid_t           sender_euid;
> > +       __kernel_pid_t  sender_pid;
> > +       __kernel_uid_t  sender_euid;
>
> Are we guaranteed that this does not affect the UAPI at all? Userspace
> code using this definition will have to run with kernels using the old
> definition and visa-versa.

A standards compliant userspace should be expecting a signed integer
type here. So the only way I can think userspace would be affected is
if:
1) pid_t is a long AND
2) sizeof(long) > sizeof(int) AND
3) Consumers of the pid_t definition actually attempt to mutate the
result to make use of extra bits in the variable (which are not there)

This seems extremely unlikely. For instance just on the topic of the
first item, all of the C library implementations with pid_t
definitions linked here use an int, except for Bionic which typdefs
pid_t to __kernel_pid_t and Sortix which uses long.
https://wiki.osdev.org/C_Library

However I would argue this is already broken and should count as a bug
fix since I can't do this:

$ cat binder_include.c ; gcc binder_include.c
#include <linux/android/binder.h>
int main() {}
In file included from binder_include.c:1:
/usr/include/linux/android/binder.h:291:9: error: unknown type name =E2=80=
=98pid_t=E2=80=99
  291 |         pid_t           sender_pid;
      |         ^~~~~
/usr/include/linux/android/binder.h:292:9: error: unknown type name =E2=80=
=98uid_t=E2=80=99
  292 |         uid_t           sender_euid;
      |         ^~~~~

This is also the only occurrence of pid_t in all of
include/uapi/linux. All 40+ other uses are __kernel_pid_t, and I don't
see why the binder header should be different.


>
> >         binder_size_t   data_size;      /* number of bytes of data */
> >         binder_size_t   offsets_size;   /* number of bytes of offsets *=
/
> >
> > --
> > 2.35.1.616.g0bdcbb4464-goog
> >
