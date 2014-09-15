From: james <wjn740-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How cpu entitlement is calculated/enforce for cpu subgroup?
Date: Mon, 15 Sep 2014 10:46:13 +0800
Message-ID: <541652F5.5010604@gmail.com>
References: <08a001cfd07f$2219bd90$664d38b0$@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        bh=WVLKQigPb+VS2iYYpKKHPfm6qS+9PodqDMItlBubMgk=;
        b=bK1V6UKoNGwuyQ01u+9vtlgs74x7FxHGyKaH5IMaJZ92JmQ46IxXxO1BTW1eg684WC
         qKC4grRpBbKu6TnnLailCRa9ryfMoCRmuY6TMuWIQcr3Otiz40lznDjDHiQlxVVouZTf
         l9RuWLleiOq4iqh5ELzXAQdyH8F2yToyQK6Vc3KDDPHjR/ip9+tNKGNFpNqJOsFBlNTl
         mkwRWPFtnFNX+kyhr6+0yKmarE3NHba6lROYgLNLAEUlsPtctrTpvSwvV/QE706lRuu2
         sR4HAZzTou4I8X16z0oG4jXL6iPn/cJM3DPx/9gLQX7IpxqhXavABBOBqGEmwvsP7FSh
         8jFw==
In-Reply-To: <08a001cfd07f$2219bd90$664d38b0$@gmail.com>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: John Wei <johntwei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'LKML-cgroups' <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

=E5=9C=A8 2014=E5=B9=B409=E6=9C=8815=E6=97=A5 08:51, John Wei =E5=86=99=
=E9=81=93:
> I understand that CPU entitlement is based on cpu.share. If all the g=
roups
> are defined at first level, that is simple.
> Once subgroups are defined, cgroups behave differently.
> If you define cgroups hierarchy, then CPU entitlement is enforced bas=
e on
> the cpu.share of "each" group and subgroup.
> For example:
> * group A has 1024 cpu.share
>    Group A has two subgroup: A1, A2. Each has 1024 cpu.share
> * group B has 1024 cpu.share
> If you run process(es) in group, A, A1, A2, and, B. Each group and su=
bgroups
> get 25% of all the CPU.
>=20
> Below is an example on defining cgroup hierarchy
> Cpu =3D /cgroups/hierarchy
> Cpuacct =3D /cgroup/hierarch
> Memory =3D /cgroup/hierarch
>=20
> If you do not define cgroup hierarchy, then cgroup treat A/A1/A2 as o=
ne
> group and will get 50% CPU, and B will get 50% as well.
> I can understand the reason why it is implemented this way. But, I do=
n't
> understand how cgroup divide that 50%  between A, A1, and A2.
> During my testing, I found A1 and A2 received 10%, while the processe=
s in
> group A received about 30% CPU. All together, processes in A/A1/A2 re=
ceived
> about 50% CPU.
>=20

hi sir,

I'm a nobody.
when there are 2 groups in level 1st (A and B), then A=3D50% and
B=3D50%(because A=3D1024 , B=3D1024 they are same. so they will have th=
e same
priority get cpu time).
and in the subgroup should following above-mentioned rules.(in same lev=
el).

And in this scenario ,when B group no processes,then A group will be 10=
0%.

ok ,this is my point.

welcome any body to correct me.

> What is the formulate for this scenario? Is there a document for this=
=2E
>=20
> John
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
