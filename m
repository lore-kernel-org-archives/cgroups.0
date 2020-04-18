From: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-next test error: BUG: using __this_cpu_read() in
 preemptible code in __mod_memcg_state
Date: Sat, 18 Apr 2020 09:04:38 +0200
Message-ID: <CACT4Y+Zfcs2MxD9-zR748UbkEpsV4BYjFgw1XgSqX4X8z=92CA@mail.gmail.com>
References: <00000000000022640205a04a20d8@google.com> <20200309092423.2ww3aw6yfyce7yty@box>
 <5b1196be-09ce-51f7-f5e7-63f2e597f91e@linux.alibaba.com> <d3fb0593-e483-3b69-bf2c-99ad6cd03567@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=frcRIzvUu/qQayHA5R2SRcLWyTjvWi33DiBNKj+vA2I=;
        b=LcLkUN501e4hh2Vf9DuLPtGQ/JpLMVGYDMR/tyElPI6RiZmLO6U26K0NH2SIUbCdwD
         UVcu1R6soOOc5voW8OC+ZA8WuFhGNjO6IPA0x/m05518n0j2VPVmIXJtEe7E+fZqMwWE
         fx4YB9PiLDHhEJERBLUGTsnnQSdaGzrWo0BBI1LjMg+anW6xdG0gAA9uJJ/Z9Fk4dosS
         mEY9vonmuIvTvndoy8hMKvBA3tzalWOQ+hwdXxX04hABIIonSd14gDSpgC66CHOXeZHa
         R/JRHWU/AmxWLqBjJUYwxf5ccY8uzDNJe9qum4Kx3xhTiaBszPVs02Kn2OLMScr+9MqQ
         ru8Q==
In-Reply-To: <d3fb0593-e483-3b69-bf2c-99ad6cd03567-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, syzbot <syzbot+826543256ed3b8c37f62-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, syzkaller-bugs <syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Mar 9, 2020 at 2:27 PM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
> =E5=9C=A8 2020/3/9 =E4=B8=8B=E5=8D=885:56, Alex Shi =E5=86=99=E9=81=93:
> >
> >
> > =E5=9C=A8 2020/3/9 =E4=B8=8B=E5=8D=885:24, Kirill A. Shutemov =E5=86=99=
=E9=81=93:
> >>> check_preemption_disabled: 3 callbacks suppressed
> >>> BUG: using __this_cpu_read() in preemptible [00000000] code: syz-fuzz=
er/9432
> >>> caller is __mod_memcg_state+0x27/0x1a0 mm/memcontrol.c:689
> >>> CPU: 1 PID: 9432 Comm: syz-fuzzer Not tainted 5.6.0-rc4-next-20200306=
-syzkaller #0
> >>> Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS Google 01/01/2011
> >>> Call Trace:
> >>>  __dump_stack lib/dump_stack.c:77 [inline]
> >>>  dump_stack+0x188/0x20d lib/dump_stack.c:118
> >>>  check_preemption_disabled lib/smp_processor_id.c:47 [inline]
> >>>  __this_cpu_preempt_check.cold+0x84/0x90 lib/smp_processor_id.c:64
> >>>  __mod_memcg_state+0x27/0x1a0 mm/memcontrol.c:689
> >>>  __split_huge_page mm/huge_memory.c:2575 [inline]
> >>>  split_huge_page_to_list+0x124b/0x3380 mm/huge_memory.c:2862
> >>>  split_huge_page include/linux/huge_mm.h:167 [inline]
> >> It looks like a regression due to c8cba0cc2a80 ("mm/thp: narrow lru
> >> locking").
> >
> > yes, I guess so.
>
> Yes, it is a stupid mistake to pull out lock for __mod_memcg_state which
> should be in a lock.
>
> revert this patch should be all fine, since ClearPageCompound and page_re=
f_inc
> later may related with lru_list valid issue in release_pges.
>
>
> Sorry for the disaster!
>
> Alex

+linux-next, Stephen for currently open linux-next build/boot failure

Hi Alex,

What's the status of this? Was the guilty patch reverted? If so,
please mark it as invalid for syzbot, otherwise it still shows up as
open bug.
