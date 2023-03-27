From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 7/7] block: make blkcg_punt_bio_submit optional
Date: Mon, 27 Mar 2023 17:32:10 -0600
Message-ID: <bfbb5ac8-60f2-2212-1ec4-5baaee7a5765@kernel.dk>
References: <20230327004954.728797-1-hch@lst.de>
 <20230327004954.728797-8-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679959932; x=1682551932;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nzG4Gg7xIaFW9NxPXDSLRapeOggi9FCFkBSxpmUKMiE=;
        b=1RQxRkrglPTErlI0U/PiFpHVr5ejmrxc/OCGg1hCtIbIzQEPzIoej6lelnQsLX6CJN
         9Ne11OkFXot/OFpO24BTU2NOR7MS4njpY6Xg39tzGib/2x1QZ2AkTtw8U06PFpoAVpZc
         SB+YEmo2RrmJqS4l0dfcT1JZPITpV7qjbEkyEGjfn5pPFjvUIJY/dKngy52nILNPGRzY
         wWIu7d2U490aafBxBaBuoFnIhtDwujXLL0pM68Kh5gf40VN0fHyRduECcaISlzwrxNxC
         f9rU/aoOY5WGX4Txt7+8TpTgqw+vC/u38DzH5972BpvoBnjADwAC1nNhGMtjVPdKth4D
         jNQQ==
Content-Language: en-US
In-Reply-To: <20230327004954.728797-8-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org

On 3/26/23 6:49=E2=80=AFPM, Christoph Hellwig wrote:
> Guard all the code to punt bios to a per-cgroup submission helper by a
> new CONFIG_BLK_CGROUP_PUNT_BIO symbol that is selected by btrfs.
> This way non-btrfs kernel builds don't need to have this code.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

--=20
Jens Axboe


