From: Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v3 6/7] mm: truncate: split huge page cache page to a
 non-zero order if possible.
Date: Mon, 17 Apr 2023 11:20:31 -0400
Message-ID: <0AC0520E-1BD2-497E-A7ED-05394400BFC9@nvidia.com>
References: <20230403201839.4097845-1-zi.yan@sent.com>
 <20230403201839.4097845-7-zi.yan@sent.com>
 <9dd96da-efa2-5123-20d4-4992136ef3ad@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_2F2466C6-2327-4132-B79B-A943398CFB0E_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7efQR0ImsGvZWg1L4YVf+xYfL28MtoAmV611fey20v0=;
 b=TPnV8L9cM++HWhUKVSVdzEETQdShosjHLSjOTEN/Cqhf17SJqALKRuA/cTu6d8Sd3VKjyCkU3jF9iMoMbSqMtgrSMgyKguMCAqw8Z2r5REFKPZS590OoFOBJmXf/cp3LrVnQrWv2gPwcH1OfhMdyoDahmRwTzT45704NeYvQg2sA+JD93qbVt6d3WWET58B9+9xRbj7LSN5EuhyfGykX5q//Firo+vYO5JnaMW4/+wxJ4VehrsxAWDCzAGBQTkUdTqbCdFk0p+/TfRV9iQBVkDK//wcHx91MRv23XPqtTa455/FOX5N23DSWZ5Fb1yszfilt4yrbZE4J70tNJtE2EA==
In-Reply-To: <9dd96da-efa2-5123-20d4-4992136ef3ad@google.com>
List-ID: <cgroups.vger.kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yang Shi <shy828301@gmail.com>, Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ryan Roberts <ryan.roberts@arm.com>, =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, Zach O'Keefe <zokeefe@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org

--=_MailMate_2F2466C6-2327-4132-B79B-A943398CFB0E_=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On 16 Apr 2023, at 15:44, Hugh Dickins wrote:

> On Mon, 3 Apr 2023, Zi Yan wrote:
>
>> From: Zi Yan <ziy@nvidia.com>
>>
>> To minimize the number of pages after a huge page truncation, we do no=
t
>> need to split it all the way down to order-0. The huge page has at mos=
t
>> three parts, the part before offset, the part to be truncated, the par=
t
>> remaining at the end. Find the greatest common divisor of them to
>> calculate the new page order from it, so we can split the huge
>> page to this order and keep the remaining pages as large and as few as=

>> possible.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/truncate.c | 21 +++++++++++++++++++--
>>  1 file changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index 86de31ed4d32..817efd5e94b4 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -22,6 +22,7 @@
>>  #include <linux/buffer_head.h>	/* grr. try_to_release_page */
>>  #include <linux/shmem_fs.h>
>>  #include <linux/rmap.h>
>> +#include <linux/gcd.h>
>
> Really?
>
>>  #include "internal.h"
>>
>>  /*
>> @@ -211,7 +212,8 @@ int truncate_inode_folio(struct address_space *map=
ping, struct folio *folio)
>>  bool truncate_inode_partial_folio(struct folio *folio, loff_t start, =
loff_t end)
>>  {
>>  	loff_t pos =3D folio_pos(folio);
>> -	unsigned int offset, length;
>> +	unsigned int offset, length, remaining;
>> +	unsigned int new_order =3D folio_order(folio);
>>
>>  	if (pos < start)
>>  		offset =3D start - pos;
>> @@ -222,6 +224,7 @@ bool truncate_inode_partial_folio(struct folio *fo=
lio, loff_t start, loff_t end)
>>  		length =3D length - offset;
>>  	else
>>  		length =3D end + 1 - pos - offset;
>> +	remaining =3D folio_size(folio) - offset - length;
>>
>>  	folio_wait_writeback(folio);
>>  	if (length =3D=3D folio_size(folio)) {
>> @@ -236,11 +239,25 @@ bool truncate_inode_partial_folio(struct folio *=
folio, loff_t start, loff_t end)
>>  	 */
>>  	folio_zero_range(folio, offset, length);
>>
>> +	/*
>> +	 * Use the greatest common divisor of offset, length, and remaining
>> +	 * as the smallest page size and compute the new order from it. So w=
e
>> +	 * can truncate a subpage as large as possible. Round up gcd to
>> +	 * PAGE_SIZE, otherwise ilog2 can give -1 when gcd/PAGE_SIZE is 0.
>> +	 */
>> +	new_order =3D ilog2(round_up(gcd(gcd(offset, length), remaining),
>> +				   PAGE_SIZE) / PAGE_SIZE);
>
> Gosh.  In mm/readahead.c I can see "order =3D __ffs(index)",
> and I think something along those lines would be more appropriate here.=

>
> But, if there's any value at all to choosing intermediate orders here i=
n
> truncation, I don't think choosing a single order is the right approach=
 -
> more easily implemented, yes, but is it worth doing?
>
> What you'd actually want (if anything) is to choose the largest orders
> possible, with smaller and smaller orders filling in the rest (I expect=

> there's a technical name for this, but I don't remember - bin packing
> is something else, I think).
>
> As this code stands, truncate a 2M huge page at 1M and you get two 1M
> pieces (one then discarded) - nice; but truncate it at 1M+1 and you get=

> lots of order 2 (forced up from 1) pieces.  Seems weird, and not worth
> the effort.

The approach I am adding here is the simplest way of splitting a folio
and trying to get >0 order folios after the split.

Yes, I agree that using "__ffs(index)" can create more >0 order folios, b=
ut
it comes with either more runtime overheads or more code changes. Like
your "1MB + 1" page split example, using "__ffs(index)", ideally, you wil=
l
split 2MB into 2 1MBs, then 1MB into 2 512KBs, ..., 8KB into 2 4KBs and
at the end of the day, we will have 1MB, 512KB, ..., 8KB each and two 2 4=
KBs,
maximizing the number of >0 order folios. But what is the cost?

1. To minimizing code changes, we then need to call
split_huge_page_to_list_to_order() 9 times from new_order=3D8 to new_orde=
r=3D0.
Since each split needs to unmap and remap the target folio, we shall see
9 TLB shutdowns. I am not sure it is worth the cost.

2. To get rid of the unmap and remap overheads, we probably can unmap
the folio, then do all the 9 splits, then remap all the split pages. But
this would make split_huge_page() a lot more complicated and I am not sur=
e
a good way of passing split order information and the corresponding
to-be-split subpages. Do we need a dynamic list to store them, making
new memory allocations a prerequisite of split_huge_page()? Maybe we can
encode in the split information in two ints? In the first one,
each bit tells which order to split the page (like order=3D__ffs(index))
and in the second one, each bit tells which subpage to split next (0 mean=
s
the left subpage, 1 means the right subpage). So your "1MB + 1" page spli=
t
will be encoded as 0b111111111 (first int), 0b1000000 (second int and
it has 1 fewer bit, since first split does not need to know which subpage=

to split).

What do you think? If you have a better idea, I am all ears. And if you
are willing to help me review the more complicated code changes, I am
more than happy to implement it in the next version. :)

Thank you for your comments. They are very helpful!

>
> Hugh
>
>> +
>> +	/* order-1 THP not supported, downgrade to order-0 */
>> +	if (new_order =3D=3D 1)
>> +		new_order =3D 0;
>> +
>> +
>>  	if (folio_has_private(folio))
>>  		folio_invalidate(folio, offset, length);
>>  	if (!folio_test_large(folio))
>>  		return true;
>> -	if (split_folio(folio) =3D=3D 0)
>> +	if (split_huge_page_to_list_to_order(&folio->page, NULL, new_order) =
=3D=3D 0)
>>  		return true;
>>  	if (folio_test_dirty(folio))
>>  		return false;
>> -- =

>> 2.39.2


--
Best Regards,
Yan, Zi

--=_MailMate_2F2466C6-2327-4132-B79B-A943398CFB0E_=
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename=signature.asc
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQJDBAEBCgAtFiEE6rR4j8RuQ2XmaZol4n+egRQHKFQFAmQ9Y78PHHppeUBudmlk
aWEuY29tAAoJEOJ/noEUByhUltQP/iHzaohQhNHX3dFij8oFo03N5i6YzNvIyDOR
iRse4krUQpMRSzHiaowDE+OC4cNDXfhKBiVFjxTn/LjTLX2ZAy0v6zjvGykkvP1k
OzT7aBjGUzPzH7HrUM+PnxyPSO3S4ipTpMIEidv/mXplOSI34YQjmh5SWQCiJfXk
fuUPnnrY81hicDhY9Sz63pM/Ne7ryngXvCnGQYxY6SZnie4odCGpT+Pmyv/igmxG
OtxkKgTtb/nSI6ZEFestcReUG1+ckLxSECRx/OHb3KKlxz3XnGIBwXFJ1S19R5xr
MzX9/nc0xqWRMAvpmhKhrtEFZ8P5dPNGG2uSPo1DMz9hP3lSp3Q+xjez6bVsgxig
2zEtzLX0fCDIW2VG8cbVHNlpo8NLGJpAkqpVMWpvFs6jIlHF1xTgC1Zg3FPBBX5b
+X/c50H6MRGTosl7bR6uI2d8uGSs2pXYu8t1cgnllOej6We1/I7DtGHFi/ncdBP1
1FihjzkR1911bmlOTzP/aiTopRH8yziQdnNCECDBku3HSyUIQ0nDE9cQt2RGbGiY
TrjM1+zBMgO7ZXXES8kepDl2Ly1W8QFU08GSJ/RdTQ05eDxL5zkW8H4mQh6v5RSY
ZeD5gYdbA/1LWupJ5F/u4K3Ugxg5Y+SLuq9xY7gSKLhwBjHAj3NS3v+GjaTJ/b14
sFRISmzO
=hjyY
-----END PGP SIGNATURE-----

--=_MailMate_2F2466C6-2327-4132-B79B-A943398CFB0E_=--
