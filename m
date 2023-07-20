From: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: Re: [PATCH RESEND net-next 1/2] net-memcg: Scopify the indicators
 of sockmem pressure
Date: Thu, 20 Jul 2023 19:34:20 +0800
Message-ID: <be65ab74-8ee4-9ae5-f0ff-88c9fd2fbeb5@bytedance.com>
References: <20230711124157.97169-1-wuyun.abel@bytedance.com>
 <d114834c-2336-673f-f200-87fc6efb411f@bytedance.com>
 <CANn89iLBLBO0CK-9r-eZiQL+h2bwTHL2nR6az5Az6W_-pBierw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689852874; x=1690457674;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0RmeowStXIEPULQOAaOWZp78vxjHDoSNjkADxM9sQfc=;
        b=M0DrMvL74mRRIv17Hv8ig5J7sQWnEZTZf84dLaKCQsXxQtcIgMlfIxVoaUskKOWIQp
         fc302CL33o59MSl/yZvbZ3cRlyAqQ9Kh0p54L4s336jjQljCzQbPmPNSghHWbn49o8Ql
         nQIvdHMaKpDxF1KLMqkeUTAACQaYlmmEtxaIsbMJ5xyfdUTgLnJEACez6gA4w3gnEy1b
         ILbyO3KvZmyrBsyIkE4hD01a9/9tAVPHEyBG1j5r2rIVFiUjio2hrkrjITfr0xQYaSJY
         53iJT35RsFQW7KN5Czi4n0AEmfUDUCTM9PP9fUG9bs9UyQrpj0H+HtBmSr/2nv9oXdjM
         EPaA==
Content-Language: en-US
In-Reply-To: <CANn89iLBLBO0CK-9r-eZiQL+h2bwTHL2nR6az5Az6W_-pBierw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kuniyuki Iwashima <kuniyu-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Martin KaFai Lau <martin.lau-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Mikhalitsyn <alexander-uFy+/5nkmnuaMJb+Lgu22Q@public.gmane.org>, Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Xing <ker>

On 7/20/23 4:57 PM, Eric Dumazet wrote:
> On Thu, Jul 20, 2023 at 9:59=E2=80=AFAM Abel Wu <wuyun.abel-EC8Uxl6Npydl5=
7MIdRCFDg@public.gmane.org> wrote:
>>
>> Gentle ping :)
>=20
> I was hoping for some feedback from memcg experts.

Me too :)

>=20
> You claim to fix a bug, please provide a Fixes: tag so that we can
> involve original patch author.

Sorry for missing that part, will be added in next version.

Fixes: 8e8ae645249b ("mm: memcontrol: hook up vmpressure to socket=20
pressure")

Thanks!
	Abel
