From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 5/7] mm: thp: split huge page to any lower order pages.
Date: Tue, 08 Aug 2023 10:45:34 -0400
Message-ID: <A6C02D09-CD3A-4F12-89D6-F1F4B03C177A@nvidia.com>
References: <20230329011712.3242298-1-zi.yan@sent.com>
 <20230329011712.3242298-6-zi.yan@sent.com>
 <b545cac8-76f7-e3c3-0e1c-3cb922c9c9ae@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_B9F89779-6ED9-4666-9B7F-FF6FF172146B_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7guSE/On/Af6MDAkEypPOZndSAV8AV2RCD5K0lnYs+Y=;
 b=SjHt1r0MOAszMQxKSR5S+6l3VUa1SsTkCi8DGmf1ZDuWdlpI/cK8U6dlhxsQmLRIwUBv+eoTQOb+br2b7c9/Kw5aJ+y0g/YCB3LQz5LmwHu2jCdaOfH5uNPXxhQQgv57Y7i5IMFzEKQPpyfv5+bjP7wyASxuiiqP7+qrPsOHPIYO3lqPy+/F3obb80ns/ZX7cerpSOrJwcayDhtjGKcuIu/2NrEHgmCRchFr1HgRey7wiWrd/Y8oWnD9cxyC8kA1Bo/n9H+jDyhsY/HjRIM0fPz/p0I0yDEksmsh2Dws4iLozDLdh6K/6RKp4b/UVdxlHeFrJ9NrimyihAMP0YbTAQ==
In-Reply-To: <b545cac8-76f7-e3c3-0e1c-3cb922c9c9ae-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zach O'Keefe <zokeefe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--=_MailMate_B9F89779-6ED9-4666-9B7F-FF6FF172146B_=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On 8 Aug 2023, at 5:01, David Hildenbrand wrote:

> On 29.03.23 03:17, Zi Yan wrote:
>> From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>>
>> To split a THP to any lower order pages, we need to reform THPs on
>> subpages at given order and add page refcount based on the new page
>> order. Also we need to reinitialize page_deferred_list after removing
>> the page from the split_queue, otherwise a subsequent split will see
>> list corruption when checking the page_deferred_list again.
>>
>> It has many uses, like minimizing the number of pages after
>> truncating a huge pagecache page. For anonymous THPs, we can only spli=
t
>> them to order-0 like before until we add support for any size anonymou=
s
>> THPs.
>>
>
> Because I'm currently looking into something that would also not be com=
patible with order-1 for now:
>
> You should make it clear that order-1 is not supported, like:
>
> "mm: thp: split huge page to any lower order pages (except order 1)"
>
> And clarify in the subject why that is the case.

Sure.

I will add below to the commit message and the comment of
split_huge_page_to_list_to_order():

Order-1 folio is not supported because _deferred_list, which is used by
partially mapped folios, is stored in subpage 2 and an order-1 folio only=

has subpage 0 and 1.

--=_MailMate_B9F89779-6ED9-4666-9B7F-FF6FF172146B_=--
