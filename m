From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] oom_kill: add option to disable dump_stack()
Date: Tue, 27 Oct 2015 09:09:21 +0100
Message-ID: <20151027080920.GA9891@dhcp22.suse.cz>
References: <1445634150-27992-1-git-send-email-arozansk@redhat.com>
 <20151026172012.GC9779@dhcp22.suse.cz>
 <20151026174048.GP15046@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151026174048.GP15046-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 26-10-15 13:40:49, Aristeu Rozanski wrote:
> Hi Michal,
> On Mon, Oct 26, 2015 at 06:20:12PM +0100, Michal Hocko wrote:
[...]
> > Would it make more sense to distinguish different parts of the OOM
> > report by loglevel properly?
> > pr_err - killed task report
> > pr_warning - oom invocation + memory info
> > pr_notice - task list
> > pr_info - stack trace
> 
> That'd work, yes, but I'd think the stack trace would be pr_debug. At a
> point that you suspect the OOM killer isn't doing the right thing picking
> up tasks and you need more information.

Stack trace should be independent on the oom victim selection because
the selection should be as much deterministic as possible - so it should
only depend on the memory consumption. I do agree that the exact trace
is not very useful for the (maybe) majority of OOM reports. I am trying
to remember when it was really useful the last time and have trouble to
find an example. So I would tend to agree that pr_debug would me more
suitable.
-- 
Michal Hocko
SUSE Labs
