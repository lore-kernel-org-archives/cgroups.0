From: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] security: selinux: allow changing labels for cgroupfs
Date: Thu, 2 Feb 2017 16:22:21 +0100
Message-ID: <CALKLTGRXnqU=jY_qX-Ned3Rg6r-jouSgLhVMfsV17nHZi28R4g@mail.gmail.com>
References: <20170202144228.24454-1-runcom@redhat.com>
 <20170202150118.GA6441@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6422388200890147955=="
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
In-Reply-To: <20170202150118.GA6441-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--===============6422388200890147955==
Content-Type: multipart/alternative; boundary=001a113d480651a7db05478dbb70

--001a113d480651a7db05478dbb70
Content-Type: text/plain; charset=UTF-8

On Thu, Feb 2, 2017 at 4:01 PM, Gary Tierney <gary.tierney-KK0ffGbhmjU@public.gmane.org> wrote:

> On Thu, Feb 02, 2017 at 03:42:28PM +0100, Antonio Murdaca wrote:
> > This patch allows changing labels for cgroup mounts. Previously, running
> > chcon on cgroupfs would throw an "Operation not supported". This patch
> > specifically whitelist cgroupfs.
> >
> > The patch could also allow containers to write only to the systemd cgroup
> > for instance, while the other cgroups are kept with cgroup_t label.
> >
> > Signed-off-by: Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  security/selinux/hooks.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 3b955c6..4e84211 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -480,6 +480,7 @@ static int selinux_is_sblabel_mnt(struct super_block
> *sb)
> >               sbsec->behavior == SECURITY_FS_USE_NATIVE ||
> >               /* Special handling. Genfs but also in-core setxattr
> handler */
> >               !strcmp(sb->s_type->name, "sysfs") ||
> > +             !strcmp(sb->s_type->name, "cgroup") ||
>
> Should we also include "cgroup2" here, since they are defined as 2
> distinct filesystems? https://github.com/SELinuxProject/selinux-kernel/
> blob/master/kernel/cgroup.c#L2314-L2326


likely yes


>
>
> >               !strcmp(sb->s_type->name, "pstore") ||
> >               !strcmp(sb->s_type->name, "debugfs") ||
> >               !strcmp(sb->s_type->name, "tracefs") ||
> > --
> > 2.9.3
> >
> > _______________________________________________
> > Selinux mailing list
> > Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
> > To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
> > To get help, send an email containing "help" to
> Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
>



-- 
Antonio (runcom) Murdaca, RHCE
Senior Software Engineer - Containers
09B9 8F09 3E2D C310 E250 69B5 B2BE AD15 0DE9 36B9
<https://pgp.mit.edu/pks/lookup?op=get&search=0xB2BEAD150DE936B9>

--001a113d480651a7db05478dbb70
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Thu, Feb 2, 2017 at 4:01 PM, Gary Tierney <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:gary.tierney-KK0ffGbhmjU@public.gmane.org" target=3D"_blank">gary.tierney-KK0ffGbhmjU@public.gmane.org<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On=
 Thu, Feb 02, 2017 at 03:42:28PM +0100, Antonio Murdaca wrote:<br>
&gt; This patch allows changing labels for cgroup mounts. Previously, runni=
ng<br>
&gt; chcon on cgroupfs would throw an &quot;Operation not supported&quot;. =
This patch<br>
&gt; specifically whitelist cgroupfs.<br>
&gt;<br>
&gt; The patch could also allow containers to write only to the systemd cgr=
oup<br>
&gt; for instance, while the other cgroups are kept with cgroup_t label.<br=
>
&gt;<br>
&gt; Signed-off-by: Antonio Murdaca &lt;<a href=3D"mailto:runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org=
">runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 security/selinux/hooks.c | 1 +<br>
&gt;=C2=A0 1 file changed, 1 insertion(+)<br>
&gt;<br>
&gt; diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c<br>
&gt; index 3b955c6..4e84211 100644<br>
&gt; --- a/security/selinux/hooks.c<br>
&gt; +++ b/security/selinux/hooks.c<br>
&gt; @@ -480,6 +480,7 @@ static int selinux_is_sblabel_mnt(struct super_blo=
ck *sb)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sbsec-&gt;behavi=
or =3D=3D SECURITY_FS_USE_NATIVE ||<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Special handl=
ing. Genfs but also in-core setxattr handler */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(sb-&gt;s=
_type-&gt;name, &quot;sysfs&quot;) ||<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(sb-&gt;s_type=
-&gt;name, &quot;cgroup&quot;) ||<br>
<br>
</span>Should we also include &quot;cgroup2&quot; here, since they are defi=
ned as 2<br>
distinct filesystems? <a href=3D"https://github.com/SELinuxProject/selinux-=
kernel/blob/master/kernel/cgroup.c#L2314-L2326" rel=3D"noreferrer" target=
=3D"_blank">https://github.com/<wbr>SELinuxProject/selinux-kernel/<wbr>blob=
/master/kernel/cgroup.c#<wbr>L2314-L2326</a></blockquote><div><br></div><di=
v>likely yes</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><br>
<span class=3D""><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(sb-&gt;s=
_type-&gt;name, &quot;pstore&quot;) ||<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(sb-&gt;s=
_type-&gt;name, &quot;debugfs&quot;) ||<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(sb-&gt;s=
_type-&gt;name, &quot;tracefs&quot;) ||<br>
&gt; --<br>
&gt; 2.9.3<br>
&gt;<br>
</span>&gt; ______________________________<wbr>_________________<br>
&gt; Selinux mailing list<br>
&gt; <a href=3D"mailto:Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org">Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org</a><br>
&gt; To unsubscribe, send email to <a href=3D"mailto:Selinux-leave-+05T5uksL2o@public.gmane.org=
a.gov">Selinux-leave-+05T5uksL2qpZYMLLGbcSA@public.gmane.org</a>.<br>
&gt; To get help, send an email containing &quot;help&quot; to <a href=3D"m=
ailto:Selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org">Selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org</a>.<br>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><div class=
=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><d=
iv><div dir=3D"ltr"><div><div dir=3D"ltr"><div><div dir=3D"ltr"><div><div d=
ir=3D"ltr"><div><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=
=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr=
"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div =
dir=3D"ltr"><div>Antonio (runcom) Murdaca, RHCE</div><div>Senior Software E=
ngineer - Containers</div><a href=3D"https://pgp.mit.edu/pks/lookup?op=3Dge=
t&amp;search=3D0xB2BEAD150DE936B9" target=3D"_blank">09B9 8F09 3E2D C310 E2=
50 69B5 B2BE AD15 0DE9 36B9</a></div></div></div></div></div></div></div></=
div></div></div></div></div></div></div></div></div></div></div></div></div=
></div></div></div></div>
</div></div>

--001a113d480651a7db05478dbb70--

--===============6422388200890147955==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
--===============6422388200890147955==--
