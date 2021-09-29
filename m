From: Yunfang Tai <yunfangtai09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG] The usage of memory cgroup is not consistent with processes
 when using THP
Date: Wed, 29 Sep 2021 11:25:59 +0800
Message-ID: <CAHKqYaZj1wB9GU9kWhNTpxJ-2xypxw5_6PzHrS1r=mJ3MQxwOA@mail.gmail.com>
References: <CAHKqYaa7H=M4E-=ObO0ecj+NE2KwZN5d7QSz4_b6tXz2vOo+VA@mail.gmail.com>
 <CAHbLzkpBCQp7UGK_WPJ-akdQ7HqkOEMtE6+9qX5ciu3DU-ZVrg@mail.gmail.com>
 <CAHKqYaZAnz4wiHksKSZMLNEbk9eUUQ1z8iQCLwFgNW40ejByYQ@mail.gmail.com> <CAHbLzkpjRV_32V3AGCsDku8JckeFKvEWd=w2-ZkQ2hbcOAChAA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mJP4XEW0PizZ+gaHwBJ6A7IE4TUjSS7IYV9gb2WrUn8=;
        b=GlTJjNKA9/XgQaTytLcy5VdmpOnq75ilyb1AI+A4KmRNdu9ilA5/NsO5+8D2vjw3TC
         UuJxskcL/h3N6hQxfGgFduD90pMpl8IfA752yrKkjPSDHaJN5Z7bL0j5Nrh+55u5buMS
         dMzG5pHaqsaekJnhQPB59NShFeyZIN81W79A8Gx5sB8K0y2nTgHYDAPpS7Q3akvBnTU0
         oMKWomDnSVs/KXb1tRoI3kSFBSAxuTzrkeRV9vi42Qk/W3Wc+l/mLI5bRrvwbydrs0sz
         Y+o8Hbik/F5DCpEkjh2zlEyYof7WLVevXX95RJBy/6+RSt1beGiQS6fT5/EpOHaV4JUE
         LPNg==
In-Reply-To: <CAHbLzkpjRV_32V3AGCsDku8JckeFKvEWd=w2-ZkQ2hbcOAChAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =E4=BA=8E2021=E5=B9=B49=E6=9C=8829=E6=97=A5=
=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=886:14=E5=86=99=E9=81=93=EF=BC=9A
> I don't quite get what exactly you want to manage. If you want to get
> rid of the disparity, I don't have good idea other than splitting THP
> in place instead of using deferred split. But AFAIK it is not quite
> feasible due to some locking problems.
I get it. Thank you for your reply!
