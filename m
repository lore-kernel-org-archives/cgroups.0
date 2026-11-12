Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794496552;
	b=bKczjv1ZC5imeR7SuvFBQrFCuhMe86lf/liEVE6/NqbaBsrGRObQCmH/BhFrL4GwAi8N
	 nFA5t2E8W0DA0rCgpzeftstUbzd4y4chEBGSX6nvPXWM1E4XdmMf453xmnP0IdOiLCIk7
	 m6/R6x+LqVIXyGFK7x1qY/Tmb9nmpsDAD3pBM9TfqUhwR8JhBNBAdvjM1ecBlGm5Y4UTZ
	 9ULqqTD36cOsHeSCu/EM+PvwSQ2CpKOJkSLSm1B7fLqzg37M+fSdSDggkZ3NnjgEg5AEG
	 9hx6eV/a+TQrrzv7Xwnw6mVuTKKPi3U7JptI2bEPKTR9udSDT40x24S17qFbysNf3/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794496552;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:CC:Subject:User-Agent:
	 In-Reply-To:References:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=3iXofka/ijAZ8YI184eortXle/aCUVIrItu1XLah2E4=;
	b=chfT8lvudC1gRM4hmyYguaWYJaMYEJAdF/Y8rMShpFKjtuZmZpZwnL2I4gkbxBhgrdPE
	 lVkKcvIWXUMWyEwh8kWfoLBaTKwXpPikIRcxXoZgD34YN4vFLx5FSzHPASBDd27GssDuF
	 LjI8nuwI56/gwLajMSvr0sGxma1Xu5a6evuHei6uVcoRpdUrI6ODbkiVh/kGTMUr1ftrI
	 Cq+V/JclB/TTBYbnyfjwC4D2owC84G/DtLN9IW+kwnE0FfjKLezrkpYhjoI5CZnjabe82
	 0GBtFvThYzF22Vx0lb7sm8+I4qg5VVfGAs9253ljfgHpGyq9n8VxwO3mRmSyU3tCUGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sGdM+++x;
	arc=none smtp.remote-ip=91.218.175.222
Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1065606A33E
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 15:15:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1065606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sGdM+++x
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=w3akmbf0AFdJvzUPfaISDxeZcbJmAzfupNJkIFkNAFo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794496549; v=1; x=1795101349;
 b=sGdM+++xxm1S7BWDjSbeG93Bfze4vRikOOD+/UcCuhXB0Rr4BUBIaHet7FQLp0nKYg96aUYh
 wOadRMQOjoQJQII5JSL+a3bmbdvDxHNPfuxwDJkj/26RnviJQnzdTChzOQNJv3gJVfal7pRWiYi
 cjW8jbz3M33SUTO4NUwxHPxo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e0e3d63694f38fef;
	Thu, 12 Nov 2026 15:14:48 +0000
X-Mizu-Trace-ID: e0e3d63694f38fef
X-Migadu-Flow: FLOW_OUT
Date: Thu, 12 Nov 2026 23:14:45 +0800
From: Tao Cui <cui.tao@linux.dev>
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, josef@toxicpanda.com, oliver.sang@intel.com,
 nilay@linux.ibm.com, hch@lst.de, yukuai@fygo.io, linux-block@vger.kernel.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, cuitao@kylinos.cn,
 sashiko-bot@kernel.org, cui.tao@linux.dev
Subject: Re: [PATCH] blk-iocost: fix the lock order in ioc_cost_model_write()
User-Agent: Thunderbird for Android
In-Reply-To: <bfe5007b2758bb06504b6966abaf1f7e@kernel.org>
References: <20261111162137.295523-1-cui.tao@linux.dev> <bfe5007b2758bb06504b6966abaf1f7e@kernel.org>
Message-ID: <55824DEC-A6E9-4607-B1DF-C61A24D59FFA@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello, Tejun, Christoph,

Thanks for the reviews=2E


=E4=BA=8E 2026=E5=B9=B411=E6=9C=8812=E6=97=A5 GMT+08:00 01:31:38=EF=BC=8CT=
ejun Heo <tj@kernel=2Eorg> =E5=86=99=E9=81=93=EF=BC=9A
>Hello, Tao=2E
>
>On Thu, Nov 12, 2026 at 12:21:37AM +0800, Tao Cui wrote:
>> The inversion cannot currently deadlock because blk_mq_freeze_queue()
>> is in a noio scope since 1e1a9cecfa ("block: force noio scope in
>> blk_mq_freeze_queue"), so a caller freezing a queue cannot recurse
>> into the frozen queue through reclaim=2E Holding the mutex across
>> the freeze needlessly serializes config writers behind it and
>> leaves two different orderings in the same file=2E
>
>There is no deadlock here to begin with, and the noio scope isn't why=2E
>Freezing is counted and doesn't exclude other freezers, and a freeze only
>waits for in-flight IOs to drain, none of which takes rq_qos_mutex=2E The

I got this wrong=2E I treated the freeze as something that could deadlock
against the mutex, but it is a counted wait for in-flight I/O to drain,
and the drain paths don't take rq_qos_mutex, so there was never a
deadlock here to fix=2E The noio scope of blk_mq_freeze_queue() addresses
a different concern: preventing reclaim from recursing into the frozen
queue=2E I conflated the two=2E

>patch doesn't make the ordering consistent either=2E blk_iocost_init() st=
ill
>freezes under the mutex through rq_qos_add() and blkcg_activate_policy(),
>and so do blk_throtl_init() and blk_iolatency_init()=2E
>
I also missed that holding rq_qos_mutex across a freeze is the normal
pattern in these paths, so the "two different orderings in the same
file" premise of the commit message was wrong to begin with=2E

>> +	mutex_unlock(&q->rq_qos_mutex);
>>  	memflags =3D blk_mq_freeze_queue(q);
>> +	mutex_lock(&q->rq_qos_mutex);
>
>This lets the disk be deleted in the middle=2E @ioc was looked up before =
the
>unlock and rq_qos_exit() can tear it down before the mutex is retaken=2E
>With a delay added after the unlock and a null_blk device deleted during
>it, the write goes on to use the ioc after ioc_rqos_exit() and KASAN
>reports use-after-free in blk_mq_quiesce_queue() called from
>ioc_cost_model_write()=2E
>
>So, this fixes nothing and adds a bug=2E
>
>Separately, ioc_qos_write() already has the same window=2E It retakes the
>mutex without rechecking disk_live(), so with the disk deleted in between=
,
>it initializes iocost on the dead disk and hits the same use-after-free=
=2E
>That's the part which needs fixing=2E
>
Thanks for the reproducer=2E This is what I missed: the mutex also
protects the lifetime of @ioc against rq_qos_exit(), and releasing it
around the freeze drops that protection=2E

On Wed, Nov 11, 2026 at 05:33:06PM +0100, Christoph Hellwig wrote:
> blkg_conf_open_bdev takes rq_qos_mutex aronud the disk_live call=2E  So
> you'll have to redo it here=2E

You're right, releasing the mutex voids the disk_live() check made under
it in blkg_conf_open_bdev()=2E  I'll withdraw this version=2E

Sorry for the noise, and thank you both for the explanations=2E I'll
take a closer look at these locking and lifetime semantics and come
back with a new version once it's properly tested=2E

Thanks,
Tao


>Thanks=2E
>
>--
>tejun
