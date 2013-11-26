From: Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Tue, 26 Nov 2013 13:31:43 -0800
Message-ID: <CAD=mX8uuAeN7s8ZA6Gc-wsBd6-PHevBRyBL6hMAS9VW15T5eYA@mail.gmail.com>
References: <20131125224335.GA15481@mail.hallyn.com>
	<CAO_RewZGWARUafKzDc_t3G5OedGtEPTZgB2VYeHHiKSSrja8fA@mail.gmail.com>
	<20131126054718.GA19134@mail.hallyn.com>
	<CAO_RewZ8cUn-PdXfQF0yH=V=9UqE7Yo1JX2pt2c71WYDrpYE0Q@mail.gmail.com>
	<20131126205819.GA27266@mail.hallyn.com>
	<CAO_RewZh+dNkUdZdu-R3CKTvYzbPL50v-BsBHvek75ti3V6kZQ@mail.gmail.com>
	<20131126212814.GA27602@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7022439014049137376=="
Return-path: <lxc-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20131126212814.GA27602-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
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

--===============7022439014049137376==
Content-Type: multipart/alternative; boundary=e89a8f23445129a5d404ec1b36e4

--e89a8f23445129a5d404ec1b36e4
Content-Type: text/plain; charset=ISO-8859-1

I think most of our usecases have only wanted to know about the parent, but
I can see people wanting to go further. Would it be much different to
support both? I feel like it'll be simpler to support all if we go that
route.


On Tue, Nov 26, 2013 at 1:28 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:

> Quoting Tim Hockin (thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> > lmctfy literally supports ".." as a container name :)
>
> So is ../.. ever used, or does noone every do anything beyond ..?
>

--e89a8f23445129a5d404ec1b36e4
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I think most of our usecases have only wanted to know abou=
t the parent, but I can see people wanting to go further. Would it be much =
different to support both? I feel like it&#39;ll be simpler to support all =
if we go that route.</div>

<div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Tue, Nov 2=
6, 2013 at 1:28 PM, Serge E. Hallyn <span dir=3D"ltr">&lt;<a href=3D"mailto=
:serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" target=3D"_blank">serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org</a>&gt;</span> wrote:=
<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-lef=
t:1px #ccc solid;padding-left:1ex">

<div class=3D"im">Quoting Tim Hockin (<a href=3D"mailto:thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org"=
>thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org</a>):<br>
&gt; lmctfy literally supports &quot;..&quot; as a container name :)<br>
<br>
</div>So is ../.. ever used, or does noone every do anything beyond ..?<br>
</blockquote></div><br></div>

--e89a8f23445129a5d404ec1b36e4--


--===============7022439014049137376==
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
--===============7022439014049137376==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Lxc-devel mailing list
Lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/lxc-devel

--===============7022439014049137376==--

