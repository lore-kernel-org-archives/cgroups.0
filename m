From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 4/5] mm: truncate: split huge page cache page to a non-zero order if possible.
Date: Tue, 22 Mar 2022 10:19:35 -0400
Message-ID: <B5F3E897-7BBF-422E-AF62-9E4AF50F655C@nvidia.com>
References: <20220321142128.2471199-1-zi.yan@sent.com>
 <20220321142128.2471199-5-zi.yan@sent.com>
 <Yjj9FaoChB3u0Gbh@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_35D1A03D-315B-42D0-8538-3E47809BB42E_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ru8E4LFHVf+kw8xPFqzeSG8fntHfmGzeug5xEkvbnmc=;
 b=Jfji/lc/DbeXQAoCT1tQIB8dOfql/kwL32EMvQ7V3Mnatd1XCGzS4Ga9W8C8oeCCZbyWiM7mg59ysQTmQhwSCTLnQVNLL8FP+fH0yvmWSV0DxJ1UiAtpAPOZEuERtWdBx0swPj1+YmZsQ2yAfD0kxA2wgewc/lRbcvkGDuc1NAd5Lu8ywkxkvJftlA0VBeBAsY26xVsRNKcGsaXt5FvyaVB89XcZqqfqxeqiXQ9tzCqak136i3B453JwzGhvKVJlWgPQkN8cguMJX4OYFpiX5MuoafnOMC6j1PWw1I+S24tWt5M3H9kqXiPhoBuAmkvhkIKItEvcChY+pbsyVKHaCQ==
In-Reply-To: <Yjj9FaoChB3u0Gbh-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--=_MailMate_35D1A03D-315B-42D0-8538-3E47809BB42E_=
Content-Type: text/plain

On 21 Mar 2022, at 18:32, Roman Gushchin wrote:

> On Mon, Mar 21, 2022 at 10:21:27AM -0400, Zi Yan wrote:
>> From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>>
>> To minimize the number of pages after a huge page truncation, we do not
>> need to split it all the way down to order-0. The huge page has at most
>> three parts, the part before offset, the part to be truncated, the part
>> remaining at the end. Find the greatest common power of two multiplier of
>> the non-zero values of them as the new order, so we can split the huge
>> page to this order and keep the remaining pages as large and as few as
>> possible.
>
> Would you mind please to describe the algorithm in more details?

Sure.

During truncation, there can be three parts in a huge page:
1. the _offset_ from the beginning of the huge page,
2. the _length_ of the to-be-truncated part,
3. the _remaining_ part after the to-be-truncated part.

the size of the split huge page need to be the greatest common divisor
of the non-zero ones of three after being rounded down to power of two.

OK, I actually find there is a gcd function. I think the algorithm can
simplified to

new_order = ilog2(gcd(gcd(offset, length), remaining)) - PAGE_SHIFT;

I will update the code, the commit message, and the comment in the next
version.

Thank you for the comment.
--=_MailMate_35D1A03D-315B-42D0-8538-3E47809BB42E_=--
