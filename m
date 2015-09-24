From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: remove pcp_counter_lock
Date: Thu, 24 Sep 2015 15:43:48 -0400
Message-ID: <20150924194348.GA3009@cmpxchg.org>
References: <1442976106-49685-1-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442976106-49685-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue, Sep 22, 2015 at 07:41:46PM -0700, Greg Thelen wrote:
> Commit 733a572e66d2 ("memcg: make mem_cgroup_read_{stat|event}() iterate
> possible cpus instead of online") removed the last use of the per memcg
> pcp_counter_lock but forgot to remove the variable.
> 
> Kill the vestigial variable.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
