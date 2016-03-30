From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] cgroup mount: ignore nsroot=
Date: Wed, 30 Mar 2016 12:09:31 -0600
Message-ID: <20160330180931.GL16629@smitten>
References: <20160321234133.GA22463@mail.hallyn.com>
 <20160329135851.GN8544@smitten>
 <20160329200018.GA21908@mail.hallyn.com>
 <20160330172100.GA11373@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=canonical-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m1vmyL0OD/xE3jWSKRWjoXV5i4GXUrRJ/i/H3KN6HaE=;
        b=qg5H6eS/cKkcXNgJlpdX0hUXa1r1yof83CNj7g66fpOowQ0yYSHSdWfUD3B3Hah349
         rsuHay2s2j6TLD/dic0Kapv3L8/PJtRhtwtoVCuovW59HxFLSvmhlhgED+I7chyM7PZ+
         hMI6spap6ZObCanoN6xz6wbEUqNYcHXezR+Xk0d+/jIZmllxiIu+dUZDjkNceyy5/XAi
         l0dznQC3kriZe0UOP3c+oVT4txOx7FXUErjRecruWrBn/NA8Qy2ojGdCz/EVawTAFDmM
         gNq9VLqRlyTejYLY/IgUBLkdxXmzdZA4tAKIbQ4xCUVoZoVerdsa9uzKCVkxO1a8Dydy
         dsgw==
Content-Disposition: inline
In-Reply-To: <20160330172100.GA11373-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Mar 30, 2016 at 12:21:00PM -0500, Serge E. Hallyn wrote:
> As of the patch "cgroup namespaces: add a 'nsroot=' mountinfo field", 
> cgroupfs mountinfo output shows 'nsroot='.  If userspace like criu
> copy/pastes mount options from there into a new mount command, we should
> ignore it.
> 
> Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Tested-by: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Thanks, Serge.

> ---
>  kernel/cgroup.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index ef0c25d..69fb112 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1680,6 +1680,10 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>  			opts->none = true;
>  			continue;
>  		}
> +		if (!strncmp(token, "nsroot=", 7)) {
> +			/* ignore nsroot= copied from mountinfo */
> +			continue;
> +		}
>  		if (!strcmp(token, "all")) {
>  			/* Mutually exclusive option 'all' + subsystem name */
>  			if (one_ss)
> -- 
> 2.7.0
> 
