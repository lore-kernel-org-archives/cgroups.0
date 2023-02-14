From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH 0/3] Some cleanups for page isolation
Date: Tue, 14 Feb 2023 14:49:51 +0800
Message-ID: <a712d178-e524-fea7-a459-dd884956fc6b@linux.alibaba.com>
References: <cover.1676342827.git.baolin.wang@linux.alibaba.com>
 <Y+sTFqwMNAjDvxw3@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y+sTFqwMNAjDvxw3-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/14/2023 12:50 PM, Matthew Wilcox wrote:
> On Tue, Feb 14, 2023 at 11:18:05AM +0800, Baolin Wang wrote:
>> The page isolation functions did not return a boolean to indicate
>> success or not, instead it will return a negative error when failed
>> to isolate a page. So it's better to check the negative error explicitly
>> for isolation to make the code more clear per Linus's suggestion in [1].
> 
> Only one caller of isolate_lru_page() or folio_isolate_lru() actually
> uses the errno.  And the errno can only be 0 or -EBUSY.  It'd be
> better to change the three functions to return bool and fix
> add_page_for_migration() to set the errno to -EBUSY itself.

Sounds reasonable to me, and I can change them to return bool in next 
version. Thanks.
