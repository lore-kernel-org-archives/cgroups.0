Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760B04DDB5C
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 09:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071106; cv=none; b=GDoJvSCouJR75iRVSCD3zAVwttXrjNUk1BKre0FarfKNwajFDg/0lB058TtGWn7gWGGKtxHYysPOb38hqaxAdIj0wB0ZtVTVU1FzgJdj8sfwKdRygiDznDfccHH+1IOVahiN0csrQz3DB/ASGaC2SPWODKJkPXzgrEYpdmmZ2jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071106; c=relaxed/simple;
	bh=zYbfbPSv4oN0DQRZXu+ig0WpHZAE1jueUN/5aUe+dpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hFPOkEcXdWCwn1O7pm/iHo67B/9NJ/q1/WCJPPtudn3AJcKmV8Qmg88wfGFO4zQyNU2dm9Vc/4CyHrNvJ4igoPf0Vo3Buz/ug022txHG/x71U117C0X+OSnKAaMR1a51wntRm3xtMQjX1OU/RHAN95XQxiXpQaHRA83XxUAlhp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VtBoOvXm; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VtBoOvXm"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e4ad9so22933255e9.2
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 02:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790071102; x=1790675902; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nZUNZdA2VreC5ZuzVVTaU77y9kWQRV4FmcQNBHWyLvk=;
        b=VtBoOvXmAmen9A15P2XUuom5lD/1FL4lYGpdQVlTKAozAKOcuAjxP/fvx0Ao38Exoq
         5+Z4Hz0ZBE6NheeiWCh5xeWyQPagqjfs4f79S40IPirUpX5MyYP/m4caovC3dzry78uG
         qLVHF46WMJzE6APh5ToFTevmH6sDFNe8j6X21GWEoW4cLdhNm4hEB96kOS4aoPn79zyN
         nZrL7X7l5ieVRSVE7emEimSWG9oKJUGSRvLQJGSqXqZQPPgzbooqStbK79ZVMeOIf3FZ
         Rfg8io+iLrPWZmwv45RZ6QmcYxFygH8ndbcley/wqvpcy8l0XeKLrrX3CsuxOj3R0rI1
         hMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790071102; x=1790675902;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nZUNZdA2VreC5ZuzVVTaU77y9kWQRV4FmcQNBHWyLvk=;
        b=xi3V9Mo+JbfEkc23OUiNAAO+U6doVzDkFzbmOSTGsLDlWOoZNO4zbphh8zLYgitS9U
         8gO86zOZ/6VWWPaGnaKzZJfbV1vQhOBpJVUd15e11w9wlONUdK+OPw3nnlpQgY3vEf+m
         yBbMdzYUP/8sdcTVMiT2enVo+mTSd7b5ahCJDDC/fHrtoOESwOfnv+UZjGWT1aIA9w5n
         7Pn3ymFkYWpn37bendFNzIqNkHvTV7tfa4SEp/GpINQN6fxfK/dNIEakxJzWMLARErXH
         pkbBpl7Y2ab4qweuwk2i/GiSVkROTn4dHNM4Tmktaj1sQTTDMAMeMDtB+6gI5MVBZUsr
         tN+Q==
X-Forwarded-Encrypted: i=1; AKwUvBxliHKtzyINWxc2F7rsqTKpHTWzOYNiiyOmEV9LGGH0U6SFFGmCY6/5mxE4XRSN1CANgtwabw1M@vger.kernel.org
X-Gm-Message-State: AFuF++nQ/Bb+58EcbfzKGIn8njrDZLnRmGkurHtpflzO+Bz8XxEWe8tW
	Oy7VeEVEw25oyBrkxIUPVddfMMaPo62CUsF6cUD/ezuMJgWHSoliPsn44RnP9ovN9ZM=
X-Gm-Gg: AYBFou2iFipihVtqVYe49wkj7h1rHpRITPh004zXWVT4bcndDYLDKz3csDA/ABehQ2t
	Kw0cSUCmq5ICe4DsGLeh41t9GKDu1v1a1tlrgZfm3kfaJ2nnfcFK/W7mes4VHh3JqQu5Mi6nDZK
	JpVhyhvhrw/DCaWXnfZEbQVVNavkYYadVlKQSN0NrletuvB77rnoRk+IufvxfmYTorlPvWvIXvO
	qor9FBSvDHdy/kO1ZFZGM3LIAKJiZyvntwAqXAl70RBMRgfDgo9ES9F0YjLtmIuyHK7YzKE5RqF
	Ko3LU9asgu3J8vgSCnqO02EJVQ4aKpA4Kdmsta//ZnDwBey/e8y9I8qlTBm2q2ZX4e41Url6fPf
	2vaJduOX0Leegu7ajO9PD/WkhYDyhnQ4YofqBeT1PuT6wzzIgKiyueaLI3MQOmKei50NgCG4vfz
	yNfkMQypaNCS1uny5l3SrglBWkOfx0zbz1DzNMK4yTTDpVtKPS9C54IY38/ylfB+tF1MNPRFQPd
	+jziBosVYriGgWKseVhnZefMkyoWQBYMDMHaRhh5jvTH7GYvGvHSZXAeFt9lo+CshcL5Fnvymud
	kQaIze1VblVb58WUciCxQ4lnw+ME9/vvabF21mfX
X-Received: by 2002:a05:600c:a0a:b0:49e:84bf:6110 with SMTP id 5b1f17b1804b1-49fc56dbb49mr199597855e9.6.1790071101618;
        Tue, 22 Sep 2026 02:58:21 -0700 (PDT)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdab0c240sm27108755e9.4.2026.09.22.02.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 02:58:21 -0700 (PDT)
Message-ID: <2bf82e0b-a032-4ee7-8d93-c5604222723d@suse.com>
Date: Tue, 22 Sep 2026 11:58:18 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] Bring includes in linux/kmod.h up to date
To: petr.pavlu@suse.com
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Jens Axboe <axboe@kernel.dk>, Johan Hovold <johan@kernel.org>,
 Alex Elder <elder@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Michal Januszewski <spock@gentoo.org>, Helge Deller <deller@gmx.de>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>,
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Danilo Krummrich <dakr@kernel.org>, Nikolay Aleksandrov
 <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
 drbd-dev@lists.linux.dev, linux-block@vger.kernel.org,
 greybus-dev@lists.linaro.org, linuxppc-dev@lists.ozlabs.org,
 linux-acpi@vger.kernel.org, linux-fbdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 cgroups@vger.kernel.org, linux-modules@vger.kernel.org,
 linux-pm@vger.kernel.org, driver-core@lists.linux.dev,
 bridge@lists.linux.dev, netdev@vger.kernel.org, keyrings@vger.kernel.org,
 linux-security-module@vger.kernel.org
References: <20260911-module-include-kmod-v3-0-6ebccc3e0731@suse.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260911-module-include-kmod-v3-0-6ebccc3e0731@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/11/26 4:46 PM, Petr Pavlu wrote:
> The usermode helper declarations were previously provided by linux/kmod.h
> but commit c1f3fa2a4fde ("kmod: split off umh headers into its own file")
> moved them to linux/umh.h in 2017. Add explicit includes of linux/umh.h to
> files that use usermode helpers and remove linux/kmod.h where it is no
> longer needed.
> 
> Also add a missing include of linux/sysctl.h to kernel/time/jiffies.c.
> 
> Finally, clean up linux/kmod.h so that it includes only the headers that it
> actually requires, importantly removing the compat linux/umh.h include.
> 
> This cleanup is motivated by trying to reduce the preprocessed size of
> linux/module.h, which includes linux/kmod.h. linux/module.h appears in
> roughly 15k #include directives across the kernel. This makes it a "hot"
> header, so it should avoid pulling in unnecessary definitions. Note that
> this series doesn't immediately improve the situation, since most of the
> files included by linux/kmod.h are, for now, also included by
> linux/module.h through other paths.
> 
> Apologies for the wide distribution. Acked-bys are appreciated.

I've queued the series on modules-next for 7.4-rc1.

-- 
Thanks,
Petr
