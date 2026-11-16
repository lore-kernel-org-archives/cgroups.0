Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794856073;
	b=rGehtd8mOKHnwbxgRWQE6AoBCxvcxQ2qmDQeF7lZKoCIS3zQIy+XpTv0eqfGlcmkwFUQ
	 2iLGqsszaR0kb6+Y1WSWbgPhIfuOv2JoKqgYomOZN1yvgNuLh5eSsenchyMMCOKaJic/3
	 rdnD11RO8dmKEtpZ2ZKdXK98GWO58EXAZfjLMCXUbOJhXGg6eOVlA7dUolOjxmcvfoweu
	 wlrE1DASiNp+wh3SOqA/1DGXs5/4ZBa5W+7qWibl3FnHifTybWsFetZVUG2oRf1P14sZf
	 sXi6QWeHPO/gJYCwU/zKEmY0fDZ1EasKnWW6qUkTTl1pyPpzjDX61S6rZnOriqd4FEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794856073;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=K0ICR6mn2TBoTZleMBYMaxw6/OnkaccZWNuPWZGU84M=;
	b=3TGNxHu/OZoZ3JC3IWPBwWvL345V29ovwLj8WMt63ixPrLC87UFVauZPAQvtpa8uG2Ug
	 WcCTL4Pyc5Te2xKrHN9VP3tPgUlHRaUSEwb/6asBMl8gJ0jivdFuTWoSBX7f0Itr82ndh
	 4xflOg6V5NaB/zzFaZqp20BZjUDiIe3dPrqrgE+sIQcgo10j+NV+kqYDRLxEkjYT5zRgH
	 S+wHyFtpb6ITjF9je/RKblWFCT/MEOWyjU3prCLvGxyYF4rIjlRxD2u+L0olLv/EwbGrE
	 dMc5tZyRxfBEDrMbcTqI9X1NvjYA6D7aGjdeVhGBo7kbECpTIyXKp1d7LyXSah/A35w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=R1aHqpFa;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A40606A8A2;
	Mon, 16 Nov 2026 19:07:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74A40606A8A2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=R1aHqpFa
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jSy6w14BFz1XM311;
	Mon, 16 Nov 2026 19:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794856069; x=1797448070; bh=K0ICR6mn2TBoTZleMBYMaxw6
	/OnkaccZWNuPWZGU84M=; b=R1aHqpFaO9V6ZBz4/BphWBYK2hWIUNhgm1Dx9Eg4
	z8XqW0IZTKrFIaLyJz7FCoAPo97sZ+i2WvxoLbnhn8zPkZ6EbMUDV4NcOLRen/lQ
	KYKS/1wkbtgBraiSi+jiq8YS7rJ476guH7RY/OezLiTu4wgt3iWAAReS8/k4Dca1
	f83o+OLlC+CZZ7PRNJojgb+G8H+Yh5uhzajHFKxm910X+Uvog3hE1sLy4K1J+ySI
	jZyt+rTKi/2ZX5c4E44OmH7o9Ve0IdJkqNQRL8wpKTlJqA71SyxvEy6EGw43bYjb
	dQa00xEBVjCqZquwd+NUMx5fg1ALsA2mo+wEjZLUBGxZYw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id npABjiIrvioi; Mon, 16 Nov 2026 19:07:49 +0000 (UTC)
Received: from [100.80.227.185] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jSy6s2zvnz1XM6J6;
	Mon, 16 Nov 2026 19:07:49 +0000 (UTC)
Message-ID: <1acc1b37-fba3-44b1-a53f-f33977576604@acm.org>
Date: Mon, 16 Nov 2026 11:07:48 -0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-ioprio: check capabilities before promoting a cgroup
 to RT
To: Hungyu Lin <dennylin0707@gmail.com>, axboe@kernel.dk
Cc: tj@kernel.org, josef@toxicpanda.com, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261116090529.69650-1-dennylin0707@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261116090529.69650-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/16/26 1:05 AM, Hungyu Lin wrote:
 > Require CAP_SYS_ADMIN or CAP_SYS_NICE for the two policies that raise
 > the priority class, like ioprio_check_cap() does. The other policies are
 > left alone.

Restricting RT promotion to privileged users makes sense to me. A few
comments below.

 > @@ -91,6 +92,9 @@ static ssize_t ioprio_set_prio_policy(struct 
kernfs_open_file *of, char *buf,
 >  	ret = sysfs_match_string(policy_name, buf);
 >  	if (ret < 0)
 >  		return ret;
 > +	if ((ret == POLICY_PROMOTE_TO_RT || ret == POLICY_NONE_TO_RT) &&
 > +	    !capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
 > +		return -EPERM;

capable() checks the credentials of the task that calls write() rather
than the credentials of the task that opened the file. Checking the
credentials of the caller from inside a .write() callback is discouraged
because it enables confused-deputy attacks, e.g. an unprivileged user
opens io.prio.class and passes the file descriptor as stdout or stderr
to a setuid program. cgroup_release_agent_write() uses the file
credentials for this reason. Please use something like this instead:

	if ((ret == POLICY_PROMOTE_TO_RT || ret == POLICY_NONE_TO_RT) &&
	    !file_ns_capable(of->file, &init_user_ns, CAP_SYS_ADMIN) &&
	    !file_ns_capable(of->file, &init_user_ns, CAP_SYS_NICE))
		return -EPERM;

Additionally, please update the io.prio.class documentation in
Documentation/admin-guide/cgroup-v2.rst such that it mentions that
CAP_SYS_ADMIN or CAP_SYS_NICE is required to select the promote-to-rt
and none-to-rt policies.

Thanks,

Bart.
