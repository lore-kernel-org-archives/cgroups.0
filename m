From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH] security: selinux: allow per-file labeling for cgroupfs
Date: Thu, 9 Feb 2017 11:14:05 -0500
Message-ID: <CAHC9VhRFxDuRJHYEuRs7kc4ivgaT=-SxdU-o5Lq7H-O+5JJRxQ@mail.gmail.com>
References: <20170209160242.23405-1-amurdaca@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=BysgPhIxUqc7ufyc6jOocxRxdzV7SMgGsTVPYrzPTuk=;
        b=GE4VV1So9Ta5ozXuL6EHWXP5M0Urn/GOEstkNY2OjCtOWjIyBfTFu1ICcoUhPRReEt
         8gc4CR1rvwZ0iPWixjLFH65KDn9OvYVz1k9DIfS2sf20A1mOmIutzK+/j0Yvjnm7EB15
         WQrqC8ykwje+LgGY3Zwo84kJyI8KrIL34jlzoWgTgGkFzjsF0nJksSHwXlZLPEF2N/ym
         fs11Odh8CBFGUIHtVyDy8Lya27r8+N0A5IvENYGseevLVhB2zTdZgLkpjkamYnyoWIHP
         xCj4NlmKHHzvlOm8F+pbt8iGQuejdBIVw/0j3udODgJIoGixr3XKOVn3d3eYXrdw2a8G
         vm2g==
In-Reply-To: <20170209160242.23405-1-amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Thu, Feb 9, 2017 at 11:02 AM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> From: Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> This patch allows genfscon per-file labeling for cgroupfs. For instance,
> this allows to label the "release_agent" file within each
> cgroup mount and limit writes to it.
>
> Signed-off-by: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  security/selinux/hooks.c | 2 ++
>  1 file changed, 2 insertions(+)

This was already merged ... ?

* https://marc.info/?l=selinux&m=148652458620202&w=2

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 9a8f12f..5a3138e 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -808,6 +808,8 @@ static int selinux_set_mnt_opts(struct super_block *sb,
>
>         if (!strcmp(sb->s_type->name, "debugfs") ||
>             !strcmp(sb->s_type->name, "sysfs") ||
> +           !strcmp(sb->s_type->name, "cgroup") ||
> +           !strcmp(sb->s_type->name, "cgroup2") ||
>             !strcmp(sb->s_type->name, "pstore"))
>                 sbsec->flags |= SE_SBGENFS;
>
> --
> 2.9.3

-- 
paul moore
www.paul-moore.com
