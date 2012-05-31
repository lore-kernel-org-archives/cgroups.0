From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] meminfo: show /proc/meminfo base on container's memcg
Date: Thu, 31 May 2012 12:32:36 +0400
Message-ID: <4FC72CA4.6080708@parallels.com>
References: <1338260214-21919-1-git-send-email-gaofeng@cn.fujitsu.com> <4FC6B68C.2070703@jp.fujitsu.com> <CAHGf_=pFbsy4FO_UNu6O1-KyTd6O=pkmR8=3EGuZB5Reu3Vb9w@mail.gmail.com> <4FC6BC3E.5010807@jp.fujitsu.com> <alpine.DEB.2.00.1205301737530.25774@chino.kir.corp.google.com> <4FC6C111.2060108@jp.fujitsu.com> <alpine.DEB.2.00.1205301831270.25774@chino.kir.corp.google.com> <4FC6D881.4090706@jp.fujitsu.com> <alpine.DEB.2.00.1205302156090.25774@chino.kir.corp.google.com> <4FC70355.70805@jp.fujitsu.com> <alpine.DEB.2.00.1205302314190.25774@chino.kir.corp.google.com> <4FC70E5E.1010003@gmail.com> <alpine.DEB.2.00.1205302325500.25774@chino.kir.corp.google.com> <4FC711A5.4090003@gmail.com> <alpine.DEB.2.00.1205302351510.25774@chino.kir.corp.google.com> <CAHGf_=qVDVT6VW2j9gE3bQKwizW24iivrDryiCKoxVu4m_fW
 Kw@mail.gmail.com> <alpine.DEB.2.00.1205310028420.8864@chino.kir.corp.google.com> <4FC720EE.3010307@gmail.com> <4FC724B1.70508@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4FC724B1.70508@cn.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, David Rientjes <rientjes@google.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, containers@lists.linux-foundation.org

On 05/31/2012 11:58 AM, Gao feng wrote:
>> >  It's one of a option. But, I seriously doubt fuse can make simpler than kamezawa-san's
>> >  idea. But yeah, I might NACK kamezawa-san's one if he will post ugly patch.
>> >
> It seams I should do some homework to make the implement beautifully.
>
> I think kamezawa-san's idea is more simpler.
> thanks for your advice.
>

One think to keep in mind: A file in memcg does not need to follow the 
same format of /proc/meminfo so we can bind mount. We should be able to 
reconstruct that in userspace based on information available from the 
kernel. You can even collect that from multiple locations, and *then* 
you bind mount.

It helps to keep the churn out of the kernel, and in case of meminfo, 
you might need no extra kernel patches at all. And in the case of other 
files like /proc/stat, the relevant information comes from more than one 
cgroup anyway, so there is not too much way around it.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
