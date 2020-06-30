From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] doc: cgroup: add f2fs and xfs to supported list for
 writeback
Date: Tue, 30 Jun 2020 06:42:17 +0100
Message-ID: <20200630054217.GA27221@infradead.org>
References: <c8271324-9132-388c-5242-d7699f011892@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=10n6fkJT5YFknRXlHwj9gjNGg/R91/iiEmizqFo2Wwo=; b=KS/1RcoO2tBOxUo26C2OeBpqjl
        OB2sVaGqmZWJ+kuE7+75OHOwksmtSEVZNf0KN2lNbbk0YFvsUp8g7rb33mF9Rygtv5wn3lgzZTqcQ
        khfetKq77lCf6uZ5aoegLeRgrbxkfD9th0T/zwET+2XNS6OaFaYwljTfGureLmMCEM6xUmlALsOn6
        64lRKuziJU6P4RoeTfLQ1YJWx3PW+uzU5MLFefV1CBVi5nANFuxRSC3wsLmhnzFHvJOpDKlVhyZlz
        HPSfid7WCsQEdj3nRsPpNptdaSIlJen04FrqdMpG9XIJEksoqGon0zcHUxo8koUf5NuQ15sP9H+H+
        76vP82GA==;
Content-Disposition: inline
In-Reply-To: <c8271324-9132-388c-5242-d7699f011892-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jun 29, 2020 at 02:08:09PM -0500, Eric Sandeen wrote:
> f2fs and xfs have both added support for cgroup writeback:
> 
> 578c647 f2fs: implement cgroup writeback support
> adfb5fb xfs: implement cgroup aware writeback
> 
> so add them to the supported list in the docs.
> 
> Signed-off-by: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> 
> TBH I wonder about the wisdom of having this detail in
> the doc, as it apparently gets missed quite often ...

I'd rather remove the list of file systems.  It has no chance of
staying uptodate.
