From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] mm: memcg: make memcg huge page split support
 any order split.
Date: Mon, 21 Mar 2022 19:54:37 +0000
Message-ID: <YjjX/bZrUmQfFjHC@casper.infradead.org>
References: <20220321142128.2471199-1-zi.yan@sent.com>
 <20220321142128.2471199-2-zi.yan@sent.com>
 <YjjKh2NoWGcq28Oo@carbon.dhcp.thefacebook.com>
 <0001CABA-9436-4EFF-9C7F-F67300D09DA1@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4efTTqCS4Gsyb7wXaU8yL8zAGuclTlr6Cip6vqeSx5U=; b=gGjMpvSX+0ScawY3AAK5s8QnbO
        XilmRzJ+bqBsjUujrCWbfeV/tiRX+pQZDKbIS1SYRtDXXz1K9KLWQrCrfPxGmLQfFztXcAsXJ2Ddo
        l4tFcS3eTzqbtxZbVV5mTyle4MnmSMieKmIpHog/hTDlWj7SWmzHTxHQWMzK7iDKSGEKFuCuCF/9W
        coeGAeogiJmc3cJpJwW11rZXRiUcEkhs/lgHGb9qR0vtxf8I6ssv8JvulnzZxoy9KoA+SjsZE3S7Q
        24osUQanD2wp6GrgKEPW9Zicp2W4mjDyhuUcBHe/T+iGNKsM6u29kq3/ct+LGca1//oM3Lch994Ro
        fcXZH5cw==;
Content-Disposition: inline
In-Reply-To: <0001CABA-9436-4EFF-9C7F-F67300D09DA1-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 21, 2022 at 03:07:46PM -0400, Zi Yan wrote:
> Yes. Will change it to new_nr to be consistent.

uh, you're going to call ilog2?

I think this would look less inconsistent if 'nr' were an unsigned long
(how long until we need 16GB pages?  Think PPC already supports those)

