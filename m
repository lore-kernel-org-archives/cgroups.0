From: Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH 3/7 v2] res_counter: add res_counter_uncharge_until()
Date: Sat, 28 Apr 2012 08:51:42 +0900
Message-ID: <CABEgKgrqW++YxikPC4tzHA6Yad0YZx7fqfdaYQHXixF+eB6Bjw@mail.gmail.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A343F.7020409@jp.fujitsu.com>
	<20120427181840.GH26595@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=ypCZR9diIk7RfD0aD3EaJzr/CBWp/dYSfLQf5w746i0=;
        b=Nvz1YuSOocYO2FeX2q7hhSzlebgF/eEMXSZeMLGJWauX5AtXYTUs2aj6QPtXx9+d27
         Oxn3oX9aB+053Tb5SDTxMinYDdKLxsN/j/cercLDn4JGjpW8UMUaP29nYZwXajzSNOa4
         ZnmrKjzJ8ctCRTv0IGQ6S/PVov60qLhnerDfh390abHNXqzMYEQRcN+tWaBvG8hcVNFM
         C5Em2pY/XBVt7MCD8GFfRppezRA0Q7btYSlpkrY5qfgxkxZ1wJ0EkYJwMReszCOyGhXi
         RiLl9USmwqHYK5rASw6ckJdWqpL7z4+ii9YLzkihSf7hjEqxFh8Y9+SlnYlnc/a0F503
         B0Gw==
In-Reply-To: <20120427181840.GH26595-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sat, Apr 28, 2012 at 3:18 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Fri, Apr 27, 2012 at 02:53:03PM +0900, KAMEZAWA Hiroyuki wrote:
>> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
>> index d508363..f4ec411 100644
>> --- a/kernel/res_counter.c
>> +++ b/kernel/res_counter.c
>> @@ -66,6 +66,8 @@ done:
>> =A0 =A0 =A0 return ret;
>> =A0}
>>
>> +
>> +
>
> Contamination?

Ah, sorry. I'll fix.

-Kame
