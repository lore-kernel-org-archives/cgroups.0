Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1AB52B1FE
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790178236; cv=pass; b=YYmDGxuD6XX0hR/yvgHYMsiryNntATmrBRPRq3UnbFuySA5u6uYh368vZntYzG+dY6QQj2kk8gnefPnB0bDv+yJWc00I/fx/DCQU/u1T3XOSTD0j5Yndb2YqmPHjaQcjHP0HNUFyt2PYQm6JO8www6JQ1V1mU0IRKx619WaBjqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790178236; c=relaxed/simple;
	bh=TTU+wpCFcAYrH8o/n1TRd3F4KqHTT45Ovt6xsGHc/po=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bgAi7u4v1/c4ptOtHMXa/JQlHE87QOae+8msQ7QJdgYN6KtA1ofBxwYdV+A8dlGvh+W70Y86eTyctYp4duYCIgBrsvWz3tEKIF2v3G0QdcZVxqTDGSyuQdwGXylM73Kjoe4w+hXfJ1LrK7dIc0+ahkFi4fH/Y/LDqw+CcfJpAj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z98iyog2; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z98iyog2"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccff31419so9229745e9.3
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 08:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790178233; cv=none;
        d=google.com; s=arc-20260327;
        b=nUkfb1xQ8ezv0OklY+3DDcxDtuInzO3/KuH+vOnPw0vjsPZAojby1wzzk8yLXQQUun
         IKXIwP8Gvz4NZgZ63qbP80OwrQwSpigwvfBPh5XBHOw8V6oXcpBwRuzAeCAK3bvQt3R8
         /uvYwDmOl8WjwJbz3OXHNPDf+fsKwZUJgOZcrUGnz5GoSErNwnrlsCYiZzy23bBiNXqR
         Yo4W3crUc/9Pno/iovopTnxD0OSrQf/prfS2Sh8zgf4q6Mwf2GPkoDBeSBhAvo3KiS84
         Ph/01GLfb6FrZHZ0J9JpaofVTvl7T1dLpmio3B81btd44Yqpn5BEAMv375RTUoYXOgt/
         HPdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Es8e/JK6KVLGMkYWnzLbZUNxa6vgo1yIxcTSFiPCupo=;
        fh=mQ8ORjzVQteT7aszQHVCJ68saff9rrXGnwr8VKAheJA=;
        b=mnHDzOS1mmVM/YEpJFwVsK34Db2aWM+u5C0dW9r4DqERK+44FJFh6oGamnxI4DOikj
         akqCJN4psG2EzoQacdOmAlpFMgD8vIXPPAtSEJJnHb5nObDIKhaGQToDjLeYY3eor9UM
         ARX69pQtB6IJSDvx1C0GqmqXG4RsQitdMQvqLFtsXtZec12MA/0/CZRPo8zt4MVLaXOS
         7L85R3+N6B/tIwviotnjJJRhpH0dwC6hhSd6A4sjF8SPOoKGoNzYJOzwYKsp/75YkNK0
         TAWv+STpo/71oACH4UPCadPeH5WSehx1r5316i1fa9/Mghq55drKms4LRmMOtUdO/rw6
         V8qg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790178233; x=1790783033; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Es8e/JK6KVLGMkYWnzLbZUNxa6vgo1yIxcTSFiPCupo=;
        b=Z98iyog2OL6AlgrltudNlWgBSpLK46Jk4Xoqe8PWWnjvWoSPijHLozscKuquMtdKCo
         O5+BRPihiSH9YO+fkdH7vXb4xnbH1JJMSENu/VhK/34y5iIcDZJ0Dis+tYYqJKAy+Riy
         gjkcsI8BLraRNQBZqu62OSlOVXl46ZtZwTTZ3Qa7INPED9N9mvPGiafhFYaqfKicC61v
         cEfvpwRCpr0MZNqbrNCNNgiC9pXoVfjws6TnCpzQLg5reGkKoKuI9ItzHp7sfcSg922c
         agjZjCGyInnauf5xRIt6ctbnZZ7eE5WKl2WdDBiiAgKGS7Ly0mY1UkRzVB2UdlkjYxUn
         gsOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790178233; x=1790783033;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Es8e/JK6KVLGMkYWnzLbZUNxa6vgo1yIxcTSFiPCupo=;
        b=ABi2KwdZT9UsA5ra3MlYkze4NeT1T44I+AXNCN3tWGu59tTZbLIDhTb1hU5nA6qAep
         Epc0n165l2H1RJlKHD+O0GP/aiQFtQjxce2BLsnf8JYRn0Uou6RzZzJAqEpvoHhG43NS
         ht5ZJX0k7IMrqNbPOW9YyUcPjV334BhZLylvTMXTpRKtVBSZ0wDEeP8rjZHWWkCmDfeg
         oVRALKuC2kpyjBDOcX9XXWliOIuRvkdl8V6IpsLOP4bZ5pqx65pae/mqE6AUlvj/tUpc
         imN/VsW3kDGfzvEC3PV2mfqEvxVh7GNRIPfT6Udz9zxN2tbOJWG4KHLWmBIbodb5g1Ma
         mk0Q==
X-Forwarded-Encrypted: i=1; AKwUvBwKN3ZQr9L2d35VQ8XarmW3aCd4UUdQzsclE1/9ljchWeGs1uieXXivsz0Mn8kFghL1K3UNkn8q@vger.kernel.org
X-Gm-Message-State: AFuF++mWD7IxrNslQeKIAQzvKnBb9XNvpjfUZUvrUJJNU5PLLIE9r6Sj
	kTcj975qPe/xP5GI74AtYeMIBlDoi6hGWxbtVqRdI4JR07rKGNxO0WbTHQC/nzvTAEmlSfwUUiq
	yzzcD2SOOZjwGMTAE8b7hHqIB3JuxP8w=
X-Gm-Gg: AYBFou3ecv34U6vnhIghOv7rtDUCZDGOvSQt+NjOfURP1H4AIoLIoWkFbQ6Ydr/0tLV
	OBo37C0YQVF4rtUiJ3atSIcshxKqNZD6HUuxrUvj1KyrMrl8LjMA1J35x7IK1FfWMV3DGhZcAF9
	06+J8Kkq72S8B3497oSaqeeG8ZZJiF3F0cLi+jcJa/cD8yy/lPmHec4yfh0PoqL3DsXt+DO5Njr
	+JUMW+C9k0i61KeqKWi6I6DwXMIWriLPwYzsOztUxv9n5vpepye52dC8JhVgv5IJdmiSqwBVsxt
	XD9FP7gAA7g+Z0KRjt4kEgWLIWFw72hV+BsTo69wuqPOqH2A13xSja/JUOHuQicaXhiujbPfRYc
	0FtnepTlHhAk=
X-Received: by 2002:a05:600d:1:b0:49f:e3d4:4c1f with SMTP id
 5b1f17b1804b1-49fe3d44c52mr27492235e9.8.1790178232516; Wed, 23 Sep 2026
 08:43:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F> <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
 <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com> <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
In-Reply-To: <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 23 Sep 2026 08:43:41 -0700
X-Gm-Features: AclHuK-DOXD6gmZ00tV-Y_YvQz68XBhp-4953At3s2qoPuH6VxOPtvAoXyV4CLo
Message-ID: <CAKEwX=Mw8DsieAeEK=Wjb2d2o=wxEN3QOoOR153u7Ki28003gw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Klara Modin <klarasmodin@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 5:52=E2=80=AFAM Klara Modin <klarasmodin@gmail.com>=
 wrote:
>
> Hi,
>
> On 2026-09-22 21:10:53 -1000, Chris Li wrote:
> > On Tue, Sep 22, 2026 at 5:53=E2=80=AFAM Rik van Riel <riel@surriel.com>=
 wrote:
> > >
> > > On Tue, 2026-09-22 at 05:43 -1000, Chris Li wrote:
> > > > On Tue, Sep 22, 2026 at 5:20=E2=80=AFAM Gregory Price <gourry@gourr=
y.net>
> > > > wrote:
> > > > >
> > > > > On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > > > > > Right now it has 64GB of memory.
> > > > > >
> > > > > > That is exactly my point. You are running 1/8 =3D 12.5% system =
ram.
> > > > > >
> > > > >
> > > > > Chris you are missing the point
> > > > >
> > > > > Zswap:           8812236 kB
> > > > > Zswapped:       24927876 kB
> > > >
> > > > I am well aware of the point. The 7%-10% data I provided is before
> > > > compression. After compression, the real saving is about 1.5% - 2%.
> > > >
> > > Here I'm at 28% without any issues, with room for
> > > more.
> >
> > 28% is one thing, 100% is a difference beast completely. If you
> > haven't tried it, don't assume 100% will behave the same as 28%. There
> > is a point where too much zswap makes the system unusable. It is hard
> > to pinpoint the exact upper boundary. However, figuring out the upper
> > bound larger than that exact boundary is not hard at all. I haven't
> > seen any one can use 100% system RAM sized memory swap out to zswap.
> > If you have a data point showing what that system with 100% swap to
> > zswap looks like, please share it.
> >
>
> Chiming in as more of a user perspective.
>
> On my 4 GiB BPI-F3, I can reach more than 10:1 compression ratio on
> zswap during some parts when building GCC 17 snapshots. E.g:
>
> MemTotal:        3966864 kB
> SwapCached:        31872 kB
> SwapTotal:      16777212 kB
> SwapFree:       16638128 kB
> Zswap:            280140 kB
> Zswapped:        2859840 kB
> AnonPages:       2927376 kB
> AnonHugePages:   1409024 kB
>
> While this is 72 % rather than the 100 % you asked for, I think this
> shows that what size a potential limit on the uncompressed size of zswap
> is suitable heavily depends on the workload.
>
> I have been using vswap consistently on all my machines since about
> August, and I have also tried one or two versions of xswap (but the
> current lack of writeback makes it inconvenient for me). I really
> appreciate the work being put in to decouple zswap from needing a
> physical swap device to work.
>
> > >
> > > > You are not listening. The boundary was set due to feedback from th=
e
> > > > application SLO. Those are real deployments not imaginary usage.
> > > > Please respect the user.
> > > >
> > > Different users need different things.
> > >
> > > The kernel needs to be able to accommodate all of them.
> > >
> > > The kernel default should accommodate the people who
> > > are least capable of configuring their systems.
> > >
> > > Hyperscalers can set their own defaults across their
> > > fleets. They know how to adjust settings.
> >
> > They can use a safe value, e.g., 100% of RAM. Let the people who know
> > exactly what they want to swap configure the boundary they want.
>
> My personal preference would be for a default uncapped (or very high,
> and I don't think 100 % of RAM is high) limit on the uncompressed data
> which is backed by zswap, since that would mean one less knob to tune.
>

Thanks for the data, and for the testing. Please let me know if you
have any requests or encounter any problems :)

And yes, I completely agree with you. We're having a very backward
conversation. The default should ALWAYS be less hassle for userspace.
Ergo, as transparent as possible.

Exposing priority, sizing, etc. is *adding work* to userspace. That's
the position that needs justification, not the other way around.
