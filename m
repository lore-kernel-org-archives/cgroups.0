From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [RFC PATCH 4/5] mm: truncate: split huge page cache page to a
 non-zero order if possible.
Date: Mon, 21 Mar 2022 15:32:53 -0700
Message-ID: <Yjj9FaoChB3u0Gbh@carbon.dhcp.thefacebook.com>
References: <20220321142128.2471199-1-zi.yan@sent.com>
 <20220321142128.2471199-5-zi.yan@sent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1647901979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4OY/H+zb0RIXu5WxaVqPmTsIU0BzpBHr2Aoo03K23OQ=;
        b=lWfBFFlwAImoY6uLwKWFs0S0tB3p39fYyxokhIeIaZPj4jja16BD+f2jryUMXCpvSoQH58
        KeNgR9rDqZZ733hMRZ75cM3upum9/Xboyi1T1hrsp4FdNCyEUqd/OOG+FlIywmGiFjuF4e
        0dwiI5FqWUCpfqADo77fjlQiIREimSI=
Content-Disposition: inline
In-Reply-To: <20220321142128.2471199-5-zi.yan-vRdzynncJC4@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 21, 2022 at 10:21:27AM -0400, Zi Yan wrote:
> From: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> 
> To minimize the number of pages after a huge page truncation, we do not
> need to split it all the way down to order-0. The huge page has at most
> three parts, the part before offset, the part to be truncated, the part
> remaining at the end. Find the greatest common power of two multiplier of
> the non-zero values of them as the new order, so we can split the huge
> page to this order and keep the remaining pages as large and as few as
> possible.

Would you mind please to describe the algorithm in more details?

Thanks!
