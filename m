From: Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Tue, 3 Dec 2013 21:09:41 -0800
Message-ID: <CAD=mX8seoMfM63hOwbmJ_0GdS-fa8H6fB40k8uyqBNbSVqfXrA@mail.gmail.com>
References: <20131125224335.GA15481@mail.hallyn.com>
	<20131203134506.GG8277@htj.dyndns.org>
	<20131204000344.GB24968@sergelap>
	<20131204012416.GY8277@htj.dyndns.org>
	<20131204023151.GA12376@sergelap>
	<CAO_RewbZiLCJcO9G7pgxN8ZxkkVdEW1B84nkQ5wX3a9DPq4zfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5654762270626927465=="
Return-path: <lxc-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CAO_RewbZiLCJcO9G7pgxN8ZxkkVdEW1B84nkQ5wX3a9DPq4zfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/lxc-devel>,
	<mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=lxc-devel>
List-Post: <mailto:lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/lxc-devel>,
	<mailto:lxc-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: lxc-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: =?ISO-8859-1?Q?St=E9phane_Graber?= <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

--===============5654762270626927465==
Content-Type: multipart/alternative; boundary=bcaec5196ddde1e87d04ecae6c56

--bcaec5196ddde1e87d04ecae6c56
Content-Type: text/plain; charset=ISO-8859-1

I thought we were going to use chown in the initial version to enforce the
ownership/permissions on the hierarchy. Only the cgroup manager has access
to the hierarchy, but it tries to access the hierarchy as the user that
sent the request. It was only meant to be a "for now" solution while the
real one rolls out. It may also have gotten thrown out since last I heard :)


On Tue, Dec 3, 2013 at 8:53 PM, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> If this daemon works as advertised, we will explore moving all write
> traffic to use it.  I still have concerns that this can't handle read
> traffic at the scale we need.
>
> Tejun,  I am not sure why chown came back into the conversation.  This
> is a replacement for that.
>
> On Tue, Dec 3, 2013 at 6:31 PM, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> wrote:
> > Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> >> Hello, Serge.
> >>
> >> On Tue, Dec 03, 2013 at 06:03:44PM -0600, Serge Hallyn wrote:
> >> > > As I communicated multiple times before, delegating write access to
> >> > > control knobs to untrusted domain has always been a security risk
> and
> >> > > is likely to continue to remain so.  Also, organizationally, a
> >> >
> >> > Then that will need to be address with per-key blacklisting and/or
> >> > per-value filtering in the manager.
> >> >
> >> > Which is my way of saying:  can we please have a list of the security
> >> > issues so we can handle them?  :)  (I've asked several times before
> >> > but haven't seen a list or anyone offering to make one)
> >>
> >> Unfortunately, for now, please consider everything blacklisted.  Yes,
> >> it is true that some knobs should be mostly safe but given the level
> >> of changes we're going through and the difficulty of properly auditing
> >> anything for delegation to untrusted environment, I don't feel
> >> comfortable at all about delegating through chown.  It is an
> >> accidental feature which happened just because it uses filesystem as
> >> its interface and it is no where near the top of the todo list.  It
> >> has never worked properly and won't in any foreseeable future.
> >>
> >> > > cgroup's control knobs belong to the parent not the cgroup itself.
> >> >
> >> > After thinking awhile I think this makes perfect sense.  I haven't
> >> > implemented set_value yet, and when I do I think I'll implement this
> >> > guideline.
> >>
> >> I'm kinda confused here.  You say *everything* is gonna go through the
> >> manager and then talks about chowning directories.  Don't the two
> >> conflict?
> >
> > No.  I expect the user - except in the google case - to either have
> > access to no cgroupfs mounts, or readonly mounts.
> >
> > -serge
>

--bcaec5196ddde1e87d04ecae6c56
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I thought we were going to use chown in the initial versio=
n to enforce the ownership/permissions on the hierarchy. Only the cgroup ma=
nager has access to the hierarchy, but it tries to access the hierarchy as =
the user that sent the request. It was only meant to be a &quot;for now&quo=
t; solution while the real one rolls out. It may also have gotten thrown ou=
t since last I heard :)</div>

<div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Tue, Dec 3=
, 2013 at 8:53 PM, Tim Hockin <span dir=3D"ltr">&lt;<a href=3D"mailto:thock=
in-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" target=3D"_blank">thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org</a>&gt;</span> wrote:<b=
r><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:=
1px #ccc solid;padding-left:1ex">

If this daemon works as advertised, we will explore moving all write<br>
traffic to use it. =A0I still have concerns that this can&#39;t handle read=
<br>
traffic at the scale we need.<br>
<br>
Tejun, =A0I am not sure why chown came back into the conversation. =A0This<=
br>
is a replacement for that.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
On Tue, Dec 3, 2013 at 6:31 PM, Serge Hallyn &lt;<a href=3D"mailto:serge.ha=
llyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org">serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org</a>&gt; wrote:<br>
&gt; Quoting Tejun Heo (<a href=3D"mailto:tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org">tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org</a>)=
:<br>
&gt;&gt; Hello, Serge.<br>
&gt;&gt;<br>
&gt;&gt; On Tue, Dec 03, 2013 at 06:03:44PM -0600, Serge Hallyn wrote:<br>
&gt;&gt; &gt; &gt; As I communicated multiple times before, delegating writ=
e access to<br>
&gt;&gt; &gt; &gt; control knobs to untrusted domain has always been a secu=
rity risk and<br>
&gt;&gt; &gt; &gt; is likely to continue to remain so. =A0Also, organizatio=
nally, a<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; Then that will need to be address with per-key blacklisting a=
nd/or<br>
&gt;&gt; &gt; per-value filtering in the manager.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; Which is my way of saying: =A0can we please have a list of th=
e security<br>
&gt;&gt; &gt; issues so we can handle them? =A0:) =A0(I&#39;ve asked severa=
l times before<br>
&gt;&gt; &gt; but haven&#39;t seen a list or anyone offering to make one)<b=
r>
&gt;&gt;<br>
&gt;&gt; Unfortunately, for now, please consider everything blacklisted. =
=A0Yes,<br>
&gt;&gt; it is true that some knobs should be mostly safe but given the lev=
el<br>
&gt;&gt; of changes we&#39;re going through and the difficulty of properly =
auditing<br>
&gt;&gt; anything for delegation to untrusted environment, I don&#39;t feel=
<br>
&gt;&gt; comfortable at all about delegating through chown. =A0It is an<br>
&gt;&gt; accidental feature which happened just because it uses filesystem =
as<br>
&gt;&gt; its interface and it is no where near the top of the todo list. =
=A0It<br>
&gt;&gt; has never worked properly and won&#39;t in any foreseeable future.=
<br>
&gt;&gt;<br>
&gt;&gt; &gt; &gt; cgroup&#39;s control knobs belong to the parent not the =
cgroup itself.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; After thinking awhile I think this makes perfect sense. =A0I =
haven&#39;t<br>
&gt;&gt; &gt; implemented set_value yet, and when I do I think I&#39;ll imp=
lement this<br>
&gt;&gt; &gt; guideline.<br>
&gt;&gt;<br>
&gt;&gt; I&#39;m kinda confused here. =A0You say *everything* is gonna go t=
hrough the<br>
&gt;&gt; manager and then talks about chowning directories. =A0Don&#39;t th=
e two<br>
&gt;&gt; conflict?<br>
&gt;<br>
&gt; No. =A0I expect the user - except in the google case - to either have<=
br>
&gt; access to no cgroupfs mounts, or readonly mounts.<br>
&gt;<br>
&gt; -serge<br>
</div></div></blockquote></div><br></div>

--bcaec5196ddde1e87d04ecae6c56--


--===============5654762270626927465==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Sponsored by Intel(R) XDK 
Develop, test and display web and hybrid apps with a single code base.
Download it for free now!
http://pubads.g.doubleclick.net/gampad/clk?id=111408631&iu=/4140/ostg.clktrk
--===============5654762270626927465==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
lxc-devel mailing list
lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/lxc-devel

--===============5654762270626927465==--

