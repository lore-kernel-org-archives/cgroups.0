From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [BUG] cgroup lockup while upgrading udev on debian
Date: Mon, 22 Jan 2018 17:46:36 +0100
Message-ID: <20180122164636.GA24468@kroah.com>
References: <20180121213108.4218693b@gandalf.local.home>
 <20180122163051.GE1096857@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180122163051.GE1096857-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jan 22, 2018 at 08:30:51AM -0800, Tejun Heo wrote:
> Hello, Steven.
> 
> On Sun, Jan 21, 2018 at 09:31:08PM -0500, Steven Rostedt wrote:
> > While upgrading my system, it locked up while upgrading udev. It locked
> > up on vanilla v4.14.12, and it also locked up on debian's 4.14 kernel
> > as well. When I booted debian's 4.9 kernel, it upgraded fine.
> > 
> > Note, this is my main server and not a development box. It is not
> > something I'm going to run bisects or other tests on. I don't even have
> > it logging to serial console (hence the photo). It's serials are hooked
> > to my test boxes. That is, it receives logs, it's not set up to send
> > them.
> > 
> > Attached in the photo of the crash that happened when I did:
> > 
> >  # dpkg --configure udev
> 
> It looks like the same bug which was fixed by 74d0833c659a ("cgroup:
> fix css_task_iter crash on CSS_TASK_ITER_PROC").  The bug got
> introduced durinv v4.14 cycle and triggers when cgroup1 and cgroup2
> are used at the same time, which the recent versions of systemd does
> when in cgroup1 mode.

That fix ended up in 4.14.14, so 4.14.12 is a bit too old Steven :)

greg k-h
