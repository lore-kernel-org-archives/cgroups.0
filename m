From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 10:59:05 -0400
Message-ID: <20160721145905.GC22680@htj.duckdns.org>
References: <20160718161816.13040-1-asarai@suse.de>
 <20160718161816.13040-4-asarai@suse.de>
 <20160720155147.GG4574@htj.duckdns.org>
 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
 <20160720230228.GA19588@mtj.duckdns.org>
 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
 <20160720231949.GB19588@mtj.duckdns.org>
 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
 <20160721143330.GA5751@mail.hallyn.com>
 <1469112709.2331.11.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=V4GOqzI7txrKDw3RnJgz8NwpjTGRGTUFQg6PNbJp5Ns=;
        b=psZQG874diDqKggkqbkoU7Wi1nLSuDnc8rasoPDuuJt7sYNavGJ1LuzvljDbwAg05i
         e7nEEimxM2SVdqLGr3MrUtUX+ABFguU8b+fHa6chmIi1OnLZ7bd4okmXHMzedFyIb1AO
         VxdJ7vzmW/7XT7prUnrB3cgSBegGT7A806xuCkGNrBGLMrVdh0TIQRRWi1zPptvAFBKt
         +LowjdJOjVFbdi78Gan2clZIkmbNRsNjRTMNxhr3O32z+1qdR7sF7wnnDy54UL8FpeQu
         CUxJBKf9HqUG0qMmZysXPVNcRKxPapjZwBv2mqwwxf+wdrtBK5mAwd3Ut/dDXoc0CETd
         /H7A==
Content-Disposition: inline
In-Reply-To: <1469112709.2331.11.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

Hello, James.

On Thu, Jul 21, 2016 at 07:51:49AM -0700, James Bottomley wrote:
> What I haven't really heard yet in the debate is the policy reason wh=
y
> an unprivileged user shouldn't set up their own cgroups as children o=
f
> the current ones (inheriting the constraints).

It's not even about policies.  The interface just can't support
operations like this in a robust way.  We can try to hack enough holes
at it to make some scenarios work but it's all but guaranteed that
such approach is gonna cause painful long-term issues.

> I have heard
>=20
>  * it would give power to move other tasks to more rigid constraints.=
=20
>    =A0To which the answer is only to allow movememnt of tasks in the
>    current cgroupns
>  * It violates the permissions delegation model. =A0This one doesn't
>    really make too much sense to me: in the same way the userns is ro=
ot
>    in its own domain, cgroups ns is effective root for the restricted
>    cgroups (and only for processes within its ns).
>=20
> Perhaps the question should be asked the other way around:  if we wer=
e
> explicitly delegating permission to every user in the system to set u=
p
> their own sub cgroups, how would you advise it be done?

Coordinate in userspace.  Request whatever is managing the cgroup
hierarchy to set up delegation.  It's not like permission model is
fully contained in kernel on modern systems anyway.

Thanks.

--=20
tejun
