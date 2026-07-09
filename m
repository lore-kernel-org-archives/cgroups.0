Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B0E401A02
	for <cgroups@vger.kernel.org>; Thu,  9 Jul 2026 09:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783590612; cv=none; b=GyAA1GdxbxkzHyJt4RFR8bfB+B3j/YY4O7kxRNE0qC0AyHnHYy2HOPJAxjej7YuscuJ/FGwOdDAOxi2can5Ss2/PRq/m5hnkbZaQ8po4etf5xwrKhxQCk3js2JyVTGTNpzTV2JKNWi4tA4ciY0V8aeZAjGZj+xCQlOUe9wooEoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783590612; c=relaxed/simple;
	bh=rxSgwuGzIsEmyghbrvFjO2zv/MUWNeA+OR1hBhENbho=;
	h=Subject:Message-Id:Date:References:To:Cc:Mime-Version:In-Reply-To:
	 From:Content-Type; b=QIj1wL55D87SYXOes9wSJg5YGwsdS/gznq5DHY42jnqZlZbHkULz23U7p4/+ITjN43IcKnB7ufg4FH7entM9HNTEnH89gnV9MUOKpCvHbirMffp/N7EFBcyJpCZ92eKxukHer+umGNLpajmDQI6BWF75EfKfFUcay8E7lDnL1dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=PqNfl6kf; arc=none smtp.client-ip=209.127.231.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="PqNfl6kf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783590593;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=rxSgwuGzIsEmyghbrvFjO2zv/MUWNeA+OR1hBhENbho=;
 b=PqNfl6kfcb7YydGxqmviNJtpbNIlE+Ie3+/dqo8uPbB4Pt6mk2zLIOxjC0WRw/gmcqeULc
 /gv/f7DHOmRX3g9ssWUL1aOR3+reHH/J1M5KHdaicddbPsYGO4eHcXwuGorpZm89JW1gH7
 vTWEf+45x74R9YH0wYw2/h2AbDf1jK03pFXZ9Z8TxG3WJ6ZQPCFazb6ZV0NQghPKVVu6V2
 9JkJMdStsk77hRJAdU0Jk+I67Fuw3/XYgcceCVvwoYSwor1OVDmfiYFs64HZwOp2bXLSoM
 YemL4DCzmLsex12QdK40QQVemyfhb872Mh71fF7rOFjIFTaS4UFI6Jr+8CJkzA==
Subject: Re: [RFC PATCH v1 05/17] block: add bio_alloc_atomic() for atomic bio users
Message-Id: <1bf1939e-6a7b-4a8d-a316-96812cd6924e@fygo.io>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 9 Jul 2026 17:49:47 +0800
References: <20260704195124.1375075-1-yukuai@kernel.org> <20260704195124.1375075-6-yukuai@kernel.org> <20260709061207.GC16504@lst.de>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Thu, 09 Jul 2026 09:49:52 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
Cc: "Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>, 
	"Keith Busch" <kbusch@kernel.org>, "Sagi Grimberg" <sagi@grimberg.me>, 
	"Alasdair Kergon" <agk@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, 
	"Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Dongsheng Yang" <dongsheng.yang@linux.dev>, 
	"Zheng Gu" <cengku@gmail.com>, "Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Josef Bacik" <josef@toxicpanda.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, <linux-block@vger.kernel.org>, 
	<cgroups@vger.kernel.org>, <linux-nvme@lists.infradead.org>, 
	<dm-devel@lists.linux.dev>, 
	"linux-bcache@vger.kernel.org Joseph Qi" <joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260709061207.GC16504@lst.de>
From: "yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a4f6ec1+0320de+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/7/9 14:12, Christoph Hellwig =E5=86=99=E9=81=93:
> On Sun, Jul 05, 2026 at 03:51:12AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> Add bio_alloc_atomic() for callers that need a GFP_ATOMIC bio from the
>> default bio set but cannot safely pass a bdev during allocation. The
>> helper returns an unattached bio, leaving callers to set bi_bdev and
>> attach blkcg state explicitly before submission.
>>
>> Use the helper for virtio-pmem flush child bios and OCFS2 heartbeat I/O.
>> Both allocate bios from atomic paths and must avoid creating missing blk=
gs
>> once blkg creation is protected by q->blkcg_mutex. virtio-pmem clones th=
e
>> parent bio's blkg association; OCFS2 binds heartbeat I/O to the root blk=
g.
> Let's kill off the concept of atomic bio allocations instead.
> Joseph already has an outstanding patch for nd_virtio that needs a little
> bit more work, and ocfs2 should be easy enough as well.

Thanks for the notice and good to hear that. This will make this set much
simpler.

>
--=20
Thanks,
Kuai
