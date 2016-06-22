From: Daniel Bristot de Oliveira <daolivei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: disable irqs while holding css_set_lock
Date: Wed, 22 Jun 2016 17:00:01 -0300
Message-ID: <6c904665-b6ed-5d6a-e486-8c24e47a5695@redhat.com>
References: <1465325475-30593-1-git-send-email-bristot@redhat.com>
 <20160607193008.GA31708@htj.duckdns.org>
 <6f15f27f-3757-5413-4292-1386e95bc278@redhat.com>
 <38469b61-7cc5-5fec-4de3-0e9a616dfe95@redhat.com>
 <20160616220315.GH3262@mtj.duckdns.org>
 <20160616221434.GI3262@mtj.duckdns.org>
 <cf514889-8a4d-1ef4-cf4a-fd1a9b9bcb1d@redhat.com>
 <20160617053625.GL31708@htj.duckdns.org>
 <4353aea6-c1e9-80d2-be44-75340d0aaf01@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4353aea6-c1e9-80d2-be44-75340d0aaf01-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Bristot de Oliveira <daolivei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Luis Claudio R. Goncalves" <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Juri Lelli <juri.lelli-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>


Hi

On 06/17/2016 04:59 PM, Daniel Bristot de Oliveira wrote:
> - using _irq and _irqsave appropriately, and
> - using raw_spin locks functions.

After some patches/tests on -rt, I figured that there is a -rt specific
patch that moves cgroup_free() calls to the non-atomic context (in the
-rt kernel). So we do not need to convert spinlocks to raw_spinlocks.

I am sending the v3 just to use _irq and _irqsave appropriately.

-- Daniel
