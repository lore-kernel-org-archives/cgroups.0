From: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] oom_kill: add option to disable dump_stack()
Date: Mon, 26 Oct 2015 13:40:49 -0400
Message-ID: <20151026174048.GP15046@redhat.com>
References: <1445634150-27992-1-git-send-email-arozansk@redhat.com>
 <20151026172012.GC9779@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151026172012.GC9779-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Michal,
On Mon, Oct 26, 2015 at 06:20:12PM +0100, Michal Hocko wrote:
> I can see why you want to reduce the amount of information, I guess you
> have tried to reduce the loglevel but this hasn't helped because
> dump_stack uses default log level which is too low to be usable, right?
> Or are there any other reasons?

One would be that the stack trace isn't very useful for users IMHO.

> I am not sure sysctl is a good way to tell this particular restriction
> on the output. What if somebody else doesn't want to see the list of
> eligible tasks? Should we add another knob?
>
> Would it make more sense to distinguish different parts of the OOM
> report by loglevel properly?
> pr_err - killed task report
> pr_warning - oom invocation + memory info
> pr_notice - task list
> pr_info - stack trace

That'd work, yes, but I'd think the stack trace would be pr_debug. At a
point that you suspect the OOM killer isn't doing the right thing picking
up tasks and you need more information.

-- 
Aristeu
