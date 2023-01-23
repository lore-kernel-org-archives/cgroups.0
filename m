From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v2 4/4] security: binder: Add binder object flags to selinux_binder_transfer_file
Date: Mon, 23 Jan 2023 16:36:32 -0500
Message-ID: <CAHC9VhQtbTWXXy8mNxNDdukaAp6YB4CX5Xa6dvSZ_r4DhM2EXg@mail.gmail.com>
References: <20230123191728.2928839-1-tjmercier@google.com> <20230123191728.2928839-5-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yGXvyQjwLmOy53oIzm1ZLaTMK3/o09Vv8V+chgSLdeY=;
        b=CcWptSLeFIccOdIwrrQruiIQVbfQw+qTyjT3yv+7o4oiOdtJnaGwyxjNF8KqV8JCPb
         EtEuwCUakT7bXDWuTHstKBBxFfx/NFD6nI++Zxx33wEt2LsDHWWFbVo+nWs5aJpvgbDt
         bcNjHlr2/smIeZ2DgR6hyv29jjDSqQQI+8Qj+9AAlhetLTyxbKX75Vw/uzLti5pjdjDD
         1gqqU5UtNkfvmUk9ZygMGK8+1jwTN9eFYCq597DzigUSvomN5c9XhKqAjmlcR+BL0bRb
         fkuAUTdTl6ZIMoENwrU3bfv6UbzvTXWAqgAlNJDWfnVuL4Hhf5bRgdVGoARAYxrNCCDe
         ljRQ==
In-Reply-To: <20230123191728.2928839-5-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Carlos Llamas <cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <stephen.smalley.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, daniel.vetter-/w4YWyX8dFk@public.gmane.org, android-mm-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jstultz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jeffv-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jan 23, 2023 at 2:18 PM T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Any process can cause a memory charge transfer to occur to any other
> process when transmitting a file descriptor through binder. This should
> only be possible for central allocator processes, so the binder object
> flags are added to the security_binder_transfer_file hook so that LSMs
> can enforce restrictions on charge transfers.
>
> Signed-off-by: T.J. Mercier <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/android/binder.c            |  2 +-
>  include/linux/lsm_hook_defs.h       |  2 +-
>  include/linux/lsm_hooks.h           |  5 ++++-
>  include/linux/security.h            |  6 ++++--
>  security/security.c                 |  4 ++--
>  security/selinux/hooks.c            | 13 ++++++++++++-
>  security/selinux/include/classmap.h |  2 +-
>  7 files changed, 25 insertions(+), 9 deletions(-)

...

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 3c5be76a9199..d4cfca3c9a3b 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -88,6 +88,7 @@
>  #include <linux/bpf.h>
>  #include <linux/kernfs.h>
>  #include <linux/stringhash.h>  /* for hashlen_string() */
> +#include <uapi/linux/android/binder.h>
>  #include <uapi/linux/mount.h>
>  #include <linux/fsnotify.h>
>  #include <linux/fanotify.h>
> @@ -2029,7 +2030,8 @@ static int selinux_binder_transfer_binder(const struct cred *from,
>
>  static int selinux_binder_transfer_file(const struct cred *from,
>                                         const struct cred *to,
> -                                       struct file *file)
> +                                       struct file *file,
> +                                       u32 binder_object_flags)
>  {
>         u32 sid = cred_sid(to);
>         struct file_security_struct *fsec = selinux_file(file);
> @@ -2038,6 +2040,15 @@ static int selinux_binder_transfer_file(const struct cred *from,
>         struct common_audit_data ad;
>         int rc;
>
> +       if (binder_object_flags & BINDER_FD_FLAG_XFER_CHARGE) {
> +               rc = avc_has_perm(&selinux_state,
> +                           cred_sid(from), sid,
> +                           SECCLASS_BINDER, BINDER__TRANSFER_CHARGE,
> +                           NULL);
> +               if (rc)
> +                       return rc;
> +       }
> +
>         ad.type = LSM_AUDIT_DATA_PATH;
>         ad.u.path = file->f_path;
>
> diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
> index a3c380775d41..2eef180d10d7 100644
> --- a/security/selinux/include/classmap.h
> +++ b/security/selinux/include/classmap.h
> @@ -172,7 +172,7 @@ const struct security_class_mapping secclass_map[] = {
>         { "tun_socket",
>           { COMMON_SOCK_PERMS, "attach_queue", NULL } },
>         { "binder", { "impersonate", "call", "set_context_mgr", "transfer",
> -                     NULL } },
> +                     "transfer_charge", NULL } },
>         { "cap_userns",
>           { COMMON_CAP_PERMS, NULL } },
>         { "cap2_userns",

My first take on reading these changes above is that you've completely
ignored my previous comments about SELinux access controls around
resource management.  You've leveraged the existing LSM/SELinux hook
as we discussed previously, that's good, but can you explain what
changes you've made to address my concerns about one-off resource
management controls?

-- 
paul-moore.com
