From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3 0/7] Split a folio to any lower order folios
Date: Tue, 4 Apr 2023 14:47:27 -0700
Message-ID: <20230404144727.e613116684dbd65a4b4745c1@linux-foundation.org>
References: <20230403201839.4097845-1-zi.yan@sent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680644848;
        bh=/W2l6FEblcPBW3a3/IFotwqzUPzNhBW9UW0Zd0bfWms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DSeplztvtpJqsg9f5uaYJlK/NnWyyAnh/SEV2H/IQK6vqQDyo4T0Qd1lI0BgG3OMJ
         JUHA7gXk+j2U+gRcqXBV2F76wMkbAicPjqRGXMoEU5qU6Q38/4SZDl9eA8xcQVruDn
         4GnQVn1dbKsDNYhFTF5GD+CQ+JoP49SVOotqemrg=
In-Reply-To: <20230403201839.4097845-1-zi.yan-vRdzynncJC4@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zach O'Keefe <zokeefe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon,  3 Apr 2023 16:18:32 -0400 Zi Yan <zi.yan-vRdzynncJC4@public.gmane.org> wrote:

> File folio supports any order and people would like to support flexible orders
> for anonymous folio[1] too. Currently, split_huge_page() only splits a huge
> page to order-0 pages, but splitting to orders higher than 0 is also useful.
> This patchset adds support for splitting a huge page to any lower order pages
> and uses it during file folio truncate operations.

This series (and its v1 & v2) don't appear to have much in the way of
detailed review.  As it's at v3 and has been fairly stable I'll queue
it up for some testing now, but I do ask that some reviewers go through
it please.

