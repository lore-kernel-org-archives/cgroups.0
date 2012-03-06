From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/10] memcg: Introduce __GFP_NOACCOUNT.
Date: Tue, 6 Mar 2012 08:13:12 -0800
Message-ID: <CABCjUKD6_7p_OvsSPOJi9q4WRcHVhn3Y-R=dndomNLb13fVApA@mail.gmail.com>
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
	<CABCjUKBP=pKgDP5RkD4BimTjoE=bQQO7NxNNAiGUfy602T4c7A@mail.gmail.com>
	<4F55E8BB.5060704@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=hmMBDG6OB2WuK+ropc+wLb+MILKZ+jcEzCwXYOZLtTI=;
        b=Zp1VLVjPQP1YbtKi9nyrWnJMwYl/85xYsPGNFxIhKsvY6Re+rLludk6lFlTJrPVeDv
         Dg5Y0agjKxNOaGdQAwwIrGKzKlBonysAmbv21KYKNEQW1thWRs8K3jXhezi4LhKW2ByX
         O8ayISbx1jGlWHumcICdkaP8sYIlsaFjQG5pyorxydzc/C039OkltcGv2Qpr9wwsXRqx
         K8Gxw4cxQC4ZaUlEBd33RXeTR2lEiBdMnvJ/P610zv0nfkgG4kQxRa7kzru1nnHMGleb
         lKV/YH6gWUV71Xzz8eJqV0oaLIBxVql5w6EGXLAwAI+mEWxP4Q6olbcFYFtUwAKBWLZS
         MOmQ==
In-Reply-To: <4F55E8BB.5060704-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue, Mar 6, 2012 at 2:36 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> w=
rote:
> On 03/04/2012 04:10 AM, Suleiman Souhlal wrote:
>>
>> Just a few lines below:
>>
>> =A0 =A0 =A0 =A0 data =3D kmalloc_node_track_caller(size, gfp_mask, n=
ode);
>>
>> -- Suleiman
>
> Can't we just make sure those come from the root cgroup's slabs?
> Then we need no flag.

Do you mean make it so that all kmallocs come from the root cgroup's sl=
abs?
We would really like to account kmallocs in general (and all the other
slab types) to the right cgroup...

That said, I'm probably going to concentrate on accounting specially
marked caches only, for now, since there seems to be a strong
opposition on accounting everything, even though I don't understand
this point of view.

-- Suleiman
