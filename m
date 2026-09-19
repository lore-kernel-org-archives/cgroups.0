Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F042C21DF
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 21:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789852932; cv=none; b=dYmbw4GTm0D32OFgFmxGhNPWVeUk5N2ekO2a1uMR9PYyd6uX2vicxtbzKbcLWfw5K0IS9/3nnVSHh6/KHTcwFuJ/o3RiXt7dlPLXaLlQAn24tOghflDvh4POXbm8bDJ+HUEqbZNugBY5atcw4IJLt2Uq4i1gowH8/F2DJSswLZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789852932; c=relaxed/simple;
	bh=9KE5aURhmFeQqffPNpopHGYL3hq2scKvdY2jkmvGLyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EfnCFN9oRneP8lqYbtpUUWR+tOfDHSR1LmGl3AzMfhbUeX9sGoukTW+YYZ0lilnyQ0Iv9na7YwU02C3PomN2bESDacgetJh9wDVUMvjgPf6+r3FpZms2/LODuwEtetS8Njx1Nm/OQLskVq78syxgku4vn5mBW1kPL0Hx5pX0GNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvxvYiL3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvxvYiL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC181F000FF
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 21:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789852931;
	bh=9KE5aURhmFeQqffPNpopHGYL3hq2scKvdY2jkmvGLyo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dvxvYiL3h4r8ovEqY5Mh4f6NhdN7+bguAVTX4+urpf3GoZamkP+ErBEtKFU4bHQmN
	 H68Wtp6494+yz30jy/m5d/RagA2pKfWwJkhqA7emGBXMdCN2ZrErMQhbcwngaZpAE5
	 Q8vwzHr8pmXA7IIVBZXC/U05n4OxzxVbxq/4AEBYKJcGv21tMp4NC7VWPsAkM2DZQ4
	 nRU+TKvcRokByfRcQddCmKVnGVAxA2MPHZnugbTe2PQjpV/u1CNfDmFUJfe8stKdW+
	 Dewl9VykVXDI6pXLrW5sA7fWZVAW7SMzPc22GVHslUWFFbF0bCks4NqF+9nAStVy18
	 qmCnUcgEbkYhw==
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-85d43daa8f4so12284347b3.3
        for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 14:22:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwlW7DFdTEHfWya51zmdMVI5rOzAcGZ/i0hh06Em0wcqIZLFa3XABYdwBA02bAAJNyzhx4X/tOb@vger.kernel.org
X-Gm-Message-State: AFuF++nacxmgKfx3c9ng/+7Jd2AkEg9ShTKM1Ljr8JiLrzs6UtYZE/w9
	bGNJ0P4rxY5gHdu4D9Zzkr7gjkYsdksZGwlAjfA4NbxZskyJVAcX0ZFYdQTdfSvhj4V1gHmw7vH
	A39N8LV6+1/FT2QKOQ4Q1EdeiFHOpn8N0ybhU1hSHCQ==
X-Received: by 2002:a05:690e:4888:10b0:66f:c1bc:87ef with SMTP id
 956f58d0204a3-6717fde9f96mr1259997d50.72.1789852930667; Sat, 19 Sep 2026
 14:22:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev> <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com> <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
In-Reply-To: <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 19 Sep 2026 11:21:59 -1000
X-Gmail-Original-Message-ID: <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
X-Gm-Features: AcwNN1V3fN8BiarqwCTVlFEX0OtGz4WToCWoAzNrsMF1T-3gjKneuvYzb3JnUKQ
Message-ID: <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 19, 2026 at 6:16=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Sat, 2026-09-19 at 01:55 -0500, Chris Li wrote:
> >
> > We don't have to address all issues in one series. I actually advise
> > against lump too many patches into one series.
> >
> There are two things here.
>
> I totally agree that we can merge things piecemeal,
> and not aim for perfection at the start.

Agree.

> However, I believe we do need to take care that
> whatever design we go with is actually able to
> support the end user functionality we want.

Agree. I want to add that we should support new functionality without
sacrificing existing user functionality.

> We have to make sure that the path we pick does
> allow us to very easily add the user visible
> functionality that people need.

Agree.

> We can always swap out technical details behind
> the scenes later, but user interfaces are supposed
> to be stable.

I think we agree on all aspects.

Chris
