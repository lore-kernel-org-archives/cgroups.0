From: Vasily Averin <vvs@openvz.org>
Subject: Re: [PATCH memcg v6] net: set proper memcg for net_init hooks
 allocations
Date: Mon, 6 Jun 2022 20:37:26 +0300
Message-ID: <0e714a5a-d2ed-9b44-fdbe-04b5595165da@openvz.org>
References: <6b362c6e-9c80-4344-9430-b831f9871a3c@openvz.org>
 <f9394752-e272-9bf9-645f-a18c56d1c4ec@openvz.org> <Yp4F6n2Ie32re7Ed@qian>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JrUCHDV/B4VsIskumMgOVA+zun0SZZfvJ9SUQK9Ped0=;
        b=hpch6RMMl19NjgUugT4b8eX/vUbvGeMyguIjW1q7ywrR/Nhc6fDnsHDWFxHhMX64Z6
         OdF4ERrF6B4Sip2D/a2woNKQeucy71ArF21CwisItz4umAXm60/4ZxyfHi0dT5fMj1vH
         YpcNVAqkKO0D9/Nf99PxbgIl+KHzfZuYdROKocmQFjZvsJlwy953ZFB+SZaDRy12nEp/
         E2rIXrQoD7AsDpdjLSANTi8R11+9R7VLnlHe2pX/4sI4BypamWK7DkKGK40Tku7WBEkH
         wmGJhQnYPcITS9wRYIbNMAwK+VCsl8lrCUcCYtCIFlC2PId8EXyc8WiUB56KToN7m58T
         Gc4A==
Content-Language: en-US
In-Reply-To: <Yp4F6n2Ie32re7Ed@qian>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Qian Cai <quic_qiancai@quicinc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, cgroups@vger.kernel.org

On 6/6/22 16:49, Qian Cai wrote:
> This triggers a few boot warnings like those.
> 
>  virt_to_phys used for non-linear address: ffffd8efe2d2fe00 (init_net)
>  WARNING: CPU: 87 PID: 3170 at arch/arm64/mm/physaddr.c:12 __virt_to_phys

Thank you for reporting the problem,
Could you please provide me your config file via private email?

Thank you,
	Vasily Averin
