From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [patch 1/2] mm: page_counter: pull "-1" handling out of
 page_counter_memparse()
Date: Tue, 13 Jan 2015 18:59:24 +0300
Message-ID: <20150113155924.GB11264@esperanza>
References: <1420776904-8559-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1420776904-8559-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 11:15:03PM -0500, Johannes Weiner wrote:
> It was convenient to have the generic function handle it, as all
> callsites agreed.  Subsequent patches will add new user interfaces
> that do not want to support the "-1" special string.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
