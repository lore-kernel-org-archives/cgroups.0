From: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] security: selinux: allow per-file labeling for cgroupfs
Date: Thu, 9 Feb 2017 23:32:09 +0100
Message-ID: <CALKLTGTjpBYd5-M9RiO-Q4H_SokEiPJYptbxktg_aPccws59Jw@mail.gmail.com>
References: <20170209160242.23405-1-amurdaca@redhat.com>
 <CAHC9VhRFxDuRJHYEuRs7kc4ivgaT=-SxdU-o5Lq7H-O+5JJRxQ@mail.gmail.com>
 <CALKLTGTc7U7ohxd44MHOuzVomW-oUsumqUqr0MKaUohw1NpSsg@mail.gmail.com>
 <CAHC9VhSj4ztDZwxfcuugaD5-OJrBVaJ=TQS=t4=jfL0+ZdbdYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8071638267089862951=="
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
In-Reply-To: <CAHC9VhSj4ztDZwxfcuugaD5-OJrBVaJ=TQS=t4=jfL0+ZdbdYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--===============8071638267089862951==
Content-Type: multipart/alternative; boundary=001a113ddd2e4d95680548208da5

--001a113ddd2e4d95680548208da5
Content-Type: text/plain; charset=UTF-8

On Feb 9, 2017 20:23, "Paul Moore" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:

On Thu, Feb 9, 2017 at 12:39 PM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
wrote:
> On Feb 9, 2017 17:14, "Paul Moore" <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org> wrote:
> On Thu, Feb 9, 2017 at 11:02 AM, Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
>> From: Antonio Murdaca <runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> This patch allows genfscon per-file labeling for cgroupfs. For instance,
>> this allows to label the "release_agent" file within each
>> cgroup mount and limit writes to it.
>>
>> Signed-off-by: Antonio Murdaca <amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  security/selinux/hooks.c | 2 ++
>>  1 file changed, 2 insertions(+)
>
> This was already merged ... ?
>
>
> This is adding cgroup and cgroup2 to the other whitelist (afaict).

Yes, my apologies, I read this patch too quickly and confused it with
the previous cgroups patch.

Just to set expectations, this patch is too late for the upcoming
merge window, we can consider it in a few weeks once the merge window
has closed.  This should give you some time to do some further testing
(hint, hint).


Sure, I'm going to test this and add tests in selinux-testsuite as well


--
paul moore
www.paul-moore.com

--001a113ddd2e4d95680548208da5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><div class=3D"gmail_extra"><br><div class=3D"gma=
il_quote">On Feb 9, 2017 20:23, &quot;Paul Moore&quot; &lt;<a href=3D"mailt=
o:paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org">paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org</a>&gt; wrote:<br type=3D"attrib=
ution"><blockquote class=3D"quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex"><div class=3D"quoted-text">On Thu, Feb 9, 2=
017 at 12:39 PM, Antonio Murdaca &lt;<a href=3D"mailto:amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org"=
>amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org</a>&gt; wrote:<br>
&gt; On Feb 9, 2017 17:14, &quot;Paul Moore&quot; &lt;<a href=3D"mailto:pau=
l@paul-moore.com">paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org</a>&gt; wrote:<br>
&gt; On Thu, Feb 9, 2017 at 11:02 AM, Antonio Murdaca &lt;<a href=3D"mailto=
:amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org">amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org</a>&gt;<br>
&gt; wrote:<br>
&gt;&gt; From: Antonio Murdaca &lt;<a href=3D"mailto:runcom-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org">run=
com-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org</a>&gt;<br>
&gt;&gt;<br>
&gt;&gt; This patch allows genfscon per-file labeling for cgroupfs. For ins=
tance,<br>
&gt;&gt; this allows to label the &quot;release_agent&quot; file within eac=
h<br>
&gt;&gt; cgroup mount and limit writes to it.<br>
&gt;&gt;<br>
&gt;&gt; Signed-off-by: Antonio Murdaca &lt;<a href=3D"mailto:amurdaca@redh=
at.com">amurdaca-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org</a>&gt;<br>
&gt;&gt; ---<br>
&gt;&gt;=C2=A0 security/selinux/hooks.c | 2 ++<br>
&gt;&gt;=C2=A0 1 file changed, 2 insertions(+)<br>
&gt;<br>
&gt; This was already merged ... ?<br>
&gt;<br>
&gt;<br>
&gt; This is adding cgroup and cgroup2 to the other whitelist (afaict).<br>
<br>
</div>Yes, my apologies, I read this patch too quickly and confused it with=
<br>
the previous cgroups patch.<br>
<br>
Just to set expectations, this patch is too late for the upcoming<br>
merge window, we can consider it in a few weeks once the merge window<br>
has closed.=C2=A0 This should give you some time to do some further testing=
<br>
(hint, hint).<br></blockquote></div></div></div><div dir=3D"auto"><br></div=
><div dir=3D"auto">Sure, I&#39;m going to test this and add tests in selinu=
x-testsuite as well</div><div dir=3D"auto"><br></div><div dir=3D"auto"><div=
 class=3D"gmail_extra"><div class=3D"gmail_quote"><blockquote class=3D"quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<font color=3D"#888888"><br>
--<br>
paul moore<br>
<a href=3D"http://www.paul-moore.com" rel=3D"noreferrer" target=3D"_blank">=
www.paul-moore.com</a><br>
</font></blockquote></div><br></div></div></div>

--001a113ddd2e4d95680548208da5--

--===============8071638267089862951==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
--===============8071638267089862951==--
