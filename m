From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/2] memcg, fsnotify: no oom-kill for remote memcg
 charging
Date: Mon, 29 Apr 2019 17:41:23 -0400
Message-ID: <20190429214123.GA3715@dhcp22.suse.cz>
References: <20190429171332.152992-1-shakeelb@google.com>
 <20190429171332.152992-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190429171332.152992-2-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon 29-04-19 10:13:32, Shakeel Butt wrote:
[...]
>  	/*
>  	 * For queues with unlimited length lost events are not expected and
>  	 * can possibly have security implications. Avoid losing events when
>  	 * memory is short.
> +	 *
> +	 * Note: __GFP_NOFAIL takes precedence over __GFP_RETRY_MAYFAIL.
>  	 */

No, I there is no rule like that. Combining the two is undefined
currently and I do not think we want to legitimize it. What does it even
mean?
-- 
Michal Hocko
SUSE Labs
