From: Max Kellermann <mk-xMchvyqCc6DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup_pids: add fork limit
Date: Tue, 10 Nov 2015 18:06:12 +0100
Message-ID: <20151110170612.GA21582@rabbit.intern.cm-ag>
References: <144716440621.20175.1000688899886388119.stgit@rabbit.intern.cm-ag>
 <20151110151223.GA17938@mtj.duckdns.org>
 <20151110153746.GA20758@rabbit.intern.cm-ag>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110153746.GA20758-Rjmu19FXx3rR8JxBgnUBv+rzNCUFrscg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015/11/10 16:44, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Nov 10, 2015 at 04:37:46PM +0100, Max Kellermann wrote:
> > There's "cpu" which changes priority
> 
> The cpu controller can limit both in terms of relative weight and
> absolute CPU cycle bandwidth.

No, Tejun, the "cpu" controller does not do what my feature does: like
I said, it only changes the priority, or let's rephrase (to account
for the "absolute CPU cycle bandwith" thing): it changes the amount of
CPU cycles a process gets every period.

But it does NOT put an upper limit on total consumed CPU cycles!  It
will only slow down a frantic process, but it will not stop it.
Stopping it is what I want.  Once process crosses the limits I
configured, there's no point in keeping it running.

You may disagree that the feature I implemented is useful, and you may
not want it merged, but do not say that I missed a kernel feature,
because that's not true.

The Linux kernel currently does not have a feature that can emulate
the fork limit that I implemented.  Useful or not, it doesn't exist.

Max
