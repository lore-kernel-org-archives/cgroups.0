From: Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v3 0/7] Split a folio to any lower order folios
Date: Tue, 18 Apr 2023 10:00:43 -0400
Message-ID: <9AA686F5-5366-4F41-92A7-C18B77BFDD6E@nvidia.com>
References: <20230403201839.4097845-1-zi.yan@sent.com>
 <20230404144727.e613116684dbd65a4b4745c1@linux-foundation.org>
 <49ee481e-452f-61c7-2da5-28de2cf3de2@google.com>
 <b37d1876-0a74-aa52-7911-e6f78280caaa@redhat.com>
 <8B784026-7C90-427D-91E2-2D551FA576D7@nvidia.com>
 <c1429e20-7462-dc73-766a-cf7b3d482c6d@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_7EF800F6-588F-4AE4-909D-5775F8A02B83_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uB18raNWnmeNPDPC26CDptXk7WiQSIQT7vl2EaQoqSY=;
 b=mddm9d5304RIAIE4gJQfWLqQFUverQv+UqYhAzs73SPO1OmkB3sLqFaBwcpY3e5lVoniy1qBhD8dblrlvi8p/BUmhO1RRZBr0mYXgfrqY04LOH8cLmGE8JbPcIhYV31MwMZc5Baet8zJBMYa9O6o2/YQlCt85bTFqcl0YKqqwZ5wh/jfejDmWD5JI2cG6k3I+CYXSmgRBcS1vXyu/orrPMyuSeKmuH9e2cbLrGiCUelgG1TzBi8qq/IqQR7S7A/yRU3Lgj+9Syx2ZEaCJBo8WP41HH+8EGTkjeMXDkKapsfvvgLEQHrZF3ZWr7S0B+47DcLqN3z8LVJzHQ7SiLjkkg==
In-Reply-To: <c1429e20-7462-dc73-766a-cf7b3d482c6d@redhat.com>
List-ID: <cgroups.vger.kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yang Shi <shy828301@gmail.com>, Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ryan Roberts <ryan.roberts@arm.com>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, Zach O'Keefe <zokeefe@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org

--=_MailMate_7EF800F6-588F-4AE4-909D-5775F8A02B83_=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On 18 Apr 2023, at 6:29, David Hildenbrand wrote:

> On 17.04.23 21:26, Zi Yan wrote:
>> On 17 Apr 2023, at 10:20, David Hildenbrand wrote:
>>
>>> On 16.04.23 20:11, Hugh Dickins wrote:
>>>> On Tue, 4 Apr 2023, Andrew Morton wrote:
>>>>> On Mon,  3 Apr 2023 16:18:32 -0400 Zi Yan <zi.yan@sent.com> wrote:
>>>>>
>>>>>> File folio supports any order and people would like to support fle=
xible orders
>>>>>> for anonymous folio[1] too. Currently, split_huge_page() only spli=
ts a huge
>>>>>> page to order-0 pages, but splitting to orders higher than 0 is al=
so useful.
>>>>>> This patchset adds support for splitting a huge page to any lower =
order pages
>>>>>> and uses it during file folio truncate operations.
>>>>>
>>>>> This series (and its v1 & v2) don't appear to have much in the way =
of
>>>>> detailed review.  As it's at v3 and has been fairly stable I'll que=
ue
>>>>> it up for some testing now, but I do ask that some reviewers go thr=
ough
>>>>> it please.
>>>>
>>>> Andrew, please don't let this series drift into 6.4-rc1.
>>>>
>>>> I've seen a bug or two (I'll point out in response to those patches)=
,
>>>> but overall I don't see what the justification for the series is: do=
ne
>>>> because it could be done, it seems to me, but liable to add surprise=
s.
>>>>
>>>> The cover letter says "splitting to orders higher than 0 is also use=
ful",
>>>> but it's not clear why; and the infrastructure provided seems unsuit=
ed
>>>> to the one use provided - I'll say more on that truncation patch.
>>>
>>> I agree. Maybe this patch set is something we want to have in the fut=
ure once actual consumers that can benefit are in place, such that we can=
 show actual performance numbers with/without.
>>
>> Ryan is working on large folio for anonymous pages and has shown promi=
sing performance
>> results[1]. This patchset would avoid getting base pages during split =
if possible.
>>
> Yes, I know. And it would be great to get some actual numbers with/with=
out your patches to show that this optimization actually matters in pract=
ice.

Sure. Will try to add perf numbers in the next version.

>
> Unrelated, your cover letter mentions "file folio truncate operations."=
=2E Would it also apply to FALLOC_FL_PUNCH_HOLE, when partially zapping a=
 THP?

Yes. In the self tests, I have
fallocate(fd, FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE, offset[j], len[j]=
);
and it uses the truncate operation I updated in patch 6.

>
>>>
>>> Until then, "365 insertions(+), 68 deletions(-)" certainly needs some=
 reasonable motivation.
>>
>> Come on. 225 out of 365 insertions are self tests code. We need motiva=
tion to add
>> testing code?
>
> Well, if you add feature X and the tests target feature X, then certain=
ly having the tests require the same motivation as feature X. But yeah, t=
he actual kernel code change is smaller than it looks at first sight.
>
> -- =

> Thanks,
>
> David / dhildenb


--
Best Regards,
Yan, Zi

--=_MailMate_7EF800F6-588F-4AE4-909D-5775F8A02B83_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename=signature.asc
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEE6rR4j8RuQ2XmaZol4n+egRQHKFQFAmQ+oowPHHppeUBudmlk
aWEuY29tAAoJEOJ/noEUByhU3ykP+wRt9zBYbVEprluv/xhZhFq8Vxhlfgi/v6Yo
ZGoedu6yksFPONQvTFuIsb73w1kjvVGHy60h9OqWWoMQGOvB+2lPC/tWMK/8TcE0
9PZrzo0Frt5XiMrDXWdBFHsSEbwFupITrNvbooqout+JEkWLDGifwTM05bZQJgwg
8MgccjHopOimBACXMTNNzIkW4iePMXnB5BxBRlSKn1RQCSv2bEFjOMZdMFi7M1LD
2WC79ipJl1qN1PZ2YKb5NCOjj3S57nPEW42QZWuL9MgitWLJmfBUodca500GEG50
pirkM6MQPmIkNsgBClFvPIVYuwuuebrndos7wkdGBJ3bfAGt0v91b8gC0ilhXjUX
le1SzCkTfFtJeo1gbN9baKln61USx3BtavmJKQA0dTLuzWD23QFb+/9lq5YC425r
F9cwwXEnI7Yvtuxh2Q8I/3vVF4MwGM+/2isL+mWzU5jd+7yokaukiaWpPBcyPrOu
Nm28lfqoMttOxumZOraG2/OaNfh74ZQ4IPG1T1grBCu0hVp/WIxqMZlvBpC4ROZv
mqc/vmoMiQSy3MIs0R08TQWLbxenNevwFeqAIWKwNkFyBwam4Gk8Al29DyqF3hX/
2BHaNVVmi6mNaIifx1vnFajVbvsKGURvUCDXHEKxCXYJ7HePnAwhZ7IBx1eb3wy/
o8QXb+77
=4mbv
-----END PGP SIGNATURE-----

--=_MailMate_7EF800F6-588F-4AE4-909D-5775F8A02B83_=--
