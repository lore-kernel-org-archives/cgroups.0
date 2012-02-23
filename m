From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Date: Thu, 23 Feb 2012 16:22:26 +0800
Message-ID: <4F45F742.1060605@cn.fujitsu.com>
References: <20120221211938.GE12236@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120221211938.GE12236-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> The following is a "best practices" document on using cgroups.
> 
>   http://www.freedesktop.org/wiki/Software/systemd/PaxControlGroups
> 
> To me, it seems to demonstrate the rather ugly situation that the
> current cgroup is providing.  Everyone should tip-toe around cgroup
> hierarchies and nobody has full knowledge or control over them.
> e.g. base system management (e.g. systemd) can't use freezer or task
> counter as someone else might want to use it for different hierarchy
> layout.
> 

This issue still exists if we allow a single hierarchy only, right?
Different cgroup users/applications have to struggle not to step
on each other's toe.
