From: Markus Elfring <Markus.Elfring-S0/GAf8tV78@public.gmane.org>
Subject: Re: [PATCH] blkcg: Fix memory leak in blkg_conf_prep()
Date: Fri, 15 May 2020 17:08:24 +0200
Message-ID: <4c670a6c-98c3-2b14-7438-09199506d92f@web.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1589555313;
        bh=2Az8NnR7wJ9rN2x9fHizGYiaHCVrPmmewTwIZIfBU5s=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=ZXqvivJYAuG2fJlojZrSHhjwQJMqWniMoTMe+0INKTTnV58dM4Xixiq/5QBWDZMyb
         UuWu3I3Hwznw0mN1iaJ/pKKdSzfPsgGXwiZOvQzrM7OyVnVACMjAFuS87gZditjEN+
         qdVQ4/JD85kb8t11+KIeFoDLzVGDucar4JRBeb2A=
Content-Language: en-GB
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Wu Bo <wubo40-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feilong Lin <linfeilong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhiqiang Liu <liuzhiqiang26-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

=E2=80=A6
> new_blkg =3D blkg_alloc(pos, q, GFP_KERNEL);
=E2=80=A6

I suggest to omit the source code quotation from the change description.


> if calling blkg_lookup_check() failed, at the IS_ERR block,
> the new_blkg should be free before goto lable fail_unlock
> in blkg_conf_prep() function.

How do you think about a wording variant like the following?

  If a call of the function =E2=80=9Cblkg_lookup_check=E2=80=9D failed,
  release the previously allocated block group before jumping
  to the target =E2=80=9Cfail_unlock=E2=80=9D in the implementation of
  the function =E2=80=9Cblkg_conf_prep=E2=80=9D.


Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the commit messag=
e?

Regards,
Markus
