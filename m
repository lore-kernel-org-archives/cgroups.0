From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] percpu counter: cast this_cpu_sub() adjustment
Date: Sun, 27 Oct 2013 09:13:25 -0700
Message-ID: <xr93ob6a1yl6.fsf@gthelen.mtv.corp.google.com>
References: <1382859876-28196-1-git-send-email-gthelen@google.com>
	<1382859876-28196-3-git-send-email-gthelen@google.com>
	<20131027112255.GB14934@mtj.dyndns.org>
	<20131027050429.7fcc2ed5.akpm@linux-foundation.org>
	<20131027130036.GN14934@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        bh=IQqWit9SYH0GrlZ3mwApacbEEFok1ICjCABLhllIZfI=;
        b=pZiDOqqKCPSPL2q5GmlgxxKUwAUnE5OzbNdtnB5Y2xRecxRch9l1qnalsZSoB8HOia
         cfwnf7qDs4oXuDKOAg+OGrFOPPZZj1zU4GUcr/7uRNhTVFyJb9ATIBx46euDO3Kt0mZY
         bpIq0vYifR1WknxaPSFW520gM1+ML5G2izblY1+2mhHa6e2FSmAF45ZS9UvlQ6V/aO3d
         l3ZixqdCcSvOPQmRlNurZ1TDj1KobLZwmp2pbTkol94uUDKLZsYW0fBPu9MMv1Gu5Bpg
         I+S9Pe06Rtvd/HBWfepbEDJOhUHpuz4qq3OOCTN47iXN0U6vS2UvffQcocRtiAyKZuTF
         9F4g==
In-Reply-To: <20131027130036.GN14934-9pTldWuhBndy/B6EtB590w@public.gmane.org> (Tejun Heo's message of
	"Sun, 27 Oct 2013 09:00:36 -0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sun, Oct 27 2013, Tejun Heo wrote:

> On Sun, Oct 27, 2013 at 05:04:29AM -0700, Andrew Morton wrote:
>> On Sun, 27 Oct 2013 07:22:55 -0400 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> 
>> > We probably want to cc stable for this and the next one.  How should
>> > these be routed?  I can take these through percpu tree or mm works
>> > too.  Either way, it'd be best to route them together.
>> 
>> Yes, all three look like -stable material to me.  I'll grab them later
>> in the week if you haven't ;)
>
> Tried to apply to percpu but the third one is a fix for a patch which
> was added to -mm during v3.12-rc1, so these are yours. :)

I don't object to stable for the first two non-memcg patches, but it's
probably unnecessary.  I should have made it more clear, but an audit of
v3.12-rc6 shows that only new memcg code is affected - the new
mem_cgroup_move_account_page_stat() is the only place where an unsigned
adjustment is used.  All other callers (e.g. shrink_dcache_sb) already
use a signed adjustment, so no problems before v3.12.  Though I did not
audit the stable kernel trees, so there could be something hiding in
there.

>> The names of the first two patches distress me.  They rather clearly
>> assert that the code affects percpu_counter.[ch], but that is not the case. 
>> Massaging is needed to fix that up.
>
> Yeah, something like the following would be better
>
>  percpu: add test module for various percpu operations
>  percpu: fix this_cpu_sub() subtrahend casting for unsigneds
>  memcg: use __this_cpu_sub() to dec stats to avoid incorrect subtrahend casting

No objection to renaming.  Let me know if you want these reposed with
updated titles.
