From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: don't initialize kmem-cache destroying work for
 root caches
Date: Wed, 22 May 2013 15:50:24 +0800
Message-ID: <519C78C0.3050204@huawei.com>
References: <1368535118-27369-1-git-send-email-avagin@openvz.org> <20130514160859.GC5055@dhcp22.suse.cz> <20130522074055.GA16207@paralelels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130522074055.GA16207-yYYamFZzV1regbzhZkK2zA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On 2013/5/22 15:40, Andrew Vagin wrote:
> On Tue, May 14, 2013 at 06:08:59PM +0200, Michal Hocko wrote:
>>
>> Forgot to add
>> Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>> +
>> Cc: stable # 3.9
>>
>> Thanks
> 
> Who usually picks up such patches?

The famous AKPM.
