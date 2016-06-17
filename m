From: Daniel Bristot de Oliveira <daolivei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: disable irqs while holding css_set_lock
Date: Thu, 16 Jun 2016 21:12:32 -0300
Message-ID: <cf514889-8a4d-1ef4-cf4a-fd1a9b9bcb1d@redhat.com>
References: <1465325475-30593-1-git-send-email-bristot@redhat.com>
 <20160607193008.GA31708@htj.duckdns.org>
 <6f15f27f-3757-5413-4292-1386e95bc278@redhat.com>
 <38469b61-7cc5-5fec-4de3-0e9a616dfe95@redhat.com>
 <20160616220315.GH3262@mtj.duckdns.org>
 <20160616221434.GI3262@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160616221434.GI3262-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Bristot de Oliveira <daolivei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Luis Claudio R. Goncalves" <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Juri Lelli <juri.lelli-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>

On 06/16/2016 07:14 PM, Tejun Heo wrote:
> Except that the patch seems to use irqsave/restore instead of plain
> irq ones in places.  Care to update those?

Hi Tejun,

The use of the irq spin_(un)lock_irq() assumes that the code is always
called with IRQs enabled. But that is not always true in this case, as
we call cgroup_free() in the hard IRQ context, and unconditionally
enable IRQ in this context is a problem. So we need to use irqsave/restore.

Discussing with rostedt, we figured that this needs to be IRQ safe
(using irqsave/restore) in the PREEMPT RT too, so I need to code a v3 of
this patch using raw_spin_*() functions to avoid this problem in the -rt
kernel as well.

Do you see any problems on this?

Thanks! -- Daniel
