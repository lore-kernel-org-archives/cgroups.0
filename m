From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH v3 net] inet_diag: add cgroup id attribute
Date: Fri, 3 Apr 2020 17:37:17 +0300
Message-ID: <c28be8aa-d91c-3827-7e99-f92ad05ef6f1@yandex-team.ru>
References: <20200403095627.GA85072@yandex-team.ru>
 <20200403133817.GW162390@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1585924638; bh=rZPKF6obiJ/krD77h4NfxBs/gQ6MdBgNCuwQmy0+SWU=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=Bi7CnL9+JFSdwQ7EcUVkkhRpD2i2IdQXd0BcCfjJsFqxyEALDQ7lW5MnXX+LRXBh6
         qx4CRVbfV5SdaYxpmSh1nqIMimnKICDPWUz+q2icQ/ZieWYbpb7l6sRNPQ0f2rOj3b
         ve+YHvl6czWpRy/Hld+/U7WxNsNN0AUww4jSXlhM=
In-Reply-To: <20200403133817.GW162390@mtj.duckdns.org>
Content-Language: en-CA
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Dmitry Yakunin <zeil@yandex-team.ru>
Cc: davem@davemloft.net, netdev@vger.kernel.org, cgroups@vger.kernel.org, bpf@vger.kernel.org

On 03/04/2020 16.38, Tejun Heo wrote:
> On Fri, Apr 03, 2020 at 12:56:27PM +0300, Dmitry Yakunin wrote:
>> This patch adds cgroup v2 ID to common inet diag message attributes.
>> Cgroup v2 ID is kernfs ID (ino or ino+gen). This attribute allows filter
>> inet diag output by cgroup ID obtained by name_to_handle_at() syscall.
>> When net_cls or net_prio cgroup is activated this ID is equal to 1 (root
>> cgroup ID) for newly created sockets.
>>
>> Some notes about this ID:
>>
>> 1) gets initialized in socket() syscall
>> 2) incoming socket gets ID from listening socket
>>     (not during accept() syscall)
> 
> How would this work with things like inetd? Would it make sense to associate the
> socket on the first actual send/recv?

First send/recv seems too intrusive.
Setsockopt to change association to current cgroup (or by id) seems more reasonable.

Systemd variant of inetd handles sockets as separate units and probably
creates own cgroups for them.

> 
> Thanks.
> 
