From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/7] Split a folio to any lower order folios
Date: Mon, 17 Apr 2023 15:26:58 -0400
Message-ID: <8B784026-7C90-427D-91E2-2D551FA576D7@nvidia.com>
References: <20230403201839.4097845-1-zi.yan@sent.com>
 <20230404144727.e613116684dbd65a4b4745c1@linux-foundation.org>
 <49ee481e-452f-61c7-2da5-28de2cf3de2@google.com>
 <b37d1876-0a74-aa52-7911-e6f78280caaa@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_6604F9BF-E972-4832-8F42-69193B2F72F2_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8hM0uY7iViOju5/VTvhwFko9AWPOITOTUCQTTPzuug=;
 b=DUE1V4GegSFA4ojJchXfwWO5OedQje25KsXcuoUVU5MFSHTM7bBornI96vvjgD09pxqRjEAFxID989NmD3rIxtnNY+2pA4lJuA2oeR5x5QEjsgRl3R7llVDmmHdKMMfnfr/SyV62Dxuhz1FLqsQAdo7ZrbMn5sCgC9nbSIFV+Lry3oHNXa6dTu/60Y3eIx5u0bacbPz06FaN0usPl3Fasnenc5cicQ6vCDV9DpK+nPMYik504vxgwExuS7oD0/Bx6NgnW0pUiqdozMhSJ8PWZ5sU7snS3grS/1RLcJdr5XN6LUidpXLzv0jl7zuURcwZ9a4psZyZFBaqTYrLb/eo8w==
In-Reply-To: <b37d1876-0a74-aa52-7911-e6f78280caaa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zach O'Keefe <zokeefe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--=_MailMate_6604F9BF-E972-4832-8F42-69193B2F72F2_=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On 17 Apr 2023, at 10:20, David Hildenbrand wrote:

> On 16.04.23 20:11, Hugh Dickins wrote:
>> On Tue, 4 Apr 2023, Andrew Morton wrote:
>>> On Mon,  3 Apr 2023 16:18:32 -0400 Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org> wrote:
>>>
>>>> File folio supports any order and people would like to support flexi=
ble orders
>>>> for anonymous folio[1] too. Currently, split_huge_page() only splits=
 a huge
>>>> page to order-0 pages, but splitting to orders higher than 0 is also=
 useful.
>>>> This patchset adds support for splitting a huge page to any lower or=
der pages
>>>> and uses it during file folio truncate operations.
>>>
>>> This series (and its v1 & v2) don't appear to have much in the way of=

>>> detailed review.  As it's at v3 and has been fairly stable I'll queue=

>>> it up for some testing now, but I do ask that some reviewers go throu=
gh
>>> it please.
>>
>> Andrew, please don't let this series drift into 6.4-rc1.
>>
>> I've seen a bug or two (I'll point out in response to those patches),
>> but overall I don't see what the justification for the series is: done=

>> because it could be done, it seems to me, but liable to add surprises.=

>>
>> The cover letter says "splitting to orders higher than 0 is also usefu=
l",
>> but it's not clear why; and the infrastructure provided seems unsuited=

>> to the one use provided - I'll say more on that truncation patch.
>
> I agree. Maybe this patch set is something we want to have in the futur=
e once actual consumers that can benefit are in place, such that we can s=
how actual performance numbers with/without.

Ryan is working on large folio for anonymous pages and has shown promisin=
g performance
results[1]. This patchset would avoid getting base pages during split if =
possible.

>
> Until then, "365 insertions(+), 68 deletions(-)" certainly needs some r=
easonable motivation.

Come on. 225 out of 365 insertions are self tests code. We need motivatio=
n to add
testing code?

[1] https://lore.kernel.org/linux-mm/20230414130303.2345383-1-ryan.robert=
s@arm.com/
--=_MailMate_6604F9BF-E972-4832-8F42-69193B2F72F2_=--
