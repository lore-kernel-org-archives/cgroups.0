Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C982E38D6A8
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 17:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976037; cv=pass; b=c8ol85vxBbwhWrRaQUHNKpkAbkNQnsSQGp8eCUKDgt5DZWJYCMzhNdimdjqYF5p5y/26OQhlU4ta3HcEQfC80mC1lp9DorQ8jUk3YqYOTN4CMa/W9smtdBI5/GjTPV+OyvhymJEZgrsH5tk3Xx7dN4Qh9LwJwJr7VzZfbioh8rA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976037; c=relaxed/simple;
	bh=hRHhNgr7L5x2Qzex+NhnB6McSSZGczX4V1lZLt3GATI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jvv5rseN1sILDTSMZzpiu/zGmuQcwy9+xC2Jng6vOI4nXEyT70VSuKeIssnJPPHzdkaClAwAIEUDKBoeb66ERtGMwdnU3D+fWoI/aK/FiW4N8PtfWNfZjKrmgpEtNgDQByG5JK4BMmoafbJTwik3TLCzkT7P+lBZyg7bwSVr3VQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iA8B8xGZ; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iA8B8xGZ"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48586861639so52455f8f.0
        for <cgroups@vger.kernel.org>; Wed, 09 Sep 2026 10:47:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788976034; cv=none;
        d=google.com; s=arc-20260327;
        b=pD2FoAGZ7cAIo537b+V2MhCVpyc1AT7n9toSs21+sgC8dSO2NabmukEYTPKSLgJSxh
         oWH1p6VDmngyod7h05Sl/vO2RP/EljLc+q50MWo8zigh4X72md9s87ZSt8TIxeCpVNpA
         lpLzMc+qDh5nHxwKFCFzGPb2e/NEyEp9bMzsauZMJ93GagCRdaRJCFxDAPrtrKH/RsOS
         mDkvx5H9RqO4DxHagH0Ck3+tZhp8dlLoDL03mO0FhjhifnmFOsaVoA7+9mW/aWdOTACe
         gOiZ2rUs4cR7KDP+HPX3CBSatppklGzcvHNanQ6iSs5WTlf00RZwRLkJmd1aiuuk1JVw
         1enw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cjBT/gijlT5nlkZYair5/Qqr3lqnucD6OCBJtzUzH/Y=;
        fh=k8H7hgcPoLAi2yScSx8CInWbCU7kxBeIqv7qVXCUiNk=;
        b=Qef13WTjpc8rBaGpnn+gMk3w3ytxkwpqm8pZb1xiCLM2RkVb//3eJ1nVwDMnRSDRp4
         TIcCDZlFmmC7Zl3NlQHt0oJFjKewq4+2b/Xf34B7yvJGQdJYoIdJ0azfUUjIxb+BeGXd
         JulmDWkO3m1XqoHz4sTnQCmFs/5jOxmZsnPx+nIAKznDR3CThoeqCS0dpXFNKFSLyswv
         UMVQiIkd/1Fu/tDgGHYKe4+swojbjUo1OhMyCoVY0zoxne83OKTQz+7j1yhXmhv5Oi54
         QP5Vm0yF2bU3nZhVYOwhkjTl9SruARkFl9LR0rze1q8QQ+fiJYceV9c0gKkVPhGtBBXd
         3rMw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788976034; x=1789580834; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cjBT/gijlT5nlkZYair5/Qqr3lqnucD6OCBJtzUzH/Y=;
        b=iA8B8xGZoUgEd3TwUaCb9cZFEzDs3z3WI+vHB7hKD7wQUsG8+vWP1rgmKBVTNnr/sR
         sMkOu2q384Z+G7kvwjD84N/i5RqPkDzav0owndb1nCU+a2RT7eZSKd+vO/axQLGr2X9E
         xkDFHVLBOndWNGczBPzSiwfYXANqCdcjQUtyg5RT3axb87FiyevsbjulKDYi5VdATdFG
         g3xnr/1wW+HEva9edTjUxqldSucvCF5EBXkkKs0xTp4dhrAMFdAVWcEEQx7qQwmMU46E
         ZJXqJUw1uqUVHL/dVbF9W9hmLhBwk6roK1LzVZdVas6Ix9HV36Vpp0SCFWm/FadLTTO8
         tUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976034; x=1789580834;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cjBT/gijlT5nlkZYair5/Qqr3lqnucD6OCBJtzUzH/Y=;
        b=qz+lAHq6WYD2Fkkh57Eww7slKb8rrRjN7fO44c1FUQD/aVCsbbD4fX72bDTS9fcRmC
         zbb3ZwxzHifJHj5Rc92sFRvvc5JtmjVdV1O+ddSC3+ifEkKflQwgRjhFQNIepTGSOmG2
         STu1bieYwmjNSomW4a6pMcoLxNs8cL2a9zEoVzotgQtu4XYHh7AcYDAlRavaGQ31HO++
         U8yr9BESWZM7RMM5U19WPicSFlteaei9n2unpkprUW1yO7mMh7UzdljZtrHk03UpBWcS
         5RSaZe79rTsiaPBWZUO2Ou3Qwvi0rfIrPlJvtSsyw4EWNNT+xdLxO0ww5AaW91bim3Pw
         fsTw==
X-Forwarded-Encrypted: i=1; AKwUvByuYLpEsdrSLzmFm30+lmRdSasFcueZgO/jCoo0Qo7MnU+f+FJtNRkTuEHKJdQczzwap445hF/c@vger.kernel.org
X-Gm-Message-State: AFuF++kIrjABP7m1FNVQOFrLr/lPZOSfCONEOiJ3iF1rGPiQBibEjKoT
	LFYxkIGEwJXwr88LfYpy/uF+cglyJ7IxzwbCvVWzFfVPUVUeKrwIr3CGXzSJ0e2pRf4zzKkFj45
	Es+ovULc2pDURagPnhy+H4LTWC8HCBEA=
X-Gm-Gg: AYBFou3ilXubLXW7j6X+3Wq6SMkupOaDiU4oV33RSO0M9iM7TM/9Xjk8wdZqv/q8nwW
	ohTNrYn6XGbTPEBSQwQVBgdzp32cTPVMqJ82Hmye1THuD+n971Z8CJWsm/hy3Sg2vFAYRWJVYUO
	JWA1x6ws1BDTLY1H6H1PHQwdcpZkyO5DJTs5gyQbNrvMdlyAWlsZ8t3Re621OlPsvNo6vy0wbWA
	lx4Mp8OpdegKj7CEjHGHnl3jkaKPvKAFeKkK7qt8y36GIgsRmz2X4R10+MF1SqbMNlYb5BRtNBU
	uoQisE3nx8DBg/lr2YkLaqimXu82HqJ10Xq8fLIW/E5Lt0E+60W3zUiMgBmcfppn76FtZzelztN
	JYa1Dqghacjw=
X-Received: by 2002:a05:6000:470f:b0:484:4779:bcd6 with SMTP id
 ffacd0b85a97d-486e0f6c735mr589913f8f.15.1788976033902; Wed, 09 Sep 2026
 10:47:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <aqBT_35E-eSoN_zj@cmpxchg.org> <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
In-Reply-To: <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 9 Sep 2026 10:47:02 -0700
X-Gm-Features: AcwNN1UaR9pHD2h6-LXbXZDQ7w46sDfAFt5QkIQi55ban0K1e2MIGYElY-fudaA
Message-ID: <CAKEwX=NYoMH8pTKeCvA=XHFmmNVMeDz3mxbhp5q6-PxSTJ5wOg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
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
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 9, 2026 at 9:41=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Tue, Sep 8, 2026 at 11:30=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
> >
> > On Mon, Sep 07, 2026 at 01:51:31PM +0800, Kairui Song wrote:
> > > Where I've ended up is that unbounded growth is a real concern. On a
> > > host with no memcg limit (root cgroup, and most desktop and embedded
> > > setups), an unlimited pool means usage can keep growing, with no
> > > admin visible ceiling at all. I'm not attached to xswap's percent of =
RAM
> > > knob specifically, but I do think some kind of bound makes sense.
> >
> > Swap space is just process virtual address space, no?
> >
> > Swap entries already have one or more page table entries pointing to
> > them, which in turn are managed by trees of vm_area_structs. That
> > means rlimits apply, overcommit protection applies, and OOM killer
> > attribution works as well (oom_badness()).
>
> I tested this theory. I spinned up a process, and let it spam 0-filled
> memory + swap these pages out continually.
>
> As you predicted, oom-killer picked it up eventually. The host was
> (and is) intact otherwise :)

Oh digging through dmesg - I did find something quite interesting:

[12462.749663] ------------[ cut here ]------------
[12462.749670] refcount_t: saturated; leaking memory.
[12462.749817] ------------[ cut here ]------------
[12462.759267] WARNING: lib/refcount.c:19 at
refcount_warn_saturate+0x1b/0x70, CPU#17: zeroleak/76075
[12462.759276] refcount_t: underflow; use-after-free.
[12462.777208] Modules linked in: sch_fq(E) tcp_diag(E) inet_diag(E)
act_gact(E) cls_bpf(E)
[12462.786790] WARNING: lib/refcount.c:28 at
refcount_warn_saturate+0x42/0x70, CPU#25: dmesg/76074

Seems like it managed to oversaturate mem_cgroup_private_id:

struct mem_cgroup_private_id {
    int id;
    refcount_t ref;
};

We should either fix mem_cgroup_private_id to use 64-bit refererence
count here, or hardcap the swap usage to below the saturation point of
refcount_t ref. I'm leaning towards the former in the long run.

This is sort of an argument for handling all of this transparently
though - expecting users to know what the cap should be based on a
myriad of architectural and arcane implementation details (which can
change arbitrarily in the future) is very unreasonable.
