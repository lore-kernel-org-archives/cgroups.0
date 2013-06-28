From: Mike Galbraith <bitbucket-BGeptl67XyCzQB+pC5nmwQ@public.gmane.org>
Subject: Re: cgroup: status-quo and userland efforts
Date: Fri, 28 Jun 2013 06:49:10 +0200
Message-ID: <1372394950.5989.128.camel@marge.simpson.net>
References: <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
	 <20130422214159.GG12543@htj.dyndns.org>
	 <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
	 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
	 <20130625000118.GT1918@mtj.dyndns.org>
	 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
	 <20130626212047.GB4536@htj.dyndns.org>
	 <1372311907.5871.78.camel@marge.simpson.net>
	 <20130627180143.GD5599@mtj.dyndns.org>
	 <1372391198.5989.110.camel@marge.simpson.net>
	 <20130628040930.GC2500@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130628040930.GC2500-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bsingharora <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dhaval.giani" <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, jpoimboe <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lpoetter <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, workman-devel <workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, 2013-06-27 at 21:09 -0700, Tejun Heo wrote:

> No, it's completely messed up.  We're now starting to see users trying
> to embed low level cgroup details into their binaries and cgroup is
> exposing sysctl-level konbs which are directly tied to internal
> implementation of core subsystems.  cgroup successfully bypassed the
> usual kernel API policing with the help of hierarchical filesystem
> interface which allows delegation on the surface.  We completely
> fucked up.  This is a full scale disaster unrolling.

I always thought that was a very cool feature, mkdir+echo, poof done.
Now maybe that interface is suboptimal for serious usage, but it makes
the things usable via dirt simple scripts, very flexible, nice.

But whatever, not my call, you know your business better than I.  If
mandatory agent happens, fine, but imho that will be sad day.

-Mike
