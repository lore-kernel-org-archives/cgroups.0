From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [RFC 0/4] per-namespace allowed filesystems list
Date: Mon, 23 Jan 2012 21:12:19 +0000
Message-ID: <20120123211218.GF23916@ZenIV.linux.org.uk>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1327337772-1972-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, Jan 23, 2012 at 08:56:08PM +0400, Glauber Costa wrote:
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

Translation, please.

> 2) Some filesystems are known not to behave well under a container
>    environment. They require changes to work in a safe-way. We can
>    whitelist only the filesystems we want.

So fix them.
 
> This works as a whitelist. Only filesystems in the list are allowed
> to be mounted. Doing a blacklist would create problems when, say,
> a module is loaded. The whitelist is only checked if it is enabled first.
> So any setup that was already working, will keep working. And whoever
> is not interested in limiting filesystem mount, does not need
> to bother about it.
> 
> Please let me know what you guys think about it.

NAKed-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
NAKed-because: too fucking ugly

This is bloody ridiculous; if you want to prevent a luser adming playing with
the set of mounts you've given it, the right way to go is not to mess with the
"which fs types are allowed" but to add a per-namespace "immutable" flag.
And add a new clone(2)/unshare(2) flag, used only along with the CLONE_NEWNS
and setting the "immutable" on the copied namespace.
