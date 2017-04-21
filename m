From: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] cgroup: define empty cftype structure for !CONFIG_CGROUPS
Date: Fri, 21 Apr 2017 15:56:36 -0600
Message-ID: <87094d9f-c6eb-567c-74d9-ff00e4ae5b3c@fb.com>
References: <20170421214206.1825504-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : cc : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=facebook;
 bh=k99Jc2cOcy5ncBj365fWq9ajvhS1ZDA7w4wSvIPSMMc=;
 b=jhedGCnm+tvd2cknY8wCX8VX6bBKM2x+xtKpXtyhg58dPoRuC79Bzwj1nmY8rNZ/QAE8
 yZ8xRErsc9g86SyHDPCXasXKCS5lMjwVNRYEsPDia9rwh3H0LDBvkkxhR7XVBrfga4d+
 nu10SVgv6GlH1GLmI369PokJqSwlmWlvraQ= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=k99Jc2cOcy5ncBj365fWq9ajvhS1ZDA7w4wSvIPSMMc=;
 b=DmRwLGbQIf6Cgt1w0aGOiENgNjcuiQ2a7cYjNBHLZEGNybw8OOQraOHCJ6eDC4q8Cpj4KfRi2kCBN+/JqFt1tJbyVXTxjobSVpEX9ZCvv7XJOI/xkHmz5yEEfikZkBCKphK0MZ03KITZL0i0F02siYPx8pYpjRSc6T08jeVizP8=
In-Reply-To: <20170421214206.1825504-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 04/21/2017 03:41 PM, Arnd Bergmann wrote:
> There is a new forward declaration for two global cftype arrays, but
> that fails to build when CONFIG_CGROUPS is disabled:
> 
> In file included from /git/arm-soc/block/bfq-iosched.c:105:0:
> block/bfq-iosched.h:820:22: error: array type has incomplete element type 'struct cftype'
>  extern struct cftype bfq_blkcg_legacy_files[];
>  extern struct cftype bfq_blkg_files[];
> 
> This adds an empty definition for the type to make it build again.

This was already fixed up yesterday:

http://git.kernel.dk/cgit/linux-block/commit/?h=for-4.12/block&id=659b3394eb67a5e274d7e7348633b508510a5c8f

-- 
Jens Axboe
