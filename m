From: Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Tue, 26 Nov 2013 09:19:18 -0800
Message-ID: <CAD=mX8v-jfA8F5DueK60Oo4Zfcjj86idKYKnDVc9LxQVs9W_rQ@mail.gmail.com>
References: <20131125224335.GA15481@mail.hallyn.com>
	<CAO_RewZGWARUafKzDc_t3G5OedGtEPTZgB2VYeHHiKSSrja8fA@mail.gmail.com>
	<20131126161246.GA23834@mail.hallyn.com>
	<CAD=mX8tCOEO4wP-XGs9YdRufTAay6zPaOxo_wZF=-KoqepH0wg@mail.gmail.com>
	<20131126164125.GC23834@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4203127241612034337=="
Return-path: <lxc-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20131126164125.GC23834-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/lxc-devel>,
	<mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=lxc-devel>
List-Post: <mailto:lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/lxc-devel>,
	<mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: lxc-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: =?ISO-8859-1?Q?St=E9phane_Graber?= <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--===============4203127241612034337==
Content-Type: multipart/alternative; boundary=047d7b672a966c8fa804ec17afc6

--047d7b672a966c8fa804ec17afc6
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Nov 26, 2013 at 8:41 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:

> Quoting Victor Marmol (vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> > On Tue, Nov 26, 2013 at 8:12 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
> wrote:
> >
> > > Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> > > > What are the requirements/goals around performance and concurrency?
> > > > Do you expect this to be a single-threaded thing, or can we handle
> > > > some number of concurrent operations?  Do you expect to use threads
> of
> > > > processes?
> > >
> > > The cgmanager should be pretty dumb, so I would expect it to be
> > > quite fast.  I don't have any specific perf goals though.  If you
> > > have requirements I'm very interested to hear them.  I should be
> > > able to tell pretty soon how far short I fall.
> > >
> > > By default I'd expect to run with a single thread, but I don't
> > > imagine one thread can serve a busy 1024-cpu system very well.
> > > Unless you have guidance right now, I think I'd like to get
> > > started with the basic functionality and see how it measures
> > > up to your requirements.  I should add perf counters from the
> > > start so we can figure out where bottlenecks (if any) are and
> > > how to handle them.
> > >
> > > Otherwise I could start out with a basic numcpus/10 threadpool
> > > and have the main thread do socket i/o and parcel access
> > > verification and vfs work out to the threadpool, but I'd rather
> > > first know where the problems lie.
> > >
> >
> > >From Rohit's talk at Linux plumbers:
> >
> >
> http://www.linuxplumbersconf.net/2013/ocw//system/presentations/1239/original/lmctfy%20(1).pdf
> >
> > The goal is O(1000) reads and O(100) writes per second.
>
> Cool, thanks.  I can try and get a sense next week of how far off the
> mark I am for reads.
>
> > > > Can you talk about logging - what and where?
> > >
> > > When started under upstart, anything we print out goes to
> > > /var/log/upstart/cgmanager.log.  Would be nice to keep it
> > > that simple.  We could log requests by r to do something
> > > it is not allowed to do, but it seems to me the failed
> > > attempts cause no harm, while the potential for overflowing
> > > logs can.
> > >
> > > Did you have anything in mind?  Did you want logging to help
> > > detect certain conditions for system optimization, or just
> > > for failure notices and security violations?
> > >
> > > > How will we handle event_fd?  Pass a file-descriptor back to the
> caller?
> > >
> > > The only thing currently supporting eventfd is memory threshold,
> > > right?  I haven't tested whether this will work or not, but
> > > ideally the caller would open the eventfd fd, pass it, the
> > > cgroup name, controller file to be watched, and the args to
> > > cgmanager;  cgmanager confirms read access, opens the
> > > controller fd, makes the request over cgroup.event_control,
> > > then passes the controller fd back to the caller and closes
> > > its own copy.
> > >
> > > I'm also not sure whether the cgroup interface is going to be
> > > offering a new feature to replace eventfd, since it wants
> > > people to stop using cgroupfs...  Tejun?
> > >
> >
> > >From my discussions with Tejun, he wanted to move to using inotify so it
> > may still be an fd we pass around.
>
> Hm, would that just be inotify on the memory.max_usage_in_bytes
> file, of inotify on a specific fd you've created which is
> associated with any threshold you specify?  The former seems
> less ideal.
>

Tejun can comment more, but I think it is still TBD.

>
> -serge
>

--047d7b672a966c8fa804ec17afc6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><br><div class=3D"gmail=
_quote">On Tue, Nov 26, 2013 at 8:41 AM, Serge E. Hallyn <span dir=3D"ltr">=
&lt;<a href=3D"mailto:serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" target=3D"_blank">serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org<=
/a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">Quot=
ing Victor Marmol (<a href=3D"mailto:vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org">vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
</a>):<br>


&gt; On Tue, Nov 26, 2013 at 8:12 AM, Serge E. Hallyn &lt;<a href=3D"mailto=
:serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org">serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; Quoting Tim Hockin (<a href=3D"mailto:thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org">thockin=
@google.com</a>):<br>
&gt; &gt; &gt; What are the requirements/goals around performance and concu=
rrency?<br>
&gt; &gt; &gt; Do you expect this to be a single-threaded thing, or can we =
handle<br>
&gt; &gt; &gt; some number of concurrent operations? =A0Do you expect to us=
e threads of<br>
&gt; &gt; &gt; processes?<br>
&gt; &gt;<br>
&gt; &gt; The cgmanager should be pretty dumb, so I would expect it to be<b=
r>
&gt; &gt; quite fast. =A0I don&#39;t have any specific perf goals though. =
=A0If you<br>
&gt; &gt; have requirements I&#39;m very interested to hear them. =A0I shou=
ld be<br>
&gt; &gt; able to tell pretty soon how far short I fall.<br>
&gt; &gt;<br>
&gt; &gt; By default I&#39;d expect to run with a single thread, but I don&=
#39;t<br>
&gt; &gt; imagine one thread can serve a busy 1024-cpu system very well.<br=
>
&gt; &gt; Unless you have guidance right now, I think I&#39;d like to get<b=
r>
&gt; &gt; started with the basic functionality and see how it measures<br>
&gt; &gt; up to your requirements. =A0I should add perf counters from the<b=
r>
&gt; &gt; start so we can figure out where bottlenecks (if any) are and<br>
&gt; &gt; how to handle them.<br>
&gt; &gt;<br>
&gt; &gt; Otherwise I could start out with a basic numcpus/10 threadpool<br=
>
&gt; &gt; and have the main thread do socket i/o and parcel access<br>
&gt; &gt; verification and vfs work out to the threadpool, but I&#39;d rath=
er<br>
&gt; &gt; first know where the problems lie.<br>
&gt; &gt;<br>
&gt;<br>
&gt; &gt;From Rohit&#39;s talk at Linux plumbers:<br>
&gt;<br>
&gt; <a href=3D"http://www.linuxplumbersconf.net/2013/ocw//system/presentat=
ions/1239/original/lmctfy%20(1).pdf" target=3D"_blank">http://www.linuxplum=
bersconf.net/2013/ocw//system/presentations/1239/original/lmctfy%20(1).pdf<=
/a><br>


&gt;<br>
&gt; The goal is O(1000) reads and O(100) writes per second.<br>
<br>
</div></div>Cool, thanks. =A0I can try and get a sense next week of how far=
 off the<br>
mark I am for reads.<br>
<div class=3D"im"><br>
&gt; &gt; &gt; Can you talk about logging - what and where?<br>
&gt; &gt;<br>
&gt; &gt; When started under upstart, anything we print out goes to<br>
&gt; &gt; /var/log/upstart/cgmanager.log. =A0Would be nice to keep it<br>
&gt; &gt; that simple. =A0We could log requests by r to do something<br>
&gt; &gt; it is not allowed to do, but it seems to me the failed<br>
&gt; &gt; attempts cause no harm, while the potential for overflowing<br>
&gt; &gt; logs can.<br>
&gt; &gt;<br>
&gt; &gt; Did you have anything in mind? =A0Did you want logging to help<br=
>
&gt; &gt; detect certain conditions for system optimization, or just<br>
&gt; &gt; for failure notices and security violations?<br>
&gt; &gt;<br>
&gt; &gt; &gt; How will we handle event_fd? =A0Pass a file-descriptor back =
to the caller?<br>
&gt; &gt;<br>
&gt; &gt; The only thing currently supporting eventfd is memory threshold,<=
br>
&gt; &gt; right? =A0I haven&#39;t tested whether this will work or not, but=
<br>
&gt; &gt; ideally the caller would open the eventfd fd, pass it, the<br>
&gt; &gt; cgroup name, controller file to be watched, and the args to<br>
&gt; &gt; cgmanager; =A0cgmanager confirms read access, opens the<br>
&gt; &gt; controller fd, makes the request over cgroup.event_control,<br>
&gt; &gt; then passes the controller fd back to the caller and closes<br>
&gt; &gt; its own copy.<br>
&gt; &gt;<br>
&gt; &gt; I&#39;m also not sure whether the cgroup interface is going to be=
<br>
&gt; &gt; offering a new feature to replace eventfd, since it wants<br>
&gt; &gt; people to stop using cgroupfs... =A0Tejun?<br>
&gt; &gt;<br>
&gt;<br>
&gt; &gt;From my discussions with Tejun, he wanted to move to using inotify=
 so it<br>
&gt; may still be an fd we pass around.<br>
<br>
</div>Hm, would that just be inotify on the memory.max_usage_in_bytes<br>
file, of inotify on a specific fd you&#39;ve created which is<br>
associated with any threshold you specify? =A0The former seems<br>
less ideal.<br></blockquote><div><br></div><div>Tejun can comment more, but=
 I think it is still TBD.=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-serge<br>
</font></span></blockquote></div><br></div></div>

--047d7b672a966c8fa804ec17afc6--


--===============4203127241612034337==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Rapidly troubleshoot problems before they affect your business. Most IT 
organizations don't have a clear picture of how application performance 
affects their revenue. With AppDynamics, you get 100% visibility into your 
Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics Pro!
http://pubads.g.doubleclick.net/gampad/clk?id=84349351&iu=/4140/ostg.clktrk
--===============4203127241612034337==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Lxc-devel mailing list
Lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/lxc-devel

--===============4203127241612034337==--

