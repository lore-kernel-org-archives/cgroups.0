From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Subject: Re: [PATCH 0/5] Networking cgroup controller
Date: Thu, 25 Aug 2016 08:54:19 -0700
Message-ID: <CAF2d9jjXxjgJU1VWDERKkv4LRvmhpjpyx7Dx76egQx43aaXtmQ@mail.gmail.com>
References: <1470876798-4024-1-git-send-email-anaravaram@google.com> <20160824210357.GU8185@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=dE7pxuvCPAW//ISeW6XYEE2cnc2ef7K41s0ueTRUmDE=;
        b=Q0X2NAax+dqKFPoo/hLgYrGSQKC8muboc/4Yoe47XGWTZWj5mAzOvb9+hXt2sNMnOr
         hLDnFRXQSi12rErDZxzU8yAA+QtNgh3DOcvQDBdxMzm9ohw4ryvIxGCWBVNTZ/cwC4KD
         juHjaDtL7KZIKPFRorFPdeJ7ZdnzgD36DBTgWpWh84C4j2/xAVuvKBGElWzfsxrF9V7c
         BlMjT0+92p8N6KYtU8BP+KmxeR6XiDx3z0CN7qYV43azEXEoIWpcPbRwtc6S7MutDSBz
         vZWXhSA6xBkdhG34GAOHIirlj/H04XUT4T6oZJxjv9L/+FEWZ6ZV7K7CaYLIN5mwAYiK
         Es8g==
In-Reply-To: <20160824210357.GU8185@htj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: corbet@lwn.net, lizefan@huawei.com, hannes@cmpxchg.org, David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, linux-netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>, tom@herbertland.com

On Wed, Aug 24, 2016 at 2:03 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Anoop.
>
> On Wed, Aug 10, 2016 at 05:53:13PM -0700, Anoop Naravaram wrote:
>> This patchset introduces a cgroup controller for the networking subsystem as a
>> whole. As of now, this controller will be used for:
>>
>> * Limiting the specific ports that a process in a cgroup is allowed to bind
>>   to or listen on. For example, you can say that all the processes in a
>>   cgroup can only bind to ports 1000-2000, and listen on ports 1000-1100, which
>>   guarantees that the remaining ports will be available for other processes.
>>
>> * Restricting which DSCP values processes can use with their sockets. For
>>   example, you can say that all the processes in a cgroup can only send
>>   packets with a DSCP tag between 48 and 63 (corresponding to TOS values of
>>   192 to 255).
>>
>> * Limiting the total number of udp ports that can be used by a process in a
>>   cgroup. For example, you can say that all the processes in one cgroup are
>>   allowed to use a total of up to 100 udp ports. Since the total number of udp
>>   ports that can be used by all processes is limited, this is useful for
>>   rationing out the ports to different process groups.
>>
>> In the future, more networking-related properties may be added to this
>> controller.
>
> Thanks for working on this; however, I share the sentiment expressed
> by others that this looks like too piecemeal an approach.  If there
> are no alternatives, we surely should consider this but it at least
> *looks* like bpf should be able to cover the same functionalities
> without having to revise and extend in-kernel capabilities constantly.
>
My primary concern is the cost that need to be paid to get this functionality.
(a) The suggested alternatives eBPF either can't solve the problem in
the current form or need substantial work to get it done. e.g.
udp-port-limit since there is no notion of "maintaining
counters-per-group-of-processes". This is solved by the cgroup infra.
(b) Also the hooks implemented are mostly with a per packet cost vs.
once when you are establishing the channel. Also not sure if the LSM
approach will allow some privileged user to over-ride the filters
attached and thus override the limits imposed. This is on top of the
administrative costs that currently don't have solution for and you
get it for free with cgroup infra.

In short most of the associated problems are handled by the
cgroup-infra / APIs while all that need separate solution in
alternatives.  Tejun, feels like I'm advocating cgroup approach to you
;)

Thanks,
--mahesh..


> Thanks.
>
> --
> tejun
