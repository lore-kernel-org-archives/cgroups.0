From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup: fix var may be used uninitialized warning
Date: Tue, 3 Mar 2015 08:46:42 -0500
Message-ID: <20150303134642.GD3122@htj.duckdns.org>
References: <1425373187-7227-1-git-send-email-javier.martinez@collabora.co.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=y8HDIvTPeer0iKGgAzGOS4wZPlZ791fqH9UsbCFv4nU=;
        b=FOnR95Yiug31YUl8FR0WPATUmU3z2Lwc6T+Fwql2M9+7raI9b277UpuD3Z5PVQm/2X
         0T8G2vQBIGMCZhXxEubhWpGTkSNY91bZ1Zbo2eb8GmqQjNyBz16CsPjuLC2NckP1cBNh
         48gWr6mL2ch5UeZNdeKhjjmAY5WAdYcdqxpFWxEUcSl0CiPXfwJKu8I+t/UpuoXVG5mN
         tvdzNTI08PfabU0/QZ7KuOmiudBpYfk7g2DJKSqqY4fGc2iFusMWhWF6SdQyn9VLWlGg
         lZNlzJzalOf4TfEd2/g4O37DVDT7eGdni6KNAVVfNxAd19AkeYet0Q2oLlAOZ5vswSB3
         2meg==
Content-Disposition: inline
In-Reply-To: <1425373187-7227-1-git-send-email-javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 03, 2015 at 09:59:47AM +0100, Javier Martinez Canillas wrot=
e:
> When building cgroup, GCC warns that the root variable
> may be used uninitialized in the cgroup_mount function.
>=20
> kernel/cgroup.c: In function =E2=80=98cgroup_mount=E2=80=99:
> kernel/cgroup.c:1886:13: warning: =E2=80=98root=E2=80=99 may be used =
uninitialized in this function [-Wuninitialized]
> kernel/cgroup.c:1742:22: note: =E2=80=98root=E2=80=99 was declared he=
re
>=20
> This can never happen because if the struct cgroup_root
> can't be allocated, ret is set to -ENOMEM and the error
> returned so the code using root is not reachable. But
> set root to NULL just to silence the compiler warning.

Which compiler are you on?

Thanks.

--=20
tejun
