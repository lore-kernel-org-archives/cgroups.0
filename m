From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [External] Re: [RFC PATCH] blk-throtl: Introduce sync queue for
 write ios
Date: Thu, 15 Dec 2022 06:42:34 -1000
Message-ID: <Y5tOejLZrpMzH8/w@slm.duckdns.org>
References: <20221206163826.10700-1-hanjinke.666@bytedance.com>
 <Y5et48VryiKgL/eD@slm.duckdns.org>
 <f42d81c1-47c8-e283-1259-8c554bf46c46@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bOgxA915+/U8If37/BdnD3/XyRRRxssxQl2Z8drtlFU=;
        b=ZHs0yZHmhddja5efzdbesgNr+m1zlfrN/YnHS6P0Z9lKUWafZeZemyjvbv59Df4vm4
         1H3d2fteVrh7ot92Y4AEg/5PaWOQjNcNvtm3ufmh+NZy+lEw8UQTqypTjW6Uba9HYdOC
         Adc5NJpWZnYgdy+Z18uk8a+TL+5SUFsmCS3enZ0ySxtDthzjCT7Soi493FLds+qPgyMO
         wrPjkAID2X7+1g3hCwbqrdASUGvcE2uXkRWN/B6GNtNGeUhjVzp56GfUhZtBQES8/e/h
         0OHDBVXAM+d5X06CKGVFFP06/2AFhOLlBF6PGksx+XmNVbSkp8GOnplhm5Gaxem3x4Yq
         RMmQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f42d81c1-47c8-e283-1259-8c554bf46c46-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

Sorry about the delay.

On Tue, Dec 13, 2022 at 11:55:16AM +0800, hanjinke wrote:
> If sq->queue[] were only classfied SYNC and ASYNC, some things may become=
 a
> little difficult to handle=E3=80=82As we put sync write and read together=
 into SYNC
> queue, the two may influence each other.
> Whit wbps=3D1M and rbps=3D100M configured, sync io likely be throtled whi=
le read
> ios after it may can be dispatched within the limit. In that case,
> maybe we should scan the whole SYNC queue to check read io.

Ah, yeah, you're right. The configuration per-rw so we have to split within.
Will review your latest patch.

Thanks.

--=20
tejun
