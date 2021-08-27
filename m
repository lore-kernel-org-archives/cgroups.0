From: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: BFQ cgroup weights range
Date: Fri, 27 Aug 2021 10:33:01 +0200
Message-ID: <72DB38C2-196C-4F55-B1A1-B8EA55667057@linaro.org>
References: <20210824105626.GA11367@blackbody.suse.cz>
 <EC36D67F-D7CC-4059-8D3B-E0E64DFC3ADB@linaro.org>
 <20210826131212.GE4520@blackbody.suse.cz> <YSfOhM9+uJ5/FzY2@mtj.duckdns.org>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=VtoCWVqLTV/heRDzLkHFfB6NsN56tLaUOwMyBzk6DsQ=;
        b=p/XqSfnZUooWAr8lgDeoBRdn3K1+CVOMlLcHv640+uENvSRHmZHL/Jgt4NXBeRRIQU
         9S6RPb4u0xmPpipOcWiNh7NacH3f3BaGFhl8BBDRVL2cylmQ205R5dzp4/iEci705arm
         eeXKeDNPCjU/T0lcP0GWvReSEMchHGSqNrjwY3Q5vpumbt1rClmdOUI4ZSdtFPX2aZm1
         mQdRkS3hP+lKNWwYmOJTM7wLs/I1e1Q3EgJVBWBxRqOIIDDkkKGQsaE5YYf8lSOs9i4a
         LOSebZMZ+Yylt+8h7WM1IMps85gmmCfO5RAcc2gh3nnfpdPWCNuAGvkDAIBujwTDFrq/
         38Ww==
In-Reply-To: <YSfOhM9+uJ5/FzY2-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



> Il giorno 26 ago 2021, alle ore 19:25, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> ha =
scritto:
>=20
> On Thu, Aug 26, 2021 at 03:12:12PM +0200, Michal Koutn=C3=BD wrote:
>> On Tue, Aug 24, 2021 at 02:51:47PM +0200, Paolo Valente =
<paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>> BFQ inherited these constants when we forked it from CFQ.  I'm ok =
with
>>> increasing max weight to 10000.  I only wonder whether this would
>>> break some configuration, as the currently maximum weight would not =
be
>>> the maximum weight any longer.
>>=20
>> Thanks for the reply. Let me form the idea as a patch (and commit
>> message) and discuss based on that if needed (+ccrosspost into =
cgroups
>> ML).
>>=20
>> -- >8 --
>> From: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>
>> Subject: [PATCH] block, bfq: Accept symmetric weight adjustments
>>=20
>> The allowed range for BFQ weights is currently 1..1000 with 100 being
>> the default. There is no apparent reason to not accept weight
>> adjustments of same ratio on both sides of the default. This change
>> makes the attribute domain consistent with other cgroup (v2) knobs =
with
>> the weight semantics.
>>=20
>> This extension of the range does not restrict existing configurations
>> (quite the opposite). This may affect setups where weights >1000 were
>> attempted to be set but failed with the default 100. Such cgroups =
would
>> attain their intended weight now. This is a changed behavior but it
>> rectifies the situation (similar intention to the commit 69d7fde5909b
>> ("blkcg: use CGROUP_WEIGHT_* scale for io.weight on the unified
>> hierarchy") for CFQ formerly (and v2 only)).
>>=20
>> Additionally, the changed range does not imply all IO workloads can =
be
>> really controlled to achieve the widest possible ratio 1:10^4.
>>=20
>> Signed-off-by: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>
>=20
> Looks fine to me.
>=20
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>=20

Acked-by: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Thanks for this improvement,
Paolo

> Thanks.
>=20
> --=20
> tejun

