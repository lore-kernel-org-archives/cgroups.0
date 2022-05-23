From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH] cgroup: Fix an error handling path in
 alloc_pagecache_max_30M()
Date: Mon, 23 May 2022 21:55:10 +0800
Message-ID: <YouSPobNcFH/cuuu@FVFYT0MHHV2J.usts.net>
References: <628312312eb40e0e39463a2c06415fde5295c716.1653229120.git.christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Df9yWQ/aDxzNckvtabHN6S/25VXwYOsM+nyYbdaI3a8=;
        b=TzTbXf5jrW5oQ4yIsnoZCjia8f/YM/jmgfc1tLNqZmzCb3k08ZDczecDygA0fXzxW0
         M81MuFj8NK6DtCT/7OVTIJAv3BhESb+ZGlV+g6JnG+cYwI4CMLm02QiKYbzV39WLLSMS
         komvx0Xcb0OjEcfD56VP8GFPwyRc8+XD62mjfdTjYLgCGwqfkwDFeTyxa0gvcwRln5V/
         eppJDWhh1gIYIIsgZb6SvwT1JFJc8Rc2PSnfcYkaYqyCR0LGr7wqnJA8xusq60qOrKuG
         qGuAxRsk7r+MPmY10Dyd8BT8HZLGxWoTa7CzLg8N/e+uS1IVHCPP3SOQTgQY7OVwOhG9
         40mg==
Content-Disposition: inline
In-Reply-To: <628312312eb40e0e39463a2c06415fde5295c716.1653229120.git.christophe.jaillet@wanadoo.fr>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: dan.carpenter@oracle.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Shuah Khan <shuah@kernel.org>, David Vernet <void@manifault.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org

On Sun, May 22, 2022 at 04:18:51PM +0200, Christophe JAILLET wrote:
> If the first goto is taken, 'fd' is not opened yet (and is un-initialized).
> So a direct return is safer.
> 
> Fixes: c1a31a2f7a9c ("cgroup: fix racy check in alloc_pagecache_max_30M() helper function")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Muchun Song <songmuchun@bytedance.com>

Thanks.
