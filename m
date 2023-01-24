From: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/4] security: binder: Add binder object flags to selinux_binder_transfer_file
Date: Mon, 23 Jan 2023 20:47:14 -0800
Message-ID: <CABdmKX0EoAw+TYk29z1dJXtWekfw22KDQAkQPGiDAh8ojeKd1A@mail.gmail.com>
References: <20230123191728.2928839-1-tjmercier@google.com>
 <20230123191728.2928839-5-tjmercier@google.com> <CAHC9VhQtbTWXXy8mNxNDdukaAp6YB4CX5Xa6dvSZ_r4DhM2EXg@mail.gmail.com>
 <CABdmKX0Jc3OTnSMv_GoL0eEo=7W9dP29+r5K=PfF84xAUHviBw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+5+rk6gG92yU871Q18SGdLg7yIfDbgS5v3bi+1rCUbI=;
        b=aWyceTWtE5DTXNyf9TvC5uY4/OZwC8YyWYVPbtQZa82CqvSa6NLYy7WyPJWvo1gHfR
         qbqDg2g0l+Ahec3b15JPqyZBqEWwhusTLppzRnqY5x9zcHeYavXxKgYAg8mIW3k8ULE5
         sKYGam3VNwr5rFIaYa2weHMKPhAlUexGu6I7BsgaF2BY/zDAErUTVigE890Cwy6KLrLc
         9yqPI2WnnMdJHwF42k8jmH74XUPI11iHViGtCj+XOvHYb5av5UEmYLP4v0+hPOymIYpP
         lWNcJpvaBML6U8BIJzbtH/XxL8W2IM9HC5UZ/bhRzYNKonuqg2CbUJvEgWkhW0R7YNE1
         MdFQ==
In-Reply-To: <CABdmKX0Jc3OTnSMv_GoL0eEo=7W9dP29+r5K=PfF84xAUHviBw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Carlos Llamas <cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <stephen.smalley.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, daniel.vetter-/w4YWyX8dFk@public.gmane.org, android-mm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jeffv-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jan 23, 2023 at 2:04 PM T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
>
>
> On Mon, Jan 23, 2023 at 1:36 PM Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
>>
>> On Mon, Jan 23, 2023 at 2:18 PM T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrot=
e:
>> >
>> > Any process can cause a memory charge transfer to occur to any other
>> > process when transmitting a file descriptor through binder. This shoul=
d
>> > only be possible for central allocator processes, so the binder object
>> > flags are added to the security_binder_transfer_file hook so that LSMs
>> > can enforce restrictions on charge transfers.
>> >
>> > Signed-off-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> > ---
>> >  drivers/android/binder.c            |  2 +-
>> >  include/linux/lsm_hook_defs.h       |  2 +-
>> >  include/linux/lsm_hooks.h           |  5 ++++-
>> >  include/linux/security.h            |  6 ++++--
>> >  security/security.c                 |  4 ++--
>> >  security/selinux/hooks.c            | 13 ++++++++++++-
>> >  security/selinux/include/classmap.h |  2 +-
>> >  7 files changed, 25 insertions(+), 9 deletions(-)
>>
>> ...
>>
>> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> > index 3c5be76a9199..d4cfca3c9a3b 100644
>> > --- a/security/selinux/hooks.c
>> > +++ b/security/selinux/hooks.c
>> > @@ -88,6 +88,7 @@
>> >  #include <linux/bpf.h>
>> >  #include <linux/kernfs.h>
>> >  #include <linux/stringhash.h>  /* for hashlen_string() */
>> > +#include <uapi/linux/android/binder.h>
>> >  #include <uapi/linux/mount.h>
>> >  #include <linux/fsnotify.h>
>> >  #include <linux/fanotify.h>
>> > @@ -2029,7 +2030,8 @@ static int selinux_binder_transfer_binder(const =
struct cred *from,
>> >
>> >  static int selinux_binder_transfer_file(const struct cred *from,
>> >                                         const struct cred *to,
>> > -                                       struct file *file)
>> > +                                       struct file *file,
>> > +                                       u32 binder_object_flags)
>> >  {
>> >         u32 sid =3D cred_sid(to);
>> >         struct file_security_struct *fsec =3D selinux_file(file);
>> > @@ -2038,6 +2040,15 @@ static int selinux_binder_transfer_file(const s=
truct cred *from,
>> >         struct common_audit_data ad;
>> >         int rc;
>> >
>> > +       if (binder_object_flags & BINDER_FD_FLAG_XFER_CHARGE) {
>> > +               rc =3D avc_has_perm(&selinux_state,
>> > +                           cred_sid(from), sid,
>> > +                           SECCLASS_BINDER, BINDER__TRANSFER_CHARGE,
>> > +                           NULL);
>> > +               if (rc)
>> > +                       return rc;
>> > +       }
>> > +
>> >         ad.type =3D LSM_AUDIT_DATA_PATH;
>> >         ad.u.path =3D file->f_path;
>> >
>> > diff --git a/security/selinux/include/classmap.h b/security/selinux/in=
clude/classmap.h
>> > index a3c380775d41..2eef180d10d7 100644
>> > --- a/security/selinux/include/classmap.h
>> > +++ b/security/selinux/include/classmap.h
>> > @@ -172,7 +172,7 @@ const struct security_class_mapping secclass_map[]=
 =3D {
>> >         { "tun_socket",
>> >           { COMMON_SOCK_PERMS, "attach_queue", NULL } },
>> >         { "binder", { "impersonate", "call", "set_context_mgr", "trans=
fer",
>> > -                     NULL } },
>> > +                     "transfer_charge", NULL } },
>> >         { "cap_userns",
>> >           { COMMON_CAP_PERMS, NULL } },
>> >         { "cap2_userns",
>>
>> My first take on reading these changes above is that you've completely
>> ignored my previous comments about SELinux access controls around
>> resource management.  You've leveraged the existing LSM/SELinux hook
>> as we discussed previously, that's good, but can you explain what
>> changes you've made to address my concerns about one-off resource
>> management controls?
>>
> It's been a couple of weeks since v1 so I've sent this update out now to =
incorporate all the other feedback so far to make sure it's headed in the r=
ight direction. I've tried opening up a discussion about this rather unique=
 case, but there's been no activity on that yet.
>
Someone pointed out this didn't make it to the lists. Retrying.

>> --
>> paul-moore.com
