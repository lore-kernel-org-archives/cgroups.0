From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] clone3: fix cgroup argument sanity check
Date: Wed, 15 Apr 2020 14:38:15 +0200
Message-ID: <20200415123815.qrc7m2ddboh645uo@wittgenstein>
References: <20200412202533.GA29554@asgard.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200412202533.GA29554-ZbobWygYI+YXGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>

On Sun, Apr 12, 2020 at 10:25:33PM +0200, Eugene Syromiatnikov wrote:
> Checking that cgroup field value of struct clone_args is less than 0
> is useless, as it is defined as unsigned 64-bit integer.  Moreover,
> it doesn't catch the situations where its higher bits are lost during
> the assignment to the cgroup field of the cgroup field of the internal
> struct kernel_clone_args (where it is declared as signed 32-bit
> integer), so it is still possible to pass garbage there.  A check
> against INT_MAX solves both these issues.
> 
> Fixes: ef2c41cf38a7559b ("clone3: allow spawning processes into cgroups")
> Signed-off-by: Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Applied, thanks!
Christian
