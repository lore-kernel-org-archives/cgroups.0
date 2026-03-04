Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C6A347FE2
	for <cgroups@vger.kernel.org>; Wed,  4 Mar 2026 15:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772639223; cv=none; b=hmNpRMbb4D4kpG4/HET5XthxB3NzgfXyyyEjNSSmDLuwqekMezZSUor6Rqxf8p3UYY369RY0qmuejmUmynWvXyd0jCVoM/puKJqwzQJNVbZ4bMW4jkbkgoNSTdZWs3lFsjslhEMjcXknig3D+Az/lzA+EonJq6M41AdybGP6ffM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772639223; c=relaxed/simple;
	bh=wQB8bgrb1VKKNUOrGalau2vuiEG8//rIFR/dkf6y4lg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zjr2wfqwLGXgmig/4Z7iowX8Bmg8BS6A2jkU62jdMYvXQvFyK8yZum2zXEGXDkv/U3zvQjnFU/W3EIgnpU9Zc0kfvN/rH1BGV1BFSa7ttLUyH5Q8XN/GbEbkQ1ruFrvoXNfCN1LxzLNNb9CLcKcm0hIk1M08aDlncO6TH1WTCzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JfJRwkdN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JfJRwkdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12D0C2BCB7
	for <cgroups@vger.kernel.org>; Wed,  4 Mar 2026 15:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772639222;
	bh=wQB8bgrb1VKKNUOrGalau2vuiEG8//rIFR/dkf6y4lg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JfJRwkdN7Yyws2qaxhR83xOmMfY62C4yRpDsHo5ATw+aJUlLtgEsD8hh5AcnQX29m
	 9hAWoJ96WGutkccfvNDGa5C89SZYkS/TZkczp7N2t9yFnFjnE3gznTm8dcpEo790hy
	 t5KU8QXyP9Pff4Qy7xQKiwnt6tfgXL/GSb3BPaqj9kLnB8yCknBhQvog2JTObrVhyU
	 QASiZikH0OljPget0q1NCyQbbx6lquHQHFLgtdPL6ssZk2Ci1PDFOf+EBiQf3bRcgs
	 EJk77cetBhpWjg1mNsDuZMFgznviPRmOPDdogYyRgBEnEqEaSnuimeBJeV8VlAz69H
	 k9sKNc5DtDm+Q==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b936b85cc71so853527066b.2
        for <cgroups@vger.kernel.org>; Wed, 04 Mar 2026 07:47:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVvCpDCQEnCe/kc/cK/JGVGYukrYjVFDwHX6w1aNsj6XWlE/a1EKbMbhiE46FOAz2aAqVwP0w/3@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1o2XUAloxDNF8vW5dyllP7hCKVJeLexa1I3+BKSJKBBFqM9GD
	96CTF4clj70dCwtTUUbnP7xmu/7woaNdlEMBOahW6vfAyU0h1P3srFjNXF/1Y5KRHHbOQIp0UJW
	IEr4CzfQtSYoSz1ReuVyPyut7RZ9pxv4=
X-Received: by 2002:a17:906:c107:b0:b8e:3957:f0d5 with SMTP id
 a640c23a62f3a-b93f11c0672mr144872766b.25.1772639221431; Wed, 04 Mar 2026
 07:47:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAO9r8zOFS7zU-eGkErcjud=DW0t00_WqNqCzq_QDf061dOsYSQ@mail.gmail.com>
 <20260304151120.3512645-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260304151120.3512645-1-joshua.hahnjy@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 4 Mar 2026 07:46:48 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOJ5bkJzptM7+8V2G00dHuycAEAF4CDcaR1YMk0kWyktA@mail.gmail.com>
X-Gm-Features: AaiRm53P3i4SVo8LADo-vaxVmK5DA7F_E32YhxfCaFssztR0PiWkABtHUAkCC0I
Message-ID: <CAO9r8zOJ5bkJzptM7+8V2G00dHuycAEAF4CDcaR1YMk0kWyktA@mail.gmail.com>
Subject: Re: [PATCH 6/8] mm/zsmalloc, zswap: Handle objcg charging and
 lifetime in zsmalloc
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 4, 2026 at 7:11=E2=80=AFAM Joshua Hahn <joshua.hahnjy@gmail.com=
> wrote:
>
> On Tue, 3 Mar 2026 15:53:31 -0800 Yosry Ahmed <yosry@kernel.org> wrote:
>
> > > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > > index 067215a6ddcc..88c7cd399261 100644
> > > --- a/mm/zsmalloc.c
> > > +++ b/mm/zsmalloc.c
> > > @@ -963,6 +963,44 @@ static bool alloc_zspage_objcgs(struct size_clas=
s *class, gfp_t gfp,
> > >         return true;
> > >  }
> > >
> > > +static void zs_charge_objcg(struct zpdesc *zpdesc, struct obj_cgroup=
 *objcg,
> > > +                           int size, unsigned long offset)
> > > +{
> > > +       struct mem_cgroup *memcg;
> > > +
> > > +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > > +               return;
> > > +
> > > +       VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> > > +
> > > +       /* PF_MEMALLOC context, charging must succeed */
> > > +       if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> > > +               VM_WARN_ON_ONCE(1);
> > > +
> > > +       rcu_read_lock();
> > > +       memcg =3D obj_cgroup_memcg(objcg);
> > > +       mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> > > +       mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
>
> Hello Yosry, I hope you are doing well!
> Thank you for your feedback : -)
>
> > Zsmalloc should not be updating zswap stats (e.g. in case zram starts
> > supporting memcg charging).  How about moving the stat updates to
> > zswap?
>
> Yeah... I think this was also a big point of concern for me. While readin=
g
> the code, I was really amazed by how clean the logical divide between
> zsmalloc and zswap / zram were, and I wanted to preserve it as much as
> possible.
>
> There are a few problems, though. Probably the biggest is that migration
> of zpdescs and compressed objects within them are invisible to zswap.
> Of course, this is by design, but this leads to two problems.
>
> zswap's ignorance of compressed objects' movements across physical nodes
> makes it impossible to accurately charge and uncharge from the correct
> memcg-lruvec.
>
> Conversely, zsmalloc's ignorance of memcg association makes it impossible
> to correctly restrict cpusets.mems during migration.
>
> So the clean logical divide makes a lot of sense for separating the
> high-level cgroup association, compression, etc. from the physical
> location of the memory and migration / zpdesc compaction, but it would
> appear that this comes at a cost of oversimplifying the logic and missing
> out on accurate memory charging and a unified source of truth for the
> counters.
>
> The last thing I wanted to note was that I agree that zsmalloc doing
> explicit zswap stat updates feels a bit awkward. The reason I chose to do
> this right now is because when enlightening zsmalloc about the compressed
> objs' objcgs, zswap is the only one that does this memory accounting.
> So having an objcg is a bit of a proxy to understand that the consumer
> is zswap (as opposed to zram). Of course, if zram starts to do memcg
> accounting as well, we'll have to start doing some other checks to
> see if the compresed object should be accounted as zram or zswap.
>
> OK. That's all the defense I have for my design : -) Now for thinking
> about other designs:
>
> I also explored whether it makes sense to make zsmalloc call a hook into
> zswap code during and after migrations. The problem is that there isn't
> a good way to do the compressed object --> zswap entry lookup, and this
> still doesn't solve the issue of zsmalloc migrating compressed objects
> without checking whether that object can live on another node.
>
> Maybe one possible approach is to turn the array of objcgs into an array
> of backpointers from compressed objects to their corresponding zswap_entr=
ies?
> One concern is that this does add 8 bytes of additional overhead per
> zswap entry, and I'm not sure that this is acceptable. I'll keep thinking
> on whether there's a creative way to save some memory here, though...
>
> Of course the other concern is what this will look like for zram users.
> I guess it can be done similarly to what is done here, and only allocate
> the array of pointers when called in from zswap.
>
> Anyways, thank you for bringing this up. What do you think about the
> options we have here? I hope that I've motivated why we want
> per-memcg-lruvec accounting as well. Please let me know if there is anyth=
ing
> I can provide additional context for : -)

Thanks for the detailed elaboration.

AFAICT the only zswap-specific part is the actual stat indexes, what
if these are parameterized at the zsmalloc pool level? AFAICT zswap
and zram will never share a pool.
