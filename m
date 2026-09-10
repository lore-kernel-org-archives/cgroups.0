Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F14F4DA548
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 16:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789057387; cv=pass; b=YeqAJC1XOvjck3QuSH8HbRoTXGefASjnhWrsM4RzgLg/hT7oWFfSxOijk13pWQpw7VrkjH7jscLtRj8shFd3L6biBUaX/vuzeRcgk931VWbBBasRnBMA0FJHSpnel+YA/+TdDvzoy4LZQ1CDMzlbPxzk+NJ0r9ve0PP9UBrGlok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789057387; c=relaxed/simple;
	bh=nEAGONInB8tJpm1u2lIKx48IXnht0iSXDghcmCqPigk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lqWFUrolOOYarBs3p0xsTY+v7kSlNjO6bps+NgklYoPWMHBojES2EB3/jGM7D5W2vWPzs8HkB3+mTJJ+GI0/qZ9sMwavUZoi4Oio+lnDc2gxnZ+IpoI3LPaVaTjDzV3pbo/fA6Rzwd41j7LZFq3B7WBjg1279zD4GsvnkXiyTHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QWb84oUu; arc=pass smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QWb84oUu"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-482e257a23aso4849850f8f.0
        for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 09:23:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789057383; cv=none;
        d=google.com; s=arc-20260327;
        b=ESQrKBABwHEmQcc1yPc88x5IPwN0DveYVsescXlf8YbSl4PKT7iUJmzmnQJeSZtVd1
         zaJxCxpCPPH15HdwpVMT1iSFhT7iC7s1j2b3/yt4BAixiCcOZLxlfLyB68rXTgb6MGIJ
         2XyuYPMNfY1Z0mjkesjiEHp87ZxZ3X2pzeXO0qefyYOqmt4bk6ARcg65hoWhJMPB5iFa
         hjk56tNSwmZYGsZiQQjsDzZZ3HhSWi3wdq5dLzrgHq6YJ5Vdow98gSXlo+g5vdNw87w2
         HFlQ+WziXJ3jGp0wCwriQylsKl36FMy6qWyUL5ypjNjk3B7xmDHwvdYCVwVSC4AlAbdS
         8/Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nEAGONInB8tJpm1u2lIKx48IXnht0iSXDghcmCqPigk=;
        fh=FZ6BEcTQbkOwHDrmRWlckfIvIVqj5n6l1laiHZuPR6g=;
        b=dHHI7kAojjgSB8/8YTUuDmZDS4Pl4vUuolUHdtxSKKm6J+2FSV5JfkFLIbjwowrUxm
         XODg+haOkm6UawP3x8LIKNoR9+jAgf+Ru+WoaV+reQRobHQp4rxQe6vK/S0joKASGJmc
         mEh5xb2jPBiex0LXQ/ZuvfBl5ikRNxTwfNEKeV/G6zhRh+L8U2DMMRPn7fulExjBtBVh
         rRFMjBX1xRHnh2uxBtRO7Fj8p8/w5ucmC6Nl8LqLsyrRXTLQgNxtaaY+Vwv1hwgqz9ux
         hciVUtW6Q5GBhqM6an9Y6C2i1giN9s6kCr24RGv4rhXH5Ew/J25zf1FegvGLVZe/gwcE
         50Cg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789057383; x=1789662183; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nEAGONInB8tJpm1u2lIKx48IXnht0iSXDghcmCqPigk=;
        b=QWb84oUuY0DIhK7Cn4zCchODbOkmPx0v/W4Y6yoAgILWKbrIbFulX/ogrgdskqh0hd
         XBqNK482u+rraNTtj3cOCbtaH6ArbvBAaVUPxYdJze/vvOJ2PrOV6rZZpKJ4CCb6/T/D
         izdn7/lkuwmMwR8aPAzBLFhtt4PiY/hHPXRzTxwLFOjBwMcbvik/O8nOLuXoOi0dNT2x
         JHSVBQiRkINOVm0ZSDDPZs9dFKLmstd2i74SftqOPn938BMJpB/6i44OrlOuW4RvDMOm
         DQxdWp55nFQ8Zs95BDMlBPmo740eVGidxTf0+Qz2huRcMaZdbNp2KnatT4QCmiumXQ67
         IVug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789057383; x=1789662183;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nEAGONInB8tJpm1u2lIKx48IXnht0iSXDghcmCqPigk=;
        b=QBT95ZYb+2cWMSg7I0ARlBNClG6eHx4mhSVBjQeX8L9SPxJK9PRbpUCv07kDLF0Ihb
         UkuWG/Q9Z9+p3EsJo2nG0zwijxnC362cQ8IdOVmGkZejKGy1bKcDv0X6ghoIMCFfI/sz
         EitnaNj9t0Ul1lfv3m5S1XOecDuOpu9bv90nHcRems7QGsYKUtBFjQXzmOwTX7//7zqy
         Rg/wRjGUz552Z57v6i7ibc8GkULf753Jws4dmKuVNiz9iXbc10sUi0eNcw6wppqWRlV/
         CF0A81aM+TasySKhywxv0nlns00HShesiZgzp/aWYH3SwFtyl/VBIX5S42sJCcRTv3vw
         QB4w==
X-Forwarded-Encrypted: i=1; AKwUvBzu9IOj8aS5qWhbdE+3K3SLVLpFuYR9yvaOT8ZZYcNrnifkoDjP56lku6LYHzAt1xLXRSfuIeGX@vger.kernel.org
X-Gm-Message-State: AFuF++mORQP47LcUXxSjzBV2tMUnW2roOMmeN7iYIez7dCpkBPFZZH+T
	PxnT24JRo7/h7egRMh+zk5Qm0LqkCGmWAAHnmCLuRrduL2SMmTzm+SselsPVh0VD0hvT6h1b1AO
	0PWQrXn1xU/98+C3NlZuZxeg3URINUhc=
X-Gm-Gg: AYBFou2PCM8RaIsZGSxQg0Uoe5RxYMHBHzoWenZFaZLMuydFoIIGPKMR3MDe5abLy+p
	lZBIeUTA6lTNGojK7mocLn05TYLblWPWeZmBtbYixneGGBXrVG1EsmMcQdugHQuJqzm2IYrjC0U
	cQAM/FZfXlaoPgv/TsWWfF9OJEt13ca9PcKTgh33metmbE38WZVgp5yqomnvW63hrozoSjNU/U6
	jmKO6bQn2AqAVlv9BHhAvcwOxyDow5c++9bC+tEU8nLOV5QmA60jEVG7+YD+l3qMpf1gfFEaKE6
	4OlDJPJ6zfioDbQaOqh7ac5M2rN/2HPfcgXAlBegbm6QusXOzP7oTurumgaMx3TGp91Ui4cEVQw
	QUQT/AGxFmVYHR2WLCyVupA==
X-Received: by 2002:a5d:6f0a:0:b0:485:95b7:fe8 with SMTP id
 ffacd0b85a97d-48595b7116emr40680885f8f.25.1789057383303; Thu, 10 Sep 2026
 09:23:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
In-Reply-To: <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 10 Sep 2026 09:22:51 -0700
X-Gm-Features: AcwNN1UnDVpavQ1PWarBG8W2VruLfKxk4ncIecF52ch3SJz533v-zrDp7ETfpYo
Message-ID: <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 3:57=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/8/26 18:45, Nhat Pham wrote:
> > On Mon, Sep 7, 2026 at 4:30=E2=80=AFAM David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
> >>
> >> On 9/4/26 23:14, Nhat Pham wrote:
> >>
> >> Hi,
> >>
> >>> To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap f=
olks -
> >>> I need some help here.
> >>
> >> I'll mostly ignore swap-related stuff because (a) -EBUSY and (b) we ha=
ve quite
> >> some swap experts around :)
> >>
> >> Reading below, I do wonder if the swap subsystem needs some more coord=
ination
> >> and collaboration?
> >>
> >> For example, maybe having bi-weekly/monthly meetings to get everybody =
aligned
> >> and uptodate could be something reasonable?
> >>
> >> This approach has proven fairly helpful in areas where (1) multiple co=
mpanies
> >> are involved (2) many concurrent development is happening, and (3) peo=
ple have
> >> different priorities and requirements.
> >>
> >> Is there already something like that to organize development? Should w=
e get
> >> started with that?
> >
> > Hi David!
>
> Hi!
>
> >
> > Thank you for your suggestions :) More collaboration and communication
> > is definitely needed here. Conference is a good place for this, but
> > it's not something we can do very frequently, and many folks could not
> > attend (visa issues, etc.).
>
> Right, and conferences usually don't have the capacity to squeeze too man=
y
> swap-related topics in, so it would have to be side discussions or BOFs.
>
> >
> > A bi-weekly/monthly series of meetings sound very appealing. Swap
> > contributors are very spread out (China, NorAm, Europe, etc.), so
> > coordination will be tricky, but let us figure out something.
>
> Yes, that's an issue. I'd suggest swap maintainers take care of that if t=
hey
> agree. I could try as well, but it's rather tricky right now on my end ..=
.
>
> As an alternative, we could also use on/two/ ... slots in the bi-weekly M=
M
> alignment session to talk about swap. (I'd be happy to learn more about a=
ll this
> as well)

That's awesome! Thanks for the offer David - I think MM alignment is at 9AM
PDT Wednesday, usually right? That works for me of course, but Baoquan
and Kairui (and other swap folks) - would this time be convenient for
you?


>
> --
> Cheers,
>
> David
