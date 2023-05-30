From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: Re: [PATCH v2 3/4] sock: Consider memcg pressure when raising
 sockmem
Date: Tue, 30 May 2023 17:58:14 +0800
Message-ID: <529f97d7-d9b7-2049-0c9d-a8d6a23b430b@bytedance.com>
References: <20230522070122.6727-1-wuyun.abel@bytedance.com>
 <20230522070122.6727-4-wuyun.abel@bytedance.com>
 <20230525012259.qd6i6rtqvvae3or7@google.com>
 <73b1381e-6a59-26fe-c0b6-51ea3ebf60f8@bytedance.com>
 <20230529211205.6clthjyt37c4opju@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev+bounces-6317-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685440700; x=1688032700;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bmz6Z7NUWk0U026+5Q0T6CzUzMYytLkTng8HlWy5Lg4=;
        b=iettzvPTOMlgAHfkVY1pS+qqpIpB2PLO5C8dRw6KQRujBajTAL8JD/241Bty/FRLjz
         9s4iBi5fUThcbTsop2dBSPpWY8pQlaROVBqEShVgYP2QADtbotxRMzdurP4sveqF4v5l
         bep8dihv0HzugpAtHfbYgA9QSk+bN9QuV6G/i2qx2JC57dXj85puYaB4rwWAB2hHSfo3
         HtQNjQVoSoQ1gqKdnESow3SdjfNShjC5FxSWHmqXreZrB1WSWpc3Rnk9x5ICwkavB/2N
         h3IjZm8TacNSoTjLzCxgvkdlRjTk9O4eLCLKj+0vOksGRzCpNIohHIq+3jgaBLTMwvI5
         inJg==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <20230529211205.6clthjyt37c4opju@google.com>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Shakeel Butt <shakeelb@google.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On 5/30/23 5:12 AM, Shakeel Butt wrote:
> 
> +linux-mm and cgroups
> 
> On Mon, May 29, 2023 at 07:58:45PM +0800, Abel Wu wrote:
>> Hi Shakeel, thanks for reviewing! And sorry for replying so late,
>> I was on a vocation :)
>>
>> On 5/25/23 9:22 AM, Shakeel Butt wrote:
>>> On Mon, May 22, 2023 at 03:01:21PM +0800, Abel Wu wrote:
>>>> For now __sk_mem_raise_allocated() mainly considers global socket
>>>> memory pressure and allows to raise if no global pressure observed,
>>>> including the sockets whose memcgs are in pressure, which might
>>>> result in longer memcg memstall.
>>>>
>>>> So take net-memcg's pressure into consideration when allocating
>>>> socket memory to alleviate long tail latencies.
>>>>
>>>> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
>>>
>>> Hi Abel,
>>>
>>> Have you seen any real world production issue which is fixed by this
>>> patch or is it more of a fix after reading code?
>>
>> The latter. But we do observe one common case in the production env
>> that p2p service, which mainly downloads container images, running
>> inside a container with tight memory limit can easily be throttled and
>> keep memstalled for a long period of time and sometimes even be OOM-
>> killed. This service shows burst usage of TCP memory and I think it
>> indeed needs suppressing sockmem allocation if memcg is already under
>> pressure. The memcg pressure is usually caused by too many page caches
>> and the dirty ones starting to be wrote back to slow backends. So it
>> is insane to continuously receive net data to consume more memory.
>>
> 
> We actually made an intentional decision to not throttle the incoming
> traffic under memory pressure. See 720ca52bcef22 ("net-memcg: avoid
> stalls when under memory pressure"). If you think the throttling
> behavior is preferred for your application, please propose the patch
> separately and we can work on how to enable flexible policy here.

Ah I see. Thanks for providing the context. So suppressing the alloc
under memcg pressure could further keep senders waiting if SACKed segs
get dropped from the OFO queue.

> 
>>>
>>> This code is quite subtle and small changes can cause unintended
>>> behavior changes. At the moment the tcp memory accounting and memcg
>>> accounting is intermingled and I think we should decouple them.
>>
>> My original intention to post this patchset is to clarify that:
>>
>>    - proto pressure only considers sysctl_mem[] (patch 2)
>>    - memcg pressure only indicates the pressure inside itself
>>    - consider both whenever needs allocation or reclaim (patch 1,3)
>>
>> In this way, the two kinds of pressure maintain purer semantics, and
>> socket core can react on both of them properly and consistently.
> 
> Can you please resend you patch series (without patch 3) and Cc to
> linux-mm, cgroups list and memcg maintainers as well?

Yeah, absolutely.

Thanks,
	Abel

