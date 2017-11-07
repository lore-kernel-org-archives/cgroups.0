From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH 1/3] mm: memcontrol: eliminate raw access to stat and
 event counters
Date: Tue, 7 Nov 2017 12:15:40 +0300
Message-ID: <20171107091540.mmv2htftez3ffle4@esperanza>
References: <20171103153336.24044-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WwjLC3iMhJ9nc7erQfFj9ihyX6+mxFrLYnpKTNPs5Vk=;
        b=T/fKkTBM9zs2qCW5Qaggvm8svcLiShSn6Jf8iQUvxLGj+bcZaEjDc1YMpGduLHhGM6
         uxwfA5tyML3mqp9eyqAFqHfmhHbSabKg/YiA/d8Kdobopi/icfpKqYWTUbZtUUdYSBqc
         WLL5gNI0ImazquL4sEgKnzlGS6uv3WctPmJW40iDA9BBzFu8bQNrhlzN9z55xm3AWDZh
         wwAKe8ESPtjZO6t8Tq1jib14Jn6Pam7uqQkGtipaZiIMdLypWS6I/h9uclpynRecv2cs
         7yENC3pih/44WGNrFJLS1yhC/fKNkPT7YY8MiBtS3zmuJDz14KziF73ol3byE6f/Vg4R
         hTZg==
Content-Disposition: inline
In-Reply-To: <20171103153336.24044-1-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Fri, Nov 03, 2017 at 11:33:34AM -0400, Johannes Weiner wrote:
> Replace all raw 'this_cpu_' modifications of the stat and event
> per-cpu counters with API functions such as mod_memcg_state().
> 
> This makes the code easier to read, but is also in preparation for the
> next patch, which changes the per-cpu implementation of those counters.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/memcontrol.h | 31 +++++++++++++++---------
>  mm/memcontrol.c            | 59 ++++++++++++++++++++--------------------------
>  2 files changed, 45 insertions(+), 45 deletions(-)

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
