Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794301853;
	b=uabRaCyIYC/UUmzXmww2jCUK5l+rviBB+j92FJM5jjDgA33iinQb/Tc65XBM3rjk+CH6
	 zqYJ1yd7HPl3Z4SOmzEYTCG0q7qYkIV5sYNRd/oUX2R/nEGjf8eIwb6ttyCND657GdV1V
	 37ikOVBcktWmc7dqVsaojWsPUv8/+aQ9drTZW5ECopk5fhLcEvtlmd5vpIqQ4omdOddmn
	 OlHWN4GwbBKI6Bk7N6ephAU4UX0svxnrRw2GoK1WgIw5rs3WblT6hCVZNMKYluyxDwojV
	 KCWiAAKZkY8sTE3/QPNcfE7o8TfiLsJMrtM2aIHBNh4viISnK5advVyr2pg0p8sj5aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794301853;
	h=DMARC-Filter:DKIM-Signature:User-Agent:Content-Transfer-Encoding:
	 Received:Subject:Date:Cc:In-Reply-To:Reply-To:To:Message-Id:
	 X-Original-From:References:X-Lms-Return-Path:Content-Type:From:
	 Mime-Version;
	bh=WdNqNT+bFHTM+YyZgJqU98xQjZavflwKu1yOJyM3vLg=;
	b=PezuyviKWpt4sHz3ObaOyk4SEkF1Dvo+HyrWUNBFJaGmz5TCwlal3sHre96jzqJcnqXv
	 IqjUwWS35ymBxfSulnzAyb0qi/J1mHQzERHavmDgma3JlUzN4PVaxAU0UtS2qxx70M4l6
	 6qTWTGqajNOvwQJhAtnc2vljSXmkhSDB0ElfGgGJSBfrOxYhEhSGqwEuFUE6wiegVC9E0
	 mgrmGkO7ebiXxYBqlUe2Duye6apAXV9uX8cdkIxMX9aq3xvUajkJNzcLEBooSnGbyZwB4
	 aFQnlnR9wEXE+xFXkbCWVcQSH28olVvu82DI/DzHsDhiIqhBfDtateb+LIBfspAMFHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=BxmIuClX;
	arc=none smtp.remote-ip=209.127.231.16
Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF6D606A32A
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 09:10:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DF6D606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=BxmIuClX
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1794301843;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=WdNqNT+bFHTM+YyZgJqU98xQjZavflwKu1yOJyM3vLg=;
 b=BxmIuClX1355HwMzKzj5df0p6A0O7fv0BuE36sLsSuUc7+ZGshKXdsZgs+sj/bfx1ssqGF
 OtAMrohjAp2fs4QCA1+/TK7AcVnK0gWRSVnHoFWL5Z8147gkh92Z7rFmOQqhofpNICOE1h
 1716zy/8X1Ehbuzs20aKGhENnjrLmEwtyXMdYFmEfuCjc2Bdkp0+XHE8S9dtgXOqRn0s+v
 tVXFJwNv8CF7xbC+0Z5I1DLmLXQEzpNziEIqQ6f+t06CC/xqhBMj5zcLnvhtTGBJUY2x8X
 BU2xbnFOrFsbnrXE71QV0Vy+lm2KjpYHYKv/eu65CS4AtBuOfPRS46sdd682+g==
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.55]) by smtp.larksuite.com with ESMTPS; Tue, 10 Nov 2026 09:10:41 +0000
Subject: Re: [PATCH] bfq: Transfer allocated request counts when moving queues
Date: Tue, 10 Nov 2026 17:10:38 +0800
Cc: <linux-block@vger.kernel.org>, <cgroups@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, "Tejun Heo" <tj@kernel.org>, 
	"Josef Bacik" <josef@toxicpanda.com>, "Jan Kara" <jack@suse.cz>, 
	"Paolo Valente" <paolo.valente@linaro.org>, <stable@vger.kernel.org>
In-Reply-To: <20261028094208.716946-1-sunyangkai@fnnas.com>
Reply-To: yukuai@fygo.io
To: "sunyangkai" <sunyangkai@fnnas.com>, "Jens Axboe" <axboe@kernel.dk>, 
	"yu kuai" <yukuai@fygo.io>
Message-Id: <b38bfc29-62a6-4f55-b6d4-f312111b6490@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20261028094208.716946-1-sunyangkai@fnnas.com>
X-Lms-Return-Path: <lba+26af2df92+45a504+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
From: "yu kuai" <yukuai@fygo.io>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0

=E5=9C=A8 2026/10/28 17:42, sunyangkai =E5=86=99=E9=81=93:

> When bfq_bfqq_move() moves a queue with outstanding requests to another
> group, it changes entity->parent without transferring these charges.
> The old ancestors retain the charges, while subsequent request releases
> decrement the new ancestors even though they were never charged. This
> can leave the destination group's allocated count negative and the
> source group's count inflated after all requests have completed,
> distorting the limits enforced by bfqq_request_over_limit().
>
> Subtract the queue's outstanding request count from its old ancestors
> before dropping the old group reference, and add it to the new ancestors
> after reparenting. Leave the queue's own count unchanged. Shared
> ancestors have no net change, and bfqd->lock serializes the transfer
> with request accounting.
>
> Fixes: 98f044999ba1 ("bfq: Track number of allocated requests in bfq_enti=
ty")
> Cc:stable@vger.kernel.org
> Signed-off-by: sunyangkai<sunyangkai@fnnas.com>
> ---
> Validation used a QEMU guest running a 6.18.18-based kernel, with BFQ
> on a virtio block device. The workload submitted direct asynchronous
> reads in /a/child, moved the task to /b, submitted more reads, and waited
> for all completions before repeating. A read-only kretprobe observed
> bfq_bfqq_move() entry and return counters.
>
> Without the fix, the drained destination group reached allocated=3D-1
> and then -2. With the fix, outstanding charges were transferred and
> the drained group counts were zero. Both runs covered migrations with
> outstanding requests, completed all reads successfully, and reported
> zero missed probes. This was not a runtime test of upstream master.
>
>   block/bfq-cgroup.c | 6 ++++++
>   1 file changed, 6 insertions(+)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
