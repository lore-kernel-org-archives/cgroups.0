Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843D852940E
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 14:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172712; cv=none; b=liB0tOnSKAQzPKbMTS6WitnQFb6ROUj98BYFRHUb8q/GvJO6O8ekWoF+fXZo+x36l281SXm31OzmEDuuw9VklVDVrv9k60wtrvO6d6Oik4soj7E7Htk8TQ2hUMsseY/WyuL7oJFal72ugGEEK50QJy6WMMAoR5jI5T1psmlXeq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172712; c=relaxed/simple;
	bh=LGkkGMO9TERbEvKb8FRwlBQ0y/VcZh7QYYRvUrUUVgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gz5s/HpXu0xzgpSRLfgpOdUr1e7e0Quvnxl5yVwaVMCzxgpdyV84Votl41QqGx1X9S2sbFFrhJeIObf4GyXg+ulkBwzOIwsQjKWB3zZDKkiE53nvsgQTzP1zgZWTlExwTSqqkeI6pli9UqvaYEegqPcikwW1OnuHHsu3Pk6RCd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=PXIaWXRp; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="PXIaWXRp"
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-85d43f9b119so15827337b3.2
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790172708; x=1790777508; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f7LX2hgCSw8Eo3VcIXgLYrzvPbWMXRZn6yDRkmN7Gj0=;
        b=PXIaWXRpfdMN1dWxL76T7IGNzWwT1jFAoAeoqw4qgOcsevgKXY6Xu5LIS9/4fHhptH
         hz3NaQI6+AHCLwfAaRMyyVxPdQT9PvoAJB135dna7knuRHzS34RsUuISpAsk/adV6eDi
         mOibJWB8ODVC2Vet9ZQKUbV4Ghzm17vCkPVWLjNm0S/KIKkWA4aNaBjV5x2uB+wGLoNE
         1CHOdYdgCVPbbmN2f+AjW91W/79lChW3pFCLkbsypCxenmLkNyoJwmQ2PFbVFIlvYNIp
         p6tvEx2DZOFJ31aPqamHnyvF4GRXoS8hrmlD6fIl42WxeOR2t5dso3yvtlipv8hDjG8p
         eJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790172708; x=1790777508;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=f7LX2hgCSw8Eo3VcIXgLYrzvPbWMXRZn6yDRkmN7Gj0=;
        b=QT/1TZgjF7C12BaJxlWCW0NA705D39uvrWsr5CNu+4NwUD3Wu116I+n91ImJOO0aVO
         gW2YNjelpQZ+HRd9Rp6UX9v2t2gOmOc8vz71yP/+gq+zbtpNBYxjqdl7dr5txiPY6Imq
         5Leemc7qM9zfaRALyqG2kftgUKneCvTgLqI+jW13HxkOCC7nv88ISHM0ajprbnn4ZaUh
         Aytc52gsAoJPuIkIxTYkUk8B1UrNnC/ht3qKBoWDPvXdNzpSlvchKsZfnAy66uzsjZEP
         XcS8GzSrhHyzd4HVlDYnE+cxLmW5f7QN+QIC7vEb+/Ntg+0SWL/wqMLMUPe7VMb/OW2x
         p7yw==
X-Forwarded-Encrypted: i=1; AKwUvBxtcDj0vdUbpTJ1dpYg82aoJUYAZcETlUHs/klMO3Q7eaEPSMSLm9fCKUIZlrnvf0QG8vS8BsO2@vger.kernel.org
X-Gm-Message-State: AFuF++kTST2kF+MSYOXzrYttt++2nhjoRMvcAHHtQIwQX6Qlv8vJobWi
	VSTwDnmin3ColEXwJEuPGmusimC00v2f/pDbqbJ0+zrMGaqWKDI2oQTfpALR6zd9MDk=
X-Gm-Gg: AYBFou1Ug26P5AqpXgecJfAxWDZtHPixYVUC/murdfI2bu7Ymas6mvkzfTpTM/qgi4T
	KT3J5F4+VqereIkkFc4w8Pb+S4D+VunUhNpl9RKfAzVV0SaCLVQ0f15UwJ92PNURXQcTObl8kva
	vrxNHNdkQQVGQgLKyo/yRn0Sqhd9dMB5+C5HsZ73Y1fJ0UptgkYfigd/Nb8IU9FlOAbyPn5EE1u
	4ZboFFfuL7LKjVmh0Wwlg1agt7wXot9y46ffGfQ5/A6QJij/FanKS9ryqS6evkNVPev4aNRK+MB
	OROO/lJ/OEFj+iHB5oOtkw5gJt2s+cBDDCNYPhgRv7uuG85RYSovP3F1ZxVoUECTpgZ9V34q+Wo
	7bw7HwHgJefooNVgddzRshPWM4z0Y+o80/5wIRJhfcVc39ZlMzvZIpg0aFsbXd/aN0MyjEOyK4k
	uhUuZqaHw0g0aFxZNDGm6r/z2IMH2n5juIr0ZhcKy7000OSpA2jPtHuwXFp+j7FUsRfRELr15YL
	an5vvk=
X-Received: by 2002:a05:690c:5705:b0:89a:63da:faaa with SMTP id 00721157ae682-8a45c8372f3mr11122287b3.101.1790172708255;
        Wed, 23 Sep 2026 07:11:48 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb3396f6sm20644991cf.19.2026.09.23.07.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 07:11:47 -0700 (PDT)
Date: Wed, 23 Sep 2026 10:11:43 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>,
	Gregory Price <gourry@gourry.net>,
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <kasong@tencent.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arPeH5MPDaD95aDp@cmpxchg.org>
References: <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
 <CAKEwX=NrN7-u7gnGvWX3qfHaBQcN6FKsFP-4-k76F=sxM1LJqg@mail.gmail.com>
 <CACePvbVuFULQVvi4UOrvKaJ-5kdWWU5iJH20gH-9nZ-6ZbEqMQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbVuFULQVvi4UOrvKaJ-5kdWWU5iJH20gH-9nZ-6ZbEqMQ@mail.gmail.com>

On Tue, Sep 22, 2026 at 09:37:48PM -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 7:33 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Tue, Sep 22, 2026 at 8:23 AM Chris Li <chrisl@kernel.org> wrote:
> > >
> > > On Tue, Sep 22, 2026 at 4:59 AM Rik van Riel <riel@surriel.com> wrote:
> > >
> > > Yes, I can agree on what you observed. You are using anon + zswap on
> > > that app alone. That is not what I originally asked.
> > >
> > > My original request was for the whole system: what percentage of the
> > > total system RAM size has been swapped out to zswap.
> > >
> > > Because when you have 100% of zswap out, it will likely trigger
> > > different kernel code path on allocating memory. You might suffer
> > > global memory pressure you did not observe in the single app memory
> > > pressure case.
> >
> > What does this 100% figure refer to? Pre- or post- compression size? I
> > legitimately cannot tell.
> 
> The 100% I mentioned above refers to the pre-compression size. See my
> previous email in this thread for details. I have been asking for a
> max(%) number in your fleet for more than six emails now.

Because people keep telling you that it's immaterial. The job of the
compression layer is to make pages smaller. It has no business
deciding what is "too much", what is "too hot". That's the job of
reclaim and OOM killing. That's the job of cgroup residency controls,
of things like MGLRU's min_ttl.

You have absolutely no way of knowing what a safe threshold is for
every usecase now and in the future.

The argument isn't we need a bigger limit. And I refuse to haggle with
you over what the precise value should be.

The argument is a to use an xarray and keep making pages smaller while
the policy layers deem it reasonable to do so.
