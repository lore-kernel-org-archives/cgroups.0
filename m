From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] oom_kill: add option to disable dump_stack()
Date: Mon, 26 Oct 2015 12:01:11 -0400
Message-ID: <20151026160111.GA2214@cmpxchg.org>
References: <1445634150-27992-1-git-send-email-arozansk@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1445634150-27992-1-git-send-email-arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Oct 23, 2015 at 05:02:30PM -0400, Aristeu Rozanski wrote:
> One of the largest chunks of log messages in a OOM is from dump_stack() and in
> some cases it isn't even necessary to figure out what's going on. In
> systems with multiple tenants/containers with limited resources each
> OOMs can be way more frequent and being able to reduce the amount of log
> output for each situation is useful.
> 
> This patch adds a sysctl to allow disabling dump_stack() during an OOM while
> keeping the default to behave the same way it behaves today.
> 
> Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

I think this makes sense.

The high volume log output is not just annoying, we have also had
reports from people whose machines locked up as they tried to log
hundreds of containers through a low-bandwidth serial console.

Could you include sample output of before and after in the changelog
to provide an immediate comparison on what we are saving?

Should we make the knob specific to the stack dump or should it be
more generic, so that we could potentially save even more output?
