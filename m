From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH RFC 2/2] memcg: add threshold for anon rss
Date: Fri, 12 Sep 2014 10:23:08 +0900
Message-ID: <54124AFC.6020700@jp.fujitsu.com>
References: <cover.1410447097.git.vdavydov@parallels.com> <b7e7abb6cadc1301a775177ef3d4f4944192c579.1410447097.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <b7e7abb6cadc1301a775177ef3d4f4944192c579.1410447097.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vladimir Davydov <vdavydov@parallels.com>, linux-kernel@vger.kernel.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>, Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>, Glauber Costa <glommer@gmail.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Pavel Emelianov <xemul@parallels.com>, Konstantin Khorenko <khorenko@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org

(2014/09/12 0:41), Vladimir Davydov wrote:
> Though hard memory limits suit perfectly for sand-boxing, they are not
> that efficient when it comes to partitioning a server's resources among
> multiple containers. The point is a container consuming a particular
> amount of memory most of time may have infrequent spikes in the load.
> Setting the hard limit to the maximal possible usage (spike) will lower
> server utilization while setting it to the "normal" usage will result in
> heavy lags during the spikes.
> 
> To handle such scenarios soft limits were introduced. The idea is to
> allow a container to breach the limit freely when there's enough free
> memory, but shrink it back to the limit aggressively on global memory
> pressure. However, the concept of soft limits is intrinsically unsafe
> by itself: if a container eats too much anonymous memory, it will be
> very slow or even impossible (if there's no swap) to reclaim its
> resources back to the limit. As a result the whole system will be
> feeling bad until it finally realizes the culprit must die.
> 
> Currently we have no way to react to anonymous memory + swap usage
> growth inside a container: the memsw counter accounts both anonymous
> memory and file caches and swap, so we have neither a limit for
> anon+swap nor a threshold notification. Actually, memsw is totally
> useless if one wants to make full use of soft limits: it should be set
> to a very large value or infinity then, otherwise it just makes no
> sense.
> 
> That's one of the reasons why I think we should replace memsw with a
> kind of anonsw so that it'd account only anon+swap. This way we'd still
> be able to sand-box apps, but it'd also allow us to avoid nasty
> surprises like the one I described above. For more arguments for and
> against this idea, please see the following thread:
> 
> http://www.spinics.net/lists/linux-mm/msg78180.html
> 
> There's an alternative to this approach backed by Kamezawa. He thinks
> that OOM on anon+swap limit hit is a no-go and proposes to use memory
> thresholds for it. I still strongly disagree with the proposal, because
> it's unsafe (what if the userspace handler won't react in time?).
> Nevertheless, I implement his idea in this RFC. I hope this will fuel
> the debate, because sadly enough nobody seems to care about this
> problem.
> 
> So this patch adds the "memory.rss" file that shows the amount of
> anonymous memory consumed by a cgroup and the event to handle threshold
> notifications coming from it. The notification works exactly in the same
> fashion as the existing memory/memsw usage notifications.
> 
>

So, now, you know you can handle "threshould".

If you want to implement "automatic-oom-killall-in-a-contanier-threshold-in-kernel",
I don't have any objections.

What you want is not limit, you want a trigger for killing process.
Threshold + Kill is enough, using res_counter for that is overspec.

You don't need res_counter and don't need to break other guy's use case.

Thanks,
-Kame




--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
