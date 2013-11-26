From: Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Tue, 26 Nov 2013 08:22:37 -0800
Message-ID: <CAD=mX8tCOEO4wP-XGs9YdRufTAay6zPaOxo_wZF=-KoqepH0wg@mail.gmail.com>
References: <20131125224335.GA15481@mail.hallyn.com>
	<CAO_RewZGWARUafKzDc_t3G5OedGtEPTZgB2VYeHHiKSSrja8fA@mail.gmail.com>
	<20131126161246.GA23834@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4441990191647104622=="
Return-path: <lxc-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20131126161246.GA23834-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
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

--===============4441990191647104622==
Content-Type: multipart/alternative; boundary=bcaec51d2552bdeb5004ec16e43a

--bcaec51d2552bdeb5004ec16e43a
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Nov 26, 2013 at 8:12 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:

> Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> > What are the requirements/goals around performance and concurrency?
> > Do you expect this to be a single-threaded thing, or can we handle
> > some number of concurrent operations?  Do you expect to use threads of
> > processes?
>
> The cgmanager should be pretty dumb, so I would expect it to be
> quite fast.  I don't have any specific perf goals though.  If you
> have requirements I'm very interested to hear them.  I should be
> able to tell pretty soon how far short I fall.
>
> By default I'd expect to run with a single thread, but I don't
> imagine one thread can serve a busy 1024-cpu system very well.
> Unless you have guidance right now, I think I'd like to get
> started with the basic functionality and see how it measures
> up to your requirements.  I should add perf counters from the
> start so we can figure out where bottlenecks (if any) are and
> how to handle them.
>
> Otherwise I could start out with a basic numcpus/10 threadpool
> and have the main thread do socket i/o and parcel access
> verification and vfs work out to the threadpool, but I'd rather
> first know where the problems lie.
>

From Rohit's talk at Linux plumbers:

http://www.linuxplumbersconf.net/2013/ocw//system/presentations/1239/original/lmctfy%20(1).pdf

The goal is O(1000) reads and O(100) writes per second.


>
> > Can you talk about logging - what and where?
>
> When started under upstart, anything we print out goes to
> /var/log/upstart/cgmanager.log.  Would be nice to keep it
> that simple.  We could log requests by r to do something
> it is not allowed to do, but it seems to me the failed
> attempts cause no harm, while the potential for overflowing
> logs can.
>
> Did you have anything in mind?  Did you want logging to help
> detect certain conditions for system optimization, or just
> for failure notices and security violations?
>
> > How will we handle event_fd?  Pass a file-descriptor back to the caller?
>
> The only thing currently supporting eventfd is memory threshold,
> right?  I haven't tested whether this will work or not, but
> ideally the caller would open the eventfd fd, pass it, the
> cgroup name, controller file to be watched, and the args to
> cgmanager;  cgmanager confirms read access, opens the
> controller fd, makes the request over cgroup.event_control,
> then passes the controller fd back to the caller and closes
> its own copy.
>
> I'm also not sure whether the cgroup interface is going to be
> offering a new feature to replace eventfd, since it wants
> people to stop using cgroupfs...  Tejun?
>

From my discussions with Tejun, he wanted to move to using inotify so it
may still be an fd we pass around.


> > That's all I can come up with for now.
>

--bcaec51d2552bdeb5004ec16e43a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><br><div class=3D"gmail=
_quote">On Tue, Nov 26, 2013 at 8:12 AM, Serge E. Hallyn <span dir=3D"ltr">=
&lt;<a href=3D"mailto:serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" target=3D"_blank">serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org<=
/a>&gt;</span> wrote:<br>


<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div>Quoting Tim Hockin (<a href=3D"mailto:thockin@google.=
com" target=3D"_blank">thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org</a>):<br>


&gt; What are the requirements/goals around performance and concurrency?<br=
>
&gt; Do you expect this to be a single-threaded thing, or can we handle<br>
&gt; some number of concurrent operations? =A0Do you expect to use threads =
of<br>
&gt; processes?<br>
<br>
</div>The cgmanager should be pretty dumb, so I would expect it to be<br>
quite fast. =A0I don&#39;t have any specific perf goals though. =A0If you<b=
r>
have requirements I&#39;m very interested to hear them. =A0I should be<br>
able to tell pretty soon how far short I fall.<br>
<br>
By default I&#39;d expect to run with a single thread, but I don&#39;t<br>
imagine one thread can serve a busy 1024-cpu system very well.<br>
Unless you have guidance right now, I think I&#39;d like to get<br>
started with the basic functionality and see how it measures<br>
up to your requirements. =A0I should add perf counters from the<br>
start so we can figure out where bottlenecks (if any) are and<br>
how to handle them.<br>
<br>
Otherwise I could start out with a basic numcpus/10 threadpool<br>
and have the main thread do socket i/o and parcel access<br>
verification and vfs work out to the threadpool, but I&#39;d rather<br>
first know where the problems lie.<br></blockquote><div><br></div><div>From=
 Rohit&#39;s talk at Linux plumbers:</div><div><br></div><div><a href=3D"ht=
tp://www.linuxplumbersconf.net/2013/ocw//system/presentations/1239/original=
/lmctfy%20(1).pdf">http://www.linuxplumbersconf.net/2013/ocw//system/presen=
tations/1239/original/lmctfy%20(1).pdf</a><br>

</div><div><br></div><div>The goal is O(1000) reads and O(100) writes per s=
econd.</div><div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin=
:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204)=
;border-left-style:solid;padding-left:1ex">



<div><br>
&gt; Can you talk about logging - what and where?<br>
<br>
</div>When started under upstart, anything we print out goes to<br>
/var/log/upstart/cgmanager.log. =A0Would be nice to keep it<br>
that simple. =A0We could log requests by r to do something<br>
it is not allowed to do, but it seems to me the failed<br>
attempts cause no harm, while the potential for overflowing<br>
logs can.<br>
<br>
Did you have anything in mind? =A0Did you want logging to help<br>
detect certain conditions for system optimization, or just<br>
for failure notices and security violations?<br>
<div><br>
&gt; How will we handle event_fd? =A0Pass a file-descriptor back to the cal=
ler?<br>
<br>
</div>The only thing currently supporting eventfd is memory threshold,<br>
right? =A0I haven&#39;t tested whether this will work or not, but<br>
ideally the caller would open the eventfd fd, pass it, the<br>
cgroup name, controller file to be watched, and the args to<br>
cgmanager; =A0cgmanager confirms read access, opens the<br>
controller fd, makes the request over cgroup.event_control,<br>
then passes the controller fd back to the caller and closes<br>
its own copy.<br>
<br>
I&#39;m also not sure whether the cgroup interface is going to be<br>
offering a new feature to replace eventfd, since it wants<br>
people to stop using cgroupfs... =A0Tejun?<br></blockquote><div><br></div><=
div>From my discussions with Tejun, he wanted to move to using inotify so i=
t may still be an fd we pass around.=A0</div><div><br></div><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;=
border-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex=
">


<div><div><br>
&gt; That&#39;s all I can come up with for now.<br>
</div></div></blockquote></div><br></div></div>

--bcaec51d2552bdeb5004ec16e43a--


--===============4441990191647104622==
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
--===============4441990191647104622==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Lxc-devel mailing list
Lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/lxc-devel

--===============4441990191647104622==--

