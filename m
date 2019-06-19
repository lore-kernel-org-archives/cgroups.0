From: Shakeel Butt <shakeelb@google.com>
Subject: Re: memcg/kmem panics
Date: Wed, 19 Jun 2019 16:04:28 -0700
Message-ID: <CALvZod6Bfbi57mRmbYetO+R=gB07kkewo=F9sTyMdWpDXGgwDg@mail.gmail.com>
References: <e5cfe17c-a59f-b1d1-19ce-590245106068@intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NbzMOyrZckNlP/Lcg+Lm/vM3zrC2t8DPpb83xlh9FiI=;
        b=t5CyOJNfaac+Q7sPzpACyPTDx6EHsMBAXAnNFHc1O5tDZWecDaCzf1vYTuyz7Zjf/e
         67AVLo3wFwFhYh4mwpzgD+9UNuTSphgseGd0AVOtn7iOtYOElLcQ3s+WX4gwDSQUJSAG
         kHzUBPWbM3Dmo4KyNNeKLuRTTau5zxBm1pYUE8IUgg96i3/B0ojjp1aZCvK8b5YvIrRq
         3y/D3kCzgimUMVAjolJtiirGA8S5lSRCCmJdB1ggTynoPqquMl1gDOrFf2Hao69SK3nD
         qqRIODa4r7NbdVpNTrP+mSFxZxA2I3Lap/PkRe7pPMQAA9C50Yxp8L3JthprklpEeTg/
         Qmtw==
In-Reply-To: <e5cfe17c-a59f-b1d1-19ce-590245106068@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Hansen <dave.hansen@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>

On Wed, Jun 19, 2019 at 3:50 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> I have a bit of a grievance to file.  :)
>
> I'm seeing "Cannot create slab..." panic()s coming from
> kmem_cache_open() when trying to create memory cgroups on a Fedora
> system running 5.2-rc's.  The panic()s happen when failing to create
> memcg-specific slabs because the memcg code passes through the
> root_cache->flags, which can include SLAB_PANIC.
>
> I haven't tracked down the root cause yet, or where this behavior
> started.  But, the end-user experience is that systemd tries to create a
> cgroup and ends up with a kernel panic.  That's rather sad, especially
> for the poor sod that's trying to debug it.
>
> Should memcg_create_kmem_cache() be, perhaps filtering out SLAB_PANIC
> from root_cache->flags, for instance?  That might make the system a bit
> less likely to turn into a doorstop if and when something goes mildly
> wrong.  I've hacked out the panic()s and the system actually seems to
> boot OK.

You must be using CONFIG_SLUB and I see that in kmem_cache_open() in
SLUB doing a SLAB_PANIC check. I think we should remove that
altogether from SLUB as SLAB does not do this and failure in memcg
kmem cache creation can and should be handled gracefully. I can send a
patch to remove that check.

Shakeel
