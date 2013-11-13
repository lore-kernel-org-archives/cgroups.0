From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Wed, 13 Nov 2013 16:38:06 +0900
Message-ID: <20131113073806.GA23244@mtj.dyndns.org>
References: <5258E584.70500@huawei.com>
 <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
 <525CB337.8050105@huawei.com>
 <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com>
 <CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com>
 <5270BFE7.4000602@huawei.com>
 <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home>
 <alpine.LNX.2.00.1310311442030.2633@eggly.anvils>
 <20131113032804.GB19394@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=CNo0spsIWmz5Y0CG90OPH+ASFfAaQlEhEL+AOVbRXs4=;
        b=E8Cyb/OceZwG3J3MTo4rOtpjV2tSyEpusIq8rVWLM+/yk5BydLQbrBCxBACADmDlaS
         IKQPiOT69CuM7PAR+vAdAW0CBf7OTmw7LQUcQOo0rr0LQgzcOGtIqR5Dihk1haKe9ngf
         aB4aaDwlB051sQLlRZl9rxuiAsneUg7Ep+0qj9nOA4ifMeSYDvnH7Nob5cqiAkfR8CIy
         70cTcMCNmyrULsQ5gUn4Y43sdhF4pR2fOuH2EjS1BXFXCEacOWVTIOwlNy/pm48vDETp
         CAVXmMdfQ9BwVsVJI499x/uAmioEgxFrls6IT6DjlqQGRiYCYgnUwIKskWL4FYfqBVog
         8jZQ==
Content-Disposition: inline
In-Reply-To: <20131113032804.GB19394-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Alexander Duyck <alexander.h.duyck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hey, guys.

cc'ing people from "workqueue, pci: INFO: possible recursive locking
detected" thread.

  http://thread.gmane.org/gmane.linux.kernel/1525779

So, to resolve that issue, we ripped out lockdep annotation from
work_on_cpu() and cgroup is now experiencing deadlock involving
work_on_cpu().  It *could* be that workqueue is actually broken or
memcg is looping but it doesn't seem like a very good idea to not have
lockdep annotation around work_on_cpu().

IIRC, there was one pci code path which called work_on_cpu()
recursively.  Would it be possible for that path to use something like
work_on_cpu_nested(XXX, depth) so that we can retain lockdep
annotation on work_on_cpu()?

Thanks.

-- 
tejun
