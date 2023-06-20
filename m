From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: Re: [RFC PATCH net-next] sock: Propose socket.urgent for sockmem
 isolation
Date: Tue, 20 Jun 2023 14:39:20 +0800
Message-ID: <8ac1034d-4ddf-86a6-a7dc-769bc5080fac@bytedance.com>
References: <20230609082712.34889-1-wuyun.abel@bytedance.com>
 <CANn89i+Qqq5nV0oRLh_KEHRV6VmSbS5PsSvayVHBi52FbB=sKA@mail.gmail.com>
 <b879d810-132b-38ab-c13d-30fabdc8954a@bytedance.com>
 <4p22vtjrpu4obmbjivgpe635gbpjmhsfisnxghgsson2g6yy5r@ovawhchw7maq>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687243172; x=1689835172;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=auJ6EJaNEhBlb5WUEu9u5pzfD1n3KesDYvPGRacKRpY=;
        b=Q0x5ZOGt4/v3wQppV0vu3j4kjyVREZuzdlXMoLL29N7NXduun7x+/qMKtZI9/fJvkE
         uXAJEwy/vwqunPx2kBUjpJnwRZJYHPKEU135M3wz8Lbji0KHP6SAo8dzYCyUA91hD2hK
         qQFY1wwfxb6zZ2hcn39cy6SQgMduj6ZO6UnIgFsg/LsEwb5s1ohxYtTnc3+lnKX4c4up
         9b0HQQSe2NnahNMiG0Ue1NNNiQHRN1pqAwwNk3vqHBW6OZsxoTORWGTDR/hX/gVasPBI
         RgeSOvQLSLXUsLXt6N2Sx/C/uwmT3Q+vwAAehP4zPVzFD3vAPrUxgSq1xPAf2WLJ68Is
         nDzw==
Content-Language: en-US
In-Reply-To: <4p22vtjrpu4obmbjivgpe635gbpjmhsfisnxghgsson2g6yy5r@ovawhchw7maq>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Eric Dumazet <edumazet@google.com>, Tejun Heo <tj@kernel.org>, Christian Warloe <cwarloe@google.com>, Wei Wang <weiwan@google.com>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Vasily Averin <vasily.averin@linux.dev>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Xi

Hi Michal,

On 6/20/23 1:30 AM, Michal Koutn=C3=BD wrote:
> On Tue, Jun 13, 2023 at 02:46:32PM +0800, Abel Wu <wuyun.abel@bytedance.c=
om> wrote:
>> Memory protection (memory.{min,low}) helps the important jobs less
>> affected by memstalls. But once low priority jobs use lots of kernel
>> memory like sockmem, the protection might become much less efficient.
>=20
> What would happen if you applied memory.{min,low} to the important jobs
> and memory.{max,high} to the low prio ones?

I might expect that the memory of low prio jobs gets reclaimed first.
Specifically we set memory.low to protect the working-set for important
jobs. Due to the best-effort behavior of 'low', the important jobs can
still be affected if not enough memory reclaimed from the low prio ones.
And we don't use 'min' (yet?) because the need for flexibility when
memory is tight.

Best Regards,
	Abel
