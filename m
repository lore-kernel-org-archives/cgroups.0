From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 00/21] per lruvec lru_lock for memcg
Date: Thu, 5 Mar 2020 18:15:40 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2003051642580.1190@eggly.anvils>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com> <20200302141202.91d88e8b730b194a8bd8fa7d@linux-foundation.org> <59634b5f-b1b2-3b1d-d845-fd15565fcad4@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1920851028-1583460965=:1190"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=z2MtYmeH2j2KewserLKK2k6VMHRwOlZRf+3/F4kq+Sk=;
        b=PVpkrCMCy0ZsCjsLfnfGd/4xzJJq7apSm7Px0RwrucCbeqa2OpumEJYeZ6x9brHl12
         pNGT2d8lsIo9HbDQ/KWXgZhA4vQmL0Ji856oTphf/TpQPCUL13BWLMdsH9i8+8WQLsyw
         Oz4C8pa9qEtansov8FD965ZXuFygcd6108Mk4pcCpYfdHrvY5rI6XXqrFKLmcMn9hp4q
         4+voMfhA9eqB4fK4n9VoHhYzqKd2gQcE4ccSS1iwp8E4gMb0xaMZB8eA0xAZku9pLSli
         nh/GSl1mvYadLyYx6yGpyq6o4QpfFhPdfHaRNVP1LEPvnCJh/jBtReyX9S1nc0Tg/7tV
         ecMA==
In-Reply-To: <59634b5f-b1b2-3b1d-d845-fd15565fcad4-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Andew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1920851028-1583460965=:1190
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 3 Mar 2020, Alex Shi wrote:
> =E5=9C=A8 2020/3/3 =E4=B8=8A=E5=8D=886:12, Andrew Morton =E5=86=99=E9=81=
=93:
> >> Thanks for Testing support from Intel 0day and Rong Chen, Fengguang Wu=
,
> >> and Yun Wang.
> > I'm not seeing a lot of evidence of review and test activity yet.  But
> > I think I'll grab patches 01-06 as they look like fairly
> > straightforward improvements.
>=20
> cc Fengguang and Rong Chen
>=20
> I did some local functional testing and kselftest, they all look fine.
> 0day only warn me if some case failed. Is it no news is good news? :)

And now the bad news.

Andrew, please revert those six (or seven as they ended up in mmotm).
5.6-rc4-mm1 without them runs my tmpfs+loop+swapping+memcg+ksm kernel
build loads fine (did four hours just now), but 5.6-rc4-mm1 itself
crashed just after starting - seconds or minutes I didn't see,
but it did not complete an iteration.

I thought maybe those six would be harmless (though I've not looked
at them at all); but knew already that the full series is not good yet:
I gave it a try over 5.6-rc4 on Monday, and crashed very soon on simpler
testing, in different ways from what hits mmotm.

The first thing wrong with the full set was when I tried tmpfs+loop+
swapping kernel builds in "mem=3D700M cgroup_disabled=3Dmemory", of course
with CONFIG_DEBUG_LIST=3Dy. That soon collapsed in a splurge of OOM kills
and list_del corruption messages: __list_del_entry_valid < list_del <
__page_cache_release < __put_page < put_page < __try_to_reclaim_swap <
free_swap_and_cache < shmem_free_swap < shmem_undo_range.

When I next tried with "mem=3D1G" and memcg enabled (but not being used),
that managed some iterations, no OOM kills, no list_del warnings (was
it swapping? perhaps, perhaps not, I was trying to go easy on it just
to see if "cgroup_disabled=3Dmemory" had been the problem); but when
rebooting after that, again list_del corruption messages and crash
(I didn't note them down).

So I didn't take much notice of what the mmotm crash backtrace showed
(but IIRC shmem and swap were in it).

Alex, I'm afraid you're focusing too much on performance results,
without doing the basic testing needed - I thought we had given you
some hints on the challenging areas (swapping, move_charge_at_immigrate,
page migration) when we attached a *correctly working* 5.3 version back
on 23rd August:

https://lore.kernel.org/linux-mm/alpine.LSU.2.11.1908231736001.16920@eggly.=
anvils/

(Correctly working, except missing two patches I'd mistakenly dropped
as unnecessary in earlier rebases: but our discussions with Johannes
later showed to be very necessary, though their races rarely seen.)

I have not had the time (and do not expect to have the time) to review
your series: maybe it's one or two small fixes away from being complete,
or maybe it's still fundamentally flawed, I do not know.  I had naively
hoped that you would help with a patchset that worked, rather than
cutting it down into something which does not.

Submitting your series to routine testing is much easier for me than
reviewing it: but then, yes, it's a pity that I don't find the time
to report the results on intervening versions, which also crashed.

What I have to do now, is set aside time today and tomorrow, to package
up the old scripts I use, describe them and their environment, and send
them to you (cc akpm in case I fall under a bus): so that you can
reproduce the crashes for yourself, and get to work on them.

Hugh
--0-1920851028-1583460965=:1190--
