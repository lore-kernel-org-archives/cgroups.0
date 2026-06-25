Received: from va-2-47.ptr.blmpb.com (va-2-47.ptr.blmpb.com [209.127.231.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDB0374745
	for <cgroups@vger.kernel.org>; Thu, 25 Jun 2026 01:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782351739; cv=none; b=HGo+7Oy+665lYGrDT4nFbUhnw+IssSUQw1R4GWnanzawPSg1zMQ1vmJC1wiRSSC11f70htBwhIdglYq3Bqkmy8BeszB8na2PD2yg4ciYPxzPIQ/9X5cBkProb3pw0ZRgKnvIYzXLJdahql9T9DzalqlwD6CHGsFIttP7ito567s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782351739; c=relaxed/simple;
	bh=w4j8f6uFb433Grb8B0eRcI7+Ke5YL/rbbA2Y0K+GuCg=;
	h=Subject:Date:Message-Id:Cc:In-Reply-To:Content-Type:From:
	 Mime-Version:References:To; b=agqz4KdOrRFvvNZ/rrxraWn0Bpml8ljAUZKba1CgnlY/Azqa+gVtlOhQxdjclfGzJvaM2r0gv07UwCuCohRCeNCCR/1IKEEjZJpUNSCaTUI476zQENvK75Mmw4EyVwKOXvaxXZRQQ3Ol24bAwEbgioCWygIhJPVLHgNqRx5qyoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=fMfJFJyT; arc=none smtp.client-ip=209.127.231.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="fMfJFJyT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1782351728;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=w4j8f6uFb433Grb8B0eRcI7+Ke5YL/rbbA2Y0K+GuCg=;
 b=fMfJFJyT58AGjKzbG4LBJYi/Ehgens5KdI2jxzQS81BZNn0UA1zTA3A4qAHXSndya/Sno7
 70AT6VxXyZLVQhs0GEVbQLd7J9HOUDuuzz7d/0594l4+jbua6O1Ne7gAT69RuJY+M1XGO0
 sWGdTmHodHUtx6Iosj8F1dCkXtEeW0yGYetnKwRP0E7YIBI3f8yYrm2UkqwcdQ1b7+DLx7
 mU4CEYcroDUxWhHYpK1yvvXey3mEhO/2Zw+dzGCabbedrz8H14LzkIaKNhHStNhXAYXVaL
 pyRxMmB/h3Vr3FAL8gAbNLRMNsvH5FWX/XHWhVW6L1Tz4kBSJ5JpdxnNx+Q8Ew==
Subject: Re: [PATCH 0/8] blk-cgroup: remove queue_lock nesting from blkcg paths
Date: Thu, 25 Jun 2026 09:42:02 +0800
Message-Id: <727c7d76-ba00-4905-b64f-e954392b346c@fygo.io>
Content-Transfer-Encoding: quoted-printable
Cc: <akpm@linux-foundation.org>, <chrisl@kernel.org>, <kasong@tencent.com>, 
	<shikemeng@huaweicloud.com>, <nphamcs@gmail.com>, <bhe@redhat.com>, 
	<baohua@kernel.org>, <youngjun.park@lge.com>, <cgroups@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
User-Agent: Mozilla Thunderbird
In-Reply-To: <34d48fb5-4952-4a48-b92a-f189bc3edd0b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Thu, 25 Jun 2026 01:42:06 +0000
X-Lms-Return-Path: <lba+26a3c876f+2849a5+vger.kernel.org+yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io> <1c739fcc-5132-4cb2-bf34-cec94de26509@fygo.io> <34d48fb5-4952-4a48-b92a-f189bc3edd0b@kernel.dk>
Reply-To: yukuai@fygo.io
To: "Jens Axboe" <axboe@kernel.dk>, <yukuai@fygo.io>, <nilay@linux.ibm.com>, 
	<tom.leiming@gmail.com>, <bvanassche@acm.org>, <tj@kernel.org>, 
	<josef@toxicpanda.com>

Hi,

=E5=9C=A8 2026/6/24 20:43, Jens Axboe =E5=86=99=E9=81=93:
> On 6/24/26 12:57 AM, yu kuai wrote:
>> Friendly ping ...
>>
>> This set can still be applied cleanly for block-7.2 branch.
> Not sure how you checked that, because patch 3 very much needs some
> manual attention to get applied. I have applied it now.

Thanks!

This was build on the top of my other set:
blk-cgroup: fix blkg list and policy data races

I'll rebase and resend this set :)

>
--=20
Thanks,
Kuai
