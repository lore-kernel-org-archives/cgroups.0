From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 04/10] memcg: Introduce __GFP_NOACCOUNT.
Date: Wed, 29 Feb 2012 13:53:28 -0300
Message-ID: <4F4E5808.2020805@parallels.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org> <1330383533-20711-5-git-send-email-ssouhlal@FreeBSD.org> <20120229150041.62c1feeb.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120229150041.62c1feeb.kamezawa.hiroyu@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Suleiman Souhlal <ssouhlal@FreeBSD.org>, cgroups@vger.kernel.org, suleiman@google.com, penberg@kernel.org, yinghan@google.com, hughd@google.com, gthelen@google.com, linux-mm@kvack.org, devel@openvz.org

On 02/29/2012 03:00 AM, KAMEZAWA Hiroyuki wrote:
> On Mon, 27 Feb 2012 14:58:47 -0800
> Suleiman Souhlal<ssouhlal@FreeBSD.org>  wrote:
>
>> This is used to indicate that we don't want an allocation to be accounted
>> to the current cgroup.
>>
>> Signed-off-by: Suleiman Souhlal<suleiman@google.com>
>
> I don't like this.
>
> Please add
>
> ___GFP_ACCOUNT  "account this allocation to memcg"
>
> Or make this as slab's flag if this work is for slab allocation.
>
> Thanks,
> -Kame
>
>
+1.

This is enough to replace the registration I originally proposed, and I 
do think it'll do us good, despite the churn drawback of having to go 
patching stuff everywhere.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
