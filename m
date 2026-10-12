Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982824BF949;
	Mon, 12 Oct 2026 17:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791827731; cv=none; b=tXKXoBbWKHvVD/uA3yI5lieoEC8KFiMTEIG1Ur543buPqL+upIsK/5u6Yi/ejEcaKFtHRa+DxpBxsZsd2Y8J2Qpm7gVKWdHQcmpScU4npFR1ksSEad9zc1RVjcbyt61FL2iUXB0d+WZk/D3YKoZEGWZcGZx35jmt73NkFeUBHNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791827731; c=relaxed/simple;
	bh=iQCsw8uWpkZoYq4YSbm5YHjbLGN+kSPUtNUTOefnYNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NR6NNcFusZDjQ+fiGxXZh4jNm0unfZZ1AkoFiTi9JaysXOyvNbS8aDqrKCtBZOi2+p/9OH34Xt+g4LMGmQ/tu5aCXsaY9kc54ohSIiUuSMJsJMDRpNXbDTOJyzUOI76wQVzmI3Rkkpjd4tPWc1HLiXU9Hj3m5k5h44QoTeGAKnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BVrURADp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BVrURADp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0061F0089B;
	Mon, 12 Oct 2026 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791827730;
	bh=J6n50eQ6V6pm/yCK3IlU6OVvJN5nG9cOEO098JYwwjc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BVrURADp1C8qVzrqLzvEPNHgiBxziCjaeMHJ0+mFb6UlZRKScmQV7vpqt/3eMKKBf
	 Kt1OVCcCSI5QxX27NGiDPfN6DnmsKHHBzNWExVlaijVqx98s6g+04t7Qha0RzzU+cm
	 EU36JDQ9rY/7RdGGhcJgswDE11gV62/RoITeMTPtTSbRV/lJMsD0+T2+lw5+27XDeZ
	 NSIEfvd8kHFDWoeeMCgo96BzPS31dyiC1FJkZLXFwNVhgWaJZ6epV8PYaBoAtbdnQW
	 KLpAmZeDS4J92RhFNACKOzt/BNJ6RTT1HruDVrTS74WhOCBTEDymQI0hNNKqq/V7mL
	 X5vM3rxGFOIrg==
Message-ID: <38befa8c-3885-44eb-813c-0ee34cd55248@kernel.org>
Date: Mon, 12 Oct 2026 19:55:25 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Content-Language: en-US
To: Kees Cook <kees@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, Pedro Falcato
 <pfalcato@suse.de>, Kuniyuki Iwashima <kuniyu@google.com>,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20261006092035.166776-2-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/6/26 11:20, Kees Cook wrote:
> Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
> alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
> accounted only through SLAB_ACCOUNT on its bucket caches. With
> CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
> kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
> which do not account it; the same happens when kmem_buckets_create()
> fails. Either way, the allocation is not charged to the sender's memory
> cgroup.
> 
> Allocate with GFP_KERNEL_ACCOUNT again, as before that commit. Memcg
> charges such an allocation in whichever cache serves it, so drop the
> SLAB_ACCOUNT, which no longer adds anything.
> 
> Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
> CONFIG_SLAB_BUCKETS as y and n.
> 
> Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>

Could we, for the purposes of a backportable fix, just have both
SLAB_ACCOUNT and GFP_KERNEL_ACCOUNT in place? That should do the right thing
regardless of CONFIG_SLAB_BUCKETS state, no?

> ---
>  ipc/msgutil.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/ipc/msgutil.c b/ipc/msgutil.c
> index e28f0cecb2ec..1ba8e59cb255 100644
> --- a/ipc/msgutil.c
> +++ b/ipc/msgutil.c
> @@ -43,7 +43,7 @@ static kmem_buckets *msg_buckets __ro_after_init;
>  
>  static int __init init_msg_buckets(void)
>  {
> -	msg_buckets = kmem_buckets_create("msg_msg", SLAB_ACCOUNT,
> +	msg_buckets = kmem_buckets_create("msg_msg", 0,
>  					  sizeof(struct msg_msg),
>  					  DATALEN_MSG, NULL);
>  
> @@ -58,7 +58,8 @@ static struct msg_msg *alloc_msg(size_t len)
>  	size_t alen;
>  
>  	alen = min(len, DATALEN_MSG);
> -	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen, GFP_KERNEL);
> +	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen,
> +				 GFP_KERNEL_ACCOUNT);
>  	if (msg == NULL)
>  		return NULL;
>  

