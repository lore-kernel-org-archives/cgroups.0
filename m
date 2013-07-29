From: Holger Brunck <holger.brunck-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Subject: Re: cgroups and SCHED_IDLE
Date: Mon, 29 Jul 2013 17:54:03 +0200
Message-ID: <51F6901B.4070308@keymile.com>
References: <51CC7392.8080701@keymile.com> <51D139B4.8070407@keymile.com> <20130723155634.GD18458@mtj.dyndns.org> <51F65F3D.1080503@keymile.com> <20130729140723.GB22156@laptop.programming.kicks-ass.net> <51F686E7.6020200@keymile.com> <20130729152529.GD22156@laptop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130729152529.GD22156-RM5+C6weyIYnLiPH7yDmwOa11wxjtiyuLtmvbW2Dspo@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Germs, Frits (extern)" <Frits.Germs-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 07/29/2013 05:25 PM, Peter Zijlstra wrote:
> On Mon, Jul 29, 2013 at 05:14:47PM +0200, Holger Brunck wrote:
>> no, unfortunately I got the same results as before.
> 
> OK, so I'm a little confused; this works on SMP but not on UP? There's

yes this is what I see in my setup.

> lots of mention of various platforms, but since I simply don't know any
> of them its not clear if they're UP or not.
> 

as I said I have two different boards with different UPs:

arch    cpu         32/64 bit   kernel
ARM     kirkwood    32          3.10  (but 3.0 shows same problems)
powerpc MPC8247     32          3.10  (but 3.0 shows same problems)

both shows this strange behaviour.

and I have a SMP host PC (Intel(R) Core(TM)2 Quad CPU) running a 3.4 kernel
where I am unable to reproduce the problem even if I start the kernel with
maxcpus=0.

Maybe I could tomorrow have a look on another board of us which is a ppc
Quadcore. I guess this could help to increase the confusion? ;-)

Regards
Holger


