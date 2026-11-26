Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795679355;
	b=2AIQhiqIOmohBnJ0aTvVMzBUR442YKqi4JQf9IMOUx1pTw3hNnjha3hzi0vWebI8Zfm6
	 9WyuxUjzIpYzZItGHR3r4R1gKSR4E3cehBGHmG9/FXIZvt4uhq4Nwe2ACZfx0Tv0lkN7n
	 LmBrLCf+lY36zrwkNs0M04d8gEkPKjI4LRELI7TZxiOwk741QMLdTtP01IOkGQcKA3vah
	 b1smyyJ9B8n6e5TSz53bFsL5NkvB8eSCkFQsBtZTBNty2JY7XDo5gK1x10udkTqY2zRS4
	 FeTWcXlfrUsVOKwFSm7JBGY9CCxdH72n7Gslrt2WZNaBLGFiQVitnKoWhdGhO1Re8RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795679355;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=B21i4+ZUhaISno42DnRuHLIvnKFoII5gbyv4BOzzN34=;
	b=0iYB9ZXZSdLdyeMKehUHL52vSav/+sB1734MtZ+vajRDsF0SrME0akw50ZpUXAR5PfQn
	 HOnLPMEg8wVdAGnyBtt2v3wbrm5Sa0hgMP+mCOvr67f71vxmxuU6ekWdq1HqsmUtMvz72
	 b9Uc7pqP6zHr4L7/+OZzGh5Fuua9xlXbT0lSuzZNAz5061K9O/I1PkaT46vmX06DWf58Z
	 lAme4LQbOJMMoh3/ilsEFNLvo5YCNxYrO5rgEDe3iXNxZ4V7lZhIOFjaYwLTOV5S11Ws6
	 N8SeZnTarTXSVA5RXUwPcy4nxm2Pj+lNW/mwLzv6SQF3eBUuxDj1fFwMnfBqsUJNW0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ae7KBciL;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=OXuiVUf6;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E97606A31C
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 07:49:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08E97606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ae7KBciL;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=OXuiVUf6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795679354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B21i4+ZUhaISno42DnRuHLIvnKFoII5gbyv4BOzzN34=;
	b=ae7KBciL6UDgPkzyLqoo5lhIMMllQTeC5jjIK2HwoW1V+uQqT2l5DoUZ4OOlEnkH2f/WNv
	nPzNYxc3YkI686R/Jh15PJCn6/uBo0nDVH9Y/1+EmoGYKbVuJ5Vc8tKQb429y07OESzLOu
	n1L432J8IR0eMdj/fEDW3ss1uWQYX10=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-0lwWxerSNsKTqpoKSdPSgQ-1; Thu, 26 Nov 2026 07:49:11 +0000
X-MC-Unique: 0lwWxerSNsKTqpoKSdPSgQ-1
X-Mimecast-MFC-AGG-ID: 0lwWxerSNsKTqpoKSdPSgQ_1795679351
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e0389d6f9so4183553f8f.1
        for <cgroups@vger.kernel.org>; Wed, 25 Nov 2026 23:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795679351; x=1796284151; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B21i4+ZUhaISno42DnRuHLIvnKFoII5gbyv4BOzzN34=;
        b=OXuiVUf68jlCB9alV8RL/oHewEdwKlN8yDpux1JMhlwJCFiS8BRWPtjpVqiT7JOwVu
         qvwbzPiURwqoTw7AYSYNtprqytRhYVtYS3JNveJQ87KhDAEKb3WkZ+JQ0acx8f8oAXDE
         lgGEJseW4R6/DdQtFfUgCumyyBy4zDtBI12IQWbMlXm5WXhxA0N/42bKh8QNg7KzbM+I
         1Hl8EFZNPDwvbK4pfUdwvIpOM/v8F+obrtmPrlcl0d8DFcfV+i/hzkvvmvS26eNqXB9d
         jm+HfGfE0IUi1MkH1rcRJ7BK3oRooeo7AKINVuPDP46Z+ppkxVlX/6jXxLmp1K4v/P4Z
         yhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795679351; x=1796284151;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B21i4+ZUhaISno42DnRuHLIvnKFoII5gbyv4BOzzN34=;
        b=gwJWzVPx38riBDUd7KIfKhZHSc2M8+se7wq5AkC5bo2x1fRNQGe7txo5MJ9PFfiTx3
         QiVqts3wJLxlGhxEjXJtr91rKQOFZh3/CiQYSMke+7IFD13U1edKj5RD5PEqYEDrApYN
         DUcA+0ItgWmp2MD1rscs+hw/6eYxMZXTP9/ZZNNOYJNvejrgJu4jY5SfA2UnVhwfx334
         OI0O4GG+eerkGDBAeL16bfY6hT3NgffXaPR7UbpcfSd0X3md7mPu1jVCeK6uZJcAR2Qs
         eVT0Su1dhQhC3azeYJBe5Nl6yTQ3cZF5XpHzkFXVyOKZVSEG4orERq1Za+D1wsVogJQ2
         NzmA==
X-Forwarded-Encrypted: i=1; AL+hErHl17SFCOOQOH0gavmsIOWIiRTgP+afqj7FBIZjImIcnkpOyZOBMBAbmVS8+fflfhXe5ryPtW9h@vger.kernel.org
X-Gm-Message-State: APuU4Z9DC+WLnrZvmTMKo/NERrju9R5sSWVmap6bzC3Gv9yBEKamNkl2
	80oxgpDZZufj61S+oHyxzJjdMo0jaD6ikJGal8Pu+OUkEPm8FCktwNy9KtaXklytSIhcXc1Madv
	m4t7ZtD6igdVFIU+uq9agx5bfsRieMgvAxtJ1TWYA8KsgS4mlXwhRtcQPT+I=
X-Gm-Gg: AZFdTZeu4crO25phkyWtaEHZW2DSjSSV6aKJep4sKTOe0HG6mRm6X/Q9dSL8maMySyJ
	S8iJw9QRLBbaOPeN+0mt/wFFbYlyvHIqvxCibJlte9Sc0FLjd/Thy7fADOAYAwUnB0puSv7+xto
	DcOu5aTsZqF+CP6i7Fkoo2GwzlL5FH4Jix4MGWPQJmkNEbRbrt1vDwwaTc1aJcmFoO8nH0HXvnP
	Iwhv2i4kcGzCWnS9n2EcCoQXGykMIF1oqn9mleEGsaeueeyJLdOOhzYb3M5hElmd9EK7M1IcYJ3
	goFv2Jxtzozxlq2n3xfJjr0BqnWdACw6v8CbaS/lxP9by/uAGYy/I99PqtegP7r5u730Bhu3p5Z
	y7V2THsvhf5tdYVzeZu4x2AJILJRy8WMKnH9df0zlgOyLya4Ql5UvWp+m9nzFJ25s2fCJkuH/un
	jkYPHB
X-Received: by 2002:a05:6000:2913:b0:4a8:7115:fa08 with SMTP id ffacd0b85a97d-4abb0f3c202mr41157244f8f.13.1795679350681;
        Wed, 25 Nov 2026 23:49:10 -0800 (PST)
X-Received: by 2002:a05:6000:2913:b0:4a8:7115:fa08 with SMTP id ffacd0b85a97d-4abb0f3c202mr41157225f8f.13.1795679350388;
        Wed, 25 Nov 2026 23:49:10 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.146.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b8b7888sm38587132f8f.42.2026.11.25.23.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 23:49:09 -0800 (PST)
Date: Thu, 26 Nov 2026 08:49:07 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: luca abeni <luca.abeni@santannapisa.it>
Cc: Tejun Heo <tj@kernel.org>, Yuri Andriaccio <yurand2000@gmail.com>,
	bsegall@google.com, cgroups@vger.kernel.org,
	dietmar.eggemann@arm.com, hannes@cmpxchg.org,
	kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
	mgorman@suse.de, mingo@redhat.com, mkoutny@suse.com,
	peterz@infradead.org, rostedt@goodmis.org,
	vincent.guittot@linaro.org, vschneid@redhat.com,
	yuri.andriaccio@santannapisa.it
Subject: Re: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Message-ID: <awfkczwhkLkXVEVz@jlelli-thinkpadt14gen4.remote.csb>
References: <471bf8d446becabfca00041fb2a78067@kernel.org>
 <20261120120659.2e902463@linux.fritz.box>
 <6fef47e08a37079c08806b3c57994778@kernel.org>
 <20261120212418.10221f2e@linux.fritz.box>
 <06f4c157677f99fc5386dba4c9d68cd2@kernel.org>
 <20261123084345.4e24e3ca@luca64>
 <awQTy09VbrDn9RpA@jlelli-thinkpadt14gen4.remote.csb>
 <20261123151846.3fdcbf4e@linux.fritz.box>
 <awfe_r5McCTzr84x@jlelli-thinkpadt14gen4.remote.csb>
 <20261126084322.4abc6744@linux.fritz.box>
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
In-Reply-To: <20261126084322.4abc6744@linux.fritz.box>

On 26/11/26 08:43, luca abeni wrote:
> Hi Juri,
> 
> On Thu, 26 Nov 2026 08:25:50 +0100
> Juri Lelli <juri.lelli@redhat.com> wrote:
> [...]
> > Just for my own (hopefully) better understanding, I tried to come up
> > with a setup that uses a cgroup with entries on some CPUs and "max" on
> > others, to reason about it more concretely. This is an illustration,
> > not a deployment I actually know of:
> [...]
> 
> Thanks for the example, it really clarifies things a lot for me!
> I am going to look at it in more details, but, just to check if I
> understand correctly: the "trick" here is that "P" does not contain any
> RT thread, and all the RT threads are either in "P/noncrit" or
> "P/crit", right?

It would make sense to me. Also, I seem to remember we said it was
actually a requirement at some point (threads only allowed in leaf
nodes), but I might be wrong.

