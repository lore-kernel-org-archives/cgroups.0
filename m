From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
Date: Thu, 31 May 2012 09:53:37 +0900
Message-ID: <4FC6C111.2060108@jp.fujitsu.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <alpine.DEB.2.00.1205301433490.9716@chino.kir.corp.google.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com> <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Gao feng <gaofeng@cn.fujitsu.com>, hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, containers@lists.linux-foundation.org

(2012/05/31 9:44), David Rientjes wrote:
> On Thu, 31 May 2012, Kamezawa Hiroyuki wrote:
>
>> My test with sysfs node's meminfo seems to work...
>>
>> [root@rx100-1 qqm]# mount --bind /sys/devices/system/node/node0/meminfo
>> /proc/meminfo
>> [root@rx100-1 qqm]# cat /proc/meminfo
>>
>> Node 0 MemTotal:        8379636 kB
>
> This doesn't seem like a good idea unless the application supports the
> "Node 0" prefix in /proc/meminfo.
>
Of course, /cgroup/memory/..../memory.meminfo , a new file, will use the same
format of /proc/meminfo. Above is just an example of bind-mount.

> If any application really cares about the amount of memory available to
> it, it should be taught to be memcg aware.  Then do something like
>

Considering the container as a kind of virtualization, Some kind of
transparent way is required.

Thanks,
-Kame


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
