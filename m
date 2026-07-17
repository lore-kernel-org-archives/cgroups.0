Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012C33E274C
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 10:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784285582; cv=none; b=eOusiUAJde1VWY94CzfaBfja7V42dkCGyO4olOEsiP5fYikxl3svhc7c+JXnkGp8doq+EYvb8P+Lf/V92rgkvnI66fNYiH0Hi/tF4BM6NHML9h8kKiIYq+ZJ0AHlOg4762BSLIRrRn1M3WWTGjCDvCj2S+PKe9Y4Tf5LyDGWF5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784285582; c=relaxed/simple;
	bh=dcBQSrYE16ORzLsvX+G93dPmiXECgcXvhDGMJ204jyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oDMxf1QHkDz1AHm4t2BS4dUxgUSJ5v38RrwM07zsx9L20uMy4HxRd+R8MTWfcNW2SATccwxZCF3hjpQmLxqR//m6lMvgI7H2DoEx7XbqgbjKv0tzbNfwlOvD5DCgjszJv7zlwL0YOBC8bciBaF+X3cfSDKPkdFKHcrXrL2TJguY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=ANaT5PU+; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="ANaT5PU+"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so3059118f8f.2
        for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 03:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784285574; x=1784890374; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1MCALYfAZM5Wgl4MTnbWAugypRriUQ0nj40l25fPONA=;
        b=ANaT5PU+CtT/GOw4zC+VrGO6/++Qt8ixyIzHiHS1SnD41EryRyllzssKpJ7zIZPvXr
         J4kn4LU0AoT7CAx4E/xwHhP4T36fQS9wUIlN+4CSQJ328nNQ5OEQXQQ24Fk54i3VH/C0
         v40Rtw8iVLGsfUyAAr5OnB8+lRNWpQeeO5Ee5N0WhLbl2BKz5T9ZpLPqjAoyL+jnaDJg
         Y+2+XhWogJPB2XaJLNbl24rw6k/e+6f3u0dbhC0Q3Nt017DwTSJbWrpwSL9XmP/pgjR2
         ljZ+vaS5JMIs5/FyvJcsLsl/D4HUo25Ch9wjURUxrDdDbjZiZYthOwwuQL8bSd/AbUFJ
         WIGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784285574; x=1784890374;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1MCALYfAZM5Wgl4MTnbWAugypRriUQ0nj40l25fPONA=;
        b=tUhBM5fHAd5i5Ko2OtyLj62jQW1HzuS1lbW/fRh0j9+XnURdC9hLyPn5ctR44Vtags
         G3KKjhxUchfQxPB/p90OTB7qMUpcH74VUxjZ+O7kCtExpgsjy8dAWb2D/MFV3zJjeCgT
         IHJU2FCoK71F3D62685aTvc/Di5wQ1cTL5iadAEALE16MGL+4fG8PLq+0xZzyRvgORZK
         Y8dFeQbVHBkP6mztOjtphqxHi5umqeANtcvOXU7gvSkaptzZAYQ1Rj7bYAxSd25IB+xZ
         0dBgx8Agy5+UWyNNH4eaiQOG3FemE8/vzDqREJXhQdG7NEQA+tQCgsUKr89m7KD6iVqA
         iSEA==
X-Forwarded-Encrypted: i=1; AHgh+Rp6PvTsoiN89ED3EBQdgpJwIvN+fh+/+pc566gFsSFKzb+AaM2p7DjaCIoDu8YA34BUGJjwzcfh@vger.kernel.org
X-Gm-Message-State: AOJu0YzE4qar2i0dP74DXxE5c8fN2OphkDHedITcuH3CCdV1jeM+3PKV
	aN94412kqfOaGltmiz4DzrBYZ8BBBETomW0SvuIXWY3y0cn2O3Ncbmf6YCehK2XSeks=
X-Gm-Gg: AfdE7cnBohczvfpS2DuqGVxbc7DNeql57QFgm+2UL/mQnBq7J+B+wk4164X7Oh1bAke
	7nJuAM93BJZtgDdm0klD9xHC1Xs8vRQlLBfmvC0nAtpBJAkWB45iWTfjTPvfhkfC3pQ5OP4i1pb
	v+rol6T/fHNrf3Cvi1SdDnDjTNN66QQ0BLK1n9GF4Y+dgzyHTEVfI3LTFsgfEVF+CSL/9jQP95c
	O934LC3vxJWwzkpBTm+ZUh6105dw7P4qWFVKUeoZzQTfMTVgH0voLgAcsw2eRsLbJvfVWweJhQW
	Z1qwBo7mdm8c/Ie8xbhd+jH7J7oBq+HB8ot+0aK4XadY1JS4T8eXCBAfIwKcNBAjdi2A/zQebxL
	6G+PKPlYg/J6WPVvpT68nDk5djSn988SiF+Pjj06LI4vEVVQDM/uZRPqclasnAZbuXZol/769fF
	w=
X-Received: by 2002:adf:e192:0:b0:47f:5710:8cad with SMTP id ffacd0b85a97d-47f622f2a3fmr2694330f8f.4.1784285574335;
        Fri, 17 Jul 2026 03:52:54 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ec7ea1sm2618713f8f.24.2026.07.17.03.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 03:52:53 -0700 (PDT)
Date: Fri, 17 Jul 2026 12:52:49 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Breno Leitao <leitao@debian.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Michal Hocko <mhocko@suse.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org, Joshua Hahn <joshua.hahnjy@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v2] mm: memcg: initialize *locked in memcg1_oom_prepare()
 stub
Message-ID: <20260717105249.GB6843@cmpxchg.org>
References: <20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org>
 <20260716173949.0f87d0ab30c5eecb01067fce@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716173949.0f87d0ab30c5eecb01067fce@linux-foundation.org>

On Thu, Jul 16, 2026 at 05:39:49PM -0700, Andrew Morton wrote:
> On Thu, 16 Jul 2026 06:42:18 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
> > mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
> > and reads it back in memcg1_oom_finish():
> > 
> > 	bool locked, ret;
> > 	...
> > 	if (!memcg1_oom_prepare(memcg, &locked))
> > 		return false;
> > 	ret = mem_cgroup_out_of_memory(memcg, mask, order);
> > 	memcg1_oom_finish(memcg, locked);
> > 
> > This relies on memcg1_oom_prepare() setting *locked whenever it returns
> > true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
> > CONFIG_MEMCG_V1=n returns true without touching *locked, so
> > memcg1_oom_finish() consumes an uninitialized value.  On a memcg OOM this
> > is reported by UBSAN:
> > 
> >   UBSAN: invalid-load in mm/memcontrol.c:1932:27
> >   load of value 0 is not a valid value for type 'bool' (aka '_Bool')
> > 
> > Initialize *locked to false in the stub; with cgroup v1 compiled out
> > there is no OOM lock to take.
> 
> Thanks.
> 
> Sashiko, as is its wont, reminds us that we all suck:
> 	https://sashiko.dev/#/patchset/20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org
> 
> Does this potential memcg issue look legit?

Yes, it looks legit to me. The task is meant to be put to sleep after
this until current->memcg_in_oom is cleared. But sleep-and-clear
happens on userspace resume and there can be multiple allocs before.

Is it worth fixing? It's a deprecated feature inside a deprecated
feature (6df4ad704707 ("memcg: initiate deprecation of oom_control"),
August 2024). Maybe we just ought to delete all this...
