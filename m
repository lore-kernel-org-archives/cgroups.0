From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC 0/4] per-namespace allowed filesystems list
Date: Mon, 23 Jan 2012 11:20:04 -0800
Message-ID: <m18vkyns4b.fsf@fess.ebiederm.org>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327337772-1972-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> (Glauber
	Costa's message of "Mon, 23 Jan 2012 20:56:08 +0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> writes:

> This patch creates a list of allowed filesystems per-namespace.
> The goal is to prevent users inside a container, even root,
> to mount filesystems that are not allowed by the main box admin.
>
> My main two motivators to pursue this are:
>  1) We want to prevent a certain tailored view of some virtual
>     filesystems, for example, by bind-mounting files with userspace
>     generated data into /proc. The ability of mounting /proc inside
>     the container works against this effort, while disallowing it
>     via capabilities would have the effect of disallowing other
>     mounts as well.
>
> 2) Some filesystems are known not to behave well under a container
>    environment. They require changes to work in a safe-way. We can
>    whitelist only the filesystems we want.
>
> This works as a whitelist. Only filesystems in the list are allowed
> to be mounted. Doing a blacklist would create problems when, say,
> a module is loaded. The whitelist is only checked if it is enabled first.
> So any setup that was already working, will keep working. And whoever
> is not interested in limiting filesystem mount, does not need
> to bother about it.

My first impression is that this looks like a hack to avoid finishing
the user namespace.

Eric
