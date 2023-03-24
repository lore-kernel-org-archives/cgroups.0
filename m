From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] mm: page_owner: add support for splitting to any
 order in split page_owner.
Date: Fri, 24 Mar 2023 11:22:52 -0400
Message-ID: <59100CE6-1A77-4620-81AC-535A6A68A98F@nvidia.com>
References: <20230321004829.2012847-1-zi.yan@sent.com>
 <20230321004829.2012847-3-zi.yan@sent.com>
 <20230324151717.hawuy5gs6cnxql55@blackpad>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_291A2FA6-08B8-4B22-B21B-51B4FB6037B5_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fX8aoEReh56mVPCfMTd25zu48cTdsYFik2GorUxwwks=;
 b=q5SqxuIm9uHt2nAQuW+INhwurEWuZYliwa7QJOdEAGmwmvUmwb5Kv8s+TA5T28cVi8Laz3g5d9YsJsbfI4gEjDnDOkxjwcg/4J6ulrrabcOZbSgiSS/6w0N4TG/vCx/fHGphb/VFMQHwX707YnNORNmemBInB8CoBSybbQ3b6rt8p7A9V3OdewV2V20qZVIH/inl83/bT12e7IcxBtqGXNEx3h5VnOWslnuj5LVC9IMQpRXkC0LksGxVc7w5D2H9B6hscMNXMrrn1m6sHrQNHfIueIRWbcAj09dlFtfshHTsbdjdaR1PNaCyNIv3SyrUapeBV44mKw71nkSCgXm26A==
In-Reply-To: <20230324151717.hawuy5gs6cnxql55@blackpad>
List-ID: <cgroups.vger.kernel.org>
To: =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--=_MailMate_291A2FA6-08B8-4B22-B21B-51B4FB6037B5_=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 24 Mar 2023, at 11:17, Michal Koutn=C3=BD wrote:

> Hello.
>
> On Mon, Mar 20, 2023 at 08:48:26PM -0400, Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org> wrot=
e:
>> @@ -5746,8 +5746,8 @@ static void *make_alloc_exact(unsigned long addr=
, unsigned int order,
>>  		struct page *page =3D virt_to_page((void *)addr);
>>  		struct page *last =3D page + nr;
>>
>> -		split_page_owner(page, 1 << order);
>> -		split_page_memcg(page, 1 << order);
>> +		split_page_owner(page, 1 << order, 1);
>> +		split_page_memcg(page, 1 << order, 1);
>
> I think here should be
>
>> +		split_page_owner(page, order, 0);
>> +		split_page_memcg(page, 1 << order, 1);
>
> because I was wondering why split_page_memcg() doesn't use orders too?
> (E.g. it wouldn't work well if nr % new_new !=3D 0).

Thanks. Good point. I will make both use orders instead in next version.

--=_MailMate_291A2FA6-08B8-4B22-B21B-51B4FB6037B5_=--
