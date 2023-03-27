From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 6/7] block: async_bio_lock does not need to be bh-safe
Date: Mon, 27 Mar 2023 17:31:59 -0600
Message-ID: <ed386649-90cb-8cfa-c2e4-95807cdb8810@kernel.dk>
References: <20230327004954.728797-1-hch@lst.de>
 <20230327004954.728797-7-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679959921; x=1682551921;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0fNEczN0672QN/RMb20IlcIW8cCEXe1UxR00CCFgmLY=;
        b=IB9NkwSe9JOio9TPyh9zvgMoNWxTA3mqFueBcMJO1UPfRJhj2qD57M88v7SjQ6AWiK
         K3vjEIV+oGgvpg6o9HUFmyw2Rk81bOFqwWniPAYee6AUVMGPOoQCynGz+Tq8yKtNTRr3
         zOqejmEg9a73aDLAf72/ul/sdwaIFsHIzkYntQkBe3xvdwIJnOqjBo3/e6wXShA+pLcA
         0NOGV6X3KdpR1OoaV6jClRrcYbd/LrenVZyEwDkTonaVBkvpO8HRy1PVSN9SwjzP/DOy
         XFSN69DyQWMqu6H0h6IwrnlWEe2WMA89s4CtFYXsYWzXFVYIBRoOHctGsp7Lf1EXtrQ6
         UbhQ==
Content-Language: en-US
In-Reply-To: <20230327004954.728797-7-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org

On 3/26/23 6:49=E2=80=AFPM, Christoph Hellwig wrote:
> async_bio_lock is only taken from bio submission and workqueue context,
> both are never in bottom halves.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

--=20
Jens Axboe


