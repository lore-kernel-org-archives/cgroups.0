From: Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 04/10] memcg: Introduce __GFP_NOACCOUNT.
Date: Sat, 3 Mar 2012 16:10:34 -0800
Message-ID: <CABCjUKBP=pKgDP5RkD4BimTjoE=bQQO7NxNNAiGUfy602T4c7A@mail.gmail.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
	<1330383533-20711-5-git-send-email-ssouhlal@FreeBSD.org>
	<20120229150041.62c1feeb.kamezawa.hiroyu@jp.fujitsu.com>
	<CABCjUKBHjLHKUmW6_r0SOyw42WfV0zNO7Kd7FhhRQTT6jZdyeQ@mail.gmail.com>
	<20120301091044.1a62d42c.kamezawa.hiroyu@jp.fujitsu.com>
	<4F4EC1AB.8050506@parallels.com>
	<20120301150537.8996bbf6.kamezawa.hiroyu@jp.fujitsu.com>
	<4F522910.1050402@parallels.com>
	<CABCjUKBngJx0o5jnJk3FEjWUDA6aNTAiFENdEF+M7BwB85NaLg@mail.gmail.com>
	<4F52A81A.3030408@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=geyW3H2M7uSwUyxMJNTZNn/zSEcWtn7t31V//zuNuiI=;
        b=U0dwXUAgnvTA9Dk4W8LVYymAvpWvRw7lJzD3rregLSsHDDB05TyxwM/VZh9qvTxq+b
         scY41hamw5O8XnAnPCenM5ivSHPrPTnr9pRTEywXe+i3Un1HiSMkcFSzJjfd4tDvBlrw
         Si73OmAm0zHBRjbNoMeKfw3s+pUoZxVnBp35snVZkyMDoMuFhmKS7NQf8JRrWf0IlAzB
         SRIz8HSCN2BN+9msVUpk2q0HawaWzWW04G97MDzSNDhMWV6+Ez2kEr2+VCJv/1dRPTk+
         aa/u5Bd0gpgaQ+alT2cwsvlKxSAtktOLowkjaQz4SWCP02dvVcpgG49KrufAlGXOAmAQ
         gfVw==
In-Reply-To: <4F52A81A.3030408@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Suleiman Souhlal <ssouhlal@freebsd.org>, cgroups@vger.kernel.org, penberg@kernel.org, yinghan@google.com, hughd@google.com, gthelen@google.com, linux-mm@kvack.org, devel@openvz.org

On Sat, Mar 3, 2012 at 3:24 PM, Glauber Costa <glommer@parallels.com> wrote=
:
> On 03/03/2012 01:38 PM, Suleiman Souhlal wrote:
>> Another possible example might be the skb data, which are just kmalloc
>> and are already accounted by your TCP accounting changes, so we might
>> not want to account them a second time.
>
>
> How so?
>
> struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int fclone, int no=
de)
> {
> =A0 =A0 =A0 =A0[ ... ]
> =A0 =A0 =A0 =A0cache =3D fclone ? skbuff_fclone_cache : skbuff_head_cache=
;
>
> =A0 =A0 =A0 =A0/* Get the HEAD */
> =A0 =A0 =A0 =A0skb =3D kmem_cache_alloc_node(cache, gfp_mask & ~__GFP_DMA=
, node);

Just a few lines below:

        data =3D kmalloc_node_track_caller(size, gfp_mask, node);

-- Suleiman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
