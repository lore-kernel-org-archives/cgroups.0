From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH] security: selinux: allow per-file labeling for cgroupfs
Date: Fri, 10 Mar 2017 15:01:04 -0500
Message-ID: <CAHC9VhSL3ZS3R2r39+qzYmvU1=8-jC2nzqkXNQ0Yk3+okKd7jw@mail.gmail.com>
References: <20170209155823.22148-1-runcom@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=eyZlyKXM8q/vNidmqEoJERQg3AQICsMGEyiTa/o0dGA=;
        b=YLYfnO7Fy4VsLwufvPWURi3HehceTplmal/DRj3pBtQcLBNAFvfbBNjd1TIApmA8Eg
         BmyLNgYngf73kAMGyv6RXstUaHH6y15nnq578AQx5IMfCqumE8KFgPs1ek5YLxJDUGe5
         JyFd88q707XIDxP/GDWrheyUmPsP7jK23lVxBYEfvpJetS6mQ47b6BVzJ4JrqSeVKpVE
         /8SXolqrS+epWI3+xIacQI+ktYJfIDDnMLkd6hYJIZmcnB3U9MJ/lIoTu0sls32XF2qG
         aj38SP4mTqOtbOCyZBN+2aqsNpmXk/MF/PehEuM442g6ufSmD8s8vpqQhImtyMrDvdaO
         hNRg==
In-Reply-To: <20170209155823.22148-1-runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Thu, Feb 9, 2017 at 10:58 AM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> This patch allows genfscon per-file labeling for cgroupfs. For instance,
> this allows to label the "release_agent" file within each
> cgroup mount and limit writes to it.
>
> Signed-off-by: Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  security/selinux/hooks.c | 2 ++
>  1 file changed, 2 insertions(+)

Now that the merge window is behind us, let's get this merged, but
could you update it to use the selinux_policycap_cgroupseclabel policy
capability?  See 2651225b5ebcdde ("selinux: wrap cgroup seclabel
support with its own policy capability") for more information.

Also, how goes the testing?

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
>
> _______________________________________________
> Selinux mailing list
> Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
> To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
> To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org

-- 
paul moore
www.paul-moore.com
