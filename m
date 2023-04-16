From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 6/7] mm: truncate: split huge page cache page to a
 non-zero order if possible.
Date: Sun, 16 Apr 2023 12:51:46 -0700 (PDT)
Message-ID: <86864d6c-39d3-d26f-278f-b96e14884541@google.com>
References: <20230403201839.4097845-1-zi.yan@sent.com> <20230403201839.4097845-7-zi.yan@sent.com> <9dd96da-efa2-5123-20d4-4992136ef3ad@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681674716; x=1684266716;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+XV1SaR4oDj2LmHIYbtEP9BS2GzUn6i8QGpmiK2pWes=;
        b=35GxN9QmW2hjy0Dfkmb2w05f+ZtVlxILgN7uYJpNWJLcIPK3szAO7GVlFCTIxLRIFw
         ovaBhQJgVADB9Q6ICg7hyMv/NAh8j0wq800X9YdYJ/dDjbdghw8JokHMRoEQNsIdRkdC
         WLiQXpG4Q+TttdZCcEbXfxWBxXC2GFAHRO1LtQZQgEpcMxrKREN4Avy2QCWCb6+mN3qa
         FRLCFpSJV0ak+dFRGggbPcpzGTkIvZjikma5vN7FHtcFbl8p3SNMYoZ+VAOk0dtr67BG
         CWcPeQAuI2DkTnaae9/D0Af3q8cBuCh0xrhWT3C7wipnfK4eVsi6qPFipvyeb/FiaUE3
         Z2Xg==
In-Reply-To: <9dd96da-efa2-5123-20d4-4992136ef3ad-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>, =?ISO-8859-15?Q?Michal_Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Zach O'Keefe <zokeefe-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> As this code stands, truncate a 2M huge page at 1M and you get two 1M
> pieces (one then discarded) - nice; but truncate it at 1M+1 and you get
> lots of order 2 (forced up from 1) pieces.  Seems weird, and not worth
> the effort.

I've probably said that wrong: truncate at 1M+1 and you'd get lots of
order 0 pieces.

Hugh
