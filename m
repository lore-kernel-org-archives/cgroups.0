Received: from smtpout6.mo539.mail-out.ovh.net (smtpout6.mo539.mail-out.ovh.net [51.210.91.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE6E46AA97
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 10:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.210.91.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788346036; cv=none; b=m1PQkxvJXKrKTTzPayukeme/NZBY1KsUruiasfS+p/t66pqdzH6BARQ70xkE/2GVX+Ezw65B2ht532Jan45TQd/7h9QXx4dKJr4C+CLQACQI+pev3c1L+xX819w3jmU3dXh7xOy703p7MTh2S02HNmIqvPVFWiC60dPI5x5RqBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788346036; c=relaxed/simple;
	bh=vkmLNeytkmmADJpmoPjfoBRLyiiE3N6FyjPY0EorhOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YtkNPiTUEYH/T63DVR77yg2+pB6YjHvcNWM772AYs1bVahkoE7UVL84syrK2hYfIx/FOeFMCJqF65wAQrEcapIxQ7RsiBgTt0HVAaHAo5gwY6DfoeCGqKFl5DLve4uMF7Ar8hO+ecJmLMogL5yZ7+jRu7O/cBlto2hA9e+VibuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pixelcluster.dev; spf=pass smtp.mailfrom=pixelcluster.dev; dkim=pass (2048-bit key) header.d=pixelcluster.dev header.i=@pixelcluster.dev header.b=BwzgO8w2; arc=none smtp.client-ip=51.210.91.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pixelcluster.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pixelcluster.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pixelcluster.dev header.i=@pixelcluster.dev header.b="BwzgO8w2"
Received: from director3.derp.mail-out.ovh.net (director3.derp.mail-out.ovh.net [79.137.60.223])
	by mo539.mail-out.ovh.net (Postfix) with ESMTPS id 4hZdlk4rVJz47dh;
	Wed,  2 Sep 2026 10:10:42 +0000 (UTC)
Received: from director3.derp.mail-out.ovh.net (director3.derp.mail-out.ovh.net. [127.0.0.1])
        by director3.derp.mail-out.ovh.net (inspect_sender_mail_agent) with SMTP
        for <manushprajwal555@gmail.com>; Wed,  2 Sep 2026 10:10:42 +0000 (UTC)
Received: from mta2.priv.ovhmail-u1.ea.mail.ovh.net (unknown [10.110.178.159])
	by director3.derp.mail-out.ovh.net (Postfix) with ESMTPS id 4hZdlk1sGsz1xpW;
	Wed,  2 Sep 2026 10:10:42 +0000 (UTC)
Received: from pixelcluster.dev (unknown [10.1.6.4])
	(Authenticated sender: nat@pixelcluster.dev)
	by mta2.priv.ovhmail-u1.ea.mail.ovh.net (Postfix) with ESMTPSA id 992443E1BA1;
	Wed,  2 Sep 2026 10:10:41 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-114S00858de9c68-fa74-4ade-82ab-19872987c287,
                    B996090B10F39224A8AB3EB696AF7E9E468EAB8C) smtp.auth=nat@pixelcluster.dev
X-OVh-ClientIp:88.133.252.134
Message-ID: <d1e18ac8-b1fb-4ab8-9fc6-d740db710d70@pixelcluster.dev>
Date: Wed, 2 Sep 2026 12:10:40 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cgroup/dmem: fix comment typos in dmem.c
To: Manush Prajwal <manushprajwal555@gmail.com>,
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>
Cc: cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20260813104236.1532-1-manushprajwal555@gmail.com>
Content-Language: en-US
From: Natalie Vock <nat@pixelcluster.dev>
In-Reply-To: <20260813104236.1532-1-manushprajwal555@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-ovh-tracer-id: 17735738285141221654
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTFKwvEwJGcol71AQsTfjZh+kAcN8JhsUvTMjq8Wg9RU1brlYQm6y2KM0yGfMU3knXqmE9bR6MDU40xhZExcGcGUOng6qpgXku9F6+O4Em+4rOhEbNAYev/CF01ePlvBSRNR/sBxJWI3dfvWXz07yCUKlqxnmU9xli5d3wAig6FzChFUQxBo4+9o+bPNNQBu8pEj3ZVqQKT+x0QpHRef3oxETopGj4WoXOzR9teZwWO6oxod/OqESQeu2Hb5WEiZ26UlWeOlYf6mFnv2kdqP6qyoIDw666ZpB/zV9/ZPBdyDHkFsBMkwx5mTgIPjdTTwGR90BoWxuZK7l7e78aO5f1nwlUs8+PSyYu5BoWayGGWxAfB6peNuoYZfjLfIuTA7MH+VIXW84D6hBjtty9q9loHF5AJuin8Jl+E+wp/rXPVOsv3FTbiUxNSrwTnGvLWfpeRHdbAPN5fBtV8HBzuBhVxUkUNj0rsdYK8rqd9SezFR02upyhSKb50W7yVPT2qY9qeev/QrPmASmXVskp26nyHWo22yhgoPLjOPvMO31+82CCgUt2ksjA3om0fao7CAtuuYHczn9bMqGbXtCPFUh0kfdwCOJBJ+ou56/NBvXniDU0WUPHiHlzT89YptbJJG0FNWHGuHT4VTEr9w5oyCjrOskx2sMXWpy0RZ1RHMrktu3g
DKIM-Signature: a=rsa-sha256; bh=dTxKNAElDwuk3yxcmSsfpCU+x1Yc1pV/uiHtmuZKsp8=;
 c=relaxed/relaxed; d=pixelcluster.dev; h=From; s=ovhmo-selector-1;
 t=1788343843; v=1;
 b=BwzgO8w2FfozGyJe8MLsWjORab1jAWNM7fuXrUN9hJyl6e3WJPXIjTgNwvFvTVBwxSMbSGyy
 DxfuDsoSeGBV7fNqbXYcu/lGbJGoW65Z1WWR2/d2jtcM2vWsPqGKGxqLZfm8T5Uu7bciOdkeDlJ
 fiuwYqjF0B2cyoAFw2Fv2EJtTP3jPTbG/md1QCj8FjrPqB8fyPN/t7PF/cKCCPPz5MhrBmOvRhE
 fcmgQ+ouL5BtKfnKINHErLjVSSLkxX3lCKYE85dy4BnJQzXd55fGF0GOx7lM5nUhXVEt0ywQT4i
 n2sbZeU0uTOrTRhekEYHDOESoWOOgniKtI+k0yFtNhhGA==

Hi,

On 8/13/26 12:42, Manush Prajwal wrote:
> Fix "succesful" -> "successful" (x2) in the kernel-doc for
> dmem_cgroup_region::ref and dmem_cgroup_try_charge(). No functional
> change.
> 
> Signed-off-by: Manush Prajwal <manushprajwal555@gmail.com>

Reviewed-by: Natalie Vock <nat@pixelcluster.dev>

and applied to drm-misc-next. Thank you!

Best,
Natalie
> ---
>   kernel/cgroup/dmem.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
> index 4753a67d0f..342ea5324e 100644
> --- a/kernel/cgroup/dmem.c
> +++ b/kernel/cgroup/dmem.c
> @@ -21,7 +21,7 @@
>   struct dmem_cgroup_region {
>   	/**
>   	 * @ref: References keeping the region alive.
> -	 * Keeps the region reference alive after a succesful RCU lookup.
> +	 * Keeps the region reference alive after a successful RCU lookup.
>   	 */
>   	struct kref ref;
>   
> @@ -634,7 +634,7 @@ EXPORT_SYMBOL_GPL(dmem_cgroup_uncharge);
>    * dmem_cgroup_try_charge() - Try charging a new allocation to a region.
>    * @region: dmem region to charge
>    * @size: Size (in bytes) to charge.
> - * @ret_pool: On succesfull allocation, the pool that is charged.
> + * @ret_pool: On successful allocation, the pool that is charged.
>    * @ret_limit_pool: On a failed allocation, the limiting pool.
>    *
>    * This function charges the @region region for a size of @size bytes.

