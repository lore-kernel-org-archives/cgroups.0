From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] mm: memcg: make memcg huge page split support any order split.
Date: Mon, 21 Mar 2022 16:26:55 -0400
Message-ID: <2FBD6D12-EDBE-4061-8738-E5E333F2367C@nvidia.com>
References: <20220321142128.2471199-1-zi.yan@sent.com>
 <20220321142128.2471199-2-zi.yan@sent.com>
 <YjjKh2NoWGcq28Oo@carbon.dhcp.thefacebook.com>
 <0001CABA-9436-4EFF-9C7F-F67300D09DA1@nvidia.com>
 <YjjX/bZrUmQfFjHC@casper.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary="=_MailMate_2F541385-50E7-4360-9312-72AE9C63E581_=";
 micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFbAVOgB5L3qOPG9VdCAPxzY821z39LgMQbDCE9M8Vo=;
 b=O6BRFysnBo22kJOzG33391zJ3P1+7YUzmBUm9pGfnxJ3h+B9z6RFZnCumP+C/LhgfIiHcrVtbV/g6MDeT1+QxLar/5P7r2yeIM/zi03WlTqlaTt+SZ1gLHfeOPVlIVGiCu+APv31PUyN3bmoX2vyXjWOdQkvw7rGcBRGQuS6t05ziwk5mP8ROLChnXjwAv0ivBx7seP6w3DZjEvvJpj6BbZvQrWFZbu+P2XNlzSAGuXGrziMLP+B4fC3YG2TpR7I6pkNKkFwE7Ez3tUug0wprFUlFOvCp7MGsKosZ9MRXVKTt92qXBpJfvr7MlNV1JycStcHoOv0YXMb9rmUarfuNg==
In-Reply-To: <YjjX/bZrUmQfFjHC-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--=_MailMate_2F541385-50E7-4360-9312-72AE9C63E581_=
Content-Type: text/plain

On 21 Mar 2022, at 15:54, Matthew Wilcox wrote:

> On Mon, Mar 21, 2022 at 03:07:46PM -0400, Zi Yan wrote:
>> Yes. Will change it to new_nr to be consistent.
>
> uh, you're going to call ilog2?

fortunately, no. Inside split_page_memcg(), I probably
need to add VM_BUG_ON(nr % new_nr != 0) to make sure
new_nr is a divisor of nr, since there are a couple
of nr / new_nr operations. Otherwise, new_nr works.

>
> I think this would look less inconsistent if 'nr' were an unsigned long
> (how long until we need 16GB pages?  Think PPC already supports those)

--=_MailMate_2F541385-50E7-4360-9312-72AE9C63E581_=--
