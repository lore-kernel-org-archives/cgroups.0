Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADF1563FAC
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 17:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098391; cv=pass; b=eZk9eSlcW769+39bHYoGtgiOsMgWqDHCEH4nV+AjJxIpKYq/sHvX45GA7NfHN/UFQhGQV0uMzN9+c1ZoVqMYJN1V7VZ242wphz8gYT5vA7xG47tASG5HLRMKWgQ/pQ0ak2q1WiIIWvEV+tMc72BeL1vQxqTi2XocTJFx1C/iKq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098391; c=relaxed/simple;
	bh=6wfVY0cj3I+ZyoFfhOD2M0rQu+6sC7TkY/5LoCxxQ7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C/o1YUMn8zxnn/QKXf3HgG+vlDUI0R4/uP2YHB/WlqBqyeuw4to8yRttgVdZBf/naPGA8sMSJI1zYGaRw+SziUZzdxVBsSfA9vE5E/0AgjPQkkyYekfwfiNoc+8pfZLO2Py18ILg7jNBfN9LP8/Hv9jiGIB0cOPD8x0JgGpTIVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bqo5f6rQ; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bqo5f6rQ"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f633ece3so145520f8f.3
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 10:33:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790098379; cv=none;
        d=google.com; s=arc-20260327;
        b=ooYZs6fHOG4b+YE7/I9xknSM1KWofI/JhS/2dPBl/Buuv0v3KmnjmKVBEZ2xHBrepL
         mwoZ3ADesOURBEsDDzE6gKJthw3+oYcx2l6FMOEexmm2D2W/V00QHdIq+HyGhbPS07pm
         JqPVtB8KEwHbMNVAkP0rlbIgAxoR/Tw8EAxmvjH4D9J4EDk8d84ZsnfxbtOCz2+aPlWz
         RdPQZHBFgelkhah16hrnTJoc9sFL0tdhFkQOqx+ZuiyqBGgxPbhcEAxdGOR6ofQcAg+Q
         npB5T9jtuiMwkcyK90jsjM8G3giOS6SNvzzHDRWL3l/lcpwVtrcsCq7UGRufso9tjrpR
         kxOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6wfVY0cj3I+ZyoFfhOD2M0rQu+6sC7TkY/5LoCxxQ7g=;
        fh=lOOBN3YBmU2ufOTcRitKavmcy4noOtaFuR1JdOvUjqY=;
        b=NBbV6UGe5DY1fL+x93J+bDPmLG7ivj4QJwFEBbRuhhHFh42jybr96Dk4DUqMASAZbT
         EI4VmGd2d4GH81iNXSFG7Xu0lDHjkx4269WsivNYoA/uQ+XM/xVMaApjNBunGFWg+9gp
         d68BtkTep2BB4n6N3XAZUM6AV0am62H7onK4HDP0x+afEuzJg0PbKv3XmmOfREfYzKqH
         enXcBgjGwgkeO323/R6GGjw2NhkuY/e9VsUDj8jMMdykKunqMmnDeUoVCq2qciw4j/kQ
         u0XIzVJm4U1BM++lihGki4lK2UL+8kopZwMtcxSedVKCkat+uBioi1ojT22dMunORHrg
         U9Mg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790098379; x=1790703179; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6wfVY0cj3I+ZyoFfhOD2M0rQu+6sC7TkY/5LoCxxQ7g=;
        b=Bqo5f6rQ81SdJcMHzW6h+aCRwcL9/oII0H/XLS8t6j0vgloBmj4IaGLms37CVBWhOh
         fWGrDNwzlE44dRvX55bjReJ2ot9ZSbwjfHV80rnOO1FBzWwd20o4JJmO/3QCDtDo+KTw
         SAF7WAZxa6myBRPr9mxVaiotHwXghC8owapv6VmoL02WC5DKDs+LuZDKIoWulYqH9AcW
         yeRanmuHXW55eYCd95qNpYsfkEcSLVqlR4x4P9g5HIRGQIjXiXQtM5ZcS38GH/JS1fWO
         8ztBqKVqsfU0WZa/4m2e507cELXCtF8nloCvNtK0HPvGesNL1DM80hjXVLCT2sgMFPHi
         CdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790098379; x=1790703179;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6wfVY0cj3I+ZyoFfhOD2M0rQu+6sC7TkY/5LoCxxQ7g=;
        b=ollF530tZCJYiXiuYjyhfdXvify+M1D5HRGyMU6zrw+3Hgl7g2B/mUjLnWLCQzaq1A
         bZk/OWiJb/tTHUJb6VvV+DdVG7zdq5F9v5zSO2KlOXb0TPHGadvEhAQlKWh7FvDf7G5c
         VclmMTN6YswucWyKJxivQC58ljXKj8nQB4NmyCFW6F+xG3b/28JniWDH0n7N5VI8Pb9t
         1wCQTkT/lGa2Dh25J3/58eq/IZspFSMMv0TWBCs4nZxJGu1Kx1Wy0Cro25/NJ9A5L0cM
         z5tsoAFndqy/1RY8bZ6wDlD70FcHyXzPr52Fs+/qN5+FW+ZNfymhY4GIg9GMsceLMrjw
         WjFw==
X-Forwarded-Encrypted: i=1; AKwUvBy02EV7MnxTEHaLuWmcnLcQQRHKuXX3ZfcwfX+m74/9UumG74Q0RqsEwhHYzTLdvBBpHfuSuGCc@vger.kernel.org
X-Gm-Message-State: AFuF++mXLePkCPpvY6If71/5tJh3JCnbhIRV65+aL/wUTx9jLUIIFZd0
	kNqfeKwQXJstAdjOBy5XaE7bx3MuM92SYYUDBFJAuTdOs7dXcSKZVS2vOgmg9+xdtkhkkiSFn/Z
	3v7szyDSKvy8YR+P3xPPW99++/4JeNpU=
X-Gm-Gg: AYBFou22Pn4WAll8chmuTl/KQBRSAMlL0P1Gm6yfJZsY0LA0cTSe+O0RJqEzVAP/EJR
	upTh8GzPj38Z3WPEo4U7aeO/ypCE0qc2anzL9bJ9VkReAEWVP3MqpQJ1UQjsrkSsOoO7BGnfDGH
	XI1/lthqIS03oCQT/mRI5lTzB6pgmjQGXIzBAcW92Wq1Oj51YJ7sPsv4ASuJUOKhaxBtO+nFcCa
	QJA3RK1tEQ2A/xSoiKdLAFuOGA3uT1j6VkVUe4GZeMhixAgySMoHr3IKCtojVvu9ODWRkS7bvZL
	6jbTwyAoMZMhBOd9bACih9zs03Bbu+Jz4MpllP8EFO0U8ZAAnV802RfbsPtDwYx/t44vPeu1K0Z
	d5BnPZ5tzzy4=
X-Received: by 2002:a5d:5d08:0:b0:485:ac35:5c5d with SMTP id
 ffacd0b85a97d-4886705d7f2mr561509f8f.15.1790098379271; Tue, 22 Sep 2026
 10:32:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com> <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
In-Reply-To: <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 22 Sep 2026 10:32:46 -0700
X-Gm-Features: AclHuK853Cv8o08iYHDa9EpXynqoJX_zkfnKle6O-lWkCRkEdpUZ-YCtbcciUuw
Message-ID: <CAKEwX=NrN7-u7gnGvWX3qfHaBQcN6FKsFP-4-k76F=sxM1LJqg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
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

On Tue, Sep 22, 2026 at 8:23=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Sep 22, 2026 at 4:59=E2=80=AFAM Rik van Riel <riel@surriel.com> w=
rote:
>
> Yes, I can agree on what you observed. You are using anon + zswap on
> that app alone. That is not what I originally asked.
>
> My original request was for the whole system: what percentage of the
> total system RAM size has been swapped out to zswap.
>
> Because when you have 100% of zswap out, it will likely trigger
> different kernel code path on allocating memory. You might suffer
> global memory pressure you did not observe in the single app memory
> pressure case.

What does this 100% figure refer to? Pre- or post- compression size? I
legitimately cannot tell.

"Trigger different kernel code path on allocating memory" what do you
mean by this? This reads like you're referring to post-compression
size, where one cgroup eats up the RAM of the host, affecting other
tenants in that host. But putting a limit on the virtual device
capacity limits the PRE-compression footprint. It is a very
unpredictable way to prevent the effect you're referring to above,
because compression ratio is unpredictable ahead of time.

For post-compression size, I can make arguments on why we should not
also gate it, but regardless we already have zswap.max and the global
zswap pool limit.
