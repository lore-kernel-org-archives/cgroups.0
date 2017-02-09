From: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] security: selinux: allow per-file labeling for cgroupfs
Date: Thu, 9 Feb 2017 18:39:16 +0100
Message-ID: <CALKLTGTc7U7ohxd44MHOuzVomW-oUsumqUqr0MKaUohw1NpSsg@mail.gmail.com>
References: <20170209160242.23405-1-amurdaca@redhat.com>
 <CAHC9VhRFxDuRJHYEuRs7kc4ivgaT=-SxdU-o5Lq7H-O+5JJRxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8053906032647159068=="
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
In-Reply-To: <CAHC9VhRFxDuRJHYEuRs7kc4ivgaT=-SxdU-o5Lq7H-O+5JJRxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--===============8053906032647159068==
Content-Type: multipart/alternative; boundary=001a113d4806dbc48b05481c759e

--001a113d4806dbc48b05481c759e
Content-Type: text/plain; charset=UTF-8

On Feb 9, 2017 17:14, "Paul Moore" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:

On Thu, Feb 9, 2017 at 11:02 AM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
wrote:
> From: Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> This patch allows genfscon per-file labeling for cgroupfs. For instance,
> this allows to label the "release_agent" file within each
> cgroup mount and limit writes to it.
>
> Signed-off-by: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  security/selinux/hooks.c | 2 ++
>  1 file changed, 2 insertions(+)

This was already merged ... ?


This is adding cgroup and cgroup2 to the other whitelist (afaict).


* https://marc.info/?l=selinux&m=148652458620202&w=2

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 9a8f12f..5a3138e 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -808,6 +808,8 @@ static int selinux_set_mnt_opts(struct super_block
*sb,
>
>         if (!strcmp(sb->s_type->name, "debugfs") ||
>             !strcmp(sb->s_type->name, "sysfs") ||
> +           !strcmp(sb->s_type->name, "cgroup") ||
> +           !strcmp(sb->s_type->name, "cgroup2") ||
>             !strcmp(sb->s_type->name, "pstore"))
>                 sbsec->flags |= SE_SBGENFS;
>
> --
> 2.9.3

--
paul moore
www.paul-moore.com

--001a113d4806dbc48b05481c759e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><div class=3D"gmail_extra"><br><div class=3D"gma=
il_quote">On Feb 9, 2017 17:14, &quot;Paul Moore&quot; &lt;<a href=3D"mailt=
o:paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org">paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org</a>&gt; wrote:<br type=3D"attrib=
ution"><blockquote class=3D"quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex"><div class=3D"quoted-text">On Thu, Feb 9, 2=
017 at 11:02 AM, Antonio Murdaca &lt;<a href=3D"mailto:amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org"=
>amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org</a>&gt; wrote:<br>
&gt; From: Antonio Murdaca &lt;<a href=3D"mailto:runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org">runcom@=
redhat.com</a>&gt;<br>
&gt;<br>
&gt; This patch allows genfscon per-file labeling for cgroupfs. For instanc=
e,<br>
&gt; this allows to label the &quot;release_agent&quot; file within each<br=
>
&gt; cgroup mount and limit writes to it.<br>
&gt;<br>
&gt; Signed-off-by: Antonio Murdaca &lt;<a href=3D"mailto:amurdaca@redhat.c=
om">amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 security/selinux/hooks.c | 2 ++<br>
&gt;=C2=A0 1 file changed, 2 insertions(+)<br>
<br>
</div>This was already merged ... ?<br></blockquote></div></div></div><div =
dir=3D"auto"><br></div><div dir=3D"auto">This is adding cgroup and cgroup2 =
to the other whitelist (afaict).=C2=A0</div><div dir=3D"auto"><br></div><di=
v dir=3D"auto"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><block=
quote class=3D"quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">
<br>
* <a href=3D"https://marc.info/?l=3Dselinux&amp;m=3D148652458620202&amp;w=
=3D2" rel=3D"noreferrer" target=3D"_blank">https://marc.info/?l=3Dselinux&a=
mp;<wbr>m=3D148652458620202&amp;w=3D2</a><br>
<div class=3D"elided-text"><br>
&gt; diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c<br>
&gt; index 9a8f12f..5a3138e 100644<br>
&gt; --- a/security/selinux/hooks.c<br>
&gt; +++ b/security/selinux/hooks.c<br>
&gt; @@ -808,6 +808,8 @@ static int selinux_set_mnt_opts(struct super_block=
 *sb,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!strcmp(sb-&gt;s_type-&gt;name, &=
quot;debugfs&quot;) ||<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(sb-&gt;s_type-&=
gt;name, &quot;sysfs&quot;) ||<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(sb-&gt;s_type-&gt;na=
me, &quot;cgroup&quot;) ||<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(sb-&gt;s_type-&gt;na=
me, &quot;cgroup2&quot;) ||<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!strcmp(sb-&gt;s_type-&=
gt;name, &quot;pstore&quot;))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sbsec-&gt=
;flags |=3D SE_SBGENFS;<br>
&gt;<br>
&gt; --<br>
&gt; 2.9.3<br>
<br>
</div><font color=3D"#888888">--<br>
paul moore<br>
<a href=3D"http://www.paul-moore.com" rel=3D"noreferrer" target=3D"_blank">=
www.paul-moore.com</a><br>
</font></blockquote></div><br></div></div></div>

--001a113d4806dbc48b05481c759e--

--===============8053906032647159068==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
--===============8053906032647159068==--
