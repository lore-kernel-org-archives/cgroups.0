From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 3/3] mm: Fix missing mem cgroup soft limit tree updates
Date: Tue, 23 Feb 2021 10:18:30 -0500
Message-ID: <YDUcxs5Zw+265Vpx@cmpxchg.org>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <e269f5df3af1157232b01a9b0dae3edf4880d786.1613584277.git.tim.c.chen@linux.intel.com>
 <YC4BcsNFEmW7XeqB@cmpxchg.org>
 <d141f9ec-5502-b011-167f-e24d891b0dfe@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BEgzN/eWl9ypgO18zGxZMbgknCN0HuQ7lE1kZsV2Mqc=;
        b=1olQJtG/wvtNQelqBB7lkff1dMw5my00CEjeWJ1HstDl1DCMGbdlX+7YLDlDBZwK8C
         FjBU18p9rB4l/AUnaEq9Qxjl+WCChyHx3OQVGcWWqgdACPeyzBL0AdQEU7KkosHV80Ql
         ry7PE2TuhFrccnUA6Dyo2q9wTcfDkGwkbr/udctYwcZYbzmz9V3WU+zZEyiMPQXhaspB
         8FbO8VTuMKy4oOP9czAfGPOIDW3Pb8/QLa3XNYvFx5URd/JIhkT7kfTlOAAbWTfQBIdV
         Y+fBDVr3jrNydsKaeRtTuq9X8HZU60XJlsiVbDJ7x6VuqH20iGNfwwgMm3sfXgMqkePz
         657A==
Content-Disposition: inline
In-Reply-To: <d141f9ec-5502-b011-167f-e24d891b0dfe@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov.dev@gmail.com>, Dave Hansen <dave.hansen@intel.com>, Ying Huang <ying.huang@intel.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Feb 22, 2021 at 10:38:27AM -0800, Tim Chen wrote:
> Johannes,
> 
> Thanks for your feedback.  Since Michal has concerns about the overhead
> this patch could incur, I think we'll hold the patch for now.  If later
> on Michal think that this patch is a good idea, I'll incorporate these
> changes you suggested.

That works for me.

Thanks!
