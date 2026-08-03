Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBD73502A9
	for <cgroups@vger.kernel.org>; Mon,  3 Aug 2026 05:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785735074; cv=none; b=gsYNrg+zmv6pPGe/NiGgSd12Bd51qoiiy6GxvO+KPT2XTmZv1HIceYew2iolJ1Xdnr9tCweIwiuzFau/BDYGqYg10QQE710dH1ALjz9Z6ZkAAOWMB8io64VD3fF+Rda/pkmHzU3qQE8WtJdfWAJ8kydf7FEe7nANYFS+ZbON4hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785735074; c=relaxed/simple;
	bh=mYIRaUOoR4OwMRJBNW3HB8dkJszBAsAmccXayxMHDHE=;
	h=Date:Mime-Version:References:Cc:Subject:Message-Id:Content-Type:
	 To:From:In-Reply-To; b=MkjUTw34U4ujxUKM09RXhjsTi8Lwtk7CGE6MWA1mTJ73tmZbbpdHDTZQVCEVOpYUnUUPhEaSlWdzTGLYOh8S2uexr32NSGAktl+0ZkW8Dt7ECUKmnRsDvFImTJ078ldnWM5tpWMHqRbYIPqpeyQVuxlUFv1hwLZMaEUrqa8JNcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=j6E217jo; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="j6E217jo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785735065;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ZT7LXS53aydScyy0mRMyMcaltkdvsQWL82YlAXTeJrU=;
 b=j6E217jonCD1HER26SXjZ3hdvlfKZth2mF+eJYo0jRusD6GFk1DbV+/4uPm5Dr7DCUl9hx
 MrrQcKCSN2niimadbmYXi2t5QkT7FZuRD1NKbmTSc0WQu3xHBy4vUzh7XhpXJb5pK5xtH+
 /XIzVKmY/NMmDaALvNt1VOJ44ceyUHpje4nO1tjOuDc9tb2QDPJrDZd6439LLU/ZqRQiNS
 TyOUI4jEK6Or//BReIHPsaWJ7PZ6jCeDrU4cMcHNGYp8UVUVtw22QoFgqQEqKc23hM35iI
 8PvrPQfmBT0kCQIeafjoQKNS7CFcwReNnjnoeYby0EVypmR78tRNDfj1m7ieNg==
Date: Mon, 3 Aug 2026 13:30:58 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Mon, 03 Aug 2026 05:31:03 +0000
User-Agent: Mozilla Thunderbird
References: <20260720093726.28965-1-cui.tao@linux.dev>
Reply-To: yukuai@fygo.io
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: "Tejun Heo" <tj@kernel.org>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Omar Sandoval" <osandov@fb.com>, "Bart Van Assche" <bvanassche@acm.org>, 
	"Yu Kuai" <yukuai@fygo.io>, "Chaitanya Kulkarni" <kch@nvidia.com>, 
	"Hannes Reinecke" <hare@kernel.org>, "Ming Lei" <ming.lei@redhat.com>, 
	"Damien Le Moal" <dlemoal@kernel.org>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, <linux-block@vger.kernel.org>, 
	<cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<cuitao@kylinos.cn>
Subject: Re: [PATCH 0/4] block: drain per-cpu latency stats over possible CPUs
Message-Id: <0a045f85-4ef5-4d2b-81db-c4742bd9d373@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a702798+fc765d+vger.kernel.org+yukuai@fygo.io>
To: "Tao Cui" <cui.tao@linux.dev>, "Jens Axboe" <axboe@kernel.dk>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
In-Reply-To: <20260720093726.28965-1-cui.tao@linux.dev>

=E5=9C=A8 2026/7/20 17:37, Tao Cui =E5=86=99=E9=81=93:

> From: Tao Cui <cuitao@kylinos.cn>
>
> Several block-layer latency statistics accumulate samples in per-cpu
> buckets and drain them periodically -- in timer callbacks, or at each
> check / reporting site -- using for_each_online_cpu().  When a CPU that
> holds pending samples is taken offline, that bucket is skipped during
> the drain: the samples are neither accumulated into the current window
> nor, where the drain also resets, cleared.  They sit in the bucket until
> the CPU is brought back online, at which point they are flushed into
> whatever window happens to be running.
>
> The effect cuts both ways and is harmful in each direction:
>
>    - while the CPU is offline, its samples are under-counted, so
>      throttle / latency / scheduling decisions derived from these stats
>      miss the work that actually happened ("should have throttled, but
>      didn't");
>
>    - on re-online, a burst of stale samples lands in a later window and
>      can spuriously trip a throttle or skew a vrate / latency estimate
>      ("shouldn't throttle, but did").
>
> Fix: drain over for_each_possible_cpu() instead.  The per-cpu areas are
> allocated for the full possible set, and the init paths already iterate
> it; an offline CPU has no concurrent writer, so reading and resetting
> its bucket is safe.
>
> Cost is bounded: the extra work is over offline buckets that have no
> writer and -- because each drain sums and resets -- hold a zeroed stat
> after the first post-offline drain.  It amounts to O(possible - online)
> trivial per-cpu reads on a timer / check / show path, alongside the
> per-CPU stat work already done for online CPUs; on systems where all
> possible CPUs are online it is exactly zero.
>
> This is the same one-line mistake in four sites; each patch switches its
> drain loop from for_each_online_cpu() to for_each_possible_cpu():
>
>    - block/blk-stat.c        blk_stat_timer_fn() -- shared infrastructure
>                              that also feeds wbt and blk-mq latency
>    - block/blk-iolatency.c   iolatency_check_latencies() (throttle) and
>                              iolatency_ssd_stat() (io.stat reporting)
>    - block/blk-iocost.c      ioc_lat_stat() -- missed-ppm / rq_wait delta
>    - block/kyber-iosched.c   kyber_timer_fn() -- latency histogram flush
>
> blk-mq.c's for_each_online_cpu() at the hctx-has-online-cpu check is
> correct and left untouched -- it is not a statistics drain.
>
> Tao Cui (4):
>    block/blk-stat: drain per-cpu callback stats over possible CPUs
>    block/blk-iolatency: account per-cpu latency stats over possible CPUs
>    block/blk-iocost: collect per-cpu latency stats over possible CPUs
>    block/kyber-iosched: flush per-cpu latency buckets over possible CPUs
>
>   block/blk-iocost.c     | 2 +-
>   block/blk-iolatency.c  | 4 ++--
>   block/blk-stat.c       | 2 +-
>   block/kyber-iosched.c  | 2 +-
>   4 files changed, 5 insertions(+), 5 deletions(-)
>
> --
> 2.43.0'

For this set:

Reviewed-by: Yu Kuai <yukuai@fygo.io>

>
--=20
Thanks,
Kuai
