From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/3] Some cleanups for page isolation
Date: Tue, 14 Feb 2023 04:50:30 +0000
Message-ID: <Y+sTFqwMNAjDvxw3@casper.infradead.org>
References: <cover.1676342827.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=p+bChmlvh7LMvh5Y4Z+EEbtWSwcTxFruTWwVWYj6SM4=; b=O+ebOqEE74wqxSJzcbyIu0QYBH
        2vs06XLi0DzhSjrQev+ypdu/zOwEZb1yiIf52NSNtpTyglV1CUwwA55PZpbc72Zq6+zBCbln2yqby
        o0KHZRljjzrHdF2APS6WX1Zx+o1SjUVF2sxp0QP6rbM8dxPQZx+4y3fZKLKdMRwJwlS3D0lO/iom9
        prqRmdjvfYBndWVhyF3y/VJYavF7mmkJrPm65WdATw5dnfsmHdGFvaKGTsxmwJPz2jmbriTlkFqlU
        FhLgxhAHo8Yc/2LX6WTwtMMtJZqL05vMdpYqVhapD+LKCLgpO8K55UXfvaHDQTn2wsUIVh3Vl9901
        8fdmdI8g==;
Content-Disposition: inline
In-Reply-To: <cover.1676342827.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 14, 2023 at 11:18:05AM +0800, Baolin Wang wrote:
> The page isolation functions did not return a boolean to indicate
> success or not, instead it will return a negative error when failed
> to isolate a page. So it's better to check the negative error explicitly
> for isolation to make the code more clear per Linus's suggestion in [1].

Only one caller of isolate_lru_page() or folio_isolate_lru() actually
uses the errno.  And the errno can only be 0 or -EBUSY.  It'd be
better to change the three functions to return bool and fix
add_page_for_migration() to set the errno to -EBUSY itself.
