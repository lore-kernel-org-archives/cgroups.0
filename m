Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD81349690D
	for <cgroups@vger.kernel.org>; Wed,  8 Jul 2026 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783534413; cv=none; b=VnyKqUfw0R+Na4bfrO3kbJFVmxyvptoEzeK5JZsypLo74SrmaWi9HjQjZAPJLQGSo6xp838maXe5Wq351Gx3OrKwAnge+U0JSGg3Sl9aT2eRqrmwbsWlwoc4Ksdnqn3wPDv30eBqGoib2CmICFFOCMmAHdb1G2UvnmuDNzx0zpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783534413; c=relaxed/simple;
	bh=mKB64eFzBwevlbfHP4GHbGCdzZzNbk41FGpjUYsfux4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vEoS86mW1tplmHHNKnN7HFp271uew7huH/A3T2Al2r8nzcOuTrbe3M9gR4BEq4Fsc3lpVvT4eXb8UhLrdUQnwapZ92HlH6NFG5AmhzszJG2pRFROzF23rBSilWffYlFHzJPC6XwXmKt40WbspckTMcgq5EtHjaMec7XjltAurGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NXY/JxGv; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NXY/JxGv"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4758bd3731bso89861f8f.0
        for <cgroups@vger.kernel.org>; Wed, 08 Jul 2026 11:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783534407; x=1784139207; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WEMJWE1zcwQ4UkLGDHzDIo1wA9TMgoKtQk475YCTe6o=;
        b=NXY/JxGvymDRFrsijRMZ9tHdf1vok229JiWLzBHZwp/af9/Y7FHShzV1p28lfGDO0P
         Zjbde5zb79XSg/jwyzfbIjMg0JbSsUD456xvuSBgfX9elPAfqtA7LRQ4E5uq5/7exmey
         EqK3Ef4oiDQgW7SogTWxwIn9DFaDCNwAlfxgMTUAGHE1yhxkzaZ+/aNgxXqr5PJhJTbk
         YJ3U/xgt0mK8BckXQ4KsDSdGzsNpqaB1DoJXAjYrfk/nUDVL5XmP9eQo6rp9dUT4uRxU
         WqEtlylEfFx/GQK85wL6RWzG+tt8Cl+7EtXP6XzSYBHRNjkC+HgLsWCbnvW7fF2s9gZo
         WeaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783534407; x=1784139207;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WEMJWE1zcwQ4UkLGDHzDIo1wA9TMgoKtQk475YCTe6o=;
        b=UwGXlJ2Ekr36KcUn41Z4dSCNmNzYjgDKDXp7Vt+1l2xlDMnzispvwEAAKCx7HWNc4v
         o26m1NKIaBixOBIR6yW9nlH1m57HnYr6jVHxA+2k0wgRjS7xioKcJ1PVpHYSy3l9a4c4
         KkYyAOAz1oTG1X+lxweEokgk8+4d5Gu4k44AzBUNa8Um5wyKlm6mJxvKS4Y/cFOAKCh2
         LZ4luSFCxLqu9dLOZkPyg9ZP3YgeCTqof8Xcp+H93GkfEeHI3TbpW4NVHsH4NczMEb/f
         g3UHSoNHeUZtYMozV5y0ALqW5Vr1I+dMEzrYo60N+8dRryRq1YeGEP3BC7GtgSHU1Amc
         r6hQ==
X-Forwarded-Encrypted: i=1; AHgh+RqepS5iXy4HzZgxtcsPcHNJW8sdmg1doP81xafA4p/bNr2McuoKSh3no4qlZLhW7uju23yLpCs/@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7PdwVeBiWVnIXnHK7FAHWmpA/kMr2+tVy1oLIWqCIH02afRge
	IMusAkIAEwgYwLfph/WKWurXjrT5wfJcB1kyOTb8GydvEHK7LFvuB4Yjf8Ei9PaS3CM=
X-Gm-Gg: AfdE7cmLwvr5yBqZGzYM5ZfNUvJI/Dv6AxJ5wK4rcQ6d06W8lpXZ9kAFZ6XQaU2eVSX
	opq13luMRtGC+cXD7HCcahnRWVpdzq44Evak0S0DjneSL+G6GbJmrg1Yac5Ro3S6gil4vMOfMy9
	UdjceAL2AJq/5bfeV4nnN6CP+UjHyqY0fGOaXiM6iAau9QbPLsDttYAyvTby8NIMjvfF5RANC6Q
	A5xTKgESpAJ7yo99wJOgRhcb6qttv82xqgWr9NCTasItqQJZa0hpzvHcheqeGHlrKeSv6LBaDq+
	W6ejvcn9dlO2rR4KNWJD/vdGDMo9h6lstg28YtiEUhJlANvfCKvKEb5sjJzY3nsxLmbXZJUUeFJ
	WhYuJKT+Xh/K3WDg3nD/6vjHVfXGgVoqre8fV2VZ3KwQ/ObeMt90SpdC8MdIcC0gQSDgWwx2Uhi
	Kmj7uAwUXWnQFjS7GDSdvviaXBkO0ZAuYb9uCt8g==
X-Received: by 2002:a05:6000:460c:b0:473:c608:eeb5 with SMTP id ffacd0b85a97d-47de9a4f159mr9196162f8f.29.1783534406837;
        Wed, 08 Jul 2026 11:13:26 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1d910sm43325516f8f.6.2026.07.08.11.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:13:26 -0700 (PDT)
Date: Wed, 8 Jul 2026 20:13:23 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, 
	Christoph =?utf-8?Q?B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>, Johan Hovold <johan@kernel.org>, 
	Alex Elder <elder@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Michal Januszewski <spock@gentoo.org>, 
	Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Danilo Krummrich <dakr@kernel.org>, 
	Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org, 
	drbd-dev@lists.linux.dev, linux-block@vger.kernel.org, greybus-dev@lists.linaro.org, 
	linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, cgroups@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-pm@vger.kernel.org, driver-core@lists.linux.dev, bridge@lists.linux.dev, 
	netdev@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] umh, treewide: Explicitly include linux/umh.h where
 needed
Message-ID: <ak6STbqZd-Q-c56v@localhost.localdomain>
References: <20260708154510.6794-1-petr.pavlu@suse.com>
 <20260708154510.6794-2-petr.pavlu@suse.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kijzkd5xnaepafl2"
Content-Disposition: inline
In-Reply-To: <20260708154510.6794-2-petr.pavlu@suse.com>


--kijzkd5xnaepafl2
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/2] umh, treewide: Explicitly include linux/umh.h where
 needed
MIME-Version: 1.0

Hi Petr.

On Wed, Jul 08, 2026 at 05:44:29PM +0200, Petr Pavlu <petr.pavlu@suse.com> =
wrote:
> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> index a4337c9b5287..60eb994c32ae 100644
> --- a/kernel/cgroup/cgroup-v1.c
> +++ b/kernel/cgroup/cgroup-v1.c
> @@ -16,6 +16,7 @@
>  #include <linux/pid_namespace.h>
>  #include <linux/cgroupstats.h>
>  #include <linux/fs_parser.h>
> +#include <linux/umh.h>
> =20
>  #include <trace/events/cgroup.h>

There is kmod.h in here too but it's unnecessary, no module lazy loading
in this code.

Thanks,
Michal

--kijzkd5xnaepafl2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCak6TOhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgY2gEAgOkCGIEUNQ8/AFfxYtdb
0XG1ZQXkD0d1Rm0cAq1+u8cBANw3nWI/wHkp5zcHmZWevxdnweU507gsyVTXzMGQ
ZwsB
=k+w6
-----END PGP SIGNATURE-----

--kijzkd5xnaepafl2--
