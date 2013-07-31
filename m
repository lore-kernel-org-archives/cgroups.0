From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 0/8] memcg, cgroup: kill css_id
Date: Wed, 31 Jul 2013 07:48:34 -0400
Message-ID: <20130731114834.GO2810@htj.dyndns.org>
References: <51F86D69.2030907@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1fVYM8f5W897YLOW2yIEk2GVd89+OFcjtfDOnT61M5A=;
        b=pJ2YUB0/JBAiYNGr2qGYYpX3v9x2tbYB7nnPVsCtNYg90zgIqnHHy1qqWK0bin3IlR
         ZFeDzSuCdH4i6qcFVA69tpUPPsuVquWtUH8JbaqKO03exiOgGIXDqM209IfeAvv+ryGL
         shDT17qQGUh/3DWqsSs68vV8qZmQIj/EcCdUpPBzM8mm5Vd5l8YTt/r6bC+sy651R8O5
         OBe0AKwTHwMGjgUbQ8CGc1lguSlpKISbNFS230TCWJ/xOT4mBH8Ficcuy/Gc1otc+VRU
         YL6LT0DnvaXd1mQwvCFzFyPw/8en9h2kzmb7dDDC+6MfGFR6aP1tHp545FPpKWlabyXg
         z73g==
Content-Disposition: inline
In-Reply-To: <51F86D69.2030907@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Wed, Jul 31, 2013 at 09:50:33AM +0800, Li Zefan wrote:
> This patchset converts memcg to use cgroup->id, and then we can remove
> cgroup css_id.
> 
> As we've removed memcg's own refcnt, converting memcg to use cgroup->id
> is very straight-forward.
> 
> The patchset is based on Tejun's cgroup tree.

Applied 1-3 to cgroup/for-3.12.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
