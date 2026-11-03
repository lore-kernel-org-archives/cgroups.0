Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793745423;
	b=qqfp+XmMXFrUx/qP879Aru3q8QKZoUc4LGy4YAVO6YjObcoM4TYXsKHiamrASxLHHJ4M
	 oUAuyY4+yYEiJoGs/RuCx9uZbjg2qTdG14jIoOS57hlQ8MUr+O3TOy22zYQ1JuAvLj2Yl
	 alPVg+E1q7Gr9oQcIn4qnCPLxINjvxhcu+8czX2g180sLyEuALLfT56/KqMr5vvQibmOl
	 oLqTmNdC4IpAhjpQynlYiNErMjRE8BZF8zDLeOlXLe9PfvOSzhVC2PgsYMCsyqvKudWmS
	 MUQGngbXrALvKEP5ZSehk8Wl3AIfcdtnipFme+BPq9+SJn2NvtlZq0FPYcq47rKNDdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745423;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=QVC6zXtmTlj5EAbSSjNHwPP18DR41YQR4sifDw97zsg=;
	b=vYBbRzDN0+iyt+h8tSiWSbzQtc5VbxO2Nj6tf1hVWVMEFmmQpcYFXRsnMWS/u/DskR0y
	 NAXeiAtBwUw4iMb4Vw+4rtSc4N5ThPsnmM3o4rSWZpnvmxR4/PIb1d8UTETdmU41HSqWT
	 ZNrCVkx6mUZZfgJX0HaIARj63AzkvGgdCRTB6zy3eX/VoVf5WOE3Sg6zp/2UMTMwwHo2a
	 7bv+yLU1PagwkjTmvG69/ECA3K4PTZYztSdovuQb+Q12dgjbXK95NR75yqhVjkaYv/vNn
	 mtJLZkkp18AkXNWL8ygY2isVHVkYM2W3IkLxCVAjVgdlsO9eF2VdBTS1P4Oiz1gN3iA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k+IVJ6Yn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0175606A324
	for <cgroups@vger.kernel.org>; Tue,  3 Nov 2026 22:37:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0175606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k+IVJ6Yn
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48e0d885929so66282f8f.3
        for <cgroups@vger.kernel.org>; Tue, 03 Nov 2026 14:37:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793745421; cv=none;
        d=google.com; s=arc-20260327;
        b=gBNo5P5Egiv/fBDU/BrjKMKNG2WveAqPklW81eLYbZ6c3rluEg+t6oM3doXnWSvHzA
         dEWmNqaagEBpy6y+VENNZk0xSyzTWJcBvzlHYcipoxUBKd81W2r2v/MX77CVg+pZut7r
         JUe/ch9PiWmgxgwyrnqdLtpY6oe9bZf7x/wij9z4v2HufGKQ9qB3AvHbsD36gKVRAPBi
         qq8e/1EhwLH8wqWXMYr/5e9DlxrLUTohvei0/NB4+V8uX01lem4uzFkL27LE0MzW96Bg
         FlJCredqDLZZXNrxvjp5Gja7U8nEVnXBXQnIO9YQyQJtkSQjwczwEEa7uYHrVfr/oH5x
         CgFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QVC6zXtmTlj5EAbSSjNHwPP18DR41YQR4sifDw97zsg=;
        fh=aYuOUPsjnslOUu1gWFJDXFeRlCScnSvHEwaDwVnS4+w=;
        b=lL0dQfcF9tP06gwM+p8x9u1M6rTp+GcWjz7UZj2CnHbTO45bM/noY9cnIHBACQjBsC
         Ha+mxyhndPr1a2bOBLaTI/10qXAvguBcwHwlFwDNeRcmyaOvHcHNhy/k6jC3zlTVXWc9
         KGoKyXM2fI1g5Mt769/NS0zNLQFcfjrlsuEQtZId1PRufoWzRTExlZpoWwFRoEdjIA/6
         4o7sUQ/8/7FQkHVzNpTs61rynPG5MIx3E95N5bn8xivOaTTFag4NyOb0sAJ+0u/c98M3
         IJSa1KNE3Ve7AsF60fKakr2yhvQ3ZOFGJGqIvdH7Xh/9vWKoqcEv19FwIL+nrORfgJzf
         5qjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793745421; x=1794350221; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QVC6zXtmTlj5EAbSSjNHwPP18DR41YQR4sifDw97zsg=;
        b=k+IVJ6YnlHQ4oETC8hg8FN8dLSl/mrCkkrXIVqeHnm+glTAWmMJEKpV/YCW925HDA1
         7VD/ZHeKp32UwC0RmjSCnLEqAAfIyJbyaAEuO7l2VsoyakRgu/KId01AqiOT3np/wd8W
         zdsCprDH12Olrm+o6hiX6Y7poDhCZboBfCMrSGoWxpEDCqmeDwfBgwtCDwfGX5mdOStc
         X55X31a/hjVTencUpG1ZiG6KXqbxdPkxNDCpCPMPwFe7YRwL6u/tbZ4Pq6eWw3IIrvGL
         od+SmtEJxt1eHRJ1ltwlq/ioIqVrH8UiIjKJ6lXH4hdCy9BmImBUpBRQbMxAV4v9O0y+
         HK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793745421; x=1794350221;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QVC6zXtmTlj5EAbSSjNHwPP18DR41YQR4sifDw97zsg=;
        b=KYO1Ier+7AzvU7HfqSBF/gFBnaTCk2vcv+qlET4OAi2xFlLi+nSQq5RDq0w+NUhobs
         pWyngZHoTSVgDalo4uj3KomhSFY/ruEUeNuqshI/NzOyrbYZtDqImn1JcgZQAl3akZlO
         OrSXqZ/8WqfQ1LtOmJgjVbylSgGTjqWY+mIv1Vv6Xi1LvxiwFyespx1TFpcrDAN5nZH5
         wViDEzvEOOm8mTC4aFmyiSBB8DwhK7NkGpXRChjHXEGK42RVARFQ181eRS9z4ZXdt6Zg
         ilx3q4EbcMQ1SVEEtq6VDWD3ON2Xy64zdaqnnug4T9lluXMc+frdSAh8/rnGJnEYVIU3
         rJtg==
X-Forwarded-Encrypted: i=1; AKwUvBymcb7ImYqOLve3ZBY+m6kVlJD/PlopsGbTN9vyh3m72gdAUjgt01gMe+t6cwuo/O3Fd6i7E8zU@vger.kernel.org
X-Gm-Message-State: APuU4Z/XCUp+/Y4yRRblQOz4d9+HvfftS2wxlfQgdxrg9ndFHjzINDOG
	BCqPLCk4Brna1ZeXR6BLnr43m91xIq1MB3cd+aSVA+gek7DM/Fc5seBlzi1Oub0TYbhxoRWm6CL
	dsUuJooIwqXytomqmylQfpiVt4WyPf6+2UiV+l1w=
X-Gm-Gg: AYBFou0i8X6c//tk1NFiJjMrNghrxlfjgiVIpyLWyS4/s1NpR23qlL4J7NQrZcF6pRR
	CKu5vCMZrtunQQvzogXpGwZI6q1geOmjmPZvkGCft0R+CDV56NkowMg5QAqZ/j69To5odNVYMy7
	0Ofmp4GyvCNb5p8pkXC9ahDBhx7Zcv0SEC7RQ6dkbgkKWFjlfbACBQ/+mtJZcTxyv7qwAK7ECuq
	BGvIL68fiE4pBOc1oDRn1tgc+GvNWPQQIIkwb9XjpA3zyodZ0xGpxXJWI1smhwItm0TgNmzUA6D
	NCNq6ULAsSC0yDT5l0l+/8uB53XdnBShZ1N1649ZMC9lTd99N/27D49ov+yiOKl5fhttwbnBnpo
	I65vjORlWrpemJkc7zHQxBYKRLqSlh9aU3S84eWUVdcEgiJXg7kZcWrsYtP7Uy4cCGFDB+SYb26
	jjlQrauS9hopDKcQGKMQ==
X-Received: by 2002:a05:6000:4027:b0:48d:f3ee:7cc with SMTP id
 ffacd0b85a97d-48e6e4f4cc8mr30979021f8f.30.1793745420854; Tue, 03 Nov 2026
 14:37:00 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
 <20261102225030.2743129-3-joannelkoong@gmail.com> <CAO9r8zP87zRuoFqeKFcAJoCrOG8M+7HCtX6hvxwdLzuHUXD0Gw@mail.gmail.com>
 <CAJnrk1bv-P_TQztAGiHYdfg=5hbj4GREML2M0Uxp5oC1R9J-Mw@mail.gmail.com>
 <CAO9r8zMvofnW-6OsiasiocOBqoRbZuD71dp3RQE5746YGzamNA@mail.gmail.com>
 <CAJnrk1ZAz2ro0-8CC7n8mEjpuRQ64=v0rABtygaw5e2Aohq3=w@mail.gmail.com> <CAO9r8zOa52hMRTXFQVnSWJPmijm+D-97AeZDH-MMK_-rGiSwMA@mail.gmail.com>
In-Reply-To: <CAO9r8zOa52hMRTXFQVnSWJPmijm+D-97AeZDH-MMK_-rGiSwMA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 3 Nov 2026 14:36:47 -0800
X-Gm-Features: AclHuK-AYBaNZSpJUjEtODEKJtvEXTubSyokZTs8vMfIpK79wH5577sQO81jRN4
Message-ID: <CAJnrk1ZZdkrz+WSOFTCmCh0dwTLXcoCOOuufrh2JZMXqGw=Xtw@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm: memcg: read root lruvec LRU stats from the
 node counters
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 11:33=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Nov 3, 2026 at 11:28=E2=80=AFAM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Mon, Nov 2, 2026 at 5:00=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> > >
> > > On Mon, Nov 2, 2026 at 4:34=E2=80=AFPM Joanne Koong <joannelkoong@gma=
il.com> wrote:
> > > >
> > > > On Mon, Nov 2, 2026 at 3:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.or=
g> wrote:
> > > > >
> > > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > > index ac6c43ea8c5a..938843346571 100644
> > > > > > --- a/mm/memcontrol.c
> > > > > > +++ b/mm/memcontrol.c
> > > > > > @@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(cons=
t struct lruvec *lruvec,
> > > > > >         return x;
> > > > > >  }
> > > > > >
> > > > > > +static bool lruvec_is_root(const struct lruvec *lruvec)
> > > > > > +{
> > > > > > +       return !mem_cgroup_disabled() && mem_cgroup_is_root(lru=
vec_memcg(lruvec));
> > > > > > +}
> > > > > > +
> > > > > > +/**
> > > > > > + * lruvec_lru_page_state - read an LRU stat of an lruvec
> > > > > > + * @lruvec: the LRU vector to read from
> > > > > > + * @idx: the node_stat_item to read
> > > > > > + *
> > > > > > + * Like lruvec_page_state(), but for the root memcg the node c=
ounter is read
> > > > > > + * instead. For stats that only track memory charged to a memc=
g (LRU sizes,
> > > > > > + * workingset, rotation and reclaim writeback counts), the roo=
t memcg's
> > > > > > + * hierarchical value equals the node counter. The root memcg =
can just read the
> > > > > > + * node counter directly instead of going through rstat, which=
 requires
> > > > > > + * flushing. Flushing the root memcg flushes every cgroup in t=
he system.
> > > > > > + *
> > > > > > + * Use lruvec_page_state() for other stats (eg slab).
> > > > > > + */
> > > > > > +unsigned long lruvec_lru_page_state(const struct lruvec *lruve=
c,
> > > > > > +                                   enum node_stat_item idx)
> > > > > > +{
> > > > > > +       if (lruvec_is_root(lruvec))
> > > > > > +               return node_page_state(lruvec_pgdat(lruvec), id=
x);
> > > > > > +
> > > > > > +       return lruvec_page_state(lruvec, idx);
> > > > > > +}
> > > > > > +
> > > > > > +/**
> > > > > > + * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() f=
or delta sampling
> > > > > > + * @lruvec: the LRU vector to read from
> > > > > > + * @idx: the node_stat_item to read
> > > > > > + *
> > > > > > + * See lruvec_page_state_monotonic() and lruvec_lru_page_state=
().
> > > > > > + */
> > > > > > +unsigned long lruvec_lru_page_state_monotonic(const struct lru=
vec *lruvec,
> > > > > > +                                             enum node_stat_it=
em idx)
> > > > > > +{
> > > > > > +       if (lruvec_is_root(lruvec))
> > > > > > +               return node_page_state_monotonic(lruvec_pgdat(l=
ruvec), idx);
> > > > > > +
> > > > > > +       return lruvec_page_state_monotonic(lruvec, idx);
> > > > > > +}
> > > > >
> > > > > Why not do this directly in lruvec_page_state() and
> > > > > lruvec_page_state_monotonic()? They already fallback to node stat=
s if
> > > > > memcg is disabled, why not do the same for the root? Are there ca=
ses
> > > > > where the node stats are not the right thing to do?
> > > >
> > > > Hi Yosry,
> > > >
> > > > Thanks for taking a look at this series! I don't think we're able t=
o
> > > > do this directly in lruvec_page_state()/lruvec_page_state_monotonic=
()
> > > > because I think there's still some places where the node stat and t=
he
> > > > root memcg stat are not guaranteed to be equal.
> > > >
> > > > The stat I was looking at last week was slab's NR_SLAB_RECLAIMABLE_=
B
> > > > and NR_SLAB_UNRECLAIMABLE_B where for those, the node counter value
> > > > can contain memory/stats that wasn't actually charged to any memcg,
> > > > which I think means for these cases, the node counter values can be
> > > > larger than what reading the root memcg rstat value would give. The
> > > > functions I was looking at were account_slab() and
> > > > memcg_slab_post_alloc_hook() where the logic adds every new slab pa=
ge
> > > > to the node counter but the memcg stats only get updated if specifi=
c
> > > > criteria are met (eg the cache had SLAB_ACCOUNT set or the allocati=
on
> > > > had the __GFP_ACCOUNT gfp flag set and the allocation was not from =
a
> > > > root memcg).
> > >
> > > If it's only the slab stats, it probably makes sense to special case
> > > those instead of the rest of the readers, right? It would be nice if
> > > the default behavior is reading the node stats that doesn't require a
> > > flush.
> >
> > If we were to special case it, it would need to exclude more than a
> > couple, I think. I asked a LLM and it says NR_KERNEL_STACK_KB,
> > NR_PAGETABLE, NR_SECONDARY_PAGETABLE, NR_VMALLOC, NR_HUGETLB,
> > WORKINGSET_NODERECLAIM would also need to be excluded.
>
> Interesting. So for all these stats, root memcg stats (from
> memory.stat) is not the same as the node stat? They all draw a
> distinction between "accounted to root" vs "not accounted"? I wonder
> if this is intentional for all of them.

I think there's 2 categories:
a) the allocation isn't acccounted to any memcg (eg kernel page
tables, hugetlb when hugetlb accounting is off, unaccounted slab
caches and kmallocs w/out __GFP_ACCOUNT, and most vmalloc). These
values only get added to the node counter

b) the allocation is accounted, but it comes from a task running in
the root cgroup (eg kernel stacks, user + secondary page tables,
accounted slab, etc)

I think a) has to stay as is since it's not linked to any memcg. For
b), it seems intentional from the original commit that added kernel
memory accounting logic (commit 7ae1e1d0f8ac ("memcg: kmem controller
infrastructure")). The commit message for that explicitly says
tracking kernel memory pages to a given memcg "will happen whenever
the caller includes the flag __GFP_KMEMCG flag and the task belongs to
a memcg other than the root". (__GFP_KMEMCG later became
__GFP_ACCOUNT). I wonder though if this was to avoid extra overhead
costs (eg for systems that don't use cgroups) on the hot paths, since
it would need to do non-trivial per-object work. If root read the node
counters for the stats that are in category b (excluding the stats
that are in both category a and b) instead of going through rstat
(which is what this series does for the LRU stats), there wouldn't
need to be any extra overhead at allocation time, since nothing would
need to be tracked.

>
> > We could add
> > this special casing in, but we would need to make sure any new stat
> > that gets added in the future that belongs on the exclusion list gets
> > put on it. If it's missed, the failure would be silent whereas with a
> > separate helper, callers have to explicitly opt in. I'm happy to go
> > either way though, so if there's one way you prefer, I'm happy to do
> > that for v2.
>
> I think we probably want to first understand if these stats are
> supposed to be different between the root memcg stats and the node
> stats first. Personally, I think the default should be the majority
> behavior, which I think is that node stats and root memcg stats are
> the same, so I am leaning toward explicit opt-out. Let's also see what
> memcg folks think.

That seems reasonable to me. memcg folks, do you have any thoughts on this?

Thanks,
Joanne
