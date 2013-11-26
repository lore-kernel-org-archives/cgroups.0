From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Tue, 26 Nov 2013 16:41:25 +0000
Message-ID: <20131126164125.GC23834@mail.hallyn.com>
References: <20131125224335.GA15481@mail.hallyn.com>
 <CAO_RewZGWARUafKzDc_t3G5OedGtEPTZgB2VYeHHiKSSrja8fA@mail.gmail.com>
 <20131126161246.GA23834@mail.hallyn.com>
 <CAD=mX8tCOEO4wP-XGs9YdRufTAay6zPaOxo_wZF=-KoqepH0wg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAD=mX8tCOEO4wP-XGs9YdRufTAay6zPaOxo_wZF=-KoqepH0wg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>

Quoting Victor Marmol (vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> On Tue, Nov 26, 2013 at 8:12 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> > > What are the requirements/goals around performance and concurrency?
> > > Do you expect this to be a single-threaded thing, or can we handle
> > > some number of concurrent operations?  Do you expect to use threads of
> > > processes?
> >
> > The cgmanager should be pretty dumb, so I would expect it to be
> > quite fast.  I don't have any specific perf goals though.  If you
> > have requirements I'm very interested to hear them.  I should be
> > able to tell pretty soon how far short I fall.
> >
> > By default I'd expect to run with a single thread, but I don't
> > imagine one thread can serve a busy 1024-cpu system very well.
> > Unless you have guidance right now, I think I'd like to get
> > started with the basic functionality and see how it measures
> > up to your requirements.  I should add perf counters from the
> > start so we can figure out where bottlenecks (if any) are and
> > how to handle them.
> >
> > Otherwise I could start out with a basic numcpus/10 threadpool
> > and have the main thread do socket i/o and parcel access
> > verification and vfs work out to the threadpool, but I'd rather
> > first know where the problems lie.
> >
> 
> >From Rohit's talk at Linux plumbers:
> 
> http://www.linuxplumbersconf.net/2013/ocw//system/presentations/1239/original/lmctfy%20(1).pdf
> 
> The goal is O(1000) reads and O(100) writes per second.

Cool, thanks.  I can try and get a sense next week of how far off the
mark I am for reads.

> > > Can you talk about logging - what and where?
> >
> > When started under upstart, anything we print out goes to
> > /var/log/upstart/cgmanager.log.  Would be nice to keep it
> > that simple.  We could log requests by r to do something
> > it is not allowed to do, but it seems to me the failed
> > attempts cause no harm, while the potential for overflowing
> > logs can.
> >
> > Did you have anything in mind?  Did you want logging to help
> > detect certain conditions for system optimization, or just
> > for failure notices and security violations?
> >
> > > How will we handle event_fd?  Pass a file-descriptor back to the caller?
> >
> > The only thing currently supporting eventfd is memory threshold,
> > right?  I haven't tested whether this will work or not, but
> > ideally the caller would open the eventfd fd, pass it, the
> > cgroup name, controller file to be watched, and the args to
> > cgmanager;  cgmanager confirms read access, opens the
> > controller fd, makes the request over cgroup.event_control,
> > then passes the controller fd back to the caller and closes
> > its own copy.
> >
> > I'm also not sure whether the cgroup interface is going to be
> > offering a new feature to replace eventfd, since it wants
> > people to stop using cgroupfs...  Tejun?
> >
> 
> >From my discussions with Tejun, he wanted to move to using inotify so it
> may still be an fd we pass around.

Hm, would that just be inotify on the memory.max_usage_in_bytes
file, of inotify on a specific fd you've created which is
associated with any threshold you specify?  The former seems
less ideal.

-serge
