From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: fix numa stats for thp migration
Date: Mon, 28 Dec 2020 11:44:59 -0800
Message-ID: <20201228194459.GB318614@carbon.dhcp.thefacebook.com>
References: <20201227181310.3235210-1-shakeelb@google.com>
 <20201227181310.3235210-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=LRR1D0hqBUOFMz5uANlIdHUf3XOP2UxydxuYUHXsOtA=;
 b=P6ZQ2ljC0ALO1R9DBa7WJN3Q5IW2adTiwE+IftjeXOdCVxLUZr9vM5QU4M3fXMkshc0N
 7Bkrk7njpv8sW/6dgMPJoTIRgWqu8WvZbSltvQ9HDNz5kywUvNiGi9IPIffMyEKVrWtR
 +5MQH9jdOX0o5WehroKA0SaF6E4Y0zZ4uq0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRR1D0hqBUOFMz5uANlIdHUf3XOP2UxydxuYUHXsOtA=;
 b=C2SINFfXY3u/iDxxa7gWQyOMyB3r670MGzsh80p46puNFbsx1y6HJGZfZ72Kh/w1aO1pfm3JNkZE7M7d+zzJq1NNbXFg6puIrRHJ/wFcgO5iM0Wh4rB1MuHAF6KvAY8m+50Nj16uR1UQfBiPRX7gkwEij8noe63PtdhXwk9G+pk=
Content-Disposition: inline
In-Reply-To: <20201227181310.3235210-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Dec 27, 2020 at 10:13:10AM -0800, Shakeel Butt wrote:
> Currently the kernel is not correctly updating the numa stats for
> NR_FILE_PAGES and NR_SHMEM on THP migration. Fix that. For NR_FILE_DIRTY
> and NR_ZONE_WRITE_PENDING, although at the moment there is no need to
> handle THP migration as kernel still does not have write support for
> file THP but to be more future proof, this patch adds the THP support
> for those stats as well.
> 
> Fixes: e71769ae52609 ("mm: enable thp migration for shmem thp")
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

With the typo fix ("__mod_zone_page_tate")

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
