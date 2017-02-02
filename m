From: Daniel J Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] security: selinux: allow changing labels for cgroupfs
Date: Thu, 2 Feb 2017 11:08:36 -0500
Message-ID: <a1f3b2a4-aded-eda0-2c1a-fa0f3d418187@redhat.com>
References: <20170202152257.30220-1-runcom@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170202152257.30220-1-runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

We need this patch set to tighten security inside of containers to only
allow certain directories in the cgroup file system to be used by the
containers.  In order to make this work, SELinux policy also needs to be
modified.


On 02/02/2017 10:22 AM, Antonio Murdaca wrote:
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
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 3b955c6..2789f0a 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -480,6 +480,8 @@ static int selinux_is_sblabel_mnt(struct super_block *sb)
>  		sbsec->behavior == SECURITY_FS_USE_NATIVE ||
>  		/* Special handling. Genfs but also in-core setxattr handler */
>  		!strcmp(sb->s_type->name, "sysfs") ||
> +		!strcmp(sb->s_type->name, "cgroup") ||
> +		!strcmp(sb->s_type->name, "cgroup2") ||
>  		!strcmp(sb->s_type->name, "pstore") ||
>  		!strcmp(sb->s_type->name, "debugfs") ||
>  		!strcmp(sb->s_type->name, "tracefs") ||
