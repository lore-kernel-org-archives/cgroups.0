From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH -next] writeback: fix -Wformat compilation warnings
Date: Thu, 14 Nov 2019 19:26:21 -0500
Message-ID: <9D52EBB0-BE48-4C59-9145-857C3247B20D@lca.pw>
References: <20191114192118.GK4163745@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=0tFAznP/o2VP74kg2CnbkybxNqllPHihT5bPzStJDZw=;
        b=gHpgVYE7BklA5dff+/FV7O0g+fRSURY17JLB+bDgYYI/ULYrMLGXLVtkDm3WaUmTzW
         3BJWsOf0KeIsLbFLz7WeJMYhF3EoWf2p5sGlaWaImptYaHx+nD/npZxIZ2bbxnuB9/Q7
         VnVasKuq9iGMAPrU2lcqF4mtbvEuwO4uOQ7wC5WEeh7f8fbVwVCpPdvFAt5SG9Ve9wPz
         6AGaX5Y17XDcMMX+gVtHiXtYgWY3eTueQ7KH+hbbz/pYkaf7+9vKm5LZLloba606odtZ
         bQY1BV7qU/IkcjkJ22KjAK66OwybBtbHJukxQ4pH6mbHCY7ywayi02S7CbKQ981R0aTM
         Vh+w==
In-Reply-To: <20191114192118.GK4163745@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: jack@suse.cz, gregkh@linuxfoundation.org, cgroups@vger.kernel.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, linux-s390@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org



> On Nov 14, 2019, at 2:21 PM, Tejun Heo <tj@kernel.org> wrote:
>=20
> Acked-by: Tejun Heo <tj@kernel.org>

Tejun, suppose you will take this patch via your tree together with the seri=
es or should I Cc Andrew who normally handle this file?=
