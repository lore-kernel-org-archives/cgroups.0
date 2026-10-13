Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC3E51FCC2
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791910779; cv=pass; b=qUAJpWmqGkKfzW2cx7e9O5s/uTPufGHpBXkLvg9AQV0aglz5HyiF8eFHitNUjmhdAKajWWL1J25hS2FKKGMzLP5kiNlgrKmP4NT+R6GLLs5A01CDoSDuR1xYrwtAOheB394jxou09yBJOZBtBnl0yvM8zdi3fL60cjrZroOztp8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791910779; c=relaxed/simple;
	bh=Irc52p7IpU94MjhUuTv/4weSSBLioQxa3X0dPTYCCpw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ngJM3oaApXhNCPSNI5d6QNFs+tmRtZyYFV2/khrBOT6EXq1FeGyrVGNchNz6lE40RuilwepP7DAYGw0kTa4ZeOHW7M0WIfhAEg4l6Bz2iyp+MzSYy4KKXxyTTq6+E7qjs1PnRh5pqm3RMjxqCwdzWe5ZSy1hHghI5cI1aSK3WfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EpOXiEQ2; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EpOXiEQ2"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2e5e090746so304688166b.0
        for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 09:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791910776; cv=none;
        d=google.com; s=arc-20260327;
        b=F5u5X3kN/CglAkrpocMaHChLwb6wkdwMM2WkuXs3TXEnVDKv4V0xaxLb1H903rBFw/
         SCQAXx28nRYBa28bBSNJthX9erjMa47FrAqVySEDByh3mWW3cqXPc0J1yGV+NcSLatk2
         6scp/xheyoEyjMOJ4MQPReouZ4C03NYN5lqz4jidvmJgtbPvHXuvJbyxmy2hoMHZoPOp
         oRZp6T68uTo5w65R4SYt8PpMrom5MH77bQvobKqQP1XPcVg2bIh+uTGmS/K1DPiv7buJ
         wIzyg0QGLBgfoiiknFpZwEyg4W/KwYD+bcqrpk1lyCDSwcyTkRI883QMyX96GUYJfl8N
         ymtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Irc52p7IpU94MjhUuTv/4weSSBLioQxa3X0dPTYCCpw=;
        fh=rUtXdnJjh5I1PJedzlxQmRaJh9vmt+VGFGjENInaiIY=;
        b=K1cae73qsk97uFRaD6mvJ2mvWOKzarg4JfhlNLKtaeVlxZnPtpI2eBr7lwgEExBXH8
         EzyKHbu8I2Bnb8iW06w2+T2vRy8bWIffIxuYIsc4oPKvegJDpBtmoYPqnH/5Oj8/mHXF
         A90sdNJYk5wEQe2RDAkiOYuACWW+m4FylC0jyY7sJevF/YuutAXgrwlHR4G1kOOqACGa
         y2nYdJgfHdIQxgnPebGYMpg1gy1Trnfj1riywLFhoVO0iMO0e+bwtUE3+LmN4ITY3yzM
         r1dwg1Mr/EHIc1rwKyZOhzZfOxBUSVuv/z42QzmALt6nE/qwROKZDICT0zwlJ6dJ4qwe
         byeg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791910776; x=1792515576; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Irc52p7IpU94MjhUuTv/4weSSBLioQxa3X0dPTYCCpw=;
        b=EpOXiEQ2SPQ6ZYYS52bSNKUx9gytoN2jhpEeJXfbT14FmKBNspqqzphM0++IIjSFFi
         tj2gzp6usgLn0QMPxtm1jfEG11DNn9aiUjDZ3pJYl3NmGZvPQ77rhTH/iostTGbD2/gB
         7KUxKMaCmJzVnW3Vr5/inj8DWr6sk5Pakw7Smk3lFXcvr1rLx/g6ZW/ViOTX1LrB9zoJ
         fsKkqVjdG8zYiGuYzeQo7KIpXSAYQbozbikn6G1G0zEzlWUnXoYG/QYUeOD6XJk4IoVf
         wBuxjgbYBwHk/wtgEKXIdE0CzYxI5cBz6mgybhU/XYNw8MxT2++D5PxvHRY3oE6rVocE
         tEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791910776; x=1792515576;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Irc52p7IpU94MjhUuTv/4weSSBLioQxa3X0dPTYCCpw=;
        b=HrpoeGUC3JsXAzfltMGYU7Bo5qS8EP+SdgRIoxLM1kumEbvnxPL+FBi26IUjKuWiIj
         f4ji2BmdwncUuBMUXEDHJ8/B/f2OETlp4kh1b4zmR5jYQULMcbon+0qD9UmaspIq57cS
         gjFgrRXsLGhRt8EwDiAmgs493AGD9mKKw/kNkPnSepHAW4B9CtAVm7pWT5dSM718uWxS
         waLhEmLdt8vfjWwfTjFrDSqTtW8Jz83svrTJ7J0n9rqwZsidWFJFJLkGQ6loXbco+9eu
         O7JLfrGFcQ0cMp7FDnImklBGPuN+1RB6qAdlP8hydbfQqH6vPnNVQVHdGOmTGx35qTgs
         FNFw==
X-Forwarded-Encrypted: i=1; AKwUvBxEzqY+BDO8NbfaBgfLlkDRrz54vQ9uRbd99ucq2nkpKGaBmMAzys1OaUdPNz4ARyBAWLKSixkf@vger.kernel.org
X-Gm-Message-State: AFq9FYKd7worCLNCM+XnlwCF1z7ZMDQm8IUODB5t2HY2BGzEWGh8VZv/
	YlfuJI+sgtZ67Fozl0BFW3LDlNPBoatAR5EVPsHr2q2RNBeeM9vWgAjnXCPgk2YaTgIcQJfwThC
	qLxDhFlUgqaGZMsLUXsv3DUwWX+6Jdo8=
X-Gm-Gg: AYBFou18hcnXkkGk3EKrAVlOdTT2+KL9bFpe1yP64j9p1scFNU60/zisIO6jmcZmKEy
	dR72esKUfj4YV2hH6HiE4wQN4Bdilz3uTIZ1UM2Q+q4KrzQds1D0SXhdQbPysTyRdNFxaUTuY2z
	dUKavOl4HfeLHrs1Xnm3DtGb7V4/ysljyUsoNE7dkwwLw7K+yFhmDWX9cnqKLPoCyrWlSDdtly4
	d5Q3Q3nW0DnIiLJibH6atE06moYomofWePm3glv0zkUj+ScDmXdpACT7G6Imryg5Cgo/6MzyrMj
	mbVYSs17/bQyLvWaES/FAxZqaAsVp+GIrOyaJntAPCTomR76g3NvZO16X22Pqn5LwHac7KBC8Up
	i019XVaIvu9IQ
X-Received: by 2002:a17:907:3d0b:b0:c31:7495:e5b with SMTP id
 a640c23a62f3a-c31a9feb26amr1246342766b.10.1791910775410; Tue, 13 Oct 2026
 09:59:35 -0700 (PDT)
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
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 14 Oct 2026 00:58:59 +0800
X-Gm-Features: AclHuK-dRyf9eKLDd-E-CAUCwm0MgTdU0FQN2EyVlbP88Wn126rzBlk5l-Sic0w
Message-ID: <CAMgjq7CT2O2VHpwZazugQRopi4grF+T4oOxZznoAGvy93Yjh-A@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
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
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 5, 2026 at 8:19=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
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

Thanks so much for suggesting this. Sorry for the late response; last
week's travel resulted in a lot of piled-up work for me.

Both slots look fine to me.
