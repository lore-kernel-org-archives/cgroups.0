From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: fix unchecked cgroup parent usage
Date: Wed, 31 Oct 2012 16:35:01 -0700
Message-ID: <20121031163501.79a0950e.akpm@linux-foundation.org>
References: <20121031160430.GD14789@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121031160430.GD14789-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 31 Oct 2012 12:04:30 -0400
Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> In 4cef7299b4786879a3e113e84084a72b24590c5b the cgroup parent usage is
> unchecked. root will not have a parent and trying to use
> device.{allow,deny} will cause problems.

From my reading of the code "problems" means "kernel null pointer
dereference".

> For some reason my stressing
> scripts didn't test the root directory so I didn't catch it on my
> regular tests.
> 
> --- github.orig/security/device_cgroup.c	2012-10-26 17:18:01.739366780 -0400
> +++ github/security/device_cgroup.c	2012-10-29 10:03:33.221918003 -0400
> @@ -352,6 +352,8 @@
>   */
>  static inline int may_allow_all(struct dev_cgroup *parent)

offtopic: this function could quite neatly have a bool return type.

>  {
> +	if (!parent)
> +		return 1;

hm.  Does it need a comment explaining what and why?  I guess not...  just.

>  	return parent->behavior == DEVCG_DEFAULT_ALLOW;
>  }
