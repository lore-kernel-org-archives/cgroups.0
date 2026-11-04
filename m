Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793835164;
	b=eqp/ZdYEa3DWJEaKL/V5CIAze7KvVNbK6LfhSKz6ourTD/fQMbHt8h+5wuMNVu4PGSrX
	 5utflL6yXHhNoMku1r1sn3xmZ8GCNes40DAVn1HiKJCDV2uPcllxPZ/h2KephhWqeurbH
	 BU+8ts8Im90yqIe3Hk+iQaBwpS2yYHO736LAE/HemdoK1orae5LcgqektLLbQH5bjMCbk
	 MV9/8o1btm98VLdMDThhNhdQU5R7k9Z4uiBgMSG/TgeSKETZcxg5qwjv+ZWgq2gYgPAAg
	 RUveBaQVQiF67/m3puQOS56whyIOoNaOahVUGVHq95kc/loF14X1oWH/a1+m/Mr1LyA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793835164;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=VkjyCgRLiyyLNFM8olRCBV6HjItGRbYCTvwNvN8lDwU=;
	b=oQeky81bMUAL+yV+7i+xeLPrYAnJDTgBFf5DLrQUq8pu9fukjSuqwQgdbqlnPCrg3/dH
	 lHJsJo5FAW2cANlYB//14/rKdw/uxuY+rvRcrgYBepAjGzvNlgbCv07CEp7kniudWEImy
	 HZL4BQnZ7lc4bSKSIu+l+nj+puRSRv6W0IPWzmXoIqnfIUE34N4Ah/AwJbxLWjBORgBt6
	 fp9y5qZjDcxz/0aCy3X+vSQ78rJ5HKhhzuBL8t96hvYhJh+7lLDAfl7i3AuvO3OCgTQlo
	 XIRsBWYdr3LAAW6RYN7MeKCCC/x7ghYqweusgBiZfzdc2945BYNikaUBqmF9fO2/MBw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Y2LHCCti;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.49
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CB3606A31B
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 23:32:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71CB3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Y2LHCCti
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-15dd124bbe7so124695c88.1
        for <cgroups@vger.kernel.org>; Wed, 04 Nov 2026 15:32:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793835163; cv=none;
        d=google.com; s=arc-20260327;
        b=dVgNdCpn6N5lu8jUDpJIDyNGql24aDqErUzNQKKRb5vFr/LcpGuepjiplTB5gI6C/H
         Avy5nVooFSO6fvZJARLerP5n4eZWNDcfI/0WO9EY9sIrh0Hqerfbq/rwSguUAZiFNGpf
         +pfXABPr/IYRflqhhfssrgYC4pURhXbSryvKdHkERMSPu8KaLyrStViZt3docWqaUibR
         kZLDy3xd/Rhz9UPN0C/ZQ5B7IRYs7O8r6mt+ugu2gSmteVw2RUnxuVFZ8CVaVmfgMa4Q
         GUiyYTLovoanqkm8U3wINeJyrrf5alZz6DG8Zy+je/LC7qncchsR8dLDfuTauSlyFvu5
         28bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VkjyCgRLiyyLNFM8olRCBV6HjItGRbYCTvwNvN8lDwU=;
        fh=mkHc6SBhrvCXs+91T7BZ3KrBeYnZhlzOk75DLm4ReeU=;
        b=mxgbjaQcOsdhS4PalIG6AJskebqKwaWBu5KaJCc19cx/QCq5F4y4gSpsrgPs48QN6j
         L1pqE0kK6nDXym4a8n08OsMB2uu7htVyF3QNrrJKIqjUn+zSprR/xTjlgHyrDzObVmip
         hrBbe00NLUvtUBBymBNWdupD3eqx/oZgMhXuyIlSRM99TwbnQgKJH+i8hY+tNa4GQedF
         v5u7DSuPC6XhOe5rxaTE97b+F86d/tytQ+NtEfDN4VdxfAbFgjaP9290BzDHuosiLhe/
         QJD2mYCc8WQwXID00f/72qqEDKQNbTet3kyCkOybmdy2190KcLwP4xsz9zQR/Dbt1OH6
         iZBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793835163; x=1794439963; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VkjyCgRLiyyLNFM8olRCBV6HjItGRbYCTvwNvN8lDwU=;
        b=Y2LHCCtil81kw9KOsNT5+65Ji3XPl4n2X1Trzvs4RT2zVKyna0zlVd5UFSlDt2YX2I
         2wf5mX/SwOQ4eQskSLS4PlqQU4RQxsdSqFgB8llCXhCpoGr8Z2iHoeZE7s6qiKtjedAP
         r1FGYbgNkd20Fvf4JQNJfKvhLd56cF3G3/q/fkJ7D3YWQq+jKquFUjeg7xG7/Yn9+R5c
         WV6oBQOCOWWAQIsuARduDaEUsq2IzmOObV3SaawfSko9mFk62XYN00iIu8FijS3ajwTA
         cPlmPoqOLVOAtawLEN+3u8C2bTEm7uamAs70bg6kLqc8foaBS84Rl7ALVKHwF7Ddclkf
         ScJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835163; x=1794439963;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VkjyCgRLiyyLNFM8olRCBV6HjItGRbYCTvwNvN8lDwU=;
        b=WZPBPZtgsmpjzVfVdS2nwOzJ1WZ9qWtJFD+lbz4v2vaejudIbkj3bQR90IXnIyTIcH
         XEhaJor7ERrEABrfKSipEn7jkA1ry9AGsA5VBFJ/cCWrs1wfQA2lhokBN35b4SAirDKH
         Z7/S11iFFn0THy8M6WHNvJruJJD89iqRoXJ3AFDSqsY0D1yIRnGPntDjbDj0p690j7vo
         8asa9Eu2yzSsbOu/gUhCIPawD4ertLQ4pWYFJAlw5sng6tzd154+TP1uL1WppJ9Ug4e/
         3/q5yrpytrPopVsLT7rm6KAuasRjson8iwYJm5x4L6EQc8t0NDOBBiErbSN91ccuue+T
         RGKA==
X-Forwarded-Encrypted: i=1; AKwUvBxR8+cwbPRA3u1IS9DIEhvGwwAVsxnpv20b7jxQMVl6gztDnP1eL3FkwYJxWqM1uVA07Thy4UoC@vger.kernel.org
X-Gm-Message-State: APuU4Z88pGcwV5cV6l7SVPYnbrMGLc7wad9aki26jP4cjZiv+MlA6Ulw
	6U26HzHlk93AsJHxSCorrszqT/PzHikhQ64JcvffUePryrNxd6dMYqP2Wmx04PDMA1rrmcqkquc
	psBvTmd25jofYBf2ThrSAx67L5mVncaj+dCtAciAv
X-Gm-Gg: AYBFou0GqmQ+FJFL+zR/+tULdKPYLBbI38UP7+oTrAphUrtPwtT2u79BQ85n+VRFv0H
	eKzDQuz2NJx2lzv+DlNa7K86+vqHFBzbY61DxCQXKfuesKFPbq2IdDckHV+7vvCK8H0MXQctgvF
	rnkcJ0m5ig3T21/VPKBpHuD9y1tUFjdc9K8aUDJ184WZZW8Lz+XZEJo/qIrMVFJrfofyaiQCtbx
	wVShCwU3eipwt3FxNEGWcSG1h7i96bgJh0CbVr8Zw78Nq2IEvZ6GYxtB3OQBVMownUaw8ypH5PY
	uqWxaQr/bJyXSpr+1Sj4F/55cf/2g71YZVg3MK09J8jMw8s6OHwhsYX3oc00ZNFC3q/7JID5SVg
	iSBAK2UtkGe4oy71wblYKcXeLVx3YbssKd+TAz5AoKuJxz2MlKm9/iBLLy1+FqS80a/GYU5xSQY
	Bc9qKzahAUF7HYGGjkPHoWl/08e4DtkPTYj1fFzwOPi7KVat+wnA4yynsU9SWJZeSCV+DiGb1Yb
	QxbKH/knA==
X-Received: by 2002:a05:701b:454f:20b0:167:d73a:e994 with SMTP id
 a92af1059eb24-1ac5ac4f0b9mr27337873c88.24.1793835162463; Wed, 04 Nov 2026
 15:32:42 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029194452.3189365-1-kuniyu@google.com> <20261104150258.56cf6be2efe442cdf5ff8da1@linux-foundation.org>
In-Reply-To: <20261104150258.56cf6be2efe442cdf5ff8da1@linux-foundation.org>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 4 Nov 2026 15:32:31 -0800
X-Gm-Features: AclHuK8qPYiofzotxpZJ9SgyNdpa7WFtAeKrxFZ9YkpLUqaZkq8IFOxN9qosUfM
Message-ID: <CAAVpQUApRZ=Mhm0pmZ1EEvAr=87d7pEsz-uMzjqneeMzC6EJQA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] memcg: Misc cleanup and perf improvement for TCP.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 3:03=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu, 29 Oct 2026 19:44:11 +0000 Kuniyuki Iwashima <kuniyu@google.com> =
wrote:
>
> > On host w/ AMD EPYC 9B45 128-Core Processor (Zen 5 Turin,
> > 2 sockets, 512 vCPUs), tcp_rr w/ 20000 flows throughput often
> > degrades by ~50%, 32M -> 17M~27M.
> >
> > In the bad case, the number of involuntary context switches
> > was extremely high by 12x (241733 -> 3093367).
> >
> > The root cause was that refill_stock() calls memcg_uncharge()
> > or drain_stock() while holding memcg_stock.lock.
> >
> > Patch 1~3 are misc cleanup for better asm output and patch 4
> > moves heavy operations to out of local_lock(&memcg_stock.lock).
> >
> > This series removes the flakiness and gives ~3% gain on the
> > 512 vCPU platform.
> >
> > In addition, on machine w/ AMD EPYC 7B12 64-Core Processor
> > (Zen 2 Rome, 2 sockets, 256 vCPU), tcp_rr w/ 10000 flows achieves
> > 36% more throughput with lower latency.
> >
> >   tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):
> >
> >   Metric                     |       Baseline |    Patched |    Diff
> >   ---------------------------+----------------+------------+--------
> >   Throughput (RPS)           |     20,884,499 | 28,453,051 | +36.24%
> >   Latency Mean (us)          |         478.46 |     351.07 | -26.63%
> >   Latency p50 (us)           |         453.96 |     343.04 | -24.43%
> >   Latency p90 (us)           |         669.00 |     479.57 | -28.32%
> >   Latency p99 (us)           |         969.38 |     593.92 | -38.73%
>
> Thanks, that all checks out here.  I fed the series into my
> LLM-controlled live kernel testing setup.  tl;dr: no correctness issues
> but the performance gains on this setup are much more humble.

Thanks for testing, I think the number depends on the CPU
generation and the number of CPUs and NIC queues.

The last number is from Zen 2 CPUs with 32 RX queues, and
the result was consistent, while on Zen 5 CPUs, the final gain
(+ no flakiness) was 3~4% as noted above.


>
> Gory details for the morbidly interested:
>
>
> : I tested all four patches before/after on Linux 7.4.0-rc1.
> :
> : Correctness testing used a four-vCPU, 8 GiB Debian QEMU/KVM guest
> : with KASAN and lockdep. Both kernels passed all 22 memcg/kmem
> : selftests, cgroup/socket churn, guest CPU hotplug, socket lifetime
> : across migration/cgroup removal, and payload-checked TCP transfers
> : under memory pressure. Final socket charges and dying descendants
> : reached zero, with no unexpected kernel diagnostics. Traces confirmed
> : stock trimming, eviction and fallback coverage.
> :
> : Performance testing used 56 guest vCPUs pinned individually to 56
> : physical cores of a 64-core Threadripper 3995WX, with 32 GiB and
> : KASAN/lockdep disabled. Host and guest each had one socket/NUMA node;
> : the guest exposed one thread per core. Neper used 10,000 flows and
> : one-byte requests/responses. All 24 runs completed: three 60-second
> : runs per kernel/condition, with alternating A/B boot blocks.
> :
> : Median throughput changes for the full series:
> :
> :     Workers per endpoint     RPS off     RPS on
> :                       28      +1.21%     +1.38%
> :                      128      +0.14%     +0.72%
> :
> : The smaller machine likely explains much of the difference from your
> : 36% gain. Your reported systems have two sockets and 256/512 vCPUs.
> : Here each endpoint had just 28 vCPUs backed by 28 physical cores;
> : 128 workers oversubscribed those CPUs rather than adding parallelism.
> : There was no physical inter-socket traffic. These differences can
> : reduce shared-counter contention and the lock-held interval behind
> : the RPS/charge-fallback/ksoftirqd amplification you described. I
> : exercised stock and RPS paths, but did not reproduce your collapse
> : or establish comparable amplification. This explanation is plausible,
> : not demonstrated by the measurements.
> :
> : Three conditions consistently favored B; 128 workers/RPS-off was
> : essentially tied. Frequency was uncontrolled, limiting sub-percent
> : claims. Both kernels had VM CPU-feature/watchdog diagnostics without
> : an unstable-clock message, and softnet drops with RPS off.

FWIW, I tested it with RFS and on non-VM.
