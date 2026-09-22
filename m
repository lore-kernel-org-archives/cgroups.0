Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9501386C9
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 13:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084332; cv=none; b=OH0u3NdUF5UonJzYm5SFQq0D3y+q4Jf1bbg0fg1kznTa3ei61cQK9eNGevaJu/PqJjFq4SWYqpBcX1mLyL7GhXlLk4TDfqxXQpmN3J6VytqHvqJOiOHUHX0XNI+C1nzMgZd9yZD77uWufPWFhFltcikd3WYoxNA85uwXC7k/l08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084332; c=relaxed/simple;
	bh=/a/f7Jh/MiC/swvVwqUhEXfqYE86b5oqe+3Ff4G++VE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fUm7vb5bs03esqjubr2xW5v7cpss4OlVKt/6QDO+13idrxdjTdIzQgRd11gi4twfNX4uqONuWDDEM70UnPExZXAT7xiATusKiDJfM2UwqIAPQb5HIqaacwTY0tMXiLyVnkQjf7lWqy5AYvkOEC4Wi71dTktSdHnZEHAvv8foOk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgHLZOsa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgHLZOsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB10E1F00907
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 13:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790084331;
	bh=/a/f7Jh/MiC/swvVwqUhEXfqYE86b5oqe+3Ff4G++VE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LgHLZOsaiLR6vEnfNUlQTY6oZ9lvgEVB+v1NKXB/7X4n71pwqtLIrApTSiD7ySt7S
	 HyLboP0B3gSKrpbNLp/+DPYLQXPZgIU6Ll1vfcQAusS8E8NtWyerjL6tgSbQgSItT/
	 zOqiJYMTe8O/M9LtX5D3mTo+SOV917k7m6JLtiJck4QLNWTOpao7KN2sUUmA03IqGr
	 a+l8rch10YaCJPB2e0Zzk8f5oorNcgMbz47E0UM68z5IWhrkPjPm4VkhNceNXsDuWw
	 jRcKi6pdnWQteSxiKx3FG7TdgBsDcrhFvBqVKTSnIfBDeWT3iJ6o140rLWVMCCwfju
	 6PSOxO9vrgInA==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aa8d882so4517226d50.0
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 06:38:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByhFIAXUjA5kQCQiT+UzLonxJ+BFueSEN5LZChiygGLAr7ZyVD9R7xMWU73hGYkLZ64pTTTFalz@vger.kernel.org
X-Gm-Message-State: AFuF++lEFhEanV+to9OHKQOD1+yuxv3I7RBqswE2hISKChXi0xwkfo5/
	GSIAazyOqnsUuN92Rl1SpcwmSICQEmQrNzLgdLYSAxOlgRedZhB2PSCJVcXhkUuIGX2dY9RSvh5
	SR9Y6wuMn+rOOP+xZKv1LQv7xy+8Z30mCjdoLxmMI4g==
X-Received: by 2002:a05:690e:a4e:b0:66e:542c:cb48 with SMTP id
 956f58d0204a3-6717fd907d8mr5090744d50.48.1790084330182; Tue, 22 Sep 2026
 06:38:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
In-Reply-To: <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 03:38:38 -1000
X-Gmail-Original-Message-ID: <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
X-Gm-Features: AcwNN1WgbakYkTh0yR3GKDNbi3ffYcCIIuJkVAws7zFs7ymxySYDN4SZgg1CLuk
Message-ID: <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org> wro=
te:
> > No that time slot is too late for Asia developers. I don't think we
> > should use that time slot for swap alignment.
> >
> > We should find a time slot more friendly to Asia.
>
> Any time slot would have that kind of problem. We're spread out across
> the globe.
>
> Let's just use a standardized time slot we have for MM alignment sessions=
.

There are more swap maintainers in Asia than in the US + Europe, at
least based on the maintainer file. Please be more inclusive. If the
alignment is done without key stakeholders, it miss the point.

Sigh, we can't even align on a time slot.

In that case, let's keep discussing on the mailing list. At least it
is accessible to every one.

Chris
