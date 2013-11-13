From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Wed, 13 Nov 2013 12:28:04 +0900
Message-ID: <20131113032804.GB19394@mtj.dyndns.org>
References: <CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com>
 <5258E584.70500@huawei.com>
 <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
 <525CB337.8050105@huawei.com>
 <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com>
 <CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com>
 <5270BFE7.4000602@huawei.com>
 <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7dbERRfHp0HV6uGqxCVAFLbmCwyTLLkS5+flHZYL+/0=;
        b=O5RoXWSeOYEGlGOaZirXNmvT2ZJ1LaPUSuK9ljJSaPP+Ojr82iNwiqMlA7iCTr1Dmh
         F+4MbUPAhfnkF1KPwIDM96UK0y2DULPPRLk9V8tufN6Yi8vYMOzhysXmIHI5wzugbWdn
         PD7k0QNOFPX/nt/PtsHlFpxk6dcBQmwcyqR4QXqpXX7voEKwX4+TsAye2wOck8y6M3QM
         9SnLCl+UO4jDMiMAJ2vXO8Jkp5ygRiAjdIbyXIQYa0Gi0OEZX9pnh0wO6rjC/rhAlrrH
         3AnynARk27IFojdPCcUoi8TOu5E71ZFJC1H8tG9Je3yuOagd8Liz0p9DeTDhqg1zCXp6
         u5gA==
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1310311442030.2633-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Oct 31, 2013 at 02:46:27PM -0700, Hugh Dickins wrote:
> On Thu, 31 Oct 2013, Steven Rostedt wrote:
> > On Wed, 30 Oct 2013 19:09:19 -0700 (PDT)
> > Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> > > This is, at least on the face of it, distinct from the workqueue
> > > cgroup hang I was outlining to Tejun and Michal and Steve last week:
> > > that also strikes in mem_cgroup_reparent_charges, but in the
> > > lru_add_drain_all rather than in mem_cgroup_start_move: the
> > > drain of pagevecs on all cpus never completes.
> > > 
> > 
> > Did anyone ever run this code with lockdep enabled? There is lockdep
> > annotation in the workqueue that should catch a lot of this.
> 
> I believe I tried before, but I've just rechecked to be sure:
> lockdep is enabled but silent when we get into that deadlock.

Ooh... I just realized that work_on_cpu() explicitly opts out of flush
lockdep verification by using __flush_work() to allow work_on_cpu()
callback to use work_on_cpu() recursively.  The commit is c2fda509667b
("workqueue: allow work_on_cpu() to be called recursively").  So, if
we have an actual deadlock scenario involving work_on_cpu(), it may
escape lockdep detection.  I'll see if I can update the lockdep
annotation so that it still allows recursive invocation but doesn't
disable lockdep annotation completely.

Thanks.

-- 
tejun
