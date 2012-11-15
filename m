From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] res_counter: delete res_counter_write()
Date: Thu, 15 Nov 2012 11:06:07 +0900
Message-ID: <50A44E0F.6030404@jp.fujitsu.com>
References: <1352938017-32568-1-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1352938017-32568-1-git-send-email-gthelen@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Greg Thelen <gthelen@google.com>
Cc: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Frederic Weisbecker <fweisbec@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

(2012/11/15 9:06), Greg Thelen wrote:
> Since 628f423553 "memcg: limit change shrink usage" both
> res_counter_write() and write_strategy_fn have been unused.  This
> patch deletes them both.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Thank you
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
