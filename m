From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Thu, 31 Oct 2013 14:46:27 -0700 (PDT)
Message-ID: <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de> <5257F7CE.90702@huawei.com> <CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com> <5258E584.70500@huawei.com> <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
 <525CB337.8050105@huawei.com> <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com> <CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com> <5270BFE7.4000602@huawei.com> <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=YN8PAK7QBA0w8C8klE/5VObeyB3YOXh66GVToxEdXIE=;
        b=a1cQ/QszJPvt6iWXpahyVlPu//o2CgEtvxL7XNT8oQJwO2nVZbUQPBDk5NvM45SjyF
         7xIaBSdcLfFO7vPz4iW/GtLlPUPIx1+7P6/YCw/45BT9CdJXmjpe9JsWHVLeKMldABLj
         67wR0DLps1TsPOTANA7Q/GhFpXmasinS0GdFsVkokgo6N0N73zjIejwTK5a2ix4hnPZo
         ZWNrGZqYGaCa4ankF1ad54J8IvPr9ZRjXVmKN45xVuvQOJfZeROO0BXkCKUmtEmaSF7q
         RH8Pzt9Fyj5F+8eE5WIx+gtraO3eExcm5sP2T7CHhhI5ox9tHYmMIw6F5NoxnyzR2IJ4
         LMTA==
In-Reply-To: <20131031130647.0ff6f2c7-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 31 Oct 2013, Steven Rostedt wrote:
> On Wed, 30 Oct 2013 19:09:19 -0700 (PDT)
> Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > This is, at least on the face of it, distinct from the workqueue
> > cgroup hang I was outlining to Tejun and Michal and Steve last week:
> > that also strikes in mem_cgroup_reparent_charges, but in the
> > lru_add_drain_all rather than in mem_cgroup_start_move: the
> > drain of pagevecs on all cpus never completes.
> > 
> 
> Did anyone ever run this code with lockdep enabled? There is lockdep
> annotation in the workqueue that should catch a lot of this.

I believe I tried before, but I've just rechecked to be sure:
lockdep is enabled but silent when we get into that deadlock.

Hugh
