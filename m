Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B4151FCB0
	for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 17:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791910900; cv=pass; b=d0i62R4yA1XXh+462jAlwibPL6d2fNRa/gcixcfKMuSBwDZR9989j716ezgHGoFCLys3FBPrA2YVAzmdeZQvO55gPwsnl4U0cQqyKnGCBXJ9+ry4HCFRkVqoOOHcrd+AMeRrXemB1LmzgWZZw2u1Dr3S7yj9L59FyellC+EIRc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791910900; c=relaxed/simple;
	bh=UQ6am3LgmR/Ys7leJ+gNMiXEAQz+mkoYeAP0NcDYoRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fsACpSx1qc9+sGLiOwrxgTOJPy6PQNM3LGeDJ2U/3fQ7GvzQ2pPhxc3UJWRXpm8pa1nh52NcvKeyGN7tnnoLSCMopl3krNEz+PFzF+aAlR1XGnthLb12SEdGE/K19QnnrMLtu2IhWmp07AxOLj+evxqLlR0zdEfedavXkE2qpQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QO0rj9CG; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QO0rj9CG"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48af27fe287so2804044f8f.0
        for <cgroups@vger.kernel.org>; Tue, 13 Oct 2026 10:01:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791910897; cv=none;
        d=google.com; s=arc-20260327;
        b=D2IWQAHOaADRu+rpSnmbabx9zTSg9r6dTfb6IbVH870ZL5Cmy+qlJOLUkPWMxBz/gJ
         xwmjQbsBKUuoAl5BtR84Xk/fsUK4ZbkOktykvC7aeujkafR6aDLqiHKJ0cl9eerAlt0k
         tmdClafmjTqWVFg3SIJmI2RDpJJnSVdoEgNJT8pVZkHncCKWMpIpQZRedauL3Q5JbDA1
         mJj1AjezfXSAYpU9OFpsB9alX+pr8K2ca1B/RvluMW8gKzPGXEpqn3oi63AwrRvsbWQ1
         Qg4iXr0MZDUlsrs2jqCEH3DS7femgrdhBJh8119rOCpvBdNXUxzAh9ED55rlh6PMuC1r
         mDNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UQ6am3LgmR/Ys7leJ+gNMiXEAQz+mkoYeAP0NcDYoRg=;
        fh=/e2HrFUvXLNCUTtYE2OwN6BWyz/z6Yqzyr/D4mbaVPM=;
        b=bpR+029mv0mI0gZSJTkXg9iT0A4jGOJh5haBbGGJPJFO/VksUOOEICu/tfYNMCJJFi
         f+RMOn2PqUs/klYCbziGD++dFod0eU7vPZ9tXh7wKEBjEA7teY5JKPnOgZwTZJ+LEcUD
         xGKMdVBwJMrxtnFrX5mOUGPxXfxX1eBaNnK7qqXSJBBPfmBH0J86I1LlHrWbnlQTi4Tq
         aJCk0xdYtNERJMUmAbC+9iSQjB2y/e5rCoBR769WKsdV1JUzL4+7xDXk6pJCY73f2X+p
         Z8RMbgRDGiNJj33iQ7KSPHvNvjfjLTohHqJFczaxB9QTUlgYBE1Phk4hkCBH9weZek1A
         QaUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791910897; x=1792515697; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UQ6am3LgmR/Ys7leJ+gNMiXEAQz+mkoYeAP0NcDYoRg=;
        b=QO0rj9CG+19Zz1tyWcOzJyXVidolxkHTlHoQAFuwP9CZajOXC1e7MkOL+gE1H4nJ4H
         FutvjkoqPqWZ/DOVkRoRoICYfzXvrmDuP5215Rkc/7WKM1V7kkm7hmzrP1YEPgf1SZwh
         RkYjk7ah0TeEwqNHwZGiH1oBjdI9WOZmp88UgqXf4uus32/E2wIClHEmsqf8Eo7+MnZR
         0ZDG0Bc4wy0ZWZ7hQZB3zGEye+z3vPR04rvV5zZJrC2xlzQFkh3JXcpzEfm9ifgVZsrj
         vZ9+MONWajL3RvfDPVSXZ9V9JAz5OIAC0eHlXAGFymWficlipQ2gb5Jt6pTkdeKzVIwJ
         maAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791910897; x=1792515697;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UQ6am3LgmR/Ys7leJ+gNMiXEAQz+mkoYeAP0NcDYoRg=;
        b=YRIhkyryDlXzt1Bfq4sOMZjaygeo+AI2+kHvjcyC3R+5prWeNpoVPXKPXOL0zJ1dc8
         yC7e+VNRS/nNHO0nMTGk/laHsf6tlc4iDz2Pb41UpMdpNELoYJdGPrWc7kiP6/alQ9Xx
         7PIrDEnZTKswAoSizbbApJukZJuJDzV+Q6Yma5MbG+HCc5EYPYgeWUdqAcm5cZZ0pk8r
         T7/gogwUQFlQoiXscyP/II8a4h84VmCJc9D6OKF1yQqoXZZlx2D1BxVB689rkoe5eKQn
         nP1JBM8uc54Fu61LQpPX4SqYz1tGcOWo2S3z9DwmmIR7DsyjU4+enrniwM5sPLLpueSl
         AWlg==
X-Forwarded-Encrypted: i=1; AKwUvBz6PL1e4ruJU5samWWoNgMPwDMDLd/1N5tQPvEHmWi3IN4cWdAUBT67sUKrNh8mNTo553a9nxEB@vger.kernel.org
X-Gm-Message-State: AFq9FYIVxEIqLVE11PaaAfD1e8DqjK1Qz/7TrvuR2lCuFvBuhJaEe2Qv
	uE/kb04COuGUvnjiS845GUYYjkDeyyt8HL3OD9bU4OWSmVyFkFpbIxHGgAIYzvAmmtRAqHlpLXe
	b1pTPja4TT9S0UuCvV3/7lF+HzRoMtIM=
X-Gm-Gg: AYBFou1Kwc+r8sfDktoAKbYLbpDLbWPE9uHzC0rTV49n6rKdlR+8u49tGYoCo4Wh3ed
	IsEGhy8Ha4NYOcztEKqbbZbLDBV5sQhM4tQzVfrnutOBCznH2hi939DJ6JxCM7GpzWLqNE2w3BS
	+YoPg8tXtO4h+cfSejCFvML6IFdePHKUaOZZ5LQEl0YUv+dGr/orlnJhZ5TYhiasgnbXXG2Qfj2
	NmD8e8gZY+RZmhWrhUyrKJ8n/3a5W8WaFh1JUgNLDzMd9M5GOaNUlVfgWWXBpoFn2zyX20iarG6
	G0lZOutsOCsqutRIV8DrgYWNUnnpWlZwpIVzWyv1Y4S7kKnXbLfQ0RiM5gZLOk+wbDha/vO38vB
	Oi0T037oHCPJcxXe49VulJeKULNE1JKo4bE/YEoWwc8d/vEBdIp1oSf6BTUv3kvOOm3tgPvA=
X-Received: by 2002:a05:6000:1ace:b0:48c:571a:a1aa with SMTP id
 ffacd0b85a97d-48dba9dacf6mr28217721f8f.19.1791910895957; Tue, 13 Oct 2026
 10:01:35 -0700 (PDT)
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
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <CAMgjq7CT2O2VHpwZazugQRopi4grF+T4oOxZznoAGvy93Yjh-A@mail.gmail.com>
In-Reply-To: <CAMgjq7CT2O2VHpwZazugQRopi4grF+T4oOxZznoAGvy93Yjh-A@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 13 Oct 2026 10:01:24 -0700
X-Gm-Features: AclHuK9oUwgVv3XRRzK2ZGaoq7d_UoCd4WV6CrUoKrvhZqpz39_1MbDWEVKEMOM
Message-ID: <CAKEwX=N8qKhhVUR2Xd-UdtE45g80Ges_+BU_sCc2MzoVS4d4ww@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Chris Li <chrisl@kernel.org>, 
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

On Tue, Oct 13, 2026 at 9:59=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Mon, Oct 5, 2026 at 8:19=E2=80=AFPM David Hildenbrand (Arm) <david@ker=
nel.org> wrote:
> >
> > On 9/22/26 15:38, Chris Li wrote:
> > > On Mon, Sep 21, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com>=
 wrote:
> > >>
> > >> On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org=
> wrote:
> > >>> No that time slot is too late for Asia developers. I don't think we
> > >>> should use that time slot for swap alignment.
> > >>>
> > >>> We should find a time slot more friendly to Asia.
> > >>
> > >> Any time slot would have that kind of problem. We're spread out acro=
ss
> > >> the globe.
> > >>
> > >> Let's just use a standardized time slot we have for MM alignment ses=
sions.
> > >
> > > There are more swap maintainers in Asia than in the US + Europe, at
> > > least based on the maintainer file. Please be more inclusive. If the
> > > alignment is done without key stakeholders, it miss the point.
> > >
> > > Sigh, we can't even align on a time slot.
> > >
> > > In that case, let's keep discussing on the mailing list. At least it
> > > is accessible to every one.
> >
> > Looking at the mailing list, that approach doesn't seem to work.
> >
> > Finding a time slot that makes US, Europe and Asia happy is ... tricky.
> >
> > 1 AM is certainly unpleasant.
> >
> > US vs. Asia is also tricky, but doable.
> >
> > China 8AM vs. US West Coast 5PM?
> >
> > China 9AM vs. US West Coast 6PM?
>
> Hi David,
>
> Thanks so much for suggesting this. Sorry for the late response; last
> week's travel resulted in a lot of piled-up work for me.
>
> Both slots look fine to me.

Hmm let's push it a week. Johannes might be out for some personal
stuff - I'll let him respond with a preferred time.
