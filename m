From: "Ho, Kenny" <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH RFC 2/5] cgroup: Add mechanism to register vendor specific
 DRM devices
Date: Wed, 21 Nov 2018 22:07:22 +0000
Message-ID: <DM5PR12MB1226238684747E76C7FE217D83DA0@DM5PR12MB1226.namprd12.prod.outlook.com>
References: <20181120185814.13362-1-Kenny.Ho@amd.com>
 <20181120185814.13362-3-Kenny.Ho@amd.com>
 <20181120202141.GA2509588@devbig004.ftw2.facebook.com>
 <DM5PR12MB1226E972538A45325114ADF683D90@DM5PR12MB1226.namprd12.prod.outlook.com>,
 <20181120223018.GB2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0758498318=="
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20181120223018.GB2509588-LpCCV3molIbIZ9tKgghJQw2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
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
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>

--===============0758498318==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_DM5PR12MB1226238684747E76C7FE217D83DA0DM5PR12MB1226namp_"

--_000_DM5PR12MB1226238684747E76C7FE217D83DA0DM5PR12MB1226namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, Nov 20, 2018 at 5:30 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Nov 20, 2018 at 10:21:14PM +0000, Ho, Kenny wrote:
> > By this reply, are you suggesting that vendor specific resources
> > will never be acceptable to be managed under cgroup?  Let say a user
>
> I wouldn't say never but whatever which gets included as a cgroup
> controller should have clearly defined resource abstractions and the
> control schemes around them including support for delegation.  AFAICS,
> gpu side still seems to have a long way to go (and it's not clear
> whether that's somewhere it will or needs to end up).
Right, I totally understand that it's not obvious from this RFC because the=
 'resource' counting demonstrated in this RFC is trivial in nature, mostly =
to illustrate the 'vendor' concept.  The structure of this patch actually g=
ive us the ability to support both abstracted resources you mentioned and v=
endor specific resources.  But it is probably not very clear as the RFC onl=
y includes two resources and they are both vendor specific.  To be clear, I=
 am not saying there aren't abstracted resources in drm, there are (we are =
still working on those).  What I am saying is that not all resources are ab=
stracted and for the purpose of this RFC I was hoping to get some feedback =
on the vendor specific parts early just so that we don't go down the wrong =
path.

That said, I think I am getting a better sense of what you are saying.  Ple=
ase correct me if I misinterpreted: your concern is that abstracting by ven=
dor is too high level and it's too much of a free-for-all.  Instead, resour=
ces should be abstracted at the controller level even if it's only availabl=
e to a specific vendor (or even a specific product from a specific vendor).=
  Is that a fair read?

A couple of additional side questions:
* Is statistic/accounting-only use cases like those enabled by cpuacct cont=
roller no longer sufficient?  If it is still sufficient, can you elaborate =
more on what you mean by having control schemes and supporting delegation?
* When you wrote delegation, do you mean delegation in the sense described =
in https://www.kernel.org/doc/Documentation/cgroup-v2.txt ?

> > To put the questions in more concrete terms, let say a user wants to
> > expose certain part of a gpu to a particular cgroup similar to the
> > way selective cpu cores are exposed to a cgroup via cpuset, how
> > should we go about enabling such functionality?
>
> Do what the intel driver or bpf is doing?  It's not difficult to hook
> into cgroup for identification purposes.
Does intel driver or bpf present an interface file in cgroupfs for users to=
 configure the core selection like cpuset?  I must admit I am not too famil=
iar with the bpf case as I was referencing mostly the way rdma was implemen=
ted when putting this RFC together.


Perhaps I wasn't communicating clearly so let me see if I can illustrate th=
is discussion with a hypothetical but concrete example using our competitor=
's product.  Nvidia has something called Tensor Cores in some of their GPUs=
 and the purpose of those cores is to accelerate matrix operations for mach=
ine learning applications.  This is something unique to Nvidia and to my kn=
owledge no one else has something like it.  These cores are different from =
regular shader processors and there are multiple of them in a GPU.

Under the structure of this RFC, if Nvidia wants to make Tensor Cores manag=
eable via cgroup (with the "Allocation" distribution model let say), they w=
ill probably have an interface file called "drm.nvidia.tensor_core", in whi=
ch only nvidia's GPUs will be listed.  If a GPU has TC, it will have a posi=
tive count, otherwise 0.

If I understand you correctly Tejun, is that they should not do that.  What=
 they should do is have an abstracted resource, possibly named "drm.matrix_=
accelerator" where all drm devices available on a system will be listed.  A=
ll GPUs except some Nvidia's will have a count of 0.  Or perhaps that is no=
t sufficiently abstracted so instead there should be just "drm.cores" inste=
ad and that file list both device, core types and count.  For one vendor th=
ey may have shader proc, texture map unit, tensor core, ray tracing cores a=
s types.  Others may have ALUs, EUs and subslices.

Is that an accurate representation of what you are recommending?

Regards,
Kenny


--_000_DM5PR12MB1226238684747E76C7FE217D83DA0DM5PR12MB1226namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
</head>
<body dir=3D"ltr">
<div id=3D"divtagdefaultwrapper" style=3D"font-size: 12pt; color: rgb(0, 0,=
 0); font-family: Calibri, Helvetica, sans-serif, EmojiFont, &quot;Apple Co=
lor Emoji&quot;, &quot;Segoe UI Emoji&quot;, NotoColorEmoji, &quot;Segoe UI=
 Symbol&quot;, &quot;Android Emoji&quot;, EmojiSymbols;" dir=3D"ltr">
<p style=3D"margin-top:0;margin-bottom:0"></p>
<div>Hi Tejun,<br>
<br>
On Tue, Nov 20, 2018 at 5:30 PM Tejun Heo &lt;tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org&gt; wrote:<br>
&gt; On Tue, Nov 20, 2018 at 10:21:14PM &#43;0000, Ho, Kenny wrote:<br>
&gt; &gt; By this reply, are you suggesting that vendor specific resources<=
br>
&gt; &gt; will never be acceptable to be managed under cgroup? &nbsp;Let sa=
y a user<br>
&gt;<br>
&gt; I wouldn't say never but whatever which gets included as a cgroup<br>
&gt; controller should have clearly defined resource abstractions and the<b=
r>
&gt; control schemes around them including support for delegation. &nbsp;AF=
AICS,<br>
&gt; gpu side still seems to have a long way to go (and it's not clear<br>
&gt; whether that's somewhere it will or needs to end up).<br>
Right, I totally understand that it's not obvious from this RFC because the=
 'resource' counting demonstrated in this RFC is trivial in nature, mostly =
to illustrate the 'vendor' concept. &nbsp;The structure of this patch actua=
lly give us the ability to support both
 abstracted resources you mentioned and vendor specific resources.&nbsp; Bu=
t it is probably not very clear as the RFC only includes two resources and =
they are both vendor specific.&nbsp; To be clear, I am not saying there are=
n't abstracted resources in drm, there are
 (we are still working on those).&nbsp; What I am saying is that not all re=
sources are abstracted and for the purpose of this RFC I was hoping to get =
some feedback on the vendor specific parts early just so that we don't go d=
own the wrong path.<br>
<br>
That said, I think I am getting a better sense of what you are saying. &nbs=
p;Please correct me if I misinterpreted: your concern is that abstracting b=
y vendor is too high level and it's too much of a free-for-all. &nbsp;Inste=
ad, resources should be abstracted at the
 controller level even if it's only available to a specific vendor (or even=
 a specific product from a specific vendor). &nbsp;Is that a fair read?<br>
<br>
A couple of additional side questions:<br>
* Is statistic/accounting-only use cases like those enabled by cpuacct cont=
roller no longer sufficient? &nbsp;If it is still sufficient, can you elabo=
rate more on what you mean by having control schemes and supporting delegat=
ion?<br>
* When you wrote delegation, do you mean delegation in the sense described =
in https://www.kernel.org/doc/Documentation/cgroup-v2.txt ?<br>
<br>
&gt; &gt; To put the questions in more concrete terms, let say a user wants=
 to<br>
&gt; &gt; expose certain part of a gpu to a particular cgroup similar to th=
e<br>
&gt; &gt; way selective cpu cores are exposed to a cgroup via cpuset, how<b=
r>
&gt; &gt; should we go about enabling such functionality?<br>
&gt;<br>
&gt; Do what the intel driver or bpf is doing? &nbsp;It's not difficult to =
hook<br>
&gt; into cgroup for identification purposes.<br>
Does intel driver or bpf present an interface file in cgroupfs for users to=
 configure the core selection like cpuset?&nbsp; I must admit I am not too =
familiar with the bpf case as I was referencing mostly the way rdma was imp=
lemented when putting this RFC together.<br>
<br>
<br>
Perhaps I wasn't communicating clearly so let me see if I can illustrate th=
is discussion with a hypothetical but concrete example using our competitor=
's product. &nbsp;Nvidia has something called Tensor Cores in some of their=
 GPUs and the purpose of those cores
 is to accelerate matrix operations for machine learning applications. &nbs=
p;This is something unique to Nvidia and to my knowledge no one else has so=
mething like it. &nbsp;These cores are different from regular shader proces=
sors and there are multiple of them in a GPU.<br>
<br>
Under the structure of this RFC, if Nvidia wants to make Tensor Cores manag=
eable via cgroup (with the &quot;Allocation&quot; distribution model let sa=
y), they will probably have an interface file called &quot;drm.nvidia.tenso=
r_core&quot;, in which only nvidia's GPUs will be listed.
 &nbsp;If a GPU has TC, it will have a positive count, otherwise 0.<br>
<br>
If I understand you correctly Tejun, is that they should not do that.&nbsp;=
 What they should do is have an abstracted resource, possibly named &quot;d=
rm.matrix_accelerator&quot; where all drm devices available on a system wil=
l be listed.&nbsp; All GPUs except some Nvidia's will
 have a count of 0.&nbsp; Or perhaps that is not sufficiently abstracted so=
 instead there should be just &quot;drm.cores&quot; instead and that file l=
ist both device, core types and count.&nbsp; For one vendor they may have s=
hader proc, texture map unit, tensor core, ray tracing
 cores as types.&nbsp; Others may have ALUs, EUs and subslices.<br>
<br>
Is that an&nbsp;accurate representation of what you are recommending?<br>
<br>
Regards,<br>
Kenny&nbsp;</div>
<div style=3D"color: rgb(0, 0, 0);">
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText"><br>
</div>
</span></font></div>
</div>
</div>
</body>
</html>

--_000_DM5PR12MB1226238684747E76C7FE217D83DA0DM5PR12MB1226namp_--

--===============0758498318==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBt
YWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5m
cmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4Cg==

--===============0758498318==--
