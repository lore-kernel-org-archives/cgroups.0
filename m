From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch 02/11] mm: swapfile: clean up unuse_pte race handling
Date: Mon, 09 Jul 2012 11:29:27 +0900
Message-ID: <4FFA4207.4060406@jp.fujitsu.com>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1341449103-1986-3-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

(2012/07/05 9:44), Johannes Weiner wrote:
> The conditional mem_cgroup_cancel_charge_swapin() is a leftover from
> when the function would continue to reestablish the page even after
> mem_cgroup_try_charge_swapin() failed.  After 85d9fc8 "memcg: fix
> refcnt handling at swapoff", the condition is always true when this
> code is reached.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
