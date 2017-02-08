From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v2] security: selinux: allow changing labels for cgroupfs
Date: Tue, 7 Feb 2017 22:29:13 -0500
Message-ID: <CAHC9VhR1yu6G4H0UYNY-4UNxs9Byg=2CMckMH+pE_HYiDf-Ugg@mail.gmail.com>
References: <20170202152257.30220-1-runcom@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
 h=mime-version:in-reply-to:references:from:date:message-id:subject:to
 :cc; bh=cGcvLM6E0vcmT8mO+kRxEePb6OQItp/dlwI71x0a2bA=;
 b=DFgvc9jtaVTPiVp7C2dwuxgPyhlsb5kiYQztGLEOboQMK7VzpDG9WZb/ViddpHBC4+
 zYYv/+7V3a+DGculpG/Ap7gyePxG2xXgmLlcnPq83QOnCf/HgxeUTD4+7ngFFNHO5SPn
 iL8dLlf9ePEuzF0+w5g8/wqiGeG1q+9X1CBxKMsMU99ngFwF6bEu4wgxDf0+EElVs+wi
 lO74gJ4Uq7TNfoPpdNgBmoZboMyfaDfXIj6U4aH+xNqrxo+Eg5xQX3kGBQmMW4O2YXOK
 1vC3eMmMrpFjX1XlacfbOkw86/KkSZKG2R/Nl5VFTiIh1Xcm1iBWAvnIVKVv9AlQoSQS
 wzrA==
In-Reply-To: <20170202152257.30220-1-runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Thu, Feb 2, 2017 at 10:22 AM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> This patch allows changing labels for cgroup mounts. Previously, running
> chcon on cgroupfs would throw an "Operation not supported". This patch
> specifically whitelist cgroupfs.
>
> The patch could also allow containers to write only to the systemd cgroup
> for instance, while the other cgroups are kept with cgroup_t label.
>
> Signed-off-by: Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> Changes in v2:
>   - whitelist cgroup2 fs type
>
>  security/selinux/hooks.c | 2 ++
>  1 file changed, 2 insertions(+)

Merged into selinux/next, thanks.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 3b955c6..2789f0a 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -480,6 +480,8 @@ static int selinux_is_sblabel_mnt(struct super_block *sb)
>                 sbsec->behavior == SECURITY_FS_USE_NATIVE ||
>                 /* Special handling. Genfs but also in-core setxattr handler */
>                 !strcmp(sb->s_type->name, "sysfs") ||
> +               !strcmp(sb->s_type->name, "cgroup") ||
> +               !strcmp(sb->s_type->name, "cgroup2") ||
>                 !strcmp(sb->s_type->name, "pstore") ||
>                 !strcmp(sb->s_type->name, "debugfs") ||
>                 !strcmp(sb->s_type->name, "tracefs") ||
> --
> 2.9.3

-- 
paul moore
www.paul-moore.com
_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
