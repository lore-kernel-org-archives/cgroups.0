From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH v3 net] inet_diag: add cgroup id attribute
Date: Fri, 3 Apr 2020 17:56:01 +0300
Message-ID: <20ba0af2-66df-00da-104a-512990c316d8@yandex-team.ru>
References: <20200403095627.GA85072@yandex-team.ru>
 <20200403133817.GW162390@mtj.duckdns.org>
 <c28be8aa-d91c-3827-7e99-f92ad05ef6f1@yandex-team.ru>
 <20200403144505.GZ162390@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1585925762; bh=Q7u3ANbO873KS0xB1AbSi27nApxQH0XfixpEWRWSarw=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=J6f1621N+JkGjuHiNs0fLjRg3rqlb5JEvKks79Yh6gBTXRN8g2wXq65tTVJ1QCYf2
         WIumpNhxdwK8ZKcQ/IkNJNH93yaiVHKhcjr5LiC++PYqpLxnEdqiRCIaegB/5Uxaxa
         ZkZiPi4CFs9Nj9IPk0+iAWwQpvYwovMIBYVKmWZg=
In-Reply-To: <20200403144505.GZ162390@mtj.duckdns.org>
Content-Language: en-CA
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>, davem@davemloft.net, netdev@vger.kernel.org, cgroups@vger.kernel.org, bpf@vger.kernel.org

On 03/04/2020 17.45, Tejun Heo wrote:
> On Fri, Apr 03, 2020 at 05:37:17PM +0300, Konstantin Khlebnikov wrote:
>>> How would this work with things like inetd? Would it make sense to associate the
>>> socket on the first actual send/recv?
>>
>> First send/recv seems too intrusive.
> 
> Intrusive in terms of?

In term of adding more code to networking fast paths.

> 
>> Setsockopt to change association to current cgroup (or by id) seems more reasonable.
> 
> I'm not sure about exposing it as an explicit interface.

Yep, it's better to create thing in right place from the beginning.
Current behaviour isn't bad, just not obvious (and barely documented).
That's why I've asked Dmitry to add these notes.

> 
> Thanks.
> 
