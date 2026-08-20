Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FDF44065B
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 22:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787264334; cv=pass; b=lKjwVSxCUwtf4E1GoDvydJfGAH3eOUNw3SWJDEubuql7pUuRTLZnrZtJPjDh+JceF7TBSx2p47E0xLg6oWHcmY3hW180FtqRgJW5pPQtINszG6BF006V2QVy9v14H72NY9EWYvchWRvVDNJCBmYaK9ZF6Ph2Q24OF6hAVwAasZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787264334; c=relaxed/simple;
	bh=oSkyDrqraVAe2Hud5nK9Rzy0thjvyx2+rjUPXdql6mA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M+R+VNk4dfzVXWB5F60rTC1/X48ohVEgfm+v7ZhktcnhuI8G5GmMMhLbMU+czX9b4rnSkTkC9IRSKHet6fJysXLjrwyQBboH9dPm34PhAo9cXFnVfvLvfyst8vscRvFULGwb1EUxcz1cLxgxI3PbsQwHV1lzywEgn1Z8lYwpWEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mha0I2DP; arc=pass smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mha0I2DP"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-499b57cf2f3so1993195e9.0
        for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 15:18:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787264331; cv=none;
        d=google.com; s=arc-20260327;
        b=kJz6UDwY6Xk4g8KlI1iFGeVSxrFwCsO5DfWRRSkwl3rJEaKNWry7gMQBjtD7trkpP6
         rAn7Kx8JsTmweet+TEQymzEoWK2j/69QCbRZFhIqbgDYz/7cE2Jkl69XEUIkMDBVmKlD
         Hd0rV1K4aADy6pIzgCvcPp9Uyk+c9/kK7qt1a+z5oZiJ8Jbi7brXWNYY0TvOYEqSMvpq
         umHw5ogLYtN6W/TM3qKaVDkqik18nmL8r6MdhwgugzKn7Arzame1EFzI74PybwcQdQB6
         8glNcZ+kbHq2+5v7cJClvJ4D7k6pCDJS4FGvGLrAB68d4Yu8QYDTLiiRt4JX5tRbtfMN
         En4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LRxDr2oxggOIQZUgO/T8PDXZcBFh71yZVO25gvl1JMw=;
        fh=94TkXnVCQLDueIPk/39gP+FhWwK8OSXzb+nnfIriCEo=;
        b=dFw2JxLqA3mxTsm1eu0wcZDwn80syfTDfkbX9rjvdCYS+UQbeeL33mlEllu7soZyL3
         nxEqfeOy0Q/IPvWgRQeWDc4uiuzAmqeWukp5f/sQP0JSwOz3UBW80BV8ibvx12DaItX8
         emD2JXjI8MW+NKUFY+vpmHoFpQ+9pkWm1Tz6S8nvwhqtYYMx1R8KinRR5CKZ7h2GWP3M
         vhdnmgaQchSW0y8ejw4CCUvrcazARzGlk8f8UygdjC+OjCRJYsGRq6KVkNq4og70jMeg
         Oa4Vt9j4Yli0gf/zEVyRZa6yQyuaAlVx1W6eC3bBfl6gDthAyeksVdUNPiAgZN2ZUTij
         CQDA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787264331; x=1787869131; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LRxDr2oxggOIQZUgO/T8PDXZcBFh71yZVO25gvl1JMw=;
        b=mha0I2DP5JO7jMDmhYAT91W5haPS0nAbUwMFsLQvo5J30Hc5jOdJ12OD7Py+iTwSxr
         JS4qeeCDkJkBcXMl4BRpg24gkXl+CEtB/Rdv3QUpQlUIP22u9rgm5v9WWnbrzOBuo8p4
         8vFhu+IJ0dgsMjU7YVWXPY083hw7+e6p+4HBUNpGmaH6cPSc9vqQkS6DEgvhHlpsynjy
         tsdVlFdidiW3I0y73Ji1i2pWzeyT6eIJPpRzKf6Jb1MBYdMETmoHeayVzW+u0NIKfxgD
         rOA5PHBx5PITQqLMN6x5b04CS4UNJPaubw0ZC3QWDGq4wVzeQyeeS/eMVhe95vfvPBaO
         JBvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787264331; x=1787869131;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LRxDr2oxggOIQZUgO/T8PDXZcBFh71yZVO25gvl1JMw=;
        b=Weuy9sOW5o0rRRdW2GEDw3eI/pfqdFTlGiUVUCC4SWUhH9jZeXIJ/m0GDaziXfJ0iC
         1SF1sJ1aYIAgy7Pcu2LjsgBNZLalXM17GvEpJnjzwNUkrpUEuO+pbOcFL9E/WGxVYyRz
         PBmCpVrZ/sqf+p9J+a77GYpUha4T/3Is0ElSt8H6f7fe7u/2TXLX4Bu6qHx5doK9FKHs
         8g4CvL71EEFR/X/SnebkNf97c+1cSUlgzE92L3WEXWOoncyS4NUD1Q3cBs3qap/07m5m
         ibEcHdP4DNv0MIU3dWo6Rbci9jZ7msxWsdYUBuBj9U7i0+v74Rgl799bBPFIfenYgXE9
         4tZA==
X-Forwarded-Encrypted: i=1; AHgh+Rpe9JeAYLdCpcAtekU7Dom4XP2hpl+8IDOxJy/aAjyOxvM+6ok5zYhWNJac+4dpTJx4bQoBUXIs@vger.kernel.org
X-Gm-Message-State: AOJu0YyXEfefZMOzLpDLRGgAVupAdmVZL/8+nyFn+zq8PsoulPaIC/Fm
	9IBRxgRC2Pv4wD9xhcNIx5KGO1IK+V8ayxwpYTGFhtZrNxUb8ZSFcgHZ4yR/2qKLKWnmKJ3xgap
	50+K0n6+NSLJpEST3qIhOZunZVXRk/Vo=
X-Gm-Gg: AR+sD13Xm3ei/nF45Z2KcOm7sYdGJ5XsvZiQzVIuS0kgRjv9+lxbRO1vhGEHpRkXUs2
	yHxdaH/n59+hOpWCrqHrBnYm4t+3FEUirpD0vvyQs8QLiCxFMDvv0bHqsmQTQfd+iGEEvgwtyWd
	7flGeyBOuZ58OY/FegMyE6R9dJcYudvH+sUVnZ2D5nxVtsRiFS7WSG+IwIeGxS9rh5+9blomhiV
	FZkcVnGm2XEfctuHN9Ln1Ad5Obs8YOM1hsxEmKnO0Z6xkOz7YfYj1UodnxBmgoD+36fm0xCnnYv
	3fL0/qQoNUdV/3Hnh5XhIyvg1oP/Q35DSweAtchtmdHQRV9CD3rsvLTYibXsvHHYCbjdyV1xfAU
	7Trq5DPj/cGJltbtYbZkn8Hmd
X-Received: by 2002:a05:600c:a49:b0:499:a5cb:b7c0 with SMTP id
 5b1f17b1804b1-499b918220cmr8341265e9.3.1787264330884; Thu, 20 Aug 2026
 15:18:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <1787017182353556.21.seg@mailgw.kylinos.cn>
 <0689d805-45c6-4bb2-8eb2-f065457c45bf@kylinos.cn> <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
In-Reply-To: <CAO9r8zNxnVYpwrsuB1Ofcwf-Lks2e+DL1Ys9CXZ5jozBug_ybQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 20 Aug 2026 15:18:39 -0700
X-Gm-Features: AcwNN1UmS6o7R2p1JRS4hnYVKjw12Bx5uXT5qvOPMj3jePhrevkwxCe1iUpKn9s
Message-ID: <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Song Hu <husong@kylinos.cn>, Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 11:35=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Mon, Aug 17, 2026 at 6:53=E2=80=AFPM Song Hu <husong@kylinos.cn> wrote=
:
> >
> >
> >
> > =E5=9C=A8 2026/8/18 00:04, Shakeel Butt =E5=86=99=E9=81=93:
> > > On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> > >> obj_cgroup_may_zswap() runs on every folio swapped out through
> > >> zswap.  For each ancestor with a non-max zswap.max, it flushes the
> > >> cgroup rstat hierarchy synchronously with force=3Dtrue, which skips
> > >> the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
> > >> with zswap.max configured, a container takes the global rstat lock
> > >> on every swapped-out folio.
> > >
> > > Any reason you are limiting zswap through zswap.max?
> > >
> >
> > Mostly fairness on a shared pool: zswap.max_pool_percent is global
> > only, so on a multi-tenant host one cgroup's cold anonymous memory
> > can soak the pool and crowd out the others.  zswap.max is the only
> > per-cgroup control over that share; memory.max bounds the total
> > footprint, not the share of the pool.
> >
> > >>
> > >> zswap_shrinker_count() had the same pattern and switched to
> > >> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> > >> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
> > >> where the same flush on the shrinker side showed up at 2.88% of
> > >> kernel cycles under osq_lock on a 96-core machine.
> > >>
> > >> Measured on a KVM guest with a swap storm under a cgroup with
> > >> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> > >> before the patch and 198,968 times after, while
> > >> __mem_cgroup_flush_stats() was entered 281,017 times before and
> > >> 80,445 times after.  The removed 200,572 flushes match the store
> > >> attempt count almost exactly; the remainder comes from other stats
> > >> readers in the swap path.
> > >
> > > This is a known issue. Using ratelimited interface also comes with a =
drawback
> > > that the kernel may react on stale information and the consequences m=
ight be
> > > unneeded oom-kills.
> > >
> > > There was orthogonal discussion on moving zswap limit enforcement awa=
y from
> > > rstat. Yosry, any updates on that?
>
> I am not actively looking into that, but Joanne was looking into
> AFAICT. I will respond to the thread there and CC Song as well.
>

For this zswap stat, I ran some benchmarks comparing 4 approaches
(switchable behind a runtime knob [1]):
a) rstat + forced flush       (baseline aka what the tree does today)
b) rstat + ratelimited         (Song's proposal)
c) hierarchical per-CPU   (Yosry's idea from [2])
d) page counters              (following what all the other memcg limits do=
)

For the setup, the benchmark creates a cgroup chain at depth X with
memory.max set to 1G on the leaf and memory.zswap.max set to 512M on
every level, and spins up 20 processes there that each allocate 100
MiB, fault it in, and touch every page four more times. With that 2000
MiB against the 1 GiB memory.max, it triggers reclaim continuously and
makes the swap traffic go through zswap. The machine I ran this on had
80 CPUs.

I also ran it with no memory.zswap.max set (ie no reads triggered,
only update path runs) - as I understand it, this is the configuration
that is more often used in practice.

These are the results I saw:

kernel cpu time (in ns) per zswap store, zswap.max set
                      a)                     b)            c)              =
  d)
depth 1        567,116          35,604     35,841     34,995
depth 2      1,082,007          35,507     37,803     36,209
depth 4      2,153,329          37,591     40,117     39,893
depth 8      4,211,692          34,963     41,070     44,211
depth 32    15,728,220       53,575     94,685     65,946

kernel cpu time (in ns) per zswap store, no zswap.max (update path only):
                        a)                  b)              c)            d=
)
depth 1         34,787          34,062     34,930     35,630
depth 2         34,913          35,061     36,404     36,360
depth 4         36,422          36,809     36,922     37,483
depth 8         42,177          34,440     36,679     40,793
depth 32        55,309          55,321     57,671     59,190

c) and d) are for the most part pretty comparable to b) without
introducing the staleness problem of b). Between c) and d), I think d)
ends up outperforming c) as the # of cpus and depth gets larger.

I'm seeing that all the other memory limits (eg memory.swap.max,
memory.max, etc) are already using page counters. Is there a reason
the zswap stat can't? If not, does it make sense for the zswap stat to
switch over to using page counters?

Thanks,
Joanne

[1] https://github.com/joannekoong/linux/commit/9092e0057f038ffca43ae3f35fa=
f58c33b1d7c9b
[2] https://lore.kernel.org/linux-fsdevel/anpsLy_pCanocgS1@google.com/

> > >
> >
> > Fair point.  The direction I had considered is the benign one -
> > stale low after a burst of stores overshoots admission for a cycle.
> > But after a burst of writebacks the folded value can be stale high
> > too, and premature rejection with zswap.writeback off or swap.max
> > tight ends in a memcg OOM kill that accurate stats would have
> > avoided.  may_zswap() is admission control rather than a hint, so
> > the guarantee matters more here than for the shrinker side
> > of ea80da363a1f.
> >
> > If moving the limit enforcement off rstat is happening, that
> > supersedes this patch and I am happy to drop it.  Otherwise it can
> > serve as a stopgap for the per-folio lock cost - your call, and
> > curious where Yosry's discussion stands.
>
> Not sure how much progress is being made there, but I would really
> like to stop the proliferation of ratelimited flushing, especially in
> this case where it can cause OOM kills.
