From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [OFFLIST] status of devcg
Date: Thu, 11 Jul 2013 14:12:06 -0500
Message-ID: <20130711191206.GA2149@ac100>
References: <20130710184655.GB16979@mtj.dyndns.org>
 <20130710195001.GW14011@redhat.com>
 <20130711093405.GC2377@redhat.com>
 <20130711155106.GB9229@mtj.dyndns.org>
 <20130711160532.GA14909@ac100>
 <20130711171037.GB10195@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130711171037.GB10195-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> Hello,
> 
> On Thu, Jul 11, 2013 at 11:05:32AM -0500, Serge Hallyn wrote:
> > Is there something in particular you want to accomplish for which the
> > current rules do not suffice?
> 
> Yeah, a cgroup changing its rules affecting the descendants
> irreversibly, which is nasty and makes it tricky to implement
> automation on top or implement proper cgroup migration, so I asked
> Aristeu whether he could implement cleaner behavior for unified
> hierarchy.

Before I respond to that, could you please tell me precisely what
you mean by 'unified hierarchy'?  I thought it just meant all
controllers composed into one mount.  Maybe it means something
else.

-serge
