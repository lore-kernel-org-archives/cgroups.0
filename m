Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C658472530
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 05:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791869224; cv=none; b=IGIBuHOxVqNZGJY6+c1wKHaTOOr0YXy35jRmRb+PnoNpyOUtlurIkaw7hncN10ioe/6jQCJdPlC6UHTPW3oQ6blWOvKtiDwf9CmFJCAhS6ZFN57/doElnFzBOmtCecGuugs9+oNdxGeX7N5MRLrdOEg5NHkHWRmawGCfteIaxVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791869224; c=relaxed/simple;
	bh=hjt7WdqvBS+sKPOEWx62yXCoipEnUvIuBL1q83yUbyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y0Z15dua9NcgZdtIESgKDgSEfa02dlQMGtjac62lXXUtw9FlOlr90WHbfxSMRASE+jzLc0pwrm2jKCDJ6bpFDxguyz9btAoCDLyjrITE4yRA1NUiBvAEDa2ZPjT9p9UepN4mx0xHiHisBCeTM2tCFb66uzIKWr9crG5DbuSe3Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+NCQmjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+NCQmjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD721F00893
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 05:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791869222;
	bh=hjt7WdqvBS+sKPOEWx62yXCoipEnUvIuBL1q83yUbyo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=n+NCQmjWoXbOOZxAomCytsmbb3aASwIZLPL3YVbo8rDWFRajKdOYFtX9TTerL1mmg
	 CK4m51usMzr5qm17bBqE5xYBOCZKpmVMEFrxfk+WlMC4OSlAJ9rVNclUE6x/BTvkkK
	 054SeUaZ1Pg9UMuOw8h0BM6Biq7qSuYcatAAJnuD91PfgmklFOUDcfL0vnXU6NzYIA
	 o6JNU89q3wedXxDRA4m0ldetoqhCmvucflGiledMqA0w368d1gbIdzjiEhkaxBbanw
	 HYMFffm2IG01aoR1Uk31n7rQzrTBciGsschJMz531fPAoTmUkPi9VpW3z8VLduW/rn
	 LVHtxVMN6lcHg==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c247f6687dcso381604966b.2
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 22:27:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByaIyl/RprvSdkHKWENkWMD1wfI6biOSP8LvP3jv6+4h5lnmp/C5HZ1wtTuUr493OMB7HPi2w6u@vger.kernel.org
X-Gm-Message-State: AFq9FYKHsdH70WDDEOOoNxUg9EPmJsDlGJTYZpMkMHygVKjUxvg+LgXl
	kpVXlh2fUZ19BoXRN3RDNQd4Wc7KIPBWQcYzDYMY1RcWq1V953v/7y//W3tj9uQBjxJZV02+81P
	T3aP1UzVr+N7EZ8SOTunSdlt9dkYIfq7qMRnGW86Vsw==
X-Received: by 2002:a17:906:630c:b0:c2e:4601:24d7 with SMTP id
 a640c23a62f3a-c31aa0b038fmr1163593566b.39.1791869221297; Mon, 12 Oct 2026
 22:27:01 -0700 (PDT)
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
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com> <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
In-Reply-To: <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 12 Oct 2026 22:26:49 -0700
X-Gmail-Original-Message-ID: <CACePvbVTnCOh51jvEpkDJ32idvCubgN1eHBps6vESjhVC8E_aQ@mail.gmail.com>
X-Gm-Features: AclHuK_DfQCPO4j2m10REoB4qF9zAuO9SjVMLTAFlHAeodT0hj3mwVtXkmxRAyo
Message-ID: <CACePvbVTnCOh51jvEpkDJ32idvCubgN1eHBps6vESjhVC8E_aQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <ryncsn@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
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

On Mon, Oct 5, 2026 at 5:19=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 9/22/26 15:38, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> >>
> >> On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org> =
wrote:
> >>> No that time slot is too late for Asia developers. I don't think we
> >>> should use that time slot for swap alignment.
> >>>
> >>> We should find a time slot more friendly to Asia.
> >>
> >> Any time slot would have that kind of problem. We're spread out across
> >> the globe.
> >>
> >> Let's just use a standardized time slot we have for MM alignment sessi=
ons.
> >
> > There are more swap maintainers in Asia than in the US + Europe, at
> > least based on the maintainer file. Please be more inclusive. If the
> > alignment is done without key stakeholders, it miss the point.
> >
> > Sigh, we can't even align on a time slot.
> >
> > In that case, let's keep discussing on the mailing list. At least it
> > is accessible to every one.
>
> Looking at the mailing list, that approach doesn't seem to work.
>
> Finding a time slot that makes US, Europe and Asia happy is ... tricky.
>
> 1 AM is certainly unpleasant.
>
> US vs. Asia is also tricky, but doable.
>
> China 8AM vs. US West Coast 5PM?
>
> China 9AM vs. US West Coast 6PM?

Hi David,

Thanks for organizing this. Time slot that works for Baoquan and
Kairui should also work for me.

Hi Kairui,

I understand that you have some face-to-face discussions at the
conference. Do we have a list of what has been aligned and what is
pending to discuss? We should have an agenda to avoid repeating
already aligned items.

Chris
