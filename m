Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C904840A928
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786379626; cv=pass; b=cDn9SVe5jKgh5ydQyWZlOqiZdQS8uVsj5M9NU88Dd8Ui24T4iYmPTphv0igL9g1YTa84Njynk0xegx9Q/e20k6bNn3neFWytsDkuptsq5lYH7hbd8nCnmhr1xOHUJ0L+Jhza4G3gPAz8fa62fk1iZ5q9X3I+AaLTA4hpyfy1tFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786379626; c=relaxed/simple;
	bh=92IdV19r0TDh/ZZaldtV1bjlAmTbuJX6DPtxnWcUDvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NrTg7z/wqCniXy9Now2vxFIJdN5xZl21RQaZ5Zw0O1Dj6exNEQUXPCvk+yNrYL4uE+nkn6MU3Tl3D1dCmgu2mKWIA5demMG0WrVwajTQblxvlxWvz7JCXI1XLRDAn+a09XEI3KgZMzR2yHCEkWZrn/NRTCU6kFcaEfrp2bUkadQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A8nkiV09; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A8nkiV09"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-476a130c138so1999260f8f.0
        for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 09:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786379623; cv=none;
        d=google.com; s=arc-20260327;
        b=IFfOLYDHBRokomTwfDU1R0uia6lGtprO/+fAjLoOU8Mqvg7RNdxsUnpG9PYAjXWw8p
         W6ZGygb2wFcr1sroVzWnAPFLpVSkRM1xWpnnZvOwQYVjkgs2BHUaKf6zL4vdzKLX4KYu
         CJESomaYxQWQFvUkEl+KiYSXkaZ1hp6ZHS2cgU2MDl8i0R3dB33xFHqW+94jvz9lHIG2
         W/BYo6DLh7hqr2uKE8x5AO7gm40e9quL9vcEBroffF94wGA0JednLGjZejwgTDJJMbrL
         NLQwa80t2lG6V2ZcXWztumAArdfr16H4Dc+qGAY3/e18KEFt1THErtogV4vlHCPl1oMr
         cMoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=92IdV19r0TDh/ZZaldtV1bjlAmTbuJX6DPtxnWcUDvU=;
        fh=C1CIfPTUIzXbSg2M0w9Jki7NqZFl4n9bXDGVz9l9RYQ=;
        b=cIlv4jaNDmZJGI8PEB7U+c5fkR0gPPwl1PqfoRSmHbXDZG4relFGHCLSTrcurUfPNR
         jgkK8c5ExrrU2VpiAj657+Fj3nsjeMnwGbo/s8HpCzqbFSu3CWeAYyYfOrRWyTIEd3UZ
         rUuUcY17hELrgrHAHihIw6/qBxPosJ2e5B9hTpFL5V7CqCDOQQadzQQNluRKuuc/a6bm
         dEi0yjf+QfUHQYQ8XwwdPDhiTIc/7gBohc79zVamcI/9BFBRuSldR8qTcuzO8qY50Ow/
         hI+ghmYaCtw3V2jRabL6wtycR+6dmgfGzIZOAl9EQteaSWrsBnGUfz9YkYJR94JeFZIu
         u0/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786379623; x=1786984423; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=92IdV19r0TDh/ZZaldtV1bjlAmTbuJX6DPtxnWcUDvU=;
        b=A8nkiV09mUMVaZGn1g6ZmAv/VBnKw+90bPl8eOV5UL0+5cLisIR16/CTIvY4uWRWKg
         k46P1Up/l3E2F+v1Af2QpJ1dtIVaCUdyCVMaP8N+jDyC4r+/1jjBLgGWGWfr2PiyTlpo
         yO8SQ1oGEI4zJ/AHG7tAtraUmjG33aBFPsZxw7mxUckVT4jV0M5OhgZsmKn3phguqK2q
         vT7jmyO2YajscjBl09EaXZ68Fv5JK14077LWaLVnlvR/7hhNTzPu5XuoHakWVFsr6658
         mS2DB621jYV+H945yn7UXEcLVEWHh7S9wLrAbZSz/uGkaOuihfDehLaLuGMqcOAhhohl
         RbNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786379623; x=1786984423;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=92IdV19r0TDh/ZZaldtV1bjlAmTbuJX6DPtxnWcUDvU=;
        b=RVYz+tVIByxnOAuKjhJQYOHNWboGKndSabz0haD8lmjTXUwi6dZW1/GNtke0ufcErG
         LbIBEx4eJtpC45SGHhNof433Y8RP6ZZ4gqf46EZyfBhTAAlM8/j1eNcJJ8EZ6tvKhoBi
         Jg+PrPl0glGik1syhFtJIDQYFy5ag6hHIKtju/fbzKIaXImTQLyzO+AF11a5p86a9gXy
         hA33PgAhS6m2egyvL/akSANbP78Tq6wweDv+EZkIIZJMuQnNBhAPB2XSFjE7oQQECD4R
         YnyvQfH0mldKXsy58Z/zCyax31dr0aGq7sjSe8zBCwhysw8mHN0qqbj17QDZ0dDEo4Ka
         pMtA==
X-Forwarded-Encrypted: i=1; AHgh+RooCknUUePLeHi1PC99kLDLQ5w6f12ISR9b/RQ1+3/5w6sPtMEv0irUMH59tsvOR0sVrmI/qKJD@vger.kernel.org
X-Gm-Message-State: AOJu0YyU4LZu481MtwFKLyAfOC9QGe3Td9pFrxazzeLvmtK32P6VTXwg
	9H1OnGyxgXmRcxBOmyAsA2BZ2GKM80XpO8zIfEGoxrI9uBRTZ3cGMX9Yzt0BnCJqhp2CyaLhHY2
	kO8QUIFfMctliCqCe5Ld9bV7wxOnULJk=
X-Gm-Gg: AR+sD12ck3+KNiUvGwK/4X4ZHDqJPRnt5z4P7CJDtUPS/1/CdyOVYtHTxNgjpjV8lwS
	iKcBAflvX2ZylLB/md+4SrLs6Fk9x9Lpx85i5O6+z+1Y4SrjeaI404J8m7aBOCLLt8KiP415qyq
	MiKq/Tgbh+gY1KyxDazZnmfWeIqtRTN27kgD3jldozKMsz0g4sz82KL5Bt63uDw922YHKF+Qc7w
	PKZOLV4RGbPh1kalxHqXENrwXKsBjut1Ya2BfeY3n0EKtks7ijuWQ7gLRcHTubeLTTHJdE7X8vM
	MQZm80HokV5Qoc0Cb/ZAlyYqrWNPM0520s9ZO9HrNpv+q9jUtMQWB3k4PyOUHE1sMmRZCsyEOmi
	EOdZCjZ74kcdD
X-Received: by 2002:a05:6000:c50:b0:47f:7c50:2222 with SMTP id
 ffacd0b85a97d-47ffd967728mr37586913f8f.24.1786379622849; Mon, 10 Aug 2026
 09:33:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <6a756c71.01d0871a.3a0d52.003a.GAE@google.com>
 <CACePvbVKpkyV7KpUoiYPTUN0MgEcRUzZL71qTL5ePyjHTA3Kbg@mail.gmail.com>
In-Reply-To: <CACePvbVKpkyV7KpUoiYPTUN0MgEcRUzZL71qTL5ePyjHTA3Kbg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 10 Aug 2026 09:33:31 -0700
X-Gm-Features: AUfX_mzZKBGWa5jQHBx4faGYg8WQuFE8t_gvjrXgkg0wPeZavX_nvUNwRzCJVmE
Message-ID: <CAKEwX=M=08W43G3dSjRh1p7Z0QFSDQZWuNWguon1yETvxW+89A@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Virtual Swap Space (Swap Table Edition)
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baoquan.he@linux.dev, cgroups@vger.kernel.org, chengming.zhou@linux.dev, 
	corbet@lwn.net, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, 
	haowenchao22@gmail.com, kasong@tencent.com, kernel-team@meta.com, 
	liam@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, muchun.song@linux.dev, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 7, 2026 at 12:21=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Nhat,
>
> On Thu, Aug 6, 2026 at 10:26=E2=80=AFPM syzbot ci
> <syzbot+cif942a042aaa8793c@syzkaller.appspotmail.com> wrote:
> >
> > syzbot ci has tested the following series
> >
> > [v3] Virtual Swap Space (Swap Table Edition)
> > https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com
> > * [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
> > * [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backen=
ds
> > * [PATCH v3 03/11] mm, swap: prepare the swap IO path for vswap
> > * [PATCH v3 04/11] mm, swap: support physical swap as a vswap backend
> > * [PATCH v3 05/11] mm, swap: enable THP swapin for vswap entries
> > * [PATCH v3 06/11] mm, swap: write back vswap zswap entries to physical=
 swap
> > * [PATCH v3 07/11] mm, swap: reclaim physical slots backing cache-only =
vswap entries
> > * [PATCH v3 08/11] mm, swap: only charge physical swap entries
> > * [PATCH v3 09/11] mm, swap: add debugfs counters for vswap
> > * [PATCH v3 10/11] mm, swap: defer memcg_table allocation for physical =
swap clusters
> > * [PATCH v3 11/11] mm, swap: widen swap_info_struct max/pages to unsign=
ed long
> >
> > and found the following issue:
> > KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/e7da1097-3230-4e50-80cb-1dfafeebea40
>
> Please take a look at the syzbot report and let us know what you think.
>
> Chris
>

Oh it's a real bug. Not too hard to fix though.

Basically, before adding the folio to the swap cache, all bets are
off. If you don't lock the PTE ("and pte mapped but not yet locked"),
the swap entry can even go away under you. With the old code and no
indirection, it's fine - we pin the swap device, and we only need that
swap device's property here (for the sync IO dispatch). With vswap
though, you need to also check vswap's entry backend device. I need to
add proper rcu/null check here in the case the vswap entry (and its
cluster) goes away.

Ironically, I think I got this correct in the pre-swap-table version
:) I was way, way overly defensive over there (I think I add one extra
pin for the vswap entry, and then pin the backend device to just for
good measures, which is not really necessary).
