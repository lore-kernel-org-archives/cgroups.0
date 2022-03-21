From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] mm: memcg: make memcg huge page split support any order split.
Date: Mon, 21 Mar 2022 15:07:46 -0400
Message-ID: <0001CABA-9436-4EFF-9C7F-F67300D09DA1@nvidia.com>
References: <20220321142128.2471199-1-zi.yan@sent.com>
 <20220321142128.2471199-2-zi.yan@sent.com>
 <YjjKh2NoWGcq28Oo@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_AEE2331C-DCD6-4190-BAE6-F7868D2E6554_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqYm47FTMvdUJOGgTLvLdKPG203KLE0rRfgG2+8JwD4=;
 b=lB6olLTB7TH6WAeiKVlQG8ZK1lk6O4MX+oeu3dDfyYbRmF71AMOMD/wuddXcuer1IEfCZQZ/0ZNG1m3dQCE9aDUm3PLXFFSwpDWz6XifC7VkQadKtNWnVDoMmX8E+2Nt2K44xKXBm3F1HcRovNaGC+TcsX1L5X29XgSVFwY+FJ0zOgQa8cbc+n458sGFKS5kiq3sHCl9mIkcteEHjF4IHQbgDjYBvJWcJjkn/6VnyEX1MCFc49CfTQpJIymqZ31HyzJKAbAnyTS2ytO010i0JlY7S3ZCJTFFUNDFeao+2A4Ec5VU+ewwHNaSWsubFRtzP8xQer1I6kmYy3NPHAaG8A==
In-Reply-To: <YjjKh2NoWGcq28Oo-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--=_MailMate_AEE2331C-DCD6-4190-BAE6-F7868D2E6554_=
Content-Type: text/plain

On 21 Mar 2022, at 14:57, Roman Gushchin wrote:

> On Mon, Mar 21, 2022 at 10:21:24AM -0400, Zi Yan wrote:
>> From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>>
>> It sets memcg information for the pages after the split. A new parameter
>> new_order is added to tell the new page order, always 0 for now. It
>> prepares for upcoming changes to support split huge page to any lower
>> order.
>>
>> Signed-off-by: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>> ---
>>  include/linux/memcontrol.h |  2 +-
>>  mm/huge_memory.c           |  2 +-
>>  mm/memcontrol.c            | 10 +++++-----
>>  mm/page_alloc.c            |  2 +-
>>  4 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 89b14729d59f..e71189454bf0 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -1116,7 +1116,7 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
>>  	rcu_read_unlock();
>>  }
>>
>> -void split_page_memcg(struct page *head, unsigned int nr);
>> +void split_page_memcg(struct page *head, unsigned int nr, unsigned int new_order);
>
> It looks a bit inconsistent, can't we switch to use either nr or order for both
> arguments? The latter is preferable.

Yes. Will change it to new_nr to be consistent.

>
> Other than that, the patch looks good to me.

Thank you for the review.
--=_MailMate_AEE2331C-DCD6-4190-BAE6-F7868D2E6554_=--
