From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Subject: Re: [RFC][PATCH 4/7 v2] memcg: use res_counter_uncharge_until in move_parent
Date: Sat, 28 Apr 2012 08:59:08 +0900
Message-ID: <CABEgKgooq6EUFRC2-19QxACpGN5+EHn=OwPzk+tMBLy-pYM9XQ@mail.gmail.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A34B2.8080103@jp.fujitsu.com>
	<20120427182018.GI26595@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=t1wmI0havxL6AKNYHsrPCuvgaQtnHgO4VTCvTy9Q+kY=;
        b=NUXMkOPXHt1WCcYZES1ON81o/Gto5TpJfRN/loBNIlRe4SX8npkXCkPV9TPDXYVZbR
         ksKdzK/6uGdskfXHsWvVKHUzHmoixSX1vSPlP5KyacY4PsKarwUB0doKakarNWTqFVG6
         AC5VWBE2gWR4Jxa9IwZKNR+PiIncWwot20u0RHCWeS/kB5mwoqGEAnPDG/vYLXEO7+DC
         ahOk7cqYEc3TC/rx6Nqy1IzaaYtlie3WRvq4Ywt2dfvm0gwZqhlhcNON5sBCN8s/bPYS
         E+o9bFAWyU8W/rN8+CnHz8n7uNw5FhDEfpkbXHr2UJoFa3ng2REwQ6DTwRsb37YsqCo7
         dmEg==
In-Reply-To: <20120427182018.GI26595@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Linux Kernel <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Frederic Weisbecker <fweisbec@gmail.com>, Glauber Costa <glommer@parallels.com>, Han Ying <yinghan@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>

On Sat, Apr 28, 2012 at 3:20 AM, Tejun Heo <tj@kernel.org> wrote:
> On Fri, Apr 27, 2012 at 02:54:58PM +0900, KAMEZAWA Hiroyuki wrote:
>> By using res_counter_uncharge_until(), we can avoid
>> unnecessary charging.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>> =A0mm/memcontrol.c | =A0 63 ++++++++++++++++++++++++++++++++++++--------=
----------
>> =A01 files changed, 42 insertions(+), 21 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 613bb15..ed53d64 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2420,6 +2420,24 @@ static void __mem_cgroup_cancel_charge(struct mem=
_cgroup *memcg,
>> =A0}
>>
>> =A0/*
>> + * Cancel chages in this cgroup....doesn't propagates to parent cgroup.
>
> =A0 =A0 =A0 =A0 =A0 =A0 ^typo =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^ unnecessary s

Ya, thanks. I'll fix it.

-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
