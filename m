From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] Rebase device_cgroup v2 patchset
Date: Mon, 22 Oct 2012 16:14:22 -0400
Message-ID: <20121022201422.GA14085@redhat.com>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
 <20121022125838.20cdc240.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121022125838.20cdc240.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andrew,
On Mon, Oct 22, 2012 at 12:58:38PM -0700, Andrew Morton wrote:
> On Mon, 22 Oct 2012 09:45:36 -0400
> Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > This patchset rebases the v2 of the patchset since the v1 was pushed into -rc1
> > instead. The last patch, not present on previous patchset, fixes the
> > permission check when allowing everything in a cgroup.
> > 
> 
> I grabbed all four, thanks.  Shall send them on to Linus in a week or
> so, after a bit more review and some linux-next testing.

thanks, much appreciated

> I've been trying to work out why I merged the v1 patchset rather than
> v2 and cannot find that v2 patchset anywhere.  When was it sent out?

It was sent to linux-kernel and cgroups@vger on Sep 04th, here's the
msgid of patch 0 for reference:
<20120904143419.892872876-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org> 

-- 
Aristeu
