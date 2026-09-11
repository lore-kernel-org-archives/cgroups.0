Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEDB372661
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 16:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789143659; cv=pass; b=IhfWO82+/ZusfShAgP28pmqIurGQBJ+RIJXdk7gh6+4mQoWn+wilRp5ONwFFVuhpWeY24DCO69oa48hFclCY8EXh5ehk6VxxBccW/Hb/Uhp1d9wzpzFzLRKQFDe72pCoZcgNrEKnBWtbZs/ujw1pCygdWXyL5ol1FcZuf05pWl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789143659; c=relaxed/simple;
	bh=D+30lDlcgxH+NCGTyCWjhWPMaOa6aoqrueHB2CoYy+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zurdnyl3AmHHQ8Are8Au5zrG7WA2e8dMEd+gaMr2A0S4rHzh7BdwAmTnfSYq/vfeKE7h6YfgfMgBv9+FXov8WL4WxSgLrZzTyOePX1G6J0uWc068AvI+zoe/fE3nj9wfXoyWEFPcooVI6tXZh6iXFAtIV4DWHySX9dWjm2QHezc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rWMLKD1v; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rWMLKD1v"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a18e24ad25so1508311a12.1
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 09:20:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789143656; cv=none;
        d=google.com; s=arc-20260327;
        b=Tbe28Bo0WYJlmskHq98rsvUOBtZbfP+3RClobW5knhPW6jcAACA7ybH0Je6a0fZBj8
         JPOVUFYX57vZWcy5ZIdNvV3swcJmJFQ94eYprOCub2DLptVjt92EHisBm0gNYvnWr9Rj
         8dYjcVeVq/230V41JHMK2Eiwm4kx+wcxKgsgvCcs/4BCpqYVAZS2+Dqs5CuVsA2DsMid
         DP0s0zCTkK7h0R4QlNFMMSqtN3nWY67SjjQVtuXQqXo8BVtF2lW0gE0b5TjasTut6lrm
         b+lKM5kBmvG+htzOrSr4xPUcNjHCWFDoFIwn8cNJFSFE45wFJ11rQgm246nSKLDLTXy+
         HwtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D+30lDlcgxH+NCGTyCWjhWPMaOa6aoqrueHB2CoYy+g=;
        fh=OPlaP7+sZg0wEH6oavzDg0pl8FTnc+BCs4Sllt7TvwA=;
        b=q2kkGII0MDtPyeOhGIuv2nkQc1B4dqPx15ioRnznfAlP0dXWCJtwuPEp9hmOdLgsUX
         YDsSF8xzV5GFQzndJWd+LFhaXgu8l4EYeXSMnCuCnl+dYxtUrUmKJPD+JMjmjNt8JfoQ
         r0QWEJ6yAQmXM523OFLieGh7VLjZRzXw+Rj5nFNQ/UJU3gVSGbgnSo4UEenPrvVS2buU
         hif3p0FTY7BdJqKjQgdhnpkfO4ClH8gjo7sS3QJmpklkymdIl5gJUFLJeNyxPzct8oc6
         H2rFtCMhSEEY6iRmJDwpuDIISVb7PidO5iMriAbepaami5cdHhwaDndSTtZeEVz+vbc/
         ONUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789143656; x=1789748456; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D+30lDlcgxH+NCGTyCWjhWPMaOa6aoqrueHB2CoYy+g=;
        b=rWMLKD1vCNa1MSkFM9EAcQ/BzM+sRbFwc1QFC0icP30QjihsMH0RPDp/Ee9/4AnQCq
         Sz4S5mfJJS5km9J08lAOM1vrcGIF6tT/lgJ67qGjYxn5u1OkG4TLBXEAZ8eSoD75imsC
         gHeBZ2StBFaHXq0OHOxC6g7Vv84EHRP6O6Wue1JB7+bNeesfXPelLRRSnkJEVOBWGHwF
         MVXKZlhKYFm9eS6I/+RUaSuhrPXKJSuw+AtJqcpxehV08+bP74jRNSTRy1bcNDOQjBKi
         l7MtxA98vwEcjXb9FdY1d6bJx4zoTkqehPMIfu3+m/iYWAKlsHJ9JiAYV00k21t5aqh4
         3uaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789143656; x=1789748456;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D+30lDlcgxH+NCGTyCWjhWPMaOa6aoqrueHB2CoYy+g=;
        b=H31z/G9Tst9tefj4ibleQtZM+aMVpdZetHWYGIV4BdGWrGZbrFr8beQOQomkfSufOL
         78MByo1z2ay248IvYA7291eNnibTSoASg69KP9K+nha8xaOn4z84KGMJ/2dljjzT0Vt0
         ZQp5oAdjWnYCXWSjURwGGaEDb4wkO9zR1JRA/4IS2thOSO2/fipAE7j5XvKsf6VfwVq/
         IOQxqdvuSFE+sObkNgDWNJ4VVL0Jcg/6WmAnZmhhAT71qvW1BhfNx7JrUMdpcI/AHZGh
         BpXJKbb88Ck7vqJv1KnGSEqajoJT4DLhw2JT9zST9C4ppxb1G4N0JjrvFs6yg0KaLCSj
         chjA==
X-Forwarded-Encrypted: i=1; AKwUvByTGq5SeUrlL4ZtV/JdLadxnn8rUDSIJRgxS1xrYkCntHmx2nAlMTqmYiGg1WDTp5rX3kK18nXQ@vger.kernel.org
X-Gm-Message-State: AFuF++nlmrqJltfu2AsucSygYWSGoZUbnUFyOD8aLOy27cW7+E1Xy0dm
	QZ+JEnWEeaN0AftKnP+hAnpaGX2vdevOHFJZGtMBLTXzmIDl1S8Xdq7AEIczj/JKz5Brg5fSwJd
	kPrGRHWDmlscZv11MdxoK3xLTP1z8SBE=
X-Gm-Gg: AYBFou0wMLb5qsagRtkSrW1gRu8A0FGgh/PA9qihzXiI3igRB3aLEe/wfIFM1tiKWDp
	Zcs9KHhbg3C+bLbFHwTdr0sgPQUx45v/k1ZQZpFsJ/2HVEwFSQoeQ4y5KY1vczE47kzXhqRpvNP
	F1mA4qKoUGpje6EEQa9FKQQlDXxWEA/OfpTwGOPenTzmuGYim4o9qph875PJgxqju1s9I8o01O8
	Z5WjN0hbqWs4xwCqN/lU6xnez8OmFvTbi7W/OIxMoSYgDCEvU9Nkzcyvs1ZuUgwoKYSmKFsEBNN
	vsNyOPF7fdCixda7coUK21NlYtwyaQGFZDkP2qasuMJoT4n/+iyQuh+mSGo0FNnKopvt5TECsfF
	mFTn3wpqdg+M+
X-Received: by 2002:a17:906:c141:b0:c29:5151:16b8 with SMTP id
 a640c23a62f3a-c2966534d19mr204979866b.2.1789143655518; Fri, 11 Sep 2026
 09:20:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
In-Reply-To: <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 12 Sep 2026 00:20:18 +0800
X-Gm-Features: AcwNN1Wybf6FDfg7sUWRjBvgNHNibYe2e1PczxS_TZMQQ3Wr5_VcCDK8f6zS35M
Message-ID: <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
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

On Fri, Sep 11, 2026 at 12:23=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Thu, Sep 10, 2026 at 3:57=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 9/8/26 18:45, Nhat Pham wrote:
> > > On Mon, Sep 7, 2026 at 4:30=E2=80=AFAM David Hildenbrand (Arm) <david=
@kernel.org> wrote:
> > >>
> > >> On 9/4/26 23:14, Nhat Pham wrote:
> > >>
> > >> Hi,
> > >>
> > >>> To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap=
 folks -
> > >>> I need some help here.
> > >>
> > >> I'll mostly ignore swap-related stuff because (a) -EBUSY and (b) we =
have quite
> > >> some swap experts around :)
> > >>
> > >> Reading below, I do wonder if the swap subsystem needs some more coo=
rdination
> > >> and collaboration?
> > >>
> > >> For example, maybe having bi-weekly/monthly meetings to get everybod=
y aligned
> > >> and uptodate could be something reasonable?
> > >>
> > >> This approach has proven fairly helpful in areas where (1) multiple =
companies
> > >> are involved (2) many concurrent development is happening, and (3) p=
eople have
> > >> different priorities and requirements.
> > >>
> > >> Is there already something like that to organize development? Should=
 we get
> > >> started with that?
> > >
> > > Hi David!
> >
> > Hi!
> >
> > >
> > > Thank you for your suggestions :) More collaboration and communicatio=
n
> > > is definitely needed here. Conference is a good place for this, but
> > > it's not something we can do very frequently, and many folks could no=
t
> > > attend (visa issues, etc.).
> >
> > Right, and conferences usually don't have the capacity to squeeze too m=
any
> > swap-related topics in, so it would have to be side discussions or BOFs=
.
> >
> > >
> > > A bi-weekly/monthly series of meetings sound very appealing. Swap
> > > contributors are very spread out (China, NorAm, Europe, etc.), so
> > > coordination will be tricky, but let us figure out something.
> >
> > Yes, that's an issue. I'd suggest swap maintainers take care of that if=
 they
> > agree. I could try as well, but it's rather tricky right now on my end =
...
> >
> > As an alternative, we could also use on/two/ ... slots in the bi-weekly=
 MM
> > alignment session to talk about swap. (I'd be happy to learn more about=
 all this
> > as well)
>
> That's awesome! Thanks for the offer David - I think MM alignment is at 9=
AM
> PDT Wednesday, usually right? That works for me of course, but Baoquan
> and Kairui (and other swap folks) - would this time be convenient for
> you?
>

Thanks for setting this up!

Is 9AM PDT fixed, or can it be adjusted? 9AM PDT is midnight for the
UTC+8 folks.

The time is still fine for me, though, I tend to stay up quite late
anyway ;) so that time works fine on my end if the slot is fixed.

Is there a calendar invite or something, please send me one, I'm happy
to do a swap sync discussion there.
