From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Devel] [PATCH v11 00/15] kmemcg shrinkers
Date: Tue, 26 Nov 2013 08:46:44 -0800
Message-ID: <20131126084644.405a091d.akpm@linux-foundation.org>
References: <cover.1385377616.git.vdavydov@parallels.com>
	<20131125174135.GE22729@cmpxchg.org>
	<529443E4.7080602@parallels.com>
	<52949A4F.7030004@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <52949A4F.7030004@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, glommer@openvz.org, mhocko@suse.cz, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org

On Tue, 26 Nov 2013 16:55:43 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> What do you think about splitting this set into two main series as follows:
> 
> 1) Prepare vmscan to kmemcg-aware shrinkers; would include patches 1-7 
> of this set.
> 2) Make fs shrinkers memcg-aware; would include patches 9-11 of this set

Please just resend everything.

> and leave other patches, which are rather for optimization/extending 
> functionality, for future?

It will be helpful to describe such splitting opportunities in the
[0/n] changelog.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
