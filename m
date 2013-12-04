From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [lxc-devel] cgroup management daemon
Date: Tue, 3 Dec 2013 20:31:51 -0600
Message-ID: <20131204023151.GA12376@sergelap>
References: <20131125224335.GA15481@mail.hallyn.com>
 <20131203134506.GG8277@htj.dyndns.org>
 <20131204000344.GB24968@sergelap>
 <20131204012416.GY8277@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131204012416.GY8277-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> Hello, Serge.
> 
> On Tue, Dec 03, 2013 at 06:03:44PM -0600, Serge Hallyn wrote:
> > > As I communicated multiple times before, delegating write access to
> > > control knobs to untrusted domain has always been a security risk and
> > > is likely to continue to remain so.  Also, organizationally, a
> > 
> > Then that will need to be address with per-key blacklisting and/or
> > per-value filtering in the manager.
> > 
> > Which is my way of saying:  can we please have a list of the security
> > issues so we can handle them?  :)  (I've asked several times before
> > but haven't seen a list or anyone offering to make one)
> 
> Unfortunately, for now, please consider everything blacklisted.  Yes,
> it is true that some knobs should be mostly safe but given the level
> of changes we're going through and the difficulty of properly auditing
> anything for delegation to untrusted environment, I don't feel
> comfortable at all about delegating through chown.  It is an
> accidental feature which happened just because it uses filesystem as
> its interface and it is no where near the top of the todo list.  It
> has never worked properly and won't in any foreseeable future.
> 
> > > cgroup's control knobs belong to the parent not the cgroup itself.
> > 
> > After thinking awhile I think this makes perfect sense.  I haven't
> > implemented set_value yet, and when I do I think I'll implement this
> > guideline.
> 
> I'm kinda confused here.  You say *everything* is gonna go through the
> manager and then talks about chowning directories.  Don't the two
> conflict?

No.  I expect the user - except in the google case - to either have
access to no cgroupfs mounts, or readonly mounts.

-serge
