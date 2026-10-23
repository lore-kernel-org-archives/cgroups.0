Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792776275;
	b=0VVxQK50PWoiFCN4xPKNYeDoVaeGWlZOf5L/WrrJKf5zaTLhR6KKKyOXWIbxFMbeYZbN
	 UESb13Nc925xTqSLPCazTq6Ku2uxd0lYUiSUGh+fGD2+5ajS7j+TTssFXcbpkIwZQHejX
	 M5BSSsg+bcU8I/Hhe8+YzDAYJynhmol03YN7wKjzC8e1Mm9JM93mvvl6hDJqDRceZTFAf
	 97OD6hrd8fed9EmNcQh1UPC21fwbb6RAJcV71W0SlcdWpprUjd41rzBbe5Fs7oJJ/c0NT
	 GgKAQp8XgjpOhcbvtfFfXtoiPHzqyTd45X+jlDpw5sNf7jiFANuhWqNecmkKRbgp9Kg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792776275;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=eals/84abdHEOTEHYo1O4S1OdoccFJaWdA/VZnmG1HM=;
	b=Ecnhifi0yUk3j7TYIkn4s3iSEEosNcZWvHhF00wB8DPLTYfBVeGVe78ervSnJ9eKG8by
	 9m9sul35EgU+MkzCtxDkOfSH7Ov7JY9bPm9YIlFUcfFpSLSzoEBDtUr6QpXFGWT6W4+Rt
	 /Q8hISysR3CMYL0M9lUCGZN4PLOL6muTyTOdr9amTuXL9oNqJCaU0KM4n5gKO9K8oZfhU
	 XKx6YDrCBsqQ5QiSQ7fQYL3H7XHTTGMYR3NYAADENYzID5oE5+5CExITI47aRwGuWe96Y
	 2D0Fpc7PrY/eV0Qc6RrlUZAEJDrsnPjxldfAuvYUy15v+qJFDAXaxMlovj2ok8XmC5Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P9y7fnPi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C92A606A31D
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 17:24:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C92A606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P9y7fnPi
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48afcfc4bf5so908967f8f.1
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 10:24:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792776273; cv=none;
        d=google.com; s=arc-20260327;
        b=HFJdZOb/4XO1bi8oouY8t0IcZufrAMZlOik3IE0+gLkowTjqxFh33UJas/nLKW/mNZ
         OBwk48mwbyjFAV/i8WdCDJB75Cyy+f1HyFmnJxEn4QAPM9cdTLJkWSAVGXQS59VVuYjd
         SZBYgR7BzXqylbokomzlUJ03R31xXJ5BtX4iWemaumt1OdXSksAtNbbwpYj3g7T/OhCA
         5V1EFDHCZHwdV6gsl4fjNRJ7eyntqzfUg311fy7wdxl/PFQjQO59K3hp9UJ2QFwp+m7i
         ZE+Bt45IdPM2gSB/P87piGBsc2GliS2LTww7jPlIwY4QomCI66lZtGOnz33uOhRS9Vg4
         q6cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eals/84abdHEOTEHYo1O4S1OdoccFJaWdA/VZnmG1HM=;
        fh=kp1MdjwI4dUQMKNZTvb9wQ8n390qOhLgcMoDxNNcQyM=;
        b=CscBEqb6G6G3D6pHZewOykC/zxR/1EPrzStzl9+R5t70ST9luCpcOv4agSsDsmunPg
         Frv1doGJo4JI1/Pcd51L+72wO4Bk3IwevTvvGivyUOKb+WlClxPpzJ0zGFIJjLFz2M1l
         SqCQbJv/PzrHGFHuK7AmNdVXe2FB/DLIb50lksLQbv7+W88Div9zFtpGV+PQW8qW/amJ
         IovyPR8nKoyZplKvbUe1ieI2TY68UN9VvbXD6rUWHNMCWnlWljMyXOKzzQ0KFmxk4NG3
         AcZlPupgTQdmNRZWu/Lm0TPqRA51kbeAE3y6rTX+2WrF6sLemTNCjAtdTY4AjylKwiDr
         Pxmw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792776273; x=1793381073; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eals/84abdHEOTEHYo1O4S1OdoccFJaWdA/VZnmG1HM=;
        b=P9y7fnPifOtWSrrXNHRkS797j5HZKJ6sBgMscYlD4DTb0DK/L5+tIiA2eHEdC+cwQ/
         fyJozZAgPWWVs3PbPl6pn8ZG4sS5UVHydDltzJ9VdBsIhu+3g37QDav1luMYBANFoBFl
         4c+Jh91093EhKdeGYgMd/e9LnCkl01LByP+L7FM2SHkPe1DFHNbytLyFuA3alN0WL+XF
         GVts5NNnDezu8yoKBHxAjfClvieimnE9k9WwfB8PMgEc9BEPm6hIHfIEIsH1qEi7ujbU
         ePKXFhXW3jtKCw5NHAzXXg0dnDY98CD1ee+ZoWZqfcpmJcbH4fn82UTcPdnr8HdEDgag
         Y/rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792776273; x=1793381073;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eals/84abdHEOTEHYo1O4S1OdoccFJaWdA/VZnmG1HM=;
        b=epaaoS2Fbcu7Itl55AaNKzp8PnLXXUkpjZMD3GCfrYQ4h4HI+PXoxwxJYXnoEJ9lFz
         y2eLBiVbhsRJp7W4r/NZFyV1+83wvsxNs0WPfndsnlUplgLAs9RZq0/o/1jrUuN9oFq7
         /iSlt1Em5i8HNPzmbHQZOFY0ubA6+143kSMRBruXEhqXxgN/sBtGFRnJiScSRnNtQyCz
         nanAjF/4Z+ZKTit2I28XfZnZXuMj5+lKbmSSIt+9LZoo2KQpl4znSaHZu1+fOo0hxyTV
         mlKd3WN79X3ouJSXtnK1nA+HLj1J/EP+9AvM/rCxMvhPxgPtI2j3fsMxBswHCZVoEQcR
         i4/A==
X-Forwarded-Encrypted: i=1; AKwUvBwAntbsMtMY8PZH8lH/Z2rh7Zw2ytA5fuKmXD7NSBqEjymrjdLcBKIttRhEH0JF1VP/cHVyK464@vger.kernel.org
X-Gm-Message-State: AFq9FYJNCfAR4PjvVCIH8WtsCNA72VUvD6vJOkFWPqL8esl/h+1sRYhb
	Xjb/bmLRHIXXFfGr6AZOThv8z1ymka36YkI8E/PWFq63pSdNnxRtcBuB7NE33bhzVQByHISkzD5
	kUecQDfaWiX/2J6wFSFlGTXFtBB6a1tw=
X-Gm-Gg: AYBFou3b4rK4eEh32UtwTgnhLrZw0eAM26zHei8b0Jz/+n/p77F6U4zn7xHWuE+xM4Q
	HN+DwrhVSIHwlEclJFtL0q7x+1H1j2Zv21MvQxxxgeloAGjFBhyIC4lkjQAGTtKDZqh2/UIvRaW
	bQk9T0KffGgKTC21q0snU+WluOJVGmma/AOwg94K0Pa17Jv9MYCpbmlZL6xRRdSTjcWsXPsTn2F
	KifZhLiaW9nFWyXiMX/CI/7KKAGLu4R6N2XLBAljiTnXlshTK0Jvx2dKIu+q+8ZcCYE5lFgeajC
	kTVGyKCeuWd55+Wi/Wa/r2LpI6brMC+A58NIXfdTTlHcUN+N5M41aLpR8FQ+V8SR9PfF7kJBsdP
	ab6C1wXlwOYL4hxmRT4zON7bcvwFf90Nz7TIE53wf7ZQz42P8MDa6hPXUMVnE9mqF0hS5h16Wkv
	VUKI/YLjzcYhj/TLKpdqVWGg7fLzTKJ3wvGkC/rl7g2wXuHFz+UJJ699/y5iaE68MklSErYVN3x
	A==
X-Received: by 2002:a05:6000:40dc:b0:48d:f5ba:fb02 with SMTP id
 ffacd0b85a97d-48e385cb0cemr4762440f8f.49.1792776273056; Fri, 23 Oct 2026
 10:24:33 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
In-Reply-To: <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 23 Oct 2026 10:24:20 -0700
X-Gm-Features: AclHuK90U31JbVkPlQ2JhTCxhfOcbXN8AAPY12NmqFk3jj-EPn44-86VqmxU4HI
Message-ID: <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
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

On Mon, Oct 19, 2026 at 5:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 10/19/26 14:24, Nhat Pham wrote:
> >
> > I'm traveling this week, so it's a bit tricky. I cannot make Thursday m=
orning.
> >
> > On Thursday I'll be traveling back from Cambridge. But hang on.
> >
> > My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.30a=
m - 2am.
> >
> > I could just naturally join that day.
> >
> > So one day later would work for me.
>
> Would that be too rushed for you? :)
>
> For everyone's convenience, this would be the time slot:
>
> PDT: Thu Oct 22, 5:00 PM
> EDT: Thu Oct 22, 8:00 PM
> Europe: Fri Oct 23, 2:00 AM
> China: Fri Oct 23, 8:00 AM

Hi folks,

Thanks everyone for attending - I didn=E2=80=99t realize swap was so well l=
oved :)

I took the liberty to summarize the points being discussed - please let
me know if I missed anything or misunderstood any points:

* Swapfile sizing: Kernel kept swap slots after read faults to save IOs
if these pages are swapped out again, and thus needed swap occupancy
(and hence static size) for a heuristics to trigger reclaim of these
swap-cache-only swap slots. However, this is not useful for fast
compressed backend, and zswap invalidates its compressed copy on page
fault anyway. Vswap does not need this heuristics because it just
frees up the swap slots eagerly on page fault for in-memory backends,
and rely on the existing slot reclaimer for physical swap backends.

* Logical footprint limits and charging: cgroupv1 allows logical memory
footprint limits (unique page tables). Cgroupv2 controls physical
memory and swap resources separately instead. While virtual swap
entries continue to count towards memsw, cgroupv2 counts only the
actual resources they consumed - post-compression size in
memory.current, and nothing in memory.swap.current. While cgroupv1
continues to be supported in its current state, a cgroupv2 transition
will present a problem for memsw users that still needs to be worked
out in some form of overcommit control.

* Swapoff: this was brought up as a request, but we ran out of time
before we could discuss the motivations and use cases behind them.
Folks interested, could you explain as a follow-up?

* VM_SPARSE v.s xarray: no performance difference between vswap v.s
part 1 of the xswap=E2=80=99s patch series. With all 3 parts, there is a wi=
n
for xswap, according to Baoquan=E2=80=99s testing.

Let us keep the communication line open and coordinate on the next
steps.
