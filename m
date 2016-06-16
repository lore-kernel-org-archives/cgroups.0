From: Daniel Bristot de Oliveira <daolivei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: disable irqs while holding css_set_lock
Date: Thu, 16 Jun 2016 18:48:56 -0300
Message-ID: <38469b61-7cc5-5fec-4de3-0e9a616dfe95@redhat.com>
References: <1465325475-30593-1-git-send-email-bristot@redhat.com>
 <20160607193008.GA31708@htj.duckdns.org>
 <6f15f27f-3757-5413-4292-1386e95bc278@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6f15f27f-3757-5413-4292-1386e95bc278-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Bristot de Oliveira <daolivei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Luis Claudio R. Goncalves" <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Juri Lelli <juri.lelli-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 06/07/2016 05:05 PM, Daniel Bristot de Oliveira wrote:
> On 06/07/2016 04:30 PM, Tejun Heo wrote:
>> Is this something in mainline?  This forces all task free path to be
>> irq-safe, which *could* be fine but it's weird to make cgroup free
>> path irq-safe for something which isn't in mainline.
> 
> you mean, mainline linux kernel? if so, yes it is. I was running the
> v4.7-rc2 from Linus, as is.... no external patches applied.
> 

is there any other question/objection about this patch?

-- Daniel
