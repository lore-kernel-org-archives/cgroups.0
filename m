Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932204;
	b=KnT0dJ4eS4R4pSwTEy7HK6f8DfhSaj2wkbxOe6VKtbbFxSUTnHNclkYNmQndwTyjySaS
	 l3mCYc/LU4U6omwqav1o5/fCcEzKYJjxVNCLn7Giidz2964rgAsbECU2Lx38SlYSiHAMd
	 /7DlgJi9IwIfAA+0ABD3zwWFAXfBU5Nf5PXi7oqXRVSjGGF04DgcQGCd8Wvs7XCVS1jhl
	 KTW+Flq1QboUWfPcvIcyWgWTnbIFabvuockYy+s7jLR8k0TTXA/q5D3Inkp6Sbztkgas7
	 Ln9nHej8TujDUnR+6TJ6hPLqIt/uElm2ElqUBaH9zOdFHdTpjThznBzxY5fS3LiDpwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932204;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=IUQwIixt7p9YgwIddvsF6szt6tnFcOzhF0U3p/Hz55Q=;
	b=cUhyjq1GCAHa5042EBrwys0I6IZqb2N8wzvt6rTCB2L7LiTY6ywQibUC2Blr6Tcc8SWv
	 7luiGqzN1oPU2n53vYrFRi9JkD5njWxU31YQfiRc0JVhnEkfuWsDpStyx0jStjF362T/v
	 fvQB3DNDE++PyKJtPDQFl3kA449SFo+n7u4ZaLadLLHy8mlhZKHvIX88T8NxDT+ISJ6gi
	 UUbW6h3wjXMYMkyJ5sxhhH9r3pYFc5JFxET0Rj1gFD74tovOTmnFUkeHcuv20IH17z4bh
	 5Zh2Bk/52IgqrNkaoas7eyNYxLjMSdPUcevRoYfLk3MJmlAaX4Y+4jHgQoVVW8cPcYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=v0Lt9zG9;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E917606A31C;
	Tue, 17 Nov 2026 16:16:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E917606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=v0Lt9zG9
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jTVGz2jZCz1XMYJS;
	Tue, 17 Nov 2026 16:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1794932200; x=1797524201; bh=IUQwIixt7p9YgwIddvsF6szt
	6tnFcOzhF0U3p/Hz55Q=; b=v0Lt9zG9f/b+33+0daCuqMzZelXUhJ/K0Waz63Kw
	1I7/4JHzWlhpRpfJxE45M2RdiXHZPJZraM+93jv3D83BEn4Uc4MseWeVqCzHogN9
	5/NX6/Qlj+7eQOaC/i8qgZeZvvWPCNbniwlSD3KR4xYXNEV2Z+/ZTZ8cZ9HY+coL
	5S5wf7DGh+MxlET4YXIDMndqBLB0TiRo/r/8yzmQfxTI6OUV5FaXEjCH0okcj0qm
	gIptCXZAM2kgTeO2XGE4gs3mfCOTqvEsoDifhsaC+XrQzhyLUUSB/0Pgz0XhMUk3
	v3XIKgnqiy9fezC9ydr7/zEOW/4Gg0DRPvv1KsnDdt3tQA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pjnch5nhyHaD; Tue, 17 Nov 2026 16:16:40 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:44bf:cc75:7d8e:9159] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jTVGv3nN6z1XLksG;
	Tue, 17 Nov 2026 16:16:39 +0000 (UTC)
Message-ID: <740cf6c3-51dc-4f29-a9d0-7e6118edb254@acm.org>
Date: Tue, 17 Nov 2026 08:16:38 -0800
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
Subject: Re: [PATCH v2] blk-ioprio: check capabilities before promoting a
 cgroup to RT
To: Hungyu Lin <dennylin0707@gmail.com>, axboe@kernel.dk
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 josef@toxicpanda.com, cuitao@kylinos.cn, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261117111157.2968-1-dennylin0707@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261117111157.2968-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/17/26 3:11 AM, Hungyu Lin wrote:
 > +#include <linux/capability.h>
 > +#include <linux/cred.h>

file_ns_capable() is declared in <linux/capability.h> and init_user_ns
is declared in <linux/user_namespace.h>. Shouldn't <linux/cred.h> be
changed into <linux/user_namespace.h>? Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
