From: Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH 00/20] Manual replacement of all strlcpy in favor of strscpy
Date: Tue, 23 Feb 2021 10:31:15 +0100
Message-ID: <CABgxDoLZKbrzghbp09kraEsk0iLzn7B0BEQWmZcdrXwmOu_MKw@mail.gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com> <936bcf5e-2006-7643-7804-9efa318b3e2b@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0000000000002b63e105bbfd9544"
Return-path: <kernel-hardening-return-20812-glkh-kernel-hardening=m.gmane-mx.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <cgroups.vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DVFCa2/tt2H+LD0hRmA62OWnetDkcRuJ237RaPObmX8=;
        b=swbR//PfErd8XhgqzDSvvUK5jzVq9I8ZOx5107KVbKYg6OqJq5hU9Y7+FdR1SBeUja
         XJmX1+I6H5AglonFmbvrr81dNBwM3QnXE4EuG7TJWhIi/6FE1+8He3sEPJbO4INmoKra
         9iOMcrz+CTsosmGPpFBUPjF+flTGoUO7NFRfH/pMaTjMhY28cNzYuNdI2H+2agFc87TG
         NNcg1BKrJzAhg+GQMv7+q2S3lhDlcToJGSD5Pj4TUA/3WGlfjh98Gwmyxaz51z2EFPhd
         TSDFq9glzNWUmQSNEfoHH4rl6gUgulaH0LvJ5akCuSta4YkpTYqMt9yAEiC7zavZGd35
         C9qg==
In-Reply-To: <936bcf5e-2006-7643-7804-9efa318b3e2b@linuxfoundation.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jiri@nvidia.com>, Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mimi Zohar <zohar@linux.ibm.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, "J. Bruce Fields" <bfields@fieldses.org>, Chuck Lever <chuck.lever@oracle.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Jessica Yu <jeyu@kernel.org>, Guenter Roeck <linux@roeck-us.net>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Steffen Maier <maier@linux.ibm.c>

--0000000000002b63e105bbfd9544
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lun. 22 f=C3=A9vr. 2021 =C3=A0 17:36, Shuah Khan <skhan@linuxfoundation.=
org> a
=C3=A9crit :

>
> Cool. A quick check shows me 1031 strscpy() calls with no return
> checks. All or some of these probably need to be reviewed and add
> return checks. Is this something that is in the plan to address as
> part of this work?
>
> thanks,
> -- Shuah
>

Hi,

Initially, what we planned with Kees is to firstly replace all calls with
error handling codes (like this series does),
and then replace all other simple calls (without error handling). However,
we can also start a discussion about this topic, all suggestions are
welcome.

I am not sure that it does make sense to check all returns code in all
cases (for example in arch/alpha/kernel/setup.c, there are a ton of other
examples in the kernel). But a general review (as you suggest), would make
sense.

Regards,
Romain

--0000000000002b63e105bbfd9544
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail=
_attr">Le=C2=A0lun. 22 f=C3=A9vr. 2021 =C3=A0=C2=A017:36, Shuah Khan &lt;<a=
 href=3D"mailto:skhan@linuxfoundation.org">skhan@linuxfoundation.org</a>&gt=
; a =C3=A9crit=C2=A0:<br></div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex"><br>
Cool. A quick check shows me 1031 strscpy() calls with no return<br>
checks. All or some of these probably need to be reviewed and add<br>
return checks. Is this something that is in the plan to address as<br>
part of this work?<br>
<br>
thanks,<br>
-- Shuah<br></blockquote><div><br></div><div>
<div>Hi,</div><div><br></div><div>Initially, what we planned with Kees is t=
o firstly replace all calls with error handling codes (like this series doe=
s),</div><div>and then replace all other simple calls (without error handli=
ng). However, we can also start a discussion about this topic, all suggesti=
ons are welcome.</div><div><br></div><div>I am not sure that it does make s=
ense to check all returns code in all cases (for example in arch/alpha/kern=
el/setup.c, there are a ton of other examples in the kernel). But a general=
 review (as you suggest), would make sense.<br></div><div><br></div><div>Re=
gards,</div><div>Romain<br></div>=C2=A0 <br></div></div></div>

--0000000000002b63e105bbfd9544--
