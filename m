From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: clarify the uncharge_list() loop
Date: Thu, 10 Mar 2016 17:16:52 -0500
Message-ID: <20160310221652.GA10884@cmpxchg.org>
References: <1457643015-8828-3-git-send-email-hannes@cmpxchg.org>
 <20160310133034.f566a14dfdfa058bf9891b42@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160310133034.f566a14dfdfa058bf9891b42@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Mar 10, 2016 at 01:30:34PM -0800, Andrew Morton wrote:
> 
> LGTM.  It's very late in the cycle so I'll queue all three for 4.6-rc1
> and I tagged the first two patches (not this one) for -stable
> backporting.

Sounds good, thank you.
