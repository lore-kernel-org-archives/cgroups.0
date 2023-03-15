From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] io_uring/sqpoll: Do not set PF_NO_SETAFFINITY on
 sqpoll threads
Date: Wed, 15 Mar 2023 06:51:11 -0600
Message-ID: <167888467141.25248.3419360093103116663.b4-ty@kernel.dk>
References: <20230314183332.25834-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678884672; x=1681476672;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cZkbtoWja85fMLAbjXK98n41T/e7K5OhmawF7QD5eFY=;
        b=bF+iZZkg40UqrsVEUQ/fdqKax2RZLHQVGPSVjvFW4QDzwVaPa6RrvqjDS5UEoX/wpi
         o/VnZDCP288oppcit1QsMrBMIM4BVDfcEt4JgypAr/JIjyCqVFtah0iWYN2xhnPir9Cz
         sKtw8Qf5K0UgbzktJxeq1B0bG4oqgGtU58K3kWkTBhhEGeq4grRGDga3ocWxvwnRxrvk
         pEPQR0v2cxDvyz/HZqTEDr4AvjQj/BhyZm5M+ZDfps6IT1xaz1DeFBUAL1u5eivcP16q
         /jGik346ZKOzg3ufG7iUiSaRLzNfgMZQi6VoehmHoPZ16b2RGSdLZjJA0Tu58Bo5IF3A
         GP/A==
In-Reply-To: <20230314183332.25834-1-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: io-uring@vger.kernel.org, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>, Daniel Dao <dqminh@cloudflare.com>, Waiman Long <longman@redhat.com>


On Tue, 14 Mar 2023 19:33:32 +0100, Michal Koutn=C3=BD wrote:
> Users may specify a CPU where the sqpoll thread would run. This may
> conflict with cpuset operations because of strict PF_NO_SETAFFINITY
> requirement. That flag is unnecessary for polling "kernel" threads, see
> the reasoning in commit 01e68ce08a30 ("io_uring/io-wq: stop setting
> PF_NO_SETAFFINITY on io-wq workers"). Drop the flag on poll threads too.
>=20
>=20
> [...]

Applied, thanks!

[1/1] io_uring/sqpoll: Do not set PF_NO_SETAFFINITY on sqpoll threads
      commit: a5fc1441af7719e93dc7a638a960befb694ade89

Best regards,
--=20
Jens Axboe



