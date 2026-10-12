Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6A2448CEC
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 08:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791793079; cv=pass; b=qdTZ6mYD+8EC8yT8+M0cbzSY/m/r2PYKPXhUP9RhVEJhV3k7+zcFiVEW5FCNyFn2QMypSES8fUFRu5o5sprKf7qZT+8cHQnzyv8mmgKVTpgKMa5k1Afkqm6AaCMx4/RM22srbQOJWtMIcnlZAmgE7CtLSAYAm3Xzzqmb8JxADwo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791793079; c=relaxed/simple;
	bh=1GLLejLzmf38Sqpzl/J1qn5yJLV3HZP8rb7jIFgq2Vc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qBbzsGIjrjwlULZwgHqK6umszQwANUOOWJ0soKMnSdkk6XFKSvC7ra1x4l+3M0Eh7DZW0Gpd/m6rv5MeQ5XxXOwrqdg9IqZ6f/LbSksI5VwqQytdWr7ClQeMTrOioB8DKSXjb7si4aGT/mBzuGSoJngr0aBoouh/3Gw4eN1Qwgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=ZDd4GRkQ; arc=pass smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="ZDd4GRkQ"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-30b6dad2382so3766666eec.0
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 01:17:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791793078; cv=none;
        d=google.com; s=arc-20260327;
        b=mpkmxEQZfvsS+pIINKjqSsxMq0ZF1vQVQA8Gvay3ZeyBleOvPEIk2aUPvASNSrK1Zb
         buPeiakmzeulrrpZcYBRd4sFlVn8DSrJGyqQjKqFusDTDa3Mrxs/fIeXgbsr19Pv81eS
         LD254+VO7TwpycXrdOYuVt50Lp537dnIpYb0dIXkYZYlyMvygSeArPLBaVoc9j4ayvBo
         ftJmHSK19ynGPQ8yDNPfWijB01K99U+KyVEAz8h9r7H7cLmW0fO/VVrnD3j6h2YfalKX
         cABqUJxrxQeDUQDYh/ERlZ+uBiOmPPzXsFKVvikoLR6AmSK35AsRLmcZ4KiM16Hxm3xR
         2z2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9Dd4TAZB19XGjWX3ZomXrsadjEIedrZeOBjDL75jfIE=;
        fh=0XKS7uGyXWPWA5td55zHdD9zMGmVhUpIp6uoeRt102o=;
        b=IxfHGNfIeRglOySOSvaRXgCpqsXmRTsa4Wzq1MmwfTKnQkthjALLg79mZphiVzjvK2
         mFfdfG1RleLHzwIo9HNH/H3jcTYR/enGtUwvfjjQStZvuneopwdNoK1IPm4pQNNSwhwI
         0OhOk6zvSrRinCWpx8RCBcQd3G8XNYukbU/cDzGFfP2pMxyRv5S6khfQk4oOO6pPkiLM
         wPukj3gt76PR2ddt9f+9o9dRmMSb0gi/Vutiav9lzvZPS1Dy3S64JbFhK3vbQ7Fnh2vh
         lnpNuuUIdMfTexl3vUFWPgHNfxXmpxqh4pvYvB6wNGm52txpfDN7IjIfXLwPN3cqMfhJ
         CZDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1791793078; x=1792397878; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Dd4TAZB19XGjWX3ZomXrsadjEIedrZeOBjDL75jfIE=;
        b=ZDd4GRkQlr+cV2bZlli0MKa/uFLU2ghsGslO1Hg2wxhjtJjoK+re0KjPo6MeivTaVv
         8RWOEGa7LS4jHPM990Ls5MHaK1OldubIiPigS47fRYHIwWf+imiS9biO58axwmZJoOob
         4t6dXZ5Bc1+RTWUUXl4zrQj0h2Ql2s2/t5GYcgok+Z1g78tDU33KD57ynQADbVV4+3Sf
         NzPSZ/mfCOwGhKiOTBTa5wHmE8ztD6WiRwXztk/dyptbzTvDN7qHNO16tvK0a5eHFv4P
         Cgx6/MdGhkmX8bga6Hw19GVes9xX7OMwdxzY+AbP1ruj2P8sXsiH3nw2LAu8x3DqtRgI
         OOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791793078; x=1792397878;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9Dd4TAZB19XGjWX3ZomXrsadjEIedrZeOBjDL75jfIE=;
        b=LkQfbaMDhUaI9z2erboLMelzQSSJwYBpccvVaJEoPajlRlnDbqLMPwUwkAGWxH4XJJ
         cf0k6skgqas2Evo4xAiVGRioUya3glQGWfdMCLURHIUyQq7F8yJ7rM3/47xo239cA4Bh
         nPfLVUhnTXaaZvPpKIvVrPDFSxMSojn2jj7zoa5s86Pgm3gnK30Mpn8/94iYqxftqnlS
         vVXa4AVm36NSy25QIanAv2vZgim19lQPRpsnHEU/CXZdw8zgNFcwSHyo2BOjZk/8/9r3
         JVpYhgxcj0fQ50i13LizB9cAQ2c/zj0hcDRX5fw5lZecMW2sPzuTiZZIlO42YsA3mMF/
         9BMw==
X-Forwarded-Encrypted: i=1; AKwUvBym8jliUmCiHwzvfW6AVec2oVCs+gfjMXNYoiou9u2/q/42It+UH9Jz71VWqNv1lwh9ovXiVmKX@vger.kernel.org
X-Gm-Message-State: AFq9FYKEKFBu96Rgcw8hrDfymojmS+aAU2T5sL6UgyoSDvKU2lvhrCZt
	wiRYDuV4CwXwcSDTVfvxHGAmMTTcoOkTAPwUfsZdM1IxL7LCsZeCBXZDUOqtu3HNg9JzFA0Ep01
	MQDLHt/UEQF65lRYNRWrPwC26EQ2me4bLwcaz6UrtM9l1b+C9nbieFKcd2WA5
X-Gm-Gg: AYBFou0hSh/XRdLxw8G4kSKUZqLsZIDZbMyu3vTekIct0V/fnReAh+BNTV8XSMCOdpH
	dlT8yDtVAlrGn+GipBEut77MR+Gz8g0icY/bOsOis5+TXayB5SyrOlq+/q9hVhRzBAyisCs3AWr
	NpXKRFgXVAYD86Fgj24sQLdPu1HD/j+6AndFfCV1OkaRvalMHvh3tAkHNJdCZQh/wpwSGtuGtCI
	MCqFiqVzKfxFfAY5z8mGiqK3Jjtox26XHt0CQMjErWeWEsInJOP37Ll1jJQDtqlS7//oIt9Fd1P
	nWq02NwDlXseQ8DUu0zOv48qLDGUDiFeBLaGRFDpr1DYmYtCZwH8tGw=
X-Received: by 2002:a05:701b:4305:b0:149:d501:b990 with SMTP id
 a92af1059eb24-16a5f3f191dmr9983232c88.25.1791793077611; Mon, 12 Oct 2026
 01:17:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260911032905.63683-1-mingyu.he@shopee.com> <aqRXqcynCx88D2QK@linux.dev>
In-Reply-To: <aqRXqcynCx88D2QK@linux.dev>
From: Mingyu He <mingyu.he@shopee.com>
Date: Mon, 12 Oct 2026 16:17:46 +0800
X-Gm-Features: AclHuK-_Zx2LzZN02tzISzVWGha4IvMdOMWo2JFUzwRP2aZsF1MCrxc-_yMLwpY
Message-ID: <CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com>
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	littleswimmingwhale@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Shakeel,

  This came from a reproducible workload with a custom in-kernel consumer,
  not a conjecture or an AI analysis. I uses aggregated file pages statistics to
  decide whether reclamation is needed.

  Tracing showed leaf stats_updates at 6656 while root stayed at 6144
  (the threshold). Further updates stopped at the leaf, and root flush
  requests were skipped.
  In one reclamation check, memcg_page_state(leaf, NR_FILE_PAGES) returned
  about 2.64 GiB from the aggregated statistics. In the same invocation,
  a bpftrace probe sequentially summed the leaf's per-CPU NR_FILE_PAGES
  counters and obtained about 6.58 GiB. This sum was not an atomic snapshot,
  but it exposed a large discrepancy with the value used by the check.

  The periodic flush does restore progress. But issue for this consumer is
  the missed reclamation decisions before that flush, not permanently lost
  accounting.

  Regarding the BPF interface, the implementation in the tree I found is:

  __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
  {
          mem_cgroup_flush_stats(memcg);
  }
  This bpf function still uses memcg_rstat_updated() benethe.
  It doesn't handle the issue.

  I originally called mem_cgroup_flush_stats() before reading the counters.
  After observing this issue, I switched the consumer to css_rstat_flush()
  on the relevant subtree.

  If waiting for the 2 seconds periodic flush is acceptable for this
function even
  under continued updates, I agree there is no need to change it.

  However, the comment in memcg_rstat_updated() states:

          If @memcg is already flushable then all its ancestors are
          flushable as well

  Concurrent counter resets can invalidate that assumption, as the trace
  shows. If the early exit is retained as an acceptable trade-off, could
  we update the comment to acknowledge this and the reliance on a later
  flush to restore progress?

  Thanks,
  Runli
