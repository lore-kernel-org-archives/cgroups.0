From: "Ho, Kenny" <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Mon, 13 Apr 2020 20:12:56 +0000
Message-ID: <DM6PR12MB399645C60BE2F5E3CC4F852883DD0@DM6PR12MB3996.namprd12.prod.outlook.com>
References: <20200226190152.16131-1-Kenny.Ho@amd.com>
 <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w@mail.gmail.com>
 <20200324184633.GH162390@mtj.duckdns.org>
 <CAOWid-cS-5YkFBLACotkZZCH0RSjHH94_r3VFH8vEPOubzSpPA@mail.gmail.com>,
 <20200413191136.GI60335@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0682915327=="
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HDN964L3IYmQaJjJGdyQvWLrXuHRuqLvwxwrAWYjWo=;
 b=RoKjdlSX/85TNGBx54CqcsItI5AELnK0kOzAbqKW/Dv9StLWKe4Zot2yiCO+RLy9ENgdak42TCcJXDjJ0WuXNQPtaYt3F+siKXIb3HM7ErrhHhcQ0DvAz97h4xAelf7q6plaVGjmhXcbT3m9Q4lDFrvRhC64gBndpbr1BoYhHEQ=
In-Reply-To: <20200413191136.GI60335-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Kuehling, Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "jsparks-WVYJKLFxKCc@public.gmane.org" <jsparks-WVYJKLFxKCc@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Larry Kaplan <lkaplan-WVYJKLFxKCc@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Greathouse,
 Joseph" <Joseph.Greathouse-5C7GfCeVMHo@public.gmane.org>, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Koenig,
 Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>

--===============0682915327==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DM6PR12MB399645C60BE2F5E3CC4F852883DD0DM6PR12MB3996namp_"

--_000_DM6PR12MB399645C60BE2F5E3CC4F852883DD0DM6PR12MB3996namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

[AMD Official Use Only - Internal Distribution Only]

Hi Tejun,

Thanks for taking the time to reply.

Perhaps we can even narrow things down to just gpu.weight/gpu.compute.weigh=
t as a start?  In this aspect, is the key objection to the current implemen=
tation of gpu.compute.weight the work-conserving bit?  This work-conserving=
 requirement is probably what I have missed for the last two years (and hen=
ce going in circle.)

If this is the case, can you clarify/confirm the followings?

1) Is resource scheduling goal of cgroup purely for the purpose of throughp=
ut?  (at the expense of other scheduling goals such as latency.)
2) If 1) is true, under what circumstances will the "Allocations" resource =
distribution model (as defined in the cgroup-v2) be acceptable?
3) If 1) is true, are things like cpuset from cgroup v1 no longer acceptabl=
e going forward?

To be clear, while some have framed this (time sharing vs spatial sharing) =
as a partisan issue, it is in fact a technical one.  I have implemented the=
 gpu cgroup support this way because we have a class of users that value lo=
w latency/low jitter/predictability/synchronicity.  For example, they would=
 like 4 tasks to share a GPU and they would like the tasks to start and fin=
ish at the same time.

What is the rationale behind picking the Weight model over Allocations as t=
he first acceptable implementation?  Can't we have both work-conserving and=
 non-work-conserving ways of distributing GPU resources?  If we can, why no=
t allow non-work-conserving implementation first, especially when we have u=
sers asking for such functionality?

Regards,
Kenny


________________________________
From: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> on behalf of Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sent: Monday, April 13, 2020 3:11 PM
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ho, Kenny <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>; cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org <cgroups-u79uwXL29TY@public.gmane.org=
nel.org>; dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>; amd-gfx list <amd-gf=
x@lists.freedesktop.org>; Deucher, Alexander <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>; K=
oenig, Christian <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>; Kuehling, Felix <Felix.Kuehlin=
g@amd.com>; Greathouse, Joseph <Joseph.Greathouse-5C7GfCeVMHo@public.gmane.org>; jsparks-2CRrayPlRfc@public.gmane.org=
m <jsparks-WVYJKLFxKCc@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem

Hello, Kenny.

On Tue, Mar 24, 2020 at 02:49:27PM -0400, Kenny Ho wrote:
> Can you elaborate more on what are the missing pieces?

Sorry about the long delay, but I think we've been going in circles for qui=
te
a while now. Let's try to make it really simple as the first step. How abou=
t
something like the following?

* gpu.weight (should it be gpu.compute.weight? idk) - A single number
  per-device weight similar to io.weight, which distributes computation
  resources in work-conserving way.

* gpu.memory.high - A single number per-device on-device memory limit.

The above two, if works well, should already be plenty useful. And my guess=
 is
that getting the above working well will be plenty challenging already even
though it's already excluding work-conserving memory distribution. So, let'=
s
please do that as the first step and see what more would be needed from the=
re.

Thanks.

--
tejun

--_000_DM6PR12MB399645C60BE2F5E3CC4F852883DD0DM6PR12MB3996namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<p style=3D"font-family:Arial;font-size:10pt;color:#0078D7;margin:15pt;" al=
ign=3D"Left">
[AMD Official Use Only - Internal Distribution Only]<br>
</p>
<br>
<div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">
Hi Tejun,</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">
<br>
</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">
Thanks for taking the time to reply.</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">
<br>
</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">
Perhaps we can even narrow things down to just gpu.weight/gpu.compute.weigh=
t as a start?&nbsp; In this aspect, is the key objection to the current imp=
lementation of gpu.compute.weight the work-conserving bit?&nbsp; This work-=
conserving requirement is probably what I
 have missed for the last two years (and hence going in circle.)</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">
<br>
</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">
If this is the case, can you clarify/confirm the followings?</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">
<br>
</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">
1) Is resource scheduling goal of cgroup purely for the purpose of throughp=
ut?&nbsp; (at the expense of other scheduling goals such as latency.)</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">
2) If 1) is true, under what circumstances will the &quot;Allocations&quot;=
 resource distribution model (as defined in the cgroup-v2) be acceptable?</=
div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0); background-color: rgb(255, 255, 255);">
3) If 1) is true, are things like cpuset from cgroup v1 no longer acceptabl=
e going forward?</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
To be clear, while some have framed this (time sharing vs spatial sharing) =
as a partisan issue, it is in fact a technical one.&nbsp; I have implemente=
d the gpu cgroup support this way because we have a class of users that val=
ue low latency/low jitter/predictability/synchronicity.&nbsp;
 For example, they would like 4 tasks to share a GPU and they would like th=
e tasks to start and finish at the same time.<br>
</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
What is the rationale behind picking the Weight model over Allocations as t=
he first acceptable implementation?&nbsp; Can't we have both work-conservin=
g and non-work-conserving ways of distributing GPU resources?&nbsp; If we c=
an, why not allow non-work-conserving implementation
 first, especially when we have users asking for such functionality?</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Regards,</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Kenny<br>
</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Arial, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font style=3D"font-size: 11pt;" data=
-ogsc=3D"" face=3D"Calibri, sans-serif" color=3D"#000000"><b>From:</b> Teju=
n Heo &lt;htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org&gt; on behalf of Tejun Heo &lt;tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org&gt;=
<br>
<b>Sent:</b> Monday, April 13, 2020 3:11 PM<br>
<b>To:</b> Kenny Ho &lt;y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org&gt;<br>
<b>Cc:</b> Ho, Kenny &lt;Kenny.Ho-5C7GfCeVMHo@public.gmane.org&gt;; cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org &lt;=
cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org&gt;; dri-devel &lt;dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org&=
gt;; amd-gfx list &lt;amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org&gt;; Deucher, Alexander=
 &lt;Alexander.Deucher-5C7GfCeVMHo@public.gmane.org&gt;; Koenig, Christian &lt;Christian.Koenig@=
amd.com&gt;;
 Kuehling, Felix &lt;Felix.Kuehling-5C7GfCeVMHo@public.gmane.org&gt;; Greathouse, Joseph &lt;Jos=
eph.Greathouse-5C7GfCeVMHo@public.gmane.org&gt;; jsparks-WVYJKLFxKCc@public.gmane.org &lt;jsparks-WVYJKLFxKCc@public.gmane.org&gt;<br>
<b>Subject:</b> Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subs=
ystem</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt"=
>
<div class=3D"PlainText">Hello, Kenny.<br>
<br>
On Tue, Mar 24, 2020 at 02:49:27PM -0400, Kenny Ho wrote:<br>
&gt; Can you elaborate more on what are the missing pieces?<br>
<br>
Sorry about the long delay, but I think we've been going in circles for qui=
te<br>
a while now. Let's try to make it really simple as the first step. How abou=
t<br>
something like the following?<br>
<br>
* gpu.weight (should it be gpu.compute.weight? idk) - A single number<br>
&nbsp; per-device weight similar to io.weight, which distributes computatio=
n<br>
&nbsp; resources in work-conserving way.<br>
<br>
* gpu.memory.high - A single number per-device on-device memory limit.<br>
<br>
The above two, if works well, should already be plenty useful. And my guess=
 is<br>
that getting the above working well will be plenty challenging already even=
<br>
though it's already excluding work-conserving memory distribution. So, let'=
s<br>
please do that as the first step and see what more would be needed from the=
re.<br>
<br>
Thanks.<br>
<br>
-- <br>
tejun<br>
</div>
</span></font></div>
</div>
</body>
</html>

--_000_DM6PR12MB399645C60BE2F5E3CC4F852883DD0DM6PR12MB3996namp_--

--===============0682915327==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
amd-gfx mailing list
amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
https://lists.freedesktop.org/mailman/listinfo/amd-gfx

--===============0682915327==--
