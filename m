Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795614725;
	b=DtbQ6ZRNKaBv5LqIER8paQ9zCDsqCI8uPcM39PvnKmnjsj8NRdZBGynQYDZn7OE+Ayhf
	 q0v4yOJXdpC8HphnL5pJqYXRhuVLml2uvFHJBgWI3qsdG7xFoy3F3jmG+bYkwHVqFyys6
	 ap25ryJSjZAO9CcHJe9+2sVuVdSFFo0eQbvaXKON7RS1vtSaKdDH84edt6AlkiPAz3U2/
	 +MQUr6fCl2wamftUINNDO7aAbqtsjQa051SIHt+LMklST/IFpONAhhnx4hR6PtM8D6kfL
	 2a5+metRKHRQZCgcIfV/sN//u4tXV/+cN7NRH36Fpc1TxI67J4TtA+10i+5eszEQ+UQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795614725;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5FkHuxjNkBWcpazSUQh3/1ocxLfgOD0ATmjtxGIbMcI=;
	b=cf3YczUEP4vdA0W+WCBeY2hKto1KFQHpX6HBgPUFbgu2XMC3Vh5ZajlCiLaCISo+MptM
	 A8TjExd3cxuKM6R0CKuwimaKnJD5dDnHcdaG8rAcFWFRnmdvXGtiLQsyPMiM+P17ck+4T
	 7azOe6vezZADMAxXlX2L5EwCRsDcruw9S5UXMRAPIs1GQ0LouKBpqlalp4PDVvybrKtXZ
	 ghhUJ0hSxTjt/c+s9wcPk6ak/ZhQAkI+SYI+Sq55NcXWKmkqrCaZxZMIKx+fCJyC/sSRb
	 ozrbqnT2c9EGOUUYfflCkvObRdyhlD4y44fU40Vf/bVgqmEIZjnZsWrTqyr8FlbII+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JwkFDPU4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFACB606A337
	for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 13:52:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFACB606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JwkFDPU4
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b8786bb305so6980548a12.0
        for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 05:52:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795614723; cv=none;
        d=google.com; s=arc-20260327;
        b=kruBceELLzo4TS46WX4I7+4pwrbYacb47an1Q+oVGNytaM88eB/bZ0OAPht79ecRCf
         dSXYkxT0kAgf7KsADHMCtrtYxkMkshunW7uwAbyZxIXkPGK9HcqbWkWHnba93OFJGm3k
         /VR/FCe/m8iPoxzSEY8SZHr7goq6MVwyNDeLKvuWa/VZzp8mUbfStkt7qNpIW8IvscQ6
         9tG6SqeIOWeQsU2pg/5KKpBmh5tcCfI+4piEFxx/qmlZoXdm9fg/JPh0OhUWpK8zgqQ6
         gUzXwlmIarzCs2MxFtZDaMtsDrkpBkEhcGVLB4DJRlL8klsN112+BrkdhwIKXLPcLJaT
         iEfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5FkHuxjNkBWcpazSUQh3/1ocxLfgOD0ATmjtxGIbMcI=;
        fh=NG75EErdJQwCAuCBlSwSf/Z+0YVrDS+vBmtuDkvJ+8I=;
        b=HOAk3hcpm+ztlTVmqZHQ65y/B/2OcGSGY3wpn/kkyJiOi5B/l+lPr7NRyz7kl/bhxN
         63Jw/J7CiYdvrImG+k2S/eeURJ0pRGipquPNpkamrMChcyTS03RHka/vBuBwujktUgZo
         /qPQsIGK/XCpHLQJS80TKKxq46/mrgRdcdQ6QWLNgFwkLJWVh/VA1DldUP857lugj4Qp
         OXjJSsV6434RpOhM13maBWon30qJvSN8pRuQlyuGv19dBcCAJNVfHrnNBbfjQWib210I
         wYwGC4SMhhE2qKrNEEVpXBxNphyFI+JTz6e3P5IlplNc0uZsgFxGS8WYnBkiIWNwQ0iN
         GrmQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795614723; x=1796219523; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5FkHuxjNkBWcpazSUQh3/1ocxLfgOD0ATmjtxGIbMcI=;
        b=JwkFDPU45Sp3/AywUmLqgV3lywr76lk0RnG3gcP1mly4Olo3y6hY7ZegU+d/6ZQ2i3
         TtgALDD9Imyj6UufUTO48LeWksg3vbIhAWHgCJEXWJOPwz3VSHoVuU/Z9bQUzEtGp89Z
         E6X8fc6zNkv1c/xM0Z/N9I0sdHl9ISo7T63ZuvEHCYYGYpNASf2PHwafYmuJEdMr+xq1
         jlPSRB3bazLcPMifdD8NB4gxWGIJrstTwJT4mhbt0MCfSupZ3/LMJnJCYQ2WYrzeua2S
         2C5siQ32aULczJ5TJAaldRgY2hcjizrGQQbbtfWi/TvBUI8zpMZVDqLr98G91rZWdZca
         ik3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795614723; x=1796219523;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5FkHuxjNkBWcpazSUQh3/1ocxLfgOD0ATmjtxGIbMcI=;
        b=AbQxlSOcI+j6EfxEeS8OxTlJGTO/98m99TzvosTB/C0e/hG3ty2RKnK74YAYTT1+4y
         IglwkrJDJL0LtNixeJk+f8RgotJAgmHd/RWMyC4a5v7JntzBEhLbKSKqfOqlrB6uH8bw
         I4g7koDQjOJoLYLsZ6CZobe5n5htHfDNK9ECGwSSfpCsucZdfHJlDEj4zkAmnt3Vgo0P
         bNmGA8weaea1YRMziKMQ+ojcKH7xqJlTBnajvUUV115W63c4Vsm9KaEmfHdVQ+epGlVA
         3NpIWV2YoiIcoQI1muuA6jcldmiuc84T0ZHWuelyWz0e3Veqadi4ftoNl8AF+Z6oYO6F
         BTaw==
X-Forwarded-Encrypted: i=1; AL+hErFPEN5R+9a1m2gMPY5jefNISeMt4T6HTLwbpRk2pDWAyrfKLYul5fMT/CqQJNkrcgbk/DYWC+k7@vger.kernel.org
X-Gm-Message-State: APuU4Z9DpNDUzRoJ3tnUlaIC9lPgrNRJqKvNNJDg19jf5Vin/C19acgP
	CaQeO67MUlP/sTP5UPWzzVticnUfBUjBt7g5Ch70I8xe+Z9gsyQskEG3D15Bng8mM/Xf04+Ykqq
	flk0lCFCSzch+PuS8msqCPxUI+FuBDyk=
X-Gm-Gg: AZFdTZc2UjOX73lHMleqOvedusCm1EigbQfwfEk2QRcnt+WbICkKAOGzioyCepAMb9Z
	aL+TE5BF2bSUGwJL9lR9zpqcARa20jQewDeCSE350ekwfl2NBuGclPmzW4Azs6ZdQOj/TzD6aEm
	MDJjjbeGUncFtE+dpeuqARIg+s7pV8WNHOech9P09Q1/QF1Y8a3EXEiPYvFxky5whLR+rf1GLXJ
	Qd0d0c97L9mtipAYzBeLOxBiZGrG/Lkmye13devwqohZtyl7IEjBJk1AP2igNczg6eMzjwe93ps
	RxdvSk026+v/eBVQzVb5HJ7heZH4gRKdWJX+OEDllyqyrNJyN4vmZpvmK1glNmSAkTj4xbxGGk3
	E7iFKX/ZFc5AzcPGseW8shASB50jbBv9tEm9lbxxutZPWWQPY+jGxVKSZEqhn0IoeZd3VbA==
X-Received: by 2002:aa7:d355:0:b0:6ba:3867:42c8 with SMTP id
 4fb4d7f45d1cf-6ba38674444mr9425076a12.30.1795614722953; Wed, 25 Nov 2026
 05:52:02 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-13-8ffea39934a6@tencent.com> <43abc7c4-c435-48a9-8dc2-616095105d45@kernel.org>
In-Reply-To: <43abc7c4-c435-48a9-8dc2-616095105d45@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 25 Nov 2026 21:51:25 +0800
X-Gm-Features: Aa3M54qvnrtyAcMz5ZXrISSFgrUyQOGr2UM6VAg_EqnvxKpfk2xtM5m2ePfgGd4
Message-ID: <CAMgjq7CQkhA94QxVcdHzq=DD-6LCihA+psL1n-K05sxCffBOVg@mail.gmail.com>
Subject: Re: [PATCH v6 13/18] mm/khugepaged: convert to LRU refs based
 operations for MGLRU
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 6:11=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > For MGLRU, PG_referenced is only the lowest bit of the folio LRU refs
> > count, so folios with nonzero even refs no longer have the bit set.
> > folio_pte_referenced() testing the raw bit misses hot folios at
> > refs 2, 4 or 6, under-counting the referenced folios of a candidate ran=
ge
> > and aborting otherwise good collapses with SCAN_LACK_REFERENCED_PAGE.
> >
> > Test the refs count directly when MGLRU is enabled, mirroring the
> > smaps conversion.  The classical LRU keeps the plain bit test.
> >
> > Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Tested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/khugepaged.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 2dc4245814df..5e768481ac22 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -579,7 +579,9 @@ static bool folio_pte_referenced(struct folio *foli=
o,
> >               struct vm_area_struct *vma, unsigned long addr, pte_t pte=
val)
> >  {
> >       /* The folio was referenced previously ... */
> > -     if (folio_test_young(folio) || folio_test_referenced(folio))
> > +     if (folio_test_young(folio))
> > +             return true;
> > +     if (folio_check_lru_refs(folio))
> >               return true;
>
> Why separate lines?

I thought separating them would make the git log easier to track if we
changed one of them again in the future. I can change it back if it's
not helpful.

> Also, is there some way to abstract this that core-mm has to worry less a=
bout
> the details?

Let's just move folio_test_young into folio_check_lru_refs() then,
PG_young is page idles's hint for LRU, so doing that makes sense.

And with FG, I think we will soon be able to retire PG_young
completely, page idle's feed back can just call
folio_inc_lru_refs(folio, LRU_REF_MAPPED), save one page flag. But
can't do that yet, need to cover the CLRU case.
