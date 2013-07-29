From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: cgroups and SCHED_IDLE
Date: Mon, 29 Jul 2013 17:25:29 +0200
Message-ID: <20130729152529.GD22156@laptop.programming.kicks-ass.net>
References: <51CC7392.8080701@keymile.com>
 <51D139B4.8070407@keymile.com>
 <20130723155634.GD18458@mtj.dyndns.org>
 <51F65F3D.1080503@keymile.com>
 <20130729140723.GB22156@laptop.programming.kicks-ass.net>
 <51F686E7.6020200@keymile.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51F686E7.6020200-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Holger Brunck <holger.brunck-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Germs, Frits (extern)" <Frits.Germs-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jul 29, 2013 at 05:14:47PM +0200, Holger Brunck wrote:
> no, unfortunately I got the same results as before.

OK, so I'm a little confused; this works on SMP but not on UP? There's
lots of mention of various platforms, but since I simply don't know any
of them its not clear if they're UP or not.

Typically the cgroup nightmare is easier on UP; it would be curious if
that's the 'broken' case now :-)
