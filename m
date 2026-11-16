Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867732;
	b=dcQYKbUpJX3ujRAjIuHy9umHuT1L95hz/KThy66Dn4vY+tDRvbf/C8aRQGaeGOiUg1h8
	 FRg46rEsRhK8f61YZ/nOFFvT8WwuxNf1nus0zqLWphaUUSR1T995kmi3ZIiLvrztOQU/t
	 e2zUef/VJ3YxToaXrwq23bsUHt1mN2L6s29QG5BJka9xLO+UlLOIpN1gTm4W+2zuRv5q8
	 DM7hrTyfgsn+MlX4l336ti4WG9liKY1eUuzbNU2olxnO0e8tQmJVT6YqgWP0BEp4DECNw
	 okCVM9j42E1TvdrjndACZws8LzqsDjfFz3bxi80dZppZcJPG9ggm5L85sr8ul57icQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867732;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=pMSexfhR541OuPmIYjYfQMR9TxRQH7Bx+m2xGYqk6uo=;
	b=N6MbuoZiEmoLkMtOKyXyrwrxg1+yf0vvLnYfgV1rY87W58xHsLYPaHCwisyvMmOj/6ER
	 s51zHiNd8aVOBpz/Xi8zhy42RdeBFSKBlk2JPE1EVY4cd9OKuqVibv/ij6PKjcmqef6uz
	 1iEujWZ3pTiZcf09VmIWM/tdAo3rAegs2zi7plc4FKzaxYdSO3qxJvXtP0iCU1WmqCxj0
	 /tWZbR+JXox0eMk8JykWqV2HeAqqlyEgC6kYmON15EWy1uRc7SHc8u7uCCYvP8m7GQFmE
	 Lul2BA/rlcMmdXRA1KBo7MJg0UATRO3++LFZEtQh4K9L71tZqq0h+xmFfSAxqav8EOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E2Gy8x0w;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A007C606A323
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 22:22:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A007C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=E2Gy8x0w
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a210470b49so32994845e9.2
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 14:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794867730; x=1795472530; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pMSexfhR541OuPmIYjYfQMR9TxRQH7Bx+m2xGYqk6uo=;
        b=E2Gy8x0wrzC0MIM4AoYyWVyIZTUFSoPodZj3PdO8OpmV1TcbgFIOt3SoxxQXkTO98k
         BYKL8cFfTORRhodtxT7jI3jdebBaXuRy8BN6SqJp5/7cog6Fmd8HbhzcU/0uKZaSYvCJ
         3tCQsrZn9AdeD/+iz6D+rAr7AaWuYhqRRLgkQZamyQrOfOU/jx44DxCRmeE90DyPyMhX
         J15FwUiiMnOx5xdnwQn+HyQ8BtUXK7zKWtFiu12nrfq8h28aWwtQ/xZSLr+h9nZK/Cao
         Eyqbu07sagw2krwlnQxGgJNrfAGDwKVfTmYnQaglei74ThH057E1pReEjQcHB/fCS6X3
         g37w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794867730; x=1795472530;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pMSexfhR541OuPmIYjYfQMR9TxRQH7Bx+m2xGYqk6uo=;
        b=sviMJ+fWjI9Bs5F1ocO9tl2oqPTL2o+21iz/fFaFmqwPF5yIPdPnpey8c667sD7+h6
         1qUGJNXlF14eIPBiDufnZlhDQX8z0pkH7gfkUWE8oZKHpGyF3g1iZbRb9wP0mdWgYW0q
         ISdUpgOdfNZrj74AO1h8ahmVaA5nD/xxvFB6FQf37AKtt6GJyt2Nw5lYF9DvwyGiU5Yy
         um6dsi+ETUca/Nfb4aAt7YgtV2ZzDJNfv+UAATiplH1B/fhyUq3nG0D3EGzjD5zAdGWN
         dduV+Q17XdcxTPfkMfeqs3R5ayB06T2Pw+3I6sjVp/Ag5KlWLG68ee/HsvIFy7i0HCj7
         w0MA==
X-Forwarded-Encrypted: i=1; AL+hErHcv/bxGY4ymKh+q4hSb2ADzGMPgqa0pwYQ+ddKMuaRRAhUS8LyxFsr2x3x/rmyDj6xw0l9JabJ@vger.kernel.org
X-Gm-Message-State: APuU4Z+uztB4Ts8+n2OnJkeiFuUCRbsLs9Qw/whFi2ODmpaqU3hJ+6pW
	eyueym/lTIVahQ1oIWjG07VgUfnIGwCC+HAAYwOaujFyevioX5YG5r4a
X-Gm-Gg: AYBFou17KyKD24UFEpsdX0xI1jZdqfIIUNytOKhWhwYgiWLoAdkMW3Uj5OTY0CtIrzp
	bKlbFNDYvyh5pK1nBjYjMb/lsKkEI+SghFzJ0kQS666+6ytri+WeCtcQhGP7AL0NBACAYOEjofJ
	LgXvS/hKZ4okn+CvcjoagB7hyK3Lgtfgr56CkULYUh2UoVAqSvdrEgJ8NQPdlchbE/jWpt3crq2
	9tGe7B848o5v5cRTaugzMhfF/2uo2aDoD2MrYVPOw9l4+qWj125En5MSDGCqGBWjJgcdDywS0mM
	870iLULTGuc4WxzEJqjungwvFm4TiO7FGTAafyWOCMMdAvWxZ26Dbni0B3dbs2nc8Wc0a0EV71T
	4zjdgeq8/G/M44W4SjWtUaMpu3WwE9EAuuVrAtQ3A+nxCA4SyfiBTgcMGULuxfcq9X1CroR7g9U
	E4b/dToP4pLBhu1vK9rqXOJPzAA3xJIy08UvroAtHqOKaagEWDcXLVtDzmHTfBdErHk1mRyevgI
	XVs4C0wTR3w7XrtGy4voCgBomIwdB6BAuaPgSxJr6R6m+S2zAwx+cjXzPZgxKNPGlQQIonRZixk
	qaB/OJpG8yx1eTaLeT20i3Nct9M0v+Vmy8YztWVbgKYXORgwKoH0oX2kE6vJAm3xLHAo7g==
X-Received: by 2002:a05:600c:548e:b0:4bb:6a5a:782d with SMTP id 5b1f17b1804b1-4bb6a5a78demr119774955e9.17.1794867729993;
        Mon, 16 Nov 2026 14:22:09 -0800 (PST)
Received: from lima-fedora ([185.184.13.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb783862d6sm17255175e9.2.2026.11.16.14.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:22:09 -0800 (PST)
Date: Mon, 16 Nov 2026 23:22:07 +0100
From: Mihail Mihov <mihovmihailp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, longman@redhat.com, chenridong@huaweicloud.com, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, 
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jstultz@google.com, kprateek.nayak@amd.com, qyousef@layalina.io, 
	regressions@lists.linux.dev
Subject: [REGRESSION] core scheduling latency with idle load
Message-ID: <avt_mdiPQ5gwAisa@lima-fedora>
References: <20260605105513.354837583@infradead.org>
 <20260605124052.227463677@infradead.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605124052.227463677@infradead.org>

Hi Peter,

I was running some experiments that co-locate a latency-sensitive
service with SCHED_IDLE batch work in a cpu.idle=1 cgroup, with the
service in its own core-scheduling cookie. After updating to 7.3 its
tail latency got much worse. With the help of an LLM I bisected it to
85570f10a4c6 ("sched/eevdf: Move to a single runqueue") and reduced it
to the script below. It is still present in v7.4-rc3.

Reproducer (root, SMT machine, CONFIG_SCHED_CORE, cyclictest):

#!/bin/sh
set -e
mkdir -p /sys/fs/cgroup/be
echo 1 > /sys/fs/cgroup/be/cpu.idle
trap 'echo 1 > /sys/fs/cgroup/be/cgroup.kill; sleep 1; rmdir /sys/fs/cgroup/be' EXIT
# one SCHED_IDLE spinner per CPU in the cpu.idle=1 cgroup
chrt -i 0 sh -c 'echo $$ > /sys/fs/cgroup/be/cgroup.procs; for i in $(seq $(nproc)); do while :; do :; done & done'
sleep 1
# p99 from cyclictest's 1 us histogram, overflows (> 1 s) included
p99() { awk '/^[0-9]/ { h[$1+0] = $2; n += $2 } /Overflows/ { o = $4 } END { n += o; for (i = 0; c < n * 0.99; i++) c += h[i]; print "p99", i - 1, "us" }'; }
printf 'no cookie: '; cyclictest -q -m -i 1000 -D 10 -h 1000000 | p99
printf 'cookie:    '; coresched new -- cyclictest -q -m -i 1000 -D 10 -h 1000000 | p99

i7-1185G7 (4C/8T), vanilla kernels built with the same config (Gentoo's
distribution kernel config, HZ=300, PREEMPT_LAZY). p99 in us:

  kernel            no cookie  cookie
  85570f10a4c6^     54         59
  85570f10a4c6      53         3695
  v7.3.4            54         3276
  v7.4-rc3          53         3290

I also tried the two cpu.idle preemption fixes under discussion [1][2]
on v7.3.4; the cookie p99 stayed around 3.1 ms with both.

Changing cgroup_mode (up, smp, concur, max, tasks) on v7.4-rc3 did not
fix it.

On Fri, Jun 05, 2026 at 02:40:20PM +0200, Peter Zijlstra wrote:
> @@ -14893,30 +14803,8 @@ bool cfs_prio_less(const struct task_str
[...]
> -     se_fi_update(sea, rq->core->core_forceidle_seq, in_fi);
> -     se_fi_update(seb, rq->core->core_forceidle_seq, in_fi);

In case it helps: adding these two calls back on v7.3.4 brought the
cookie p99 back to 55 us. I don't know whether that is the right thing
to do, only that it changes this result.

Thanks,
Mihail

[1] https://lore.kernel.org/all/20261019182622.1584454-1-vincent.guittot@linaro.org/
[2] https://lore.kernel.org/all/20261105165525.011876858@infradead.org/

#regzbot introduced: 85570f10a4c6
